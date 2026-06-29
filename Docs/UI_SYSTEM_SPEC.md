# UI System Spec

## Identidade
Produto financeiro pessoal com linguagem:
- clara
- precisa
- confiável
- leve
- moderna

Evitar:
- saturação visual
- excesso de cards
- gamificação
- ilustrações infantis

## Color Tokens

### Brand
- `brand.primary = #14B8A6`
- `brand.secondary = #2563EB`

### Feedback
- `feedback.error = #EF4444`
- `feedback.warning = #F59E0B`
- `feedback.success = #10B981`

### Light
- `bg.canvas = #F8FAFC`
- `bg.surface = #FFFFFF`
- `bg.subtle = #F1F5F9`
- `border.default = #E2E8F0`
- `text.primary = #0F172A`
- `text.secondary = #475569`
- `text.tertiary = #64748B`

### Dark
- `bg.canvas.dark = #0F172A`
- `bg.surface.dark = #111827`
- `bg.subtle.dark = #1E293B`
- `border.default.dark = #334155`
- `text.primary.dark = #F8FAFC`
- `text.secondary.dark = #CBD5E1`
- `text.tertiary.dark = #94A3B8`

### Financial
- `money.positive = #16A34A`
- `money.negative = #DC2626`
- `money.neutral = #0F172A`
- `money.neutral.dark = #F8FAFC`

## Typography
Família base:
- `Geist` ou equivalente sem serifa, de alta legibilidade

Escala:
- `display.lg = 40/48`
- `display.md = 32/38`
- `heading.lg = 28/34`
- `heading.md = 24/30`
- `title.lg = 20/26`
- `title.md = 18/24`
- `body.lg = 16/24`
- `body.md = 14/22`
- `body.sm = 13/20`
- `caption = 12/16`

Pesos:
- `regular`
- `medium`
- `semibold`
- `bold`

## Spacing
Escala:
- `4`
- `8`
- `12`
- `16`
- `20`
- `24`
- `32`
- `40`
- `48`

## Radius
- `sm = 8`
- `md = 12`
- `lg = 16`
- `xl = 20`
- `2xl = 24`
- `pill = 999`

## Shadows / Elevation
- `elevation.0 = none`
- `elevation.1 = 0 1 2`
- `elevation.2 = 0 4 10`
- `elevation.3 = 0 8 24`

Uso:
- cards padrão usam `elevation.1`
- modais e bottom sheets usam `elevation.3`

## Grid

### Mobile
- largura base: `390`
- margens laterais: `20`
- grid lógico: `4 colunas`

### Desktop
- largura mínima de conteúdo: `1280`
- sidebar fixa
- área analítica em grid de `12 colunas`

## Ícones
Família:
- outlines simples
- consistente em 20/24 px

Categorias:
- navegação
- financeiro
- status
- ações rápidas

## Componentes Base
- `AppShell`
- `TopBar`
- `BottomNavigation`
- `SideNavigation`
- `PrimaryButton`
- `SecondaryButton`
- `TertiaryButton`
- `IconButton`
- `FAB`
- `TextField`
- `SearchField`
- `AmountField`
- `SelectField`
- `SegmentedControl`
- `Chip`
- `Badge`
- `Snackbar`
- `Dialog`
- `BottomSheet`
- `Card`
- `MetricCard`
- `TransactionRow`
- `AccountCard`
- `CreditCardSummary`
- `CardSkin`
- `GoalCard`
- `BudgetBar`
- `CalendarEventRow`
- `EmptyState`
- `ErrorState`
- `OfflineState`
- `SyncState`
- `SkeletonBlock`

## Variantes Obrigatórias
Todo componente interativo deve prever:
- `default`
- `hover`
- `pressed`
- `focus`
- `disabled`
- `loading`
- `light`
- `dark`

## Regras de Nomeação
- `screen/mobile/dashboard/light/default`
- `screen/mobile/dashboard/dark/empty`
- `component/button/primary/light/default`
- `component/button/primary/dark/loading`
- `pattern/history/filter-bar/light/default`

## Regras de Implementação Futura
- nada de componente duplicado por tela
- estado visual deve nascer do design system, não de exceções locais
- todo estado vazio precisa texto, CTA e explicação
- todo estado de erro precisa recuperação explícita

## Card Skin System
Os cartões devem usar um catálogo visual fictício por banco, documentado em `CARD_SKINS.md`.

Objetivo:
- facilitar reconhecimento visual
- enriquecer a interface sem usar cartões reais

Aplicação:
- `CreditCardSummary`
- `Detalhes do Cartão`
- cabeçalhos de fatura
- badges compactos no histórico
