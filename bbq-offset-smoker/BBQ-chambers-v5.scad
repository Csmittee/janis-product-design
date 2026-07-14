// BBQ Offset Smoker — Chambers
// Version: v5
// Date: 2026-07-14
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
GRATE_Z          = 700;                  // MASTER CONTROL VALUE — world Z, not derived
grate_clearance  = 100;
wall_t           = 3;
chamber_L        = 915;                  // length, along X
chamber_W        = 610;                  // width, along Y
chamber_H        = 610;                  // full octagon cross-section height, floor to ridge
chamfer          = 150;                  // 45-degree chamfer (equal rise/run), TOP and BOTTOM (v2)
firebox_size     = 457;
firebox_drop     = 200;                  // ASSUMPTION — OPEN FLAG, still not resolved (DO NOT TOUCH)
PASSAGE_INSET    = 10;                   // v5 Finding 3 — offset inward from the cut profile, per Janis's explicit spec
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

LID_X0           = 10;                   // v2 TASK 3 — "full width -10mm each side"
LID_X1           = chamber_L - 10;       // 905
LID_LENGTH       = LID_X1 - LID_X0;      // 895

// ───────────────────────────────
// DATUMS — SKELETON block (per SKILL_product_design_skeleton.md)
// PRIMARY:   DATUM_GRATE_Z    (horizontal plane) — locks Z, "grate-down" chain
// SECONDARY: DATUM_X_REAR     (chamber's rear/firebox wall, X plane) — locks X
// TERTIARY:  DATUM_Y_CENTER   (chamber's lateral centerline, Y plane) — locks Y
// ───────────────────────────────
DATUM_GRATE_Z    = GRATE_Z;                                   // 700
chamber_floor_z  = DATUM_GRATE_Z - grate_clearance;            // 600 -- Parent: DATUM_GRATE_Z, offset dZ=-100
DATUM_X_FRONT    = 0;                                          // Parent: MASTER ORIGIN
DATUM_X_REAR     = DATUM_X_FRONT + chamber_L;                  // 915 -- Parent: DATUM_X_FRONT, offset dX=+chamber_L
DATUM_Y_LEFT     = 0;                                          // Parent: MASTER ORIGIN
DATUM_Y_CENTER   = DATUM_Y_LEFT + chamber_W/2;                  // 305 -- Parent: DATUM_Y_LEFT
// trough_h REDEFINED v2: chamfer now cuts BOTH top and bottom (was top only
// in v1) -- real dimensional change, 460 -> 310. Every downstream value
// using it (ROOM_BASE_Z etc) recomputes automatically, in dependency order.
trough_h         = chamber_H - 2*chamfer;                       // 310 -- vertical wall height (both walls, symmetric)
DATUM_Z_RIDGE    = chamber_floor_z + chamber_H;                  // 1210 -- outer ridge surface AND lid hinge Z (v2, dual meaning)

firebox_floor_z  = chamber_floor_z - firebox_drop;              // 400 -- Parent: chamber_floor_z, offset dZ=-firebox_drop

