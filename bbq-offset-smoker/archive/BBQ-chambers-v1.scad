// BBQ Offset Smoker — Chambers
// Version: v1
// Date: 2026-07-13
// Changes from: N/A (first version, new product line)
//
// SOURCE: prompts/bbq-offset-smoker-v1-init-cc-prompt.md, TASK 2.
//
// COORDINATE CORRECTION (stated explicitly, per cc_rules.md COORDINATE
// SYSTEM section + rules-dimensions.md "COORDINATE SYSTEM STANDARD — ALL
// MODELS"): the source prompt's own module sketches used Y as the
// chamber's long/length axis ("chamber_L along Y"). The project's locked,
// all-models coordinate standard is X = longitudinal (long axis), Y =
// lateral (width), Z = vertical — confirmed still binding for new product
// lines (rules-dimensions.md line 335: "this global coordinate convention
// is still the outer World frame"). This file uses chamber_L along X,
// chamber_W along Y, matching that standard — a deliberate correction to
// the prompt's own snippet per WORKFLOW_SKILL's "cc verifies from live
// repo — not bound by Claude Web's suggested implementation."
//
// JUDGMENT CALLS (flagged, not silently resolved — see cc_chat_log.md):
// 1. The prompt's chamber_profile()/chamber_shell() describe ONE full
//    chamfered-hex tube, while a separate "Lid assembly" module is
//    described as hinged along the rear top edge. To reconcile a single
//    fixed tube with a real hinged lid, this file splits the FIXED shell
//    (chamber_shell()) as the full hex tube MINUS a lid-opening cutout in
//    its ridge/chamfer zone, and lid() as a separate hinged cap filling
//    that cutout. New params LID_MARGIN_FRONT/LID_MARGIN_REAR (below) set
//    how much fixed ridge material remains at each end — not specified in
//    the prompt, chosen so the chimney (front, ~X=200) mounts on solid
//    FIXED shell material, independent of lid rotation.
// 2. Chimney mounted on the FIXED trough/ridge material (not the lid) so
//    opening the lid never disturbs the flue — "front shoulder, on the
//    chamfer" read as the fixed shell's own front margin, not the lid.
// 3. Lid built from 3 flat cube() panels (2 slants + 1 ridge-top), not a
//    polygon offset() shell — matches rules-codes.md's explicit
//    preference ("Use cube() for all flat rectangular panels") and avoids
//    offset()-direction ambiguity on an open-bottom shell.
// 4. firebox_drop = 200mm — OPEN FLAG per the prompt itself, Claude Web's
//    assumption, not yet Janis's explicit number. Left as-is, flagged
//    again here.
//
// SKELETON — single source of truth. Every module below declares its
// Parent explicitly (a DATUM_* below, or another part's local origin).
// No part may reference a Cousin or a Stranger. See
// .claude/SKILL_product_design_skeleton.md.
// Local origin for this file: (0,0,0) at floor level, front-left — matches
// MASTER ORIGIN in SKELETON_WORKSHEET.md.

$fn = 64;
e   = 0.01;   // epsilon, coplanar-face offset per rules-codes.md

// ───────────────────────────────
// PARAMETERS — all mm, locked this session (source: prompt TASK 2)
// ───────────────────────────────
GRATE_Z          = 700;                  // MASTER CONTROL VALUE — world Z, not derived
grate_clearance  = 100;
wall_t           = 3;
chamber_L        = 915;                  // length, along X (corrected from prompt's Y)
chamber_W        = 610;                  // width, along Y
chamber_H        = 610;                  // full hex cross-section height, floor to ridge
chamfer          = 150;                  // 45-degree chamfer (equal rise/run)
firebox_size     = 457;
firebox_drop     = 200;                  // ASSUMPTION — OPEN FLAG, confirm w/ Janis before merge
window_w         = 254;
window_h         = 119;
intake_w         = 107;
intake_h         = 107;
chimney_d        = 127;
chimney_len      = 762;                  // built length, NOT the raw volume formula
drop_tube_d      = chimney_d - 20;       // 107
CHIMNEY_RECESS   = 40;                   // base recessed into shell for clean weld joint

