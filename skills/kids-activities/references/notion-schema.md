# Notion Schema & API Reference

**Base URL:** `https://api.notion.com/v1`
**Auth header:** `Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3`
**Version header:** `Notion-Version: 2022-06-28`

---

## Sources Database (`32619a09-5fb6-8158-b075-c6094ca57d0b`)

### Properties
| Property | Type | Notes |
|---|---|---|
| Name | title | Source/venue name |
| Type | select | `venue`, `blog`, `aggregator`, `social` |
| Website | url | Main site |
| Events / Calendar URL | url | Direct events/calendar page to scrape |
| Category | select | |
| Area | select | |
| Distance from Home | select | |
| Cost | select | |
| Best For | multi_select | |
| Active | checkbox | Always set true when adding |
| Last Scraped | date | Update to today after every successful scrape |
| Scrape Notes | rich_text | Crawl quirks (JS-rendered, URL 404s, etc.) |
| Notes | rich_text | General notes |

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

### Update Last Scraped
```bash
curl -X PATCH "https://api.notion.com/v1/pages/SOURCE_PAGE_ID" \
  -H "Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3" \
  -H "Content-Type: application/json" -H "Notion-Version: 2022-06-28" \
  -d '{"properties": {"Last Scraped": {"date": {"start": "YYYY-MM-DD"}}}}'
```

### Query sources sorted by Last Scraped (stalest first)
```bash
curl -X POST "https://api.notion.com/v1/databases/32619a09-5fb6-8158-b075-c6094ca57d0b/query" \
  -H "Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3" \
  -H "Content-Type: application/json" -H "Notion-Version: 2022-06-28" \
  -d '{
    "filter": {"property": "Active", "checkbox": {"equals": true}},
    "sorts": [{"property": "Last Scraped", "direction": "ascending"}]
  }'
```

---

## Events Database (`32619a09-5fb6-8122-a033-c4f4e57fda9e`)

### Properties
| Property | Type | Notes |
|---|---|---|
| Event Name | title | |
| Source | relation | Relation → Sources DB |
| Date | date | Can have start + end |
| Time | rich_text | e.g. "10:00 AM – 4:00 PM" |
| Cost | select | `Free`, `$`, `$$`, `$$$` |
| Category | select | |
| Best For | multi_select | `Amelia`, `Archer`, `Both` |
| Age Range | rich_text | e.g. "3–12" |
| Recurring | checkbox | true for weekly drop-ins, markets, etc. |
| Notes | rich_text | |
| Event URL | url | Direct link to event page |

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

### Query upcoming events
```bash
curl -X POST "https://api.notion.com/v1/databases/32619a09-5fb6-8122-a033-c4f4e57fda9e/query" \
  -H "Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3" \
  -H "Content-Type: application/json" -H "Notion-Version: 2022-06-28" \
  -d '{
    "filter": {"property": "Date", "date": {"on_or_after": "TODAY"}},
    "sorts": [{"property": "Date", "direction": "ascending"}]
  }'
```

### Check for duplicate (query by Event Name)
```bash
curl -X POST "https://api.notion.com/v1/databases/32619a09-5fb6-8122-a033-c4f4e57fda9e/query" \
  -H "Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3" \
  -H "Content-Type: application/json" -H "Notion-Version: 2022-06-28" \
  -d '{
    "filter": {
      "and": [
        {"property": "Event Name", "title": {"equals": "EVENT_NAME_HERE"}},
        {"property": "Date", "date": {"equals": "YYYY-MM-DD"}}
      ]
    }
  }'
```

### Trash a stale event
```bash
curl -X PATCH "https://api.notion.com/v1/pages/PAGE_ID" \
  -H "Authorization: Bearer ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3" \
  -H "Content-Type: application/json" -H "Notion-Version: 2022-06-28" \
  -d '{"in_trash": true}'
```

---

## Page IDs

| Page | ID | URL |
|---|---|---|
| Kids Activities (calendar) | `32619a09-5fb6-81e9-a178-dd3722bb9d4f` | https://www.notion.so/Kids-Activities-Spring-2026-32619a095fb681e9a178dd3722bb9d4f |
| Rainy Day Reference | `32619a09-5fb6-8103-a309-f9c98234538b` | https://www.notion.so/Toronto-Indoor-Playgrounds-Rainy-Day-Activities-32619a095fb68103a309f9c98234538b |
| Kids Activities (parent) | `32619a09-5fb6-81e9-a178-dd3722bb9d4f` | |
