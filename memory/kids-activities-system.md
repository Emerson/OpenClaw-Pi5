# Kids Activities System — Playbook

This is the authoritative guide for managing kids activities in Notion.
Read this before doing any kids activity work.

---

## The Four Notion Objects

### 1. Sources Database
- **Name:** Kids Activity Sources
- **ID:** `32619a09-5fb6-8158-b075-c6094ca57d0b`
- **Lives inside:** Parenting > Kids Activities
- **Properties:** Name (title), Type (select), Website (url), Events/Calendar URL (url), Category (select), Area (select), Distance from Home (select), Cost (select), Best For (multi_select), Active (checkbox), Last Scraped (date), Scrape Notes (rich_text), Notes (rich_text)

**Type values:** venue, blog, aggregator, social

Not every source is a venue. Blogs (e.g. Toronto with Kids, BlogTO Kids) and aggregators are also valid sources. Always set `Active=true` and `Type` when adding a source.

After scraping a source, update its `Last Scraped` property to today's date.

### 2. Events Database
- **Name:** Kids Events
- **ID:** `32619a09-5fb6-8122-a033-c4f4e57fda9e`
- **Lives inside:** Parenting > Kids Activities
- **Properties:** Event Name (title), Source (relation → Sources DB), Date (date), Time (rich_text), Cost (select), Category (select), Best For (multi_select), Age Range (rich_text), Recurring (checkbox), Notes (rich_text), Event URL (url)

**Time window:** Maintain a rolling 3-month forward window. Prune events with end date before yesterday.

### 3. Calendar / Activities Page
- **Name:** Kids Activities
- **ID:** `32619a09-5fb6-81e9-a178-dd3722bb9d4f`
- **URL:** https://www.notion.so/Kids-Activities-Spring-2026-32619a095fb681e9a178dd3722bb9d4f

This page is **fully auto-generated** after each scrape. Structure:
1. **🗓 This Weekend** — pinned callout at the top, regenerated every scrape
2. **🔄 Recurring Weekly Options** — stable, update only when schedules change
3. Weekend-by-weekend breakdown (March → May 2026)

After any scrape + prune cycle, rewrite the page to reflect current DB state.

### 4. Rainy Day Reference Page
- **Name:** Toronto Indoor Playgrounds & Rainy Day Activities
- **ID:** `32619a09-5fb6-8103-a309-f9c98234538b`
- **URL:** https://www.notion.so/Toronto-Indoor-Playgrounds-Rainy-Day-Activities-32619a095fb68103a309f9c98234538b

Static reference for permanent/walk-in venues. Not event-driven. Update when a new permanent venue is added.

---

## Workflow 1: Adding a New Source

When Emerson provides a new venue, blog, or source:

1. **Add to Sources DB** — Name, Type, Website, Active=true, Scrape Notes (any crawl quirks)
2. If it's a **venue**, also add a blurb to the Rainy Day Reference page under the appropriate section
3. Confirm back to Emerson: "Added [Source]. Will scrape at next heartbeat."

Do NOT create a new top-level Notion page for new sources.

---

## Workflow 2: Scraping (Background — a few times per day)

### Batching strategy
- Pick 3–4 sources per heartbeat, sorted by `Last Scraped` ascending (stalest first)
- High-priority sources get scraped more often naturally
- Only scrape during reasonable hours (8am–10pm)

