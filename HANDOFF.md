# Curva de Defocus — handoff técnico e operacional

**Atualizado em:** 24/11/2026  
**Escopo desta sessão:** início da auditoria operacional P0, sem alterações em produção.

## Estado verificado

- Repositório público: `keitishirasu/curva-defocus`; branch padrão `main`.
- SHA da aplicação auditada: `e4a09878355c46dc08a581dfe3e63a4a8bf343dd` (25/10/2026), commit “Importar exame por IA na seção de pupila e aberrometria (#10)”.
- O clone não existia na pasta de trabalho selecionada (`work` estava vazia). A tentativa de `git clone https://github.com/keitishirasu/curva-defocus.git` falhou porque o ambiente não resolveu `github.com`. Portanto, não foi possível verificar `origin`, branch, `git status` ou alterações locais por Git. Nenhuma alteração local anterior foi encontrada na pasta selecionada.
- A leitura remota do conteúdo e da árvore do repositório confirmou a presença das páginas, módulos, testes e documentos descritos no handoff anterior. O arquivo `HANDOFF.md` ainda não existia na branch antes desta atualização.
- O último workflow GitHub Actions encontrado é o deploy padrão de GitHub Pages: SUCCESS no SHA acima, em 25/10/2026. O status combinado do commit não lista verificações de CI. Não foi encontrada evidência de workflow próprio que execute a suíte de testes.
- A página pública do catálogo abriu no Chrome. Renderizou 33 registros e avisos de proveniência e limites da evidência. Foi uma inspeção visual pontual do catálogo, não um teste funcional completo do app.

## Auditoria de serviços

### Backend / Datasigh

- Projeto Railway: `considerate-enchantment` (`0bae6f3d-2ccf-4492-b32e-38d2dc2239ef`); ambiente `production`; serviço `orbeOS` (`68f39795-30e2-4028-a193-61ed7809d70b`).
- Railway informa deployment SUCCESS criado em 17/11/2026, commit `2c5cc9e366b3e19c23378dd4c265fa73065d31ef`, branch `main`, sem trabalho pendente no ambiente. A branch `main` do backend e o deployment apontavam para esse mesmo SHA na consulta.
- Domínios associados ao serviço incluem `app.orbeos.com.br` (porta 8080).
- A rota `GET /defocus/pacientes` está presente no commit implantado e no `main`. O código exige Bearer token Supabase válido, restringe a identidade autorizada, exige unidade explícita e busca com no mínimo 3 caracteres, normaliza acentos e formatos de resposta, limita a 20 resultados e responde sem cache. Erros da integração Datasigh oferecem preenchimento manual.
- A existência do código e do deployment não confirma busca autenticada contra o Datasigh. Não foram fornecidas credenciais e nenhum nome/ID de paciente foi consultado.

### Supabase

- Projeto `orbeOS/pedido-exames` (`sdyejhxkrbnxecclqvzq`) respondeu `ACTIVE_HEALTHY`, região `sa-east-1`, PostgreSQL 17.
- A migração `defocus_persistencia_individual_atomica` e as migrações anteriores de tabelas/satisfação constam no histórico remoto.
- As quatro tabelas `defocus_pacientes`, `defocus_exames`, `defocus_pontos` e `defocus_revisoes` existem; todas têm RLS habilitado. A listagem do schema reportou zero registros em cada tabela no momento da consulta. Não foram lidos dados de pacientes.
- Há policy específica por tabela para a identidade clínica autorizada. Não foi encontrado grant de tabela para `anon`. A função `public.defocus_salvar(jsonb)` existe, é SECURITY INVOKER, fixa `search_path` para `public, pg_temp`, não concede execução a `anon` e concede execução a `authenticated`.
- A função implantada valida identidade, campos obrigatórios, os 11 pontos do protocolo, distância positiva, ao menos um valor, unidade do ID Datasigh, revisão concorrente e grava uma linha de revisão por gravação.
- **Achado que exige correção antes da validação operacional da preservação do histórico:** a ACL de `authenticated` em `public.defocus_revisoes` permite SELECT, INSERT, UPDATE, DELETE e TRUNCATE. A policy RLS limita a identidade, mas não impede que essa conta apague ou altere o histórico. Os dados estão vazios no momento; portanto, nenhum registro foi observado em risco de perda nesta consulta. Rever grants e limitar a tabela ao mínimo necessário (a função SECURITY INVOKER ainda precisa de INSERT e o fluxo de histórico precisa de SELECT). Não aplicar mudança de DDL sem revisar grants/policies completos e plano de reversão.
- O advisor do Supabase também reportou avisos gerais do projeto (incluindo proteção de senha vazada desabilitada e função sem search_path fixo); eles não foram atribuídos especificamente ao módulo defocus. Avaliar no contexto do projeto integrado, sem alterar configuração nesta auditoria.

## Testes e validações ainda não executados

Não foram executados `npm ci`, `npm test`, `python research/build-catalogue.py` ou verificações de diff entre arquivos gerados e templates. O clone ausente e a falha de DNS impediram a execução local; o sucesso do deploy Pages não equivale à aprovação dos testes. Também não foram confirmados:

- login real da conta clínica, busca no Datasigh ou formato de resposta em produção;
- gravação, leitura em outro dispositivo, histórico, conflito de revisão ou restauração de exame;
- fluxo real de importação de exame por IA;
- impressão, compartilhamento nativo ou PDF no navegador e Safari/iPhone físico;
- páginas de exame, simulador e questionário por uma validação funcional ponta a ponta.

Não pedir senha clínica no chat. Para os fluxos que exigem sessão, o médico deve autenticar-se no próprio navegador e conferir os dados antes de qualquer gravação clínica.

## Próxima sequência P0

1. Restaurar acesso de rede ao GitHub ou disponibilizar um clone. Antes de sincronizar, confirmar `origin`, branch, `git status` e diff; não descartar nem sobrescrever mudanças locais.
2. Atualizar a branch de trabalho sem rebase destrutivo e confirmar SHA contra `main`.
3. Instalar dependências com `npm ci`; executar `npm test`; registrar saída por suíte.
4. Executar `python research/build-catalogue.py` e verificar se a geração é reproduzível e não deixa diferenças inesperadas.
5. Preparar correção mínima, revisável e reversível das permissões de `defocus_revisoes`; validar efeitos em autenticação e RPC antes de qualquer aplicação ao banco.
6. Inspecionar endpoint e deployment atuais com sessão adequada; validar Datasigh com busca sintética ou termo previamente autorizado, sem expor dados pessoais no relatório.
7. Com o médico autenticado, validar gravação e recuperação ponta a ponta usando caso sintético, incluindo satisfação zero, 11 pontos, revisão e conflito. Não apagar nem sobrescrever dados clínicos reais.
8. Testar PDF/importação e as páginas restantes; registrar navegador, condições e evidência de cada resultado.
9. Ao concluir, atualizar este handoff com SHA, comandos, resultados e bloqueios remanescentes.

## Regras de continuidade

O app continua sendo ferramenta clínica interna de apoio, não um preditor validado de desempenho individual de LIO. Não inventar curvas comerciais nem converter adição nominal da LIO em curva no plano dos óculos por regra universal. Preservar olho, unidade, condição de correção, origem e precisão; informação ausente não significa zero ou normalidade. Não reaplicar `database/applied-defocus.sql`: é exportação da migração aplicada. Nenhum teste desta sessão alterou o banco ou o Railway.
