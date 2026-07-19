CC PROMPT — bbq-chambers-v14.1-flat-tuckunder-trapezoid-passage
================================================================
Repo location: bbq-offset-smoker/BBQ-chambers-v14.1.scad (new, source
v14)

REVISION NOTE: targeted bug-fix + one real design-simplification round
on top of the just-merged v14 (PR #132). NOT a new negotiation — both
real problems below were already surfaced (one explicitly flagged by
cc's own v14 PR notes, one visually confirmed by Janis from the actual
render). Chamber apex(950mm)/firebox width(580mm)/fire-volume math —
ALL FROZEN, correct, do not re-touch. Understructure remains
completely out of scope, same as v14.

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in
your active context from earlier in THIS session, with no git
pull/merge to main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation
  — governance already current" and go straight to TASKS.
→ NO: FRESH. `git fetch --all && git checkout main && git pull origin
  main`. Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3
  entries). State every file read before writing a line.

Claude Web override: none

**MANDATORY FIRST CHECK** — confirm the real, live values currently in
BBQ-chambers-v14.scad: `chamber_floor_z`(expect 771.335), real apex A
(expect exactly 950mm), firebox width/Y-range (expect [15,595], 580mm),
inner duct real dimensions (expect 540×388.6mm, 460mm interior length),
outer shell real physical length (expect 480mm = 460 + 20mm flange),
and the real fire volume (expect ≈5,890.5in³, ≈103% of target). If ANY
differ from expected, STOP and flag before proceeding.

Task-specific reads:
1. bbq-offset-smoker/BBQ-chambers-v14.scad — LIVE, in full. State the
   real current `outer_shell()` end-cap/flange construction (the exact
   module(s) responsible for the 20mm tuck-under — this is TASK 1's
   target) and the real current passage-circle module (TASK 2's
   target, currently a plain 197mm circle per v14's own header).
2. `true_octagon_profile()`'s real boundary function — need the REAL
   boundary points at local h=0 (expect width=`BOT_W`-equivalent,
   ≈252.67mm centered on `DATUM_Y_CENTER`) and at local h=`chamfer`
   (≈178.665mm, expect full `chamber_W`=610mm width) — TASK 2's
   trapezoid is derived directly from these two real points, not
   hand-estimated.
3. Inner duct (`inner_duct()`) real Y-range/width (expect ≈540mm,
   centered on `DATUM_Y_CENTER`) — TASK 2's trapezoid must stay within
   this real footprint at every height, not just at its widest point.
4. .claude/SKILL_joint_construction.md
5. .claude/rules-codes.md

**Historical precedent**: this is the second round in a row where a
real coordinate/epsilon issue surfaced only after a real CGAL render
(v14 itself found and fixed 3 such issues during its own build). TASK
3 below asks you to specifically hunt for a 4th, adjacent to those —
don't assume the prior fixes were exhaustive just because the mandatory
checks passed; those checks tested contact/manifold status, not visual
double-surfaces in preview mode.

## 2. CONTEXT

**Problem 1 — real, visually confirmed**: the outer shell's tuck-under
was built as a partial-height notch/flange (only the top ~20mm band),
creating a visible STEP where that notch meets the shell's face below
it (screenshot: `make it flat not step straight down from top`,
provided by Janis). The fix is a real simplification, not added
complexity: make the ENTIRE outer shell rear face one flat plane,
pushed 20mm further under the chamber uniformly, full height — not a
partial notch. This works structurally because only the UPPER portion
of that flat face (from `chamber_floor_z` up to firebox top,
~228.7mm) touches real chamber material; the lower portion (firebox
floor 571.4mm up to `chamber_floor_z` 771.335mm) sits below the
chamber's own floor line where no material has ever existed at any
point in this project (same "no material below the floor" rule
`true_octagon_profile()` already follows) — so it simply sits in open
air there, no collision, no need for a separate notch shape.

**Problem 2 — real, explicitly flagged in v14's own PR, now resolved
by direction from Janis**: the 197mm circular passage does not fully
clear real chamber material (chord-shaped result, confirmed by cc).
Janis's direction, stated plainly: **stop treating this as
duct-shaped**. It is a hole in the CHAMBER's own octagon end cap only
— any shape is fine, the only real constraint is it must not extend
outside the inner duct's own real footprint (that's what it welds
against). Chosen shape: a **trapezoid that literally follows the
octagon's own real boundary** — narrow at the bottom, wide at the top
— positioned with its top edge 50mm below the firebox's own top
(heat/ash reasoning: keep the opening high, away from ash/fuel debris
at the firebox floor). This trapezoid should be derived DIRECTLY from
`true_octagon_profile()`'s own real boundary at local h=0 and
h=`chamfer` — not an invented taper. Real bonus, worth stating in your
response as a cross-check: the trapezoid's top edge (firebox
top(1000mm) − 50mm = 950mm) lands exactly on apex A (also 950mm) —
this is not a coincidence to re-derive differently, it's confirmation
the geometry is self-consistent; state this explicitly when you find
it.

