CC PROMPT — bbq-understructure-v2-axles-swivel-handle
================================================================
Repo location: bbq-offset-smoker/BBQ-understructure.scad (edit in
place, save as v2)

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. bbq-offset-smoker/rules-bbq-fab.md (includes the new Standing
   Orientation Convention — exhaust=left, firebox=right, door toward
   user, when facing the smoker — locked in a prior session this week)
5. bbq-offset-smoker/SKELETON_WORKSHEET.md
6. bbq-offset-smoker/BBQ-chambers-v3.scad (or whatever version is
   actually live — confirm the real current filename/version from the
   repo, do not assume v3 is current) — this file's own DATUM_* /
   chamber_* constants are the parent for everything below
7. bbq-offset-smoker/BBQ-understructure.scad (the LIVE file, in full —
   currently placeholder-level legs()/casters()/tow_handle(), being
   substantially replaced by this prompt)
8. .claude/SKILL_joint_construction.md
9. .claude/rules-codes.md

## 2. CONTEXT

The existing legs()/casters()/tow_handle() were explicit placeholders
from the original v1-init prompt ("basic placeholder pass, low churn").
This prompt replaces them with a fully-specified real mechanism, derived
through direct calculation with Janis (not sandbox-verified by Claude
Web this session, per her explicit instruction — cc's own full QA
remains mandatory as always).

This is two genuinely different axle mechanisms, not four identical
wheels:
- REAR: fixed, non-swivel, mounted under the firebox
- FRONT: single-swivel caster (steering), with a triangular bracket
  carrying a hinged, tiltable tow handle

All coordinates below are real numbers, derived step by step (wheel
size → clearances → structural stack), not estimates. Where Claude Web
made an explicit choice rather than deriving from a given constraint,
it's flagged — verify those specifically, don't just build past them.

## 3. NEW FILES

None. Editing bbq-offset-smoker/BBQ-understructure.scad in place.

## 4. TASKS

### TASK 1 — Rear axle (fixed, non-swivel, under firebox)

```
WHEEL_D = 609.6        // 24" wheel including tire
WHEEL_R = 304.8         // 305mm, rounded
FIREBOX_CLEARANCE = 200 // Janis's spec, each side, avoid heat

// firebox footprint (read live values, do not hardcode from this
// prompt — confirm firebox_x0/firebox_size/DATUM_Y_CENTER match):
// firebox_x0 = DATUM_X_REAR (915), firebox_size = 457,
// firebox spans Y: DATUM_Y_CENTER - firebox_size/2 to +firebox_size/2
//   = 76.5 to 533.5

REAR_AXLE_X = firebox_x0 + firebox_size/2   // 1143.5 — centered on
                                              // firebox midpoint
REAR_WHEEL_Y_LEFT  = 76.5 - FIREBOX_CLEARANCE    // -123.5
REAR_WHEEL_Y_RIGHT = 533.5 + FIREBOX_CLEARANCE   // 733.5
REAR_TRACK_WIDTH = REAR_WHEEL_Y_RIGHT - REAR_WHEEL_Y_LEFT  // 857mm

REAR_AXLE_Z = WHEEL_R   // 305 — ground contact, wheel radius
REAR_BRACKET_H = firebox_floor_z - REAR_AXLE_Z  // 400 - 305 = 95mm
```

Build: a simple fixed drop-bracket (95mm tall, wall_t-ish plate/tube
construction, your choice of reasonable structural cross-section) from
the firebox underside (firebox_floor_z, at REAR_AXLE_X) down to
REAR_AXLE_Z, with a transverse axle beam at the bottom spanning
REAR_TRACK_WIDTH (Y: -123.5 to 733.5), wheel placeholder (simple
cylinder, WHEEL_D diameter, reasonable tire width e.g. 150mm — off-
shelf placeholder per project convention, no tread detail) centered at
each end of that beam. No swivel, no kinetic parameter — this axle is
static.

