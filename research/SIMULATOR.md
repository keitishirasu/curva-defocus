# Simulador de planejamento da LIO — v2 (25/10/2026)

O módulo é publicado em `simulador.html`, junto ao app atual. O botão “Planejar segundo olho” envia um snapshot do exame via sessionStorage, na mesma aba. Nenhum exame ou tabela do banco é alterado.

A interface principal v2 oferece modos primeiro/segundo olho e sugestão automática qualitativa por objetivos e lacunas. Regras, estados e limitações em [RECOMMENDATIONS.md](RECOMMENDATIONS.md). O laboratório numérico abaixo continua independente da sugestão por marca.

## Fluxo implementado

- Importar primeiro olho OD/OE, manter condição de correção, distância e iluminação; AO é rejeitado. Mostrar valores reais e alcance contínuo desde 0 D ao corte editável, sem unir lacunas acima de 0,50 D. Se o limite não foi observado, indicar ≥ e a pendência.
- Registrar exames do olho a planejar, pupilas, aparelho, abertura e Zernike com sinal. K/Q são contexto e não geram SA.
- Comparar duas das 33 fichas do catálogo, com proveniência e pendências. Condições clínicas geram ressalvas ou insuficiência de dados. Exclusão é uma decisão médica com motivo; não é uma regra derivada de MTF ou SA isolada.
- Inserir curvas clínicas com fonte, condição e modelo. Mudança de candidata elimina a referência anterior. Referência monocular corrigida pode ser comparada ponto a ponto ao primeiro olho corrigido; curvas binoculares e sem correção ficam identificadas e não entram nessa inferência. Não há curva binocular estimada.
- Laboratório óptico independente com perfis genéricos de um, dois ou três focos. Não são simulações das marcas listadas. Parâmetros, modelo, malha e resultados são incluídos no JSON do plano.
- Salvar planos separados localmente, exportar/restaurar JSON e imprimir/PDF. Cálculos são refeitos na restauração; resultado antigo não é aceito como atual. Não há sincronização orbeOS de planos nesta versão.

## Base matemática e unidades

Convenção OSA/ANSI normalizada em µm, abertura circular concêntrica. Restrição a C40/C60 e coma/trefoil de terceira ordem; ordens omitidas não são inferidas de HOA RMS. Uma opção explícita permite assumir zero para coeficientes não medidos. Pupila simulada entre 2 e 6 mm e nunca maior que a abertura de origem. Para a = D_novo/D_original:

- C40_novo = a^4 C40 + sqrt(35)(a^6 − a^4) C60
- C60_novo = a^6 C60
- C20_induzido = sqrt(15)(a^4 − a^2) C40 + sqrt(21)(3a^6 − 5a^4 + 2a^2) C60

O rebalanceamento remove piston, tilt e defocus induzidos. Depois se aplica o SE/cilindro residual no plano pupilar. Os coeficientes corneanos e os do perfil são somados apenas como **substitutos equivalentes no mesmo plano**; isto não propaga raios entre córnea e LIO e não soma automaticamente uma especificação comercial à medida corneana.

OTF pela autocorrelação da pupila complexa; deslocamento da autocorrelação = lambda(mm) × focal(mm) × frequência(ciclos/mm). Frente de onda de defocus W(µm) = −M(D) r(mm)^2/2; residual miópico −0,75 D posiciona o pico em defocus −0,75 D. Focos ideais usam adições equivalentes nos óculos, sem conversão universal das adições nominais da LIO.

OTF multifocal = soma ponderada das OTFs complexas, normalizada pela energia representada; só então se obtém o módulo. Não é média dos módulos de MTF. A energia restante não é distribuída como espalhamento por hipótese silenciosa. As orientações 0°/90° são promediadas em MTF. MTFa é integral 0–50 ciclos/mm dividida por 50, passo 5 ciclos/mm. Não reproduz todas as métricas do artigo de Alarcon, nem usa a regressão de AV daquele artigo.

Malha inicial 80×80; confronto 128×128 em +1, 0, −1,5, −2,5 e −4 D. Diferença absoluta de MTF50 ou MTFa acima de 0,025 rejeita o cenário. É uma verificação numérica amostral, não prova global de convergência ou validação clínica.

## Referências e limites

- MGZ: https://oftalmoblack.com.br/simuladores/simulador-grau-zero/ — observado por resposta HTTP e HTML público, X-Frame-Options SAMEORIGIN, 25/10/2026. Sua tela descreve curvas digitalizadas e extrapolações didáticas. Não há reprodução de código, imagens ou base digitalizada. Acesso externo no app; iframe incompatível com o cabeçalho atual. Não foi encontrada integração/API pública documentada no material consultado.
- Dai 2006: DOI 10.1364/JOSAA.23.000539. Resumo acessível; texto/equações completos restritos. Fórmulas limitadas acima derivadas independentemente dos polinômios e verificadas por projeção numérica.
- Alarcon et al. 2016: DOI 10.1364/BOE.7.001877; PMC4871088. Texto completo obtido em XML de Europe PMC. Estudo de correlação de bancada/clínica, 243 pacientes, seis modelos AMO de 20 D, bancada a 3 mm; resultados clínicos binoculares médios corrigidos. O estudo declara que previsão média pode não prever desempenho individual. Não sustenta uma conversão universal de MTF50 para logMAR, Snellen ou Jaeger.
- SimVis Gekko: https://www.2eyesvision.com/simvis-gekko/ — referência de experiência comparativa com dispositivo óptico binocular; nenhuma equivalência de validação atribuída a este app.

O catálogo segue com curvas numéricas globais vazias. A próxima camada de simulação por **modelo comercial** exige curvas verificadas, perfis ópticos/phase maps ou dados de bancada suficientes em mais de uma pupila e condições, origem rastreável e validação. Não preencher essa lacuna por ajuste arbitrário usando apenas SA, adição e energia.

## Verificação

`python research/build-catalogue.py` gera catálogo e simulador a partir da mesma base JSON.

Instale a dependência de teste fixada em `package.json` com `npm install` (Node.js 24.15+ LTS ou outra versão compatível com package.json). Depois rode `npm test`, ou individualmente:

- `node tests/defocus.test.cjs`
- `node tests/catalogo.test.cjs`
- `node tests/simulator.test.cjs`

A suíte nova compara C40/C60 e C20 a quadratura independente, OTF ideal à expressão analítica da abertura circular, preservação de fase e normalização de energia, sinal do deslocamento refracional, lacunas e corte de curvas, paciente/olho, referências vinculadas a modelo, restauração e troca de caso sem herdar dados.

QA no navegador: cálculo em Worker, perfil de três focos, importação real pelo botão do exame e lateralidade OE após exame OD. Aparência do gráfico óptico conferida com eixo crescente para cima. Dados de QA são fictícios; nenhum paciente real é necessário para testar.
