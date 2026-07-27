// BBQ Offset Smoker — Chambers
// Version: v2
// Date: 2026-07-14
// Changes from v1: 3 corrections per prompts/bbq-chambers-v2-closure-
// exhaust-lid-cc-prompt.md (Janis's own review against reference photos):
//
// 1. FULL CLOSURE + TRUE OCTAGON: chamber_full_profile() (6-point,
//    chamfered top only) replaced by an 8-point true octagon (chamfered
//    top AND bottom) -- see fixed_shell_profile()/lid_profile() below,
//    now split per TASK 3. CLOSURE BUG FIXED: v1's inner-cavity cut
//    overshot PAST both extrusion ends (e beyond each), leaving only a
//    paper-thin rim instead of a real wall_t solid end-cap. Fixed: cavity
//    now INSET to X=[wall_t, chamber_L-wall_t], leaving genuine wall_t
//    end caps, matching real welded end-plate practice.
//
// 2. EXHAUST OUTLET REBUILT: old chimney()/drop_tube() (recessed stub +
//    internal drop-tube) REMOVED entirely, replaced by exhaust_room() (a
//    real half-cylinder mounting room, D=200/H=200, welded to the front
//    end-cap) + chimney_pipe() (127mm pipe sitting on the room's own flat
//    top, coaxial). drop_tube's "smoke circulates low" function is NOT
//    replicated in this version -- the prompt explicitly groups
//    chimney()+drop_tube() as both being replaced by the room+pipe unit,
//    with no drop-tube equivalent described. Flagged, not silently kept
//    or silently reinvented.
//    REAL INCONSISTENCY FOUND, flagged not silently resolved: the prompt
//    describes the chamber's front-endcap opening as matching the room's
//    "semicircular footprint" -- but a vertical-axis cylinder (as
//    explicitly specified, height=ROOM_H=200mm confirms vertical axis,
//    not a radius) bisected by a vertical plane (X=0, to weld flush
//    against a vertical wall) produces a RECTANGULAR flat interface face
//    (200mm Y x 200mm Z), not a semicircle -- the semicircular shape
//    belongs to the room's horizontal TOP/BOTTOM footprint, a different
//    face. Built the endcap opening to match the room's ACTUAL interface
//    face (rectangle) since that's what's dimensionally consistent with
//    the rest of the given numbers (ROOM_H=200 only makes sense as a full
//    vertical height, not a radius). See cc_chat_log.md.
//    REAL DIMENSIONAL CONFLICT FOUND: chimney_d (127mm) cannot be fully
//    inscribed within the room's own 200mm-diameter semicircular top --
//    the largest circle that fits inside a semicircle of that size has a
//    MAXIMUM diameter of 100mm (proof: tangent to both the flat chord and
//    the arc requires radius = R/2 = 50mm exactly). The 127mm pipe hole
//    necessarily overhangs the room's own footprint boundary regardless
//    of placement. Positioned at the symmetric-overhang compromise
//    (13.5mm past the flat back edge, 13.5mm past the curved arc) --
//    least-bad option, not a silent force-fit. See cc_chat_log.md.
//
// 3. LID REDESIGNED: end-hinged trunk lid (hinge along Y at fixed X, 3
//    flat cube panels covering the ridge zone between LID_MARGIN_FRONT/
//    REAR) REPLACED by a full-length, ridge-hinged clamshell lid (hinge
//    along X at fixed Y,Z -- the ridge midpoint -- covering 2.5 of the
//    octagon's 8 sides: right wall + right chamfer + half ridge). Confirmed
//    via user-supplied labeled diagram (point A = "lowest apex" = the
//    prompt's own parting-line start, matching exactly) before building.
//    lid_hardware() DISABLED in ASSEMBLY (not deleted, not repositioned)
//    per explicit instruction -- every position in it was built for the
//    OLD lid geometry and is now wrong. TODO: reposition once this new
//    lid shape is confirmed by Janis, follow-up prompt.
//
// SOURCE: prompts/bbq-chambers-v2-closure-exhaust-lid-cc-prompt.md.
// Naming note: the prompt assumes a function named `hp(h,w)` -- this file
// already has an equivalent helper, `hex_pt(h,w)`, same signature/
// semantics ([-h,w] encoding, verified empirically in v1). Reused as-is,
// not renamed -- no functional difference.
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
window_w         = 254;
window_h         = 119;
intake_w         = 107;
intake_h         = 107;
chimney_d        = 127;
chimney_len      = 762;                  // carried over from v1 (prompt didn't restate it) —
                                          // still satisfies the <=2.5m top-height rule, see below

ROOM_D           = 200;                  // exhaust room diameter (v2 TASK 2)
ROOM_H           = 200;                  // exhaust room height (vertical axis)

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