**Problem 3 — real, unexplained visual anomaly, needs investigation
not reassurance**: Janis reports the firebox door area behaves
differently in OpenSCAD's F5 (preview) vs F6 (real CGAL render) — F5
preview does NOT show through into the firebox interior (looks solid/
occluded), while F6 render is correct. The chamber's own door does not
have this problem — you can see inside at F5 there already. This
smells like a leftover thin/duplicate surface (a coincident-face
z-fighting artifact, the same CLASS of issue as the "two
exact-coincident-face touches" v14 already found and fixed once) —
but do not assume that's the answer, investigate and state the real
cause.

## 3. NEW FILES

None. New `BBQ-chambers-v14.1.scad` (source v14).

## 4. TASKS

### TASK 1 — Outer shell rear face: flat, full-height, no step

Replace the current partial-height tuck-under notch with ONE flat
plane for the entire outer shell's rear face, shifted 20mm further
under the chamber (same 20mm value as before — this is not a size
change, only a shape change: full flat face instead of a stepped
notch).

Real verification required:
- Confirm via real `intersection()` that the UPPER portion of this
  flat face (world Z from `chamber_floor_z` to firebox top) has real,
  non-empty contact with the chamber's own octagon material — state
  the real contact area.
- Confirm the LOWER portion (world Z from firebox floor(571.4) to
  `chamber_floor_z`) has zero real chamber material to intersect with
  (expected — state this as a confirmed real check, not assumed) —
  this portion is structurally fine sitting in open space, matching
  how firebox material below the chamber floor has always been
  treated in this project.
- Confirm NO step/discontinuity remains in the face — one real
  continuous plane, full outer-shell height.
- Re-confirm the mandatory zero-contact check between this
  (now-reshaped) outer shell and the inner duct assembly still holds
  — do not assume the prior v14 check still applies to the new shape,
  re-run it.

### TASK 2 — Passage: octagon-derived trapezoid, replaces the circle

Retire the 197mm circle entirely. New passage = a trapezoid cut
through the chamber's own octagon end cap only (same location as
before — NOT through the inner duct's own end cap, which stays fully
sealed as already established).

