#!/usr/bin/env bash
# Integration: manifest schema the shell will accept.
set -euo pipefail
cd "$(dirname "$0")/../.."

if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin validate .
else
  bash scripts/validate-manifest.sh
fi
echo "ok manifest"
