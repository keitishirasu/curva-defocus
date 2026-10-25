# Questionário Protocolo Visão 360 v1.2

Entrevista própria sobre rotina visual, objetivos e expectativas antes da definição da indicação de correção visual (LIOs ou outras opções refrativas). Sem pressupor catarata. Não exige nem apresenta resultado do primeiro olho. Inspirada nos domínios de rotina, objetivos, óculos e expectativas da ficha CLUB enviada pelo usuário, com redação e organização próprias.

## Ajustes

- Detalhismo/perfeccionismo permanece como autodescrição graduada, acompanhada da atividade em que pequenas diferenças visuais importam. Orienta precisão, investigação das expectativas e explicação das limitações; não altera escore nem exclui lente automaticamente.
- Distâncias reais de perto e intermediário, tarefa crítica, direção noturna e pouca luz.
- Tolerância a fenômenos ópticos separada de desejo de independência e de custos. Sem promessa de independência absoluta e sem pergunta que condicione aceitação à disposição para pagar.
- Diabetes e cirurgias anteriores permanecem como história referida; sintomas de superfície acrescentados. Ausência de resposta não significa ausência de doença.
- Restrição alimentar sai da entrevista de escolha da LIO; eventual necessidade permanece na avaliação perioperatória da clínica.
- Sem diagnóstico de personalidade ou saúde mental como filtro automático.
- Exames e elegibilidade são registrados pelo médico, sem preenchimento automático como normal. A ficha não é consentimento nem PROM validado.

## Fluxo e persistência

`index.html` envia apenas identificação do cadastro/exame aberto: nome, nascimento, ID e unidade. Pode vir de seleção autenticada no Datasigh ou de entrada manual; a origem é descrita como cadastro/exame aberto, sem alegar validação remota de cada campo.

O planejador envia identificação e parâmetros pré-operatórios disponíveis do olho a planejar, além das preferências. Não envia medidas ou resultados pós-operatórios do primeiro olho para esta ficha. Campos ausentes ficam em branco. A importação usa contexto de sessão explícito, consumido uma vez; abrir o questionário diretamente não escolhe silenciosamente um paciente anterior.

A ficha salva e reabre respostas por ID no navegador, exporta/restaura JSON e imprime respostas ou uma ficha para preenchimento à mão, mantendo identificação. O botão de perfil inicia o planejamento do primeiro olho com objetivos, distâncias e preferências respondidas; exames não são aprovados a partir das respostas. A ficha original é preservada no JSON do plano.

Não foi criado endpoint nem tabela de banco. Questionários não sincronizam no banco orbeOS nesta versão. A busca de pacientes existente exige autenticação; não introduzimos acesso anônimo a prontuários. Salve o planejamento/exame antes de navegar para outra tela.

## Referência

ESCRS Recommendations for Cataract Surgery, seções sobre seleção para LIOs corretoras da presbiopia e expectativas, consultadas em 25/10/2026: https://www.escrs.org/escrs-recommendations-for-cataract-surgery . A diretriz apoia a investigação de comorbidades, independência de óculos e expectativas realistas. Não valida esta ficha própria nem um escore de candidatura.

## QR Code individual — requisito de integração

A equipe autenticada seleciona a ficha do paciente e gera convite individual. O celular deve abrir um formulário público limitado ao convite, sem login da equipe e sem mostrar prontuário. Token opaco sem nome/ID na URL, prazo e revogação; respostas retornam ao servidor e são vinculadas ao contato e à versão do questionário. Confirmação de envio somente após gravação. O QR é alternativa ao compartilhamento por WhatsApp; nenhum envio a pacientes foi realizado.

ESTADO: requisito definido, ainda não implementado. O formulário estático atual não recebe respostas remotas da equipe/paciente. Não apresentar QR genérico como se tivesse vínculo com a ficha.
