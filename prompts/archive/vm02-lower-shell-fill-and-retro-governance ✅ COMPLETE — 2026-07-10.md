# cc Prompt — VM-02: Lower Right-Compartment Metal Panel + Retroactive Governance Pass
# Date: 2026-07-10
# Two-part session: (1) real geometry fix, (2) retroactive New-Product-Line
# governance chain for VM-02, executed in that order — governance docs in
# Part 2 must be extracted from the file AFTER Part 1's geometry lands,
# not from the pre-fix state.

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in your
active context from earlier in THIS session, with no git pull/merge to
main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation —
  governance already current" and go straight to TASKS.
→ NO: FRESH. git fetch --all && git checkout main && git pull origin main.
  Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3 entries).
  State every file read before writing a line.

Before writing any fix (per R-009, RULES.md): confirm whether the
value/logic being changed exists in more than one place. State this
explicitly in cc_chat_log even if the answer is "no duplicates found."

Claude Web override: none

Task-specific reads (regardless of continuation/fresh):
- `vending-machine/VM-02-base/VM-02-base-v1.scad` (in full — this is your
  starting file for Part 1)
- `rules-dimensions.md` VM-02 sections (in full, current v33)
- `vending-machine/VM-02-base/PART_MANIFEST.md` (current v1.2)
- `vending-machine/design_scope_of_work_rule.md` (VM-01's existing file —
  read this as the STRUCTURAL TEMPLATE for Part 2, Task 2 below; do not
  copy its VM-01 content, mirror its structure/filter only)
- `.claude/SKILL_product_design_skeleton.md` (in full — read before
  starting Part 2, Tasks 3-5; this is authoritative for the worksheets'
  required format and file-output location, follow it exactly, do not
  invent a structure not specified there)

State the exact current v1.scad line count and confirm every file above
was read before writing anything.

## 2. CONTEXT

