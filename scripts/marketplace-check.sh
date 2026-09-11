#!/usr/bin/env bash
# Fail if the tree is not ready for plugins.omarchy.org submission rules.
set -euo pipefail
cd "$(dirname "$0")/.."

die() { printf 'marketplace: %s\n' "$@" >&2; exit 1; }
ok() { printf '  ok %s\n' "$*"; }

echo "== marketplace readiness =="

bash scripts/validate-manifest.sh >/dev/null

# Marketplace display fields beyond the shell's required set.
for field in author description license; do
  jq -e --arg f "$field" 'has($f) and (.[$f] | type == "string") and (.[$f] | length > 0)' manifest.json >/dev/null \
    || die "manifest missing non-empty '$field' (required for marketplace listing)"
done
ok "manifest author/description/license"

id=$(jq -r .id manifest.json)
[[ $id != omarchy.* ]] || die "id '$id' uses reserved omarchy.* namespace"
[[ $id =~ ^[a-z0-9][a-z0-9._-]*$ ]] || die "prefer lowercase namespaced id (got '$id')"
ok "plugin id $id"

[[ -f LICENSE ]] || die "missing root LICENSE"
ok "LICENSE"

[[ -f README.md ]] || die "missing root README.md"
rg -q '^## Install' README.md || die "README must have an ## Install section"
rg -q '^## Remove' README.md || die "README must have an ## Remove section"
rg -qi 'omarchy plugin add' README.md || die "README Install should show omarchy plugin add"
rg -qi 'omarchy plugin remove' README.md || die "README Remove should show omarchy plugin remove"
ok "README Install + Remove"

# External dependency disclosure (API host is the live data plane).
rg -q 'omablitz\.grimes\.pro' README.md || die "README must document the omablitz.grimes.pro dependency"
rg -qi 'unsandboxed|not a security' README.md || rg -qi 'unsandboxed' README.md \
  || die "README should warn that plugins run unsandboxed"
ok "dependencies + unsandboxed warning"

# Published tree must not contain symlinks (dev link is outside the repo).
while IFS= read -r -d '' link; do
  die "tracked symlink not allowed in plugin repo: $link"
done < <(find . -type l -not -path './.git/*' -print0)
ok "no symlinks in tree"

# Automated Security Baseline smell checks (static; not a full audit).
# Only scan runtime-ish paths — skip this checker (it names the patterns).
smell_files=$(rg -l \
  -e 'curl[^\n]*\|\s*(ba)?sh' \
  -e 'wget[^\n]*\|\s*(ba)?sh' \
  -e 'NOPASSWD\s*:\s*ALL' \
  -e 'cargo install --git' \
  scripts ui lib \
  --glob '*.sh' --glob '*.py' --glob '*.js' --glob '*.qml' --glob '*.mjs' \
  --glob '!scripts/marketplace-check.sh' \
  2>/dev/null || true)
if [[ -n ${smell_files:-} ]]; then
  printf '%s\n' "$smell_files" >&2
  die "security-baseline smell: remove download-to-shell / dangerous sudoers / unpinned cargo git (see docs/MARKETPLACE.md)"
fi
ok "no baseline smell patterns"

# Optional preview — warn only.
if compgen -G 'preview.{png,jpg,jpeg,webp,avif}' >/dev/null; then
  ok "preview image present"
else
  printf '  note: add preview.png before listing (optional but recommended)\n'
fi

# Planned listing metadata (documentation anchor).
[[ -f docs/MARKETPLACE.md ]] || die "missing docs/MARKETPLACE.md"
ok "docs/MARKETPLACE.md"

echo "ok marketplace"
