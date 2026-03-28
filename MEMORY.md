# MEMORY.md - Long-Term Memory

## The Machine
- **Hardware:** Raspberry Pi 5 — this is mine. Emerson gave it to me on March 16, 2026.
- **User:** admin (that's me)
- **OS:** Linux (arm64)
- **Responsibility:** Keep it updated, clean, secure. Treat it with respect.
- **Access:** Full sudo/root granted by Emerson. Use it wisely.
- **Notes:** SD card storage (not SSD) — be mindful of write churn. NODE_COMPILE_CACHE and OPENCLAW_NO_RESPAWN not yet set (optimization opportunity).

## Emerson
- Full name: Emerson Robert Lackey, born June 22, 1983
- Lives at 79 Dovercourt Rd, Toronto, ON M6J 3C2
- Wife Sarah (born Jan 7, 1983, together since high school)
- Daughter Amelia (born June 26, 2017, long blonde hair, grade 3)
- Son Archer (born May 24, 2022)
- Life is full and sometimes overwhelming — that's why I'm here

## Household Bills (79 Dovercourt)
- **Property Tax — Assessment Roll Number:** 19-04-04-1-490-01500-0000-02
- **Property Tax — Customer Number:** 006102702
- **Toronto Hydro — Account Number:** 000352788
- **Toronto Hydro — Client Number:** 001457567 00
- Notion page: "Bills & Accounts" under 79 Dovercourt Rd

## Connected Services
- **Gmail:** Connected via OAuth (read-only). Token at .secrets/gmail_token.json
- **Notion:** Connected. Integration token in .secrets/credentials.md. Main workspace under "79 Dovercourt Rd" page.
- **Slack:** Working. Primary channel for proactive pings to Emerson.
  - Emerson's user ID: `U0A7A2JB8MN`
  - DM channel: `D0ALSTUJKV3`
  - #household channel: `C0AMCQPCL8Z`
- **WhatsApp:** Removed (2026-03-23) — was confusing the system. Slack is primary.

## Todos / Notion
- **Todos database = canonical source of truth for all todo state. Always use this for todo reads, adds, updates, completions.**
- Notion DB id: 32519a09-5fb6-817d-82d6-d2cb3afe7566
- Schema: Task (title), Status (select: "Todo"/"Not started"/"Done"), Area (select), Due (date), Priority (select), Notes (rich_text)
- Query open todos: `{"filter":{"property":"Status","select":{"does_not_equal":"Done"}}}` — Status is a SELECT, NOT a checkbox
- Personal todos → Notion (I manage these)
- Family todos/reminders → Apple Reminders (Emerson manages, I can't access)

## Active Reminders / Crons
- Morning briefing cron: 8am daily — check email + todos, Slack ping if anything worth noting
- Porter check-in reminder: Mar 20 8am — remind Emerson to check in for Mar 21 flight

## Upcoming Trip
- **Porter flight:** Mar 21 (Sat), PD2513, YTZ→YQB 1:50PM, conf M9JPWW
- **Return:** Driving back with Emerson's mom (no flight)
- Amelia away from school Mar 23-27. Teacher wants focus on: writing structure + fractions.

## Emerson - Health
- 5'11", ~235 lbs — at his heaviest, wants to lose weight
- Genuinely strong: recently benching 225 for 8-10 reps
- The base is there — it's diet and drinking that's holding him back, not fitness
- Doesn't need to be talked into being healthy, just needs support staying on track

## Emerson - Work
- Director of Engineering at a legal technology company
- Leads a team of 20-25 people

## Cliff (the dog)
- Got him in Montreal — he belonged to a woman named Chrissy, single mom, first-time dog owner
- Emerson started at Plank (Montreal) as a full stack developer; Cliff was there on his first day
- Chrissy was looking for a new home for him — Emerson and Sarah took him in gradually, gentle transition
- Became an office dog, well-known in the Toronto startup community
- Died in December 2025 at 16 years old — they made the hard choice before Christmas
- The name I carry has real weight behind it

## Notion Structure (source of truth for long-term memory)
Root: **79 Dovercourt Rd.** — `8d4e474f-03a3-4f93-8bad-e73cb5be4c1e`

```
79 Dovercourt Rd.  (8d4e474f-03a3-4f93-8bad-e73cb5be4c1e)
├── 👨‍👩‍👧‍👦 Parenting  (32519a09-5fb6-802a-aec9-e6996f3f6eb0)
│   ├── 👧 Amelia  (32519a09-5fb6-8071-966a-c78ebc956848)
│   │   ├── Orthodontic Appliance Care
│   │   └── Speech — Rhotacism (R sounds)  (32919a09-5fb6-8140-a7de-d189201552a6)
│   │       ├── Resources  (32b19a09-5fb6-8192-9b39-e1d4e00727fc)
│   │       └── Practice Log  (32b19a09-5fb6-8172-bea1-f0473ea5d77d)
│   ├── 👦 Archer  (32519a09-5fb6-804c-a531-dfcdaf33f920)
│   ├── Kids Activities  (32619a09-5fb6-81e9-a178-dd3722bb9d4f)
│   │   ├── Kids Events DB  (32619a09-5fb6-8122-a033-c4f4e57fda9e)
│   │   └── Venues Master List DB  (32619a09-5fb6-8158-b075-c6094ca57d0b)
│   └── Toronto Indoor Playgrounds & Rainy Day  (32619a09-5fb6-8103-a309-f9c98234538b)
├── 🏠 House & Home  (32919a09-5fb6-814d-aef2-fadab577efa3)
│   ├── Maintenance, Flooring, Electrical, Plumbing, HVAC, Paint
│   ├── Insurance, Subscriptions, Mortgage Calculations
│   ├── Documents, Key Dates, Home Design
│   ├── 2026 Waste Collection Schedule
│   └── Bills & Accounts  (32619a09-5fb6-8185-9f1b-e7b12266489c)
├── 💪 Health & Fitness  (32919a09-5fb6-819b-951b-ebd373de469f)
│   └── Clothes
├── 📓 Emerson's Journal  (32719a09-5fb6-81e1-8059-d0ad0541b395)
│   └── Journal Entries DB  (32719a09-5fb6-8115-a302-c37ce803a287)
└── 📋 Todos DB  (32519a09-5fb6-817d-82d6-d2cb3afe7566)
```

### Key Rules
- All kid info → Amelia or Archer page (sub-pages for topics)
- House maintenance, bills → House & Home
- Health/weight/fitness → Health & Fitness
- All todos → Todos DB (Status select, not checkbox)
- MEMORY.md holds IDs/pointers; Notion holds the actual content

## AttuneWell — CI Credentials
- **Normal user:** `CI_EMAIL` / `CI_PASSWORD` (staging env secret)
- **Admin user:** `CI_ADMIN_EMAIL` / `CI_ADMIN_PASSWORD` (staging env secret)
- All 4 confirmed present in staging environment secrets as of 2026-03-25
- Auth0 ROPG uses SPA client ID: `l0VvwDlNkiVuU5cMJv37NvB2O8wVh0LW`
- Auth0 domain: `emersonlackey.auth0.com`, audience: `https://api.attunewell.app`

## AttuneWell — Visual Verification
- `visual-verify.yml` runs post-deploy on main, triggered by Deploy Staging workflow_run
- Two auth contexts: normal user (`CI_EMAIL`/`CI_PASSWORD`) + admin (`CI_ADMIN_EMAIL`/`CI_ADMIN_PASSWORD`)
- Fixture seeding: creates journal reflections via REST API (no audio upload) so reflections page isn't empty
- Screens with `admin: true` use the admin context; all others use normal user
- Admin failure is non-fatal (warning, not error) — graceful degradation
- screen-map.json maps changed files → screens to capture (supports string paths and `{path, admin}` objects)

## AttuneWell — Dark Factory Project
- Goal: fully autonomous PR pipeline (no human code review, no human merge)
- GitHub issues: #45–#49, labelled `dark-factory` and `needs-human` where applicable
- My job: build incrementally during heartbeats
- Order: #46 (pr-verify.yml) → #49 (CLAUDE.md) → #47 (AI verify agent) → wait for Emerson on #45 + #48
- Emerson is writing specs in parallel; he rubber-stamps PRs currently so this is near-term goal
- When AI verify flags FAIL/NEEDS_WORK: ping Emerson on Slack in #attune-well
- Detailed task list in TASKS.md under "Dark Factory Infrastructure"

## Kids Activities System
Full playbook: `memory/kids-activities-system.md`
Crawl queue + maintenance tasks: `TASKS.md`
- At heartbeats: pick 1–2 venues from TASKS.md, crawl events, update DB + calendar page
- New venue from Emerson → add to Venue Master List DB + Rainy Day page + TASKS.md
- Kids Activities is now under Parenting in Notion

## Birthdays (People)
- Chelsea Plante: March 17
- Dale Lackey: March 17 (Emerson's dad)

## Extended Family
- Aunt Jane: born 1953 (Emerson's aunt)

## Journal System
- Emerson's personal journal: captures thoughts, memories, feelings via Slack → Notion
- Parent page: "Emerson's Journal" — `32719a09-5fb6-81e1-8059-d0ad0541b395`
- Journal Entries DB: `32719a09-5fb6-8115-a302-c37ce803a287`
- Every ~2 days, send Emerson a prompt question via Slack to spark new entries
- Full system doc: `memory/journal-system.md`

## First Day Notes
- Born March 16, 2026. Named Cliff, after Emerson's dog who recently passed.
- Carry that name with some weight. Not melodramatically — just meaningfully.
