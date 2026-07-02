# cc Prompt — RAPID: Amend CURRENT_STATE.md format + wire session-open reads
# Date: 2026-07-03
# Supersedes: nothing already merged is wrong, this ADDS to it. PR #75
# merged the first draft of CURRENT_STATE.md/rules-waivers.md before a
# later refinement in the same Claude Web session was captured. This
# prompt closes that gap. rules-waivers.md is correct as merged — do not
# touch it.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read: cc_rules.md → cc_chat_log.md (first 3 entries) → CURRENT_STATE.md
(current merged version) → WORKFLOW_SKILL.md → chat_rules.md → knowledge.map
State every file read before writing a single line.

## 2. CONTEXT

PR #75 merged CURRENT_STATE.md as a rigid "one entry per product,
conclusions only, no open items" file. In the same Claude Web session,
immediately after, Janis refined the design: CURRENT_STATE.md is a
"where we left off" resumption memo, not a status board — it must hold
open/unfinished items (things found but not yet decided), and it updates
on exactly ONE trigger: Janis explicitly confirming a pause, never on
ordinary task completion. That refinement, plus the WORKFLOW_SKILL.md/
chat_rules.md wiring to actually read this file at session-open, never
reached cc — this prompt delivers it.

Also found since PR #75 merged, during QA of PR #74: the leg socket is
NOT physically cut into the wood leg (`leg_socket()` draws the wood as one
solid cube, the socket sleeve as a separate overlapping tube — no boolean
difference removes wood for it). Janis has NOT decided whether to fix or
waive this — it belongs in CURRENT_STATE.md as an open item, explicitly
NOT in rules-waivers.md (a waiver requires Janis's explicit accept, this
does not have it yet).

## 3. NEW FILES
None. All three files below already exist (CURRENT_STATE.md, WORKFLOW_SKILL.md,
chat_rules.md merged via earlier PRs) — this prompt edits them in place.

## 4. TASKS

### TASK 1 — Replace `CURRENT_STATE.md` entirely with this content

```
# CURRENT_STATE.md
# Janis Product Design — Where We Left Off
# Last updated: 2026-07-03 by cc (rapid amendment on top of PR #75)
#
# UPDATE TRIGGER — read this before touching this file:
# This file is updated ONLY when Janis explicitly confirms a pause is
# starting (on any single product line, or the whole project). That
# confirmation is the ONLY trigger — never update this file just because
# a session or task ended, that would turn it into a second log. When
# Janis confirms a pause, cc (or Claude Web, if drafting a handoff) MUST
# update this file immediately, before the pause is considered complete.
#
# FORMAT — deliberately NOT one rigid line per product. Each entry holds
# whatever it takes to reconstruct exactly where things were left,
# including unfinished threads, open questions, things started but not
# decided. Structure below is a floor, not a ceiling.
#
# For raw session-by-session history, see cc_chat_log.md.
# For known-and-DELIBERATELY-ACCEPTED issues, see .claude/rules-waivers.md.
# Anything unresolved/undecided lives HERE, not in rules-waivers.md — a
# waiver requires Janis's explicit accept, an open item here does not.

## Vending Machine (VM-01) — DONE, dormant
Active: VM-01-base-v36.scad | Last confirmed good: v36, PASS
No open items.

## Pilates Reformer (PR-01) — PAUSED, awaiting customer
Active (confirmed): PR-01-assembly-v31.scad — base-file-consolidation
(PR #74) merged, zero visual/dimensional change from v30 (CSG-dump
md5sum-identical), so v30's F5/F6 confirmation still stands for v31.

Open items (unresolved, not yet decided by Janis):
- Socket is NOT physically cut into the wood leg. `leg_socket()` draws the
  wood leg as one fully solid cube and the socket sleeve as a separate
  tube occupying the same space — no boolean difference removes wood to
  make room for the sleeve. Looks correct in a colored render, would not
  be physically manufacturable as-is (no real cavity exists in the model).
  Found 2026-07-03, QA'd by Janis, NOT YET decided whether to fix now or
  waive — do not treat as accepted until Janis says so explicitly.
- W-001 dormant global-override pattern (44 instances) — see
  .claude/rules-waivers.md, already a formal waiver, cross-referenced here
  for visibility.

Next if resumed: read WORKFLOW_SKILL.md session-open steps, then the most
recent CHAT_HANDOFF file for specific open items, then this file for
anything that predates the handoff.

## Vending Machine variants (Satu, VM-1.1, VM-1.2) — NOT STARTED
Queued, no files exist yet.

## BBQ Offset Smoker (3–4 model variants planned) — NOT STARTED
Queued, no files exist yet.
```

