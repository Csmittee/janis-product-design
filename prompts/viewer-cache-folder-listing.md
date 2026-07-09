# cc Prompt — Viewer: Cache Model-Folder Listing (fix 429 rate limit)
# Date: 2026-07-09

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read: cc_rules.md → cc_chat_log.md (first 3 entries) → knowledge.map →
viewer/janis-product-viewer.html (fetchModelFolder / modelsFolder logic
only, from PR #106). State version read.

## 2. CONTEXT
Janis hit "429 Too Many Requests" from GitHub's Contents API — the
unauthenticated 60/hour limit, exactly the risk flagged in PR #106.
Caused by fetchModelFolder() re-querying GitHub on every load/project
switch during normal repeated use/testing.

## 3. NEW FILES
None.

## 4. TASKS

### TASK 1 — Cache the folder listing client-side
Cache fetchModelFolder()'s result in memory (per project) for a short
TTL — 5 minutes is reasonable, state whatever value you use. Repeated
calls within the TTL return the cached result, no new API call.

### TASK 2 — Add a manual "Refresh models" button
Add a small button near the file list/dropdown that force-bypasses the
cache and re-fetches immediately — so Janis can see a just-uploaded file
without waiting out the TTL.

### TASK 3 — Handle 429 gracefully if it still happens
If a fetch still returns 429 (cache expired, limit still hot), show a
clear message ("Rate limited, try again shortly") instead of a blank/
broken list, and keep showing the last successfully cached list if one
exists rather than clearing it.

## 5. DO NOT TOUCH
- Any `.scad` file
- PR-01's legacy STL system
- The `modelsFolder`/`fetchModelFolder` URL construction itself — cache
  wrapping only, don't change how/what it fetches

## 6. QA VERIFICATION
- [ ] Cache implemented, TTL stated
- [ ] Refresh button added, bypasses cache correctly
- [ ] 429 handled gracefully, last good list preserved
- [ ] PR-01 unaffected — confirmed

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/
3. Commit all → merge to main
