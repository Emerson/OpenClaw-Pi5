---
name: kids-activities
description: "Manages Toronto kids activity tracking in Notion — scraping events from venues and blogs, maintaining the Sources and Events databases, pruning stale events, and regenerating the Kids Activities calendar page. Use when: (1) scraping or crawling activity sources during heartbeats, (2) Emerson adds a new venue or source, (3) the Kids Activities page needs regeneration, (4) pruning old events, (5) anything related to kids events, Toronto venues, weekend activity planning for Amelia and Archer."
---

# Kids Activities

Manages a Notion-backed event tracking system for kids activities in Toronto.
Full Notion schema and API reference: `references/notion-schema.md`
Source list with crawl notes: `references/sources.md`

## Four Notion Objects

| Object | ID | Purpose |
|---|---|---|
| Sources DB | `32619a09-5fb6-8158-b075-c6094ca57d0b` | Venues, blogs, aggregators to crawl |
| Events DB | `32619a09-5fb6-8122-a033-c4f4e57fda9e` | Upcoming events (rolling 3-month window) |
| Activities Page | `32619a09-5fb6-81e9-a178-dd3722bb9d4f` | Auto-generated calendar page |
| Rainy Day Page | `32619a09-5fb6-8103-a309-f9c98234538b` | Static indoor/walk-in venue reference |

Notion token: `ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3`

---

## Workflow 1: Heartbeat Scrape

Run at each heartbeat during reasonable hours (8am–10pm). Pick 3–4 sources from the Sources DB sorted by `Last Scraped` ascending (stalest first).

### Per-source process
1. Fetch the source's `Events / Calendar URL` via `web_fetch`
2. If JS-rendered or no events extracted, fall back to `web_search` — note in `Scrape Notes`
3. For each event found:
   - Query Events DB by Event Name + Date to check for duplicates before inserting
   - Insert new events with `Source` relation linked to the source's page ID
4. Update `Last Scraped` on the source record to today's date

### After each batch
1. **Prune** — trash events where Date < yesterday (non-recurring) or Date > 3 months from today
2. **Regenerate** the Activities Page (see Workflow 3)

---

## Workflow 2: Adding a New Source

When Emerson provides a new venue, blog, or aggregator:

1. Add to Sources DB — Name, Type, Website, Active=true, Scrape Notes (any crawl quirks)
2. If it's a **venue**, add a blurb to the Rainy Day Reference page under the right section
3. Confirm back: "Added [Source]. Will scrape at next heartbeat."

Do NOT create a new top-level Notion page for the source.

---

## Workflow 3: Regenerating the Calendar Page

After every scrape + prune cycle, rewrite the **content blocks** of the Kids Activities page.

### ⚠️ Critical rules — read before touching any page
- **NEVER trash or delete the Activities Page or Rainy Day Page** — these are permanent pages that Emerson owns
- **NEVER use `in_trash: true` on a page** — only on individual event records in the Events DB
- To "rewrite" a page: fetch its existing child blocks, delete those blocks individually, then append fresh blocks
- The page itself (`32619a09-5fb6-81e9-a178-dd3722bb9d4f`) must always survive

### Block-replace procedure
1. `GET /v1/blocks/{page_id}/children` — list current child blocks
2. For each block ID returned: `DELETE /v1/blocks/{block_id}` — remove old content
3. `PATCH /v1/blocks/{page_id}/children` — append the new blocks

### Page structure
```
🗓 This Weekend — callout block with events for upcoming Sat–Sun
🔄 Recurring Weekly Options — ongoing drop-ins, markets, etc.
🌷 March 2026
  Weekend Mar 28–29: ...
🌸 April 2026
  Weekend Apr 4–5: ...
  ...
☀️ May 2026
  ...
```

**Event line format:**
`📅 SAT Mar 28: **Event Name** — Venue, HH:MM, cost tier, age. [Link]`

The "This Weekend" callout is the fast answer to "what should we do this weekend?" — always regenerate it.

---

## Scrape Priority & Cadence

- **Weekly:** ROM, Ripley's, Harbourfront, Young People's Theatre, High Park Nature Centre
- **Every 2 weeks:** AGO, Evergreen Brick Works, Sorauren, Dufferin Grove, Riverdale Farm, Toronto Botanical Garden, Roundhouse, Adventure Alley, CMCP, Casa Loma, Toronto Zoo, Exhibition Place, Downsview Park, Ontario Science Centre, TIFF
- **Monthly/seasonal:** Canada's Wonderland, Blue Jays/Rogers Centre, Toronto Island/Centreville, Kortright Centre, Spadina Museum

Full source list with URLs and crawl notes: `references/sources.md`

---

## What NOT to do
- ❌ **Never trash or delete the Activities Page or Rainy Day Page** — only delete individual child blocks when regenerating
- ❌ Never use `in_trash: true` on anything except stale event records in the Events DB
- ❌ Never scrape all sources at once — 3–4 per heartbeat, stalest first
- ❌ Never insert duplicate events — query by Event Name + Date first
- ❌ Never leave Last Scraped blank after a successful scrape
- ❌ Never create a top-level Notion page for a source