**Part 1 — real, confirmed design gap, not a regression.** Janis's
original spec (first VM-01 setup, restated today for VM-02): the right
compartment's lower zone (dashboard: screen, QR scanner, card reader,
speaker) should sit inside a SOLID sheet-metal panel, with the acrylic
display window starting only 50mm above the touchscreen's top edge
(Janis-confirmed today, keeping cc's existing `ACRYLIC_ZONE_MARGIN=50`)
and continuing up to the roofline. Live geometry check (done by Claude
Web this session, reading `outer_shell()` directly) confirms this has
NEVER been built — since VM-01-base-v6, the right-compartment front-face
cutout in `outer_shell()` has always spanned the ENTIRE lower zone height
as one continuous open hole, with the dashboard's screen/QR/card/speaker
floating in that open space with no surrounding panel. This is a genuine,
long-standing gap, not something this prompt broke — VM-01 (locked, out
of scope here) has the identical gap and is not being touched.

**Part 2 — retroactive governance.** When VM-02 was first derived
(`vm02-derivation-from-vm01-v58.md`), cc correctly flagged that VM-02 is
a new product line and the mandatory kickoff chain (scope file → Skeleton
Definition Worksheet → BOM Subassembly Tree → Kinetic Dual-View table)
was never run — proceeded anyway since the prompt inherited VM-01's whole
datum architecture. Janis's explicit decision: let the derivation +
direct-chat fixes finish, then run this chain RETROACTIVELY — confirming
against what was actually built, not a blind pre-spec. That point has
now been reached. Build all 3 worksheets + the scope file grounded in the
REAL, CURRENT VM-02-base-v2.scad (post Part 1 fix), not an idealized
version.

## 3. NEW FILES

- `vending-machine/VM-02-base/VM-02-base-v2.scad` (new, source v1 — Part
  1's geometry fix lands here)
- `vending-machine/design_scope_of_work_rule.md` already exists for
  VM-01 at the `vending-machine/` root — VM-02 needs its OWN file. Name
  it clearly distinct (e.g. `vending-machine/VM-02-design_scope_of_work_rule.md`
  or under `vending-machine/VM-02-base/`, whichever matches this
  project's actual existing naming convention more closely — state your
  choice and reasoning explicitly in cc_chat_log, this is a real naming
  decision, not a formality).
- Skeleton Definition Worksheet, BOM Subassembly Tree, Kinetic Dual-View
  table for VM-02 — file location and naming per
  `.claude/SKILL_product_design_skeleton.md`'s own convention (read
  first, per Section 1). Add each new file to `knowledge.map`.

## 4. TASKS

### PART 1 — TASK 1: Lower right-compartment metal panel

1.1. In `outer_shell()`, the existing "right compartment front face
     opening" cutout currently spans the full lower-zone height. Change
     it so the OPEN cutout only spans from `acrylic_zone_bot_z` (the
     live datum `dashboard()`/`acrylic_display()` already compute —
     reuse it, do not duplicate the number) up to the roofline (matching
     whatever the acrylic zone's own existing cutout logic already does
     there — verify from live code, do not assume a specific existing
     cutout shape).

1.2. Below `acrylic_zone_bot_z`, down to the compartment floor (`leg_h`
     local reference, matching how the rest of `outer_shell()` handles
     its local-Z convention — see rules-codes.md's local-vs-world-Z
     rule), the right-compartment front face must become SOLID shell
     material — same `skin_t` thickness as the rest of the shell, not a
     separate material/thickness.

1.3. Cut individual mounting cutouts into that new solid panel for each
     dashboard component: screen+bezel footprint, QR scanner, card
     reader, speaker grille. Each cutout = that component's own real
     footprint (read exact dimensions from `dashboard()`'s live code)
     PLUS this project's existing 2mm Global Clearance Tolerance
     convention on all sides (already used elsewhere — e.g. the acrylic/
     frame clearance work today; reuse the same convention, do not
     invent a new tolerance value).

1.4. All new Z-positions/heights must be DERIVED from the same live
     datums `dashboard()`/`acrylic_zone_bot_z` already use (`screen_top_z`,
     `DASH_MIN_Z`, etc.) — not hardcoded literals — since `total_h`/
     `screen_top_z` vary with `tray_count` (1-5), confirmed earlier today.

1.5. Mandatory CGAL sweep: confirm manifold-clean at `tray_count` = 1, 3,
     5 (screen_top_z clamps differently at each per today's earlier fix)
     — the panel and its cutouts must recompute correctly and stay clear
     of all dashboard hardware at every value, not just the default (3).
     Also confirm no new collision with `rear_service_door()`,
     `tray_zone_frame()`, or `compartment_divider()`.

## DO NOT TOUCH (Part 1)

- `acrylic_display()` itself — margin/position already Janis-confirmed
  today, zero change
- `tray_x_inset`/`product_w`/`tray_zone_frame()` — today's already-fixed
  tray/frame clearance work, zero change
- `legs()`, left-compartment door/tray geometry
- `VM-01-base-v58.scad` — locked, not touched

### PART 2 — TASK 2: `design_scope_of_work_rule.md` for VM-02

Mirror VM-01's existing file's exact structure (Product Identity,
Envelope Targets, Compartment/Section Map, Functional Features,
Appearance/Do-Not Features, Open Questions/Gaps) and its CORE FILTER
(owner-recognizable/marketing-headline content only — never construction
method, exact component specs, BOM, or dimensional/technical rules;
those stay in `rules-dimensions.md`/`PART_MANIFEST.md`).

Extract from: the ACTUAL built `VM-02-base-v2.scad` (post Part 1),
`PART_MANIFEST.md`, `rules-dimensions.md`'s VM-02 sections, and EVERY
VM-02 entry in `cc_chat_log.md` (explicit exception to the usual
first-3-entries rule — this is a full retroactive extraction, read all
of them). Do not invent or assume — if a section has no confirmed
source, write `NOT YET SPECIFIED BY OWNER`, same convention VM-01's file
uses.

### PART 2 — TASKS 3-5: Skeleton Definition Worksheet, BOM Subassembly Tree, Kinetic Dual-View table

Read `.claude/SKILL_product_design_skeleton.md` in full first (Section
1). Follow its own specified structure and file-output location exactly.
Complete all three IN ORDER, consuming Task 2's scope file content
directly (per that skill's own PREREQUISITE section).

Since this is retroactive: ground everything in what
`VM-02-base-v2.scad` ACTUALLY contains — real datums, real parent/child
offsets, real parts list, real moving parts with both end-states. Flag
any mismatch between what was built and what an ideal from-scratch
skeleton would look like as a normal note in the worksheet's own
findings — do NOT silently alter geometry to make the retroactive
worksheet "look right."

Kinetic Dual-View table must cover every moving part: front door
(`left_zone_door()`, open/closed), exit flap, EACH tray (index 0 through
`tray_count`-1, retracted/extended — note explicitly that this is a
per-tray vector, not a single shared state), rear service door if
hinged/openable.

## 5. DO NOT TOUCH

- `acrylic_display()`, `tray_x_inset`/`product_w`/`tray_zone_frame()`
  clearance fix (today's work), `legs()`
- `rules-dimensions.md` — read/append only (new VM-02 panel dimensions
  section), no existing rows edited
- `VM-01-base-v58.scad` — locked, not touched, not read for anything
  other than the scope-file structural template (Task 2)

## 6. QA VERIFICATION

- [ ] No undefined variable warnings in SCAD
- [ ] Version incremented — saved as v2, v1 untouched
- [ ] Metal panel + cutouts verified via real CGAL at tray_count 1/3/5 —
      `Simple: yes` throughout, state the actual output
- [ ] Cutout clearances use the existing 2mm Global Clearance Tolerance
      convention, not a new/guessed number — confirm explicitly
- [ ] `design_scope_of_work_rule.md` (VM-02) mirrors VM-01's structure +
      CORE FILTER, no invented content, `NOT YET SPECIFIED BY OWNER`
      used where source is missing
- [ ] Skeleton/BOM/Kinetic worksheets follow
      `SKILL_product_design_skeleton.md`'s own format exactly, built from
      what's actually in v2.scad, not a blind pre-spec

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, concise summary
   covering BOTH the geometry fix result AND all 3-4 governance
   artifacts (naming choices, key extracted content, any flagged
   mismatches)
2. Archive this prompt → `/prompts/archive/`
3. Update `knowledge.map` — new v2.scad + all new governance files, with
   their real final paths
4. Bump `rules-dimensions.md` version — add new VM-02 panel dimensions
   section
5. Commit all → merge to main
6. Tell Janis explicitly: final panel dimensions + cutout margins used,
   manifold sweep result, exact file paths for all 4 new governance
   documents, and any real mismatch the retroactive worksheets surfaced
   between what was built and what an ideal skeleton would specify
