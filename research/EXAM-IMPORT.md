# Importação de pupila/aberrometria por IA

Botão na seção correspondente do simulador: colar imagem ou anexar PNG/JPEG/WebP/PDF até 4 MB, ler por IA, conferir o exame e selecionar os valores antes de aplicar. A conta é a mesma da busca defocus, via token Supabase validado no backend. Modelo Anthropic no servidor, sem chave no cliente.

A transcrição conserva sinal, olho, unidade, trecho de origem, tipo corneano/ocular, normalização e abertura. Não classifica pupila genérica como fotópica ou mesópica. Coeficientes sem OSA/ANSI e abertura explícitas, ou medidas oculares/internas, não são importados como coeficientes corneanos. Não mistura aberturas ou coeficientes antigos de conjuntos diferentes. Ausência não vira zero. Nenhuma medida é aplicada sem seleção e conferência; troca de identidade ou olho invalida aplicação.

Os valores e o registro da conferência/trechos de origem entram no planejamento salvo/exportado via qualityNotes. O arquivo original fica apenas na memória da tela; não é arquivado no Supabase nesta versão. Recarregar perde o anexo, não os valores que já tenham sido salvos no plano.

Validação: testes do backend de auth/tipo/tamanho/estrutura; testes de elegibilidade e fluxo do frontend com API simulada. Uma leitura de exame real precisa ser conferida com login do usuário, não foi considerada validada apenas pelos testes de contrato.

Documentação primária consultada: https://platform.claude.com/docs/en/build-with-claude/vision e https://platform.claude.com/docs/en/build-with-claude/pdf-support .
