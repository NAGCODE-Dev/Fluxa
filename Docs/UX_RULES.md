# UX Rules

## Objetivo
Este documento é a constituição da interface.

Ele existe para impedir que a experiência se degrade ao longo da implementação.

## Princípios Gerais
- o produto deve ser utilizável sem treinamento
- velocidade é parte do valor do produto
- a internet nunca pode ser pré-requisito para registrar algo
- clareza vale mais do que densidade de informação
- a interface deve explicar o estado atual sem exigir interpretação técnica
- o primeiro contato deve fazer o usuário se sentir seguro e no controle do próprio dado

## Regras de Velocidade
- registrar gasto em até `5 segundos`
- registrar receita em até `5 segundos`
- ações frequentes em no máximo `2 toques`
- tempo de percepção da ação principal em até `10 segundos`

## Teste dos 10 Segundos
Pergunta de validação:

> “Como você adicionaria um gasto?”

Critério:
- se a pessoa encontra o caminho em até `10 segundos`, a tela passou
- se a pessoa pergunta onde clicar, a UX precisa ser revista

## Regras de Navegação
- máximo de `3 abas principais`
- dashboard principal sem scroll crítico
- nenhuma tela principal com mais de `7 elementos clicáveis` prioritários
- ações secundárias nunca podem competir visualmente com a ação principal

## Regras de Interface
- todos os botões precisam de feedback visual
- todas as animações devem ser `<= 250 ms`
- toda tela deve deixar claro:
  - onde o usuário está
  - o que pode fazer
  - o que acontece depois

## Regras de Estado
- sempre salvar localmente primeiro
- nunca bloquear a interface esperando internet
- offline deve ser visível, mas não alarmista
- syncing deve ser discreto, mas rastreável
- erro deve explicar o problema e a próxima ação

## Regras de Conteúdo
- usar linguagem humana
- evitar jargão técnico desnecessário
- números financeiros sempre com contexto
- não esconder unidade monetária
- sinais positivo e negativo devem ser imediatamente distinguíveis
- explicar com clareza que o app não armazena dados confidenciais de cartão
- apresentar login com Google como sincronização opcional, não como barreira de entrada

## Regras de Dashboard
- precisa caber no primeiro viewport mobile
- mostrar apenas o que é decisivo agora
- não virar página de relatório
- gráficos só entram se reduzirem esforço cognitivo

## Regras de Formulário
- mostrar primeiro apenas os campos essenciais
- campos avançados devem ser progressivos
- placeholders não substituem labels
- confirmar sucesso sem interromper o fluxo

## Regras de Desktop Companion
- desktop é para análise, não réplica do mobile
- foco em comparação, tendências e leitura ampla
- desktop pode ter maior densidade, mas não caos visual

## Regras de Consistência
- nenhum padrão visual pode nascer isolado em uma tela
- toda exceção precisa virar regra documentada ou ser removida
- todo novo componente deve consultar `COMPONENT_GUIDE.md`

## Critério de Rejeição
Uma solução visual deve ser recusada se:
- aumentar cliques em ações frequentes
- exigir internet para tarefa central
- esconder estado importante
- depender de explicação verbal
- competir com a ação principal da tela
