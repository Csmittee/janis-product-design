CC PROMPT — bbq-chambers-v13-reanchor-grate-decouple-rear-passage
================================================================
Repo location: bbq-offset-smoker/BBQ-chambers-v13.scad (new, source
v12)

REVISION NOTE: chamber-only this round. Firebox (v12,
460x510x428.6mm, world Z=[571.4,1000]) and understructure (v4, 18"
wheel, world-Z=0 anchor) are BOTH already correct/frozen — do not
touch either file's own dimensions or Z-anchor logic. This prompt
restarts the chamber-height discussion from scratch after last
round's real, honestly-flagged finding: apex A's real value is
778.665mm, NOT the 900mm a prior prompt incorrectly assumed (that
900mm figure traced back to a v3 GROUND_OFFSET constant that was
computed on paper but never actually wired into built geometry — see
BBQ-understructure-v4.scad's own header for the full investigation).
This prompt fixes the REAL geometry directly, no more paper offsets.

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
1. bbq-offset-smoker/BBQ-chambers-v12.scad — LIVE, in full. State real
   current values: `chamber_floor_z`(600), `GRATE_Z`(778.665, formula
   `chamber_floor_z+chamfer`), `chamfer`(178.665), `true_octagon_profile()`'s
   full real boundary (not just apex A — need the actual profile curve
   used for TASK 3's intersection), `DATUM_X_REAR`(915, the chamber's
   rear end wall X-position), the rear end wall's own real construction
   (how it's currently built — solid cap, open, or something else —
   state explicitly, this determines how TASK 3's cut is implemented),
   `lid_open_deg`/door mechanics near the rear, `grill_grate()`'s
   current full construction (position formula, dimensions — this is
   being decoupled, need the real current values to preserve size/X-Y
   placement while changing only its Z anchor).
2. bbq-offset-smoker/BBQ-chambers-v12.scad's own firebox section —
   state real `FIREBOX_L/W/H`(460/510/428.6), `firebox_floor_z`(571.4,
   top=1000), `fuel_cylinder()`'s real diameter(388.6)/wall(3mm)/
   position — this round's rear-wall cut and new end-cap plate must be
   derived from these REAL, ALREADY-BUILT values, not re-guessed.
3. .claude/SKILL_joint_construction.md
4. .claude/rules-codes.md
5. bbq-offset-smoker/design_scope_of_work_rule.md — Envelope section
   (grate-height figure being changed again this round, see Mandatory
   Closing)

**Historical precedent to read carefully before TASK 3 — this project
has made this exact class of mistake TWICE already**: BBQ-chambers-v6
(`GRATE_Y0`/`GRATE_Y1` fix) and v8/v10 (`ROOM_BASE_Z`/`ROOM_TOP_Z`
recentering) both originally assumed a simple constant-width or
naively-centered cut, when the octagon's real profile — narrower near
the floor via the chamfer — made that assumption wrong, caught only
after a real CGAL collision check. TASK 3 in this prompt is the same
risk, at higher stakes (a compound two-shape boolean, not a single
rectangle). Read those two file headers before writing TASK 3's
geometry, and use a REAL `intersection()` against the live
`true_octagon_profile()`, not an assumed/hand-derived boundary shape.

## 2. CONTEXT

Three independent entities this round, deliberately NOT rigidly
locked together the way they were pre-v12 — Janis's explicit call,
flagged as TEMPORARY (see TASK 2):

1. **Chamber body** (shell, lid, door, chimney, exhaust room — every-
   thing currently keyed off `chamber_floor_z`) — reanchors as one
   rigid group so apex A lands at exactly 900mm (TASK 1).
2. **Grate** — becomes independently positioned at a fixed 1000mm,
   decoupled from the chamber body's own Z formula (TASK 2). Floats
   ~100mm above apex A with a real, currently-unsupported air gap —
   expected, matches the chamber's new position, NOT a defect. The
   structure that will physically support the grate at this height
   (a reinforcement frame at chamber face A-B, plus a correspondingly
   shortened door) is an explicitly DEFERRED future task, not built
   this round.
3. **Firebox** (v12, already correct, world Z=[571.4,1000]) — frozen,
   untouched this round.

**TASK 3's mechanism, stated precisely — read twice before
implementing:**
- The chamber's rear end wall gets a hole = the REAL
  `intersection()` of the fuel cylinder's circular cross-section with
  wherever the chamber's own wall material actually exists (bounded by
  `true_octagon_profile()`'s real boundary AND by `chamber_floor_z` —
  the octagon shell has no material at all below the chamber floor).
  This is NOT a full circle — where the octagon's chamfer narrows
  faster than the circle, or below `chamber_floor_z` where the octagon
  doesn't exist, the cut follows the OCTAGON's edge instead of the
  circle's. Real-world result when viewed through the open door: round
  at the top, following the octagon's own boundary lower down.
- A SEPARATE new plate — the firebox's own end-cap (backing wall,
  chamber-facing side of the firebox, distinct from the chamber's rear
  wall above) — has two zones in one continuous shape: ABOVE
  `chamber_floor_z`(the new, reanchored value from TASK 1), it follows
  the real `true_octagon_profile()` boundary (filling the gap between
  the firebox cube's rectangular footprint and the octagon's actual
  narrower edge, open only where it must match the real hole already
  cut in the chamber's rear wall); BELOW `chamber_floor_z`, no octagon
  reference exists, so it's a plain rectangle matching the firebox
  cube's own width/height, fully solid, sealing the cylinder's lower
  portion completely (no passage below the chamber floor line).
- The cylinder is seal-welded (real, touching/overlapping material,
  CGAL-confirmed, not a floating near-touch) around the rear-wall
  hole's own perimeter where it passes through.
- The firebox cube (outer housing) mounts flush against this same
  end-cap plate, welded/attached, but performs NO cut of its own on
  any chamber surface — purely a shroud around the cylinder, real air
  gap between cylinder and cube walls (already built in v12, unchanged
  this round).
- Firebox is fully sealed on every face except its own access door —
  this new end-cap plate is part of that seal, not an exception to it.

## 3. NEW FILES

None. New `BBQ-chambers-v13.scad` (source v12).

## 4. TASKS — IN THIS ORDER, TASK 3 DEPENDS ON TASK 1's OUTPUT

### TASK 1 — Chamber body reanchor (apex A → 900mm)

Change `chamber_floor_z` from 600mm to a new real value such that
`GRATE_Z`'s own formula (`chamber_floor_z + chamfer`) — still the
octagon's own apex-A reference, unchanged formula — lands at exactly
900mm. State the real computed `chamber_floor_z` (expect ~721.335mm,
but derive and state it live from the real `chamfer` value, don't
copy this number blindly). Every other chamber-body element currently
keyed off `chamber_floor_z` (shell, lid, door, chimney, exhaust
room, `DATUM_Z_RIDGE`, etc.) moves with it automatically via the
existing dependency chain — confirm this explicitly, state which
elements recomputed and their real new Z values.

Real verification: confirm apex A's real world Z is now exactly
900mm (not approximately), and confirm no new collision was
introduced against the firebox (world Z=[571.4,1000], frozen) or the
understructure (frozen) at the new chamber position.

### TASK 2 — Grate decoupling (temporary, fixed 1000mm)

Break `grill_grate()`'s Z-position away from `DATUM_GRATE_Z`
(`chamber_floor_z + chamfer`) entirely. New, independent constant,
e.g. `GRATE_Z_FIXED = 1000` (name your own convention, state it),
consumed only by `grill_grate()`'s own Z placement. X/Y placement
(`GRATE_MARGIN`, segment layout, `GRATE_Y0`/`GRATE_Y1`) — keep the
EXISTING real formulas/dimensions, only the Z anchor changes.

**MANDATORY comment block directly in the module/constant
definition** (not just the file header): state explicitly that this
decoupling is TEMPORARY — once the future reinforcement frame at
chamber face A-B and the correspondingly shortened door are built (a
later, separate session), the grate is intended to be RE-MERGED back
into the chamber body's own coordinate system (i.e. this fixed
constant should be revisited/removed at that time, not left as
permanent architecture). Flag this same note in cc_chat_log.md and
knowledge.map's own entry for this round.

