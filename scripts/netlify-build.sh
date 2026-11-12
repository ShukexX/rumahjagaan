#!/usr/bin/env bash
set -euo pipefail

# Netlify does not include Flutter. Install the tested SDK without upgrading it.
readonly REQUIRED_FLUTTER_VERSION="3.35.4"
readonly PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly SDK_DIR="${FLUTTER_SDK_DIR:-${HOME}/.cache/dgh-flutter/${REQUIRED_FLUTTER_VERSION}}"

cd "$PROJECT_ROOT"
if [[ "${FLUTTER_VERSION:-$REQUIRED_FLUTTER_VERSION}" != "$REQUIRED_FLUTTER_VERSION" ]]; then
  echo "This project requires Flutter ${REQUIRED_FLUTTER_VERSION}." >&2
  exit 1
fi

if [[ ! -x "$SDK_DIR/bin/flutter" ]]; then
  mkdir -p "$(dirname "$SDK_DIR")"
  git clone --depth 1 --branch "$REQUIRED_FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git "$SDK_DIR"
fi

export PATH="$SDK_DIR/bin:$PATH"
export CI=true
export FLUTTER_SUPPRESS_ANALYTICS=true
export DART_SUPPRESS_ANALYTICS=true

# Bootstrap the tool before parsing its machine-readable output on a fresh SDK.
flutter --version
ACTUAL_VERSION="$(flutter --version --machine | python3 -c 'import json,sys; print(json.load(sys.stdin)["frameworkVersion"])')"
if [[ "$ACTUAL_VERSION" != "$REQUIRED_FLUTTER_VERSION" ]]; then
  echo "Expected Flutter ${REQUIRED_FLUTTER_VERSION}; found ${ACTUAL_VERSION}." >&2
  exit 1
fi

flutter precache --web
flutter pub get --enforce-lockfile
flutter build web --release --no-pub --base-href / \
  --dart-define=flutter.inspector.structuredErrors=false \
  --dart-define=debugShowCheckedModeBanner=false

# A successful build must contain the compiled app, not just web/index.html.
for file in index.html flutter_bootstrap.js main.dart.js; do
  if [[ ! -s "build/web/$file" ]]; then
    echo "Missing build/web/$file; refusing to publish an incomplete app." >&2
    exit 1
  fi
done

echo "DGH Care Centre is ready to publish from build/web."
