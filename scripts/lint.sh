#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

QMLLINT=${QMLLINT:-}
if [[ -z $QMLLINT ]]; then
  QMLLINT=$(command -v qmllint || true)
fi
if [[ -z ${QMLLINT:-} || ! -x $QMLLINT ]]; then
  if [[ -x /usr/lib/qt6/bin/qmllint ]]; then
    QMLLINT=/usr/lib/qt6/bin/qmllint
  fi
fi
[[ -n ${QMLLINT:-} && -x $QMLLINT ]] || {
  echo "qmllint not found (install Qt 6 declarative tools)" >&2
  exit 1
}

if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin validate .
else
  bash scripts/validate-manifest.sh
fi

# ui/ imports qs.* and Quickshell — only lint when Omarchy shell modules exist.
mapfile -t qml_files < <(find ui -name '*.qml' | sort)
if (( ${#qml_files[@]} )); then
  shell_qml=${OMARCHY_PATH:-/usr/share/omarchy}/shell
  if [[ -d $shell_qml/Ui && -d $shell_qml/Commons ]]; then
    help=$("$QMLLINT" --help 2>&1 || true)
    qml_disable=()
    for cat in import unqualified missing-property missing-type uncreatable-type; do
      if grep -qE -- "--${cat}( |$)" <<<"$help"; then
        qml_disable+=(--"$cat" disable)
      fi
    done
    "$QMLLINT" -I "$shell_qml" "${qml_disable[@]}" "${qml_files[@]}"
  else
    printf 'skip ui qmllint (no Omarchy shell modules at %s)\n' "$shell_qml"
  fi
fi

# Unit-test QML must lint cleanly under stock Qt (no Omarchy imports).
mapfile -t test_qml < <(find tests -name '*.qml' 2>/dev/null | sort)
if (( ${#test_qml[@]} )); then
  "$QMLLINT" "${test_qml[@]}"
fi

shellcheck -x scripts/*.sh tests/integration/*.sh

echo "ok lint"
