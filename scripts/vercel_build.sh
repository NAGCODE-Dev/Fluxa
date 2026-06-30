#!/usr/bin/env bash
set -euo pipefail

FLUTTER_DIR="$PWD/.vercel_flutter"

if ! command -v flutter >/dev/null 2>&1; then
  if [ ! -d "$FLUTTER_DIR/.git" ]; then
    git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  fi
  export PATH="$FLUTTER_DIR/bin:$PATH"
fi

flutter config --enable-web
flutter pub get
dart run drift_dev web
flutter build web --release --base-href /app/

rm -rf .vercel/output
mkdir -p .vercel/output/static

cp -R site .vercel/output/static/site
cp -R assets .vercel/output/static/assets
cp -R build/web .vercel/output/static/app
cp site/index.html .vercel/output/static/index.html

cat > .vercel/output/config.json <<'JSON'
{
  "version": 3,
  "routes": [
    {
      "src": "^/$",
      "dest": "/index.html"
    },
    {
      "src": "^/app$",
      "dest": "/app/index.html"
    },
    {
      "handle": "filesystem"
    },
    {
      "src": "^/app/.*$",
      "dest": "/app/index.html"
    }
  ]
}
JSON
