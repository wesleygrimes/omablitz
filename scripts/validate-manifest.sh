#!/usr/bin/env bash
# Manifest checks that work without the omarchy CLI (CI). Prefer
# `omarchy plugin validate` on a desktop — this mirrors the basics.
set -euo pipefail
cd "$(dirname "$0")/.."

die() { printf '%s\n' "$@" >&2; exit 1; }

[[ -f manifest.json ]] || die "missing manifest.json"
jq -e . manifest.json >/dev/null || die "manifest.json is not valid JSON"
jq -e '.schemaVersion == 1' manifest.json >/dev/null || die "schemaVersion must be 1"

for field in id name version kinds entryPoints; do
  jq -e --arg f "$field" 'has($f)' manifest.json >/dev/null || die "missing $field"
done

id=$(jq -r .id manifest.json)
[[ $id =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || die "invalid id"
[[ $id != omarchy.* ]] || die "id must not use omarchy.* namespace"

jq -e '(.kinds | type) == "array" and (.kinds | length) > 0' manifest.json >/dev/null \
  || die "kinds must be a non-empty array"
jq -e '(.entryPoints | type) == "object"' manifest.json >/dev/null \
  || die "entryPoints must be an object"

while IFS= read -r ep; do
  [[ -n $ep ]] || continue
  [[ $ep != /* && $ep != *..* ]] || die "unsafe entry point: $ep"
  [[ -f $ep ]] || die "missing entry point file: $ep"
done < <(jq -r '.entryPoints | .[]' manifest.json)

echo "ok validate-manifest"
