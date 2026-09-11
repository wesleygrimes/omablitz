#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

QMLFORMAT=${QMLFORMAT:-/usr/lib/qt6/bin/qmlformat}

mapfile -t files < <(find ui tests -name '*.qml' 2>/dev/null | sort)
(( ${#files[@]} )) || exit 0
"$QMLFORMAT" -i "${files[@]}"
echo "formatted ${#files[@]} qml files"