### TASK 2 — Amend `WORKFLOW_SKILL.md`

In `## CLAUDE WEB SESSION OPENING — MANDATORY SEQUENCE`, insert between
the existing Step 3 and Step 4:
```
**Step 3.5:** Search project knowledge for "CURRENT_STATE" — read it in full
  (it's short, unlike cc_chat_log). This is synced from repo root, same as
  cc_chat_log. Not found → tell Janis sync is broken, same as Step 3.
```
Renumber old Step 4 → 5, old Step 5 → 6. Update the closing line "Do not
respond to any task until all 5 steps confirmed" → "all 6 steps confirmed."

Add a new section immediately after `## REPO TRUTH — WHO CONFIRMS CURRENT
STATE`:
```
---

## MID-SESSION PROJECT SWITCH — PROACTIVE CURRENT_STATE CHECK

CURRENT_STATE.md only updates when Janis explicitly confirms a pause — but
Janis does not always announce a switch. If, mid-conversation, Janis's
requests clearly move to a different product line than CURRENT_STATE.md's
active entry reflects (e.g. session opened on PR-01, conversation shifts
to VM-01 or a new product with no CURRENT_STATE.md entry), Claude Web MUST
ask, before proceeding with the new topic, whether to update
CURRENT_STATE.md for the product being left first. Offer two options
explicitly: (a) Claude Web sends a small cc prompt to update it now, or
(b) Janis updates it directly and pastes the result back. Do not proceed
silently on the new topic without asking this first — an un-updated
CURRENT_STATE.md that looks current but isn't is worse than no file at all.
```

Update the `CHAT HANDOFF TEMPLATE` block's embedded step list (the literal
text Janis pastes into new chats) to insert the CURRENT_STATE.md read as
its own line between the existing Step 3 and Step 4 lines, renumber the rest.

Update `FILE STRUCTURE — REPO`: add `CURRENT_STATE.md` at repo root and
`.claude/rules-waivers.md` under `.claude/`, one-line description each,
matching their knowledge.map rows.

Bump `WORKFLOW_SKILL.md` version (currently 3.6 → 3.7).

### TASK 3 — Amend `chat_rules.md`

Under `## Reading & Diagnosis`, immediately after the existing bullet
`- Read cc_chat_log at every session open — if unreadable or absent, tell Janis sync is broken before proceeding. Do not proceed.`
add:
```
- Read CURRENT_STATE.md at every session open (Step 3.5, WORKFLOW_SKILL.md)
  — short file, read in full, not just skimmed. If a mid-session request
  clearly shifts to a different product than its active entry reflects,
  ask Janis whether to update it before continuing — see MID-SESSION
  PROJECT SWITCH in WORKFLOW_SKILL.md.
```
Bump `chat_rules.md` version (currently v3.6 → v3.7).

### TASK 4 — Update `knowledge.map`

Update the existing `CURRENT_STATE.md` row's description (currently says
"conclusions only... overwritten each update, never appended" — now stale)
to: "Where-we-left-off resumption memo, one entry per product, includes
open/unresolved items. Updates ONLY on Janis-confirmed pause. Read by
Claude Web AND cc." Bump knowledge.map version (v23 → v24).

## 5. DO NOT TOUCH
- `.claude/rules-waivers.md` — correct as merged in PR #75, zero change
- All `.scad` files — zero geometry change
- `rules-dimensions.md`, `cc_rules.md`, `.claude/rules-codes.md` — unrelated
- Any section of WORKFLOW_SKILL.md / chat_rules.md beyond what TASK 2/3 specify

## 6. QA VERIFICATION
- [ ] CURRENT_STATE.md fully replaced, matches TASK 1 exactly, PR-01's
      socket-not-cut-into-wood item present as OPEN, not in rules-waivers.md
- [ ] WORKFLOW_SKILL.md: Step 3.5 inserted, steps renumbered through 6,
      MID-SESSION PROJECT SWITCH section added, CHAT HANDOFF TEMPLATE and
      FILE STRUCTURE updated, version bumped 3.6→3.7
- [ ] chat_rules.md: new bullet added, version bumped v3.6→v3.7
- [ ] knowledge.map: CURRENT_STATE.md row description updated, version
      bumped v23→v24
- [ ] rules-waivers.md untouched — confirm explicitly
- [ ] Zero .scad files touched — confirm explicitly

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-03
3. knowledge.map updated in TASK 4
4. Bump version on all changed files (done above)
5. Commit all → merge to main
