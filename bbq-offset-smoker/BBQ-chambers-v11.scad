// BBQ Offset Smoker — Chambers
// Version: v11
// Date: 2026-07-17
// Changes from v10: bbq-chambers-v11-firebox-wall-seal. THE REAL FIX for
// the "triangle leak" Janis has reported 3 prior rounds (PR #121 x2, v9)
// -- root cause found by Janis directly, independently confirmed by
// Claude before writing any code, per SKILL_local_render.md's
// Independent Post-Fix Verification rule.
//
// This is NOT the same defect v9/PR#121 tested. Those rounds all checked
// whether `firebox_passage_profile()` (the smoke-opening CUT) was clipped
// against the right boundary -- it is, confirmed 3 separate ways,
// untouched here.
//
// Real root cause: the chamber's octagon cross-section narrows near the
// floor (the bottom two chamfers). `firebox_shell()` is a plain SQUARE
// (firebox_size=457mm). Immediately above chamber_floor_z, the octagon's
// real width is narrower than the firebox's square opening -- so the
// square's own footprint extends PAST the chamber's true wall envelope
// on both sides, for the band chamber_floor_z..chamber_floor_z+102.165mm
// (recomputed live from this file's own chamfer/firebox_size, not
// trusted from the prompt). `firebox_near_wall_closure()` only ever
// closed the region BELOW chamber_floor_z (unchanged, still correct).
// Nothing ever built a closing panel for the region ABOVE
// chamber_floor_z where the square sticks out past the narrowing
// octagon -- `firebox_passage_profile()`'s inset cut correctly avoids
// cutting INTO that region, but clipping the opening never added
// material to seal the OUTSIDE of it. Two symmetric triangular openings
// (mirrored left/right of the firebox's Y-center) result -- this is the
// "triangle leak."
//
// Independent verification performed BEFORE writing this fix (real
// OpenSCAD render + STL export + Python analysis of the actual v10 file,
// not assumed from the prompt): `difference(firebox_square_2d(),
// fixed_side_solid_2d())`, restricted to h>=0 (world Z>=chamber_floor_z),
// produced exactly 16 STL facets = 2 triangular prisms, spanning world
// Z=[600, 702.165mm], area 5218.8436mm² EACH, mirror-symmetric (identical
// area, opposite Y side of DATUM_Y_CENTER) -- matches Janis's screenshot
// and this prompt's own diagnosis exactly.
//
// TASK 1: new module `firebox_upper_wall_seal_2d()` builds exactly that
// 2D gap shape (difference(firebox_square_2d(), fixed_side_solid_2d())
// clipped to h>=0 via a local half-space mask, same style as
// room_half_space()'s own big-margin box) -- built from the REAL
// firebox_square_2d()/fixed_side_solid_2d() modules (both DO NOT TOUCH,
// unchanged), not hardcoded triangle coordinates, so it stays correct if
// chamfer/firebox_size ever change. `firebox_upper_wall_seal()` extrudes
// this by wall_t at firebox_x0, same translate+rotate([0,90,0])+
// linear_extrude pattern and same e-overshoot convention
// firebox_passage()/firebox_near_wall_closure() already use. Called from
// firebox() alongside firebox_near_wall_closure().
//
// TASK 2 verification (see cc_chat_log.md for the full real-run results):
// CGAL probe of the filled triangle region (Simple: yes, solid material
// now present where the gap was), full kinetic sweep 0-120° (Simple:
// yes throughout), full BBQ-offset-smoker-base-v1.scad assembly chain
// (Simple: yes), render at Janis's own screenshot angle (both triangles
// visually filled), both panel areas confirmed 5218.84mm² each,
// mirror-symmetric.
//
// R-009: firebox_square_2d() and fixed_side_solid_2d() each confirmed
// defined exactly once, with exactly one real caller each
// (firebox_passage_profile()) before this change added a second real
// caller to both (firebox_upper_wall_seal_2d()) -- no duplication.
//
// ---- v10 (superseded logic, kept for record) ----
// Changes from v9: bbq-chambers-exhaust-room-recenter. Small, single-
// focus fix -- exhaust room vertical position only.
//
// Every prior placement of the exhaust room (v3's original centering
// formula, and v8's own "max-flush" recompute) used a wrong assumption
// about where the octagon's flat vertical wall zone actually starts. The
// flat wall zone is `[chamber_floor_z + chamfer, chamber_floor_z +
// chamber_H - chamfer]` -- NOT `[chamber_floor_z, chamber_floor_z +
// trough_h]` as v8's own ROOM_BASE_Z/ROOM_TOP_Z formula assumed (the
// bottom chamfer sits BELOW the flat wall zone, not included in it, so
// starting the zone at chamber_floor_z put v8's own "max-flush" position
// too low, its own top edge coincidentally landing AT the real
// wall/chamfer boundary rather than being centered anywhere useful).
// Recomputed real wall zone, independently verified from THIS file's own
// live chamfer/chamber_H (not trusted from the prompt): chamfer=178.665mm,
// chamber_H=610mm, chamber_floor_z=600mm -->
// zone = [600+178.665, 600+610-178.665] = [778.665, 1031.335].
// Janis wants the room's own vertical center aligned to the octagon's
// TRUE center, `chamber_floor_z + chamber_H/2` = 905mm exactly -- real
// formula (not a hardcoded 905), so it stays correct if chamber_H ever
// changes. New ROOM_BASE_Z/ROOM_TOP_Z = 855/955mm (was 752.670/852.670mm
// under v8's own flawed max-flush formula) -- both comfortably inside
// the real [778.665, 1031.335] wall zone, confirmed by direct computation,
// not assumed. R-009: grepped every real ROOM_BASE_Z/ROOM_TOP_Z consumer
// in the file before changing -- both are defined exactly once (no
// duplication) and read directly by `exhaust_room_opening()`,
// `room_half_space()`, `room_outer_half()`, `room_inner_cavity()`
// (ROOM_BASE_Z) and `room_pipe_hole()`/`PIPE_BASE_Z` (ROOM_TOP_Z) -- all
// update automatically, no other code changed. Position-only change:
// ROOM_D/ROOM_H, the room's own construction, and the chimney pipe's own
// construction are all untouched -- only the Z position moves.
//
// ---- v9 (superseded logic, kept for record) ----
// Changes from v8: bbq-chambers-v9-firebox-passage-true-profile.
//
// ** DOES NOT FIX THE "TRIANGLE LEAK" — READ BEFORE ASSUMING RESOLVED **
//
// The source prompt theorized that `firebox_passage_profile()`'s use of
// `fixed_shell_profile()` (the fake-diagonal profile) instead of
// `true_octagon_profile()`+`fixed_side_wedge()` was cutting the wrong
// shape, causing the "triangle leak" Janis has reported 3 times (PR #121
// investigated twice, found "no CGAL-provable defect" both times because
// -- the prompt claimed -- it was checking manifold validity, not visual
// correctness).
//
// Per the newly-added SKILL_local_render.md "Independent Post-Fix
// Verification (R-111 Escalation)" section, this claim was checked
// independently BEFORE writing any fix, not assumed:
//
// 1. REAL GEOMETRIC XOR TEST: `fixed_shell_profile()` and
//    `intersection(true_octagon_profile(), fixed_side_wedge())` were
//    rendered and XOR'd (symmetric difference) against each other in a
//    real OpenSCAD run. Result: EMPTY. These two shapes are
//    mathematically IDENTICAL -- same boundary, same area, same
//    diagonal-cut silhouette (the "fake" diagonal edge in
//    `fixed_shell_profile()` sits EXACTLY on the same reference line
//    `fixed_side_wedge()` uses to clip `true_octagon_profile()`, so
//    clipping via mask vs. baking the edge into the polygon produces the
//    identical filled 2D area here -- this is a DIFFERENT situation from
//    the v7 bug, where the profile was extruded SOLID the full chamber_L
//    length; here it's only ever used as a single flat 2D intersection
//    input, so the "spanning panel" failure mode never applied).
// 2. REAL 3D CGAL PROBE: the ACTUAL BUILT `chamber_shell()` (v8,
//    unchanged) was intersected with a padded box covering the firebox's
//    full footprint at the passage location and exported to STL. Result:
//    a clean, complete, Simple:yes 16-point cross-section boundary
//    exactly matching expected geometry (floor corners at chamfer/
//    chamber_W-chamfer=178.665/431.335mm, inset frame at
//    firebox_y0+15/firebox_y1-15=91.5/518.5mm matching PASSAGE_INSET) --
//    no gap, no missing material, no leak found in the real solid.
// 3. New passage area computed with the "fixed" profile: 88209.549116mm²
//    -- IDENTICAL (to the decimal) to v8's own 88209.5mm². Confirms
//    finding 1 numerically: this change alters ZERO geometry.
//
// CONCLUSION: the prompt's theorized root cause does not hold up under
// independent verification. TASK 1/2 below are still implemented (a real
// code-quality improvement -- `fixed_shell_profile()`, the file's last
// fake-diagonal profile, is now fully retired, and the passage is
// provably built from real edges only) but this is NOT a fix for the
// "triangle leak" symptom, because there was never a shape mismatch to
// fix in the first place. Whatever Janis is actually seeing (if it is a
// real, reproducible visual artifact and not e.g. an F5 preview seam
// between `chamber_shell()`'s cut edge and `firebox_shell()`'s own
// separate frame edge, meeting at a diagonal -- plausible but NOT
// independently confirmed either, stated as a hypothesis only) remains
// UNEXPLAINED after 3 real investigation rounds (PR #121 x2, this
// session). Per this project's own KT protocol ("IF 3RD LOOP FAILS AFTER
// FULL KT: state 'KT exhausted,' present the IS/IS-NOT table to Janis,
// do not write another fix prompt without new information from Janis"):
// this is now KT-exhausted territory. A 4th guess was not attempted.
// Janis's direct input is needed -- ideally a screenshot/angle that
// pinpoints exactly what reads as a "leak," or confirmation this is a
// preview-only artifact safe to ignore. See cc_chat_log.md.
//
// ---- v8 (superseded logic, kept for record) ----
// Changes from v7: bbq-chambers-v8-regular-octagon-continuous-channel.
// Two related fixes, both locally verified before writing (real OpenSCAD/
// CGAL, installed fresh this session) — both touch the same modules, so
// done together.
//
// FIX 1 -- REGULAR OCTAGON: `chamfer` was locked at 150mm since v1, but
// was never actually the value that makes an octagon inscribed in a
// 610x610 square have all 8 equal sides. For 8 equal sides:
// W - 2*chamfer = chamfer*sqrt(2), i.e. chamfer = W/(2+sqrt(2)) =
// 178.665mm (real formula, not a decimal literal -- stays correct if
// chamber_W ever changes). At the old 150mm value, the octagon had 4
// sides at 310mm (walls/ridge) and 4 at 212.13mm (chamfers) -- correctly
// flagged by Janis as visually exaggerated (it's the 4 SHORT chamfer
// faces that were short, not any face being long). Verified via real
// OpenSCAD render: all 8 edges of the corrected octagon measure
// 252.6703mm exactly (shoelace-style edge-length check on
// true_octagon_profile()'s own 8 points).
//
// This forced a real DATUM-CHAIN INVERSION (not just a decimal swap):
// `GRATE_Z` was previously the independent "MASTER CONTROL VALUE," with
// `chamber_floor_z = DATUM_GRATE_Z - grate_clearance` derived FROM it.
// Per Janis ("if you do it right, grate will lift up naturally"), the
// grate's Z was never really independent -- it's supposed to sit exactly
// at the top of the lower chamfer (the lid parting line), a real
// geometric constraint, not an arbitrary ergonomic pick. Making
// `GRATE_Z = chamber_floor_z + chamfer` a literal formula (TASK 2) is
// IMPOSSIBLE without also flipping which side is independent -- you can't
// derive chamber_floor_z from GRATE_Z AND derive GRATE_Z from
// chamber_floor_z at once (circular). Fixed by making `chamber_floor_z`
// itself the new fixed PARAMETER (600mm, numerically unchanged) and
// `GRATE_Z`/`DATUM_GRATE_Z` a DATUMS-block formula. `grate_clearance`
// (its only consumer was the old chamber_floor_z formula) is RETIRED --
// the floor-to-grate distance is now always exactly `chamfer` by
// construction, not an independently-tunable clearance. New real value:
// GRATE_Z = 600 + 178.665 = 778.665mm (was hardcoded 750).
// SKELETON_WORKSHEET.md Part A's PRIMARY DATUM updated to match (was
// DATUM_GRATE_Z "grate-down"; now chamber_floor_z, GRATE_Z derived
// "floor-up" for the grate specifically -- firebox_floor_z's own
// direction off chamber_floor_z is unchanged either way).
//
// R-009 DUPLICATION CHECK (done before writing any fix, full grep of
// `chamfer` in the live v7 file, not just the prompt's own named list):
// real consumers found -- `trough_h`, `GRATE_Z` (TASK 2), `ROOM_BASE_Z`/
// `ROOM_TOP_Z` (TASK 4, via trough_h), `fixed_shell_profile()` (kept, v7
// note, still the one real caller for `firebox_passage_profile()`),
// `true_octagon_profile()`, `fixed_side_wedge()`, `lid_profile()`,
// `lid_side_wedge()` (new), `lid_slant_len`, `lid_closed_panels()` (4
// direct uses), `GRATE_Y0`/`GRATE_Y1` (DO NOT TOUCH -- formula itself
// already correct, updates automatically). Full list stated in
// cc_chat_log.md before writing the fix, per the prompt's own instruction.
//
// FIX 2 -- NO VISIBLE END-MARGIN WALL: `lid_territory_end_caps()` (PR
// #121/v6) built the end margins as an INDEPENDENTLY-profiled piece (via
// `lid_profile()`, a 4-point quad) that only happens to abut
// `chamber_outer_tube()` (built from a DIFFERENT profile entirely,
// `fixed_shell_profile()` in v6, `true_octagon_profile()`+
// `fixed_side_wedge()` in v7) at X=LID_X0/LID_X1 -- two independently-
// defined profile shapes meeting at a seam, not two slices of the same
// tube. Janis wants the visible wall/seam gone entirely, not reshaped.
// Fixed per TASK 3: the fixed-side wedge already runs continuously across
// the FULL [0,chamber_L] (unchanged structurally from v7's
// `chamber_outer_tube()`); a NEW `lid_territory_margin_fill()` adds the
// complementary LID-side wedge (new `lid_side_wedge()`, real triangle:
// apex A / top-left corner / ridge midpoint) ONLY across
// [0,LID_X0]/[LID_X1,chamber_L], built from the SAME `true_octagon_profile()`
// ring as the fixed side (new shared helper `octagon_ring()`), real wall_t
// end cap ONLY at the true outer end (X=0 or X=chamber_L), fully OPEN
// (no closing face) at the LID_X0/LID_X1 boundary -- both pieces are now
// literally wedge-clipped slices of the identical tube, not two
// independently-modeled shapes that happen to match. `lid_territory_end_caps()`
// REMOVED (folded into `lid_territory_margin_fill()`). `chamber_inner_cavity()`
// also RETIRED as a standalone module (its job is now `octagon_ring()`'s
// internal inset step, reused by both pieces) -- confirmed zero other
// callers before removing (R-009).
// Real CGAL boundary probe at both LID_X0 and LID_X1 (post-fix): the
// octagon ring's wall_t material is continuous straight through the
// boundary, no perpendicular closing face at either plane -- see
// cc_chat_log.md for the actual probe result.
//
// `window_hole()`/`exhaust_room_opening()`-equivalent subtractions
// (`firebox_passage()`, `exhaust_room_opening()`) applied to the new
// `chamber_shell()` union exactly as before, unchanged.
//
// TASK 4 -- EXHAUST ROOM REPOSITIONED for the new trough_h: per Claude
// Web's prior max-flush decision (room stays flush against the flat wall,
// never extends into the chamfer), `ROOM_BASE_Z`/`ROOM_TOP_Z` recomputed
// from `chamber_floor_z + trough_h - ROOM_H` (was centered in the
// trough_h band: `chamber_floor_z + (trough_h-ROOM_H)/2`) -- real values
// 752.670/852.670 (was 705/805 under the old chamfer's centered formula).
// Confirmed ROOM_TOP_Z lands EXACTLY at the new wall/chamfer boundary
// (chamber_floor_z+trough_h = 852.670, matches ROOM_TOP_Z exactly).
//
// TASK 5 -- FIREBOX PASSAGE AREA CHANGED (real, flagged not silently
// absorbed): `firebox_passage_profile()` itself is UNCHANGED CODE, but it
// consumes `fixed_shell_profile()`, which consumes the now-corrected
// `chamfer` -- real shoelace-equivalent area (STL volume/1mm extrude, real
// OpenSCAD render): 92741.2mm² (old chamfer) -> 88209.5mm² (new chamfer),
// a real ~4.9% decrease (the corrected chamfer cuts deeper into the
// firebox square's corners). Bounding box UNCHANGED (X=[-242,-15],
// Y=[91.5,518.5] both before/after) -- only the corner geometry shrinks,
// not the overall opening envelope. Flagged for Janis, not silently
// absorbed.
//
// ---- v7 (superseded logic, kept for record) ----
// Changes from v6: bbq-chambers-v7-fixed-shell-open-channel-rebuild.
// R-111 territory — this is the 4th real attempt at "chamber reads solid,
// not hollow with lid open," but the FIRST one grounded in a real local
// OpenSCAD render before writing any fix (SKILL_local_render.md), not a
// guess. PR #119 (color/opacity) and v5's own end-cap gap fix were BOTH
// real fixes for what they targeted, but neither touched the actual
// culprit; PR #121's lid_territory_end_caps() hollow rebuild (v6, below)
// was also real and correct for ITS OWN module, but wrong module for
// this symptom's true source.
//
// ROOT CAUSE (confirmed via real CGAL cross-section probes at 3 points
// along LID_X0..LID_X1, not a single sample): `fixed_shell_profile()` is
// a 7-point CLOSED polygon whose points 3->4 ("PARTING START"/"PARTING
// END" per its own comments, apex A to ridge midpoint) are NOT a real
// octagon edge -- a straight diagonal added only so the profile could
// close as a valid extrudable 2D shape. The file's own header rationalized
// this as "the internal seam face only (hidden when lid is closed)" --
// true when the lid IS closed, but `chamber_outer_tube()`/
// `chamber_inner_cavity()` extrude this profile the FULL chamber_L length
// (not just the lid's own margins), so that "seam" is a real, permanent,
// wall_t-thick panel spanning apex-A-to-ridge-midpoint at every X in the
// open-lid sightline -- exactly Janis's "flat surface cover... at every
// angle of glaze."
//
// R-009 DUPLICATION CHECK (done before writing any fix): grepped every
// real call site of `fixed_shell_profile()` in this file (not just the
// 2 the prompt named). Found a THIRD: `firebox_passage_profile()`
// (intersection() with `firebox_square_2d()`) -- flagged explicitly in
// this prompt's own DO NOT TOUCH list as a separate open item (PR #121),
// so `fixed_shell_profile()` is KEPT, unchanged, still used by that one
// caller only. `chamber_outer_tube()`/`chamber_inner_cavity()` no longer
// call it at all -- see below.
//
// FIX: new `true_octagon_profile()` (TASK 1) -- the TRUE closed 8-point
// octagon, real edges only, no fake diagonal anywhere. `chamber_outer_tube()`/
// `chamber_inner_cavity()` REBUILT (TASK 2) to build the FULL wall_t hollow
// ring from this true profile (same outer-minus-inset-inner pattern this
// file already uses everywhere), THEN clip to the fixed (non-lid) side via
// `intersection()` with a new `fixed_side_wedge()` cutting-plane mask --
// never by baking a fake edge into the profile itself. Intersecting a
// cutting plane through a REAL HOLLOW RING exposes only the wall's true
// wall_t cross-section at the cut, never a spanning solid panel. Real CGAL
// confirmed `Simple: yes` on the rebuilt shell; 3-point cross-section probe
// (X=150, X=450, X=750, spanning the full LID_X0..LID_X1=[100,815] range)
// confirmed NO material spans the apex-to-ridge-midpoint line at any of
// them (real 6mm probe cube, empty at all 3 -- positive-control probe at
// the real floor confirmed the shell isn't accidentally hollow everywhere).
// `chamber_shell()`'s own `chamber_inner_cavity()` subtraction line REMOVED
// -- hollowing now happens internally inside the rebuilt `chamber_outer_tube()`,
// so subtracting it again from `chamber_shell()` would be a redundant no-op.
// `firebox_passage()`/`exhaust_room_opening()` re-applied to the new tube
// exactly as before, no change to either module (TASK 2 constraint).
//
// `lid_territory_end_caps()` (PR #121's fix, TASK 3) is UNTOUCHED --
// different module, already correct for what it covers. Re-verified via a
// real boundary `intersection()` probe at both LID_X0 and LID_X1 against
// the rebuilt main tube: clean join, no gap, no overlap (same benign
// zero-volume coincident-face touch at the shared X boundary this file has
// hit before, not new).
//
// ---- v6 (superseded logic, kept for record) ----
// Changes from v5: direct-cc fix (R-011 pattern, no prompt file). Janis
// reviewed v5 live in OpenSCAD desktop (2 new annotated screenshots) and
// found the "reads solid, not hollow" complaint STILL not resolved, plus 3
// more concrete items. ALL investigated first, per R-008.
//
// 1. STILL READS SOLID WITH LID OPEN — RE-DIAGNOSED (2nd loop on this
//    symptom; PR #119's color/opacity fix was loop 1, insufficient).
//    ROOT CAUSE FOUND: v5's own Finding-1 fix (`lid_territory_end_caps()`)
//    plugged the confirmed end-margin gap with a SOLID fill (using
//    lid_profile()'s shape as a solid block, not a hollow shell) — exactly
//    the two zones visible when the lid is open (X near the front/rear
//    ends, right where an open-lid viewer is looking). A solid opaque-
//    looking block sitting right in the sightline reads as "solid mass"
//    even though the REST of the shell is correctly hollow — this was a
//    real design gap in the v5 fix itself, not a re-run of PR #119's
//    color root cause. FIX: `lid_territory_end_caps()` REBUILT as a
//    proper wall_t-thick HOLLOW shell using a new `full_octagon_profile()`
//    (the TRUE 8-point closed octagon — union of fixed_shell_profile()'s
//    and lid_profile()'s own pieces), matching the same hollow
//    construction the rest of the tube already uses (chamber_outer_tube()/
//    chamber_inner_cavity()) — solid only for the true wall_t-thick end
//    caps at the outermost tips (X=0, X=chamber_L), same pattern
//    chamber_inner_cavity() already uses for its own end caps.
//
// 2. LID MARGIN WIDENED 10mm -> 100mm EACH END: LID_X0=100 (was 10),
//    LID_X1=chamber_L-100=815 (was 905). The end zones are now real fixed
//    (welded, non-opening) octagon-ring sections per Finding 1 above, not
//    a thin plug — a much more realistic fixed-vs-kinetic split.
//
// 3. FIREBOX PASSAGE "TRIANGLE GAP" AT THE BOTTOM CORNERS: investigated
//    via real CGAL — the raw pre-offset intersection() polygon AND the
//    offset(-10)/offset(-15) results are all single-contour, non-self-
//    intersecting (no topological defect at either inset). A targeted
//    solid probe at the exact corner divergence zone (where the
//    octagon-chamfer-bound edge crosses over to the firebox-square-bound
//    edge) confirmed REAL chamber wall material still exists there (7
//    facets, Simple:yes, non-empty) — NOT a true unclosed hole. Most
//    likely a fast-preview (F5) rendering seam where the chamber's
//    octagon-clipped cut boundary and firebox_shell()'s own plain-square
//    frame edge diverge most (exactly at the corners) — two separately-
//    colored adjacent solids that don't merge in preview mode, not a CGAL
//    manifold defect. Per Janis's own explicit request: PASSAGE_INSET
//    10mm -> 15mm (retains partition strength, also widens the visible
//    solid margin around the seam as a practical side effect).
//
// 4. GRILL GRATE REPOSITIONED to the lid parting line: GRATE_Z 700 -> 750.
//    "Lid parting line (bottom of face facing cooker)" = the bottom edge
//    of the lid's own vertical wall panel (lid_closed_panels() panel 3),
//    which sits at chamber_floor_z + chamfer = 600+150 = 750 exactly (not
//    a coincidence — this is where trough_h's own vertical-wall zone
//    begins). grate_clearance updated 100->150 in lockstep so
//    chamber_floor_z stays EXACTLY 600 (unchanged) — only the grate's own
//    seat height moves, nothing else in the datum chain shifts. No
//    understructure change needed: leg_h derives from chamber_floor_z
//    alone (unaffected by GRATE_Z), confirmed by reading the live formula,
//    not assumed.
//
// ---- v5 (superseded logic, kept for record) ----
// Changes from v4: direct-cc fix (R-011 pattern, no prompt file — Janis
// sent 2 new annotated OpenSCAD-desktop screenshots of the v4 build with 3
// findings). ALL 3 INVESTIGATED FIRST via real CGAL checks before any code
// changed, per R-008 Verification Discipline — see cc_chat_log.md for the
// full probe record.
//
// 1. MISSING EDGE / UNCLOSED GAP (front+rear lid-territory margins):
//    CONFIRMED real via CGAL -- a probe cube at X=[0,10] (inside the lid's
//    own cross-section territory, Y=0-ish side) against chamber_shell()
//    returned "Current top level object is empty", same result at the
//    rear margin X=[905,915]. Root cause: fixed_shell_profile() (used by
//    chamber_outer_tube()/chamber_inner_cavity() for the FULL chamber_L
//    length) only ever traces the FIXED (right, floor+both-chamfers+
//    right-wall) portion of the octagon -- the lid's own territory (upper-
//    left, above the bottom chamfer zone) is correctly left open for
//    X=[LID_X0,LID_X1] (lid() itself supplies material there, kinetic) but
//    was NEVER closed for the 2 short margins OUTSIDE that range
//    (X=[0,LID_X0] and X=[LID_X1,chamber_L]), where lid() provides nothing
//    either (a cap-less trough by design). Fixed via new
//    lid_territory_end_caps() -- solid fill using lid_profile() itself (so
//    the plug's own exterior traces the real octagon edges exactly),
//    folded into chamber_shell()'s own union() so the existing
//    exhaust_room_opening()/firebox_passage() cuts apply to it too (both
//    overlap this Y-range at the ends).
//
// 2. GRILL GRATE COLLIDES WITH THE FIXED SHELL (not the lid -- verified
//    separately, grate-vs-closed-lid tested EMPTY): CONFIRMED real via
//    CGAL, 36 facets, exact coords X=[60,855] Y=[50,560] Z=[690,700].
//    Root cause: grill_grate()'s old Y-range (wall_t+10 ..
//    chamber_W-(wall_t+10) = [13,597]) assumed a constant-width interior,
//    but the chamber's real octagon geometry narrows near the floor via
//    BOTH bottom chamfers (unchanged since v1) -- at the grate's own
//    height band (h=90..100 above chamber_floor_z, well inside the
//    chamfer=150 zone) the true interior boundary is much narrower than
//    the mid-height chamber_W figure the old code assumed. Fixed by
//    computing GRATE_Y0/GRATE_Y1 from the real chamfer-boundary formulas
//    (Y_left(h)=chamfer-h, Y_right(h)=(chamber_W-chamfer)+h) evaluated at
//    the grate's own binding height, + wall_t/safety inset -- same
//    approach as GRATE_MARGIN already uses on the X axis, just newly
//    applied to Y. GRATE_Z itself (world Z=700) is documented elsewhere as
//    a MASTER CONTROL VALUE, not derived -- NOT moved this pass; the
//    "also too low" visual complaint is expected to resolve as a
//    byproduct of removing the real intrusion (the mesh no longer plows
//    into the slanted chamfer wall), flagged here rather than silently
//    assumed fixed.
//
// 3. FIREBOX PASSAGE TOO SMALL: Janis's explicit spec -- "follow the
//    intersec of hexagon profile but offset from edge -10mm around the
//    cut profile". window_hole() (v1, a fixed 254x119mm rectangle,
//    previously DO-NOT-TOUCH) REPLACED with firebox_passage() -- the real
//    2D intersection of fixed_shell_profile() (the chamber's own cross-
//    section) and the firebox's own square cross-section (both expressed
//    in the same hex_pt(h,w) 2D space), inset 10mm via offset(delta=-10).
//    A real 2D boolean (not manual per-height math) so it automatically
//    follows both bottom chamfers AND the internal parting seam correctly
//    across the firebox's full height range. This is a real scope change
//    (small fixed window -> large contour-following passage), flagged
//    explicitly, not silently dropped -- same precedent as v2's removed
//    fold-chimney (see SKELETON_WORKSHEET.md PART C). window_w/window_h
//    params removed (orphaned by the replacement).
//
// ---- v4 (superseded logic, kept for record) ----
// Changes from v3: direct-cc fix (R-011 pattern, no prompt file — Janis
// reported the v3 build's lid-open screenshots look like "a solid octagon
// mass, not a shell configuration" and asked to see the grill grate
// sitting inside).
//
// INVESTIGATED FIRST, not assumed: real CGAL cross-section check at
// X=400 (chamber_shell(), pre-window/exhaust cuts) found 14 distinct
// boundary points -- 7 matching fixed_shell_profile()'s own outer
// vertices exactly, 7 matching an ~3mm-inset copy of the same 7 vertices.
// That's a genuine thin-walled ring, not a solid fill -- the hollow shell
// IS geometrically correct. (Two earlier probes near the bottom-right-
// chamfer corner found "unexpected" solid material, but that was a bad
// probe choice, not a defect -- a diagonal chamfer's own wall_t band
// legitimately extends further into a naive axis-aligned probe box near
// a corner than a straight wall section would; re-verified against the
// actual outer/inner vertex coordinates, not re-guessed.)
// ROOT CAUSE of the visual complaint: no color()/opacity was ever applied
// to any BBQ part (chamber_shell/lid/firebox/exhaust_room/chimney_pipe
// all rendered in OpenSCAD's flat default yellow, fully opaque). With no
// transparency, looking through the lid's open lid-territory reveals the
// FAR interior wall -- opaque and the same flat color as everything else,
// so it reads as "solid" rather than "hollow, this is the far wall,
// nothing in between." This project's OWN existing rules-codes.md already
// has a standing "Color and Opacity Rules" + "COLOR CODING STANDARD"
// convention for exactly this (outer shell = 0.75 opacity) -- never
// applied to any BBQ file until now. Fix: color()/opacity added per that
// existing convention (see ASSEMBLY block below) -- not a new convention
// invented for this file, applying the one that already governs the rest
// of the project.
//
// Changes from v2 (v3, carried forward): 3 corrections per
// prompts/bbq-chambers-v3-closure-exhaust-resize-lid-mirror-cc-prompt.md
// (Janis's own review of the merged v2 build, real hardware photos +
// labeled diagrams):
//
// 1. FIREBOX-TO-CHAMBER BOTTOM GAP CLOSED: firebox_floor_z sits
//    firebox_drop(200mm) below chamber_floor_z. The firebox's near
//    (chamber-facing) wall is correctly open for Z>=chamber_floor_z
//    (matches window_hole()'s own pass-through), but for
//    firebox_floor_z..chamber_floor_z there was no chamber wall behind it
//    at all (chamber doesn't extend that low) -- a genuine unclosed hole,
//    not a designed opening. New firebox_near_wall_closure() panel added,
//    Z=[firebox_z0, chamber_floor_z] only -- the existing opening for
//    Z>=chamber_floor_z is untouched.
//
// 2. EXHAUST ROOM RESIZED: ROOM_D 200->360, ROOM_H 200->100 (own v2
//    finding: 127mm pipe couldn't fit a 200mm room's max-100mm-inscribed-
//    circle). New room inscribes a 180mm circle -- real margin over the
//    127mm pipe, no forced overhang. Every downstream value re-derived in
//    dependency order (ROOM_BASE_Z/TOP_Z, the rectangular endcap opening,
//    PIPE_HOLE_X) -- none left as stale v2 numbers.
//
// 3. LID MIRRORED: v2 put the lid on the Y=chamber_W (right) side; Janis's
//    review confirmed the lid must open toward the user, and per the new
//    Standing Orientation Convention (rules-bbq-fab.md, this session) the
//    user-facing/near side is Y=0. fixed_shell_profile()/lid_profile()
//    and lid_closed_panels() all mirrored (w -> chamber_W-w transform) --
//    FIXED shell now occupies the Y=chamber_W-ish side, LID now occupies
//    the Y=0-ish side. Hinge Z/Y datum UNCHANGED (ridge midpoint doesn't
//    move under this mirror). Re-verified the acute-angle-at-hinge defect
//    (v2's own finding, fixed via flat cube() panels) stays fixed after
//    the mirror -- confirmed via a fresh CGAL sweep, not assumed from
//    symmetry.
//
// 4. GOVERNANCE: new "Standing Orientation Convention" section added to
//    rules-bbq-fab.md (exhaust=left/firebox=right/lid-toward-user when
//    facing the smoker), locked so it's never re-guessed in a future
//    session. See that file.
//
// SOURCE: prompts/bbq-chambers-v3-closure-exhaust-resize-lid-mirror-cc-prompt.md.
// Naming note (carried from v1/v2): the prompt assumes a function named
// `hp(h,w)` -- this file already has an equivalent helper, `hex_pt(h,w)`,
// same signature/semantics ([-h,w] encoding). Reused as-is, not renamed.
//
// SKELETON — single source of truth. Every module below declares its
// Parent explicitly (a DATUM_* below, or another part's local origin).
// Local origin for this file: (0,0,0) at floor level, front-left — matches
// MASTER ORIGIN in SKELETON_WORKSHEET.md.