// Lid opening extent — JUDGMENT CALL 1 above, not in source prompt
LID_MARGIN_FRONT = 300;                  // fixed ridge material kept at front (chimney mount zone)
LID_MARGIN_REAR  = 60;                   // fixed ridge material kept at rear (structural rim)

// ───────────────────────────────
// DATUMS — SKELETON block (per SKILL_product_design_skeleton.md)
// PRIMARY:   DATUM_GRATE_Z    (horizontal plane) — locks Z, "grate-down" chain
// SECONDARY: DATUM_X_REAR     (chamber's rear/firebox wall, X plane) — locks X
// TERTIARY:  DATUM_Y_CENTER   (chamber's lateral centerline, Y plane) — locks Y
// ───────────────────────────────
DATUM_GRATE_Z    = GRATE_Z;                                  // 700
chamber_floor_z  = DATUM_GRATE_Z - grate_clearance;           // 600 -- Parent: DATUM_GRATE_Z, offset dZ=-100
DATUM_X_FRONT    = 0;                                         // Parent: MASTER ORIGIN
DATUM_X_REAR     = DATUM_X_FRONT + chamber_L;                 // 915 -- Parent: DATUM_X_FRONT, offset dX=+chamber_L
DATUM_Y_LEFT     = 0;                                         // Parent: MASTER ORIGIN
DATUM_Y_CENTER   = DATUM_Y_LEFT + chamber_W/2;                 // 305 -- Parent: DATUM_Y_LEFT
trough_h         = chamber_H - chamfer;                       // 460 -- vertical wall height, floor to lid seam
DATUM_Z_SEAM     = chamber_floor_z + trough_h;                 // 1060 -- trough top rim / lid seam
DATUM_Z_RIDGE    = chamber_floor_z + chamber_H;                 // 1210 -- outer ridge surface, world Z

firebox_floor_z  = chamber_floor_z - firebox_drop;             // 400 -- Parent: chamber_floor_z, offset dZ=-firebox_drop
lid_x0           = DATUM_X_FRONT + LID_MARGIN_FRONT;           // 300 -- Parent: DATUM_X_FRONT
lid_x1           = DATUM_X_REAR - LID_MARGIN_REAR;             // 855 -- Parent: DATUM_X_REAR
lid_len          = lid_x1 - lid_x0;                            // 555

// ───────────────────────────────
// PROFILE HELPER — full chamfered-hex outline, encoded [-height, width] so
// that rotate([0,90,0]) after linear_extrude(chamber_L) lands as world
// (X=length, Y=width, Z=height) — verified empirically (test extrusion,
// bounding box confirmed X:[0,L] Y:[0,W] Z:[0,H]) before use in this file.
// ───────────────────────────────
function hex_pt(h, w) = [-h, w];
module chamber_full_profile() {
    // Parent: DATUM chamber_floor_z (local h=0 == world chamber_floor_z)
    polygon(points=[
        hex_pt(0, 0),
        hex_pt(0, chamber_W),
        hex_pt(trough_h, chamber_W),
        hex_pt(chamber_H, chamber_W - chamfer),
        hex_pt(chamber_H, chamfer),
        hex_pt(trough_h, 0),
    ]);
}

