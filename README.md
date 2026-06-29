# Fluxa

Vertical slice Flutter do produto definido em `Docs/`.

## Escopo atual
- boas-vindas e personalização leve
- dashboard
- adicionar gasto
- histórico
- cartões com skins fictícios por banco

## Princípios aplicados
- mobile first
- dashboard sem ruído visual
- login Google tratado como sincronização opcional
- nenhum dado confidencial de cartão exposto na UI
- estrutura pronta para expandir sem reescrever a base

## Estrutura
- `lib/app`: ponto de entrada do app
- `lib/core`: tokens de tema e extensões
- `lib/shared`: widgets reutilizáveis
- `lib/models`: entidades e read models
- `lib/data`: fake data e datasource local
- `lib/repositories`: contratos simples de acesso a dados
- `lib/features`: telas e fluxo principal
- `Docs/`: PRD, regras de UX e demo original

## Regra atual de desenvolvimento
Nenhuma tela nova deve nascer fora dessa base:
- tokens primeiro
- widget reutilizável depois
- model/read model depois
- repository/datasource depois
- tela por último

## Execução
Quando o Flutter SDK estiver instalado:

```bash
flutter pub get
flutter run
```

## Marca
- Símbolo oficial da marca: `assets/brand/source/fluxa-symbol-master.svg`
- Prancha oficial da marca: `assets/brand/source/fluxa-board-master.svg`
- Exports prontos para uso: `assets/brand/fluxa-symbol-1024.png`, `assets/brand/fluxa-lockup-dark.png` e `assets/brand/fluxa-brand-board.png`
- `assets/brand/source` deve conter apenas os masters oficiais editáveis
- Para regenerar branding, ícone e splash: `source .venv-brand/bin/activate && python tool/generate_brand_assets.py`

## Limitação deste ambiente
O SDK `flutter` não está instalado na máquina atual, então o código foi estruturado mas não pôde ser compilado ou testado localmente daqui.
