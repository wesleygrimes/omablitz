#!/usr/bin/env bash
# Watch this checkout and ask omarchy-shell to reload the plugin.
# Needed because a symlink under ~/.config/omarchy/plugins skips the shell's
# inotify watcher; rescanPlugins still reloads QML from the linked tree.
set -euo pipefail
cd "$(dirname "$0")/.."

die() { printf '%s\n' "$@" >&2; exit 1; }

command -v inotifywait >/dev/null || die "inotifywait not found (pacman -S inotify-tools)"
command -v omarchy-shell >/dev/null || die "omarchy-shell not on PATH"

id=$(jq -r .id manifest.json)
status=$(bash scripts/link-plugin.sh --status)
if [[ $status != linked ]]; then
  die "Checkout is not linked. Run: mise plugin-link"
fi

reload() {
  if ! omarchy-shell shell ping >/dev/null 2>&1; then
    printf 'shell down — waiting\n'
    return 0
  fi
  local out
  out=$(omarchy-shell shell rescanPlugins 2>&1 || true)
  printf 'reload %s\n' "$(date +%H:%M:%S)"
  [[ -z $out || $out == ok ]] || printf '%s\n' "$out"
}

printf 'Watching ui/ lib/ mock/ manifest.json — edits reload %s\n' "$id"
reload

# Debounce bursts (save + format, editors writing temp files).
pending=0
inotifywait -m -r -e close_write,create,delete,move \
  --exclude '(\.git/|.*\.qmlc$|.*\.jsc$)' \
  ui lib mock manifest.json 2>/dev/null |
while read -r _dir _event file; do
  [[ -n ${file:-} ]] || continue
  pending=1
  # Drain a short window of events, then reload once.
  while read -r -t 0.3 _; do :; done
  if (( pending )); then
    pending=0
    reload
  fi
done