Real construction:
- Bottom edge: at world Z = `chamber_floor_z` (local h=0). Width =
  the REAL `true_octagon_profile()` boundary width at h=0 (expect
  ≈`BOT_W`-equivalent, ≈252.67mm), inset by a real material margin —
  state the margin you use and why (structural weld-lip reasoning,
  same pattern as this project's other real material margins).
- Top edge: at world Z = firebox top(1000mm) − 50mm = 950mm (expect
  this to land exactly on apex A — confirm and state this real
  cross-check explicitly). Width = the real octagon boundary width at
  that height, CAPPED by the inner duct's own real footprint width
  (expect duct width ≈540mm is the binding constraint here, since the
  octagon itself is at full 610mm width by that height) — state
  clearly which constraint (octagon width vs. duct width) actually
  governs the top edge, don't assume it's the duct without checking.
- Both edges centered on `DATUM_Y_CENTER`, straight sides between
  them (a real trapezoid, not a curve-matched taper) — confirm via
  real check that every point along both slanted sides stays within
  BOTH the octagon's real material AND the inner duct's real
  footprint at that height, not just at the two edges.
- Real CGAL check: confirm this cut, unlike the old circle, produces
  NO chord/partial-clip result — full trapezoid clears real chamber
  material everywhere.

Add an in-code comment (module-level, not just file header) stating
this trapezoid's proportions are Janis's real design choice (heat-
rises/ash-avoidance reasoning), not a placeholder — this one IS a
locked spec, unlike v14's circle which was explicitly a placeholder.

### TASK 3 — Investigate F5/F6 door-area visual discrepancy

Do NOT reassure without a real answer. Investigate the actual geometry
near the firebox door/passage area for:
- Leftover thin/duplicate surfaces from the TASK 1/2 rework above, or
  residual from v14's own 3 previously-fixed coordinate bugs
- Any near-zero-thickness shell or coincident face causing OpenSCAD's
  F5 preview (raw, non-boolean-resolved) to render an apparent solid
  occlusion while F6's real CGAL boolean resolves correctly
- Compare directly against how the CHAMBER's own main door achieves a
  clean F5 preview (Janis's own reference point — "unlike the chamber,
  you can browse inside since F5 preview") — state what that module
  does differently, structurally, than the firebox door's construction

State a real, specific finding — which geometry, why it causes the F5
artifact, and the fix — not a general reassurance that F6 is correct
so it's fine. If no real cause is found after genuine investigation,
state that explicitly rather than guessing.

## 5. DO NOT TOUCH

- Chamber apex A(950mm), `chamber_floor_z` formula, `GRATE_Z_FIXED`,
  grate-to-apex gap(50mm) — all correct from v14, zero changes
- Firebox width(580mm)/Y-range, inner duct dimensions(540×388.6mm,
  460mm interior length) — all correct from v14, zero changes
- Real fire volume math/target(≈103%) — unaffected by either task,
  confirm unchanged, don't re-derive differently
- `BBQ-understructure-v4.scad` — entirely out of scope, do not open
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] Outer shell rear face: ONE flat plane, full height, no step —
      confirmed, screenshot shows continuous face
- [ ] Real contact confirmed: upper portion vs. chamber material
      (non-empty), lower portion vs. chamber material (empty, expected)
- [ ] Zero-contact check (outer shell vs. inner duct) RE-RUN against
      the new shape, confirmed still empty
- [ ] Trapezoid passage: real bottom width stated (from real octagon
      boundary at h=0), real top width stated (governing constraint —
      octagon or duct — identified explicitly)
- [ ] Real cross-check confirmed and stated: trapezoid top edge (950mm)
      = apex A (950mm)
- [ ] Real CGAL check: trapezoid produces NO chord/partial-clip result,
      full shape clears real material
- [ ] In-code comment present: trapezoid is a locked spec, not a
      placeholder (contrast explicitly with v14's retired circle)
- [ ] F5/F6 door discrepancy: real specific cause stated (or genuine
      "investigated, no cause found" if that's the honest result) —
      not a general reassurance
- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Full kinetic sweep (lid, firebox door) — `Simple: yes` throughout
- [ ] 4-angle screenshots (iso/front/side/rear) PLUS one real
      look-through-the-open-firebox-door F6 shot PLUS one F5 PREVIEW
      screenshot of the same door-open view (for direct before/after
      comparison on Problem 3) PLUS one dimensioned view showing the
      trapezoid's real 4 corner coordinates
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: state
   the flat-face fix confirmation, real trapezoid dimensions + the
   apex-A cross-check, and the F5/F6 investigation's real finding.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-20
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md —
   retire the old circular-passage module entry, add the new trapezoid
   passage module (flagged as LOCKED spec, not placeholder, contrast
   with v14's retired circle), note the flat-face simplification
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md`'s Envelope
   section: passage now trapezoid (real dimensions), outer shell rear
   face now single flat plane, bump version
5. Save as BBQ-chambers-v14.1.scad (v14 kept); update
   BBQ-offset-smoker-base-v1.scad's include v14→v14.1 (confirm real
   include chain location first, same check prior rounds required)
6. Commit all → merge to main
