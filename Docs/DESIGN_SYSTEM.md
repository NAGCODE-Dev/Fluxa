# DESIGN_SYSTEM.md

## 1. Direção Visual
O produto deve transmitir:
- clareza
- velocidade
- segurança
- confiança
- leveza operacional

Evitar:
- visual infantil
- excesso de cards irrelevantes
- poluição informacional
- jargão financeiro sem explicação

## 2. Temas
Suporte obrigatório a:
- tema claro
- tema escuro

## 3. Cores Base
- cor principal: `#14B8A6`
- cor secundária: `#2563EB`
- erro: `#EF4444`
- aviso: `#F59E0B`

Sugestão neutra:
- fundo claro: `#F8FAFC`
- superfície clara: `#FFFFFF`
- fundo escuro: `#0F172A`
- superfície escura: `#111827`
- texto principal claro: `#0F172A`
- texto principal escuro: `#F8FAFC`

## 4. Tipografia
Priorizar leitura rápida.
Escala sugerida:
- Display: visão de saldo e número principal
- Heading: seções
- Title: cards principais
- Body: conteúdo padrão
- Caption: apoio e contexto

Regras:
- números financeiros com destaque visual consistente
- separação clara entre valor principal e contexto
- nunca esconder unidades ou sinal monetário

## 5. Espaçamento
Sistema base de 4 pontos.
Escala sugerida:
- 4
- 8
- 12
- 16
- 20
- 24
- 32

## 6. Componentes Base
Criar componentes reutilizáveis para:
- AppShell
- TopBar
- BottomNavigation
- PrimaryButton
- SecondaryButton
- IconButton
- AmountField
- TransactionQuickForm
- SummaryCard
- MetricTile
- FilterChip
- EmptyState
- ErrorState
- SuccessToast
- SectionHeader
- AccountCard
- CardLimitCard
- GoalProgressCard
- BudgetProgressBar
- CalendarEventTile
- InsightPanel
- ReportPreviewCard

## 7. Regras de UX
- máximo 3 abas principais
- máximo 2 toques para fluxos comuns
- telas principais sem scroll
- ações primárias sempre evidentes
- feedback visual imediato após cadastro
- valores positivos e negativos claramente diferenciados

## 8. Telas-Chave
### Dashboard
Sem scroll.
Blocos mínimos:
- saldo atual
- despesas e receitas do período
- economia do mês
- limite de cartão
- meta principal
- próximos eventos

### Adicionar Movimentação
Objetivo:
- concluir cadastro em menos de 5 segundos

Campos visíveis primeiro:
- valor
- categoria
- origem

Campos extras devem ficar progressivos.

### Histórico
- filtros rápidos no topo
- busca direta
- agrupamento por dia, semana ou categoria
- leitura fácil de valores e origem

### Planejamento
- metas
- orçamento
- previsão de saldo
- modo “E se?”

## 9. Motion
Animações curtas, funcionais e discretas.
Usar apenas para:
- confirmação de ação
- transição de estados
- mudanças de valor

## 10. Acessibilidade
- contraste adequado
- alvo de toque confortável
- tipografia legível
- ícones sempre com apoio textual quando necessário
- números e status não dependem só de cor