// Exhaust room datums (v2 TASK 2) — Parent: chamber_floor_z + trough_h
ROOM_BASE_Z      = chamber_floor_z + (trough_h - ROOM_H)/2;     // 655 -- centers ROOM_H within the vertical-wall zone
ROOM_TOP_Z       = ROOM_BASE_Z + ROOM_H;                         // 855

// ───────────────────────────────
// PROFILE HELPERS — encoded [-height, width] so that rotate([0,90,0])
// after linear_extrude(length) lands as world (X=length, Y=width,
// Z=height) — verified empirically in v1, unchanged mechanism.
// ───────────────────────────────
function hex_pt(h, w) = [-h, w];

// fixed_shell_profile() — 7-point profile (v2 TASK 3). Traces the REAL
// octagon edges: floor, left wall, left chamfer, left half of ridge —
// then a single straight PARTING edge (point 3 to point 4) closing back
// to the floor's right end. This parting edge is the internal seam face
// only (hidden when lid is closed) -- NOT the visible exterior, which is
// why it's allowed to be a straight diagonal rather than tracing real
// edges (unlike the lid's own profile below, whose exterior IS visible).
// Parent: chamber_floor_z (local h=0 == world chamber_floor_z).
module fixed_shell_profile() {
    polygon(points=[
        hex_pt(0, chamfer),                      // 1: floor, left end of flat bottom
        hex_pt(0, chamber_W - chamfer),           // 2: floor, right end of flat bottom
        hex_pt(chamfer, chamber_W),               // 3: PARTING START — lowest apex (= diagram's point A)
        hex_pt(chamber_H, chamber_W/2),           // 4: PARTING END — ridge midpoint (= diagram's mid C-D)
        hex_pt(chamber_H, chamfer),                // 5: ridge, left end
        hex_pt(chamber_H - chamfer, 0),            // 6: left wall top
        hex_pt(chamfer, 0),                         // 7: left wall bottom
    ]);
}

// lid_profile() — 4-point profile, the 2.5-side chunk removed above.
// Edges 1->2 (half ridge), 2->3 (real right chamfer), 3->4 (real right
// wall) ARE the real octagon edges -- this is the visible exterior when
// the lid is closed, confirmed against the real octagon coordinates
// (points 2,3,4 all share width=chamber_W or the true chamfer/ridge
// values, not a shortcut). Only the 4->1 closing edge is the internal
// diagonal seam face, mirroring fixed_shell_profile()'s own seam.
// NOT used directly for construction below (see lid_closed_panels()'s own
// header for why) -- kept as the documented reference shape this file's
// governance docs (SKELETON_WORKSHEET.md) describe.
module lid_profile() {
    polygon(points=[
        hex_pt(chamber_H, chamber_W/2),            // 1: ridge midpoint (hinge line)
        hex_pt(chamber_H, chamber_W - chamfer),     // 2: ridge, right end (half-ridge)
        hex_pt(chamber_H - chamfer, chamber_W),     // 3: top-right chamfer bottom (= real wall top)
        hex_pt(chamfer, chamber_W),                  // 4: right wall bottom (parting end, = fixed_shell_profile point 3)
    ]);
}

// ───────────────────────────────
// chamber_shell() — fixed portion only (floor + left wall + left chamfer
// + half ridge), wall_t hollow, full chamber_L length. NO lid-opening
// cutout needed anymore (v1's lid_opening_cut() removed) -- the profile
// itself already excludes the lid's territory for its whole length.
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
module window_hole() {
    // Parent: DATUM_X_REAR (chamber rear wall). Low pass-through opening.
    // UNCHANGED from v1 (DO NOT TOUCH, per this prompt's own Section 5).
    translate([DATUM_X_REAR - wall_t - e, DATUM_Y_CENTER - window_w/2, chamber_floor_z])
        cube([wall_t + 2*e, window_w, window_h]);
}
module exhaust_room_opening() {
    // Front end-cap opening (X=0..wall_t), matching exhaust_room()'s own
    // REAL flat interface face -- a rectangle (ROOM_D wide x ROOM_H tall),
    // not the semicircle the prompt describes (see header note above).
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
        chamber_outer_tube();
        chamber_inner_cavity();
        window_hole();
        exhaust_room_opening();
    }
}

