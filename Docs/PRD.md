# PRD — SaaS de Gestão Financeira Pessoal

## 1. Visão do Produto
Construir um SaaS de gestão financeira pessoal focado em simplicidade, velocidade, transparência e experiência do usuário.

O produto deve permitir que uma pessoa sem conhecimento financeiro avançado consiga:
- registrar receitas, despesas e transferências em menos de 5 segundos
- entender seu saldo, gastos, compromissos e metas sem esforço
- planejar o próximo mês com base em dados reais
- tomar decisões melhores com explicações claras, sem jargão excessivo

## 2. Objetivo de Negócio
Entregar um produto suficientemente útil e confiável para ser publicado e vendido como SaaS, com base operacional enxuta e arquitetura escalável.

## 3. Não Objetivos
O produto não deve:
- ser uma corretora
- operar investimentos
- conectar credenciais bancárias sensíveis
- prometer rentabilidade
- depender de IA para cálculos financeiros
- adicionar recursos fora do escopo sem justificativa de negócio
- armazenar dados pessoais desnecessários
- armazenar dados confidenciais de cartão ou banco

## 4. Princípios do Produto
### Simplicidade
O usuário deve conseguir utilizar o sistema sem treinamento.

### Transparência
Todo cálculo relevante precisa ter explicação acessível.

### Privacidade por padrão
O produto deve funcionar com o mínimo possível de informação pessoal.
Nome exibido, aparência e preferências são opcionais e tratados como personalização leve, não como identidade sensível.

### Sincronização sem invasão
Login com Google pode existir para sincronizar dados entre aparelhos, não para enriquecer perfil pessoal.
Sem login, o app continua utilizável localmente.

### Velocidade
Registrar uma movimentação deve levar menos de 5 segundos.

### Baixo custo operacional
A lógica deve ser majoritariamente programada.
Meta técnica:
- 80% programação tradicional
- 20% IA

### Escalabilidade
Cada módulo deve poder evoluir independentemente, com contratos e serviços compartilhados.

## 5. Público-Alvo
- jovens
- universitários
- trabalhadores CLT
- autônomos
- pessoas sem conhecimento financeiro avançado

## 6. Plataformas
### Frontend
- Flutter

### Backend
- Supabase
- PostgreSQL

### Autenticação
- Supabase Auth

### Notificações
- Firebase

### Integração WhatsApp
- Meta WhatsApp Business API

### Design
- Figma

## 7. Proposta de Valor
O produto combina:
- registro rápido
- controle financeiro pessoal real
- cartões e contas em um só lugar
- planejamento e previsão
- WhatsApp como entrada opcional de dados
- sincronização opcional entre dispositivos sem exigir coleta de dados pessoais além do necessário

## 7.1. Regra de Dados do Usuário
O aplicativo não deve depender de dados pessoais sensíveis para entregar valor.

Pode guardar:
- nome de exibição opcional
- preferências visuais
- preferências operacionais
- dados financeiros adicionados manualmente pelo usuário

Não deve guardar:
- número completo de cartão
- CVV
- senha bancária
- token bancário
- documentos pessoais sem necessidade de negócio
- endereço residencial
- data de nascimento como requisito de uso

Regra adicional:
- cartões exibidos no produto são representações visuais e operacionais, nunca cópias de cartões reais com dados confidenciais

## 8. Funcionalidades Obrigatórias
### Boas-vindas e personalização leve
Na primeira execução, o produto deve oferecer uma tela acolhedora de entrada com:
- mensagem de boas-vindas
- nome de exibição opcional
- escolha simples de aparência
- explicação clara de que o app não armazena dados confidenciais de cartão
- opção de continuar localmente
- opção de entrar com Google para sincronização

### Dashboard
Exibir sem necessidade de scroll:
- saldo atual
- receitas
- despesas
- economia do mês
- limites de cartões
- meta principal
- resumo financeiro

### Movimentações
Permitir cadastrar:
- despesas
- receitas
- transferências

Campos mínimos:
- valor
- categoria
- origem

Requisito de UX:
- cadastro médio em menos de 5 segundos

### Categorias
Categorias padrão:
- Mercado
- Alimentação
- Transporte
- Saúde
- Educação
- Lazer
- Assinaturas
- Moradia
- Investimentos
- Outros

Também deve permitir categorias personalizadas.

### Contas
Permitir múltiplas contas.
Campos:
- nome
- tipo
- saldo

Exemplos:
- Santander
- Banco do Brasil
- Nubank
- Caixa

Restrição:
- nunca armazenar credenciais bancárias

