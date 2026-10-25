# Planejamento guiado — regras v2.0, 25/10/2026

## Finalidade e limite clínico

Sugestão qualitativa de estratégia e de modelos compatíveis com os objetivos informados, para revisão pelo oftalmologista. Não é um modelo validado de melhor LIO individual, uma calculadora de potência ou um preditor de AV binocular. Não há percentuais de sucesso ou curvas de marca geradas a partir de SA/adição/energia.

A tela principal recebe primeiro/segundo olho, necessidade visual, distâncias de trabalho, tolerância a disfotopsias, aceitação de óculos, pupilas e aberrometria do olho a planejar e avaliação clínica. Sugestões mudam com os dados sem exigir que o usuário escolha previamente marcas ou configure o laboratório óptico.

## Resultado do primeiro olho

No segundo olho, pode-se importar uma curva monocular do app ou informar medidas pontuais reais de longe, intermediário e perto em Snellen (padrão) ou logMAR. Frações 20/x ou 6/x são convertidas internamente por log10(denominador/numerador); o formato original acompanha o plano. Trocar o formato converte os valores válidos sem reinterpretá-los, e planos antigos sem esse campo continuam em logMAR. As medições pontuais têm olho, correção e distâncias de origem próprios. Mudar a distância desejada não reatribui uma AV medida em outra distância. O plano e a análise registram a origem manual ou importada.

A comparação com o corte editável classifica cada foco como atendido, lacuna ou desconhecido. Uma lacuna de medida não significa visão normal; interpolações permanecem limitadas a segmentos observados de até 0,50 D. Não se calcula melhor olho, média monocular ou soma binocular como se fossem visão prevista.

É necessário registrar revisão/estabilidade do primeiro olho e qualidade percebida. Instabilidade ou queixa explicitamente não resolvida produz estado de reavaliação, sem liberação automática de indicação. Baixa AV de longe gera aviso para investigar refração/superfície e causas de perda visual; ela não é tratada como algo que a nova LIO corrige no outro olho. Curvas sem correção conservam seu significado funcional, com aviso sobre possível componente refracional.

## Regras de estratégia

1. Baixa tolerância a halos, prioridade noturna ou sintomas de qualidade no primeiro olho direcionam a discussão para menor divisão de foco. Se a prioridade for noturna e o paciente aceitar óculos, monofocal aprimorada é a classe disponível mais próxima desse objetivo; uma monofocal convencional deve continuar na discussão clínica, embora não esteja cadastrada nesta lista. Caso contrário, EDOF é a estratégia inicial de longe/intermediário, com ressalva de perto.
2. Sem esse conflito de qualidade, lacuna de perto no primeiro olho favorece discutir maior alcance com perto; se o intermediário já está atendido, desenhos com perto com ou sem foco intermediário adicional compartilham o primeiro grupo de discussão; lacuna intermediária favorece EDOF; se os três focos já estão atendidos, não se pressupõe necessidade de mais multifocalidade.
3. Para primeiro olho, prioridade de perto ou independência em todos os focos favorece discutir maior alcance; prioridade intermediária favorece EDOF; prioridade noturna é discutida com menor divisão de foco.
4. Conflito entre perto sem óculos e intolerância/sintomas de qualidade é explicitado. Não existe regra que declare atendimento garantido de ambos.
5. Dentro de uma classe, modelos com referências monoculares corrigidas fornecidas, cobrindo todas as lacunas corrigidas disponíveis, recebem apoio adicional identificado. Referência binocular ou sem correção não entra nessa inferência. Não se extrapolam referências incompletas nem se prediz o resultado individual.
6. Demais empates priorizam fichas com menos pendências técnicas registradas e depois ordem alfabética. Esta é uma ordem de apresentação/documentação, não superioridade clínica de eficácia. A tela informa o empate e permite ver todos os modelos equivalentes.

A classificação por desenho utiliza os grupos/alcances já existentes no catálogo: monofocal aprimorada; EDOF refrativa; full range com perto e intermediário; full range sem intermediário documentado. LENTIS Comfort é tratada à parte como segmentada de baixa adição, e não recebe automaticamente a expectativa de menor disfotopsia da classe EDF. Não se cria um alcance quantitativo específico pela adição nominal ou pela distribuição de energia.

## Pupila e aberrometria