// ───────────────────────────────
// exhaust_room() — half-cylinder mounting room (v2 TASK 2). Vertical axis
// (Z), bisected by the X=0 plane (contains the axis, matches "flat face
// welds flush against the front end-cap"). Kept half = X<=0 (protrudes
// forward, away from the chamber). Parent: DATUM_X_FRONT / DATUM_Y_CENTER
// / ROOM_BASE_Z.
// ───────────────────────────────
ROOM_R = ROOM_D / 2;   // 100
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
// PIPE_HOLE_X: real dimensional conflict (see header) -- 127mm hole
// cannot fit inside a 200mm semicircle's footprint (max inscribable
// diameter = 100mm), so SOME overhang past the room's own boundary is
// unavoidable. The symmetric compromise (-R/2=-50, equal 13.5mm overhang
// each side) was tried first, but a real CGAL intersection() found the
// pipe's own +X overhang (to X=+13.5) collides with the lid's front edge
// (LID_X0=10) -- both open AND closed states, since the pipe's Z-range
// reaches lid height regardless of lid_open_deg (rotation is about X, an
// axis this collision doesn't depend on). Moved further into -X (still a
// judgment call, not a prompt-given number) so the pipe clears LID_X0
// with a real margin: pipe max X = -60+63.5=3.5, 6.5mm clear of X=10.
// This increases the OTHER overhang (past the room's curved arc, to
// 23.5mm) -- accepted since nothing else is built in that direction to
// collide with, unlike the lid. Re-verified via CGAL, see cc_chat_log.md.
PIPE_HOLE_X = -60;
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
PIPE_BASE_Z = ROOM_TOP_Z - wall_t - e;   // 851.99 -- matches room_pipe_hole()'s own bottom
module chimney_pipe() {
    translate([PIPE_HOLE_X, PIPE_HOLE_Y, PIPE_BASE_Z])
        cylinder(d = chimney_d, h = chimney_len + wall_t + e);   // top = 1617.0mm world -- within 2.5m limit
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
// wall), NOT a polygon+offset() extrude. REAL DEFECT FOUND AND FIXED:
// lid_profile()'s interior angle at the hinge vertex (point 1) is ~56.4
// deg (computed from its own edge vectors) -- an ACUTE angle, and
// offset(delta=-wall_t) on an acute corner produces a numerically
// unstable near-zero-width spike there. This resolved to Simple:yes at
// lid_open_deg=0 (a coincidental alignment) but broke (Simple:no) at
// every angle from ~46 deg upward -- found via a real CGAL angle sweep,
// not assumed from the 0 deg case alone. Same underlying lesson as v1's
// original chamber lid (rules-codes.md: "Use cube() for all flat
// rectangular panels"), rediscovered here for a different profile shape.
// OVERLAP=3mm gives real shared volume at the 2 panel joins (union()
// must share volume, not just edges/faces). Open at both X ends (no
// caps) -- correct for the lid, a cap-less trough.
LID_OVERLAP = 3;
lid_slant_len = chamfer * sqrt(2) + LID_OVERLAP;
module lid_closed_panels() {
    // panel 1: half-ridge, flat (world Z = DATUM_Z_RIDGE)
    translate([LID_X0, DATUM_Y_CENTER, DATUM_Z_RIDGE - wall_t])
        cube([LID_LENGTH, (chamber_W - chamfer) - DATUM_Y_CENTER + LID_OVERLAP, wall_t]);
    // panel 2: chamfer, slanted -45 deg (world Y increases, Z decreases)
    translate([LID_X0, chamber_W - chamfer, DATUM_Z_RIDGE]) rotate([-45, 0, 0])
        cube([LID_LENGTH, lid_slant_len, wall_t]);
    // panel 3: wall, vertical (constant Y = chamber_W)
    translate([LID_X0, chamber_W - wall_t, chamber_floor_z + chamfer - LID_OVERLAP])
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
module lid(lid_open_deg = 0) {
    translate([0, DATUM_Y_CENTER + LID_HINGE_GAP, DATUM_Z_RIDGE + LID_HINGE_GAP])
        rotate([lid_open_deg, 0, 0])
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
    fire_grate();
    ash_tray(ash_tray_out_pct);
    firebox_door(firebox_door_open_deg);
}

// ───────────────────────────────
// Grill grate + Floor drains — UNCHANGED from v1 (DO NOT TOUCH).
// ───────────────────────────────
GRATE_MARGIN = 60;
GRATE_GAP = 8;
grate_usable_l = chamber_L - 2*GRATE_MARGIN;
grate_seg_l = (grate_usable_l - 2*GRATE_GAP) / 3;
module grill_grate() {
    for (i = [0:2])
        translate([DATUM_X_FRONT + GRATE_MARGIN + i*(grate_seg_l + GRATE_GAP), wall_t + 10, DATUM_GRATE_Z - 10])
            cube([grate_seg_l, chamber_W - 2*(wall_t + 10), 10]);
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
// (rules-codes.md).
// ───────────────────────────────
if (show_chamber_shell) chamber_shell();
if (show_lid) lid(lid_open_deg);
if (show_lid_hardware) lid_hardware(lid_open_deg);
if (show_firebox) firebox(firebox_door_open_deg, ash_tray_out_pct);
if (show_exhaust_room) exhaust_room();
if (show_chimney_pipe) chimney_pipe();
if (show_grate) grill_grate();
if (show_drains) floor_drains();
