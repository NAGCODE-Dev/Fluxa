# Component Guide

## Objetivo
Definir como cada componente deve ser usado antes da implementação.

Este documento existe para que código, UI demo e futuras telas usem a mesma linguagem de interface.

## Estrutura de Leitura
Cada componente documenta:
- nome
- quando usar
- quando não usar
- exemplo
- estados
- variantes
- responsividade
- acessibilidade

---

## PrimaryButton

### Quando usar
- ação principal da tela
- confirmação de criação, salvamento ou continuação

### Quando não usar
- ações destrutivas secundárias
- navegação pouco prioritária

### Exemplo
- `Salvar movimentação`
- `Criar conta`

### Estados
- default
- hover
- pressed
- focus
- disabled
- loading

### Variantes
- light
- dark
- full width
- inline

### Responsividade
- full width no mobile quando for CTA principal
- pode ser inline em desktop e modais

### Acessibilidade
- contraste AA
- label sempre explícita
- área mínima de toque confortável

---

## SecondaryButton

### Quando usar
- ação secundária clara, mas não dominante

### Quando não usar
- CTA principal

### Exemplo
- `Parcelar`
- `Tentar novamente`

### Estados
- default
- hover
- pressed
- focus
- disabled

### Variantes
- light
- dark
- outline

### Responsividade
- pode compartilhar linha com primary em telas largas

### Acessibilidade
- nunca depender só da borda para ser percebido

---

## FAB

### Quando usar
- atalho primário persistente para adicionar movimentação

### Quando não usar
- múltiplas ações concorrentes
- páginas de onboarding ou autenticação

### Exemplo
- `+` para abrir registrar gasto/receita/transferência

### Estados
- default
- pressed
- hidden on scroll context

### Variantes
- expanded
- compact
- light
- dark

### Responsividade
- fixo no mobile
- opcional no tablet

### Acessibilidade
- label acessível mesmo se visualmente compacta

---

## TextField

### Quando usar
- entradas textuais gerais

### Quando não usar
- valor monetário
- seleção fechada

### Exemplo
- descrição
- nome da conta

### Estados
- default
- focus
- filled
- error
- disabled

### Variantes
- single line
- multiline
- light
- dark

### Responsividade
- largura fluida

### Acessibilidade
- label persistente
- mensagem de erro associada

---

## AmountField

### Quando usar
- valor de despesa, receita, meta, orçamento

### Quando não usar
- texto livre

### Exemplo
- `R$ 120,00`

### Estados
- default
- active
- filled
- error

### Variantes
- compact
- hero
- light
- dark

### Responsividade
- destaque máximo no mobile

### Acessibilidade
- moeda sempre visível
- leitura numérica clara

---

## SearchField

### Quando usar
- histórico
- categorias
- assinaturas

### Quando não usar
- formulários de cadastro

### Exemplo
- `Buscar mercado, uber, salário...`

### Estados
- default
- focus
- typing
- clearable

### Variantes
- light
- dark
- sticky top

### Responsividade
- ocupa topo da área filtrável

### Acessibilidade
- ícone não substitui label semântica

---

## Chip

### Quando usar
- filtros rápidos
- status curtos
- tags de contexto

### Quando não usar
- navegação principal

### Exemplo
- `Mês`
- `Mercado`
- `Offline`

### Estados
- default
- active
- pressed
- disabled

### Variantes
- neutral
- primary
- secondary
- danger

### Responsividade
- quebra de linha controlada

### Acessibilidade
- área clicável suficiente
- estado ativo claro além de cor

---

## MetricCard

### Quando usar
- KPIs resumidos no dashboard e desktop

### Quando não usar
- listas detalhadas

### Exemplo
- saldo projetado
- orçamento consumido

### Estados
- default
- loading
- empty
- warning

### Variantes
- light
- dark
- positive
- negative

### Responsividade
- 2 colunas no mobile
- grid amplo no desktop

### Acessibilidade
- hierarquia clara entre título, valor e contexto

---

## CreditCardSummary

### Quando usar
- dashboard
- lista de cartões
- detalhe do cartão
- cabeçalho de fatura

