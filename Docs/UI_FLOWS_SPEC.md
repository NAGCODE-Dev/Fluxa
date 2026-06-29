# UI Flows Spec

## Regras
- todo fluxo precisa começo, meio e confirmação
- todo fluxo crítico precisa estado offline e erro
- cada passo precisa CTA principal clara

## Fluxos Obrigatórios

### Primeiro acesso
1. Splash
2. Onboarding
3. Login ou Cadastro
4. Dashboard vazio guiado

### Criar conta
1. Cadastro
2. Confirmação
3. Preferências iniciais
4. Dashboard

### Adicionar cartão
1. Cartões
2. Novo cartão
3. Confirmação
4. Detalhes do cartão

### Registrar gasto
1. Dashboard ou FAB
2. Adicionar gasto
3. Confirmação
4. Histórico atualizado

### Criar meta
1. Metas
2. Nova meta
3. Confirmação
4. Planejamento

### Cancelar assinatura
1. Assinaturas
2. Detalhe da assinatura
3. Ação cancelar
4. Confirmação

### Editar orçamento
1. Orçamento mensal
2. Editar categoria
3. Salvar
4. Estado atualizado

### Enviar gasto pelo WhatsApp
1. Usuário envia mensagem
2. Tela Integração WhatsApp mostra entrada
3. Parser confirma ou pede revisão
4. Histórico é atualizado

### Sincronização offline
1. Estado offline visível
2. Usuário continua lançando
3. Fila local sinalizada
4. Estado syncing quando rede volta
5. Confirmação de sync

### Sincronização online
1. Alteração local
2. Indicador discreto de sincronização
3. Estado concluído

### Compra premium
1. Tela Premium
2. Comparativo de plano
3. Checkout
4. Confirmação
5. Perfil com plano atualizado

## Dependências de UI
- `Dashboard` depende de cards resumo, atalhos e alertas
- `Histórico` depende de busca, chips e rows de transação
- `Planejamento` depende de goal cards, budget bars e blocos comparativos
- `Desktop` depende de tabelas, painéis analíticos e gráficos
