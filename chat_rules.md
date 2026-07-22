# Claude Web — Chat Rules
# Version: v3.13 — 2026-07-21
# Changes: Prompt Writing section gets 3 new bullets from R-014 (RULES.md,
# the BBQ firebox/chamber dual-end-cap retrospective — same module
# touched 6 real times, CGAL passed clean at multiple points while the
# actual written design intent stayed wrong until a locked, named
# convention existed to check against). New bullets: reference locked
# conventions by NAME rather than re-describing geometry in fresh prose;
# state the specific real verification expected, not just "confirm no
# collision"; treat an owner statement that something was asked before
# and not delivered as confirmed intent for direct execution, never a
# fresh request needing re-confirmation. Detail addition to an existing
# section, not new structure — X.Y bump.
# Previous: v3.12 — 2026-07-13
# Changes: governance-inline-content-and-predelivery-check. Prompt Writing
# section gets one new bullet — never write "pull from chat/session/
# discussion" into a cc prompt, transcribe confirmed content directly (new
# rule R-012, RULES.md). Detail addition to an existing section, not new
# structure — X.Y bump.
# Previous: v3.11 — 2026-07-09
# Changes: New "Direct-CC Escalation Protocol" section added (wiring in
# R-011 from RULES.md, governance-verification-escalation-rules) —
# formalizes when Janis may escalate directly to cc bypassing prompt
# drafting, and what Claude Web must confirm before resuming work on a
# file that may have had a direct-cc-chat session. Follows this file's
# own established precedent (v3.7→v3.8 added a whole new section as an
# X.Y bump, not X.0) rather than the stricter abstract Document
# Versioning Rule definition.
# Previous: v3.10 — 2026-07-07
# Changes: "New Product Design Discipline" section REWRITTEN (not just
# appended) as one explicit ordered 5-step sequence — customer interview →
# design_scope_of_work_rule.md → skeleton skill's 3 worksheets (in order,
# consuming the scope file) → first cc prompt/coding loop →
# cc_chat_log/CURRENT_STATE feedback. Previously the scope-rule file
# (created 2026-07-06, one day after this skill) was never referenced
# here at all — a future session could complete the skeleton worksheets
# without ever creating one, or in the wrong order. Sequencing/detail
# change to existing content, not new structural content — X.Y bump.
# Grandfather clause preserved, integrated into the rewritten section.
# Previous: v3.9 — 2026-07-07
# Changes: Extended "New Product Design Discipline" section — the same
# mandatory pre-first-prompt gate now covers 3 artifacts, not 1 (Skeleton
# Worksheet + BOM Subassembly Tree + Kinetic Dual-View table, all added to
# SKILL_product_design_skeleton.md 2026-07-07). Detail addition to an
# existing section, not new structure — X.Y bump. Grandfather clause
# unchanged.
# Previous: v3.8 — 2026-07-05
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

## New Product Design Discipline (added 2026-07-05, rewritten as one
## sequence 2026-07-07 — wire-kickoff-chain-scope-to-skeleton)

Trigger: Janis requests a new product design, new model line, or any
physical assembly that is NOT a continuation of VM-01 or PR-01.

The full kickoff sequence, in order — each step depends on the one
before it, do not reorder, skip, or start one before the previous is
Janis-confirmed:

1. **Customer requirement** — interview Janis in chat, no file yet.
2. **`design_scope_of_work_rule.md` created** — owner-vocabulary
   features, envelope target, appearance/UX, for that product's own
   folder. State it back to Janis and get explicit confirmation.
3. **`.claude/SKILL_product_design_skeleton.md`'s worksheets**, completed
   IN ORDER, all consuming the scope file's content directly (per that
   skill's own PREREQUISITE section):
   a. Skeleton Definition Worksheet: master origin, Primary/Secondary/
      Tertiary datums, and each major sub-assembly's declared Parent +
      offset.
   b. BOM Subassembly Tree: parts/subassembly hierarchy — a DIFFERENT
      artifact from the Skeleton (parts hierarchy, not coordinate
      reference), seeds that product's `PART_MANIFEST.md`.
   c. Kinetic Dual-View table: every moving part identified in the BOM
      tree (opens/closes, slides, rotates, extends/retracts) gets BOTH
      end states listed and confirmed — not just its default state.
   State all three worksheets back to Janis explicitly and get
   confirmation — this is a SEPARATE confirmation gate from step 2's,
   not collapsed into it.
