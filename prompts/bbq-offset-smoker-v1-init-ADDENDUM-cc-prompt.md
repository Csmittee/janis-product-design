CC PROMPT — bbq-offset-smoker-v1-init-ADDENDUM
================================================
Read this together with the original bbq-offset-smoker-v1-init-cc-prompt.md,
already in progress this session. This fills two kinds of gaps found by
Claude Web audit after the original was delivered: missing template
sections, and a placeholder instruction that pointed to a source you
cannot see.

## 1. CC INTRO

Continuity check: you are already mid-session on bbq-offset-smoker-v1-init
— this is a SAME-SESSION addendum, not a fresh prompt. Do NOT re-run git
fetch/pull. Continue from wherever you currently are in Task 1-4.

If for any reason you ARE starting fresh (main changed since, or prior
context was lost): git fetch --all && git checkout main && git pull
origin main, then read cc_rules.md → knowledge.map → cc_chat_log.md
(first 3 entries) before continuing with anything below.

## 2. CONTEXT

The original prompt's Task 1 told you to pull the Compartment Map /
Functional Features / Appearance-DoNot / Made-Buy-Hire lists, and the
SKELETON_WORKSHEET's BOM Subassembly Tree + Kinetic Dual-View table,
"from this session's chat log." That instruction was wrong — it pointed
to a Claude Web <-> Janis conversation you have no access to, not
anything in this repo. This addendum supplies real content to unblock
Task 1, and adds the template sections (NEW FILES, DO NOT TOUCH,
MANDATORY CLOSING) the original prompt was missing entirely.

Two different confidence levels below — read carefully:
- Section 3's scope-file content is reconstructed by Claude Web from the
  confirmed session handoff. It should be materially correct but has NOT
  been re-confirmed verbatim by Janis in this exact wording.
- Section 3's BOM/Kinetic tables are DERIVED mechanically by you (cc)
  from the fully-specified module list already locked in the original
  prompt's Task 2/3 — they were never a verbatim Janis-confirmed source
  to begin with, so derive rather than guess at a "copy" that doesn't
  exist.

Both must be flagged for Janis's review in cc_chat_log per Section 6 —
neither is to be treated as silently locked just because it's now in a
committed file.

## 3. CONTENT — replaces Task 1's bracketed placeholders

### 3a. For design_scope_of_work_rule.md

Use this content for Compartment Map / Functional Features /
Appearance-DoNot / Made-Buy-Hire:

**Compartment Map**
- Cook Chamber — main octagonal-profile smoking chamber, pass-through
  smoke flow (V1)
- Firebox — offset, attached at chamber rear (Y=chamber_L), floor lower
  than chamber floor (classic offset-smoker draft technique)
- Chimney — front shoulder mount, foldable, internal drop-tube down to
  grate level
- Understructure — corner-tube wheeled frame, 2 fixed + 2 swivel
  casters, tow handle at chimney end
- Prep Shelves x2 — fold-up (vertical stowed / horizontal deployed),
  left + right, front of chamber

**Functional Features**
1. Full-length counterbalanced lid — lever + weight, target ~85-90%
   self-balance (slight self-closing bias, not full balance)
2. Full-width lift handle rail, 150mm standoff, 2+ mounting posts
3. 2+ floor drain valves, spaced front-third / back-third of chamber
4. Firebox door — lockable, off-shelf spiral-wire heat-safe handle
5. Laser-cut steel grill grate, 3-4 removable segments on internal
   support ledge
6. 2 fold-up prep shelves (vertical stowed / horizontal deployed)
7. Foldable chimney with internal drop-tube (smoke circulates low
   across food, not a short-circuit top vent)
8. Adjustable firebox air-intake damper
9. Slide-out ash tray below the fire grate
10. Toggle-clamp lid latches x2+
11. Dome thermometer port (placeholder)
12. Hybrid fuel — wood or charcoal

