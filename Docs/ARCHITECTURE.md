# ARCHITECTURE.md

## 1. Stack
- Flutter no frontend
- Supabase no backend gerenciado
- PostgreSQL como banco principal
- Supabase Auth para autenticação
- Firebase para notificações push
- Meta WhatsApp Business API para registro conversacional
- Figma para design e protótipos

## 2. Princípios Técnicos
- Feature First Architecture
- Offline First
- Mobile First
- separação clara entre data, domain e presentation
- dependências entre features proibidas sem abstração compartilhada
- cálculos financeiros sempre em lógica programada
- IA como apoio, nunca como motor financeiro

## 3. Estrutura do App Flutter
```text
lib/
  core/
  shared/
  features/
    auth/
    dashboard/
    accounts/
    cards/
    transactions/
    categories/
    goals/
    budgets/
    subscriptions/
    calendar/
    reports/
    projections/
    whatsapp/
    premium/
    library/
```

## 4. Estrutura Interna por Feature
```text
feature_name/
  data/
    datasources/
    models/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    controllers/
    pages/
    widgets/
```

## 5. Camadas Compartilhadas
### core/
Responsável por:
- configuração do app
- temas
- navegação
- services globais
- auth guards
- sync orchestration
- observabilidade

### shared/
Responsável por:
- design system
- utilitários
- formatadores
- componentes reutilizáveis
- tipos compartilhados

## 6. Navegação
Máximo de 3 abas principais.
Sugestão:
- Início
- Histórico
- Planejamento

Acesso secundário por ações rápidas e folhas modais:
- adicionar movimentação
- contas e cartões
- metas
- configurações

## 7. Offline First
Ordem de verdade operacional:
```text
UI -> Local DB -> Sync Queue -> Supabase
```

Regras:
- toda ação do usuário grava primeiro localmente
- toda mutação entra em fila de sincronização
- conflitos devem ser auditáveis
- app precisa funcionar sem internet para os fluxos principais

## 8. Sincronização
### Estratégia
- operações locais recebem `localId`
- fila com retries exponenciais
- deduplicação por `clientMutationId`
- servidor responde com estado reconciliado

### Tipos de sync
- create
- update
- delete lógico
- recomputação de agregados

## 9. Arquitetura de Dados
- PostgreSQL com RLS no Supabase
- cada usuário só acessa seus dados
- eventos financeiros importantes devem ter trilha de auditoria
- cálculos agregados podem ser materializados para performance

## 10. WhatsApp Ingestion
Pipeline:
```text
Webhook Meta -> Parser Tradicional -> Classificador -> Persistência -> Sync -> UI
```

Prioridade técnica:
1. regex
2. dicionários de categorias/contas/cartões
3. regras contextuais
4. fallback IA

## 11. IA
IA pode existir como serviço desacoplado.

Casos de uso:
- interpretação textual ambígua
- explicação de relatórios
- consultor financeiro textual

Casos proibidos:
- cálculo de saldo
- cálculo de juros oficiais
- cálculo de orçamento
- cálculo de previsão
- decisão automática de alocação financeira

## 12. Observabilidade
Implementar:
- logs estruturados
- métricas de sync
- métricas de performance por tela
- auditoria de eventos sensíveis
- rastreio de falhas de parser do WhatsApp

## 13. Segurança
- Supabase Auth
- RLS em todas as tabelas de usuário
- criptografia para dados sensíveis não financeiros
- tokens seguros em device storage apropriado
- logs sem dados sigilosos

## 14. Estratégia de Implementação
Ordem sugerida:
1. estrutura Flutter
2. banco local
3. Supabase
4. autenticação
5. contas
6. cartões
7. transações
8. dashboard
9. histórico
10. metas
11. orçamento
12. calendário
13. projeções
14. sync offline
15. desktop companion
16. WhatsApp
17. IA
18. biblioteca financeira
