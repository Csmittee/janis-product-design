CC PROMPT — bbq-understructure-v2-axles-swivel-handle
================================================================
Repo location: bbq-offset-smoker/BBQ-understructure.scad (edit in
place, save as v2)

REVISION NOTE: this replaces the version of this prompt previously
sitting in /prompts/ — Task 2 (front wheel support) is fully rewritten
below, based on real sketches Janis provided directly. Task 1 and
Task 3 are UNCHANGED from the original — do not reinterpret them.

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. bbq-offset-smoker/rules-bbq-fab.md (includes the Standing Orientation
   Convention — exhaust=left, firebox=right, door toward user, when
   facing the smoker)
5. bbq-offset-smoker/SKELETON_WORKSHEET.md
6. bbq-offset-smoker/BBQ-chambers-v10.scad — LIVE file, in full (NOT v3
   — confirm this against the real current filename/version from the
   repo regardless). This file's own DATUM_*/chamber_* constants
   (including the corrected `chamfer=chamber_W/(2+sqrt(2))`, NOT the old
   150mm value) are the parent for everything below.
7. bbq-offset-smoker/BBQ-understructure.scad (the LIVE file, in full —
   currently placeholder-level legs()/casters()/tow_handle(), being
   substantially replaced by this prompt)
8. .claude/SKILL_joint_construction.md
9. .claude/rules-codes.md

## 2. CONTEXT

The existing legs()/casters()/tow_handle() were explicit placeholders
from the original v1-init prompt. This prompt replaces them with a
fully-specified real mechanism.

Two genuinely different, UNRELATED mechanisms — do not let them
influence each other's geometry:
- REAR: fixed, non-swivel axle under the firebox (Task 1)
- FRONT WHEEL SUPPORT: a single bent-sheet bracket carrying a swivel
  caster under the chamber (Task 2, REWRITTEN this round)
- PULLER/HANDLE MOUNT: a separate triangle bracket + hinged handle
  (Task 3) — has NOTHING to do with the front wheel/caster. Do not
  merge, cross-reference, or reconcile its geometry against Task 2's.

## 3. NEW FILES

None. Editing bbq-offset-smoker/BBQ-understructure.scad in place.

## 4. TASKS

### TASK 1 — Rear axle (fixed, non-swivel, under firebox) — UNCHANGED

```
WHEEL_D = 609.6        // 24" wheel including tire
WHEEL_R = 304.8         // 305mm, rounded
FIREBOX_CLEARANCE = 200 // Janis's spec, each side, avoid heat

// firebox footprint — READ THE LIVE FILE, do not hardcode from this
// prompt. At time of writing: firebox_x0 = DATUM_X_REAR (915),
// firebox_size = 457, firebox spans Y: DATUM_Y_CENTER - firebox_size/2
// to +firebox_size/2 = 76.5 to 533.5. Re-derive from the live file.

REAR_AXLE_X = firebox_x0 + firebox_size/2   // centered on firebox midpoint
REAR_WHEEL_Y_LEFT  = firebox_y0 - FIREBOX_CLEARANCE
REAR_WHEEL_Y_RIGHT = firebox_y1 + FIREBOX_CLEARANCE
REAR_TRACK_WIDTH = REAR_WHEEL_Y_RIGHT - REAR_WHEEL_Y_LEFT  // ~857mm

REAR_AXLE_Z = WHEEL_R   // ground contact, wheel radius
REAR_BRACKET_H = firebox_floor_z - REAR_AXLE_Z
```

Build: a simple fixed drop-bracket (real height per the formula above,
wall_t-ish plate/tube construction, your choice of reasonable structural
cross-section) from the firebox underside (firebox_floor_z, at
REAR_AXLE_X) down to REAR_AXLE_Z, with a transverse axle beam at the
bottom spanning REAR_TRACK_WIDTH, wheel placeholder (simple cylinder,
WHEEL_D diameter, reasonable tire width e.g. 150mm — off-shelf
placeholder, no tread detail) centered at each end of that beam. No
swivel, no kinetic parameter — this axle is static.

