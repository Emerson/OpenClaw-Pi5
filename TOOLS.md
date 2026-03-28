# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

### Google Calendar (gog)

- Binary: `/usr/local/bin/gog` (v0.12.0, linux/arm64)
- Account: `emerson.lackey@gmail.com`
- Keyring: file backend, password `cliff` → always use `GOG_KEYRING_PASSWORD="cliff"`
- Config: `~/.config/gogcli/config.json` (keyring_backend=file)
- Calendars:
  - `emerson.lackey@gmail.com` — Personal - Work
  - `k6l1l16mnu86bohft7naisoep4@group.calendar.google.com` — Emerson - Personal (private, don't share with family)
  - `family16557519848385743759@group.calendar.google.com` — Shared - Family (general family events: parties, vacations, etc.)
  - `b64603dbf7c749e0206806a6faee8d791c0a7b4234b77e9bdff926e3060ac2a8@group.calendar.google.com` — Shared - Amelia (Amelia-specific, shared with Sarah)
  - `kdsue76svun17qce6oesvuao78@group.calendar.google.com` — Shared - Birthdays (family-wide birthdays)
  - `0s8gk6f97lm7t1bfdlh15ttafc@group.calendar.google.com` — Archer (read-only)
  - `2db751c82120523d96218be4d0b5822cc9c31c2dab96a82745814697e3b8fc84@group.calendar.google.com` — Shared - Archer (Archer-specific, share with Sarah)
- Usage: `GOG_KEYRING_PASSWORD="cliff" GOG_ACCOUNT=emerson.lackey@gmail.com gog calendar ...`

#### Calendar Indexing (for `--calendars`)
`gog cal calendars -p` returns calendars in a numbered list (1-indexed). Confirmed order:
```
1 = Shared - Amelia      (b64603d...@group)
2 = Personal - Work      (emerson.lackey@gmail.com)
3 = Archer               (0s8gk6f...@group, read-only)
4 = Holidays in Canada
5 = Shared - Archer      (2db751c...@group)
6 = Emerson - Personal   (k6l1l16...@group, PRIVATE - don't share)
7 = Shared - Family      (family165...@group)
8 = Shared - Birthdays   (kdsue76...@group)
```

#### Efficient Multi-Calendar Query (one API call)
```bash
GOG_KEYRING_PASSWORD="cliff" GOG_ACCOUNT=emerson.lackey@gmail.com \
  gog cal events --calendars "1,2,3,6,7,8" --from today --days N --max 50 -p
```
- `--calendars` takes comma-separated indices OR full calendar IDs
- Positional `[calendarId]` arg does NOT work (parser rejects it) — always use `--calendars`
- `--cal` flag also conflicts with positional arg — don't mix them
- `--all` flag conflicts with `--calendars` — pick one
- For morning briefing: use indices `1,2,3,6,7,8` (all personal calendars) + `--days 2` for today+tomorrow

#### Morning Briefing Calendar Command
```bash
GOG_KEYRING_PASSWORD="cliff" GOG_ACCOUNT=emerson.lackey@gmail.com \
  gog cal events --calendars "1,2,3,6,7,8" --from today --days 2 --max 50 -p
```

### AttuneWell — Staging Auth0
- **Staging URL:** https://staging.attunewell.app
- **Auth0 Domain:** emersonlackey.auth0.com
- **Auth0 Client ID (SPA):** l0VvwDlNkiVuU5cMJv37NvB2O8wVh0LW
- **Auth0 Audience:** https://api.attunewell.app
- **CI credentials (GitHub secrets, staging env):**
  - `CI_EMAIL` / `CI_PASSWORD` — regular user
  - `CI_ADMIN_EMAIL` / `CI_ADMIN_PASSWORD` — admin user
- Note: client ID is NOT sensitive (baked into public JS bundle)

### Playwright
- Installed: `/home/admin/.openclaw/workspace/node_modules/playwright`
- Browser: Chrome Headless Shell 145 (arm64), cached at `~/.cache/ms-playwright/`
- Status: ✅ Working (confirmed 2026-03-16)
- DNS note: Sandbox blocks raw DNS for Node/Chromium. Use IP addresses or a workaround for external URLs. `web_fetch` uses privileged routing and works fine for simple fetches.
- Use for: JS-rendered pages, login-walled sites, form automation, screenshots
- Launch flags: always include `--no-sandbox` on the Pi

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.
