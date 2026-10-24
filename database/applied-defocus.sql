-- Exportação da migração aplicada no Supabase; não reaplicar automaticamente.

alter table public.defocus_pacientes add column if not exists unidade text;
alter table public.defocus_exames add column if not exists client_payload jsonb;
alter table public.defocus_exames add column if not exists revision integer not null default 1;
create table if not exists public.defocus_revisoes (
 exame_id uuid not null references public.defocus_exames(id),
 revision integer not null,
 payload jsonb not null,
 autor_id uuid not null,
 created_at timestamptz not null default now(),
 primary key(exame_id,revision)
);
alter table public.defocus_revisoes enable row level security;
revoke all on public.defocus_pacientes, public.defocus_exames, public.defocus_pontos,public.defocus_revisoes from anon;
grant select,insert,update on public.defocus_pacientes,public.defocus_exames to authenticated;
grant select,insert,update,delete on public.defocus_pontos to authenticated;
grant select,insert on public.defocus_revisoes to authenticated;
create policy defocus_keiti_pacientes on public.defocus_pacientes for all to authenticated using ((select auth.uid())='47fe09e0-0d06-40fe-bb81-aa4c12cf421d'::uuid) with check ((select auth.uid())='47fe09e0-0d06-40fe-bb81-aa4c12cf421d'::uuid);
create policy defocus_keiti_exames on public.defocus_exames for all to authenticated using ((select auth.uid())='47fe09e0-0d06-40fe-bb81-aa4c12cf421d'::uuid) with check ((select auth.uid())='47fe09e0-0d06-40fe-bb81-aa4c12cf421d'::uuid);
create policy defocus_keiti_pontos on public.defocus_pontos for all to authenticated using ((select auth.uid())='47fe09e0-0d06-40fe-bb81-aa4c12cf421d'::uuid) with check ((select auth.uid())='47fe09e0-0d06-40fe-bb81-aa4c12cf421d'::uuid);
create policy defocus_keiti_revisoes on public.defocus_revisoes for all to authenticated using ((select auth.uid())='47fe09e0-0d06-40fe-bb81-aa4c12cf421d'::uuid) with check ((select auth.uid())='47fe09e0-0d06-40fe-bb81-aa4c12cf421d'::uuid);
create or replace function public.defocus_salvar(p jsonb) returns jsonb
language plpgsql security invoker set search_path=public,pg_temp as $$
declare eid uuid; pid uuid; previous public.defocus_exames; rev integer; pt jsonb; ident text; uni text; n integer;
begin
 if auth.uid() is distinct from '47fe09e0-0d06-40fe-bb81-aa4c12cf421d'::uuid then raise exception 'Acesso não autorizado' using errcode='42501'; end if;
 eid:=(p->>'id')::uuid;
 if eid is null or nullif(trim(p->>'patient'),'') is null or nullif(trim(p->>'lioModel'),'') is null or p->>'mode' not in ('corrigido','sem_correcao') or nullif(p->>'date','') is null then raise exception 'Preencha paciente, data, LIO e condição do exame'; end if;
 if p->>'mode' is null then raise exception 'Informe a condição do exame'; end if;
 if p->'protocol' is distinct from '[1,0.5,0,-0.5,-1,-1.5,-2,-2.5,-3,-3.5,-4]'::jsonb or jsonb_array_length(p->'vals')<>11 then raise exception 'Protocolo inválido'; end if;
 if coalesce((p->>'distance')::numeric,0)<=0 then raise exception 'Distância inválida'; end if;
 select count(*) into n from jsonb_array_elements(p->'vals') v where v<>'null'::jsonb;
 if n=0 then raise exception 'Registre ao menos um ponto'; end if;
 perform pg_advisory_xact_lock(hashtextextended(eid::text,0));
 select * into previous from public.defocus_exames where id=eid for update;
 if found then
   if coalesce((p->>'revision')::integer,0)<>previous.revision then raise exception 'CONFLITO: exame alterado em outro dispositivo. Reabra o histórico antes de corrigir.' using errcode='40001'; end if;
   rev:=previous.revision+1;
 else
   if coalesce((p->>'revision')::integer,0)<>0 then raise exception 'Exame não encontrado'; end if;
   rev:=1;
 end if;
 ident:=nullif(trim(p->>'datasighId'),'');uni:=nullif(p->>'unit','');
 if ident is not null and uni is null then raise exception 'Informe a unidade do ID Datasigh'; end if;
 if ident is not null then
  perform pg_advisory_xact_lock(hashtextextended(uni||':'||ident,1));
  select id into pid from public.defocus_pacientes where unidade=uni and identificador=ident order by created_at limit 1;
 else
  pid:=nullif(p->>'patientUuid','')::uuid;
 end if;
 if pid is null then pid:=gen_random_uuid(); end if;
 insert into public.defocus_pacientes(id,identificador,nome,nascimento,unidade)
 values(pid,ident,p->>'patient',nullif(p->>'birth','')::date,uni)
 on conflict(id) do update set nome=excluded.nome,nascimento=excluded.nascimento;
 p:=p||jsonb_build_object('id',eid,'revision',rev,'patientUuid',pid);
 insert into public.defocus_exames(id,paciente_id,olho,data_exame,data_cirurgia,lio_modelo,lio_potencia,modo,refracao,distancia_optotipo_m,observacoes,satisfacao_0a10,client_payload,revision)
 values(eid,pid,p->>'eye',(p->>'date')::date,nullif(p->>'surgery','')::date,p->>'lioModel',nullif(p->>'power','')::numeric,p->>'mode',p->>'rx',(p->>'distance')::numeric,p->>'notes',nullif(p->>'satisfaction','')::smallint,p,rev)
 on conflict(id) do update set paciente_id=excluded.paciente_id,olho=excluded.olho,data_exame=excluded.data_exame,data_cirurgia=excluded.data_cirurgia,lio_modelo=excluded.lio_modelo,lio_potencia=excluded.lio_potencia,modo=excluded.modo,refracao=excluded.refracao,distancia_optotipo_m=excluded.distancia_optotipo_m,observacoes=excluded.observacoes,satisfacao_0a10=excluded.satisfacao_0a10,client_payload=excluded.client_payload,revision=excluded.revision,updated_at=clock_timestamp();
 delete from public.defocus_pontos where exame_id=eid;
 for n in 0..10 loop
  pt:=p->'vals'->n;
  if pt<>'null'::jsonb then
   insert into public.defocus_pontos(exame_id,defocus_d,snellen_denominador) values(eid,(p->'protocol'->>n)::numeric,(pt#>>'{}')::integer);
  end if;
 end loop;
 insert into public.defocus_revisoes(exame_id,revision,payload,autor_id) values(eid,rev,p,auth.uid());
 return p;
end $$;
revoke all on function public.defocus_salvar(jsonb) from public,anon;
grant execute on function public.defocus_salvar(jsonb) to authenticated;