### TASK 2 — Front axle: support box + single swivel + triangle bracket

```
// support box — under the G-H face (flat bottom edge of the octagon)
SUPPORT_BOX_WIDTH = chamber_W - 2*chamfer   // 310mm, matches G-H width
SUPPORT_BOX_DEPTH = 300                      // longitudinal, X: 0 to -300
SUPPORT_BOX_Y0 = DATUM_Y_CENTER - SUPPORT_BOX_WIDTH/2   // 150
SUPPORT_BOX_Y1 = DATUM_Y_CENTER + SUPPORT_BOX_WIDTH/2   // 460
CHAMBER_UNDERSIDE_Z = chamber_floor_z - wall_t   // 597

SUPPORT_BOX_H = 120
SUPPORT_BOX_Z0 = CHAMBER_UNDERSIDE_Z - SUPPORT_BOX_H   // 477
// support box: X 0 to -300, Y 150-460, Z 477-597

SWIVEL_X = -150   // support box CENTER (confirmed — not the outer
                   // edge; corrected mid-session)
SWIVEL_Y = DATUM_Y_CENTER   // 305
SWIVEL_COLLAR_H = 20
SWIVEL_Z0 = SUPPORT_BOX_Z0 - SWIVEL_COLLAR_H   // 457
// swivel pivot: free Z-axis rotation collar, X=-150, Y=305, Z 457-477

FRONT_WHEEL_X = SWIVEL_X   // -150 — wheel sits directly below the
                            // swivel, does not move fore/aft on steer
FRONT_WHEEL_Z = WHEEL_R     // 305, same wheel spec as rear

// triangle bracket — TOP-VIEW triangle only (apex at swivel, widens
// to a flat base at the hinge). In SIDE view this is just plate
// thickness, not a tall vertical structure — confirmed explicitly by
// Janis after an earlier misread. Do not build this as a tall
// vertical member.
HINGE_X = -400   // apex-to-base "height" of the top-view triangle =
                  // 400-150 = 250mm forward of the swivel. Purpose:
                  // move the tiltable handle's hinge far enough
                  // forward to clear the exhaust room during its
                  // fold-up swing to vertical storage — NOT a wheel
                  // clearance requirement, the wheel stays at X=-150.
TRIANGLE_BASE_Z = FRONT_WHEEL_Z   // 305 — base of the triangle carries
                                   // the transverse axle beam, matches
                                   // wheel height
```

CLEARANCE CHECK (state numerically in cc_chat_log, confirm against the
LIVE chambers file's real exhaust room dimensions — do not assume the
360mm/180mm-reach figures below are still current, re-read them):
exhaust room's forward reach (ROOM_D/2, per that file) must leave real
margin against HINGE_X=-400. At the time this prompt was written:
ROOM_D=360 → reach=180mm → margin = 400-180 = 220mm. Re-verify this is
still true against the actual live file before building.

Triangle bracket construction: a flat plate (wall_t-appropriate
thickness, e.g. similar to the chamber's own wall_t or a sturdier
structural gauge — your call, flag your choice), apex at (SWIVEL_X,
SWIVEL_Y, TRIANGLE_BASE_Z), widening in the -X direction to a flat base
at HINGE_X spanning the SAME track width as the rear axle
(REAR_TRACK_WIDTH, Y: -123.5 to 733.5 — this is Janis's explicit
"front span must follow rear for parallelity" requirement). A
transverse axle beam runs along that base (at HINGE_X, spanning the
full track width), with a wheel (WHEEL_D, same spec as rear) at each
end.

Mechanism (single central swivel — not two independent front wheels):
the swivel pivot (SWIVEL_X, SWIVEL_Y, Z 457-477) is the ONE steering
axis. The triangle bracket + axle beam + both front wheels rotate
TOGETHER about this single vertical (Z) axis when steered — one rigid
assembly, not independent wheels. Support box (fixed to the chamber) is
the parent; swivel collar is the child, free to rotate about Z; triangle
+ axle beam + wheels are rigid children of the swivel, all moving
together.

