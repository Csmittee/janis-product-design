# cc Prompt — Governance Restructure: CC INTRO Continuation Logic +
# knowledge.map Cleanup + RULES.md Refresh
# Date: 2026-07-07
# Documentation/process only. Zero .scad files touched.
# This is itself an example of the NEW CC INTRO format it introduces —
# read it as the reference implementation.

## 1. CC INTRO

Session continuity check (you, cc, self-determine this):
Are `cc_rules.md`, `knowledge.map`, and `cc_chat_log.md` already loaded in
your active context from earlier in THIS session, with no `git pull`/
merge to main since you last read them?
- If YES → CONTINUATION. Skip re-reading those three. State "Continuation
  — governance already current from this session" and go straight to
  TASKS below.
- If NO (new session/chat, first prompt of the day, or main has changed
  since) → FRESH. Do:
  `git fetch --all && git checkout main && git pull origin main`
  Read in order: `cc_rules.md` → `knowledge.map` → `cc_chat_log.md`
  (first 3 entries). State every file read before writing a single line.

Claude Web override: none — this prompt requires a FRESH full read
regardless of your own self-check, since it rewrites the files this
check itself depends on. Read fresh even if you believe you're mid-
session.

Task-specific reads (read these regardless of continuation/fresh, since
this prompt touches them directly): `WORKFLOW_SKILL.md` (full),
`RULES.md` (full), every archived prompt in `/prompts/archive/` dated
2026-07-05 through today (for Task 3's lesson extraction).

## 2. CONTEXT

Three related governance gaps, found this session:

1. `WORKFLOW_SKILL.md`'s own CC PROMPT TEMPLATE (the reference template
   Claude Web copies for every new prompt) had drifted to a narrower read
   list than `knowledge.map`'s own "WHO READS WHAT" section specifies.
   `knowledge.map` says cc reads `cc_rules.md → knowledge.map →
   cc_chat_log.md → prompt file` every session; the template had silently
   narrowed to `cc_rules.md → cc_chat_log.md → rules-dimensions.md →
   [source]`, dropping `knowledge.map` (cc's own file-system index)
   entirely, with no recorded decision to do so. This prompt restores the
   correct order AND adds a continuation/fresh self-check so it isn't
   wastefully re-read on every single prompt within one active session.

2. `knowledge.map` currently mixes two jobs: (a) a live index of what
   files exist, where, and when to read them, and (b) a long embedded
   changelog of every past governance/version change. Per Janis: (a) is
   knowledge.map's real job; (b) belongs to `cc_chat_log.md`, which
   already does it well for this repo (confirmed sufficient — no separate
   project-state file needed here). This prompt strips (b) out of
   knowledge.map entirely (that history isn't lost — it's in git history
   and in cc_chat_log already) and rebuilds knowledge.map as a clean,
   current-state-only index, including a FULL listing of everything in
   `/.claude/` (not just a partial sample).

3. `RULES.md` (numbered R-XXX lessons) has not been updated since its
   creation at v1.0 on 2026-06-29, despite several real, durable lessons
   surfacing since — extract and number them now.

## 3. NEW FILES
None. Rewrites to `WORKFLOW_SKILL.md`, `knowledge.map`, `RULES.md`.

## 4. TASKS

### TASK 1 — Rewrite the CC PROMPT TEMPLATE inside `WORKFLOW_SKILL.md`

Find the "CC PROMPT TEMPLATE (7 sections)" section. Replace its Section 1
(CC INTRO) example with this exact structure (this becomes the new
reference template every future Claude Web prompt copies):

```
## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in your
active context from earlier in THIS session, with no git pull/merge to
main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation —
  governance already current" and go straight to TASKS.
→ NO (new session/chat, first prompt of the day, or main changed since):
  FRESH. git fetch --all && git checkout main && git pull origin main.
  Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3 entries).
  State every file read before writing a line.

Claude Web override (only if set below, follow it regardless of your own
self-check): [none | FORCE FULL RE-READ — reason: ...]

Task-specific reads (read these regardless of continuation/fresh, ONLY if
listed below — per knowledge.map's "read only when task requires"):
[named explicitly per prompt — e.g. rules-dimensions.md, RULES.md,
PART_MANIFEST.md, specific source .scad file]
```

Add one line directly under the template, in the template's own
surrounding explanatory text (not inside the code block): "Default
Claude Web override is 'none' — only set FORCE FULL RE-READ when there's
a specific reason (e.g., the prior session ran near its context limit, or
this prompt itself rewrites a governance file the self-check depends
on)."

Bump `WORKFLOW_SKILL.md` version (this is a detail change to an existing
section, not a new section — X.Y, not X.0 per the Document Versioning
Rule). State exact old and new version.

### TASK 2 — Rebuild `knowledge.map` as a pure current-state index

Rebuild `knowledge.map` from scratch with this structure. Do NOT carry
forward the embedded per-version changelog entries currently in the
file — that history is preserved in git and in cc_chat_log.md already.

```markdown
# knowledge.map
# Version: [next] — 2026-07-07
# Changes: Full rebuild — stripped embedded changelog (moved to git
# history/cc_chat_log.md, this file is current-state-only now), added
# complete /.claude/ index, restored as cc's mandatory 2nd session read.
# Previous: v[X] — [date]
# Maintained by: cc
#
# cc reads this at EVERY session start (step 2, after cc_rules.md) to
# know exactly what else exists and where. This file answers WHAT and
# WHERE — never WHAT HAPPENED (that's cc_chat_log.md) and never WHAT
# STATE WE PAUSED IN (that's CURRENT_STATE.md).

---

## WHO READS WHAT

### Claude Web reads (via Janis's Project Knowledge sync — NOT repo)
- chat_rules.md
- WORKFLOW_SKILL.md
Claude Web NEVER reads directly from repo. cc NEVER reads chat_rules.md
or WORKFLOW_SKILL.md.

### cc reads — EVERY session start (in this order, unless CONTINUATION
### per the CC INTRO self-check)
1. cc_rules.md
2. knowledge.map (this file)
3. cc_chat_log.md (first 3 entries)
4. The task prompt file named in this session

### cc reads — ONLY when the task requires (named explicitly per prompt)
[Full current list — verify each still exists, add any missing, remove
any deleted:]
- rules-dimensions.md
- RULES.md
- rules-pr.md
- CURRENT_STATE.md
- PART_MANIFEST.md (per-project)
- design_scope_of_work_rule.md (per-project — read whenever a session
  confirms a new owner feature/goal, per its own standing rule)
- Every file under /.claude/ — list each individually below, do not
  summarize as a group:
  [enumerate every actual file found in /.claude/ during this session's
  read, one row each, with a one-line purpose and exact trigger
  condition for each — do not guess a file's purpose from its name
  alone, open and confirm]

---

## FILE SYSTEM MAP (root)

| File | Maintained by | Purpose |
|---|---|---|
[one row per actual root-level file found this session — CURRENT_STATE.md,
README.md, RULES.md, WORKFLOW_SKILL.md, cc_chat_log.md, cc_rules.md,
chat_rules.md, knowledge.map, rules-dimensions.md, rules-pr.md, and any
others found — confirm the live list, do not assume the sample here is
complete]

## FILE SYSTEM MAP (/.claude/)

| File | Purpose | cc reads when |
|---|---|---|
[one row per actual file in /.claude/ — do not omit any]

## PROJECT FOLDERS

| Folder | Contents |
|---|---|
- vending-machine/
- pilates-reformer/
- viewer/
- /prompts/ (active) and /prompts/archive/ (completed)
- /exports/for-supplier/, /exports/for-cnc/
- /renders/
```

State in cc_chat_log exactly which rows were carried forward unchanged
vs. newly added vs. removed (deleted files no longer in repo).

### TASK 3 — Extract missing lessons into `RULES.md`

Read every archived prompt from 2026-07-05 onward (already listed in CC
INTRO above) plus this session's own toggle/hole/steel-bar fixes.
Extract durable, reusable lessons — NOT one-off task specifics — and add
each as a new numbered rule (R-005, R-006, etc., newest at top per the
file's own format). Candidates to confirm and word properly (extraction
only, verify against the actual source before wording — do not invent
detail beyond what's confirmed):

- The debug-toggle mode-gating trap: a `show_*` boolean can be declared
  and even referenced, but if the code path that checks it only executes
  under one `render_mode` value, setting it has zero visible effect under
  other modes — always confirm which render_mode a toggle is gated to
  before concluding it's broken.
- The "patch vs. real material" pattern: a visual gap created by
  shortening/repositioning one part (e.g., acrylic) should be closed by
  extending the adjacent structural material to fill it, not by adding a
  separate cosmetic strip that merely visually covers the gap — the
  latter creates a dependent, fragile fix (confirm this is what actually
  happened in the steel-bar case this session before wording the rule).
- The shared-radius/shared-center arc constraint: two features built from
  the same geometric center and radius (e.g., a door's swing arc and a
  frame return flange) cannot be independently resized without
  recalculating both — extending one back into contact with a fixed wall
  can reintroduce the exact collision the extension was meant to fix.

Do not add a rule you can't trace to an actual confirmed event in the
read history — flag as "candidate, not confirmed" in cc_chat_log rather
than force one in.

Bump `RULES.md` version (2.0, since this is new structural content —
new numbered rules — not a detail-only change).

## 5. DO NOT TOUCH

- Any `.scad` file — zero geometry change
- `cc_rules.md`, `chat_rules.md`, `rules-dimensions.md`,
  `CURRENT_STATE.md`, `PART_MANIFEST.md`, `design_scope_of_work_rule.md`
  files — read/reference only, not edited by this prompt
- `cc_chat_log.md` entries — append only, per Mandatory Closing, no
  reordering or deletion
- The actual R-001 through R-004 content in `RULES.md` — append new
  rules above them, do not reword or delete existing ones
- Any PR-01 file

## 6. QA VERIFICATION

- [ ] `WORKFLOW_SKILL.md` CC PROMPT TEMPLATE Section 1 replaced with the
      exact continuation/fresh/override structure above
- [ ] Explanatory line about default override added outside the code
      block
- [ ] `WORKFLOW_SKILL.md` version bumped, old/new stated
- [ ] `knowledge.map` rebuilt — changelog entries removed, WHO READS WHAT
      restored with knowledge.map as cc's mandatory 2nd read
- [ ] Full `/.claude/` directory enumerated individually, no group
      summaries, each with purpose + trigger
- [ ] Full root-level file list confirmed live (not assumed from sample)
- [ ] `knowledge.map` version bumped (X.0, structural rebuild)
- [ ] Each new `RULES.md` entry traced to an actual confirmed event —
      state which source for each; any uncertain candidate flagged, not
      forced in
- [ ] `RULES.md` version bumped to 2.0, R-001–R-004 untouched
- [ ] No `.scad` files touched — confirm explicitly

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: CC
   INTRO template restored + continuation logic added, knowledge.map
   rebuilt (rows carried/added/removed), RULES.md new rule count and
   which were confirmed vs. flagged as candidates
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-07
3. This prompt IS the knowledge.map update — no separate step needed
4. Confirm no `.scad`/dimension files needed a version bump
5. Commit all → merge to main
