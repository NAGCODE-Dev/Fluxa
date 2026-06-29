# UI Master Spec

## Objetivo
Congelar toda a interface do produto antes de qualquer implementação funcional.

Este documento substitui temporariamente o papel do Figma como especificação visual principal.

## Princípios
- máximo de 3 abas principais no mobile
- máximo de 2 toques para acessar funções comuns
- telas principais sem scroll quando isso for requisito explícito
- tema claro e escuro em toda superfície de produto
- matemática e estados financeiros sempre legíveis
- sem decoração excessiva
- interface construída para uso rápido, não para entretenimento
- a primeira interação deve transmitir conforto, simplicidade e privacidade
- login social deve ser apresentado como sincronização opcional, não exigência de uso
- nenhuma tela deve sugerir armazenamento de dados confidenciais de cartão

## Arquitetura de Navegação

### Mobile
Abas principais:
- `Início`
- `Histórico`
- `Planejamento`

Acessos secundários:
- botão flutuante de adicionar movimentação
- atalhos contextuais no dashboard
- rotas empilhadas para detalhes, edição e configuração

### Desktop Companion
Navegação lateral:
- `Visão Geral`
- `Relatórios`
- `Planejamento`
- `Calendário`
- `Comparativos`
- `Simulações`
- `Indicadores`
- `Configurações`

## Estados Globais Obrigatórios
Todo módulo visual deve prever:
- `default`
- `loading`
- `empty`
- `error`
- `offline`
- `syncing`

## Temas
Toda tela precisa existir em:
- `light`
- `dark`

## Inventário Completo de Telas

### 01. Entrada e Conta
- `Splash`
- `Onboarding`
- `Boas-vindas e personalização leve`
- `Login`
- `Cadastro`
- `Recuperação de acesso`

### 02. Núcleo Mobile
- `Dashboard`
- `Adicionar Gasto`
- `Adicionar Receita`
- `Editar Movimentação`
- `Histórico`
- `Filtros`
- `Categorias`
- `Contas`
- `Cartões`
- `Detalhes do Cartão`
- `Fatura`

### 03. Planejamento
- `Metas`
- `Planejamento`
- `Calendário Financeiro`
- `Assinaturas`
- `Orçamento Mensal`
- `Previsão Financeira`
- `Saúde Financeira`
- `Simulador`
- `Indicadores Econômicos`
- `Biblioteca Financeira`

### 04. Conta e Sistema
- `Perfil`
- `Configurações`
- `Premium`
- `Integração WhatsApp`
- `Ajuda`
- `Sobre`
- `Notificações`

### 05. Desktop Companion
- `Dashboard Analítico`
- `Relatórios`
- `Planejamento Desktop`
- `Calendário Desktop`
- `Comparativos`
- `Gráficos`
- `Simulações Desktop`
- `Indicadores Desktop`

## Regras de Layout por Área

### Dashboard
Deve caber no primeiro viewport mobile sem scroll crítico.

Blocos obrigatórios:
- saldo atual
- receitas e despesas do período
- economia do mês
- meta principal
- limite de cartão
- próximos eventos
- atalho rápido para registrar movimentação

### Histórico
Topo fixo com:
- campo de busca
- filtro rápido
- recorte temporal

Corpo:
- agrupamento por data
- valor destacado
- origem e categoria visíveis

### Planejamento
Deve consolidar:
- metas
- orçamento
- previsão
- modo “E se?”
- calendário

### Cartões
Deve separar claramente:
- visão consolidada
- detalhe do cartão
- fatura atual
- vencimento e fechamento

Regra adicional:
- identidade visual do cartão pode remeter ao banco, mas nunca exibir dados reais confidenciais

### Boas-vindas e personalização leve
Deve explicar em poucos segundos:
- que o app pode ser usado sem expor dados pessoais
- que nome e aparência são opcionais
- que login com Google existe para sincronizar dados entre aparelhos
- que os cartões mostrados são apenas representações visuais

### WhatsApp
Tela específica para:
- explicar o formato de uso
- mostrar exemplos válidos
- listar últimas entradas recebidas
- exibir pendências ambíguas

## Comportamentos Obrigatórios
- movimentação rápida em menos de 5 segundos
- campos extras progressivos
- confirmações discretas e imediatas
- erros sempre explicados com ação corretiva
- estados offline sempre visíveis
- sincronização nunca bloqueia a interface principal

## Saída Esperada para Implementação
Toda implementação futura deve seguir:
- o inventário completo de telas deste documento
- o design system definido em `UI_SYSTEM_SPEC.md`
- os blueprints de tela definidos em `UI_SCREEN_BLUEPRINTS.md`
- os fluxos definidos em `UI_FLOWS_SPEC.md`
