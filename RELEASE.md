# Fluxa V1.0.0

## Canais de publicação

- **Android:** APK gerado pelo workflow `Release Android APK` a partir da tag `v1.0.0`.
- **iPhone/iOS:** Fluxa Web publicado em `/app/` e instalável pelo Safari como PWA.
- **Landing:** página estática na raiz do Vercel, lendo as releases do GitHub para preencher versão, changelog e link do APK.

## Checklist de release

1. Confirmar `version: 1.0.0+1` em `pubspec.yaml`.
2. Rodar `flutter analyze` e `flutter test`.
3. Validar `flutter build apk --release`.
4. Gerar os assets web do Drift com `dart run drift_dev web`.
5. Validar `flutter build web --release --base-href /app/` ou `bash scripts/vercel_build.sh`.
6. Criar e enviar a tag `v1.0.0` para disparar o APK no GitHub Actions.
7. Publicar no Vercel usando `bash scripts/vercel_build.sh` como build command.
