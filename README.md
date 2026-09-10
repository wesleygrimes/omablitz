# Omablitz

80s-retro football for [Omarchy](https://omarchy.org) — college (FBS + FCS) and NFL.

Follow the teams you care about. A quiet pixel helmet lives on the bar year-round. On gameday, scorebug pills light up. Click in for the rest.

## Install

```bash
omarchy plugin add https://github.com/wesleygrimes/omablitz.git --enable
```

Plugins run unsandboxed inside `omarchy-shell`. Read the code before you enable it.

## First run

Omablitz opens a panel to pick teams. One autocomplete: logo, name, conference/division (city/state when names collide). College and NFL in the same search. Follow as many as you want.

**Done** needs at least one team. **Skip** leaves only the helmet until you add some. **Manage teams** anytime from the panel — same picker, already filled with who you follow.

## The bar

**Mark** — the year-round 8-bit helmet. Disable the plugin if you want it gone.

**Pills** — only on gameday, and only for followed teams playing that day.

- Before kickoff: away logo · kickoff time · home logo
- Live: away logo · score · home logo, with a thin red outline on the pill
- Final: same without the outline (a little dimmer), then it drops

One pill per game even if you follow both sides. When the score changes, the pill gives a short rock and the changed number flashes once.

Quarter, clock, network, and deeper stats stay out of the bar.

## Panels

**Mark → Following** — your teams as a simple list: logo, name, one next pulse (`Sat 3:30` / live score / `Final`). Quiet weeks keep the roster with a calm pulse; offseason stays calm too. If scores can’t be reached, a small status sits right of the Omablitz header — the list keeps last-known data underneath.

No teams yet is the only true empty: a short line and **Add teams**.

**Pill → Game** — that game’s card in pixel style: clock, quarter, timeouts, scorebug, pass/rush totals, penalties, stadium, local conditions. Summary stats, not play-by-play.

Midweek planning lives in Following. The bar stays quiet until gameday.

## Kickoff alert

Fifteen minutes before a followed team’s kickoff, Omablitz sends one Omarchy notification: matchup, time, and network when known. Click opens the game (or Following if it isn’t live yet). Once per game; dismiss and it stays quiet. No score spam, no phone push.

## Data

Live data comes through `omablitz.grimes.pro`. The plugin never holds upstream API keys.

## License

MIT
