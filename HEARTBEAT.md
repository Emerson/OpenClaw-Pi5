# HEARTBEAT.md

## Morning Briefing (8am daily) — ALWAYS SEND
- **Never skip. Never NO_REPLY. Always send a Slack message.**
- Pull ALL calendars: `GOG_KEYRING_PASSWORD="cliff" GOG_ACCOUNT=emerson.lackey@gmail.com gog cal events --calendars "1,2,3,6,7,8" --from today --days 2 --max 50 -p`
- Include: events, appointments, birthdays, anything on any calendar
- Check Gmail for key emails (school, family, financial, anything needing response — skip marketing/newsletters/receipts)
- On weekends (Sat/Sun): check Notion Kids Events DB (32619a09-5fb6-8122-a033-c4f4e57fda9e) for upcoming kids events
- If nothing notable: still send — good morning + system status (Pi uptime, last cron run, etc.)
- Format: greeting → today's calendar → tomorrow's calendar → emails → kids events (weekends) → system status if quiet

## Email Check (3x daily)
- Check Gmail for important/urgent emails
- Ping Emerson on Slack ONLY if something needs attention
- Ignore: marketing, newsletters, automated notifications, receipts
- Flag: anything from school, family, financial institutions, anything requiring a response

## Notion Todos (DB: 32519a09-5fb6-817d-82d6-d2cb3afe7566)
- Query open todos using Status select != "Done"
- Ping on Slack if something is due today or tomorrow and not done

## AttuneWell — Dark Factory (every heartbeat, reasonable hours)
- Repo: `/home/admin/.openclaw/workspace/attunewell`
- Dark factory infrastructure is **complete** (merged 2026-03-23, PR #50). Pipeline is live.
- Check `memory/attunewell-log.md` for current status

### What to do each heartbeat:
1. **Check open GitHub issues** — any specs ready to implement? Spin up a coding agent to build it as a PR through the pipeline.
2. **Code quality sweep (every 2nd heartbeat)** — look for easy wins: dead code, TODO comments, inconsistent patterns, missing tests, obvious optimizations. Open a PR for anything clean and low-risk.
3. **Monitor open PRs** — check if any PRs have AI verify returning FAIL/NEEDS_WORK. If so, ping Emerson on Slack in #attune-well with details.
4. **Check CI** — any red branches? Flag immediately.
5. **ALWAYS ping #attune-well (C0A7J6YJSKZ) every single run** — even if nothing changed. A brief "all clear + here's what I checked" is better than silence. No exceptions.

### Code quality sweep approach:
- Focus on backend first (Python/FastAPI)
- Look for: N+1 queries, missing indexes, unused imports, inconsistent error handling, undocumented endpoints, hardcoded values that should be config
- Open small focused PRs — one concern per PR, easy for AI verify to evaluate
- Skip anything touching auth, payments, or data migrations without checking with Emerson first

## Background Tasks (Kids Activity Crawl)
- At each heartbeat during reasonable hours (8am–10pm), crawl 1–2 kid activity sources
- **Source of truth: Notion Sources DB (32619a09-5fb6-8158-b075-c6094ca57d0b)** — NOT TASKS.md
- Query the DB sorted by Last Scraped ascending to find the stalest sources
- After scraping: update `Last Scraped` on the source record, prune past events, regenerate the Activities page
- Full playbook: `memory/kids-activities-system.md`
- TASKS.md is legacy reference only — do not rely on its checkboxes

## Journal Prompts
- Check `memory/journal-system.md` for next prompt due date
- If due, send one prompt question to Emerson via Slack
- Update "Last prompt sent" and "Next prompt due" in journal-system.md after sending
- Don't send prompts after 10pm or before 9am

## Rules
- DO NOT ping for routine stuff
- Late night (11pm-8am): only urgent
- One ping per topic per day max
- Keep Slack messages short and actionable