$fn = 64;
e   = 0.01;   // epsilon, coplanar-face offset per rules-codes.md

// ───────────────────────────────
// PARAMETERS — all mm
// ───────────────────────────────
wall_t           = 3;
chamber_L        = 915;                  // length, along X
chamber_W        = 610;                  // width, along Y
chamber_H        = 610;                  // full octagon cross-section height, floor to ridge
// chamfer -- v8 CORRECTED: real formula for a REGULAR octagon (all 8 sides
// equal) inscribed in a chamber_W x chamber_W square. Was hardcoded 150mm
// since v1 (never actually regular -- see file header Finding 1). Real
// value: 178.665mm. Kept as a formula (not a decimal literal) so it stays
// correct if chamber_W ever changes.
chamfer          = chamber_W / (2 + sqrt(2));   // 178.665mm (v8, was hardcoded 150)
// chamber_floor_z -- v8: NOW THE PRIMARY DATUM / MASTER CONTROL VALUE (was
// DERIVED from GRATE_Z/grate_clearance in v1-v7). See file header for the
// full datum-chain-inversion rationale (GRATE_Z = chamber_floor_z + chamfer
// is circular otherwise). Numeric value UNCHANGED (600mm) -- only which
// side of the relationship is independent has flipped.
chamber_floor_z  = 600;
firebox_size     = 457;
firebox_drop     = 200;                  // ASSUMPTION — OPEN FLAG, still not resolved (DO NOT TOUCH)
PASSAGE_INSET    = 15;                   // v6: 10->15 per Janis's explicit request (retain partition
                                          // strength; also widens the visible solid margin around the real
                                          // wall material at the corners, see file header Finding 3)