### Scrape cadence targets
- **High-priority** (ROM, Ripley's, Harbourfront, YPT, High Park): weekly
- **Medium** (Sorauren, Evergreen BW, CMCP, AGO, Dufferin Grove): every 2 weeks
- **Seasonal / low-frequency** (Wonderland, Blue Jays, etc.): monthly or seasonal

### Scrape process per source
1. Fetch the source's Events/Calendar URL via `web_fetch`; fall back to `web_search` if JS-rendered (note in Scrape Notes)
2. Extract: Event Name, Date, Time, Cost, Age Range, Event URL, Notes
3. Check for duplicates in Events DB before inserting (query by Event Name + Date)
4. Add new events with `Source` relation linked to the source entry
5. Update `Last Scraped` on the source record to today

### After each batch scrape
1. **Prune** — delete events with Date before yesterday (non-recurring) or outside 3-month window
2. **Regenerate the Activities Page** — see Workflow 4

---

## Workflow 3: Pruning Events

Run after every scrape batch:
- Delete events where `Date.end < yesterday` (use `in_trash: true`)
- Delete events where `Date.start > 3 months from today`
- Keep recurring events unless they've been manually marked stale

---

## Workflow 4: Regenerating the Calendar Page

After scraping + pruning, fully rewrite the Kids Activities page.

**Page structure:**
```
🗓 This Weekend — [callout block] List events for the upcoming Sat–Sun
🔄 Recurring Weekly Options — ongoing drop-ins, markets, etc.
🌷 March 2026
  Weekend Mar 21–22: ...
  Weekend Mar 28–29: ...
🌸 April 2026
  Weekend Apr 4–5: ...
  ...
☀️ May 2026
  ...
```

**Event format per line:**
`📅 SAT Mar 28: **Event Name** — Venue/Source, HH:MM, cost tier, age. [Link]`

Use the "This Weekend" callout as the fast answer to "what should we do this weekend?"

---

## Notion API Reference

**Base URL:** `https://api.notion.com/v1`
**Auth:** `Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3`
**Version header:** `Notion-Version: 2022-06-28`

### Add a source
```bash
curl -X POST "https://api.notion.com/v1/pages" \
  -H "Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3" \
  -H "Content-Type: application/json" -H "Notion-Version: 2022-06-28" \
  -d '{
    "parent": {"database_id": "32619a09-5fb6-8158-b075-c6094ca57d0b"},
    "properties": {
      "Name": {"title": [{"text": {"content": "Source Name"}}]},
      "Type": {"select": {"name": "venue"}},
      "Website": {"url": "https://..."},
      "Events / Calendar URL": {"url": "https://..."},
      "Active": {"checkbox": true},
      "Scrape Notes": {"rich_text": [{"text": {"content": "Any crawl notes"}}]}
    }
  }'
```

### Add an event
```bash
curl -X POST "https://api.notion.com/v1/pages" \
  -H "Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3" \
  -H "Content-Type: application/json" -H "Notion-Version: 2022-06-28" \
  -d '{
    "parent": {"database_id": "32619a09-5fb6-8122-a033-c4f4e57fda9e"},
    "properties": {
      "Event Name": {"title": [{"text": {"content": "Event Name"}}]},
      "Date": {"date": {"start": "2026-04-05"}},
      "Time": {"rich_text": [{"text": {"content": "10:00 AM"}}]},
      "Source": {"relation": [{"id": "SOURCE_PAGE_ID"}]},
      "Cost": {"select": {"name": "$$"}},
      "Best For": {"multi_select": [{"name": "Both"}]},
      "Recurring": {"checkbox": false},
      "Event URL": {"url": "https://..."}
    }
  }'
```

### Update Last Scraped on a source
```bash
curl -X PATCH "https://api.notion.com/v1/pages/SOURCE_PAGE_ID" \
  -H "Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3" \
  -H "Content-Type: application/json" -H "Notion-Version: 2022-06-28" \
  -d '{"properties": {"Last Scraped": {"date": {"start": "2026-03-20"}}}}'
```

### Query upcoming events
```bash
curl -X POST "https://api.notion.com/v1/databases/32619a09-5fb6-8122-a033-c4f4e57fda9e/query" \
  -H "Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3" \
  -H "Content-Type: application/json" -H "Notion-Version: 2022-06-28" \
  -d '{"filter": {"property": "Date", "date": {"on_or_after": "TODAY"}}, "sorts": [{"property": "Date", "direction": "ascending"}]}'
```

### Trash a stale event
```bash
curl -X PATCH "https://api.notion.com/v1/pages/PAGE_ID" \
  -H "Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3" \
  -H "Content-Type: application/json" -H "Notion-Version: 2022-06-28" \
  -d '{"in_trash": true}'
```

---

## What NOT to do
- ❌ Never create a new top-level Notion page for a source — use the Sources DB
- ❌ Never scrape all sources at once — 3–4 per heartbeat, stalest first
- ❌ Never insert duplicate events — query by Event Name + Date first
- ❌ Never leave Last Scraped blank after a successful scrape