### Cartões
Permitir múltiplos cartões.
Campos:
- nome
- banco
- limite
- fechamento
- vencimento

Exibir:
- limite total
- limite utilizado
- limite disponível

Restrição:
- nunca armazenar dados sensíveis
- nunca armazenar número completo, CVV ou qualquer dado que torne o cartão reproduzível

### Histórico
Suportar:
- filtro hoje
- filtro semana
- filtro mês
- filtro personalizado
- pesquisa rápida
- agrupamento inteligente

### Metas
Permitir metas financeiras.
Exibir:
- valor alvo
- valor acumulado
- percentual concluído
- tempo estimado

### Assinaturas
Detectar gastos recorrentes.
Exibir:
- valor mensal
- valor anual
- próxima cobrança

Gerar alertas.

### Relatórios
Relatórios:
- semanal
- mensal
- anual

Exportação:
- PDF

## 9. Funcionalidades de Alto Valor Já Aprovadas
### Orçamento mensal por categoria
Exemplo:
- mercado R$ 800/mês
- lazer R$ 300/mês

### Calendário financeiro
Mostrar:
- vencimentos
- cobranças futuras
- fechamento e vencimento de cartões
- assinaturas recorrentes

### Previsão de saldo de 30 dias
Baseada em:
- recorrências
- metas
- contas
- cartões
- orçamento

### Modo “E se?”
Simulações de decisão como:
- guardar R$ 100 a mais por mês
- cancelar assinaturas
- quitar cartão
- reduzir gastos de lazer

## 10. IA no Produto
A IA não pode ser responsável por cálculos financeiros.

A IA pode ser usada para:
- classificação de texto livre
- interpretação de mensagens
- consultor financeiro
- explicação de relatórios

Toda matemática deve ser realizada por lógica programada.

## 11. Integração WhatsApp
Objetivo:
Permitir registro financeiro sem abrir o app.

Fluxo:
Usuário -> WhatsApp -> Meta API -> Backend -> Banco -> Aplicativo

Exemplos de mensagens válidas:
- mercado 120
- uber 25
- salario 3500
- ifood 45 credito santander

Regra de implementação:
- priorizar parser tradicional
- usar regex, dicionários e regras
- usar IA apenas quando o parser não conseguir interpretar

## 12. Premium
Objetivo:
Adicionar conveniência, sem remover o valor central do plano gratuito.

### Recursos Premium
- WhatsApp ilimitado
- relatórios automáticos
- consultor financeiro
- planejamento financeiro
- alertas inteligentes
- projeções futuras

### Recursos que não devem ser bloqueados
- contas
- cartões
- metas
- categorias
- dashboard
- histórico

## 13. UX
Restrições obrigatórias:
- máximo de 3 abas principais
- máximo de 2 toques para acessar qualquer função comum
- sem scroll nas telas principais
- feedback visual imediato
- tema claro e tema escuro

## 14. Segurança
Nunca armazenar:
- senhas bancárias
- tokens bancários
- número completo de cartões
- CVV
- dados sigilosos desnecessários

Aplicar:
- criptografia
- controle de acesso
- logs
- auditoria

## 15. Critérios de Conclusão
O projeto só será considerado concluído quando:
- todos os módulos obrigatórios estiverem implementados
- todos os fluxos críticos funcionarem
- não existirem erros críticos abertos
- a interface tiver sido aprovada no Figma
- a aplicação for responsiva
- performance estiver validada
- segurança estiver validada
- testes estiverem aprovados
- documentação estiver concluída

## 16. Estratégia de Lançamento
### Fase 1 — Lançamento
- dashboard
- contas
- cartões
- gastos e receitas
- categorias
- metas
- orçamento mensal
- calendário financeiro
- offline first
- tema claro e escuro
- sincronização
- histórico
- previsão financeira básica

### Fase 2 — Premium
- WhatsApp via Meta API
- relatórios automáticos
- planejamento financeiro
- simulações
- saúde financeira
- modo “E se?”

### Fase 3 — Biblioteca Financeira
- Selic
- CDI
- IPCA
- comparadores
- simuladores
- conteúdo educativo

## 17. Biblioteca Financeira
Objetivo:
Permitir simulações e educação financeira com fontes públicas, sem operar investimentos.

O sistema não deve:
- recomendar ativos específicos
- indicar compra ou venda
- prometer rentabilidade
- intermediar investimentos
- receber dinheiro dos usuários

Fontes públicas sugeridas:
- Banco Central do Brasil
- Tesouro Nacional
- IBGE
- Receita Federal
- APIs públicas autorizadas
