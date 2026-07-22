# Claude Code (cc) Rules
# Version: v10 — 2026-07-21
# Changes: Added Verification Discipline Rule — root cause fix for the BBQ
# firebox/chamber dual-end-cap saga (BBQ-chambers-v15 through v20, the
# SAME module touched 6 real times): CGAL "Simple: yes, no collision"
# passed at multiple points while the actual written design intent was
# still wrong (v17 dodged 2 known bugs without satisfying the written
# rule; a solid-vs-hollow flange defect shipped 5 versions unquestioned).
# The loop only closed once a locked, named convention
# (rules-bbq-fab.md's Dual End-Cap Independence Convention) and a reusable
# CSG pattern (.claude/SKILL_joint_construction.md RULE 4) existed for cc
# to check against and reuse directly, instead of re-deriving a fix from
# scratch each round. New rule formalizes: manifold-clean is necessary,
# not sufficient; locked conventions must be read and their named patterns
# reused, not re-derived; cc must self-trigger R-010's own "question the
# design" escalation in direct-cc sessions, since R-010's own trigger
# point (Claude Web noticing repeat-touch) never fires when cc is working
# directly with Janis. Detail addition, not new section structure.
# Previous: v9 — 2026-07-07
# Changes: One-line addition to the existing NEW product line gate — the
# same read-and-confirm requirement now also covers
# SKILL_product_design_skeleton.md's BOM Subassembly Tree and Kinetic
# Dual-View table (added to that skill file 2026-07-07), not just the
# Skeleton Worksheet. Detail addition (X.Y-equivalent, this file's own
# plain-integer convention), not a new section here.
# Previous: v8 — 2026-07-05
# Changes: Added Toggle-Completeness Rule (every ASSEMBLY-called module
# needs a show_* toggle or a named safety-critical exception in that
# product's PART_MANIFEST.md) — root cause fix for tray_zone_frame() going
# ~10 versions with zero toggle and no one noticing its wrong reference
# point. See VM-01-governance-batch-post-v44.
# Previous: v7 — 2026-07-05
# Changes: Added pointer to .claude/SKILL_product_design_skeleton.md — the
# FIRST file read for any NEW product line (not VM-01/PR-01 continuation).
# Formalizes the DATUM_*/local-origin habit into a full Skeleton Layout +
# Datum Reference Frame + Parent-Child design discipline, established BEFORE
# any component sizing. VM-01/PR-01 explicitly grandfathered — not retrofitted.
# .claude/SKILL_reference_point_first.md superseded by it but still the
# relevant reference for ongoing VM-01/PR-01 work specifically.
# Previous: v6 — 2026-07-05
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

