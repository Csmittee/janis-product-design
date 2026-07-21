CC PROMPT — bbq-chamber-parting-shift-and-tray-init
================================================================
Repo locations:
- bbq-offset-smoker/BBQ-chambers-v19.scad (new, source v18)
- bbq-offset-smoker/BBQ-offset-smoker-base-v2.scad (new, source v1)

REVISION NOTE: ONE round, TWO files, real cause-and-effect between them
— read both parts before starting either, so the reasoning connects.
The chamber's lid/fixed parting line shifts +50mm, which shortens the
lid AND creates a genuine 50mm band of always-fixed material (never
moves with the lid) on the Y=0 side. That new fixed band is the ONLY
reason the tray's hinges can mount where they do. Building these in the
same round, together, is deliberate — TASK 2 depends on TASK 1's real
output, not an assumed number.

BBQ-understructure's own tray was already removed in
BBQ-understructure-v10.scad (separate, complete round) to make room for
this relocation — confirm that's real before building TASK 2.

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in
your active context from earlier in THIS session, with no git
pull/merge to main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation —
  governance already current" and go straight to TASKS.
→ NO: FRESH. `git fetch --all && git checkout main && git pull origin
  main`. Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3
  entries). State every file read before writing a line.

Claude Web override: none

**MANDATORY FIRST CHECK**: confirm `BBQ-understructure-v10.scad` is
real and merged, and that `prep_shelf()`/`prep_shelves()`/
`tray_mount_bracket()` are genuinely absent from it. State the real,
live values in `BBQ-chambers-v18.scad` before touching anything: apex A
(expect 950mm), `chamber_floor_z` (expect 771.335mm), `chamfer` (expect
178.665mm), `GRATE_Z_FIXED` (expect 1000mm), `chamber_L` (expect
915mm), `DATUM_Y_CENTER` (expect 305mm), and the REAL current
fixed/lid split boundary (`fixed_side_wedge()`/`lid_side_wedge()`'s own
apex-A-to-ridge-midpoint reference line) — confirm today's real
boundary before changing it.

Task-specific reads:
1. bbq-offset-smoker/BBQ-chambers-v18.scad — LIVE, in full. Need
   `fixed_side_wedge()`, `lid_side_wedge()`, `lid_profile()`,
   `true_octagon_profile()`, `chamber_outer_tube()`,
   `chamber_inner_cavity()`, and the lid's own real construction
   (`lid()`/`lid_closed_panels()` or equivalent) in full — this is a
   real modification to the fixed/lid split, not a new independent cut.
2. bbq-offset-smoker/rules-bbq-fab.md — LIVE, in full. The Dual End-Cap
   Independence Convention and Standing Orientation Convention both
   bear directly on this round (lid opens toward Y=0 — confirm this
   still matches before building TASK 1).
3. bbq-offset-smoker/BBQ-offset-smoker-base-v1.scad — LIVE, in full
   (confirm its real current content is purely the include chain).
4. bbq-offset-smoker/BBQ-understructure-v10.scad — LIVE, read only,
   confirm tray removal per Mandatory Check above.
5. .claude/rules-codes.md
6. .claude/SKILL_joint_construction.md

## 2. CONTEXT

**Why this round exists, stated plainly so the reasoning carries
through both tasks**: the lid currently opens all the way down to real
apex A (world Z=950mm). Janis wants a shorter door — the lid's own
opening material should start 50mm higher, at Z=1000mm (the same real
height as `GRATE_Z_FIXED`, where the grate/food actually sits). The
50mm of material this reclaims (world Z=[950,1000] on the Y=0/lid
side) becomes genuine FIXED, non-moving material — solid regardless of
`lid_open_deg` — specifically so there's real structural material to
weld tray hinges to, instead of hinges having nowhere safe to mount
except onto the lid itself (which would mean the tray moves every time
the lid opens — not what's wanted).

Real numbers both tasks depend on:
- New fixed-zone top edge on the Y=0 side: **Z=1000mm** (was Z=950mm/
  apex A)
- New band of always-fixed material: **world Z=[950,1000], 50mm tall**,
  at real Y=0, full `chamber_L` length
- Tray hinge mount Z: **980mm** (20mm below the new fixed-zone top
  edge, i.e. inside the new 50mm band with real margin on both sides —
  30mm above apex A, 20mm below the new lid-start line)

## 3. NEW FILES

- `BBQ-chambers-v19.scad` (source v18)
- `BBQ-offset-smoker-base-v2.scad` (source v1) — FIRST real content
  ever added to this file. State explicitly in its header that its role
  changes from pure assembly-includer to the project's real accessories
  home (tray now; a lid counterbalance/fulcrum mechanism is the planned
  NEXT addition — Janis is still developing that concept, do NOT design
  or stub it this round, see TASK 3 below).

## 4. TASK 1 (BBQ-chambers-v19.scad) — Shift the lid/fixed parting line +50mm

Real requirement: on the Y=0 side, real FIXED (non-lid) material must
now span from the existing wall/floor material up through world
Z=1000mm (was Z=950mm/apex A) — a new 50mm-tall band of genuinely fixed
wall material between the two. The lid's own real material/opening
must correspondingly start 50mm higher than it does today, so the
overall envelope is unchanged (no new material is added beyond this
band; the lid gets shorter by exactly what the fixed band gains).

This is a real modification to `fixed_side_wedge()`/`lid_side_wedge()`
(or whatever real construction currently defines the fixed/lid split)
— not a brand-new independent cut layered on top. State your own real
construction method (e.g., a small additional fixed-material insert
spanning the new band, unioned into the existing fixed shell, with the
lid's own material correspondingly clipped/shortened to no longer
include that band) and why you chose it.

**Mandatory real CGAL checks, all required**:
- The new fixed band makes genuine, non-empty contact with the existing
  fixed shell (real structural continuity, not a floating insert)
- The lid's own remaining material has ZERO gap where the band was
  removed from its territory — real continuity check at the new
  boundary, both with the lid closed and through a real sweep of
  `lid_open_deg`
- The lid's real swept volume (through its full practical opening
  range) does NOT collide with the new fixed band at any angle — this
  is the band's whole purpose (staying out of the lid's way), verify it
  actually does