// ───────────────────────────────
// chamber_shell() — fixed hex tube, floor to ridge, wall_t hollow.
// Parent: DATUM_X_FRONT / chamber_floor_z / DATUM_Y_LEFT.
// Ridge/chamfer zone between lid_x0..lid_x1 is cut away for lid().
// Rear wall gets the pass-through window_cut (shared plane with firebox).
// ───────────────────────────────
module chamber_outer_tube() {
    translate([0, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = chamber_L) chamber_full_profile();
}
module chamber_inner_cavity() {
    // overshoot BOTH ends by e (not just the far end) so the cavity cut
    // never lands exactly flush/coplanar with the outer tube's own end
    // caps, per rules-codes.md coplanar-face epsilon rule.
    translate([-e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = chamber_L + 2*e, convexity = 4)
            offset(delta = -wall_t) chamber_full_profile();
}
module lid_opening_cut() {
    // overshoot cut per rules-codes.md "overshooting subtractors" +
    // HINGE_CLEARANCE past lid_x1: at open angles near 100 deg the lid's
    // own hinge-adjacent material swings back far enough to clip the
    // fixed rear-margin shell with zero clearance -- real CGAL
    // intersection() found this (see cc_chat_log.md), fixed by giving the
    // rotating lid a few mm of clearance from the fixed material it
    // pivots next to, same class as R-002's cylinder-near-flat-face rule.
    HINGE_CLEARANCE = 15;
    translate([lid_x0 - e, -e, DATUM_Z_SEAM - wall_t])
        cube([lid_len + HINGE_CLEARANCE + e, chamber_W + 2*e, chamber_H]);
}
module window_hole() {
    // Parent: DATUM_X_REAR (chamber rear wall). Low pass-through opening.
    translate([DATUM_X_REAR - wall_t - e, DATUM_Y_CENTER - window_w/2, chamber_floor_z])
        cube([wall_t + 2*e, window_w, window_h]);
}
module chamber_shell() {
    difference() {
        chamber_outer_tube();
        chamber_inner_cavity();
        lid_opening_cut();
        window_hole();
    }
}

// ───────────────────────────────
// lid() — hinged cap over the ridge/chamfer cutout, 3 flat cube() panels
// (2 slants + 1 ridge-top), per rules-codes.md "Use cube() for all flat
// rectangular panels." OVERLAP=3mm gives real shared volume at the 2
// corner joins (Rule: union() must share volume, not just edges/faces).
// Parent: DATUM_Z_RIDGE / lid_x1 (rear-top hinge line, along Y).
// Kinetic: lid_open_deg 0 (closed) .. ~100 (open) — verified BOTH states
// via real render (see cc_chat_log.md), per Kinetic Dual-View convention.
// ───────────────────────────────
LID_OVERLAP = 3;
slant_len   = chamfer * sqrt(2) + LID_OVERLAP;
module lid_closed_panels() {
    translate([lid_x0, 0, DATUM_Z_SEAM]) rotate([45, 0, 0])
        cube([lid_len, slant_len, wall_t]);
    translate([lid_x0, chamber_W, DATUM_Z_SEAM]) rotate([135, 0, 0])
        cube([lid_len, slant_len, wall_t]);
    translate([lid_x0, chamfer - LID_OVERLAP, DATUM_Z_RIDGE - wall_t])
        cube([lid_len, chamber_W - 2*chamfer + 2*LID_OVERLAP, wall_t]);
}
module lid(lid_open_deg = 0) {
    translate([lid_x1, 0, DATUM_Z_RIDGE])
        rotate([0, lid_open_deg, 0])
        translate([-lid_x1, 0, -DATUM_Z_RIDGE])
        lid_closed_panels();
}

// ───────────────────────────────
// Lid hardware — toggle-clamp latches (placeholder), lift handle rail on
// 2 standoff posts, dome thermometer port (placeholder), counterbalance
// lever + weight (rigid on the lid, rotates WITH it, not independently
// kinetic). All off-shelf/simple-detail per prompt's explicit allowance.
// Parent: lid()'s own hinge transform — these follow the lid when open.
// ───────────────────────────────
LEVER_ARM = 400;     // mm off hinge pivot, per this session's torque calc
COUNTERWEIGHT_KG = 10; // target ~85-90% balance, placeholder mass only
module lid_hardware(lid_open_deg = 0) {
    translate([lid_x1, 0, DATUM_Z_RIDGE]) rotate([0, lid_open_deg, 0]) translate([-lid_x1, 0, -DATUM_Z_RIDGE]) {
        // lift handle rail, full width, front edge of lid, 150mm standoff
        for (yp = [80, chamber_W - 80])
            translate([lid_x0 + 20, yp, DATUM_Z_RIDGE]) cylinder(d = 16, h = 150);
        translate([lid_x0 + 20, chamber_W/2, DATUM_Z_RIDGE + 150]) rotate([0, 90, 0])
            cylinder(d = 20, h = chamber_W - 160);
        // toggle-clamp latches x2, placeholder boxes at the front seam
        for (yp = [chamber_W*0.25, chamber_W*0.75])
            translate([lid_x0 - 10, yp - 15, DATUM_Z_SEAM - 20]) cube([30, 30, 40]);
        // dome thermometer port, placeholder
        translate([lid_x0 + lid_len*0.5, chamber_W/2, DATUM_Z_RIDGE]) sphere(d = 40);
    }
    // counterbalance lever + weight — rigid on hinge, extends past rear
    // (+X). LEVER_CLEARANCE lifts it above DATUM_Z_RIDGE: at Z=DATUM_Z_
    // RIDGE exactly it grazes straight through the fixed rear-margin
    // shell material (855-915 zone) at rest -- real CGAL intersection()
    // found this (see cc_chat_log.md), fixed with a standoff bracket.
    LEVER_CLEARANCE = 50;
    translate([lid_x1, chamber_W/2, DATUM_Z_RIDGE + LEVER_CLEARANCE]) rotate([0, lid_open_deg, 0]) {
        rotate([0, 90, 0]) cylinder(d = 20, h = LEVER_ARM);
        translate([LEVER_ARM, 0, 0]) rotate([0, 90, 0]) cylinder(d = 65, h = 60);
    }
}

// ───────────────────────────────
// firebox() — shelled box, 457mm cube, wall_t on 4 faces (both sides, top,
// bottom). BOTH ends are open: the face nearest the chamber (X=firebox_x0)
// welds directly onto the chamber's own rear wall (no double wall, per
// real fab practice, matches window_hole()'s cut); the outward face
// (X=firebox_x1) is open because the hinged door (firebox_door(), below)
// is the ONLY thing that covers it — a solid wall there would make the
// door pointless. (Real design error, found via CGAL: an earlier version
// gave this face its own wall_t skin in addition to the door, which
// silently collided with the sliding ash tray — fixed here, see
// cc_chat_log.md.)
// Parent: DATUM_X_REAR (near/open face) + firebox_floor_z.
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

// Fire grate — welded bars, mid-height for ash clearance below.
FIREBOX_GRATE_Z = firebox_z0 + 150;
module fire_grate() {
    for (yp = [firebox_y0 + 40 : 60 : firebox_y1 - 40])
        translate([firebox_x0 + wall_t, yp, FIREBOX_GRATE_Z]) rotate([0, 90, 0])
            cylinder(d = 12, h = firebox_size - 2*wall_t);
}

// Ash tray — slides out along +X, through the door opening at firebox_x1.
// ash_tray_out_pct=1 extends past the door face — only physically valid
// with the door open, same accepted door-dependency as VM-02's tray_out_pct
// (see cc_chat_log.md; not a bug, an unavoidable real constraint).
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

// Firebox door — hinged on the LEFT vertical edge of the far (outward) face.
// 3mm joggle-step joint per rules-bbq-fab.md: flange plate + inset step plate.
JOGGLE = 3;
// HINGE_GAP: the door's rotation axis sits exactly on firebox_shell()'s own
// corner edge by construction -- an exact zero-clearance tangent contact,
// which real CGAL union() (not intersection()) found to be non-manifold at
// every open angle, same failure class as R-002/Rule M-2 (undercut/
// tangency). intersection() reported empty (correctly -- no real volume
// overlap) but the UNION still failed; found via a full-assembly bisection,
// not the pairwise intersection probe alone (see cc_chat_log.md). Fixed by
// offsetting the hinge axis a hair outside the shell.
HINGE_GAP = 0.5;
module firebox_door(firebox_door_open_deg = 0) {
    // NEGATIVE Z-rotation: swings the door toward +X/away from the firebox
    // body (which occupies local X<0 from this hinge) -- verified via real
    // CGAL intersection() vs firebox_shell(), empty at 30/90/110 deg; the
    // naive positive-angle sign swept the door INTO the box (real, found
    // and fixed this session, see cc_chat_log.md).
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
// chimney() + drop_tube() — Parent: DATUM_X_FRONT + DATUM_Z_RIDGE (fixed
// shell material, front margin, independent of lid rotation — JUDGMENT
// CALL 2, see header). Base recessed CHIMNEY_RECESS into the ridge.
// Kinetic: chimney_open true (deployed, vertical) / false (folded flat
// along the ridge for transport) — verified both states via real render.
// drop_tube() is always fixed (chamber-internal, independent of chimney
// fold state) — runs from the chimney's base connection down to GRATE_Z
// so smoke circulates low across the food, per prompt.
// ───────────────────────────────
chimney_x = DATUM_X_FRONT + 200;   // ~X=200, "front shoulder"
chimney_y = DATUM_Y_CENTER;
chimney_base_z = DATUM_Z_RIDGE - CHIMNEY_RECESS;   // 1170
chimney_deployed_h = chimney_len;                   // top = 1170+762=1932mm world -- within 2.5m limit
// FOLD_PIVOT_Z: a standoff bracket above the ridge, NOT the recessed weld
// base -- real CGAL intersection() found chimney(false) at the recessed
// pivot swings straight through the fixed shell's own solid ridge (which
// sits AT the recess-to-ridge height range as the pipe folds flat), see
// cc_chat_log.md. Real folding-chimney hardware mounts the fold hinge on
// a bracket above the roofline for exactly this clearance reason.
FOLD_PIVOT_Z = DATUM_Z_RIDGE + chimney_d/2 + 5;
module chimney(chimney_open = true) {
    if (chimney_open) {
        // deployed: straight vertical stub from the recessed weld base
        translate([chimney_x, chimney_y, chimney_base_z]) cylinder(d = chimney_d, h = chimney_deployed_h);
    } else {
        // folded: pivots from FOLD_PIVOT_Z, toward -X (front, over the
        // tow-hitch end), clear of the lid opening (X 300-855)
        translate([chimney_x, chimney_y, FOLD_PIVOT_Z]) rotate([0, -90, 0])
            cylinder(d = chimney_d, h = chimney_deployed_h - (FOLD_PIVOT_Z - chimney_base_z));
    }
}
module drop_tube() {
    translate([chimney_x, chimney_y, DATUM_GRATE_Z])
        difference() {
            cylinder(d = drop_tube_d, h = chimney_base_z - DATUM_GRATE_Z + CHIMNEY_RECESS + e);
            translate([0, 0, -e]) cylinder(d = drop_tube_d - 4, h = chimney_base_z - DATUM_GRATE_Z + CHIMNEY_RECESS + 3*e);
        }
}

// ───────────────────────────────
// Grill grate — 3 removable laser-cut segments on an internal support
// ledge, top surface at DATUM_GRATE_Z exactly. Parent: DATUM_GRATE_Z.
// Not independently kinetic (removable, not hinged/sliding) — single
// show_grate isolation toggle per Toggle-Completeness Rule.
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

// ───────────────────────────────
// Floor drain valves x2 — placeholder valve + welded boss, front third /
// back third of chamber length, centered laterally. Off-shelf placeholder
// per prompt's explicit allowance (bbox/cylinder only, no detail).
// Parent: chamber_floor_z.
// ───────────────────────────────
module floor_drains() {
    for (xp = [DATUM_X_FRONT + chamber_L/3, DATUM_X_FRONT + chamber_L*2/3])
        translate([xp, DATUM_Y_CENTER, chamber_floor_z - 30])
            cylinder(d = 25, h = 30 + wall_t + e);
}

// ───────────────────────────────
// DEBUG TOGGLES — module isolation, per rules-codes.md Rule M-4.
// Kinetic params (Kinetic Dual-View convention): lid_open_deg,
// firebox_door_open_deg, ash_tray_out_pct, chimney_open.
// ───────────────────────────────
show_chamber_shell = true;
show_lid            = true;
show_lid_hardware   = true;
show_firebox        = true;
show_chimney        = true;
show_drop_tube       = true;
show_grate           = true;
show_drains          = true;

lid_open_deg           = 0;    // 0=closed .. 100=open
firebox_door_open_deg  = 0;    // 0=closed .. 110=open
ash_tray_out_pct       = 0;    // 0=in .. 1=fully out
chimney_open            = true; // true=deployed(vertical) / false=folded

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation Testing
// (rules-codes.md). All world coordinates, no additional translate needed
// (this file's local origin already matches MASTER ORIGIN).
// ───────────────────────────────
if (show_chamber_shell) chamber_shell();
if (show_lid) lid(lid_open_deg);
if (show_lid_hardware) lid_hardware(lid_open_deg);
if (show_firebox) firebox(firebox_door_open_deg, ash_tray_out_pct);
if (show_chimney) chimney(chimney_open);
if (show_drop_tube) drop_tube();
if (show_grate) grill_grate();
if (show_drains) floor_drains();