Usam-se os valores de C40/C60, abertura e pupilas para restringir os coeficientes às aberturas medidas, com o acoplamento C60→C40 descrito em SIMULATOR.md. Quando C60 falta, o ajuste permanece pendente até que o médico escolha explicitamente explorar apenas SA primária. A hipótese é mostrada e salva. Não extrapolar para uma pupila maior que a abertura de medida.

C40 corneano negativo em uma pupila analisada gera ressalva ao avaliar LIO com SA nominal negativa confirmada na fonte cadastrada. **Não é contraindicação universal e não é uma soma de coeficientes de planos ou aberturas diferentes.** Não se ajustam automaticamente as adições ou as curvas da marca à pupila e não se minimiza um suposto resíduo corneano+LIO como escore de sucesso. Dados MGZ não confirmados são sinalizados e não sustentam esse alerta como fato confirmado.

HOA RMS, Strehl, MTF, K/Q, coma e trefoil permanecem na avaliação e no laboratório descrito; não há ponto de corte universal criado para excluir marcas. Ausência de dados não se converte em zero ou normalidade. A adequação estrutural da córnea, superfície, mácula, nervo, endotélio, cápsula/zônula e biometria é declarada pelo médico; uma confirmação conjunta é uma ação explícita, nunca valor padrão.

## Estados e decisões

- `collect`: faltam contexto/prioridade/olho ou resultado do primeiro olho; nenhuma marca é sugerida.
- `invalid`: número, lateralidade, identidade ou medidas conflitantes; sem sugestões por marca até corrigir.
- `provisional`: contexto suficiente para estratégia, mas dados de avaliação ainda pendentes; modelos aparecem como sugestão provisória.
- `review`: alteração clínica, primeiro olho ainda não revisado/estabilizado ou queixa explicitamente não resolvida; opções aparecem para reavaliação, sem indicação automática liberada.
- `ready`: dados de contexto definidos e avaliação registrada; sugestão por objetivos, ainda dependente da confirmação clínica e da evidência específica da LIO.

O médico pode excluir qualquer modelo com justificativa, desfazer a exclusão e comparar duas fichas em detalhe. Exclusão e regras/resultado são preservados no JSON/plano local. Troca de modo gera identidade nova de plano e elimina referências/decisões do contexto anterior; troca de olho limpa exames e avaliação do olho a planejar. Planos anteriores permanecem no histórico. Planos v1 são abertos com modo segundo olho quando contêm um primeiro olho importado; não são sobrescritos em lote.

## Referências e força da evidência

- ESCRS Recommendations for Cataract Surgery, seções 4.1.6 e 4.2.7: https://www.escrs.org/escrs-recommendations-for-cataract-surgery . Diretriz com metodologia GRADE; seleção por comorbidades, expectativas e independência, alcance de multifocais, menor disfotopsia de EDF em relação a multifocais e necessidade de discutir compromissos. Muitas recomendações pertinentes têm baixa certeza (GRADE +). Não valida uma ordenação entre os 33 modelos.
- Nochez et al., 2010, DOI 10.1136/bjo.2009.167775, PMID 19833613. RCT pequeno (43 olhos) de individualização da asfericidade, com ganho de contraste mesópico e similaridade de BCVA. Não valida este motor ou extrapolação a todas as LIOs modernas.
- Tan et al., 2019, DOI 10.1186/s12886-019-1162-6, PMID 31319806. Estudo prospectivo não randomizado (84/78 pacientes); menor aberração no grupo personalizado, sem diferença consistente de AV, OSI, MTF cut-off ou Strehl. Justifica não usar “SA residual zero” como regra suficiente para a melhor lente.
- Fontes de fabricante, IOLCon, bancada e estudos específicos permanecem no catálogo. Grau de evidência e pendências acompanham os modelos.

As regras de objetivos/lacunas são uma **inferência de apoio à decisão implementada no app**, não um protocolo de recomendação de marcas validado por RCT ou endossado pela ESCRS.

## Testes

`npm test` inclui nova suíte de estratégias primeiro/segundo olho, sintomas, conflitos, estados desconhecidos, pupila/SA, origem/distância/lateralidade das medidas, exclusão e restauração de planos. A interface foi conferida no navegador com dados fictícios. O laboratório óptico v1 permanece independente e não alimenta a recomendação por marca.
