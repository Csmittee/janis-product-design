CC PROMPT — bbq-chamber-parting-shift-and-tray-init
================================================================
Repo locations:
- bbq-offset-smoker/BBQ-chambers-v21.scad (new, source v20)
- bbq-offset-smoker/BBQ-offset-smoker-base-v2.scad (new, source v1)

VERSION NOTE (corrected from the original draft of this prompt): source
is v20, not v18 — v18 and v19 were superseded by direct-cc rounds while
this prompt was queued (v19 = fire_cylinder_end_cap_2d() hole fix +
ash_tray() fully retired; v20 = outer_shell() flange rebuilt hollow,
was solid since v14). Neither of those rounds touched the fixed/lid
split or any datum this prompt depends on, but confirm that live rather
than assuming it (R-014 — state the real check, not an assumption).
Run this AFTER the understructure round (bbq-understructure-v12) —
TASK 2 below depends on that round's tray removal being real and merged.

REVISION NOTE: ONE round, TWO files, real cause-and-effect between them
— read both parts before starting either, so the reasoning connects.
The chamber's lid/fixed parting line shifts +50mm, which shortens the
lid AND creates a genuine 50mm band of always-fixed material (never
moves with the lid) on the Y=0 side. That new fixed band is the ONLY
reason the tray's hinges can mount where they do. Building these in the
same round, together, is deliberate — TASK 2 depends on TASK 1's real
output, not an assumed number.

Janis has confirmed this was already asked for (parting-line shift +
tray relocation) and not yet delivered — per chat_rules.md's Prompt
Writing discipline (R-014), this is confirmed intent, execute directly,
do not re-confirm scope with Janis mid-round.

BBQ-understructure's own tray was already removed in
BBQ-understructure-v12.scad (separate, complete round, run immediately
before this one) to make room for this relocation — confirm that's real
before building TASK 2.

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

Per R-014 (RULES.md) / chat_rules.md v3.13 Prompt Writing discipline:
where this round touches a locked, named convention, reuse it by name
(see rules-bbq-fab.md references below) — do not re-derive the
construction method from scratch. State the SPECIFIC real check
performed for every QA item, not a generic "confirmed no collision."

**MANDATORY FIRST CHECK**: confirm `BBQ-understructure-v12.scad` is
real and merged, and that `prep_shelf()`/`prep_shelves()`/
`tray_mount_bracket()` are genuinely absent from it. State the real,
live values in `BBQ-chambers-v20.scad` before touching anything: apex A
(expect 950mm), `chamber_floor_z` (expect 771.335mm), `chamfer` (expect
178.665mm), `GRATE_Z_FIXED` (expect 1000mm), `chamber_L` (expect
915mm), `DATUM_Y_CENTER` (expect 305mm), and the REAL current
fixed/lid split boundary (`fixed_side_wedge()`/`lid_side_wedge()`'s own
apex-A-to-ridge-midpoint reference line) — confirm today's real
boundary before changing it. These are expected UNCHANGED from v18
(v19/v20 touched the fire-cylinder end cap and the outer-shell flange
only), but confirm live rather than assuming carryover.

Task-specific reads:
1. bbq-offset-smoker/BBQ-chambers-v20.scad — LIVE, in full. Need
   `fixed_side_wedge()`, `lid_side_wedge()`, `lid_profile()`,
   `true_octagon_profile()`, `chamber_outer_tube()`,
   `chamber_inner_cavity()`, and the lid's own real construction
   (`lid()`/`lid_closed_panels()` or equivalent) in full — this is a
   real modification to the fixed/lid split, not a new independent cut.
2. bbq-offset-smoker/rules-bbq-fab.md — LIVE, in full. Reuse by NAME:
   the **Dual End-Cap Independence Convention** and the **Standing
   Orientation Convention** (lid opens toward Y=0 — confirm this still
   matches before building TASK 1). Also confirm whether the **Dual
   End-Cap Footprint Pattern** (RULE 4, .claude/SKILL_joint_construction.md)
   is relevant here — it is NOT (that pattern governs end-cap footprints,
   this round's split is the lid/fixed boundary, a different
   relationship) — state this distinction explicitly rather than
   silently reusing or silently ignoring it.
