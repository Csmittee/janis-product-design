# Claude Code (cc) Rules
# Version: v6 — 2026-07-05
# Changes: Added pointer to .claude/SKILL_reference_point_first.md — read before
# designing any new part/module's geometry (VM-01-door-fixes-v42, tray/window
# desync bug). Every module needs one clean local origin, tied to a world DATUM_*
# via a single translate() — never a chain of independently-derived values.
# Previous: v5 — 2026-07-01
# Read this at the START of every cc session — step 1, always.

---

## My Role
- Execute prompts from Claude Web
- Read repo, write code, commit files
- Report results in cc_chat_log.md after every commit
- Never make design decisions — execute only

---

## Session Start — Do This Every Time, In Order

```
1. git fetch --all
2. git merge origin/main
   (Janis always pushes prompts to main — fetch before reading)
3. Read cc_rules.md (this file)
4. Read knowledge.map (know what else to load)
5. Read cc_chat_log.md (what Claude Web flagged last session)
6. Read /prompts/[task].md (filename given by Janis in chat)
7. Read latest .scad for active model (in cc_chat_log.md)
8. Read rules-dimensions.md + rules-materials.md
9. Read product-specific rules if prompt specifies
```

**If prompt file not found:** do git fetch --all + git merge origin/main
before reporting missing. Janis always pushes to main, not the feature branch.

---

## Coding Rules
- All units MM — always
- Named parameters at top of every file — no exceptions
- No hardcoded numbers inside modules — use parameters
- Every module max 30 lines
- $fn = 64 for all curves
- Comment every section
- hull() for rounded shapes
- difference() for cutouts
- Shared reference points (any Z/X/Y position two or more modules need) are
  named DATUM_* constants, computed once from raw dimensions — never
  re-derived independently per module. See .claude/SKILL_reference_point_first.md
  and .claude/rules-codes.md "Datum Rules".

---

## File Rules
- Never overwrite — always increment version (v8 → v9)
- Name format: [PRODUCT]-[MODEL]-[COMPONENT]-[VERSION].scad
- Save SCAD to correct product folder
- Save STL to /exports/for-supplier/
- Save DXF to /exports/for-cnc/
- Root rules files (cc_rules.md, rules-dimensions.md, etc.) stay at root — do not move
- .claude/ rules files (.claude/rules-codes.md, etc.) stay in .claude/ — do not copy to root

---

## After Every Commit
1. Update cc_chat_log.md — PREPEND new entry at TOP (newest first). Max 10 lines per entry.
2. List every file committed
3. Flag ambiguity or decisions needed by Claude Web in cc_chat_log.md Flags section
4. Update knowledge.map Active Project Status if needed

---

## What cc Never Does
- Never change dimensions not in the prompt
- Never skip reading session-start files
- Never make design decisions
- Never read chat_rules.md or workflow_skill.md (those are Claude Web only)
- Never commit without updating cc_chat_log.md
- Never paste prompt text into chat — always read from /prompts/ file

---

## Files cc Reads (see knowledge.map for full index)
- Always: cc_rules.md, knowledge.map, cc_chat_log.md, /prompts/[task].md
- SCAD tasks: rules-dimensions.md, .claude/rules-materials.md, .claude/rules-codes.md, latest .scad
- VM tasks: .claude/rules-vm.md (when it exists)
- PR tasks: rules-pr.md (when it exists)
- R-111 trigger: .claude/SKILL_problem_solving_kt.md
- .claude/SKILL_option_b_unified_loft.md — read in full BEFORE touching
  pole_top_body(), pole_top_housing(), pole_top_neck(), or any pole_top
  seam/joint geometry. Do not reconstruct Option B architecture from memory.
- .claude/SKILL_reference_point_first.md — read in full BEFORE designing any
  new part/module's geometry. Each module gets its own local origin (0,0,0)
  tied to a named DATUM_* via one translate() — never scattered world-Z
  formulas re-derived independently per module.

---

## COORDINATE SYSTEM — READ BEFORE ANY GEOMETRY WORK

This project uses automotive convention (locked in rules-dimensions.md):
  X = longitudinal (long axis), Y = lateral (width), Z = vertical (up)
  Origin = front-left corner at floor.

Before writing any rotate() or translate() for a directional component:
1. State the axis explicitly in a comment: // crossbar runs along X
2. Confirm rotation: along X = rotate([0,90,0]), along Y = rotate([90,0,0])
3. Never assume — derive from parameter names (bed_l → X, bed_w → Y)
