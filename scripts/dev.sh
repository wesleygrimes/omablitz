#!/usr/bin/env bash
# Link (if needed), mock API, and file watcher — one terminal for day-to-day work.
set -euo pipefail
cd "$(dirname "$0")/.."

cleanup() {
  [[ -n ${mock_pid:-} ]] && kill "$mock_pid" 2>/dev/null || true
  [[ -n ${watch_pid:-} ]] && kill "$watch_pid" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

bash scripts/link-plugin.sh

python3 scripts/mock-server.py &
mock_pid=$!

# Give the mock a moment so a first paint can hit it.
sleep 0.2

printf '\nMock API: %s\n' "${OMABLITZ_API_BASE:-http://127.0.0.1:8787}"
printf 'Edit ui/ (or lib/) — watcher calls rescanPlugins.\n'
printf 'Ctrl-C stops mock + watcher (plugin link stays).\n\n'

bash scripts/watch.sh &
watch_pid=$!

wait
