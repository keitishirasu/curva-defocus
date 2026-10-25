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
PDF sintético extraído e renderizado para conferência A4. Site publicado testado no Chrome: 11 etapas, LIO manual, satisfação zero, salvamento local e recuperação após recarregar.
O teste real de login da conta clínica não deve ser realizado com senha compartilhada no chat.

## Pendências
- Confirmar com sessão clínica autenticada o filtro nomePaciente e o formato real retornado pelo Datasigh. Busca implementada em rota isolada, com debounce, cancelamento de respostas antigas e preenchimento manual alternativo.
- Verificação no Safari/iPhone físico e compartilhamento nativo do PDF.
- Comparação de LIOs e simulador do segundo olho.
- Histórico paginado para mais de 100 exames e seleção vinculada de paciente manual.
- Confirmação ponta a ponta com a conta do médico no navegador.

Não apagar registros reais nos testes. Dados sintéticos de banco foram revertidos.

## Integração Datasigh / Railway
Produção correta: projeto considerate-enchantment (0bae6f3d-2ccf-4492-b32e-38d2dc2239ef), serviço orbeOS (68f39795-30e2-4028-a193-61ed7809d70b), ambiente 2e342c39-9518-41b8-b7e9-4cddc9d192aa, https://app.orbeos.com.br.
O projeto shimmering-adventure citado no handoff era somente uma criação pendente e não foi alterado.
GET /defocus/pacientes?unit=cianorte|campo_mourao&q=fragmento exige token Supabase validado e conta autorizada.
Backend: keitishirasu/pedido-exames, PR #257. As rotas clínicas anteriores foram preservadas. O filtro de nome é repassado à API; diferenças de acento também dependem do filtro do Datasigh. A lista retornada é normalizada e filtrada antes da apresentação; máximo 20 resultados.
Exportação da migração já aplicada: database/applied-defocus.sql. O SQL documenta o banco, não deve ser reaplicado sem revisão.


## Planejamento guiado da LIO — v2

Disponível em [simulador.html](https://keitishirasu.github.io/curva-defocus/simulador.html). Na tela principal, selecione primeiro/segundo olho, objetivos, tolerância, pupila/aberrometria e avaliação clínica. O app sugere uma estratégia e modelos compatíveis, com justificativas, pendências e compromissos. No segundo olho, usa curva importada pelo botão do exame ou medidas pontuais reais para identificar lacunas. Nenhuma visão binocular é fabricada.

Sugestões são apoio qualitativo à decisão médica, não um modelo clínico validado de melhor marca individual. Empates e dados faltantes são explícitos; ver [research/RECOMMENDATIONS.md](research/RECOMMENDATIONS.md). Comparação detalhada e laboratório óptico genérico ficam disponíveis em áreas próprias.

Planos locais preservam modo, dados, regras/resultado e exclusões justificadas; podem ser exportados/restaurados em JSON e impressos/PDF. Ainda não sincronizam no orbeOS. Trocar modo preserva histórico com um novo plano; trocar olho limpa os exames desse olho.

Validação: Node.js compatível com package.json, `npm ci` e `npm test`. jsdom é apenas dependência de teste. Geração: `python research/build-catalogue.py`, com a mesma base revisada de LIOs para catálogo e simulador. Método óptico e limites em [research/SIMULATOR.md](research/SIMULATOR.md).