### TASK 2 — Front wheel support bracket + caster (REWRITTEN)

A single bent-sheet bracket, press-brake formed from ONE flat trapezoidal
blank, 6mm thick. Confirmed via real local render against a sketch
Janis provided directly — build EXACTLY this geometry, do not
reinterpret or re-derive a different shape.

**Shape, in the chamber's own hex_pt(h,w) convention (h relative to
chamber_floor_z, w = world Y) — read the live chambers file's own
`chamfer`, `chamber_W`, `DATUM_Y_CENTER` values, do not hardcode
decimals from this prompt:**

```
MID_H    = chamfer / 2                        // 89.3325 at current values
                                                 // -- 50% up the chamfer,
                                                 // this is where the
                                                 // bracket's top edge
                                                 // welds to the chamber
TOP_W    = (chamber_W - 2*chamfer) + 2*MID_H    // 431.335 -- the REAL
                                                 // octagon width at
                                                 // h=MID_H. This MUST be
                                                 // computed from the same
                                                 // octagon math the
                                                 // chamber itself uses
                                                 // (chamber_W-2*chamfer+2h),
                                                 // not approximated —
                                                 // the top edge has to be
                                                 // flush/continuous with
                                                 // the real chamfer
                                                 // surface, no seam.
BOT_W    = chamber_W - 2*chamfer                // 252.665 -- same as the
                                                 // chamber's own actual
                                                 // floor width
LEG_GAP  = 250                                  // X spacing between the
                                                 // front and rear leg
LEG_DROP = 150                                  // chamber_floor_z (h=0)
                                                 // down to the bracket's
                                                 // bottom, where the
                                                 // caster mounts
t        = 6                                    // plate thickness
```

**Construction — ONE bent blank, not separate welded plates:**
- Two trapezoidal side plates (front leg, rear leg), each spanning from
  h=MID_H (top, width=TOP_W, centered on DATUM_Y_CENTER) down to
  h=-LEG_DROP (bottom, width=BOT_W, centered on DATUM_Y_CENTER) — a
  straight-sided trapezoid, real edges only, same hex_pt(h,w) convention
  the chamber file itself uses (h negative = below chamber_floor_z).
  Position the two legs at X = FRONT_X and X = FRONT_X - LEG_GAP (pick a
  reasonable FRONT_X placing the bracket under the chamber's front
  overhang area — flag your choice, state reasoning).
- A flat bottom plate, thickness t, spanning the full LEG_GAP between
  the two legs at Z = chamber_floor_z - LEG_DROP, width BOT_W (matching
  the legs' own bottom width) — this is where the caster mounts.
- The TOP edge of each leg (at h=MID_H, width=TOP_W) must be flush
  against the chamber's real chamfer surface at that height — verify
  via a real CGAL check that there's no gap/interference (the leg's top
  edge should lie exactly ON the chamber's own true_octagon_profile()
  boundary at h=MID_H, not floating off it).
- Caster: a real off-the-shelf swivel caster placeholder (cylinder +
  simple mounting plate representation is fine, no internal bearing
  detail), mounted centered on the bottom plate. State the mounting
  interface you assumed (bolt pattern / plate size) — if you don't have
  a real spec, use a reasonable generic heavy-duty swivel caster
  footprint and flag it as a placeholder needing Janis's real hardware
  spec to finalize.
- Wheel(s) on the caster: reuse the same WHEEL_D/WHEEL_R spec as Task 1
  unless the caster's own footprint requires a different size — flag
  either way.

No kinetic parameter for this bracket itself — it's a fixed weldment.
The caster's own swivel/steer motion is inherent to the off-the-shelf
part, not something this bracket needs to model kinematically.

### TASK 3 — Tow handle + puller triangle bracket — UNCHANGED

