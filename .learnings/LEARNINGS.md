# Learnings

## [LRN-20260316-001] best_practice

**Logged**: 2026-03-16T23:25:00-04:00
**Priority**: high
**Status**: resolved
**Area**: infra

### Summary
Pi DNS resolution broken for Node/Python/Chromium despite ping working — router DNS was silently failing

### Details
On this Raspberry Pi 5, `ping google.com` worked but Node, Python socket, and Chromium all failed to resolve DNS. Root causes:
1. `/etc/nsswitch.conf` had `mdns4_minimal [NOTFOUND=return]` which short-circuits DNS after mDNS fails
2. Router at `192.168.2.1` was silently failing DNS queries

### Suggested Action
Always use `8.8.8.8`/`8.8.4.4` as primary DNS on this Pi. Lock `/etc/resolv.conf` with `chattr +i` and disable NetworkManager DNS management.

### Resolution
- **Resolved**: 2026-03-16T23:25:00-04:00
- **Notes**: Fixed nsswitch.conf, set resolv.conf to 8.8.8.8/8.8.4.4, locked with `chattr +i`, disabled NM DNS via `dns=none` in NetworkManager.conf

### Metadata
- Source: error
- Tags: dns, networking, raspberry-pi, playwright, node
- Pattern-Key: infra.dns_resolution_broken

---

## [LRN-20260316-002] best_practice

**Logged**: 2026-03-16T23:28:00-04:00
**Priority**: medium
**Status**: resolved
**Area**: config

### Summary
Gateway restart kills active session — use deferred nohup to restart

### Details
Running `systemctl --user restart openclaw-gateway.service` from within an exec tool call kills the gateway mid-command, causing SIGTERM. Must defer the restart.

### Suggested Action
Always use: `nohup bash -c 'sleep 2 && systemctl --user restart openclaw-gateway.service' > /dev/null 2>&1 &`

### Metadata
- Source: error
- Tags: openclaw, gateway, systemctl
- Pattern-Key: infra.gateway_restart

---

## [LRN-20260320-001] correction

**Logged**: 2026-03-20T08:35:00-04:00
**Priority**: high
**Status**: promoted
**Area**: config

### Summary
Morning briefings must always include a full calendar pull across all of Emerson's calendars.

### Details
The Mar 20 morning briefing was sent without pulling calendar data. It missed Archer's 9am dental appointment, Birthday Brunch for Judy (11am-2pm), Birthday Lunch for Judy (3pm-5pm), and Dale Lackey's birthday. Emerson corrected this explicitly.

### Suggested Action
Always run `gog cal events --calendars "1,2,3,6,7,8" --from today --days 2` as part of every morning briefing. Calendar data is not optional — it is a core component of the briefing.

### Metadata
- Source: user_feedback
- Tags: morning-briefing, calendar, correction
- Related Files: HEARTBEAT.md, TOOLS.md

---
