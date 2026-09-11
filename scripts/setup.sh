#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

die() { printf '%s\n' "$@" >&2; exit 1; }

need() {
  command -v "$1" >/dev/null 2>&1 || die "missing $1 — $2"
}

need omarchy "Omarchy desktop (omarchy CLI)"
need omarchy-shell "Omarchy shell IPC"
need jq "mise install"
need python3 "system Python"
need inotifywait "pacman -S inotify-tools"
need curl "pacman -S curl"

[[ -x /usr/lib/qt6/bin/qmllint ]] || die "missing qmllint — pacman -S qt6-declarative"
[[ -x /usr/lib/qt6/bin/qmltestrunner ]] || die "missing qmltestrunner — pacman -S qt6-declarative"
[[ -x /usr/lib/qt6/bin/qmlformat ]] || die "missing qmlformat — pacman -S qt6-declarative"

omarchy plugin validate .
printf 'setup ok\n'
