CC PROMPT — bbq-understructure-v3-wheel-height-tray-handle
================================================================
Repo location: bbq-offset-smoker/BBQ-understructure-v3.scad (new,
source v2)

REVISION NOTE: this SUPERSEDES the prior queued
bbq-understructure-v3-wheel-size-dual-front-wheel prompt — that draft
covered wheel size + front wheel count only. Real render review by
Janis (actual screenshots of the merged v2 build) surfaced 4 real
issues together, confirmed and locked across this session. This is
ONE run covering all 4 — do not partially implement and stop, but DO
flag honestly (same as v2's own log did) anywhere a task can't be
fully verified.

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

Task-specific reads (read regardless of continuation/fresh):
1. bbq-offset-smoker/BBQ-chambers-v11.scad — confirm still the live
   chambers file (not v10). State real values: chamber_W, chamfer,
   chamber_floor_z, firebox_x0/size/y0/y1, firebox_floor_z,
   DATUM_Y_CENTER, DATUM_X_FRONT, `true_octagon_profile()`'s own point
   coordinates (need apex A specifically, see TASK 3), lid parting-line
   reference, exhaust_room()/ROOM_D geometry.
2. bbq-offset-smoker/BBQ-understructure-v2.scad — LIVE file, in full.
   State current real values: WHEEL_D/WHEEL_R, REAR_AXLE_X/
   REAR_TRACK_WIDTH/REAR_AXLE_Z/REAR_BRACKET_H, MID_H/TOP_W/BOT_W/
   LEG_GAP/LEG_DROP/FRONT_X, CASTER_X/CASTER_PLATE_SIZE/
   CASTER_WHEEL_D, TRIANGLE_APEX_X/TRIANGLE_BASE_X/TRIANGLE_Z/
   HINGE_X/HANDLE_LEN/HANDLE_D, prep_shelf()'s own mount formula.
3. .claude/SKILL_joint_construction.md
4. .claude/rules-codes.md
5. bbq-offset-smoker/design_scope_of_work_rule.md — Envelope section
   (grate height control value, being changed this session — see
   TASK 2)

## 2. CONTEXT

Real render review by Janis this session (actual screenshots of the
merged v2 build, not a description) found 4 things, all confirmed and
locked in chat before this prompt was written:

1. Wheel size too large (609.6mm/24") and front caster built with only
   ONE wheel — visibly passes through the front bracket's own legs.
2. **Grate height control value CHANGED**: the project's original
   700mm/750mm target (rules-dimensions.md's BBQ section /
   design_scope_of_work_rule.md's Envelope section) is SUPERSEDED —
   Janis re-verified ergonomic reach height and the new locked target
   is **900–1000mm (90–100cm) from true ground**, superseding
   700–750mm. Update design_scope_of_work_rule.md's Envelope section
   to reflect this (see TASK 2/closing).
3. The two fold-up prep trays (`prep_shelves()`) are built floating in
   space — mounted at an arbitrary X/Z point with no real weld/contact
   to the chamber's own solid shell. They must attach to real chamber
   material near apex A of the octagon cross-section (the lowest
   vertex, same reference point the lid's own parting line uses) —
   this is where the lid/door area touches down, per Janis's own
   description.
4. The tow handle + triangle bracket (Task 3 in v2) was built as an
   INDEPENDENT mechanism, explicitly not sharing any mount/axle with
   the front caster (Task 2). Janis's actual intent, confirmed via a
   real reference photo this session (industry precedent — a
   fabricated offset smoker with an identical mechanism): the triangle
   bracket + handle is RIGIDLY WELDED to the front axle/caster yoke.
   Swinging the handle left/right physically steers the front wheels —
   one linked motion, same principle as a hand-truck/pallet-jack pull
   handle. Also: the handle itself must be a real T-shaped crossbar
   (grip bar perpendicular to the upright), not the plain round bar v2
   built, with a fold angle input (0° = towing/use position, 90° =
   folded vertical for storage) using the SAME angle-parameter
   convention as this project's door/lid open-angle params.

Additionally, per Janis's own reference photo this session: once
chamber+firebox (frozen) and understructure (wheel-diameter-
constrained) are merged, real gaps WILL appear between the front
bracket's/rear strut's confirmed mounting points and wherever the new
wheel axles actually need to sit. This is expected and normal
(industry practice, per Janis) — close each gap with a dedicated
SPACER BRACKET, a new, separately-dimensioned element, rather than
altering the confirmed bracket/strut geometry itself. Two places:
- FRONT: ONE spacer, centered, between the front bracket's confirmed
  bottom plate and the caster axle/pivot.
- REAR: TWO spacers, one left and one right of the firebox, each
  pushing its own wheel's axle outward clear of the firebox — not a
  single center spacer like the front.

**DO NOT TOUCH, confirmed correct, zero changes this round:**
- `BBQ-chambers-v11.scad` — entirely locked, read only
- Front bracket's own leg/bottom-plate geometry: `MID_H`, `TOP_W`,
  `BOT_W`, `LEG_GAP`, `LEG_DROP`, `FRONT_X`, the two-trapezoid-leg +
  bottom-plate construction — confirmed correct, real gaps get
  absorbed by the NEW spacer element (TASK 2), not by changing this
  shape
- Rear strut's own construction and `REAR_AXLE_X`/`REAR_TRACK_WIDTH`
  horizontal positions — same principle, gaps absorbed by the new
  rear spacers (TASK 2), not by redesigning the struts

## 3. NEW FILES

None. New `BBQ-understructure-v3.scad` (source v2).

## 4. TASKS

### TASK 1 — Wheel size + true 4-wheel system

```
WHEEL_D = 400   // was 609.6 -- real ~40cm, per Janis's explicit spec
WHEEL_R = 200
```

Single source, consumed by BOTH rear axle wheels (Task, unchanged
count/position) AND the front caster. Front caster changes from ONE
wheel to TWO: keep the SAME single swivel pivot / mounting location
(unchanged — one pivot, not two), add a real stub axle through that
pivot carrying two wheels side-by-side, symmetric about
`DATUM_Y_CENTER`. Pick a reasonable off-shelf dual-wheel spacing,
state reasoning, flag as placeholder if no real hardware spec exists.

Tire width placeholder: same proportion or reduced slightly for the
smaller wheel — your call, state reasoning.

### TASK 2 — Global height lift to hit grate target 900–1000mm, plus spacer brackets

**Locked target** (supersedes old 700–750mm): grate height,
world-Z-from-true-ground, must land in **900–1000mm**. Pick a specific
value within that range based on what's geometrically cleanest given
the real numbers below — state the chosen value and reasoning
explicitly, don't just report "in range."

Mechanism, do NOT deviate from this approach: `BBQ-chambers-v11.scad`
is completely locked (chamber_floor_z, GRATE_Z formula, everything —
zero changes). The lift must be achieved entirely at the
UNDERSTRUCTURE level, by introducing ONE new shared "ground offset"
constant that both the rear axle and the front caster consume
consistently, so the whole vehicle stance stays level. Concretely: the
wheels' ground-contact point moves to `local Z = -GROUND_OFFSET`
(instead of v2's `local Z = 0`), which lengthens the rear
strut/bracket and the front bracket-to-axle spacer accordingly — the
chamber/firebox themselves never move in their own local frame, the
GROUND shifts relative to them.

Re-derive and state the real numbers:
- New `REAR_AXLE_Z`, `REAR_BRACKET_H` at the new `WHEEL_R` + new
  `GROUND_OFFSET`
- New front caster axle Z position

Real verification required: confirm no strut/spacer length goes to
zero or negative anywhere, and re-run the full kinetic sweep to
confirm no new ground-clearance conflict was introduced (e.g. firebox
underside, prep shelf, front bracket bottom plate all still clear of
the new true-ground plane). If 900–1000mm is genuinely not achievable
without a real conflict, state exactly what conflicts and by how much
— do not force a bad geometry through.

**Spacer brackets** (new elements, real computed lengths — the
confirmed bracket/strut shapes above are NOT altered to make room,
this is what absorbs the gap instead):
- FRONT: ONE spacer, centered on `CASTER_X`/`DATUM_Y_CENTER`, bridging
  the front bracket's confirmed bottom plate down (or up, whichever
  the real math requires) to the caster axle/pivot's new Z position.
- REAR: TWO spacers, symmetric left/right of the firebox
  (`REAR_WHEEL_Y_LEFT`/`REAR_WHEEL_Y_RIGHT`), each connecting the rear
  strut/beam's confirmed mount point out to its own wheel axle,
  pushing the wheel clear of the firebox at the new geometry.

State each spacer's real computed length/position — not a placeholder
guess — and run a real CGAL check confirming each spacer actually
bridges (touches/overlaps appropriately) both the fixed bracket side
and the wheel-axle side, no floating gap left on either end.

### TASK 3 — Prep tray reattachment (apex A)

`prep_shelf()`/`prep_shelves()` currently mount at an arbitrary
X/Z point (`DATUM_X_FRONT + LEG_INSET`, `Z = chamber_floor_z`) with no
real contact to the chamber's own shell — confirmed floating in the
render, not acceptable.

Fix: derive the real world coordinates of octagon point "apex A" (the
lowest vertex of `true_octagon_profile()` — same reference the lid's
own parting line uses) directly from the LIVE chambers file — do not
estimate or reuse an old constant. Re-hinge both trays from real
chamber shell material at that vertex/edge, on the chamber's front
face near where the door/lid area touches down. Real CGAL contact
check required: the tray's mount bracket must show actual shared
material/contact with the chamber's fixed shell, not a visual-only
proximity.

Keep the existing kinetic behavior (`shelf_deployed` true=horizontal/
false=vertical-stowed) and existing shelf dimensions
(`chamber_L*0.35` x `SHELF_D` x `SHELF_T`) — only the MOUNT point/
attachment changes, not the tray's own size. Re-verify the existing
empty-intersection result vs. the front bracket/spacers still holds at
the new mount position and new stack height (state the real check, not
assumed unaffected).

This is a single first tray per side, per Janis's note — she plans
more along the chamber length later, not in this prompt.

### TASK 4 — T-bar tow handle, welded to front axle (coupled steering)

This REPLACES v2's Task 3 design assumption (triangle/handle
"entirely independent" of the front caster) — that assumption was
wrong, corrected this session via Janis's own reference photo.

New design intent:
- The triangle bracket (top-view triangle, apex pointing away from the
  exhaust room — keep this part of v2's geometry/orientation logic)
  is now RIGIDLY WELDED to the front axle/caster yoke — same physical
  assembly, not two separate mounts. Swinging the handle left/right
  (a single `steer_deg`-equivalent rotation) must now ALSO rotate the
  front caster wheels by the same amount — one linked motion, not
  independent parameters. Reconcile this against TASK 1/2's dual-wheel
  front caster: the whole front wheel pair swivels together with the
  handle.
- Handle itself: real T-shaped crossbar — a grip bar mounted
  perpendicular to the top of the upright member, not the plain round
  bar v2 built. State real dimensions chosen (length/diameter of both
  the upright and the crossbar), flag as placeholder if no exact
  hardware spec given.
- Fold angle: single kinetic parameter, SAME convention as this
  project's door/lid open-angle params — 0° = towing/use position
  (down, roughly horizontal), 90° = folded vertical for storage. Name
  it consistently with the existing convention (e.g.
  `handle_fold_deg`) rather than reusing v2's old `handle_tilt_deg` if
  the rotation math changes meaningfully — state which you used and
  why.

Mandatory real verification, do not assume old numbers hold:
- Real CGAL check: handle assembly at full-fold (storage) position
  clears `exhaust_room()` — re-derive the real margin from the LIVE
  chambers file at the NEW lift height (TASK 2) and NEW coupled
  geometry. The old 137.5mm/155mm clearance numbers were computed for
  v2's independent design at the old height — do not reuse them
  without re-checking.
- Real CGAL check: the coupled front-wheel steer sweep (whatever
  real range the handle can physically swing) doesn't bring either
  front wheel into the front bracket, its new spacer (TASK 2), or the
  prep trays (TASK 3) at any angle in the sweep — not just the
  centered/forward-facing default.
- Real CGAL check: the weld/attachment between the triangle bracket
  and the front axle/caster yoke is genuine shared material, not a
  floating near-touch.

## 5. DO NOT TOUCH

- `BBQ-chambers-v11.scad` — entirely locked, read only, zero changes
- Front bracket's own leg/bottom-plate geometry: `MID_H`, `TOP_W`,
  `BOT_W`, `LEG_GAP`, `LEG_DROP`, `FRONT_X` — confirmed correct, real
  gaps from wheel/height changes are absorbed by TASK 2's new spacer
  elements, never by altering this shape
- Rear strut's own construction, `REAR_AXLE_X`/`REAR_TRACK_WIDTH`
  horizontal positions — same principle, absorbed by TASK 2's rear
  spacers, not a strut redesign
- Tray SIZE (`chamber_L*0.35` x `SHELF_D` x `SHELF_T`) and its
  deployed/stowed kinetic behavior — only the MOUNT point changes
  (TASK 3)
- rules-dimensions.md, cc_rules.md — read only (note: this prompt's
  TASK 2 does require updating design_scope_of_work_rule.md's Envelope
  section grate-height figure — that file is NOT in this read-only
  list, see Mandatory Closing)

## 6. QA VERIFICATION

- [ ] `WHEEL_D`/`WHEEL_R` = 400/200, single source, both axles + front
      caster's two wheels consume it
- [ ] Front caster: TWO wheels, symmetric about `DATUM_Y_CENTER`, one
      shared pivot — real dual-wheel spacing stated
- [ ] Grate height: real chosen value stated within 900–1000mm, OR a
      real conflict stated explicitly if unachievable
- [ ] `GROUND_OFFSET` (or equivalent) stated as a real number, applied
      consistently to rear axle AND front caster
- [ ] Rear `REAR_AXLE_Z`/`REAR_BRACKET_H` recomputed at new
      radius+offset, real numbers stated
- [ ] Front spacer (1, centered): real length/position stated, real
      CGAL contact check on both ends
- [ ] Rear spacers (2, left+right of firebox): real lengths/positions
      stated, real CGAL contact check on all ends
- [ ] No strut/spacer length is zero or negative anywhere — confirmed
      explicitly
- [ ] Prep trays: real apex-A world coordinates derived from the LIVE
      chambers file, stated explicitly (not estimated)
- [ ] Prep trays: real CGAL contact check confirms actual shared
      material with the chamber shell — not floating
- [ ] Prep tray size/kinetic behavior confirmed unchanged — real diff
      stated
- [ ] T-bar handle: real crossbar dimensions stated
- [ ] Fold angle kinetic parameter implemented, 0°/90° states verified
- [ ] Triangle bracket confirmed rigidly attached (real CGAL
      shared-material check) to the front axle/caster yoke
- [ ] Coupled steering: front wheel pair rotation matches handle swing
      — confirmed via real geometry, not assumed
- [ ] Real CGAL check: handle at full-fold vs. `exhaust_room()` at the
      NEW lift height — real margin stated, old numbers NOT reused
      without re-verification
- [ ] Real CGAL check: coupled steer sweep vs. front bracket/spacer/
      prep trays at multiple angles, not just centered
- [ ] Front bracket's own MID_H/TOP_W/BOT_W/LEG_GAP/LEG_DROP/FRONT_X:
      zero diff from v2 — state a real diff confirming this
      explicitly
- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Full kinetic sweep (fold angle, coupled steer, lid, door, tray,
      shelf-deployed states, combined) — `Simple: yes` throughout
- [ ] 4-angle screenshots (iso/front/side/rear) + 1 with handle folded
      to storage + 1 with steer swung to a real non-centered angle
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: state
   new WHEEL_D/WHEEL_R, chosen grate height + GROUND_OFFSET, front/rear
   spacer real lengths, apex-A real coordinates used for tray mount,
   T-bar dimensions + fold convention name, coupled-steering
   confirmation, and all real CGAL check results (contact/interference/
   clearance) — flag honestly if any target (esp. 900-1000mm grate)
   wasn't fully achievable.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-17
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md for:
   dual-wheel front caster, spacer brackets (front+rear), tray
   reattachment, T-bar coupled-steer handle
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md`'s Envelope
   section: grate height control value 700–750mm → 900–1000mm
   (900–1000mm locked, superseding old figure per Janis 2026-07-17),
   bump that file's version
5. Save as BBQ-understructure-v3.scad (v2 kept per convention); update
   BBQ-offset-smoker-base-v1.scad's include v2→v3
6. Commit all → merge to main
