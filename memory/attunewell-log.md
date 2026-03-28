# AttuneWell Activity Log

Tracks what Cliff has done on the AttuneWell project during heartbeats and sessions.

---

## 2026-03-23

### Dark Factory Infrastructure
- Created plan spec files for issues #45–#49 (dark factory pipeline)
- Issues filed on GitHub: #45 (branch protection), #46 (pr-verify.yml), #47 (AI verify agent), #48 (auto-merge), #49 (CLAUDE.md spec-first)
- PR #50 opened: `feat: AI spec verification agent + dark factory workflow docs`
  - Status: CI failures — Postgres auth error in test suite + coverage below 80%

### PR Activity
- PR #51 (`fix: update remaining name→first name copy in AccountInfoSection`) — manually triggered merge after all checks passed (auto-merge wasn't set on the PR itself)
- Lesson: must call `gh pr merge --auto --squash` when creating PRs going forward

---

## 2026-03-24 (morning)

### Issue #56 Filed
- Problem: Therapy style badge overflows on ReflectionsPage for long names like "Emotionally Focused Therapy (EFT)"
- Spec written at: `plans/frontend/therapy-style-badge-fix/README.md`
- Solution: Pure CSS truncation (`max-w-[10rem] truncate whitespace-nowrap`) + ShadCN Tooltip
- No backend changes needed — only `ReflectionsPage.tsx`

### CI Status
- PR #53 (`fix/issue-36-error-recovery`) — Verify running, AI Verify passed ✅
- PR #55 (`feat/ai-verifier-two-phase`) — AI Verify failed ❌ (expected: new workflow file can't self-verify on first PR; needs merge to main first)

### Blockers
- Google OAuth tokens (Gmail + Calendar) expired — need re-auth from Emerson

### 8:00am Update
- PRs #52 (Settings UI) and #53 (Error Recovery) confirmed merged ✅
- New open PRs: #55 (two-phase AI verifier, behind main) and #57 (badge overflow fix, CI running)
- PR #55 AI Verify failure is expected — workflow validation guard when verifier is changing itself
- PR #57 Verify failed — Prettier formatting issue in tooltip.tsx. Fixed and pushed (commit b67ff1d). CI re-running.

### 11:30am Update
- PR #57 merged at 13:33 UTC ✅ — staging deployed
- PR #55 still open (two-phase verifier)
- Spinning Claude Code agent on issue #39 (Frontend SSE Real-time Pipeline Updates)
  - ProcessingReflectionView still polls every 2s — needs to use PipelineProgress + usePipelineEvents
  - Branch: fix/issue-39-sse-frontend

---

## 2026-03-27

### Speaker Binding Bug Investigation

Root cause identified: reflections processed before PR #74 (`speakers_expected=2`) may have 0 speakers because AssemblyAI defaulted to single-speaker diarization. The `create_transcript_with_diarization` idempotency guard prevents re-processing on standard retry.

### PRs Opened Today

**PR #77** — `fix: hide Confirm Speakers button when transcript has no speakers`
- Branch: `fix/speaker-confirm-hide-when-no-speakers`
- One-line fix: added `&& speakers.length > 0` guard to footer button in `MobileSpeakerSheet.tsx`
- Status: ✅ **MERGED & DEPLOYED** to staging (Deploy Staging completed ~19:35 UTC)

**PR #78** — `feat: admin force reprocess with speaker override params`
- Branch: `feat/admin-force-reprocess`
- Full feature: new `POST /admin/reflections/{id}/force-reprocess` endpoint + admin UI modal
- Clears transcript/speakers/segments/annotations/feedback/insights, then re-dispatches AssemblyAI with optional `speakers_expected` override
- Status: CI running — AI Verify ✅, Verify + Claude Code Review in progress
- Auto-merge enabled — will land when CI passes

### Open Items / Watch
- Once #78 is on staging: use force reprocess on reflection `f13a148a-c9c5-406b-86b8-14daa20c560c` with `speakers_expected=2`

**PR #79** — `feat: user self-memory — Phase 2 of partner memory`
- Branch: `feat/user-self-memory`
- `SpeakerMemory.conversation_partner_id` made nullable — NULL = self-memory
- New `USER_SELF_MEMORY_SYSTEM_PROMPT`, `generate_user_self_memory()`, `/speaker-memories/self` endpoints
- Self-memory injected into feedback prompts alongside partner memory
- "Your Memory" panel on account/settings page
- Status: ✅ **MERGED & DEPLOYED** to staging (22:54 UTC)