3. bbq-offset-smoker/BBQ-offset-smoker-base-v1.scad — LIVE, in full
   (confirm its real current content is purely the include chain).
4. bbq-offset-smoker/BBQ-understructure-v12.scad — LIVE, read only,
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

- `BBQ-chambers-v21.scad` (source v20)
- `BBQ-offset-smoker-base-v2.scad` (source v1) — FIRST real content
  ever added to this file. State explicitly in its header that its role
  changes from pure assembly-includer to the project's real accessories
  home (tray now; a lid counterbalance/fulcrum mechanism is the planned
  NEXT addition — Janis is still developing that concept, do NOT design
  or stub it this round, see TASK 3 below).

## 4. TASK 1 (BBQ-chambers-v21.scad) — Shift the lid/fixed parting line +50mm

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

**Mandatory real CGAL checks, all required, each stated with its
specific probe (per R-014)**:
- New fixed band vs. existing fixed shell: NON-EMPTY (state real
  contact area — genuine structural continuity, not a floating insert)
- Lid's own remaining material at the new boundary: ZERO gap, checked
  both with the lid closed AND through a real sweep of `lid_open_deg`
- Lid's real swept volume (full practical opening range) vs. new fixed
  band: EMPTY at every angle checked (state the angles swept and the
  result at each)
- Full assembly manifold sweep: `Simple: yes`, before proceeding to
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

**Mandatory real CGAL checks, all required, each stated with its
specific probe (per R-014)**:
- Hinge mount point vs. TASK 1's real new fixed band: NON-EMPTY
  (genuine contact), confirmed at every `lid_open_deg` in a real sweep
  — must never sit on or interfere with moving lid geometry at any
  angle
- Each tray's own full angle sweep (−90° to 0°, real steps) vs. the
  chamber shell, the lid (closed, the realistic in-use case), and the
  current understructure geometry (wheels, front bracket): EMPTY at
  every step checked (state the steps and result at each)
- Both trays deployed (0°) simultaneously vs. each other across the
  5mm gap: EMPTY (state real margin, not "clear")

## 6. TASK 3 — Counterbalance hinge: DO NOT DESIGN THIS ROUND

Do not create a module, stub, placeholder geometry, or toggle for the
lid counterbalance/fulcrum mechanism. State in the base file's own
header, plainly, that it is the next planned addition — a one-line
forward note, not code.

## 7. DO NOT TOUCH

- `BBQ-understructure-v12.scad` — read only (confirm tray removal per
  Mandatory Check), zero changes
- `BBQ-offset-smoker-base-v1.scad` — kept unchanged, on record
- `BBQ-chambers-v20.scad` — kept unchanged, on record
- Apex A's own real value (950mm), `chamber_floor_z`, `chamfer`, chamber
  body datums generally — UNCHANGED, only the fixed/lid MATERIAL split
  moves, no chamber datum itself moves
- The Dual End-Cap Independence Convention (rules-bbq-fab.md) — this
  round's TASK 1 is a different kind of split (lid vs. fixed, not
  inner-entity vs. outer-shell end caps) — do not conflate the two
  conventions or reuse one's construction method for the other without
  independently justifying it
- `fire_cylinder_end_cap_2d()` and `outer_shell()`'s flange (v19/v20's
  own real fixes) — unrelated to this round, do not touch

## 8. QA VERIFICATION

- [ ] Mandatory Check: understructure tray removal confirmed real, off
      BBQ-understructure-v12.scad
- [ ] TASK 1: real new fixed-zone top edge stated (expect 1000mm), all
      4 CGAL checks stated with their specific real probe/margin
- [ ] TASK 2: real tray dimensions stated, real hinge Z stated (read
      live from TASK 1), all 3 CGAL checks stated with their specific
      real probe/margin
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
5. Save both files (v20 and base-v1 kept, on record); update
   BBQ-offset-smoker-base-v2.scad's own include pointer to
   BBQ-chambers-v21.scad
6. Commit all → merge to main
