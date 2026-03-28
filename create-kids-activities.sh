#!/bin/bash
# Create Kids Activities page in Notion under 79 Dovercourt Rd

NOTION_TOKEN="ntn_y68792728861qhEo5Tmug90IfYQxRMDdCIqyoOzTPO1dC3"

curl -s -X POST "https://api.notion.com/v1/pages" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  -d @/home/admin/.openclaw/workspace/kids-activities-payload.json | python3 -m json.tool 2>/dev/null | grep -E '"id"|"url"|"object"' | head -5
