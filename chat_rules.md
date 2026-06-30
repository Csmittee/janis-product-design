# Claude Web — Chat Rules
# Version: v3.2 — 2026-06-30
# Changes: "first 3 entries (newest at top)" in Reading & Diagnosis; manifold triage bullet in QA Discipline
# Previous: v3 — 2026-06-29
# Owner: Claude Web reads this at Step 2 of every session open. CC never reads this.

---

## Reading & Diagnosis

- Never guess file contents — search project knowledge first, always
- Never guess dimensions — read rules-dimensions.md, never calculate from memory
- Never form any diagnosis before reading cc_chat_log first 3 entries (newest at top) + affected SCAD file
- Read cc_chat_log at every session open — if unreadable or absent, tell Janis sync is broken before proceeding. Do not proceed.

---

## CHAT_HANDOFF Quality Check — Run Before Step 3

Before searching for cc_chat_log, inspect the CHAT_HANDOFF body:
- `## WHAT WAS DONE TODAY` must contain summary text only — no code blocks, no version history, no root cause analysis
- If it contains code fragments or detailed cc_chat_log-style content — the handoff was written under context decay
- In this case: treat Step 3 as NOT YET CONFIRMED regardless of search results
- Search project knowledge for cc_chat_log as a standalone file and state the latest version entry explicitly before proceeding

---

## Prompt Writing

- One cc prompt per session goal — batch all related fixes into one prompt
- Never re-explain project history in cc prompts — cc reads its own rules files
- Every cc prompt must follow the 7-section template in WORKFLOW_SKILL exactly
- Never hardcode values into cc prompts — cc reads from live repo, not from Claude Web memory
- Never overwrite a file — always specify version increment in the save-as filename

---

## Safety & Locked Decisions

- spring_gap = 13mm — OWNER-LOCKED — never change without Janis written approval in chat
- Dashboard 7" landscape — LOCKED
- Payment: online only, no cash/coin — never — do not design, suggest, or include any cash mechanism
- Never reopen any decision marked OWNER-LOCKED or CONFIRMED without Janis explicitly stating it in chat

---

## File Discipline

- Every .md Claude Web writes or updates must have a version bump in the header
- Never write CHAT_HANDOFF to repo — project knowledge only
- Never ask cc to write CHAT_HANDOFF — Claude Web only
- Flag any new file created by cc — must be in cc prompt Section 3 and trigger knowledge.map update

---

## QA Discipline

- Never approve a version without seeing an F6 screenshot from Janis
- Always give explicit PASS or FAIL — never "looks OK" or "should be fine"
- PASS requires: no 2-manifold warning visible + visual check matches intent
- If same issue repeats more than 2 fix loops — stop, trigger R-111, do not write another fix prompt
- 2-manifold warning: read SKILL_manifold_triage.md before writing any prompt.
  First action is always an isolation test, not a fix.
  Maximum 3 prompts from warning report to QA PASS — if exceeded, R-111 triggers.

---

## Session Discipline

- Once Janis confirms today's goal — proceed to prompt. No re-scoping without Janis changing it explicitly
- Do not chain clarifying questions across turns — state the assumption, proceed, let Janis correct
- Never write SCAD code directly in chat — all code goes through cc via prompt file
- Never tell Janis to manually edit SCAD files unless Claude Web gives exact line-by-line instruction
- Verify cc delivery before writing CHAT_HANDOFF — read cc_chat_log, confirm latest entry matches what was requested, flag any gap to Janis

---

## Decay Symptoms — Stop All Task Work Immediately When Any of These Appear

- CHAT_HANDOFF contains code blocks or version history in `## WHAT WAS DONE TODAY`
- cc_chat_log latest entry version does not match ACTIVE MODEL in CHAT_HANDOFF
- cc_chat_log absent from project knowledge as a standalone file
- cc prompt format looks wrong or incomplete
- Same issue repeats more than 2 loops
- Claude Web output drifts from template standards mid-session
- Naming or vocabulary does not match knowledge.map

When decay symptom detected: stop, re-read WORKFLOW_SKILL.md and chat_rules.md from project knowledge, state which rule was violated, propose fix before resuming.

---

## What Claude Web Never Does

- Write SCAD code directly
- Run, compile, or test code
- Approve a version without an F6 screenshot
- Change a locked decision without flagging to Janis first
- Write CHAT_HANDOFF to repo
- Guess dimensions, file contents, or version history

---

## Coordinate System QA Rule
- Before any orientation diagnosis: read XYZ gizmo from screenshot — never assume
- Automotive convention: X=longitudinal, Y=lateral, Z=vertical, origin=front-left leg at floor
- State axis mapping out loud before writing any fix
- If no gizmo visible in screenshot: request a view that shows it before diagnosing
