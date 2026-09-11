# Omarchy Plugins marketplace

Goal: ship Omablitz so it can list on
[plugins.omarchy.org](https://plugins.omarchy.org/) without a rewrite.

Official refs:

- [Browse](https://plugins.omarchy.org/)
- [Develop a plugin](https://plugins.omarchy.org/develop.html)
- [Publish a plugin](https://plugins.omarchy.org/publish.html)
- [SUBMISSION.md](https://github.com/omacom/omarchy-plugin-marketplace/blob/main/SUBMISSION.md)
- [SECURITY.md](https://github.com/omacom/omarchy-plugin-marketplace/blob/main/SECURITY.md) (Automated Security Baseline)

## Listing metadata (when we submit)

| Field | Value |
|-------|--------|
| Repository | `https://github.com/wesleygrimes/omablitz` |
| Plugin ID | `pro.grimes.omablitz` (permanent once listed — do not rename lightly) |
| Category | `Widgets` |
| Tags | `bar`, `games`, `quickshell` |

Issue title: `[Plugin]: Omablitz`

## Repository contract (always keep true)

- Public GitHub repo with **one** plugin and `manifest.json` at the root
- Root `README.md` with **Install** and **Remove**
- Root `LICENSE` and documented external dependencies
- ID outside `omarchy.*`, globally unique
- No symlinks inside the published tree (dev `mise plugin-link` is local-only)
- Optional root `preview.png` / `.jpg` / `.webp` / `.avif` (auto-optimized on list)
- Runtime code must not overwrite Omarchy/user config without explicit consent
- No `curl \| sh`, unpinned remote git installs, dangerous sudoers, or privileged PID control from `/tmp` (baseline findings)

## Architecture notes for Quattro

- Prefer nesting Following UI under the `bar-widget` (clock-style `Loader` +
  `KeyboardPanel`) when it is a bar popout.
- Keep a declared `panel` kind only when something must be summoned on its own
  (e.g. Game from a kickoff notification). That matches Omastorm’s bar + window
  split; do not add kinds you do not need.
- Never start a second Quickshell process for the plugin.
- Put pure logic in `lib/*.js` so checks stay honest; keep privileges minimal.

## Pre-submit checklist

```sh
mise marketplace   # structure + security-baseline smell checks
mise check         # lint + tests
```

Then open the
[submission form](https://github.com/omacom/omarchy-plugin-marketplace/issues/new?template=submit-plugin.yml)
(or follow SUBMISSION.md / `gh issue create`). Listing approval is **not** a
security review — plugins stay unsandboxed.

## After listing

- Merges to `main` reach users via `omarchy plugin update` (mutable HEAD).
- Marketplace “Verified” is bound to an exact commit; newer HEAD shows
  “Update unverified” until a verification/update issue promotes it.
- Use `mise release` for user-facing `v*` notes; that is separate from marketplace verification.