// Exhaust room datums — Parent: chamber_floor_z + trough_h
ROOM_BASE_Z      = chamber_floor_z + (trough_h - ROOM_H)/2;     // 705 (v3, was 655) -- centers ROOM_H within the vertical-wall zone
ROOM_TOP_Z       = ROOM_BASE_Z + ROOM_H;                         // 805 (v3, was 855)

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
// Parent: chamber_floor_z (local h=0 == world chamber_floor_z).
module fixed_shell_profile() {
    polygon(points=[
        hex_pt(0, chamber_W - chamfer),           // 1: floor, right end of flat bottom (was left, v2)
        hex_pt(0, chamfer),                       // 2: floor, left end of flat bottom (was right, v2)
        hex_pt(chamfer, 0),                        // 3: PARTING START — lowest apex, now on the Y=0 side (diagram's point A, mirrored)
        hex_pt(chamber_H, chamber_W/2),            // 4: PARTING END — ridge midpoint (unchanged, self-mirrors)
        hex_pt(chamber_H, chamber_W - chamfer),     // 5: ridge, right end (was left, v2)
        hex_pt(chamber_H - chamfer, chamber_W),     // 6: right wall top (was left, v2)
        hex_pt(chamfer, chamber_W),                  // 7: right wall bottom (was left, v2)
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
// needed -- the profile itself already excludes the lid's territory for
// its whole length.
// Parent: DATUM_X_FRONT / chamber_floor_z / DATUM_Y_LEFT.
// ───────────────────────────────
module chamber_outer_tube() {
    translate([0, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = chamber_L) fixed_shell_profile();
}
module chamber_inner_cavity() {
    // v2 CLOSURE FIX: inset to [wall_t, chamber_L-wall_t] (real solid end
    // caps), NOT overshoot past both ends (v1's bug -- paper-thin rim
    // only). Root cause + fix per TASK 1.
    translate([wall_t, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = chamber_L - 2*wall_t, convexity = 4)
            offset(delta = -wall_t) fixed_shell_profile();
}
// firebox_square_2d() — the firebox's own square cross-section, expressed
// in the SAME hex_pt(h,w) 2D space as fixed_shell_profile() (2D-x=-h,
// 2D-y=Y=w), so the two can be intersect()-ed directly. h measured local
// to chamber_floor_z (matches fixed_shell_profile()'s own h=0 origin).
module firebox_square_2d() {
    translate([chamber_floor_z - firebox_z1, firebox_y0])
        square([firebox_size, firebox_size]);
}
// firebox_passage_profile() — v5 Finding 3, REPLACES window_hole() (v1, a
// fixed 254x119mm rectangle). Per Janis's explicit spec: "follow the
// intersec of hexagon profile but offset from edge -10mm around the cut
// profile". A REAL 2D boolean intersection (not manual per-height math) --
// automatically follows both bottom chamfers AND the internal parting
// seam correctly across the firebox's full height range, since
// intersection() clips to fixed_shell_profile()'s own real boundary
// wherever the firebox square would otherwise stick out past it.
module firebox_passage_profile() {
    offset(delta = -PASSAGE_INSET)
        intersection() {
            fixed_shell_profile();
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
// lid_territory_end_caps() — v5 Finding 1. Fills the lid's own cross-
// section territory at the 2 short margins where the lid stops short of
// the shell's true ends (X=[DATUM_X_FRONT,LID_X0] and
// X=[LID_X1,DATUM_X_REAR]) -- CONFIRMED real unclosed gap via CGAL (empty
// probe result against chamber_shell() at both margins, see file header).
// Solid fill (short fixed end plugs, not a hollow moving lid), using
// lid_profile() itself so the plug's own exterior traces the real octagon
// edges exactly, matching the closed lid's own outer surface where they
// meet at X=LID_X0/LID_X1.
module lid_territory_end_caps() {
    if (LID_X0 > DATUM_X_FRONT)
        translate([DATUM_X_FRONT, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = LID_X0 - DATUM_X_FRONT, convexity = 4) lid_profile();
    if (DATUM_X_REAR > LID_X1)
        translate([LID_X1, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = DATUM_X_REAR - LID_X1, convexity = 4) lid_profile();
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
    difference() {
        union() {
            chamber_outer_tube();
            lid_territory_end_caps();   // v5 Finding 1 — closes the confirmed end-margin gaps
        }
        chamber_inner_cavity();
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
GRATE_LOCAL_H = (DATUM_GRATE_Z - 10) - chamber_floor_z;   // 90
GRATE_Y_SAFETY = wall_t + 10;                              // wall inset + same safety margin GRATE_MARGIN uses on X
GRATE_Y0 = (chamfer - GRATE_LOCAL_H) + GRATE_Y_SAFETY;                 // real left chamfer boundary at h=90, + safety
GRATE_Y1 = (chamber_W - chamfer + GRATE_LOCAL_H) - GRATE_Y_SAFETY;     // real right chamfer boundary at h=90, - safety
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