- Full assembly manifold sweep, `Simple: yes`, before proceeding to
  TASK 2

State the real, final world-Z value of the new fixed-zone top edge
explicitly (expect exactly 1000mm) — TASK 2 depends on this being
real, not assumed.

## 5. TASK 2 (BBQ-offset-smoker-base-v2.scad) — Build the tray

Only proceed once TASK 1's real CGAL checks above are confirmed clean.

Real dimensions, Janis's own spec:
- Total span = `chamber_L`(915mm, read live) along X
- 2 trays, each `chamber_L/2` = **457.5mm** long (X), **300mm** deep
  (Y, projecting outward when deployed)
- **5mm gap** between the two trays (assembly tolerance), ADDITIVE —
  total real span 920mm, confirm you built it additive not absorbed
- Construction: welded steel frame + 2mm plate (thin-shell
  representation, consistent with this project's existing sheet-metal
  parts)
- Mounted ONLY on the Y=0 side — confirm no tray/mount geometry exists
  on the Y=chamber_W side

Hinges: each tray gets **2 hinges**, mounted to the REAL fixed band
from TASK 1, at **Z=980mm** (read TASK 1's real confirmed fixed-zone
top edge live — do not hardcode 980 if TASK 1's real result differs
from the expected 1000mm top edge).

Kinetic parameter: each tray gets its OWN independent angle parameter
(not shared) — real range **−90° (stowed, vertical) to 0° (deployed,
horizontal)**. State your real chosen parameter names.

**Mandatory real CGAL checks, all required**:
- Hinge mount point vs. TASK 1's real new fixed band: NON-EMPTY (genuine
  contact), confirmed at every `lid_open_deg` in a real sweep — must
  never sit on or interfere with moving lid geometry at any angle
- Each tray's own full angle sweep (−90° to 0°, real steps) vs. the
  chamber shell, the lid (closed, the realistic in-use case), and the
  current understructure geometry (wheels, front bracket) — state real
  results, EMPTY expected
- Both trays deployed (0°) simultaneously — real check they don't
  collide with each other across the 5mm gap

## 6. TASK 3 — Counterbalance hinge: DO NOT DESIGN THIS ROUND

Do not create a module, stub, placeholder geometry, or toggle for the
lid counterbalance/fulcrum mechanism. State in the base file's own
header, plainly, that it is the next planned addition — a one-line
forward note, not code.

## 7. DO NOT TOUCH

- `BBQ-understructure-v10.scad` — read only (confirm tray removal per
  Mandatory Check), zero changes
- `BBQ-offset-smoker-base-v1.scad` — kept unchanged, on record
- `BBQ-chambers-v18.scad` — kept unchanged, on record
- Apex A's own real value (950mm), `chamber_floor_z`, `chamfer`, chamber
  body datums generally — UNCHANGED, only the fixed/lid MATERIAL split
  moves, no chamber datum itself moves
- The Dual End-Cap Independence Convention (rules-bbq-fab.md) — this
  round's TASK 1 is a different kind of split (lid vs. fixed, not
  inner-entity vs. outer-shell end caps) — do not conflate the two
  conventions or reuse one's construction method for the other without
  independently justifying it

## 8. QA VERIFICATION

- [ ] Mandatory Check: understructure tray removal confirmed real
- [ ] TASK 1: real new fixed-zone top edge stated (expect 1000mm), all
      4 CGAL checks (fixed-band contact, lid continuity, lid-sweep
      clearance, full assembly manifold) stated explicitly
- [ ] TASK 2: real tray dimensions stated, real hinge Z stated (read
      live from TASK 1), all 3 CGAL checks (hinge-vs-lid-sweep,
      per-tray angle sweep, dual-tray self-clearance) stated explicitly
- [ ] TASK 3: confirmed zero counterbalance code written, header note
      present
- [ ] Full CGAL manifold sweep, `Simple: yes`, both files combined via
      the base file's own include chain
- [ ] Full kinetic sweep (lid, both tray angles independently, existing
      understructure kinetics) — `Simple: yes` throughout
- [ ] Screenshots: iso/front/side + lid open showing the new fixed band
      + both trays deployed + both trays stowed + mixed state
- [ ] Error-Log clean

## 9. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: real
   new fixed-zone top edge, real CGAL results for both tasks, real
   tray dimensions and hinge Z.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md — new
   fixed-band geometry in the chambers table, NEW "Accessories" branch
   with the tray as its first entry, parented to the real new fixed-zone
   datum
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md` — lid's real
   new shortened envelope, tray's real relocated spec
5. Save both files (v18 and base-v1 kept, on record); update
   BBQ-offset-smoker-base-v2.scad's own include pointer to
   BBQ-chambers-v19.scad
6. Commit all → merge to main