4. **First cc prompt written, coding debug loop begins** — standard
   7-section CC PROMPT TEMPLATE, isolate-before-fix discipline, R-111/KT
   if something repeats. Ordinary rules from here on, nothing new.
5. **`cc_chat_log.md` + `CURRENT_STATE.md`** feed back into every
   subsequent loop iteration — already working correctly, unchanged by
   this discipline.

Never let a build prompt introduce a new shared reference point without
checking whether it belongs in the Skeleton (2+ parts need it) or is a
true local Parent-Child offset (one part, measured from its actual
Parent) — never a Cousin or a Stranger reference.

**Grandfather clause, explicit and non-negotiable: VM-01 and PR-01 are
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
- Never write "pull from chat/session/discussion" into a cc prompt — cc
  cannot see the Claude Web <-> Janis conversation under any circumstance.
  Transcribe confirmed content directly, every time. See RULES.md R-012.
- If a locked, named convention already covers the area a prompt touches
  (check the product's own fabrication-rules file, e.g.
  `rules-bbq-fab.md`'s own locked sections, and general reusable patterns
  in `.claude/SKILL_joint_construction.md`), REFERENCE IT BY NAME in the
  prompt text ("apply the Dual End-Cap Independence Convention, Rule 1"
  / "use the Dual End-Cap Footprint Pattern, RULE 4") — do not re-describe
  the geometry in fresh prose from memory. A precise name routes cc
  straight to the already-verified pattern; a fresh description invites a
  fresh, possibly-incompatible reinterpretation. See RULES.md R-014.
- Every prompt requiring a geometry fix must state the SPECIFIC real
  verification expected — never just "confirm no collision" or "make it
  manifold." Pull the exact probes from the relevant locked convention's
  own QA section if one exists (e.g. rules-bbq-fab.md's "Dual End-Cap QA
  Simulation Checklist"). Manifold-clean is necessary, not sufficient —
  see R-014.
- If Janis states a fix was asked before and not delivered, the next
  prompt (or direct-cc instruction) must treat that as CONFIRMED intent
  and instruct DIRECT execution — never re-litigate, never ask Janis to
  reconfirm what was already asked. Still flag in the prompt that this is
  closing a previously-open ask, so the gap is on record.

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

## Direct-CC Escalation Protocol (added 2026-07-09, R-011 in RULES.md)

The default flow is: Janis describes an issue to Claude Web → Claude Web
drafts a structured prompt (7-section CC PROMPT TEMPLATE) → Janis sends
it to cc. Janis MAY escalate directly to cc instead — bypassing prompt
drafting entirely — when the prompt-based loop is not making progress
(a prompt was built on insufficient context, the actual problem needs
faster back-and-forth than the prompt format allows, or repeated prompt
rounds aren't converging). This is a LEGITIMATE, EXPECTED escape valve,
not a process failure.

When a direct-cc-chat session has happened (or may have happened) on a
file Claude Web is about to work on:
1. Do NOT assume what happened in that session from Janis's paraphrase
   alone. The real source (PR diff, cc_chat_log entry) is checkable —
   check it, per the REPO TRUTH rule in WORKFLOW_SKILL.md.
2. Confirm the direct-cc-chat session actually completed its own
   MANDATORY CLOSING (cc_chat_log.md entry, prompt archived if one
   existed, version bump, merged to main) — a direct-cc-chat session
   that skipped closing is not a completed unit of work, treat it the
   same as an unmerged PR.
3. If cc_chat_log's latest entry doesn't clearly correspond to what
   Janis describes happened directly with cc, treat this as a Decay
   Symptom (see below) — stop and reconcile before proceeding.
Root cause this prevents: this project's own PR #100/#101 sync-lag
incidents, where running both channels on the same file without an
explicit sync point caused real confusion and repeated re-diagnosis.

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