intake_w         = 107;
intake_h         = 107;
chimney_d        = 127;
chimney_len      = 762;                  // carried over from v1 (prompt didn't restate it) —
                                          // still satisfies the <=2.5m top-height rule, see below

// v3 TASK 2: resized 200/200 -> 360/100. Max inscribed circle in a
// semicircle of radius R has diameter R (proof: tangent to both the flat
// chord and the arc requires hole-radius = R/2). At ROOM_D=360 (R=180),
// max inscribed = 180mm, real margin over chimney_d=127mm -- no forced
// overhang needed, unlike v2's 200mm room (max inscribed only 100mm).
ROOM_D           = 360;                  // exhaust room diameter (v3 TASK 2, was 200)
ROOM_H           = 100;                  // exhaust room height, vertical axis (v3 TASK 2, was 200)

LID_X0           = 100;                  // v6: 10->100 per Janis's explicit spec — real fixed (welded)
                                          // octagon-ring end zones, not a thin plug (see file header)
LID_X1           = chamber_L - 100;      // 815 (v6, was 905)
LID_LENGTH       = LID_X1 - LID_X0;      // 715 (v6, was 895)

// ───────────────────────────────
// DATUMS — SKELETON block (per SKILL_product_design_skeleton.md)
// PRIMARY:   chamber_floor_z  (horizontal plane) — locks Z. v8: FLIPPED
//            from DATUM_GRATE_Z (was "grate-down": chamber_floor_z derived
//            FROM the grate). Now "floor-up" for the grate specifically:
//            GRATE_Z is DERIVED (= chamber_floor_z + chamfer, the real
//            lid-parting-line constraint), chamber_floor_z is the fixed
//            input. firebox_floor_z's own direction off chamber_floor_z is
//            unchanged either way. See file header for the full rationale.
// SECONDARY: DATUM_X_REAR     (chamber's rear/firebox wall, X plane) — locks X
// TERTIARY:  DATUM_Y_CENTER   (chamber's lateral centerline, Y plane) — locks Y
// ───────────────────────────────
// GRATE_Z / DATUM_GRATE_Z -- v8: NOW FORMULA-DERIVED (was hardcoded 750,
// even though a comment claimed "= chamber_floor_z + chamfer exactly" —
// that was a coincidence-by-comment, not a real formula, per Janis's own
// "if you do it right, grate will lift up naturally"). Real new value:
// 778.665mm (was 750) -- moves automatically now that chamfer is corrected.
GRATE_Z          = chamber_floor_z + chamfer;                  // 778.665mm (v8, was hardcoded 750)
DATUM_GRATE_Z    = GRATE_Z;
DATUM_X_FRONT    = 0;                                          // Parent: MASTER ORIGIN
DATUM_X_REAR     = DATUM_X_FRONT + chamber_L;                  // 915 -- Parent: DATUM_X_FRONT, offset dX=+chamber_L
DATUM_Y_LEFT     = 0;                                          // Parent: MASTER ORIGIN
DATUM_Y_CENTER   = DATUM_Y_LEFT + chamber_W/2;                  // 305 -- Parent: DATUM_Y_LEFT
// trough_h -- v8: real dimensional change from the corrected chamfer,
// 310 -> 252.670mm. Every downstream value using it (ROOM_BASE_Z etc)
// recomputes automatically, in dependency order.
trough_h         = chamber_H - 2*chamfer;                       // 252.670mm (v8, was 310)
DATUM_Z_RIDGE    = chamber_floor_z + chamber_H;                  // 1210 -- outer ridge surface AND lid hinge Z (v2, dual meaning) -- UNCHANGED, floor+full height, not floor+chamfer