**Appearance / Do-Not**
- Reference plan images (corner-tube frame, toggle-clamp lid) are
  construction-method inspiration only — do NOT copy their dimensions
- V1 is pass-through smoke flow only — reverse-flow is explicitly OUT
  OF SCOPE for this version, do not add it

**Made / Buy / Hire**
- Made (laser-cut / welded in-house): grill grate segments, drain valve
  bosses, chamber/firebox shells, understructure frame
- Buy (off-shelf): wheels, axle, wheel-axle joints, toggle clamp
  latches, dome thermometer, spiral-wire firebox handle, drain valves
- Hire / supplier-verify: bend allowances for formed panels (doors,
  end-caps)

### 3b. For SKELETON_WORKSHEET.md

**Part A — Datum Skeleton:** already fully specified in the original
prompt's Task 2 "DATUMS" section — use that directly, do not re-derive:
1. Grill Grate plane — fixed at GRATE_Z=700, MASTER CONTROL VALUE
2. Cook Chamber shell — parent: Grate plane, offset dZ=-100
3. Firebox — parent: Cook Chamber back wall (Y=chamber_L), floor
   parented independently per firebox_drop
Master origin: (0,0,0), floor level, front-left.

**Part B — BOM Subassembly Tree** and **Part C — Kinetic Dual-View
table:** DERIVE these from the module list already locked in the
original prompt's Task 2/3 — every named part/subassembly gets a BOM
row (Cook Chamber, Firebox, Window Cut, Chimney, Drop Tube, Lid
Assembly, Grill Grate segments x3-4, Floor Drain Valves x2+,
Understructure Frame, Prep Shelves x2); every part described as
hinged / folding / sliding gets a Kinetic row with BOTH end states
listed (Lid: open/closed, Chimney: deployed/folded, Ash Tray: in/out,
Prep Shelves x2 each: vertical-stowed/horizontal-deployed).

State explicitly in cc_chat_log that Parts B/C were CC-DERIVED from the
geometry spec, not copied from a prior Janis confirmation.

## 4. NEW FILES (this session creates six, none exist yet)
- bbq-offset-smoker/design_scope_of_work_rule.md
- bbq-offset-smoker/rules-bbq-fab.md
- bbq-offset-smoker/SKELETON_WORKSHEET.md
- bbq-offset-smoker/BBQ-chambers-v1.scad
- bbq-offset-smoker/BBQ-understructure.scad
- bbq-offset-smoker/BBQ-offset-smoker-base-v1.scad

All three new .md files must carry the standard version header:
> Version 1.0 — 2026-07-13
> Changes: initial creation
> Previous: none

All six must be added to knowledge.map on completion (see Section 6).

## 5. DO NOT TOUCH
- Anything outside bbq-offset-smoker/ — no VM-01, VM-02, or PR-01 files
  of any kind
- rules-dimensions.md — VM-specific, not applicable to BBQ, do not edit
  or reference it for this product
- cc_rules.md, chat_rules.md, WORKFLOW_SKILL.md, and knowledge.map's own
  structure — read/reference only, except to append the new-file rows
  named in Section 4

## 6. MANDATORY CLOSING (this was missing entirely from the original
## prompt — required now, same as every other cc prompt in this repo)
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines: list
   all 6 new files created; explicitly flag that
   design_scope_of_work_rule.md's feature lists AND
   SKELETON_WORKSHEET.md's BOM/Kinetic tables are reconstructed/derived,
   not verbatim from a prior Janis confirmation, and need her review;
   restate firebox_drop=200mm as still-open; state QA results (manifold
   sweep, screenshot angles, window/firebox overlap check)
2. Archive BOTH prompts (original v1-init AND this addendum) →
   /prompts/archive/ ✅ COMPLETE — 2026-07-13
3. Update knowledge.map with all 6 new files
4. Confirm version headers present on all 3 new .md files
5. Commit all → merge to main