**If the task is a NEW product line** (not a VM-01 or PR-01 continuation —
check whether the product already has committed `.scad` versions in its
own folder): read `.claude/SKILL_product_design_skeleton.md` FIRST, before
step 8 below, before rules-dimensions.md, before writing a single
parameter. Confirm the Skeleton Layout + Datum Reference Frame was
established with Janis (per that file's Claude Web procedure) before
proceeding — if the prompt doesn't show evidence of this, flag it in
cc_chat_log rather than silently inventing datums. Same gate now also
covers that skill file's BOM Subassembly Tree and Kinetic Dual-View
table (added 2026-07-07) — confirm evidence of those too, not just the
Skeleton Worksheet, before proceeding.

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
- New product lines: the datum block is a SKELETON, established before any
  part is dimensioned, and every module carries an explicit Parent
  declaration comment. See .claude/SKILL_product_design_skeleton.md.

## Toggle-Completeness Rule (added 2026-07-05)

Every module called directly in a product's ASSEMBLY section MUST have
its own `show_*` isolation toggle, with ONE exception: modules that are
safety-critical and must never be hidden (e.g. `drop_zone_guards()`) may
be marked "(none — always on, safety-critical)" in that product's
PART_MANIFEST.md instead — this exception must be explicit and named in
the manifest, never silent.

Before every commit that adds a new ASSEMBLY-called module: grep the
ASSEMBLY block, confirm every call is either gated by a show_* toggle or
explicitly listed as a safety-critical exception in PART_MANIFEST.md.
Report this check's result in cc_chat_log ("N modules in ASSEMBLY, N
toggled, 0 untoggled-and-unexplained" or flag the gap).

Root cause this prevents: tray_zone_frame() had zero toggle for ~10
versions, made it impossible to isolate/inspect independently, and it
sat wrong-referenced against the shell's exterior corner the entire time
without anyone noticing. See PART_MANIFEST.md for the plain-language part
identity this rule pairs with.

---

## Verification Discipline Rule (added 2026-07-21)

**1. Manifold-clean is necessary, not sufficient.** A real CGAL
`Simple: yes` result and an empty collision probe prove the geometry
doesn't self-intersect or overlap what it shouldn't — they prove NOTHING
about whether it's the shape actually asked for. Before reporting any fix
done, state explicitly what real, named check confirms it matches the
written intent (a locked convention's own QA section if one exists, or
the prompt/owner's own stated requirement) — not just "renders clean."

**2. If a locked, named convention exists for the area being touched,
read it FIRST and reuse its own named pattern — never re-derive.** Check
the product's own fabrication-rules file (e.g. `rules-bbq-fab.md`) for a
locked section covering this construction before writing new geometry
logic. If a reusable CSG pattern exists for it (e.g.
`.claude/SKILL_joint_construction.md`'s numbered RULEs), apply it
directly and cite it by name in the commit/cc_chat_log entry. Two
independently-invented fixes for the same real problem (as happened
across BBQ-chambers-v16 and v18, before the pattern was written down) is
itself a signal the convention should have been written down sooner —
write it down the FIRST time a real, non-obvious construction technique
is found, don't wait for a third occurrence.

**3. Self-trigger R-010 in direct-cc sessions.** R-010 (RULES.md) requires
a "question the underlying design, not just the bug" task once the same
module/feature has been the subject of 3+ separate fix rounds — but its
own trigger assumes Claude Web is tracking rounds and inserting that task.
In a direct-cc session (R-011), no one else is watching for this. cc must
count its own real touches to the same module/feature (checking
cc_chat_log's own recent entries, not memory) and, on the 3rd real round,
explicitly ask "is the underlying construction technique right, not just
this specific instance" BEFORE writing another patch — same bar as R-010,
self-applied.

**4. A prior ask that wasn't delivered is confirmed intent, not a fresh
request.** If Janis states something was asked before and not done
(check cc_chat_log for the real prior mention when possible), execute it
directly — do not ask for re-confirmation. DO flag prominently in
cc_chat_log that this closes a previously-open ask, so the gap itself
(why it wasn't done the first time) is on record, not just the fix.

Root cause this prevents: the BBQ firebox/chamber dual-end-cap saga
(BBQ-chambers-v15 through v20) — the same module was touched 6 real
times, CGAL passed clean at multiple intermediate points while the
actual written design intent was still wrong, and a solid-vs-hollow
flange defect shipped unquestioned for 5 versions before a direct visual
check (not a CGAL check) found it. The loop only closed once
`rules-bbq-fab.md`'s "Dual End-Cap Independence Convention" + QA
Simulation Checklist and `.claude/SKILL_joint_construction.md` RULE 4
existed to check against and reuse directly.

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
  new part/module's geometry within VM-01 or PR-01 specifically. Each module
  gets its own local origin (0,0,0) tied to a named DATUM_* via one
  translate() — never scattered world-Z formulas re-derived independently
  per module.
- .claude/SKILL_product_design_skeleton.md — read FIRST, before any other
  file, for any product line that is NOT VM-01 or PR-01. Establishes the
  Skeleton Layout + Datum Reference Frame with Janis before a single
  component is sized. VM-01/PR-01 are explicitly grandfathered out of this
  file's scope.

---

## COORDINATE SYSTEM — READ BEFORE ANY GEOMETRY WORK

This project uses automotive convention (locked in rules-dimensions.md):
  X = longitudinal (long axis), Y = lateral (width), Z = vertical (up)
  Origin = front-left corner at floor.

Before writing any rotate() or translate() for a directional component:
1. State the axis explicitly in a comment: // crossbar runs along X
2. Confirm rotation: along X = rotate([0,90,0]), along Y = rotate([90,0,0])
3. Never assume — derive from parameter names (bed_l → X, bed_w → Y)
