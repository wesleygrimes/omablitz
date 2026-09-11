# Releasing Omablitz

Installs clone this repo into `~/.config/omarchy/plugins/pro.grimes.omablitz`
and updates fast-forward `main`. Users get whatever is on `main` when they
update — a `v*` tag is the release note for that work, not a separate artifact.

## Ship a version

1. Bump `version` in `manifest.json`.
2. From a clean `main` that matches `origin/main`, run `mise check`.
3. Commit and push the bump (and any shipping changes).
4. Run `mise release` (or `mise release -- --dry-run` first).
   - Tags `v<version>` on HEAD and pushes it
   - Opens a **draft** GitHub Release with generated notes since the previous `v*` tag
5. Edit the draft notes, attach any media, publish.

There is no engine binary and no pin file — the git tree is the plugin.

## Hotfix without a version bump

Merge to `main`. Tell users to `omarchy plugin update`. Tag later if you want
the fix in release notes.

## Marketplace

Listing and verification are separate from `v*` tags. See
[MARKETPLACE.md](MARKETPLACE.md). After a release you care about verifying,
use the marketplace’s plugin verification form for that exact commit.
