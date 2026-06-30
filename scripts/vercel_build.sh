#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$PWD/.vercel_flutter"
  export PATH="$PWD/.vercel_flutter/bin:$PATH"
fi

flutter pub get
flutter build web --base-href /app/

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
