# ROADMAP.md

## Fase 0 — Congelamento do Produto
Objetivo:
consolidar regras e impedir crescimento caótico de escopo.

Entregáveis:
- PRD.md
- ARCHITECTURE.md
- DATABASE.md
- DESIGN_SYSTEM.md
- wireframes base no Figma

## Fase 1 — Lançamento
Objetivo:
publicar um produto útil e vendável.

Escopo:
- autenticação
- dashboard
- contas
- cartões
- transações
- categorias
- metas
- orçamento mensal
- calendário financeiro
- histórico
- previsão financeira básica
- tema claro/escuro
- sincronização
- offline first

Critério de saída:
- usuário consegue usar o app diariamente sem internet constante
- dados sincronizam corretamente
- principais fluxos são rápidos e confiáveis

## Fase 2 — Premium
Objetivo:
aumentar retenção e monetização com conveniência.

Escopo:
- WhatsApp via Meta API
- relatórios automáticos
- planejamento financeiro
- modo “E se?”
- saúde financeira
- alertas inteligentes

## Fase 3 — Biblioteca Financeira
Objetivo:
adicionar educação financeira e simulação auditável.

Escopo:
- indicadores públicos
- simulador Selic/CDI/IPCA/Poupança/Tesouro
- comparadores
- conteúdos educativos
- projeções integradas a metas

## Ordem de Implementação Técnica
1. Estrutura Flutter
2. Banco local Drift/SQLite
3. Supabase base
4. Supabase Auth
5. Accounts
6. Cards
7. Transactions
8. Dashboard
9. History
10. Goals
11. Budgets
12. Calendar
13. Basic projections
14. Offline sync queue
15. Desktop companion
16. WhatsApp ingestion
17. IA auxiliar
18. Biblioteca financeira

## Como Pedir para um Agente de Código
Nunca pedir:
- “faça o app inteiro”

Sempre pedir em lotes pequenos e verificáveis.

Exemplos:
- “Crie a estrutura Flutter seguindo ARCHITECTURE.md”
- “Implemente a feature Accounts com data/domain/presentation”
- “Implemente o schema local Drift para accounts, cards e transactions”
- “Conecte Supabase Auth e fluxo de sessão”
- “Implemente sync queue offline-first com retries”

## Critério de Congelamento
Depois de finalizada a V1, novas mudanças só entram por:
- bug
- performance
- requisito legal
- dependências
- demanda recorrente validada por usuários
