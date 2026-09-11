#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

QMLTESTRUNNER=${QMLTESTRUNNER:-/usr/lib/qt6/bin/qmltestrunner}

echo "== unit =="
"$QMLTESTRUNNER" -input tests/unit -platform offscreen

echo "== integration =="
bash tests/integration/manifest.sh
bash tests/integration/mock.sh

echo "ok test"
