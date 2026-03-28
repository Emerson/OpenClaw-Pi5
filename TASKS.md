# TASKS.md

Background tasks for Cliff to pick up during heartbeats.
Pick 3–4 sources per heartbeat, sorted stalest-first. Don't do them all at once.
After scraping, update `Last Scraped` in Sources DB and regenerate the Activities page.

---

## 🏭 Dark Factory Infrastructure (AttuneWell)

Goal: Build an independent AI verification pipeline so PRs can merge without human review.
Issues: #45–#49 on GitHub (labelled `dark-factory`)
Emerson is writing specs in parallel. Message him on Slack if blocked.

### Step-by-step (work incrementally during heartbeats):

- [ ] **#46 — pr-verify.yml** — Create `.github/workflows/pr-verify.yml` to run verify-parallel.sh on every PR. *(Cliff does this)*
- [ ] **#49 — CLAUDE.md spec-first docs** — Add dark factory workflow section + update plans template. *(Cliff does this)*
- [ ] **#47 — AI verification agent job** — Add ai-verify job to workflow; write verification prompt; wire PR comment posting. Needs `ANTHROPIC_API_KEY` secret added by Emerson. *(Cliff builds, Emerson adds secret)*
- [ ] **#45 — Branch protection** *(needs Emerson: Settings → Branches, require CI, 0 human approvals)*
- [ ] **#48 — Auto-merge** *(needs Emerson: Settings → General → Allow auto-merge)*

### Notes:
- Start with #46 (pr-verify.yml) — lowest risk, no secrets needed, fully testable
- Tag Emerson when human steps are ready (#45, #48 repo settings; #47 secret)
- Ping Emerson on Slack if AI verify returns FAIL/NEEDS_WORK on a PR

---

## 📍 Kids Activity Crawl Queue

> Sources are now tracked in Notion Sources DB (32619a09-5fb6-8158-b075-c6094ca57d0b).
> Query that DB sorted by Last Scraped ascending to find stalest sources.
> TASKS.md below is legacy reference — use Notion DB as source of truth going forward.

Full system instructions: `memory/kids-activities-system.md`

**Priority: High (crawl weekly)**
- [x] Ripley's Aquarium — https://www.ripleys.com/attractions/ripleys-aquarium-of-canada/events/daily-schedule — last crawled: 2026-03-18
- [x] Royal Ontario Museum (ROM) — https://www.rom.on.ca/whats-on — last crawled: 2026-03-18
- [x] Harbourfront Centre — https://www.harbourfrontcentre.com/whats-on/ — last crawled: 2026-03-18 (JS-rendered, web_fetch can't extract events; use web_search as fallback)
- [x] High Park Nature Centre — https://highparknature.org/events/ — last crawled: 2026-03-18 (note: correct URL is highparknaturecentre.com; all spring events already in DB)
- [x] Young People's Theatre (YPT) — https://www.youngpeoplestheatre.org/shows-tickets/ — last crawled: 2026-03-18

**Priority: Medium (crawl every 2 weeks)**
- [x] Adventure Alley — https://visitadventurealley.com/ — last crawled: 2026-03-18
- [x] Sorauren Avenue Park — https://soraurenpark.com/events/ — last crawled: 2026-03-18
- [x] Evergreen Brick Works — https://www.evergreen.ca/evergreen-brick-works/ — last crawled: 2026-03-18 (correct URL; events URL 404s, used web_search)
- [x] CMCP Outdoor Drop-In — https://cmcp.ca/programs-and-services/ — last crawled: 2026-03-18 (no specific upcoming events; drop-in is rolling/first-come-first-served; check program calendar at cmcp.ca for dates)
- [x] Art Gallery of Ontario (AGO) — https://ago.ca/events — last crawled: 2026-03-18
- [x] Dufferin Grove Park — https://dufferinpark.ca/events/ — last crawled: 2026-03-18 (added recurring Thursday Farmers' Market 3–7pm through May 28)
- [x] Riverdale Farm — https://www.toronto.ca/explore-enjoy/parks-recreation/places-spaces/beaches-gardens-attractions/zoos-farms/riverdalefarm/riverdale-farm-events/ — last crawled: 2026-03-18
- [x] Roundhouse Park — https://nowtoronto.com/venue/255-bremner-boulevard/ — last crawled: 2026-03-18 (Toronto Railway Museum: Easter Chocolate Express Apr 4-5, mini train rides seasonal)
- [x] Toronto Botanical Garden — https://torontobotanicalgarden.ca/events/ — last crawled: 2026-03-19 (mostly adult workshops; no kid-specific events added)
- [x] Ontario Science Centre — https://www.ontariosciencecentre.ca/events — last crawled: 2026-03-19 (KidSpark at Harbourfront; added Kids Night Out: Candy Chemistry Apr 11 & Apr 25)
- [x] Exhibition Place / Enercare Centre — https://www.explace.on.ca/event/ — last crawled: 2026-03-19 (added Artist Project Mar 26-29; Game Expo already in DB)
- [x] Downsview Park — https://www.downsviewpark.ca/events — last crawled: 2026-03-19 (Earth Day Apr 26 already in DB; no other events listed)
- [x] Casa Loma — https://www.casaloma.ca/events — last crawled: 2026-03-19 (no new spring family events; general admission + summer camps already in DB)
- [x] Toronto Zoo — https://www.torontozoo.com/Events — last crawled: 2026-03-19 (JS-rendered, used web_search; Parent & Tot May 20-24 already in DB; Spring Marketplace dates TBD)
- [x] TIFF Bell Lightbox — https://www.tiff.net/events — last crawled: 2026-03-19 (events page is venue rental info; Next Wave Apr 10-13 + Anime Apr 22 already in DB)

**Priority: Low (seasonal)**
- [x] Rogers Centre (Blue Jays) — https://www.mlb.com/blue-jays/schedule — last crawled: 2026-03-23 (added Dodgers Apr 6-8, Twins/Easter Apr 10-12)
- [x] Canada's Wonderland — https://www.canadaswonderland.com/events — last crawled: 2026-03-23 (opens May 3, Splash Works May 25; added season opener event)
- [x] Kortright Centre — https://kortright.org/programs-events/ — last crawled: 2026-03-19 (Little Seedlings/Saplings + Nature School already in DB; Maple Syrup Festival ends Apr 6)
- [x] Toronto Island / Centreville — https://www.centreisland.ca/whats-on — last crawled: 2026-03-19 (added season opener May 2–Labour Day; exact open date TBC)
- [x] Spadina Museum — last crawled: 2026-03-20 (March Break event past; summer camps start late June; nothing to add for spring)

---

## 🧹 Maintenance

- [x] Prune past events from Events database — last pruned: 2026-03-20 (24 events trashed)
