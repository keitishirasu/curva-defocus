# Catálogo de LIOs — referência clínica, versão 1

Revisão: 25/10/2026. Escopo: as 32 entradas das páginas 1–2 do PROTOCOLO MGZ RESUMO.pdf. AcrySof PanOptix e Clareon PanOptix foram separadas, resultando em 33 registros. Não implica disponibilidade nacional, na clínica, ou no poder necessário.

## Entrega

`../catalogo.html` apresenta tabela pesquisável, filtros, comparação de até quatro lentes, exportação CSV/JSON e impressão. A base revisável está em `catalogo-lios.json`; o HTML contém uma cópia autossuficiente para funcionar sem conexão. Regenerar com `python research/build-catalogue.py`.

O único ajuste no exame é um link para abrir o catálogo em outra aba. Não foram alterados dados de pacientes, autenticação, banco, protocolo de 11 etapas ou impressão do exame.

## Limites da revisão

Os campos técnicos foram confrontados com fontes primárias e IOLCon; as fichas indicam o que foi confirmado, divergente ou ainda incompleto. Cada entrada cita suas fontes, mas uma fonte não valida todos os seus campos. As categorias ópticas servem à organização do catálogo; nomenclaturas do MGZ, fabricantes e IOLCon podem divergir. Não existe um selo global de lente validada.

As publicações localizadas sustentam descrições textuais. Não foi feita revisão sistemática exaustiva nem meta-análise, e nem todos os textos completos puderam ser examinados. Fontes de bancada, AV simulada, dados em arquivo e estudos clínicos não são intercambiáveis. Informações extraídas de página indexada ou resumo são identificadas; não se presume acesso ao livro MGZ.

Não há curvas numéricas artificiais. Todos os vetores `curve.points` estão vazios até extração e conferência das figuras/tabelas. A existência de uma publicação com curva não equivale à sua digitalização. A comparação desta versão é uma tabela de características, não uma simulação ou ranking de pacientes.

## Divergências relevantes localizadas

- BIOS: ficha técnica Rev07/2025 informa +1,50 D intermediário; curso informa +1,85 D. A comparação comercial utiliza BIOS binocular aos 90 dias versus PanOptix monocular aos seis meses. Não sustenta superioridade direta.
- EMV: fabricante descreve SA positiva controlada; curso marca neutra.
- LuxSmart: modulação de quarta/sexta ordens; neutralidade isolada não descreve o perfil. Extensão de foco não deve ser convertida em adição nominal.
- Gemetric / Plus e Impress: IOLCon cadastra −0,16 µm; curso usa −0,18 µm. Manter divergência e condição de abertura pendente.
- Comfort MF15: foco adicional de +1,50 D; não equivale a ausência de adição, apesar da classificação comercial EDOF.
- AT ELANA: fabricante informa constante A rotulada 120,2. Curso 119,5 pode corresponder a outra fonte/tipo; não sobrescrever sem esclarecer.
- Optiflex Trio: páginas/revisões do fabricante divergem nas constantes; adições confirmadas +3,50/+1,85 D. Não confundir com Trio Plus.
- Intensity: SL/BN/Toric/HP requerem distinção de plataforma e constante. Não transportar parâmetros entre versões.
- EyeDiff/Plus: geração e informações inconsistentes na página técnica precisam de confirmação.
- Adições do AMF e HYDIFF, curvas pupilares quantitativas e distribuições energéticas de várias lentes ainda têm lacunas.

## Uso posterior no planejamento

Antes da seleção personalizada, capturar o modelo exato, curva real do primeiro olho e condições de exame. Registrar aberrometria com sinal/unidade/apertura/ordem/aparelho e distinguir corneana, interna e total. Não converter T.Sph RMS em C₄⁰ com sinal nem Q diretamente em SA. Não transportar SA entre pupilas com uma regra universal não validada.

As futuras regras devem distinguir: contraindicação explícita da IFU local do modelo; fator relativo de seleção apoiado em evidência; critério de especialista; dado insuficiente. Cada regra precisa de fonte, população, abertura, limiar e possibilidade de revisão médica. A ausência de dados não significa normalidade. Não implementar ranking ou exclusão usando apenas classe óptica, SA, Strehl ou MTF.

## Próxima extração necessária

Para cada curva: modelo e plataforma, estudo, n de pacientes/olhos, tempo pós-operatório, mono/binocular, corrigida/sem correção, refração-alvo, distância do optótipo, luminância/contraste, pupila medida (ou não informada), pontos originais e dispersão, método de extração e conferência. Curvas de bancada precisam de plano pupilar, potência da LIO, modelo corneano, comprimento de onda e frequência espacial.

Somente curvas com condições compatíveis poderão sobrepor-se à curva do primeiro olho. Uma curva binocular publicada não será atribuída ao segundo olho monocular. Pontos ausentes não viram zero nem serão extrapolados até −4 D.

## Verificação de software

Testes preexistentes do exame: `node tests/defocus.test.cjs`.
Integridade do catálogo: `node tests/catalogo.test.cjs`.
Teste DOM: 33 registros, busca, filtro, comparação limitada a quatro e limpeza passaram em ambiente jsdom. Validação visual e navegador real são registradas no PR conforme disponibilidade do ambiente. Safari/iPhone físico permanece verificação independente.
