# Omablitz

80s-retro football scores for [Omarchy](https://omarchy.org) — college (FBS + FCS) and NFL.

Follow the teams you care about. A quiet pixel helmet sits on the bar year-round. On gameday, scorebug pills light up. Click in for the details.

## Install

```bash
omarchy plugin add https://github.com/wesleygrimes/omablitz.git --enable
```

Plugins run unsandboxed inside `omarchy-shell`. Read the code before you enable it.

## How it works

### First run
On first enable, Omablitz opens a panel to pick teams. One autocomplete: logo, school/club name, conference/division (city/state when it helps disambiguate). FBS and FCS colleges plus NFL. Follow as many as you want. **Done** needs at least one team; **Skip** leaves the bar quiet until you add some.

**Manage teams** anytime from the panel — same UI, pre-filled with who you follow.

### The bar
- **Mark** — year-round 8-bit helmet glyph. Hide the whole plugin via Setup → Plugins if you want it gone.
- **Pills** — only on gameday for followed teams that play that day.
  - Pre-kickoff: away logo · kickoff time · home logo
  - Live: away logo · score · home logo, thin red outline on the pill
  - Final: same as live without the outline (slightly dimmed), then it drops
- One pill per game even if you follow both sides.
- Score changes: short rock/nudge and the changed number flashes once.

Quarter, game clock, network, and deeper stats stay out of the bar.

### Clicks
- **Mark** → home: followed teams (logo, name, next/live/final status). Open a team's week / next game from a row. Footer: Manage teams (and This week when it lands).
- **Pill** → that game's card (pixel style): clock/quarter/timeouts, scorebug, pass/rush totals, penalties, stadium, local conditions. Summary stats — not play-by-play.

### Planning
Midweek planning lives in the panel (mark → home / schedule). The bar stays calm until gameday.

## Data
Live data comes through `omablitz.grimes.pro` (private Worker). The plugin never holds upstream API keys.

## License

MIT
