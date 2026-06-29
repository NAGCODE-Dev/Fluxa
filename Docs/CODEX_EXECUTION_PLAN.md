# CODEX_EXECUTION_PLAN.md

## Objetivo
Usar um agente de código para construir o produto em etapas pequenas, verificáveis e alinhadas aos documentos da pasta `Docs/`.

## Regra Principal
Nunca pedir:
- faça o app inteiro

Sempre pedir:
- uma etapa limitada
- com contexto documental explícito
- com critério claro de aceitação
- com validação obrigatória

## Ordem Recomendada para Pedidos
1. Estrutura Flutter base
2. Design tokens e shell de navegação
3. Banco local
4. Supabase base
5. Auth
6. Accounts
7. Cards
8. Transactions
9. Dashboard
10. History
11. Goals
12. Budgets
13. Calendar
14. Projections
15. Offline sync
16. WhatsApp
17. IA auxiliar
18. Biblioteca financeira

## Template de Pedido para Codex
```text
Contexto:
Siga estritamente os documentos em /Docs:
- PRD.md
- ARCHITECTURE.md
- DATABASE.md
- DESIGN_SYSTEM.md
- ROADMAP.md

Tarefa:
[descreva uma etapa única e pequena]

Restrições:
- Não adicionar funcionalidades fora do escopo.
- Seguir arquitetura feature-first.
- Cada feature deve ter data/domain/presentation.
- Não usar IA para cálculos financeiros.
- Priorizar código limpo, testes e validação local.

Entrega esperada:
- código implementado
- testes da etapa
- resumo do que foi feito
- lista do que ainda falta
```

## Prompt 1 — Estrutura Base
```text
Crie a estrutura inicial de um app Flutter seguindo Docs/ARCHITECTURE.md.

Implemente:
- lib/core
- lib/shared
- lib/features
- tema claro/escuro
- navegação base com no máximo 3 abas principais
- estrutura feature-first com data/domain/presentation

Não implemente regras de negócio ainda.
Apenas fundação arquitetural.
Valide que o app compila.
```

## Prompt 2 — Banco Local
```text
Implemente a base offline-first local seguindo Docs/DATABASE.md.

Use Drift/SQLite.
Crie as tabelas locais necessárias para:
- accounts
- cards
- categories
- transactions
- goals
- budgets
- subscriptions
- calendar_events
- sync_queue

Inclua:
- DAOs iniciais
- modelos locais
- migrações iniciais
- testes básicos de persistência
```

## Prompt 3 — Supabase e Auth
```text
Implemente a integração inicial com Supabase e Supabase Auth.

Entregue:
- configuração de ambiente
- serviço de autenticação
- sessão persistida
- sign in
- sign up
- sign out
- recuperação de sessão no boot

Não implemente ainda WhatsApp, IA ou relatórios premium.
```

## Prompt 4 — Accounts
```text
Implemente a feature Accounts seguindo a arquitetura feature-first.

Escopo:
- criar conta
- listar contas
- editar conta
- arquivar conta
- mostrar saldo por conta

Seguir Docs/PRD.md e Docs/DATABASE.md.
Incluir testes e estados de loading/empty/error.
```

## Prompt 5 — Transactions
```text
Implemente a feature Transactions.

Escopo:
- criar despesa
- criar receita
- criar transferência
- edição básica
- listagem por data
- pesquisa rápida
- agrupamento inteligente

Requisito:
registro médio de movimentação em menos de 5 segundos.
```

## Prompt 6 — Dashboard
```text
Implemente a tela Dashboard conforme Docs/PRD.md e Docs/DESIGN_SYSTEM.md.

Requisitos:
- sem scroll
- saldo atual
- receitas
- despesas
- economia do mês
- limite de cartões
- meta principal
- próximos eventos

Use dados reais do estado local.
```

## Prompt 7 — WhatsApp Parser
```text
Implemente a fundação do parser de mensagens financeiras para WhatsApp.

Prioridade:
1. regex
2. dicionários
3. regras
4. fallback IA apenas para mensagens ambíguas

Exemplos a suportar:
- mercado 120
- uber 25
- salario 3500
- ifood 45 credito santander

Não usar IA para cálculos.
```

## Prompt 8 — Biblioteca Financeira
```text
Implemente a fundação da Biblioteca Financeira.

Escopo:
- indicadores econômicos públicos
- tela de comparação de cenários
- simulador matemático auditável
- exibição de fórmula, taxa, data e fonte

Restrições:
- sem recomendação de ativos
- sem integração com corretoras
- sem promessas de rentabilidade
```

## Checkpoint de Qualidade por Etapa
Cada etapa deve encerrar com:
- build passando
- testes da etapa passando
- sem erros críticos
- aderência explícita aos docs
- sem expansão de escopo
