# DATABASE.md

## 1. Princípios
- banco principal em PostgreSQL no Supabase
- isolamento por usuário via RLS
- sem armazenamento de credenciais bancárias
- sem dados sensíveis desnecessários de cartão
- sem armazenamento obrigatório de dados pessoais além do mínimo operacional
- suporte explícito a sincronização offline

## 2. Entidades Principais

### users
Origem: Supabase Auth
Campos principais:
- id
- email
- created_at
- updated_at

### profiles
Campos:
- id
- user_id
- display_name nullable
- currency_code
- locale
- timezone
- theme_preference nullable
- plan_type
- created_at
- updated_at

### accounts
Campos:
- id
- user_id
- name
- type
- initial_balance
- current_balance
- color
- is_archived
- created_at
- updated_at

### cards
Campos:
- id
- user_id
- account_id nullable
- name
- bank_name
- skin_key nullable
- brand nullable
- limit_amount
- closing_day
- due_day
- current_used_amount
- is_archived
- created_at
- updated_at

### categories
Campos:
- id
- user_id nullable para categorias padrão
- name
- kind enum: income | expense | transfer
- icon_key
- color
- is_system
- is_archived
- created_at
- updated_at

### transactions
Campos:
- id
- user_id
- account_id nullable
- card_id nullable
- category_id
- type enum: income | expense | transfer
- amount
- description
- source_label
- transaction_date
- competence_date nullable
- installment_index nullable
- installment_count nullable
- transfer_pair_id nullable
- created_via enum: app | whatsapp | import | sync
- notes nullable
- created_at
- updated_at
- deleted_at nullable

### goals
Campos:
- id
- user_id
- name
- target_amount
- current_amount
- target_date nullable
- linked_account_id nullable
- status enum: active | paused | completed | canceled
- created_at
- updated_at

### budgets
Campos:
- id
- user_id
- category_id
- period_month
- period_year
- budget_amount
- alert_threshold_percent
- created_at
- updated_at

### subscriptions
Campos:
- id
- user_id
- category_id nullable
- account_id nullable
- card_id nullable
- name
- amount
- billing_cycle enum: monthly | yearly | custom
- next_charge_date
- is_active
- detection_source enum: inferred | manual
- created_at
- updated_at

### calendar_events
Campos:
- id
- user_id
- type enum: card_due | card_closing | subscription_charge | goal_target | custom
- reference_id nullable
- title
- description nullable
- event_date
- amount nullable
- created_at
- updated_at

### reports_cache
Campos:
- id
- user_id
- report_type enum: weekly | monthly | yearly
- period_key
- payload_json
- generated_at

### financial_projections
Campos:
- id
- user_id
- projection_type enum: balance_30d | what_if | goal_projection | investment_education
- input_payload
- output_payload
- formula_snapshot
- created_at

### economic_indicators
Campos:
- id
- indicator_code
- indicator_name
- value
- unit
- source_name
- source_url
- reference_date
- captured_at

### whatsapp_messages
Campos:
- id
- user_id
- direction enum: inbound | outbound
- raw_text
- normalized_text
- parser_status enum: parsed | ambiguous | failed
- parsed_payload nullable
- created_at

### audit_logs
Campos:
- id
- user_id
- event_type
- entity_type
- entity_id
- payload_json
- created_at

### sync_queue
Campos:
- id
- user_id
- local_entity_type
- local_entity_id
- operation enum: create | update | delete
- payload_json
- status enum: pending | processing | failed | synced
- retry_count
- last_error nullable
- created_at
- updated_at

## 3. Regras de Modelagem
- `transactions` é a fonte de verdade para histórico financeiro
- transferências devem gerar dois efeitos contábeis ligados por `transfer_pair_id`
- `cards.current_used_amount` deve ser derivado de transações quando possível
- assinaturas podem ser inferidas, mas sempre revisáveis pelo usuário
- projeções armazenam inputs, outputs, fórmula e data da taxa usada

## 4. Índices Recomendados
- transactions por `user_id, transaction_date desc`
- transactions por `user_id, category_id, transaction_date desc`
- budgets por `user_id, period_year, period_month`
- calendar_events por `user_id, event_date`
- sync_queue por `user_id, status, created_at`
- subscriptions por `user_id, next_charge_date`

## 5. Segurança e Compliance
Nunca armazenar:
- senha bancária
- token bancário
- número completo do cartão
- CVV
- CPF
- RG
- endereço residencial
- data de nascimento sem necessidade legal
- telefone como requisito para uso básico

Armazenar no máximo:
- nome do cartão
- banco
- últimos 4 dígitos mascarados quando o usuário quiser identificar visualmente
- skin visual fictícia do cartão

## 6. Observações de Privacidade do Produto
- `profiles` existe para personalização leve, não para perfil pessoal profundo
- `display_name` é opcional e pode ser alterado ou removido sem impactar os dados financeiros
- `cards.skin_key` referencia apenas aparência visual inspirada em bancos, sem copiar um cartão real
- login social serve prioritariamente para sincronização entre dispositivos
- limite
- fechamento
- vencimento

## 6. Cálculos Obrigatoriamente Programados
- saldo consolidado
- limite usado/disponível
- progresso de metas
- orçamento consumido
- projeção de saldo
- comparativos de indicadores
