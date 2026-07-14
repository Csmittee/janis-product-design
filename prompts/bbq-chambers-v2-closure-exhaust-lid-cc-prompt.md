CC PROMPT — bbq-offset-smoker-chambers-v2-closure-exhaust-lid
================================================================
Repo location: bbq-offset-smoker/BBQ-chambers-v1.scad (edit in place,
save as v2 per Task 4/closing)

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. bbq-offset-smoker/rules-bbq-fab.md
5. bbq-offset-smoker/SKELETON_WORKSHEET.md
6. bbq-offset-smoker/BBQ-chambers-v1.scad (the LIVE file, in full — this
   prompt modifies it, do not assume its current contents, read them)
7. .claude/SKILL_joint_construction.md
8. .claude/rules-codes.md

## 2. CONTEXT

Janis reviewed the merged v1-init build against reference photos and
specified 3 corrections directly (not Claude Web's design choices —
Janis's own words, converted to geometry below). Unlike prior BBQ
prompts, Claude Web did NOT locally verify this geometry in a sandbox
before writing this prompt (Janis's explicit instruction this session,
a deliberate time/token tradeoff) — this does NOT waive cc's own
mandatory QA (full CGAL manifold sweep, real screenshots). Treat every
coordinate below as a specification to build and verify, not as
pre-confirmed correct — if something doesn't fit or produces a manifold
warning, flag it in cc_chat_log rather than silently forcing a fit.

Three corrections, in priority order:
1. Full closure — every chamber wall solid except two named openings.
2. Exhaust outlet rebuilt as a real 3D half-cylinder room, not a thin
   disc (Claude Web's earlier disc concept was explicitly rejected).
3. Lid mechanism completely redesigned — length-wise ridge hinge
   instead of the old end-hinged trunk lid.

## 3. NEW FILES

None. Editing bbq-offset-smoker/BBQ-chambers-v1.scad in place.

## 4. TASKS

### TASK 1 — True octagon profile + full closure (chamber_shell)

The live file's profile is a 6-point shape (chamfered top corners only,
sharp bottom corners) — replace with a true 8-point octagon, chamfered
top AND bottom, using the file's existing `hp(h,w)` convention:

```
hp(0, chamfer)                    // 1: floor, left end of flat bottom
hp(0, chamber_W - chamfer)        // 2: floor, right end of flat bottom
hp(chamfer, chamber_W)            // 3: bottom-right chamfer top
hp(chamber_H - chamfer, chamber_W)// 4: right wall top
hp(chamber_H, chamber_W - chamfer)// 5: ridge, right end
hp(chamber_H, chamfer)            // 6: ridge, left end
hp(chamber_H - chamfer, 0)        // 7: left wall top
hp(chamfer, 0)                    // 8: left wall bottom
```
(trough_h = chamber_H - 2*chamfer = 310, both walls this height)

CLOSURE FIX — root cause: the live file's inner-cavity cut overshoots
PAST both ends of the extrusion (by `e` on each side), leaving only a
paper-thin wall_t rim at X=0 and X=chamber_L instead of a real solid
cap. Fix: inset the cavity cut so it starts at X=wall_t and ends at
X=chamber_L-wall_t (NOT X=-e to X=chamber_L+e) — this leaves real
wall_t-thick solid material at both ends naturally, matching real
welded end-plate practice.

After this fix, chamber_shell() must have NO openings anywhere except:
- Rear end-cap (X=chamber_L): the EXISTING rear_window_hole() cut,
  unchanged size/position (254x119mm, at chamber_floor_z) — this is
  the firebox passage, the only connection between the two compartments.
- Front end-cap (X=0): ONLY the exhaust-room connection opening from
  TASK 2 below.
State explicitly in cc_chat_log: "both end-caps confirmed solid except
[these two named openings]" — not just "looks closed."

### TASK 2 — Exhaust outlet: half-cylinder room + chimney pipe

Replace the entire `chimney()` + `drop_tube()` construction with a real
3D mounting room, per Janis's own description: take a cylinder,
diameter 200mm, height 200mm, axis VERTICAL — cut it in half through a
vertical plane containing its axis (produces a semicircular-footprint
volume, flat cut face on one side, curved dome on the other). That flat
face welds flush against the chamber's front end-cap (X=0), centered on
it. The chimney pipe sits on TOP of this room, not directly on the wall.

Exact placement (Claude Web's choice, flagged, not yet Janis-confirmed —
centers the room within the uninterrupted vertical-wall zone so it
doesn't run into the chamfer):
```
ROOM_D = 200            // diameter
ROOM_H = 200             // height
ROOM_BASE_Z = chamber_floor_z + (trough_h - ROOM_H)/2   // 655
ROOM_TOP_Z  = ROOM_BASE_Z + ROOM_H                        // 855
```
(vertical wall zone is chamber_floor_z..chamber_floor_z+trough_h, i.e.
600-910 — this centers the 200mm room within it: 55mm clear margin
top and bottom, well clear of the chamfer)

Construction (hollow shell, wall_t skin, matches real welded-room fab —
NOT a solid block):
- Flat BACK face (against the wall, X=0 plane): fully OPEN — same
  semicircular footprint as the room itself, no redundant double-wall,
  same precedent already used for firebox_shell()'s own near-face
  (see that module's header comment in the live file for the reasoning).
- Curved side wall + flat bottom: solid, wall_t skin.
- Flat TOP (at ROOM_TOP_Z): solid EXCEPT one round hole, diameter =
  chimney_d (127mm, unchanged locked value), centered on the room's
  semicircle, for the pipe to mount over.
- Chamber's own front end-cap opening (TASK 1): must match this room's
  full semicircular footprint (200mm dia semicircle), not a small
  pipe-sized hole — the room's open back IS the wall's opening.

Chimney pipe: diameter = chimney_d (127mm), base at ROOM_TOP_Z, rising
straight up. Per SKILL_joint_construction.md's own scope note, this is
simple coaxial round stacking (pipe sits on a round hole, same
diameter, single shared vertical axis) — no elbow, no loft needed.

CRITICAL — a real defect Claude Web caught and fixed in local testing,
do not repeat it: the pipe's own base must fully cover its mounting
hole. If the pipe is centered ON the hole's center height instead of
based AT the hole's edge, only half the hole gets covered, leaving a
real unsealed gap. Confirm in cc_chat_log that the pipe's solid body
fully overlaps the hole with zero gap — state the actual Z range of
both (hole and pipe base) and confirm full containment, not just
"aligned."

State final world coordinates for the room and pipe in cc_chat_log per
SKILL_joint_construction.md Rule 3 (parent axis / child axis / actual
numbers, not just "correct").

### TASK 3 — Lid: full redesign, length-wise ridge hinge

Replace the entire lid()/lid_closed_panels()/LID_MARGIN_FRONT/
LID_MARGIN_REAR/lid_opening_cut() construction. The old lid hinged along
Y at a fixed X (trunk-lid style, opening along the chamber's length).
The new lid hinges along X at a fixed (Y,Z) — a hinge line running the
FULL chamber length, at the ridge's own midpoint — and swings open
sideways, covering 2.5 of the octagon's 8 sides.

**Hinge line (world coordinates):** Y = DATUM_Y_CENTER (305), Z =
chamber_floor_z + chamber_H (1210, the ridge), running the full X range
of the lid. Rotation is about this line's own axis (the X-direction) —
NOT the old rotate([0,deg,0]) about a Y-axis line; this is
rotate([deg,0,0]) about an X-axis line, so translate the hinge line to
pass through the world origin's Y,Z before rotating, then translate back.

**Fixed-shell profile — replaces the 8-point TASK 1 profile with a
7-point profile** (the lid's own 2.5-side chunk is cut away and given to
the lid; opens toward +Y — Claude Web's choice, flag as a 1-line mirror
swap if Janis wants -Y instead):
```
hp(0, chamfer)                     // 1: floor, left end of flat bottom
hp(0, chamber_W - chamfer)         // 2: floor, right end of flat bottom
hp(chamfer, chamber_W)             // 3: PARTING START — lowest apex,
                                    //    right wall's bottom corner
hp(chamber_H, chamber_W/2)         // 4: PARTING END — ridge midpoint
                                    //    (straight cut edge, point 3 to 4)
hp(chamber_H, chamfer)             // 5: ridge, left end (same as before)
hp(chamber_H - chamfer, 0)         // 6: left wall top
hp(chamfer, 0)                     // 7: left wall bottom
```
Point 3 (chamfer, chamber_W) is the PARTING LINE location Janis
specified: "lowest apex," i.e. the existing bottom-right-chamfer/
right-wall-bottom corner — NOT the old trough_h seam (that was the
wall/upper-chamfer junction, correctly rejected as "the middle").

**Lid's own profile** (the 2.5-side chunk removed above — this is what
swings open):
```
hp(chamber_H, chamber_W/2)         // 1: ridge midpoint (hinge line)
hp(chamber_H, chamber_W - chamfer) // 2: ridge, right end (half-ridge)
hp(chamber_H - chamfer, chamber_W) // 3: top-right chamfer bottom
hp(chamfer, chamber_W)             // 4: right wall bottom (parting end,
                                    //    matches fixed-shell point 3)
```
Closes back to point 1 (straight edge, mirrors the fixed shell's cut).
Build the same way the main chamber_shell() is built: extrude this
4-point profile along X for the lid's length, shell by wall_t (offset
cavity inset from both X ends, same closure-fix pattern as TASK 1 — do
not repeat the overshoot bug here either), open at both X ends is
correct for the lid itself (it's a cap-less trough, not a sealed box).

**Lid length (Janis: "full width -10mm each side"):**
```
LID_X0 = 10
LID_X1 = chamber_L - 10   // 905
LID_LENGTH = LID_X1 - LID_X0   // 895
```
Replaces the old asymmetric LID_MARGIN_FRONT(300)/LID_MARGIN_REAR(60).

**Kinetic:** `lid_open_deg` parameter, 0=closed. State a reasonable
open-angle max (e.g. ~110-120deg — verify via real CGAL that the lid
clears the fixed shell at your chosen max, same discipline as the old
firebox door's verified 110deg) and report the confirmed max in
cc_chat_log.

**lid_hardware() — DO NOT respecify positions this pass.** Every
existing position (handle posts, latches, lever, thermometer) was built
for the OLD lid geometry and is now wrong. Comment out the
`lid_hardware()` call in the ASSEMBLY block (or wrap in `show_lid_hardware
= false`), and add a `// TODO` note that hardware repositioning is a
follow-up prompt once this new lid shape is confirmed — do not leave
hardware silently floating in stale positions disconnected from the new
lid.

## 5. DO NOT TOUCH

- `firebox_shell()`, `fire_grate()`, `ash_tray()`, `firebox_door()` —
  already correct and CGAL-verified, zero changes
- `rear_window_hole()` size/position — unchanged (254x119mm)
- `firebox_drop = 200` — still an open flag, not resolved by this prompt
- `grill_grate()`, `floor_drains()` — unchanged
- Understructure — separate file, not in scope
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Both chamber end-caps confirmed solid except the two named
      openings — state explicitly, not just "looks closed"
- [ ] True 8-point octagon confirmed (both top AND bottom chamfered)
- [ ] Exhaust room: semicircular footprint confirmed, open back matches
      wall opening exactly, solid elsewhere except the one round pipe
      hole on top — actual world coordinates stated (Rule 3)
- [ ] Chimney pipe fully covers its mounting hole — zero-gap confirmed
      with actual Z-range numbers, not just "aligned" (see Task 2's
      named defect — do not repeat it)
- [ ] New lid: hinge line world coordinates stated explicitly; 2.5-side
      coverage confirmed against the 8-point profile; parting line
      confirmed at point 3 (lowest apex), not the old trough_h seam
- [ ] Lid length confirmed = 895mm, X:10-905
- [ ] `lid_hardware()` confirmed disabled/flagged, not left mis-positioned
- [ ] 4-angle screenshots: iso, front, side, rear — PLUS one additional
      angle with `lid_open_deg` at your confirmed max, so the hinge and
      parting geometry are actually visible open, not just closed
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines: confirm
   closure, state exhaust-room/pipe/hinge-line actual coordinates (Rule
   3), confirm lid coverage math, confirm lid_hardware disabled, state
   QA results (manifold/screenshots/gap-check)
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-14
3. Update knowledge.map if needed
4. Version bump: BBQ-chambers-v1.scad → save as BBQ-chambers-v2.scad
   (or bump in place per this project's file-versioning convention —
   confirm which the live repo already uses before choosing)
5. Commit all → merge to main
