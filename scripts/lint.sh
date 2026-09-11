#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

QMLLINT=${QMLLINT:-/usr/lib/qt6/bin/qmllint}
[[ -x $QMLLINT ]] || QMLLINT=$(command -v qmllint || true)
[[ -n ${QMLLINT:-} && -x $QMLLINT ]] || {
  echo "qmllint not found" >&2
  exit 1
}

if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin validate .
else
  bash scripts/validate-manifest.sh
fi

# Plugin QML imports qs.* / Quickshell which qmllint cannot resolve outside the
# shell. Category names vary by Qt version — only pass flags this binary knows.
help=$("$QMLLINT" --help 2>&1 || true)
qml_disable=()
for cat in import unqualified missing-property missing-type uncreatable-type; do
  if grep -qE -- "--${cat}( |$)" <<<"$help"; then
    qml_disable+=(--"$cat" disable)
  fi
done

mapfile -t qml_files < <(find ui -name '*.qml' | sort)
if (( ${#qml_files[@]} )); then
  "$QMLLINT" "${qml_disable[@]}" "${qml_files[@]}"
fi

# Pure lib / tests should resolve cleanly (no Omarchy imports).
mapfile -t test_qml < <(find tests -name '*.qml' 2>/dev/null | sort)
if (( ${#test_qml[@]} )); then
  "$QMLLINT" "${test_qml[@]}"
fi

shellcheck -x scripts/*.sh tests/integration/*.sh

echo "ok lint"
