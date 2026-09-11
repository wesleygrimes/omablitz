#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

QMLTESTRUNNER=${QMLTESTRUNNER:-}
if [[ -z $QMLTESTRUNNER ]]; then
  QMLTESTRUNNER=$(command -v qmltestrunner || true)
fi
if [[ -z ${QMLTESTRUNNER:-} || ! -x $QMLTESTRUNNER ]]; then
  if [[ -x /usr/lib/qt6/bin/qmltestrunner ]]; then
    QMLTESTRUNNER=/usr/lib/qt6/bin/qmltestrunner
  fi
fi
[[ -n ${QMLTESTRUNNER:-} && -x $QMLTESTRUNNER ]] || {
  echo "qmltestrunner not found (install Qt 6 declarative tools)" >&2
  exit 1
}

export QT_QPA_PLATFORM=${QT_QPA_PLATFORM:-offscreen}

echo "== unit =="
"$QMLTESTRUNNER" -input tests/unit -platform offscreen

echo "== integration =="
bash tests/integration/manifest.sh
bash tests/integration/mock.sh

echo "ok test"
