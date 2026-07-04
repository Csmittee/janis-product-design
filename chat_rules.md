# Claude Web — Chat Rules
# Version: v3.8 — 2026-07-05
# Changes: Added "New Product Design Discipline" section — .claude/SKILL_product_design_skeleton.md is now the FIRST file read for any NEW product line (not VM-01/PR-01 continuation). Establish the Skeleton Layout + Datum Reference Frame with Janis before any component sizing or first cc prompt.
# Previous: v3.7 — 2026-07-03
# Owner: Claude Web reads this at Step 2 of every session open. CC never reads this.

---

## Reading & Diagnosis

- Never guess file contents — search project knowledge first, always
- Never guess dimensions — read rules-dimensions.md, never calculate from memory
- Never form any diagnosis before reading cc_chat_log first 3 entries (newest at top) + affected SCAD file
- Read cc_chat_log at every session open — if unreadable or absent, tell Janis sync is broken before proceeding. Do not proceed.
- Read CURRENT_STATE.md at every session open (Step 3.5, WORKFLOW_SKILL.md)
  — short file, read in full, not just skimmed. If a mid-session request
  clearly shifts to a different product than its active entry reflects,
  ask Janis whether to update it before continuing — see MID-SESSION
  PROJECT SWITCH in WORKFLOW_SKILL.md.
- Project Knowledge is a snapshot, not live repo access. Never treat a
  fetch, a search result, or an assumption as current truth — ask Janis
  to confirm or sync whenever current repo/PR/merge status actually
  matters to the task at hand.

---

## New Product Design Discipline (added 2026-07-05)

- Trigger: Janis requests a new product design, new model line, or any
  physical assembly that is NOT a continuation of VM-01 or PR-01.
- Read `.claude/SKILL_product_design_skeleton.md` FIRST — before
  rules-dimensions.md, before any component-sizing conversation, before
  the first cc prompt.
- Complete the Skeleton Definition Worksheet with Janis in chat: master
  origin, Primary/Secondary/Tertiary datums, and each major sub-assembly's
  declared Parent + offset. State it back to Janis for explicit
  confirmation before writing the first cc prompt.
- Never let a build prompt introduce a new shared reference point without
  checking whether it belongs in the Skeleton (2+ parts need it) or is a
  true local Parent-Child offset (one part, measured from its actual
  Parent) — never a Cousin or a Stranger reference.
- **Grandfather clause, explicit and non-negotiable: VM-01 and PR-01 are
  NOT retrofitted to this system.** Continue using the existing
  DATUM_*/`SKILL_reference_point_first.md` convention for those two
  products. This discipline applies to later/new products only.

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
- Same issue repeats more than 2 loops — Claude Web MUST self-check loop
  count at the START of every QA result it receives, BEFORE responding to
  it. This check happens automatically, every single FAIL, not only when
  Janis raises it. If 2nd consecutive FAIL on the same root component is
  detected, state "R-111 triggered" in the same message as the QA
  response — do not proceed to write or imply a 3rd fix attempt first.
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

## Claude Web Rendering Capability (added 2026-07-01)
Claude Web can install OpenSCAD via apt in its bash sandbox and render
geometry locally. This is now a MANDATORY first step for any new module
shape design. See .claude/SKILL_local_render.md for the full protocol.
This capability replaced the screenshot→cc→screenshot loop that previously
burned 11+ versions per design iteration.
- For aesthetic/artistic geometry decisions (curve character, stylistic
  proportion — not purely dimensional), build a Customizer-enabled prototype
  per .claude/SKILL_customizer_profile.md instead of iterating on static
  screenshots.

---

## Coordinate System QA Rule
- Before any orientation diagnosis: read XYZ gizmo from screenshot — never assume
- Automotive convention: X=longitudinal, Y=lateral, Z=vertical, origin=front-left leg at floor
- State axis mapping out loud before writing any fix
- If no gizmo visible in screenshot: request a view that shows it before diagnosing
