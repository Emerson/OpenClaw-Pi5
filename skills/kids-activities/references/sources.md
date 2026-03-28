# Kids Activity Sources

All sources are also tracked in the Notion Sources DB (`32619a09-5fb6-8158-b075-c6094ca57d0b`).
The DB is the source of truth for `Last Scraped` dates. This file is reference context for crawl quirks.

---

## High Priority — Crawl Weekly

| Source | Events URL | Notes |
|---|---|---|
| Ripley's Aquarium | https://www.ripleys.com/attractions/ripleys-aquarium-of-canada/events/daily-schedule | |
| Royal Ontario Museum (ROM) | https://www.rom.on.ca/whats-on | |
| Harbourfront Centre | https://www.harbourfrontcentre.com/whats-on/ | JS-rendered — `web_fetch` can't extract events; use `web_search` as fallback |
| High Park Nature Centre | https://www.highparknaturecentre.com/events | Correct domain is `highparknaturecentre.com` (not highparknature.org) |
| Young People's Theatre (YPT) | https://www.youngpeoplestheatre.org/shows-tickets/ | |

---

## Medium Priority — Crawl Every 2 Weeks

| Source | Events URL | Notes |
|---|---|---|
| Adventure Alley | https://visitadventurealley.com/ | |
| Sorauren Avenue Park | https://soraurenpark.com/events/ | |
| Evergreen Brick Works | https://www.evergreen.ca/evergreen-brick-works/ | Events URL 404s — use `web_search` as fallback |
| CMCP Outdoor Drop-In | https://cmcp.ca/programs-and-services/ | No specific upcoming events; drop-in is rolling/first-come; check program calendar at cmcp.ca for dates |
| Art Gallery of Ontario (AGO) | https://ago.ca/events | |
| Dufferin Grove Park | https://dufferinpark.ca/events/ | Recurring Thursday Farmers' Market 3–7pm through May 28 |
| Riverdale Farm | https://www.toronto.ca/explore-enjoy/parks-recreation/places-spaces/beaches-gardens-attractions/zoos-farms/riverdalefarm/riverdale-farm-events/ | |
| Roundhouse Park | https://nowtoronto.com/venue/255-bremner-boulevard/ | Toronto Railway Museum on site — check for Easter Chocolate Express and seasonal mini train |
| Toronto Botanical Garden | https://torontobotanicalgarden.ca/events/ | Mostly adult workshops; filter for family/kids-specific |
| Ontario Science Centre | https://www.ontariosciencecentre.ca/events | KidSpark now at Harbourfront |
| Exhibition Place / Enercare Centre | https://www.explace.on.ca/event/ | |
| Downsview Park | https://www.downsviewpark.ca/events | |
| Casa Loma | https://www.casaloma.ca/events | Family events occasional; general admission always available |
| Toronto Zoo | https://www.torontozoo.com/Events | JS-rendered — use `web_search` as fallback |
| TIFF Bell Lightbox | https://www.tiff.net/events | Main events page is venue rental info; use `web_search` for family/kids screenings |

---

## Low Priority — Monthly or Seasonal

| Source | Events URL | Notes |
|---|---|---|
| Rogers Centre (Blue Jays) | https://www.mlb.com/blue-jays/schedule | Season Apr–Sep |
| Canada's Wonderland | https://www.canadaswonderland.com/events | Opens May 3; Splash Works May 25 |
| Kortright Centre | https://kortright.org/programs-events/ | Little Seedlings/Saplings + Nature School; Maple Syrup Festival ends Apr 6 |
| Toronto Island / Centreville | https://www.centreisland.ca/whats-on | Opens May 2–Labour Day; exact dates TBC |
| Spadina Museum | https://www.toronto.ca/explore-enjoy/history-art-culture/museums/spadina-museum/ | Summer camps start late June; occasional family events |

---

## Crawl Tips

- Always check `Events / Calendar URL` in the Sources DB first — it may differ from the main site
- If `web_fetch` returns empty or clearly wrong results, note it in `Scrape Notes` and use `web_search` instead
- For recurring events (markets, drop-ins), set `Recurring=true` so they survive pruning
- After scraping, always update `Last Scraped` in the Sources DB — this is how the heartbeat knows what's stale