Do not modify, reinterpret, or cross-check this against Task 2's
geometry. Build exactly as specified:

The handle is a separate tall member, hinged at the tip of a flat
top-view triangle bracket (plate thickness only in side view — not a
tall vertical member). This triangle and its hinge point are entirely
independent of the front wheel/caster built in Task 2 above — they do
not share a mounting point, an axle, or any coordinate reference.

```
// triangle bracket — TOP-VIEW triangle only. Apex forward, base at the
// hinge. Position and dimensions per Janis's own spec from the prior
// session — read cc_chat_log.md / prior session record for the exact
// HINGE_X / track-width / clearance numbers if not otherwise given
// here, and re-verify the exhaust-room clearance check against the
// LIVE chambers file (ROOM_D etc. may have changed — v10 recentered
// the exhaust room's Z position, but re-confirm ROOM_D's own forward
// reach is unchanged before trusting old clearance numbers).
```

Handle: `handle_tilt_deg` kinetic parameter, 0 = towing/use position,
full tilt = vertical storage. Steering (rotation about the triangle's
own mount axis) turns the handle assembly independent of tilt angle.

Confirm via real CGAL that the handle at full-vertical tilt clears the
exhaust room — re-derive the real margin from the LIVE chambers file,
don't assume old numbers still hold.

## 5. DO NOT TOUCH

- Any `bbq-offset-smoker/BBQ-chambers-v*.scad` file — read only, do not
  modify chamber/firebox/lid/exhaust geometry
- `prep_shelves()` geometry — unchanged, BUT flag via real intersection
  probe whether Task 2's new bracket (at FRONT_X and below) spatially
  conflicts with it — report the finding, do not silently assume no
  overlap
- `firebox_drop = 200` — still not resolved, read-only reference value
- Task 3's own mechanism — build it, but do not redesign, reinterpret,
  or tie it to Task 2's bracket in any way
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Rear axle: REAR_AXLE_X, REAR_TRACK_WIDTH, REAR_BRACKET_H stated,
      derived from the LIVE firebox values (not this prompt's numbers)
- [ ] Front bracket: MID_H, TOP_W, BOT_W all stated as computed from the
      live file's real chamfer/chamber_W — not hardcoded decimals
- [ ] Front bracket: real CGAL check confirms the leg's top edge (at
      h=MID_H) lies flush on the chamber's true_octagon_profile()
      boundary — no gap, no interference
- [ ] Front bracket: confirmed as ONE bent-blank construction (trapezoid
      taper from MID_H to bottom), not a separate offset/collar design
- [ ] Caster mounting interface stated explicitly (real spec or flagged
      placeholder)
- [ ] Front and rear track width comparison stated (need not match —
      state both, flag if Janis should confirm parallelity separately)
- [ ] Task 3: triangle + handle built exactly per its own spec, zero
      cross-reference to Task 2's bracket geometry
- [ ] Task 3: handle-to-exhaust-room clearance re-verified against the
      LIVE chambers file, real margin number stated
- [ ] `prep_shelves()` vs Task 2's bracket: real intersection probe
      result stated either way
- [ ] Kinetic sweep: `handle_tilt_deg` at rest/mid/full-vertical —
      Simple:yes throughout
- [ ] 4-angle screenshots (iso/front/side/rear) + 1 with handle at full
      vertical storage tilt
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: state
   real rear axle coordinates, real front bracket MID_H/TOP_W/BOT_W
   values, flush-fit CGAL check result, caster spec assumption,
   prep_shelves conflict finding, handle clearance margin, QA results
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-17
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md —
   remove the old generic legs()/casters()/tow_handle() entries, add
   the new rear_axle()/front_bracket()/caster()/tow_handle() (or your
   chosen names) entries with real Toggle-Completeness coverage
4. Save as BBQ-understructure-v2.scad (v1 kept per convention); update
   BBQ-offset-smoker-base-v1.scad's include if it references the
   understructure filename directly
5. Commit all → merge to main