firebox_floor_z  = chamber_floor_z - firebox_drop;              // 400 -- Parent: chamber_floor_z, offset dZ=-firebox_drop

// Exhaust room datums — v10 RECENTERED: v8's own "max-flush" formula
// (chamber_floor_z + trough_h - ROOM_H) wrongly assumed the flat wall
// zone starts AT chamber_floor_z -- it actually starts at
// chamber_floor_z+chamfer (the bottom chamfer sits below the flat zone,
// not inside it), so v8's own room ended up sitting too low, its top
// edge only coincidentally landing at the real wall/chamfer boundary.
// Real flat wall zone (recomputed from this file's own live chamfer/
// chamber_H, not assumed): [chamber_floor_z+chamfer,
// chamber_floor_z+chamber_H-chamfer] = [778.665, 1031.335]. New formula
// centers the room on the octagon's TRUE vertical center
// (chamber_floor_z+chamber_H/2 = 905mm exactly) -- both ROOM_BASE_Z=855
// and ROOM_TOP_Z=955 confirmed comfortably inside the real wall zone.
ROOM_BASE_Z      = chamber_floor_z + chamber_H/2 - ROOM_H/2;    // 855mm (v10, was 752.670mm under v8's flawed max-flush formula)
ROOM_TOP_Z       = ROOM_BASE_Z + ROOM_H;                         // 955mm (v10, was 852.670mm)

