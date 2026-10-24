# Curva de Defocus — orbeOS

Aplicativo clínico em HTML/CSS/JavaScript, sem dependências externas.
Protocolo: +1,00 a −4,00 D, passo 0,50 D; 14 acuidades Snellen.

## Versão de 24/10/2026
- Identificação Datasigh com unidade, nascimento, cirurgia, potência da LIO, condição corrigida/sem correção e iluminação.
- Login individual pela conta existente do orbeOS. Apenas a identidade autorizada acessa as tabelas defocus por RLS. Frontend contém somente chave publicável.
- Salvamento transacional de paciente, exame e pontos; revisões anteriores preservadas em defocus_revisoes.
- Controle de revisão impede sobrescrita por um dispositivo desatualizado.
- Rascunho local recuperável e cópia local antes de sincronizar; salvamento central confirmado somente após resposta.
- Histórico central (100 exames mais recentes); registros locais antigos preservados. Protocolos sem correspondência comprovada não são remapeados automaticamente.
- Botões distintos de salvar no banco, salvar local, imprimir e gerar arquivo PDF. PDF usa compartilhamento de arquivos quando o navegador oferece suporte, com download como alternativa.
- CSV preserva precisão logMAR; PDF e tabela arredondam somente a apresentação.

## Banco
Projeto Supabase sdyejhxkrbnxecclqvzq.
Migração remota: defocus_persistencia_individual_atomica.
Função SECURITY INVOKER: public.defocus_salvar(p jsonb).
Nenhuma tabela de outro módulo foi alterada.
A identidade autorizada foi conferida no auth.users existente; não há cadastro público neste aplicativo.
Não reutilizar identificador Datasigh entre unidades sem preservar a unidade.

## Validação
Execute: node tests/defocus.test.cjs
Testes de banco executados em transação revertida: inclusão, leitura, 11 pontos, atualização, satisfação zero, revisões, conflito e recusa de outra conta.
PDF sintético extraído e renderizado para conferência A4.
O teste real de login da conta clínica não deve ser realizado com senha compartilhada no chat.

## Pendências
- Busca Datasigh por nome: ainda não integrada. O cliente legado listarPacientes necessita adaptar a assinatura por unidade; produção não foi alterada.
- Verificação no Safari/iPhone físico e compartilhamento nativo do PDF.
- Comparação de LIOs e simulador do segundo olho.
- Histórico paginado para mais de 100 exames e seleção vinculada de paciente manual.
- Confirmação ponta a ponta com a conta do médico no navegador.

Não apagar registros reais nos testes. Dados sintéticos de banco foram revertidos.
