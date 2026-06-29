# Card Skins Catalog

## Objetivo
Criar um banco visual superficial de cartões fictícios inspirados na identidade dos bancos mais comuns, sem usar cartões reais e sem depender de ativos sensíveis.

Esses skins existem para:
- enriquecer a UI
- diferenciar cartões na leitura rápida
- melhorar reconhecimento visual no histórico, dashboard e detalhe do cartão

## Regras
- nenhum cartão deve copiar fielmente um cartão real
- a referência deve ser apenas cromática e de linguagem visual
- o nome do banco pode aparecer, mas a arte do cartão deve ser simulada
- sempre usar numeração mascarada
- sempre usar textos genéricos como `Crédito`, `Débito`, `Black`, `Gold`, `Platinum`

## Estrutura de Dados Recomendada
Cada skin deve ter:
- `bankKey`
- `displayName`
- `theme`
- `background`
- `foreground`
- `accent`
- `pattern`
- `networkLabel`

Exemplo:
```json
{
  "bankKey": "nubank",
  "displayName": "Nubank",
  "theme": "purple",
  "background": "#7C3AED",
  "foreground": "#FFFFFF",
  "accent": "#C4B5FD",
  "pattern": "soft-diagonal",
  "networkLabel": "Mastercard"
}
```

## Catálogo Inicial

### Nubank
- `bankKey = nubank`
- fundo: roxo profundo
- texto: branco
- acento: lilás claro
- pattern: diagonal suave
- leitura pretendida: moderno, digital, limpo

### Santander
- `bankKey = santander`
- fundo: vermelho forte
- texto: branco
- acento: vermelho claro / coral
- pattern: ondas suaves
- leitura pretendida: forte, tradicional, reconhecível

### Banco do Brasil
- `bankKey = banco_do_brasil`
- fundo: amarelo quente
- texto: azul escuro
- acento: azul médio
- pattern: blocos geométricos discretos
- leitura pretendida: institucional, confiável

### Caixa
- `bankKey = caixa`
- fundo: azul médio
- texto: branco
- acento: laranja
- pattern: faixas horizontais discretas
- leitura pretendida: pública, sólida

### Itaú
- `bankKey = itau`
- fundo: laranja forte
- texto: azul escuro
- acento: azul vibrante
- pattern: curvas leves
- leitura pretendida: energética, conhecida

### Bradesco
- `bankKey = bradesco`
- fundo: vermelho vinho
- texto: branco
- acento: rosa suave
- pattern: brilho radial discreto
- leitura pretendida: premium, tradicional

### Inter
- `bankKey = inter`
- fundo: laranja vivo
- texto: branco
- acento: laranja claro
- pattern: grade sutil
- leitura pretendida: digital, leve

### C6
- `bankKey = c6`
- fundo: preto grafite
- texto: branco
- acento: dourado suave
- pattern: metal escuro discreto
- leitura pretendida: premium, sóbrio

## Regras de Uso na Interface

### Dashboard
- usar no máximo `2` cartões visíveis por vez
- o cartão principal deve ter destaque
- os demais podem aparecer como mini-cards ou empilhados

### Histórico
- nunca renderizar o cartão completo
- usar apenas badge ou tarja de cor do skin

### Detalhe do Cartão
- usar o skin completo
- mostrar:
  - nome do banco
  - rótulo do produto
  - final mascarado
  - limite
  - fechamento
  - vencimento

### Fatura
- usar cabeçalho com skin reduzido
- não competir com a lista de transações

## Variações Permitidas
- `default`
- `dark-surface`
- `compact`
- `mini-badge`

## Não Fazer
- não usar logotipos rasterizados sem necessidade
- não tentar imitar chip/contacless realistas demais
- não usar números completos
- não usar texturas exageradas
