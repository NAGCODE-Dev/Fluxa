# UI Screen Blueprints

## Convenção
Cada blueprint define:
- pergunta que a tela responde
- estrutura obrigatória
- ações primárias
- estados necessários

## Splash
- pergunta: `o app está iniciando corretamente?`
- blocos:
  - marca
  - mensagem curta
  - indicador de carregamento

## Onboarding
- pergunta: `como o produto funciona e por onde começar?`
- blocos:
  - proposta de valor
  - benefícios principais
  - CTA criar conta
  - CTA entrar

## Boas-vindas e personalização leve
- pergunta: `como começo de forma confortável e sem expor dados pessoais?`
- blocos:
  - saudação curta
  - campo opcional de nome de exibição
  - escolha rápida de aparência
  - explicação de privacidade em linguagem humana
  - CTA continuar localmente
  - CTA sincronizar com Google
- estados:
  - default
  - loading
  - error

## Login
- pergunta: `como acesso minha conta rapidamente?`
- blocos:
  - campo email
  - campo senha
  - CTA entrar com Google
  - CTA entrar
  - CTA criar conta
  - CTA recuperar acesso

## Cadastro
- blocos:
  - nome
  - email
  - senha
  - aceite
  - CTA criar conta

## Dashboard
- pergunta: `como está minha vida financeira agora?`
- blocos:
  - saldo atual
  - resumo receitas/despesas
  - economia do mês
  - meta principal
  - limite dos cartões
  - próximos eventos
  - acesso rápido adicionar movimentação
- estados:
  - loading
  - empty
  - error
  - offline
  - syncing

## Adicionar Gasto
- pergunta: `como registrar uma despesa no menor tempo possível?`
- blocos:
  - valor
  - categoria
  - origem
  - data
  - descrição opcional
  - CTA salvar

## Adicionar Receita
- mesmo padrão de gasto com rótulos adaptados

## Editar Movimentação
- blocos:
  - dados já preenchidos
  - editar
  - excluir
  - duplicar

## Histórico
- pergunta: `para onde meu dinheiro foi?`
- blocos:
  - busca
  - filtro rápido
  - intervalo
  - agrupamento
  - lista de movimentações

## Filtros
- blocos:
  - período
  - tipo
  - categorias
  - contas
  - cartões
  - CTA aplicar

## Categorias
- blocos:
  - categorias padrão
  - categorias personalizadas
  - CTA nova categoria

## Contas
- pergunta: `onde meu dinheiro está armazenado?`
- blocos:
  - lista de contas
  - saldo por conta
  - CTA nova conta

## Cartões
- pergunta: `qual meu uso de crédito hoje?`
- blocos:
  - visão consolidada
  - lista de cartões
  - CTA novo cartão

## Detalhes do Cartão
- blocos:
  - nome e banco
  - limite total
  - utilizado
  - disponível
  - fechamento
  - vencimento
  - acesso à fatura

## Fatura
- blocos:
  - valor atual
  - lista de compras
  - data de fechamento
  - data de vencimento

## Metas
- pergunta: `o que estou construindo com meu dinheiro?`
- blocos:
  - metas ativas
  - progresso
  - tempo estimado
  - CTA nova meta

## Planejamento
- blocos:
  - metas
  - orçamento
  - previsão
  - modo “E se?”

## Calendário Financeiro
- blocos:
  - visão mensal
  - vencimentos
  - fechamentos
  - cobranças de assinatura

## Assinaturas
- blocos:
  - lista recorrente
  - valor mensal/anual
  - próxima cobrança
  - CTA revisar

## Orçamento Mensal
- blocos:
  - orçamento por categoria
  - consumido
  - restante
  - alertas

## Previsão Financeira
- blocos:
  - saldo previsto 30 dias
  - eventos considerados
  - cenários comparáveis

## Saúde Financeira
- blocos:
  - leitura resumida
  - principais riscos
  - principais oportunidades

## Perfil
- blocos:
  - dados da conta
  - preferências
  - plano atual

## Configurações
- blocos:
  - conta
  - aparência
  - notificações
  - segurança
  - integrações

## Premium
- blocos:
  - proposta premium
  - comparação free vs premium
  - CTA assinar

## Integração WhatsApp
- pergunta: `como registrar pelo WhatsApp sem abrir o app?`
- blocos:
  - explicação
  - exemplos válidos
  - status da integração
  - histórico de entradas
  - mensagens ambíguas

## Biblioteca Financeira
- blocos:
  - navegação por temas
  - artigos educativos
  - atalhos para simuladores

## Simulador
- blocos:
  - valor inicial
  - aporte
  - prazo
  - taxa
  - resultado
  - fórmula
  - fonte

## Indicadores Econômicos
- blocos:
  - selic
  - cdi
  - ipca
  - data e fonte

## Ajuda
- blocos:
  - FAQ
  - contato
  - guias

## Sobre
- blocos:
  - visão do produto
  - versão
  - termos

## Notificações
- blocos:
  - lista de alertas
  - filtros por tipo
  - marcar como lida

## Desktop Companion

### Dashboard Analítico
- pergunta: `quais padrões e desvios importam agora?`
- blocos:
  - KPIs principais
  - tendências
  - comparação por período
  - alertas

### Relatórios
- blocos:
  - filtros
  - resumo
  - exportação

### Planejamento Desktop
- blocos:
  - metas
  - orçamento
  - cenários lado a lado

### Calendário Desktop
- blocos:
  - calendário expandido
  - agenda lateral

### Comparativos
- blocos:
  - categorias
  - meses
  - contas
  - cartões

### Gráficos
- blocos:
  - linha temporal
  - barras por categoria
  - distribuição

### Simulações Desktop
- blocos:
  - painel de inputs
  - resultados
  - comparação entre cenários

### Indicadores Desktop
- blocos:
  - indicadores
  - notas metodológicas
  - histórico curto
