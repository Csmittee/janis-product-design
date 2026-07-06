# cc Prompt — Wire design_scope_of_work_rule.md into Session Start Sequence
# Date: 2026-07-06
# Documentation-only. No .scad files touched.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read: cc_rules.md → WORKFLOW_SKILL.md → chat_rules.md →
design_scope_of_work_rule.md (both vending-machine and pilates-reformer
copies, if both exist on main already).
State every file read.

## 2. CONTEXT

`design_scope_of_work_rule.md` was added this session to hold the
owner's actual product concept (envelope targets, compartment map,
functional/appearance features) — the one thing that was previously
scattered across handoffs, chat turns, and cc_chat_log entries with no
durable home.

Gap found immediately after creating it: the file was never wired into
WORKFLOW_SKILL.md's mandatory session-start read sequence. That sequence
governs what Claude Web reads at the start of EVERY new chat, before any
QA or prompt-writing begins. Without this wire-in, a future chat has no
way of knowing this file exists unless it happens to search for it —
defeating the entire purpose of the file.

This matters specifically for Claude Web's role in this project (root-
cause analysis + prompt authorship), not just cc's: Claude Web has to
know the owner's actual design intent BEFORE writing any prompt, not
discover it reactively. cc executing an incorrect-but-plausible prompt is
a smaller risk than Claude Web never knowing the standing product
concept in the first place.

## 3. TASKS

### TASK 1 — Add design_scope_of_work_rule.md to the mandatory read sequence

Find the step-by-step session-start sequence in `WORKFLOW_SKILL.md` (the
same one referenced by the chat handoff template — "Step 1: Load
WORKFLOW_SKILL", "Step 2: Load chat_rules", "Step 3: Read cc_chat_log",
etc.). Add a new step that reads the relevant project's
`design_scope_of_work_rule.md` in FULL, at the same mandatory tier as
chat_rules.md and CURRENT_STATE.md — not an optional/conditional step.
Position it early in the sequence (before any QA discussion or prompt
drafting could begin), state exactly where you inserted it and why that
position.

If a chat could plausibly touch either project (VM-01 or PR-01) but it's
not yet clear which at session start, note that both should be read, or
flag this ambiguity explicitly rather than picking one silently.

### TASK 2 — Confirm the cc-side read rule stays as-is

Per Janis: cc does NOT get this file added to ITS own mandatory read
list — cc reads it only when a specific prompt explicitly points to it
(unchanged from the original design). Confirm this task does not
accidentally add it to any cc-side automatic read step; if the current
cc_rules.md has no such automatic step to begin with, simply confirm
that in cc_chat_log rather than assuming.

## 4. DO NOT TOUCH
- No .scad files
- design_scope_of_work_rule.md's own content — this prompt only wires it
  into the read sequence, doesn't edit what's inside it
- cc_rules.md's own cc-side read behavior — do not add automatic cc
  reading of this file (see TASK 2)

## 5. QA VERIFICATION
- [ ] design_scope_of_work_rule.md added to WORKFLOW_SKILL.md's mandatory
      session-start sequence, exact insertion point stated
- [ ] Confirmed at the same mandatory tier as chat_rules.md/CURRENT_STATE.md
      — not conditional/optional
- [ ] Confirmed cc's own read behavior unchanged — still prompt-triggered
      only, not automatic
- [ ] If both VM-01 and PR-01 design_scope files exist, confirmed the
      sequence handles reading the correct one (or both, if ambiguous at
      session start) — state how

## 6. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines: exact
   insertion point in WORKFLOW_SKILL.md, confirmation cc's own read
   behavior is unchanged
2. Archive this prompt → /prompts/archive/
3. Commit all → merge to main