Real verification: confirm the grate's real Z-gap above the
(now-reanchored) apex A is exactly 100mm, and run a real CGAL
interference check against the repositioned lid/chimney/exhaust room
at their TASK-1 real Z values — the grate floating higher relative to
the shell than before could newly collide with the lid's own swept
volume, check explicitly, don't assume clear.

### TASK 3 — Rear passage rework (do LAST, depends on TASK 1's real chamber_floor_z)

Implement exactly the two-shape mechanism in CONTEXT above:
1. Chamber's rear end wall: cut = real `intersection()` of the fuel
   cylinder's circular cross-section (388.6mm dia, from the ALREADY-
   BUILT v12 `fuel_cylinder()`, read its real position/diameter live,
   don't re-guess) against `true_octagon_profile()`'s real boundary at
   `DATUM_X_REAR`, further bounded below by the (TASK 1's real, new)
   `chamber_floor_z` — no material, hence no cut geometry, below that
   line. Use OpenSCAD's real `intersection()` primitive against the
   live profile — do NOT hand-derive an approximated boundary curve
   (see the historical-precedent warning above).
2. New firebox end-cap plate (separate solid from #1): upper zone
   (above the new `chamber_floor_z`) follows the real octagon
   boundary, open only where it must align with #1's real cut; lower
   zone (below `chamber_floor_z`) is a plain rectangle matching
   `FIREBOX_W`/`FIREBOX_H`, fully solid. One continuous plate, stated
   as such.
3. Real CGAL seal-weld check: cylinder-to-hole-perimeter contact
   confirmed non-floating; end-cap-plate-to-firebox-cube contact
   confirmed non-floating; end-cap-plate fully seals the firebox
   interior from the outside world except at the door opening — state
   this explicitly as a real check, not assumed from visual placement.
4. Real CGAL check: confirm the OLD, superseded rectangular
   firebox-footprint cut (if still present anywhere in inherited
   geometry) is fully removed — state a real diff confirming only the
   new round-topped/octagon-bottomed opening exists.

## 5. DO NOT TOUCH

- `BBQ-chambers-v12.scad`'s firebox section (`FIREBOX_L/W/H`,
  `firebox_floor_z`, `fuel_cylinder()`'s own diameter/wall/length) —
  read only, already correct, zero changes
- `BBQ-understructure-v4.scad` — entirely out of scope this round,
  read only if needed for a collision check, zero changes
- Wheel size, world-Z=0 anchor, `REAR_BRACKET_H` — untouched, already
  correct from last round
- `grill_grate()`'s X/Y placement formulas and dimensions — only its Z
  anchor changes (TASK 2)
- Front axle span, spacer brackets, T-bar/tow-handle geometry, front
  bracket height alignment — all still deferred from prior rounds,
  not this prompt
- The intentional future reinforcement-frame/shorter-door work itself
  — do not attempt to build it this round, only flag/preserve the
  100mm gap TASK 2 creates
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] Real new `chamber_floor_z` stated (expect ~721.335mm, confirm
      live-derived not copied)
- [ ] Real apex A world Z confirmed exactly 900mm
- [ ] Every chamber-body element dependent on `chamber_floor_z` listed
      with its real new Z value
- [ ] Real check: no new collision between reanchored chamber body and
      frozen firebox/understructure
- [ ] Grate Z-anchor fully decoupled from `chamber_floor_z` — new
      independent constant stated, named, and value confirmed exactly
      1000mm
- [ ] Grate X/Y placement confirmed UNCHANGED (real diff stated)
- [ ] Mandatory "TEMPORARY — future re-merge" comment present in the
      grate module/constant itself, not just the file header
- [ ] Real grate-to-apex-A gap confirmed exactly 100mm
- [ ] Real CGAL check: grate vs. repositioned lid/chimney/exhaust room
      at new Z values — stated explicitly, non-colliding confirmed
- [ ] Task 3 rear-wall cut: real `intersection()` used against live
      `true_octagon_profile()` (not hand-derived) — confirmed, method
      stated explicitly
- [ ] Real description/render confirms the cut is round at top,
      octagon-bounded lower down, matching Janis's "look through the
      door" description
- [ ] New firebox end-cap plate: upper octagon-zone / lower rectangle-
      zone construction confirmed as ONE continuous solid, real
      dimensions stated
- [ ] Real CGAL seal-weld checks: cylinder-to-hole-perimeter,
      end-cap-plate-to-firebox-cube — both confirmed non-floating
      contact
- [ ] Real confirmation: firebox interior fully sealed except at the
      door opening
- [ ] Real confirmation: old rectangular firebox-footprint cut fully
      removed, only the new cylinder∩octagon opening remains
- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Full kinetic sweep (lid, door, tray, shelf, ash tray, existing
      understructure kinetics) — `Simple: yes` throughout, INCLUDING
      full door-open sweep specifically checked against the new rear
      passage geometry
- [ ] 4-angle screenshots (iso/front/side/rear) PLUS one real
      look-through-the-open-door shot showing the round-top/octagon-
      bottom passage clearly, PLUS one dimensioned side-view showing
      apex-A Z(900), GRATE_Z_FIXED(1000), firebox top/bottom Z, and
      chamber_floor_z all labeled with real numbers
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: state
   real new `chamber_floor_z`, confirmed apex-A=900mm, grate decouple
   confirmation + explicit TEMPORARY flag, and the TASK 3 real
   intersection-cut method + seal-weld check results.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-18
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md —
   explicitly note the grate's TEMPORARY decoupled status in each, so
   it isn't mistaken for permanent architecture by a future session
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md`'s Envelope
   section: apex A / chamber-body reference now 900mm (real, built),
   grate now independently fixed at 1000mm (flagged TEMPORARY, pending
   future re-merge once the reinforcement frame + shorter door exist),
   new rear-passage/end-cap-plate construction described, bump version
5. Save as BBQ-chambers-v13.scad (v12 kept); update
   BBQ-offset-smoker-base-v1.scad's include v12→v13
6. Commit all → merge to main
