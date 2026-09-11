#!/usr/bin/env bash
# Integration: mock server serves fixture-shaped JSON.
set -euo pipefail
cd "$(dirname "$0")/../.."

die() { printf '%s\n' "$@" >&2; exit 1; }

# Pick a free port so a leftover mise mock on :8787 cannot poison the check.
port=$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1]); s.close()')
base=http://127.0.0.1:$port

cleanup() {
  if [[ -n ${pid:-} ]]; then
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
  fi
}
trap cleanup EXIT

OMABLITZ_MOCK_PORT=$port python3 scripts/mock-server.py &
pid=$!
for (( i = 0; i < 50; i++ )); do
  curl -sf "$base/health" >/dev/null 2>&1 && break
  sleep 0.05
done
curl -sf "$base/health" >/dev/null || die "mock server failed to start on $port"

curl -sf "$base/health" | jq -e '.ok == true' >/dev/null
curl -sf "$base/v1/teams" | jq -e '.teams | type == "array" and length > 0' >/dev/null
curl -sf "$base/v1/teams?q=georgia" | jq -e '.teams | length == 1 and .[0].abbr == "UGA"' >/dev/null
curl -sf "$base/v1/games/today" | jq -e '.games | type == "array" and length > 0' >/dev/null
curl -sf "$base/v1/games/nfl-20260913-atl-no" | jq -e '.status == "live" and .home.abbr == "NO"' >/dev/null
code=$(curl -s -o /dev/null -w '%{http_code}' "$base/v1/games/missing")
[[ $code == 404 ]] || die "expected 404 for missing game, got $code"

echo "ok mock"