### TASK 3 — Tow handle (separate part, hinged at the triangle's tip)

The handle is a separate tall member from the triangle bracket, not
part of it — confirmed against Janis's own reference sketch (two
circles on a vertical post, distinct from the flat triangle plate).

```
HANDLE_HINGE_X = HINGE_X   // -400, at the triangle's forward tip/base
HANDLE_HINGE_Y = DATUM_Y_CENTER   // 305, centered
HANDLE_HINGE_Z = TRIANGLE_BASE_Z  // 305, same height as the axle beam
```

Kinetic: `handle_tilt_deg` parameter. 0 = towing/use position (handle
angled down/outward from the hinge — your reasonable choice of resting
angle, flag it). Full tilt = vertical storage position, rotating about
a Y-axis line through HANDLE_HINGE point (tilts fore/aft, i.e. up/down
— NOT the same axis as the swivel's Z-rotation).

Confirm via real CGAL that the handle at full-vertical tilt clears the
exhaust room with the margin stated in Task 2's clearance check — this
is the actual purpose of HINGE_X's forward offset, verify it's real,
not just arithmetic.

Steering behavior (state explicitly, this is the mechanism Janis
specified): rotating the handle about the SWIVEL's Z-axis (not the
tilt hinge) turns the whole front assembly — handle, triangle, axle
beam, and both front wheels move together, at ANY tilt angle (down for
towing, up for storage — steering works the same either way, since the
swivel and the tilt hinge are independent, perpendicular axes).

## 5. DO NOT TOUCH

- Any `bbq-offset-smoker/BBQ-chambers-v*.scad` file — read only, do not
  modify chamber/firebox/lid/exhaust geometry
- `prep_shelves()` geometry — unchanged, BUT flag via real intersection
  probe whether the new support box (X:0 to -300) spatially conflicts
  with it ("front of chamber" per its own original spec) — report the
  finding, do not silently assume no overlap
- `firebox_drop = 200` — still not resolved, read-only reference value
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Rear axle: REAR_AXLE_X, REAR_TRACK_WIDTH, REAR_BRACKET_H stated
      and confirmed matching the formulas above (or the real live
      firebox values if they differ from what's assumed here)
- [ ] Front swivel: confirmed single pivot, both front wheels + triangle
      + axle beam rotate together as one rigid assembly
- [ ] Front and rear track width confirmed EQUAL (parallelity)
- [ ] Triangle bracket confirmed as a flat top-view shape (plate
      thickness only in side view) — not built as a tall vertical member
- [ ] Handle-to-exhaust-room clearance confirmed via real CGAL at full
      vertical tilt, actual margin number stated (not assumed from this
      prompt's numbers alone — re-derived from the live chambers file)
- [ ] `prep_shelves()` vs new support box: real intersection probe
      result stated either way
- [ ] Kinetic sweep: `handle_tilt_deg` at rest/mid/full-vertical, swivel
      rotation at a few angles combined with tilt states — all Simple:yes
- [ ] 4-angle screenshots (iso/front/side/rear) + 1 with handle at full
      vertical storage tilt, + 1 with swivel turned to a non-zero angle
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: state
   real rear/front axle coordinates, confirmed track-width match,
   handle clearance margin (actual number), prep_shelves conflict
   finding, QA results
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-14
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md —
   remove the old generic legs()/casters()/tow_handle() entries, add
   the new rear_axle()/front_axle()/tow_handle() (or your chosen names)
   entries with real Toggle-Completeness coverage
4. Save as BBQ-understructure-v2.scad (v1 kept per convention); update
   BBQ-offset-smoker-base-v1.scad's include if it references the
   understructure filename directly
5. Commit all → merge to main
