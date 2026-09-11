# Develop

Day-to-day on an Omarchy desktop:

```sh
mise install
mise setup
mise dev
```

That symlinks this checkout into `~/.config/omarchy/plugins/pro.grimes.omablitz`,
serves `mock/fixtures` on `http://127.0.0.1:8787`, and reloads the plugin when
you edit `ui/`, `lib/`, or `manifest.json`.

| Task | What it does |
|------|----------------|
| `mise plugin-link` / `plugin-unlink` | Point the bar at this tree / restore the clone |
| `mise mock` | Mock API only |
| `mise watch` | Reload on save (needs link) |
| `mise lint` / `test` / `check` | Marketplace readiness, qmllint, shellcheck, tests |
| `mise format` | `qmlformat` in place |
| `mise release` | Tag `v*` from `main` and open a draft GitHub Release |

The plugin reads `OMABLITZ_API_BASE` (mise sets it to the mock). Production
default is `https://omablitz.grimes.pro`.

Before every commit: `mise check`. That includes marketplace readiness
([docs/MARKETPLACE.md](docs/MARKETPLACE.md)), lint, and tests. Releases:
[docs/RELEASING.md](docs/RELEASING.md). Listing on
[plugins.omarchy.org](https://plugins.omarchy.org/) is a first-class goal — keep
Install/Remove, dependency docs, and the security baseline constraints intact
as you build.

## Issues

Use the GitHub issue forms:

- **Bug report** — what happened, what you expected, Omarchy version, plugin commit
- **Feature request** — problem, proposal, and how it fits the UX

Security reports go through [SECURITY.md](SECURITY.md), not public issues.

## Commits

[Conventional Commits](https://www.conventionalcommits.org/)-style subjects:

```
feat: add team search to Following
fix: keep live pills after shell restart
docs: document Remove in README
chore: bump mise tools
test: cover scorebug formatting
refactor: move pulse label into lib/
```

Rules of thumb:

- Imperative mood, ~72 chars for the subject
- One logical change per commit
- Body optional; use it for *why*, not a file list
- No co-author / tool trailers unless you want them

`mise release` builds GitHub release notes from `v*` tags and issue labels
(see `.github/release.yml`).

## Pull requests

Branch from `main`. One change per PR. Run `mise check` before opening.
Subject is a short imperative; the body says why and how you verified it.
Use the PR template checklist.

## Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