// ───────────────────────────────
// PROFILE HELPERS — encoded [-height, width] so that rotate([0,90,0])
// after linear_extrude(length) lands as world (X=length, Y=width,
// Z=height) — verified empirically in v1, unchanged mechanism.
// ───────────────────────────────
function hex_pt(h, w) = [-h, w];

// fixed_shell_profile() — 7-point profile, MIRRORED v3 TASK 3 (w ->
// chamber_W-w transform applied to every v2 point): now traces floor,
// RIGHT wall (near Y=chamber_W), RIGHT chamfer, RIGHT half of ridge —
// then a single straight PARTING edge (point 3 to point 4) closing back
// to the floor's left end. v2 had this on the Y=0 side; the mirror swaps
// which side is fixed vs lid so the lid ends up on the Y=0 (user-facing,
// per the new Standing Orientation Convention) side instead. This parting
// edge is the internal seam face only (hidden when lid is closed) -- NOT
// the visible exterior, which is why it's allowed to be a straight
// diagonal rather than tracing real edges (unlike the lid's own profile
// below, whose exterior IS visible).
// fixed_shell_profile() — v9 REMOVED (was here through v8). This was the
// 7-point profile with the fake diagonal PARTING edge (apex A -> ridge
// midpoint) that caused v7's "reads solid" bug when extruded SOLID the
// full chamber_L length. v7/v8 already stopped using it for the main
// tube; its last real caller, `firebox_passage_profile()`, is rebuilt
// below (v9 TASK 1) to use `fixed_side_solid_2d()` instead -- confirmed
// via a full-file grep (R-009) that this leaves ZERO real callers, so
// the module is deleted outright rather than kept as dead code. NOTE:
// per v9's own header, this rebuild does NOT change the passage's
// geometry at all -- a real XOR test proved `fixed_shell_profile()` and
// `fixed_side_solid_2d()` are identical shapes. This deletion is a code-
// quality cleanup (retires the file's last fake-diagonal profile), not
// part of any fix for the "triangle leak" symptom.

// true_octagon_profile() — v7 TASK 1, NEW. The TRUE closed 8-point
// octagon: real edges only (floor, left chamfer, left wall, left
// ridge-half, ridge, right ridge-half/chamfer, right wall, bottom-right
// chamfer closing back to point 1) -- no fake diagonal anywhere, unlike
// `fixed_shell_profile()` above. Boundary check (v7, stated per prompt):
// 8 points, each consecutive pair + the closing edge is a real octagon
// edge (floor width = chamber_W-2*chamfer, wall height = chamber_H-2*chamfer
// = trough_h, all 4 corners chamfered 45deg equal rise/run) -- a convex,
// simple, non-self-intersecting polygon, confirmed via real OpenSCAD
// render (2D outline + extrude), not assumed. Same hex_pt(h,w) 2D space as
// every other profile in this file.
// Parent: chamber_floor_z (local h=0 == world chamber_floor_z), same as
// fixed_shell_profile().
module true_octagon_profile() {
    polygon(points=[
        hex_pt(0, chamber_W - chamfer),            // 1: floor, right end
        hex_pt(0, chamfer),                        // 2: floor, left end
        hex_pt(chamfer, 0),                          // 3: apex A — real left chamfer/wall corner
        hex_pt(chamber_H - chamfer, 0),               // 4: left wall top
        hex_pt(chamber_H, chamfer),                   // 5: ridge, left end
        hex_pt(chamber_H, chamber_W - chamfer),        // 6: ridge, right end
        hex_pt(chamber_H - chamfer, chamber_W),        // 7: right wall top
        hex_pt(chamfer, chamber_W),                     // 8: right wall bottom
    ]);
}

// fixed_side_wedge() — v7 TASK 2, NEW. A cutting-plane MASK (not a wall
// profile) that keeps only the FIXED (non-lid) side of the real apex-A ->
// ridge-midpoint line: full floor + right wall + right-half ridge, closed
// back to apex A via the SAME diagonal reference line `fixed_shell_profile()`
// used to bake into its own boundary -- but here it's only a mask edge,
// never extruded as a stand-alone solid on its own. Used via
// `intersection()` against a REAL HOLLOW RING (see `chamber_outer_tube()`
// below) -- intersecting a mask through a hollow ring exposes only the
// wall's true wall_t cross-section at the cut, never a spanning panel
// (the ring has no material to expose in the middle to begin with).
// Ridge midpoint is a cut-plane REFERENCE point only, not claimed as a
// profile vertex of the true octagon (see true_octagon_profile() above --
// it isn't one).
module fixed_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A (real corner, shared with true_octagon_profile() point 3)
        hex_pt(0, 0),
        hex_pt(0, chamber_W),
        hex_pt(chamber_H, chamber_W),
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only, not a real vertex)
    ]);
}

// lid_side_wedge() — v8 TASK 3, NEW. The complementary mask to
// fixed_side_wedge() above, cut along the SAME apex-A-to-ridge-midpoint
// reference line: a real triangle (apex A / top-left corner / ridge
// midpoint) that bounds exactly the left wall + left chamfer + left-half
// ridge — the real octagon material fixed_side_wedge() excludes. Used the
// same way (intersection() against a real hollow ring), so it never
// produces a spanning panel either.
module lid_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A
        hex_pt(chamber_H, 0),            // top-left corner (h=chamber_H, w=0)
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only)
    ]);
}

// lid_profile() — 4-point profile, MIRRORED v3 TASK 3 (same w ->
// chamber_W-w transform). Now the LEFT-side chunk (near Y=0): half ridge,
// LEFT chamfer, LEFT wall — the 2.5-side piece removed from
// fixed_shell_profile() above. Edges 1->2 (half ridge), 2->3 (real left
// chamfer), 3->4 (real left wall) ARE the real octagon edges -- this is
// the visible exterior when the lid is closed. Only the 4->1 closing edge
// is the internal diagonal seam face, mirroring fixed_shell_profile()'s
// own seam.
// NOT used directly for construction below (see lid_closed_panels()'s own
// header for why) -- kept as the documented reference shape this file's
// governance docs (SKELETON_WORKSHEET.md) describe.
module lid_profile() {
    polygon(points=[
        hex_pt(chamber_H, chamber_W/2),            // 1: ridge midpoint (hinge line, unchanged)
        hex_pt(chamber_H, chamfer),                 // 2: ridge, left end (half-ridge) (was right, v2)
        hex_pt(chamber_H - chamfer, 0),             // 3: top-left chamfer bottom (= real wall top) (was right, v2)
        hex_pt(chamfer, 0),                          // 4: left wall bottom (parting end, = fixed_shell_profile point 3) (was right, v2)
    ]);
}

