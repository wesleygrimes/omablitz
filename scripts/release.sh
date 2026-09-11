#!/usr/bin/env bash
# Tag the current commit as v<manifest.version> and open a draft GitHub Release.
set -euo pipefail
cd "$(dirname "$0")/.."

die() { printf '%s\n' "$@" >&2; exit 1; }

dry=0
[[ ${1:-} == --dry-run ]] && dry=1

command -v gh >/dev/null || die "gh not found"
command -v git >/dev/null || die "git not found"

version=$(jq -r .version manifest.json)
[[ -n $version && $version != null ]] || die "manifest.json missing version"
tag=v$version

git rev-parse --is-inside-work-tree >/dev/null
[[ -z $(git status --porcelain) ]] || die "working tree dirty — commit or stash first"
branch=$(git branch --show-current)
[[ $branch == main ]] || die "release from main (on $branch)"

git fetch origin main --tags
[[ $(git rev-parse HEAD) == $(git rev-parse origin/main) ]] \
  || die "HEAD is not origin/main — push or reset first"

git rev-parse "$tag" >/dev/null 2>&1 && die "tag $tag already exists"

omarchy plugin validate .
bash scripts/lint.sh
bash scripts/test.sh

notes_args=(--generate-notes)
prev=$(git tag -l 'v*' --sort=-v:refname | head -1 || true)
if [[ -n $prev ]]; then
  notes_args=(--notes-start-tag "$prev")
fi

printf 'Will tag %s at %s and open a draft release.\n' "$tag" "$(git rev-parse --short HEAD)"
if (( dry )); then
  printf 'dry-run: skipping tag + gh release\n'
  exit 0
fi

git tag -a "$tag" -m "Omablitz $version"
git push origin "$tag"
gh release create "$tag" --draft "${notes_args[@]}" --title "Omablitz $version"
printf 'Draft release: '
gh release view "$tag" --json url -q .url
printf 'Review notes, attach any media, then publish.\n'