### Quando não usar
- histórico detalhado linha a linha

### Exemplo
- `Nubank • Crédito • final 2841`
- `Santander • Gold • final 0912`

### Estados
- default
- selected
- warning
- loading

### Variantes
- full card
- compact
- stack
- light
- dark

### Responsividade
- no dashboard mobile usar destaque para um cartão principal
- em listas usar versão compacta

### Acessibilidade
- final mascarado sempre legível
- contraste suficiente entre fundo e texto

### Observação
- o visual deve usar skins fictícios definidos em `CARD_SKINS.md`
- nunca usar reprodução exata de cartão real

---

## TransactionRow

### Quando usar
- histórico
- fatura
- lista de movimentações

### Quando não usar
- resumo analítico

### Exemplo
- `Mercado Extra — R$ 186,40`

### Estados
- default
- highlighted
- syncing
- erro de envio

### Variantes
- income
- expense
- transfer
- card statement

### Responsividade
- colapsa metadados, nunca o valor

### Acessibilidade
- valor, tipo e origem legíveis sem cor

---

## GoalCard

### Quando usar
- metas
- planejamento

### Quando não usar
- indicadores econômicos

### Exemplo
- `Notebook`
- `Viagem`

### Estados
- active
- paused
- completed

### Variantes
- compact
- detailed
- light
- dark

### Responsividade
- stack vertical no mobile

### Acessibilidade
- progresso com texto e barra

---

## BudgetBar

### Quando usar
- orçamento por categoria

### Quando não usar
- KPI principal isolado

### Exemplo
- `Mercado — R$ 612 de R$ 800`

### Estados
- safe
- warning
- exceeded

### Variantes
- inline
- card-contained

### Responsividade
- largura total no mobile

### Acessibilidade
- nunca depender só da cor da barra

---

## Snackbar

### Quando usar
- confirmação curta e não bloqueante

### Quando não usar
- erro crítico
- decisão importante

### Exemplo
- `Movimentação salva`

### Estados
- success
- warning
- error

### Variantes
- with action
- passive

### Responsividade
- flutuante no mobile
- alinhado ao canto no desktop

### Acessibilidade
- tempo suficiente para leitura

---

## Dialog

### Quando usar
- confirmação destrutiva
- decisão irreversível

### Quando não usar
- simples edição de formulário

### Exemplo
- excluir movimentação
- cancelar assinatura

### Estados
- default
- danger

### Variantes
- confirm
- destructive

### Responsividade
- modal no desktop
- sheet no mobile quando fizer mais sentido

### Acessibilidade
- foco preso
- ordem de leitura correta

---

## BottomSheet

### Quando usar
- ações contextuais
- seleção rápida
- filtros

### Quando não usar
- conteúdo extenso de leitura

### Exemplo
- escolher tipo de movimentação
- aplicar filtros

### Estados
- collapsed
- expanded

### Variantes
- action list
- filter sheet
- form sheet

### Responsividade
- mobile-first

### Acessibilidade
- handle visual não substitui título

---

## EmptyState

### Quando usar
- ausência total de conteúdo

### Quando não usar
- loading

### Exemplo
- nenhum gasto registrado
- nenhuma meta criada

### Estados
- informational
- guided

### Variantes
- with CTA
- without CTA

### Responsividade
- centralizado e respirado

### Acessibilidade
- texto objetivo
- CTA claro

---

## ErrorState

### Quando usar
- falha de carregamento ou envio

### Quando não usar
- alerta leve

### Exemplo
- erro ao carregar histórico

### Estados
- retryable
- blocked

### Variantes
- inline
- page-level

### Responsividade
- manter ação de recuperação visível

### Acessibilidade
- explicar problema e próximo passo

---

## OfflineState

### Quando usar
- ausência de conectividade com continuidade local

### Quando não usar
- erro genérico

### Exemplo
- offline, mas registrando localmente

### Estados
- passive
- syncing-queued

### Variantes
- banner
- page-level

### Responsividade
- discreto no topo

### Acessibilidade
- deixar claro que o app continua funcional
