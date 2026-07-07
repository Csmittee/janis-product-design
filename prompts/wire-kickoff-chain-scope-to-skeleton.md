# cc Prompt — Wire New-Product Kickoff Chain: Scope Rule → Skeleton/BOM/
# Kinetic → Coding Loop, as ONE Connected Sequence
# Date: 2026-07-07
# Documentation/governance only. Zero .scad files touched. Applies to
# NEW product lines only — grandfather clause unchanged (VM-01/PR-01
# exempt throughout).

## 1. CC INTRO

Session continuity check: main has changed since the last merge — treat
as FRESH regardless of your own session state.
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → .claude/SKILL_product_design_skeleton.md (full, current
version, includes this session's BOM tree + kinetic additions) →
chat_rules.md → WORKFLOW_SKILL.md (TRIGGER table + CC PROMPT TEMPLATE
section). State every file read before writing a single line.

Claude Web override: none.

## 2. CONTEXT

Two governance pieces exist for new-product kickoff but were never
connected into one sequence: `design_scope_of_work_rule.md` (created
2026-07-06 — owner-vocabulary product concept, per-product) and
`SKILL_product_design_skeleton.md` (created 2026-07-05, one day
earlier — Datum Skeleton + BOM Subassembly Tree + Kinetic Dual-View,
per this session's addition). Because the scope-rule file didn't exist
yet when the skeleton skill was written, the skeleton skill's own SCOPE/
trigger section says nothing about it — a future session could read
the skeleton skill, complete its worksheets, and never create a scope
file at all, or do them in the wrong order.

The correct kickoff sequence for any new product line, confirmed by
Janis, is:

1. Customer requirement — interview in chat, no file
2. `design_scope_of_work_rule.md` created — owner-vocabulary features,
   envelope target, appearance/UX, per that product's folder
3. `SKILL_product_design_skeleton.md`'s worksheets, completed IN ORDER,
   all consuming the scope file's content directly:
   a. Datum Skeleton (master origin, Primary/Secondary/Tertiary datums)
   b. BOM Subassembly Tree (parts hierarchy, seeds that product's
      PART_MANIFEST.md)
   c. Kinetic Dual-View table (every moving part from the BOM tree,
      both states)
4. First cc prompt written and the coding debug loop begins (standard
   7-section CC PROMPT TEMPLATE, isolate-before-fix, R-111/KT if
   something repeats)
5. `cc_chat_log.md` (decision/fix history) and `CURRENT_STATE.md`
   (pause snapshot) feed back into every subsequent loop iteration —
   already working correctly, not part of what this prompt changes

This prompt makes steps 2→3 an explicit, stated dependency instead of
two independently-triggered files that happen to work if done in the
right order by memory.

## 3. NEW FILES
None. Edits to `SKILL_product_design_skeleton.md`, `chat_rules.md`,
`WORKFLOW_SKILL.md`, `knowledge.map`.

## 4. TASKS

### TASK 1 — Add scope-rule prerequisite to
### `SKILL_product_design_skeleton.md`'s SCOPE section

At the top of the SCOPE section (before "TRIGGER PHRASES"), add:

```markdown
## PREREQUISITE — Read This Before the Worksheets Below

This skill's worksheets (Skeleton, BOM Tree, Kinetic Table) all consume
a `design_scope_of_work_rule.md` for this product — create that file
FIRST if it doesn't already exist for this product, using the customer-
requirement interview with Janis (owner-vocabulary features, envelope
target, appearance/UX — see the file's own filter: customer-recognizable/
marketing-headline content only, never implementation detail). Do not
begin the Skeleton Definition Worksheet until the scope file exists and
Janis has confirmed it. If a scope file already exists for this product
(e.g., a later design phase for an already-scoped product), read it in
full before starting the worksheets — every worksheet answer should
trace back to something the scope file actually says, not be invented
independently of it.
```

### TASK 2 — Rewrite `chat_rules.md`'s "New Product Design Discipline"
### section as one ordered sequence

Find the section added 2026-07-05. Rewrite it (don't just append) to
state the full 5-step sequence explicitly, referencing all three
artifacts (scope file, skeleton skill's three worksheets, coding loop)
in the stated order. Keep the existing grandfather clause language
intact, integrated into the rewritten section rather than dropped.

### TASK 3 — Update `WORKFLOW_SKILL.md`'s TRIGGER → ACTION → VALIDATOR
### table

Find the row for new product design. Update ACTION to name the full
chain (scope file → skeleton worksheets → first cc prompt) instead of
just pointing at the skeleton skill alone. Update VALIDATOR to require
Janis's confirmation at TWO points, not one: after the scope file, and
again after the three worksheets — do not collapse these into a single
confirmation gate, they're different content and Janis should see them
separately.

### TASK 4 — Update `knowledge.map`'s GOVERNANCE section

Update the existing entry for `SKILL_product_design_skeleton.md` to
mention the scope-file prerequisite and the BOM/kinetic additions
together, as one coherent description of the new-product path — not
three disconnected bullet points.

## 5. DO NOT TOUCH

- Any `.scad` file — zero geometry change
- `design_scope_of_work_rule.md` files for VM-01/PR-01 (if any exist) —
  this prompt only wires the SEQUENCE for future products, does not
  retrofit existing ones
- The Datum Skeleton / BOM Tree / Kinetic Table content itself — this
  prompt adds a prerequisite pointer, does not alter those procedures
- The VM-01/PR-01 grandfather clause — confirm it still applies, do not
  weaken it
- `rules-dimensions.md`, `.claude/rules-codes.md` — unrelated

## 6. QA VERIFICATION

- [ ] `SKILL_product_design_skeleton.md` has a new PREREQUISITE section,
      positioned before TRIGGER PHRASES, referencing
      `design_scope_of_work_rule.md` explicitly
- [ ] `chat_rules.md`'s New Product Design Discipline section rewritten
      as one ordered 5-step sequence, grandfather clause preserved
- [ ] `WORKFLOW_SKILL.md`'s TRIGGER row updated, TWO separate Validator
      confirmation points stated (post-scope-file, post-worksheets)
- [ ] `knowledge.map`'s GOVERNANCE entry unified into one coherent
      description
- [ ] Versions bumped on all four files, X.Y (detail/sequencing change,
      not new structural content) — confirm this is the correct bump
      type before deciding
- [ ] No `.scad` files touched — confirmed explicitly

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: scope-
   file prerequisite added to skeleton skill, chat_rules sequence
   rewritten, WORKFLOW_SKILL trigger/validator updated, knowledge.map
   unified
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-07
3. Confirm knowledge.map's own entry is the update — no separate step
4. No dimension/SCAD files changed — confirm explicitly
5. Commit all → merge to main