// ───────────────────────────────
// chamber_shell() — fixed portion only (floor + RIGHT wall (Y near
// chamber_W) + right chamfer + half ridge, v3 mirror — was the Y=0 side
// in v2), wall_t hollow, full chamber_L length. NO lid-opening cutout
// needed -- the fixed-side clip (via `fixed_side_wedge()`, v7) already
// excludes the lid's territory for its whole length.
// Parent: DATUM_X_FRONT / chamber_floor_z / DATUM_Y_LEFT.
// v8 TASK 3 REBUILD: chamber_outer_tube() and the new
// lid_territory_margin_fill() (replaces lid_territory_end_caps()) are now
// both built from the SAME shared helper, octagon_ring() — two
// wedge-clipped slices of the literal same tube, not two independently-
// profiled shapes that happen to abut (v7's chamber_outer_tube() used
// true_octagon_profile()+fixed_side_wedge(); v7's lid_territory_end_caps()
// used a DIFFERENT profile, lid_profile(), for its own separate
// construction). chamber_inner_cavity() RETIRED as a standalone module —
// confirmed zero other callers (R-009) — its job is now octagon_ring()'s
// own internal inset step, reused by both pieces below.
// ───────────────────────────────
// octagon_ring(x0, x1, cap_x0, cap_x1) — true-octagon wall_t hollow ring
// across X=[x0,x1]. Each end independently gets either a REAL wall_t solid
// end cap (cap_*=true, e.g. the product's true outer ends) or stays fully
// OPEN/hollow-through (cap_*=false, e.g. the LID_X0/LID_X1 boundary — v8
// TASK 3 Finding 2: no separate closing face there).
module octagon_ring(x0, x1, cap_x0, cap_x1) {
    inner_x0 = cap_x0 ? x0 + wall_t : x0;
    inner_x1 = cap_x1 ? x1 - wall_t : x1;
    difference() {
        translate([x0, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = x1 - x0) true_octagon_profile();
        translate([inner_x0, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = inner_x1 - inner_x0, convexity = 4)
                offset(delta = -wall_t) true_octagon_profile();
    }
}
// chamber_outer_tube() — v8 TASK 3 point 1: fixed_side_wedge() intersected
// with the true octagon ring, run continuously across the FULL
// [DATUM_X_FRONT, DATUM_X_REAR] range — always present, never interrupted.
// Real end caps at both true ends (cap_x0=cap_x1=true), same as v7.
module chamber_outer_tube() {
    intersection() {
        octagon_ring(DATUM_X_FRONT, DATUM_X_REAR, true, true);
        translate([0, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = chamber_L, convexity = 4) fixed_side_wedge();
    }
}
// firebox_square_2d() — the firebox's own square cross-section, expressed
// in the SAME hex_pt(h,w) 2D space as the octagon profiles (2D-x=-h,
// 2D-y=Y=w), so they can be intersect()-ed directly. h measured local
// to chamber_floor_z (matches true_octagon_profile()'s own h=0 origin).
module firebox_square_2d() {
    translate([chamber_floor_z - firebox_z1, firebox_y0])
        square([firebox_size, firebox_size]);
}
// fixed_side_solid_2d() — v9 TASK 1, NEW. The REAL fixed-side wall
// boundary in 2D: intersection(true_octagon_profile(), fixed_side_wedge()),
// i.e. the same real-edges-only shape chamber_outer_tube()'s own true
// SOLID end cap (X=DATUM_X_REAR-wall_t..DATUM_X_REAR, uncut since
// octagon_ring() only insets the hollow cavity, not the outer solid) has,
// just expressed as a 2D filled area instead of a 3D extrude. REPLACES
// fixed_shell_profile() as firebox_passage_profile()'s intersection
// input. Built as a small 2D-only helper rather than adapting
// chamber_outer_tube()'s own 3D construction: chamber_outer_tube()
// produces a HOLLOW RING (correct for a wall, wrong shape for this use),
// while firebox_passage_profile() needs the FILLED solid cross-section
// (matching the real, uncut end-cap material the passage actually cuts
// through) -- reusing the 3D module would require re-deriving a filled
// 2D shape from a hollow 3D one, more indirect than just building the 2D
// intersection directly from the same two profile modules
// chamber_outer_tube() itself already uses.
// Real independent verification (v9, before writing this fix): rendered
// fixed_shell_profile() and this shape and computed their XOR (symmetric
// difference) -- result EMPTY. These two are mathematically IDENTICAL
// shapes (the fake diagonal edge sits exactly on the same reference line
// fixed_side_wedge() clips along), so this rebuild changes NO geometry --
// see file header, this is NOT a fix for the "triangle leak."
module fixed_side_solid_2d() {
    intersection() {
        true_octagon_profile();
        fixed_side_wedge();
    }
}
// firebox_passage_profile() — v5 Finding 3, REPLACES window_hole() (v1, a
// fixed 254x119mm rectangle). Per Janis's explicit spec: "follow the
// intersec of hexagon profile but offset from edge -10mm around the cut
// profile". A REAL 2D boolean intersection (not manual per-height math) --
// automatically follows both bottom chamfers correctly across the
// firebox's full height range, since intersection() clips to
// fixed_side_solid_2d()'s own real boundary wherever the firebox square
// would otherwise stick out past it. v9: rebuilt to intersect against
// fixed_side_solid_2d() (real edges only) instead of fixed_shell_profile()
// (fake diagonal) -- geometrically IDENTICAL result, confirmed via real
// XOR test and via this profile's own area (88209.549116mm², matches v8's
// 88209.5mm² exactly) -- see file header, this is a code-quality rebuild,
// not a shape change.
module firebox_passage_profile() {
    offset(delta = -PASSAGE_INSET)
        intersection() {
            fixed_side_solid_2d();
            firebox_square_2d();
        }
}
// firebox_passage() — extruded through the rear wall at DATUM_X_REAR,
// same wall_t-thickness pass-through pattern window_hole() used.
module firebox_passage() {
    translate([DATUM_X_REAR - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t + 2*e, convexity = 4)
            firebox_passage_profile();
}
// lid_territory_margin_fill() — v8 TASK 3 point 2, REPLACES
// lid_territory_end_caps() (PR #121/v6 — REMOVED, folded into this
// construction). chamber_outer_tube() already covers the FIXED side
// continuously across the FULL chamber_L (point 1); the ONLY thing
// missing at the 2 end margins (X=[DATUM_X_FRONT,LID_X0],
// X=[LID_X1,DATUM_X_REAR]) is the LID-SIDE material lid() itself would
// normally supply there — this module adds ONLY that, via the SAME
// octagon_ring() helper (not a separately-profiled shape, unlike v7's
// lid_profile()-based version), intersected with lid_side_wedge(). Each
// margin gets a real wall_t end cap ONLY at its own true outer end
// (cap at X=DATUM_X_FRONT / X=DATUM_X_REAR) — fully OPEN at the
// LID_X0/LID_X1 boundary (no separate closing face there, per Finding 2).
// NO overlap past LID_X0/LID_X1 into the lid's own kinetic X-range —
// same reasoning as v7 (rotate() only moves material within the Y-Z
// cross-section, never across X) — re-verified via a full CGAL kinetic
// sweep after this change, not assumed.
module lid_territory_margin_fill() {
    if (LID_X0 > DATUM_X_FRONT)
        intersection() {
            octagon_ring(DATUM_X_FRONT, LID_X0, true, false);
            translate([DATUM_X_FRONT, 0, chamber_floor_z]) rotate([0, 90, 0])
                linear_extrude(height = LID_X0 - DATUM_X_FRONT, convexity = 4) lid_side_wedge();
        }
    if (DATUM_X_REAR > LID_X1)
        intersection() {
            octagon_ring(LID_X1, DATUM_X_REAR, false, true);
            translate([LID_X1, 0, chamber_floor_z]) rotate([0, 90, 0])
                linear_extrude(height = DATUM_X_REAR - LID_X1, convexity = 4) lid_side_wedge();
        }
}
module exhaust_room_opening() {
    // Front end-cap opening (X=0..wall_t), matching exhaust_room()'s own
    // REAL flat interface face -- a rectangle (ROOM_D wide x ROOM_H tall,
    // v3: 360x100mm, was 200x200mm), confirmed still a RECTANGLE per this
    // file's own v2 finding (not the "semicircle" language some prompts
    // use) -- geometry unchanged by the resize, still governed by
    // ROOM_D/ROOM_H so both dimensions update automatically.
    // ROOM_GAP: a cut EXACTLY ROOM_D wide is exactly tangent to the room's
    // own curved outer surface (same radius, same center) along its full
    // height -- zero-clearance tangency, real CGAL union() (not
    // intersection()) found this non-manifold, same failure class as the
    // firebox door hinge fix (v1). Widened by 1mm each side/end for real
    // clearance -- confirmed via CGAL, see cc_chat_log.md.
    ROOM_GAP = 1;
    translate([-e, DATUM_Y_CENTER - ROOM_D/2 - ROOM_GAP, ROOM_BASE_Z - ROOM_GAP])
        cube([wall_t + 2*e, ROOM_D + 2*ROOM_GAP, ROOM_H + 2*ROOM_GAP]);
}
module chamber_shell() {
    // v8: lid_territory_end_caps() -> lid_territory_margin_fill() (TASK 3).
    // firebox_passage()/exhaust_room_opening() re-applied exactly as
    // before, unchanged (TASK 3 constraint).
    difference() {
        union() {
            chamber_outer_tube();
            lid_territory_margin_fill();   // v8 — replaces lid_territory_end_caps(), no separate closing wall
        }
        firebox_passage();              // v5 Finding 3 — replaces window_hole()
        exhaust_room_opening();
    }
}

// ───────────────────────────────
// exhaust_room() — half-cylinder mounting room. Vertical axis (Z),
// bisected by the X=0 plane (contains the axis, matches "flat face welds
// flush against the front end-cap"). Kept half = X<=0 (protrudes forward,
// away from the chamber). v3: resized 200/200 -> 360/100 (TASK 2), real
// margin now over the 127mm pipe (see PIPE_HOLE_X below). Parent:
// DATUM_X_FRONT / DATUM_Y_CENTER / ROOM_BASE_Z.
// ───────────────────────────────
ROOM_R = ROOM_D / 2;   // 180 (v3, was 100)
module room_half_space() {
    // keeps only X<=~0 (small +e overshoot for a clean back-face cut,
    // same overshoot habit as every other cut in this file)
    translate([-ROOM_R - 10, DATUM_Y_CENTER - ROOM_R - 10, ROOM_BASE_Z - e])
        cube([ROOM_R + 10 + e, 2*(ROOM_R + 10), ROOM_H + 2*e]);
}
module room_outer_half() {
    intersection() {
        translate([0, DATUM_Y_CENTER, ROOM_BASE_Z]) cylinder(d = ROOM_D, h = ROOM_H);
        room_half_space();
    }
}
module room_inner_cavity() {
    // wall_t solid on the curved side + floor + top; the BACK (X=0) gets
    // no reserved wall_t (both outer and inner reach the same +e boundary
    // there) -- this is what makes the back genuinely open, same
    // precedent as firebox_shell()'s own open near-face.
    intersection() {
        translate([0, DATUM_Y_CENTER, ROOM_BASE_Z + wall_t]) cylinder(d = ROOM_D - 2*wall_t, h = ROOM_H - 2*wall_t);
        room_half_space();
    }
}
// PIPE_HOLE_X: v3 TASK 2 RESOLVES the v2 conflict at the source (bigger
// room) instead of routing around it. ROOM_D=360 (R=180) inscribes a
// MAXIMUM 180mm circle (proof: tangent-to-both requires hole-radius=R/2);
// chimney_d=127mm (radius 63.5) fits with real margin. Centered for EQUAL
// clearance from both the flat back edge and the curved arc: at distance
// d from center, clearance_flat=d-r, clearance_arc=(R-d)-r; equal at
// d=R/2=90. Both clearances = 90-63.5 = 26.5mm -- real margin, no
// overhang, unlike v2's forced -60/-50 compromise (superseded).
PIPE_HOLE_X = -ROOM_R / 2;   // -90 (v3, was -60 in v2)
PIPE_HOLE_Y = DATUM_Y_CENTER;
module room_pipe_hole() {
    translate([PIPE_HOLE_X, PIPE_HOLE_Y, ROOM_TOP_Z - wall_t - e])
        cylinder(d = chimney_d, h = wall_t + 2*e);
}
module exhaust_room() {
    difference() {
        room_outer_half();
        room_inner_cavity();
        room_pipe_hole();
    }
}

// ───────────────────────────────
// chimney_pipe() — coaxial with room_pipe_hole() (same X,Y,d). Base
// starts BELOW the hole's own bottom (not at the hole's top edge or mid-
// height) so the pipe's solid body has REAL overlap with the surrounding
// top-plate material at the hole's rim, not just a top-edge touch — the
// exact defect the prompt's own CRITICAL note warns against. Per
// SKILL_joint_construction.md: simple coaxial round stacking, no
// elbow/loft needed (same diameter, single shared vertical axis).
// ───────────────────────────────
PIPE_BASE_Z = ROOM_TOP_Z - wall_t - e;   // 801.99 (v3, was 851.99) -- matches room_pipe_hole()'s own bottom
module chimney_pipe() {
    translate([PIPE_HOLE_X, PIPE_HOLE_Y, PIPE_BASE_Z])
        cylinder(d = chimney_d, h = chimney_len + wall_t + e);   // top = 1567.0mm world (v3, was 1617.0) -- within 2.5m limit
}

// ───────────────────────────────
// lid() — v2 TASK 3: full-length ridge-hinged clamshell, replaces the
// entire v1 end-hinged trunk-lid construction (lid_closed_panels(),
// LID_MARGIN_FRONT/REAR, lid_opening_cut() all removed). Built the same
// polygon+extrude+offset way as chamber_shell() (not v1's 3-flat-panel
// hack) -- lid_profile() is a proper 2D shape, no offset()-direction
// ambiguity risk this time (single convex-ish quad, verified via render).
// Open at BOTH X ends (no end caps) -- correct for the lid, it's a
// cap-less trough, not a sealed box.
// Hinge line (world): Y=DATUM_Y_CENTER, Z=DATUM_Z_RIDGE, running the
// FULL LID_LENGTH along X. Rotation is about this line's own X-axis --
// rotate([lid_open_deg,0,0]), translated to pass through the hinge line
// before rotating, then translated back.
// Parent: DATUM_Y_CENTER / DATUM_Z_RIDGE (hinge line).
// Kinetic: lid_open_deg 0 (closed) .. max (open) — max confirmed via
// real CGAL sweep, see cc_chat_log.md for the actual confirmed number.
// ───────────────────────────────
// lid_closed_panels() — 3 flat cube() panels (half-ridge + chamfer +
// wall), NOT a polygon+offset() extrude. v2 found a real defect on the
// same profile shape (offset() on the ~56.4deg acute hinge-vertex angle
// produced a numerically unstable spike, Simple:yes only at exactly 0deg)
// -- fixed there via flat cube() panels, matching rules-codes.md's own
// stated preference; re-verified this stays fixed after the v3 mirror
// (own CGAL sweep, not assumed from symmetry).
// v3 TASK 3: MIRRORED (w -> chamber_W-w) -- panels now build the LEFT
// (Y=0-ish) side instead of the right, matching lid_profile()'s own
// mirror above. LID_OVERLAP=3mm still gives real shared volume at the 2
// panel joins (union() must share volume, not just edges/faces). Open at
// both X ends (no caps) -- correct for the lid, a cap-less trough.
LID_OVERLAP = 3;
lid_slant_len = chamfer * sqrt(2) + LID_OVERLAP;
module lid_closed_panels() {
    // panel 1: half-ridge, flat (world Z = DATUM_Z_RIDGE), spans chamfer..DATUM_Y_CENTER (was DATUM_Y_CENTER..chamber_W-chamfer, v2)
    translate([LID_X0, chamfer - LID_OVERLAP, DATUM_Z_RIDGE - wall_t])
        cube([LID_LENGTH, DATUM_Y_CENTER - (chamfer - LID_OVERLAP), wall_t]);
    // panel 2: chamfer, slanted -135 deg (world Y DEcreases, Z decreases -- mirrored sign from v2's -45)
    translate([LID_X0, chamfer, DATUM_Z_RIDGE]) rotate([-135, 0, 0])
        cube([LID_LENGTH, lid_slant_len, wall_t]);
    // panel 3: wall, vertical (constant Y = 0, was Y = chamber_W in v2)
    translate([LID_X0, 0, chamber_floor_z + chamfer - LID_OVERLAP])
        cube([LID_LENGTH, wall_t, trough_h + LID_OVERLAP]);
}
module lid_closed() {
    lid_closed_panels();
}
// LID_HINGE_GAP: the hinge line (DATUM_Y_CENTER, DATUM_Z_RIDGE) sits
// exactly on fixed_shell_profile()'s own vertex (point 4, ridge midpoint)
// -- same exact-tangency class as v1's firebox door hinge fix. Real CGAL
// intersection() vs chamber_shell() found "Simple: no, Facets: 0" (a
// degenerate zero-clearance touch, not real volume) at every open angle.
// Fixed the same way: nudge the hinge axis a hair off the shell's own
// vertex. See cc_chat_log.md.
LID_HINGE_GAP = 0.5;
// ROTATION SIGN FLIPPED v3: the lid material now sits on the Y<
// DATUM_Y_CENTER side (mirrored, TASK 3), so swinging it AWAY from the
// fixed shell (now on the Y>DATUM_Y_CENTER side) requires the OPPOSITE
// sign from v2's rotate([+deg,0,0]) -- verified empirically (bounding box
// at deg=90: Y swings to -158 (away, correct) with -deg; Y swung to +769
// (INTO the fixed shell's own territory, wrong) with +deg, tested first).
module lid(lid_open_deg = 0) {
    translate([0, DATUM_Y_CENTER + LID_HINGE_GAP, DATUM_Z_RIDGE + LID_HINGE_GAP])
        rotate([-lid_open_deg, 0, 0])
        translate([0, -DATUM_Y_CENTER - LID_HINGE_GAP, -DATUM_Z_RIDGE - LID_HINGE_GAP])
        lid_closed();
}

// ───────────────────────────────
// lid_hardware() — UNCHANGED from v1, built for the OLD lid geometry.
// DISABLED in ASSEMBLY (show_lid_hardware=false) per explicit prompt
// instruction — every position below (handle posts, latches, lever,
// thermometer) is now wrong for the new lid shape. TODO: reposition once
// the new lid is confirmed by Janis — follow-up prompt, not this one.
// Kept as-is (not deleted, not fixed) so the old reference geometry isn't
// lost.
// ───────────────────────────────
LEVER_ARM = 400;     // mm off hinge pivot, per v1 session's torque calc
COUNTERWEIGHT_KG = 10; // target ~85-90% balance, placeholder mass only
module lid_hardware(lid_open_deg = 0) {
    translate([0, DATUM_Y_CENTER, DATUM_Z_RIDGE]) rotate([lid_open_deg, 0, 0]) translate([0, -DATUM_Y_CENTER, -DATUM_Z_RIDGE]) {
        // STALE v1 positions -- built for the old end-hinged trunk lid
        // (lid_x0/lid_x1 no longer exist). Not repositioned this pass.
    }
}

// ───────────────────────────────
// firebox() — UNCHANGED from v1 (DO NOT TOUCH, per this prompt's Section
// 5 — already correct and CGAL-verified).
// ───────────────────────────────
firebox_x0 = DATUM_X_REAR;                       // 915 -- Parent: DATUM_X_REAR
firebox_x1 = firebox_x0 + firebox_size;          // 1372
firebox_y0 = DATUM_Y_CENTER - firebox_size/2;    // 76.5 -- Parent: DATUM_Y_CENTER
firebox_y1 = firebox_y0 + firebox_size;          // 533.5
firebox_z0 = firebox_floor_z;                    // 400
firebox_z1 = firebox_z0 + firebox_size;          // 857
module firebox_shell() {
    difference() {
        translate([firebox_x0, firebox_y0, firebox_z0]) cube([firebox_size, firebox_size, firebox_size]);
        translate([firebox_x0 - e, firebox_y0 + wall_t, firebox_z0 + wall_t])
            cube([firebox_size + 2*e, firebox_size - 2*wall_t, firebox_size - 2*wall_t]);
    }
}

// firebox_near_wall_closure() — v3 TASK 1, NEW module (firebox_shell()
// itself unchanged per DO NOT TOUCH). Real defect: the firebox's near
// (chamber-facing) wall is open for its FULL height by design, matching
// window_hole()'s own pass-through for Z>=chamber_floor_z -- but for
// Z<chamber_floor_z (the firebox_drop=200mm step, since firebox_floor_z
// sits below chamber_floor_z) there is no chamber wall behind it at all
// (the chamber doesn't extend that low) -- a genuine unclosed hole, not a
// designed opening. Closes ONLY that Z-range; Z>=chamber_floor_z stays
// untouched/open, matching window_hole() exactly (DO NOT TOUCH).
module firebox_near_wall_closure() {
    translate([firebox_x0 - e, firebox_y0 + wall_t, firebox_z0 - e])
        cube([wall_t + 2*e, firebox_size - 2*wall_t, (chamber_floor_z - firebox_z0) + e]);
}

// firebox_upper_wall_seal_2d() — v11 TASK 1, NEW. The REAL open region
// firebox_near_wall_closure() above never covers: firebox_square_2d()
// minus fixed_side_solid_2d(), restricted to h>=0 (chamber_floor_z and
// above) only, via a local half-space mask (same big-margin-box style
// room_half_space() already uses elsewhere in this file, just 2D). Below
// h=0, fixed_side_solid_2d() has zero area by construction (every
// true_octagon_profile() point has h>=0), so without this clip the
// difference() would wrongly include the ENTIRE h<0 firebox square --
// the region firebox_near_wall_closure() already handles. Built from the
// real firebox_square_2d()/fixed_side_solid_2d() modules (both untouched,
// per DO NOT TOUCH) -- not hardcoded triangle coordinates -- so this
// stays correct if chamfer/firebox_size ever change. Independently
// confirmed (see file header) to equal exactly the two triangular gaps
// Janis flagged: 5218.84mm² each, mirror-symmetric.
module firebox_upper_wall_seal_2d() {
    intersection() {
        difference() {
            firebox_square_2d();
            offset(delta = -e) fixed_side_solid_2d();   // erode by e so the seal panel
                                                          // OVERLAPS real wall material by e,
                                                          // instead of exactly abutting its
                                                          // surface -- same coplanar-face-avoidance
                                                          // purpose as every other e-epsilon in
                                                          // this file, applied here to the 2D
                                                          // cross-section itself (found via a real
                                                          // CGAL non-manifold check: an exact-
                                                          // abutment version left the seal panel's
                                                          // inner edge coincident with
                                                          // chamber_outer_tube()'s own outer wall
                                                          // surface -- Simple:no, Volumes:3 instead
                                                          // of 2 -- this erosion fixes it, Simple:yes)
        }
        translate([-4000, -4000]) square([4000, 8000]);   // h>=0 half-space (2D-x <= 0)
    }
}
// firebox_upper_wall_seal() — v11 TASK 1. Extrudes the 2D gap shape above
// by wall_t at the near-wall X position (firebox_x0), same
// translate+rotate([0,90,0])+linear_extrude pattern and same e-overshoot
// convention firebox_passage()/firebox_near_wall_closure() already use,
// so it unions/differences cleanly against the rest of the assembly.
module firebox_upper_wall_seal() {
    translate([firebox_x0 - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t + 2*e, convexity = 4)
            firebox_upper_wall_seal_2d();
}

FIREBOX_GRATE_Z = firebox_z0 + 150;
module fire_grate() {
    for (yp = [firebox_y0 + 40 : 60 : firebox_y1 - 40])
        translate([firebox_x0 + wall_t, yp, FIREBOX_GRATE_Z]) rotate([0, 90, 0])
            cylinder(d = 12, h = firebox_size - 2*wall_t);
}

ASH_TRAY_H = 80;
ASH_TRAY_L = firebox_size - 2*wall_t - 40;   // 411
ASH_TRAY_W = firebox_size - 2*wall_t - 20;   // 431
ASH_TRAY_X_IN = firebox_x0 + wall_t + 10;    // 928 -- tucked deep, near chamber side
ASH_TRAY_SLIDE_MAX = 350;
module ash_tray(ash_tray_out_pct = 0) {
    slide = ash_tray_out_pct * ASH_TRAY_SLIDE_MAX;
    translate([ASH_TRAY_X_IN + slide, firebox_y0 + wall_t + 10, firebox_z0 + wall_t])
        difference() {
            cube([ASH_TRAY_L, ASH_TRAY_W, ASH_TRAY_H]);
            translate([wall_t, wall_t, wall_t]) cube([ASH_TRAY_L - 2*wall_t, ASH_TRAY_W - 2*wall_t, ASH_TRAY_H]);
        }
}

JOGGLE = 3;
HINGE_GAP = 0.5;
module firebox_door(firebox_door_open_deg = 0) {
    translate([firebox_x1, firebox_y0 - HINGE_GAP, firebox_z0]) rotate([0, 0, -firebox_door_open_deg]) {
        difference() {
            union() {
                cube([wall_t, firebox_size, firebox_size]);
                translate([wall_t, JOGGLE, JOGGLE]) cube([JOGGLE, firebox_size - 2*JOGGLE, firebox_size - 2*JOGGLE]);
            }
            translate([-e, firebox_size*0.5 - intake_w/2, firebox_size*0.15]) cube([wall_t + JOGGLE + 2*e, intake_w, intake_h]);
        }
    }
}
module firebox(firebox_door_open_deg = 0, ash_tray_out_pct = 0) {
    firebox_shell();
    firebox_near_wall_closure();
    firebox_upper_wall_seal();   // v11 — closes the two "triangle leak" gaps
    fire_grate();
    ash_tray(ash_tray_out_pct);
    firebox_door(firebox_door_open_deg);
}

// ───────────────────────────────
// Grill grate + Floor drains.
// v5 Finding 2: grate Y-range FIXED (was UNCHANGED-from-v1, now a real
// defect fix) — old range assumed a constant-width interior; the chamber
// actually narrows near the floor via both bottom chamfers. CONFIRMED
// collision via CGAL against the fixed shell (36 facets, X=[60,855]
// Y=[50,560] Z=[690,700]) — see file header. Floor drains UNCHANGED.
// ───────────────────────────────
GRATE_MARGIN = 60;
GRATE_GAP = 8;
grate_usable_l = chamber_L - 2*GRATE_MARGIN;
grate_seg_l = (grate_usable_l - 2*GRATE_GAP) / 3;
// GRATE_LOCAL_H: grate's own bottom height above chamber_floor_z (the
// binding constraint across its Z band — see Y_left/Y_right below, both
// most restrictive at the LOWEST point of the grate's height range).
GRATE_LOCAL_H = (DATUM_GRATE_Z - 10) - chamber_floor_z;   // 140 (v6, was 90 -- GRATE_Z moved 700->750)
GRATE_Y_SAFETY = wall_t + 10;                              // wall inset + same safety margin GRATE_MARGIN uses on X
GRATE_Y0 = (chamfer - GRATE_LOCAL_H) + GRATE_Y_SAFETY;                 // real left chamfer boundary at the grate's own bottom height, + safety
GRATE_Y1 = (chamber_W - chamfer + GRATE_LOCAL_H) - GRATE_Y_SAFETY;     // real right chamfer boundary at the grate's own bottom height, - safety
module grill_grate() {
    for (i = [0:2])
        translate([DATUM_X_FRONT + GRATE_MARGIN + i*(grate_seg_l + GRATE_GAP), GRATE_Y0, DATUM_GRATE_Z - 10])
            cube([grate_seg_l, GRATE_Y1 - GRATE_Y0, 10]);
}
module floor_drains() {
    for (xp = [DATUM_X_FRONT + chamber_L/3, DATUM_X_FRONT + chamber_L*2/3])
        translate([xp, DATUM_Y_CENTER, chamber_floor_z - 30])
            cylinder(d = 25, h = 30 + wall_t + e);
}

// ───────────────────────────────
// DEBUG TOGGLES — module isolation, per rules-codes.md Rule M-4.
// v2: show_chimney/show_drop_tube REMOVED (modules gone), show_exhaust_room
// and show_chimney_pipe ADDED. show_lid_hardware defaults FALSE this pass
// (stale positions, see module header above).
// ───────────────────────────────
show_chamber_shell  = true;
show_lid             = true;
show_lid_hardware    = false;   // v2: DISABLED, stale v1 positions -- TODO reposition, follow-up prompt
show_firebox         = true;
show_exhaust_room    = true;
show_chimney_pipe    = true;
show_grate            = true;
show_drains           = true;

lid_open_deg           = 0;    // 0=closed .. max (confirmed via CGAL sweep, see cc_chat_log.md)
firebox_door_open_deg  = 0;    // 0=closed .. 110=open (unchanged from v1)
ash_tray_out_pct       = 0;    // 0=in .. 1=fully out

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation Testing
// (rules-codes.md). v4: color()/opacity applied per this project's own
// existing rules-codes.md convention ("Color and Opacity Rules" + "COLOR
// CODING STANDARD" — outer shell 0.75 opacity, structural parts opaque
// and visually distinct) — NOT applied anywhere in this file before v4.
// Applied at the ASSEMBLY call site (not baked into each module) so
// isolation-toggle debug renders aren't tinted oddly and each module's
// own construction stays untouched.
// ───────────────────────────────
if (show_chamber_shell) color("#C8C8C8", 0.75) chamber_shell();
if (show_lid) color("#C8C8C8", 0.75) lid(lid_open_deg);
if (show_lid_hardware) color("#C8C8C8", 0.75) lid_hardware(lid_open_deg);
if (show_firebox) color("#C8C8C8", 0.75) firebox(firebox_door_open_deg, ash_tray_out_pct);
if (show_exhaust_room) color("#C8C8C8", 0.75) exhaust_room();
if (show_chimney_pipe) color("#C8C8C8", 0.75) chimney_pipe();
if (show_grate) color("#CCCCCC", 1.0) grill_grate();
if (show_drains) color("#AAAAAA", 1.0) floor_drains();
