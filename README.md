# <p align="center">
  <img src="assets/brand/fluxa-lockup-light.png" width="220" alt="Fluxa Logo"/>
</p>

<h1 align="center">Fluxa</h1>

<p align="center">
Organize sua vida financeira com simplicidade.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter">
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart">
  <img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase">
  <img src="https://img.shields.io/badge/License-MIT-success">
  <img src="https://img.shields.io/badge/V1-1.0.0-2563EB">
</p>

---

## ✨ Sobre

Fluxa é um aplicativo moderno de controle financeiro pessoal criado para tornar o acompanhamento de gastos simples, rápido e agradável.

Ao invés de transformar o usuário em um contador, o objetivo é oferecer uma experiência intuitiva onde registrar despesas leva apenas alguns segundos.

O foco é eliminar atritos e criar o hábito de acompanhar as próprias finanças diariamente.

---

## 🎯 Objetivos

- Controle financeiro simples
- Interface minimalista
- Dashboard sem poluição visual
- Registro rápido de despesas
- Histórico inteligente
- Sincronização em nuvem
- Expansão modular

---

## 📱 Preview

A V1 publicável entrega Android por APK e iPhone/iOS via Fluxa Web como PWA. A pasta `assets/brand/` reúne os materiais oficiais da marca, incluindo ícone, lockup, splash e prévias visuais do Fluxa.

---

## 🎨 Design

A identidade visual segue três princípios:

- Clareza
- Movimento
- Controle

A interface utiliza bastante espaço em branco, azul como cor principal e componentes minimalistas.

---

## 🏗 Arquitetura

```
lib/
 ├── app/
 ├── core/
 ├── data/
 ├── features/
 ├── models/
 ├── repositories/
 └── shared/
```

---

## 🚀 Tecnologias

- Flutter
- Dart
- Supabase
- Material 3
- Vercel
- GitHub Releases

---

## 📦 Como executar

```bash
git clone https://github.com/NAGCODE-Dev/Fluxa.git

cd Fluxa

flutter pub get

flutter run
```

## 🌐 Distribuição pública

O projeto agora inclui a base de distribuição pública em três partes:

- `site/`: landing page estática para Vercel
- `.github/workflows/release-android.yml`: workflow que gera o APK e publica a release
- `.github/workflows/deploy-web.yml`: workflow que gera o build web
- `vercel.json`: entrega a landing na raiz do deploy e o app web em `/app/`

### Fluxo

1. Publique código no GitHub.
2. Gere o app web com `flutter build web` ou rode o workflow `Build Fluxa Web`.
3. Rode o workflow `Release Android APK` manualmente ou use uma tag `vX.Y.Z`.
4. O GitHub Actions gera `fluxa-vX.Y.Z.apk` e anexa na release.
5. A landing do Vercel consulta automaticamente as releases e atualiza:

- versão atual
- changelog curto
- botão de download
- histórico de versões

O botão de iPhone abre `Fluxa Web` em `/app/`.

### Deploy da landing no Vercel

No Vercel, importe este repositório sem framework preset especial.

- Root Directory: `.`
- Build Command: `bash scripts/vercel_build.sh`
- Output Directory: `.vercel/output/static`

O `vercel.json` usa esse script para instalar Flutter quando necessário, compilar `flutter build web --release --base-href /app/` e publicar a landing na raiz com o app em `/app/`.

### Fluxa Web

O app já compila para web e pode ser servido no mesmo projeto em `/app/`.

- Android: continua baixando o APK via release.
- iPhone/iOS: usa Fluxa Web no Safari e pode ser instalado por `Compartilhar` > `Adicionar à Tela de Início`.
- Build web: gere os assets do Drift com `dart run drift_dev web`; depois o workflow e o Vercel usam `flutter build web --release --base-href /app/`.
- Landing: o botão `Usar no iPhone` aponta para `/app/`, mantendo o caminho PWA claro para a V1.

### Captura assistida por notificações

No Android, o Fluxa pode gerar sugestões de gasto a partir de notificações de banco/cartão.

- O usuário ativa manualmente em `Conta e preferências` > `Captura por notificações`.
- O Android abre a tela de permissão de acesso a notificações.
- O app procura notificações com valores em reais e cria uma sugestão editável.
- Nada é registrado automaticamente: o usuário toca em `Registrar`, revisa o gasto e salva.
- iPhone e Fluxa Web continuam com cadastro manual, porque o iOS não permite leitura livre de notificações de outros apps.

---

## 🛣 Roadmap

- [x] Dashboard
- [x] Histórico
- [x] Cadastro de gastos
- [x] Sistema de cartões
- [ ] Supabase
- [ ] Login Google
- [ ] Categorias inteligentes
- [ ] Estatísticas
- [ ] Backup em nuvem
- [ ] Publicação Android

---

## 📁 Documentação

Toda a documentação do projeto encontra-se na pasta:

```
Docs/
```

Incluindo:

- Arquitetura
- PRD
- UX
- Componentes
- Fluxos
- Banco de dados

---

## 🤝 Contribuindo

Contribuições são bem-vindas.

Abra uma Issue ou envie um Pull Request.

---

## 📄 Licença

MIT License.
