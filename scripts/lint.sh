#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

QMLLINT=${QMLLINT:-/usr/lib/qt6/bin/qmllint}

if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin validate .
else
  bash scripts/validate-manifest.sh
fi

# Plugin QML imports qs.* / Quickshell which qmllint cannot resolve outside the
# shell — disable those categories and still catch syntax / smell issues.
mapfile -t qml_files < <(find ui -name '*.qml' | sort)
if (( ${#qml_files[@]} )); then
  "$QMLLINT" \
    --import disable \
    --unqualified disable \
    --missing-property disable \
    --missing-type disable \
    --uncreatable-type disable \
    "${qml_files[@]}"
fi

# Pure lib / tests should resolve cleanly (no Omarchy imports).
mapfile -t test_qml < <(find tests -name '*.qml' 2>/dev/null | sort)
if (( ${#test_qml[@]} )); then
  "$QMLLINT" "${test_qml[@]}"
fi

shellcheck -x scripts/*.sh tests/integration/*.sh

echo "ok lint"
