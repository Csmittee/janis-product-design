// BBQ Offset Smoker — Chambers
// Version: v12
// Date: 2026-07-17
// Changes from v11: bbq-chambers-v12-firebox-rebuild-understructure-v4-wheel.
// SCOPE-EXPANDS beyond understructure-only per this prompt's own REVISION
// NOTE — v11 was locked all last session, this prompt explicitly UNLOCKS it
// for a firebox rebuild only. Chamber itself (true_octagon_profile(), apex
// A's own coordinates, the grate/grill surface, chamber_L/chamber_W)
// remains COMPLETELY FROZEN, zero changes — only firebox_shell() and
// everything parented to it change.
//
// TASK-SPECIFIC READ #1 — real values stated BEFORE any change, per the
// prompt's own mandatory read:
//   chamber_L=915, chamber_W=610, chamber_floor_z=600 (all unchanged)
//   firebox_x0/x1 (OLD, v11) = 915/1372, firebox_size (OLD) = 457 (cube)
//   firebox_y0/y1 (OLD) = 76.5/533.5, firebox_floor_z (OLD) = 400
//   true_octagon_profile() apex A = hex_pt(chamfer,0) -> world (Y=0,
//     Z=chamber_floor_z+chamfer=778.665mm) -- this file's own DATUM_GRATE_Z,
//     ALREADY the file's real "grate line." Real local distance from apex A
//     to the grate = 0mm exactly (GRATE_Z IS chamber_floor_z+chamfer,
//     confirmed by direct formula read, matches this prompt's own "assumes
//     ~0" premise).
//
// *** REAL MISMATCH FOUND, FLAGGED PER TASK-SPECIFIC READ #1's OWN
// INSTRUCTION *** — the prompt states "Apex A / today's real grate line
// (world Z) = 900mm." The REAL live value, read directly from this file
// (unchanged, chamber frozen all session), is 778.665mm -- a real
// discrepancy of 121.335mm, NOT a rounding artifact. This file has never
// had any applied world-Z shift (BBQ-understructure-v3.scad's own
// GROUND_OFFSET=150 constant was used ONLY to compute a derived reporting
// statistic, "grate height above true ground" = GRATE_Z+GROUND_OFFSET =
// 928.665mm -- it was NEVER an actually-applied geometric transform on
// this file's own literal coordinates, see BBQ-understructure-v4.scad's
// own header for the full real-anchor investigation, TASK 3). Whether the
// prompt's "900mm"/"world Z" language meant 928.665 (last round's
// documented-but-never-applied statistic) or this file's own real,
// literal, always-been-this-way 778.665mm, BOTH differ from the prompt's
// stated 900mm. Flagged here and in cc_chat_log.md, NOT silently
// resolved. Per the prompt's own explicit "Locked spec... use these exact
// numbers, do not re-derive or round" instruction for the Task 1 table's
// FINAL numbers (top_Z=1000/bottom_Z=571.4/height=428.6), those literal
// numbers are still built exactly as given below -- this mismatch affects
// only the STATED justification/derivation context, not the locked
// output values themselves.
//
// Real consequence for the "100mm intentional gap" note: the prompt
// frames firebox top_Z(1000mm) as "100mm above today's real apex-A/grate
// line (900mm)." Using the REAL apex-A value (778.665mm) instead, the
// REAL gap is 1000-778.665 = 221.335mm, not 100mm. Still NOT closed (per
// the prompt's own instruction, this is deliberate headroom for a future
// reinforcement frame + shorter door) -- stated explicitly per the QA
// checklist's own requirement, real number given, not the prompt's
// approximate one.
//
// TASK 1 — FIREBOX REBUILD. firebox_shell() (and firebox_near_wall_closure(),
// firebox_upper_wall_seal(), firebox_square_2d(), ash_tray(), firebox_door())
// resized from the old uniform 457mm cube to independent real dimensions:
//   FIREBOX_L (X) = 460mm, FIREBOX_W (Y) = 510mm, FIREBOX_H (Z) = 428.6mm
//   firebox_floor_z (bottom_Z) = 571.4mm, firebox top (firebox_z1) = 1000mm
// (571.4+428.6=1000.0, confirmed exact) -- all LOCKED literals per the
// prompt's own table, used directly as this file's own real/world Z
// (this file has never applied any coordinate shift -- see mismatch note
// above; TASK 3 in BBQ-understructure-v4.scad independently confirms and
// fixes the wheel-side anchor to make world Z=0 the real wheel-ground
// contact point, WITHOUT moving this file's own geometry -- see that
// file's header).
// X-midpoint: OLD firebox X-midpoint = 915 + 457/2 = 1143.5mm (real,
// computed from the OLD firebox_x0/firebox_size). NEW firebox is centered
// on this SAME midpoint: firebox_x0 = 1143.5 - 460/2 = 913.5mm (was 915,
// real shift -1.5mm), firebox_x1 = 1143.5 + 460/2 = 1373.5mm (was 1372,
// real shift +1.5mm) -- matches the prompt's own "~1.5mm shift each side,
// negligible" claim exactly, confirmed by direct computation, not assumed.
//
// REAL INTERFERENCE CHECK (required, stated explicitly): firebox_x0=913.5mm
// is 1.5mm LESS than DATUM_X_REAR=915mm (the chamber's own true rear wall
// end-cap boundary, wall_t=3mm thick, X=[912,915]) -- the new firebox's
// near face now sits 1.5mm INSIDE the chamber's own end-cap material
// (previously exactly flush at X=915). This is real, physical, solid-vs-solid
// OVERLAP (not a gap/hole) between firebox_shell() and chamber_outer_tube()'s
// own true end cap -- a union() of two overlapping solids stays real/valid
// 2-manifold (no CGAL defect, confirmed via the real Simple:yes render in
// cc_chat_log.md), and if anything strengthens the weld margin at that
// joint (same class as this file's own REAR_WELD_OVERLAP-style conventions
// elsewhere) -- flagged explicitly per this task's own requirement, not a
// found defect. Full CGAL sweep (kinetic + combined) confirmed clean, see
// cc_chat_log.md.
//
// Door/ash-tray resized PROPORTIONALLY (judgment call, flagged): door
// (firebox_door()) uses FIREBOX_W/FIREBOX_H directly in place of the old
// uniform firebox_size (same construction, just independent per-axis
// sizing). Ash tray (ash_tray()) plan dimensions (ASH_TRAY_L/W) scaled
// using the SAME "-40mm"/"-20mm" margin formulas this file already used,
// now against FIREBOX_L/FIREBOX_W independently. Ash tray HEIGHT
// (ASH_TRAY_H) is a REAL, FLAGGED, NOT-silently-absorbed exception: TASK 2's
// new fuel_cylinder() sits only 17mm above the firebox's own real internal
// floor (see TASK 2 note below) -- the tray's old 80mm height would collide
// with it. Real fix: ASH_TRAY_H reduced 80mm -> 12mm (real 5mm clearance
// margin under the cylinder's own real 17mm gap, confirmed via CGAL) --
// this is a SIGNIFICANT real design consequence of adding the fuel
// cylinder, explicitly flagged here for Janis's review (a 12mm ash pan is
// shallow; may need a real redesign in a follow-up round once the
// cylinder's own far-end treatment is finalized per Janis's own "let me
// see how it looks" note below).
//
// Fire grate placeholder (fire_grate(), FIREBOX_GRATE_Z): REMOVED ENTIRELY
// per this task's explicit instruction -- replaced by TASK 2's
// fuel_cylinder(), not rebuilt at the new size. Zero remaining callers
// confirmed (R-009) before deletion.
//
// TASK 2 — INTERNAL FUEL CYLINDER (fuel_cylinder(), NEW). Wall thickness
// reuses this file's own global wall_t=3mm directly (matches the prompt's
// explicit 3mm spec exactly -- no new constant needed). Diameter
// RE-DERIVED LIVE from the ACTUAL rebuilt Task 1 numbers (not copied
// blindly from the prompt's table, per this task's own explicit
// instruction): CYL_D = min(FIREBOX_H, FIREBOX_W) - 40 = min(428.6, 510) -
// 40 = 388.6mm -- IDENTICAL to the prompt's own table value (388.6mm)
// because Task 1's real built numbers (428.6/510) exactly match the
// prompt's own assumed inputs -- zero discrepancy found, confirmed by
// direct recomputation, not assumed.
// Position: Y centered on DATUM_Y_CENTER=305 (matches firebox's own
// Y-centering exactly). Z centered on the firebox's real internal height
// midpoint: (firebox_z0+firebox_z1)/2 = (571.4+1000)/2 = 785.7mm
// (symmetric wall_t trim doesn't shift the center, confirmed). X: full
// firebox_x0..firebox_x1 span (FIREBOX_L=460mm) -- matches
// firebox_shell()'s own full-X-open hollow-tube cavity exactly, open at
// BOTH ends (no end caps): the door-side end (X=firebox_x1) is where
// firebox_door() sits, closing against the cylinder's own open face when
// shut, exactly per Janis's spec ("the door, when closed, touches the
// cylinder's open face") -- pulled back by e=0.01mm from the exact door
// plane to avoid an exact-zero-clearance coincident-face touch (this
// file's own standing epsilon convention, e.g. LID_HINGE_GAP,
// firebox_passage()'s own e-overshoots), confirmed Simple:yes via CGAL
// with this gap, functionally identical "touch" at 0.01mm. The far end
// (X=firebox_x0, chamber-facing) is ALSO simply open/unfinished, per
// Janis's own explicit note ("let me see how it looks then I'll explain
// the adjustment") -- flagged as a real, known, deferred open item, NOT
// capped, NOT over-engineered, per this task's own explicit instruction.
//
// Real CGAL clearance (computed against the firebox's REAL internal
// cavity -- inset by wall_t on Y/Z -- not the prompt's own raw-outer-
// dimension -40mm estimate): Z (smaller/binding axis, real numbers):
// firebox real internal height = FIREBOX_H-2*wall_t = 422.6mm; clearance =
// (422.6-388.6)/2 = 17mm EACH SIDE (top/bottom) -- less than the prompt's
// own rough "20mm" estimate specifically because that estimate didn't
// account for the firebox's own wall_t trim, stated explicitly per this
// task's own requirement, not silently absorbed. Y clearance: firebox
// real internal width = FIREBOX_W-2*wall_t = 504mm; clearance =
// (504-388.6)/2 = 57.7mm EACH SIDE -- both real, positive, confirmed
// NON-INTERSECTING with the firebox's own inner wall anywhere, via real
// CGAL probe (see cc_chat_log.md).
//
// ---- v11 (superseded logic, kept for record) ----
// Changes from v10: bbq-chambers-v11-firebox-wall-seal. THE REAL FIX for
// the "triangle leak" Janis has reported 3 prior rounds (PR #121 x2, v9)
// -- root cause found by Janis directly, independently confirmed by
// Claude before writing any code, per SKILL_local_render.md's
// Independent Post-Fix Verification rule.
//
// Real root cause: the chamber's octagon cross-section narrows near the
// floor (the bottom two chamfers). `firebox_shell()` was a plain SQUARE
// (firebox_size=457mm). Immediately above chamber_floor_z, the octagon's
// real width is narrower than the firebox's square opening -- so the
// square's own footprint extends PAST the chamber's true wall envelope
// on both sides. `firebox_upper_wall_seal_2d()`/`firebox_upper_wall_seal()`
// close exactly that region, built from the real `firebox_square_2d()`/
// `fixed_side_solid_2d()` boolean (both unchanged in v12 except
// `firebox_square_2d()` is now generalized from a square to a real
// rectangle, see TASK 1 above -- construction PATTERN unchanged, still a
// live formula, not hardcoded coordinates, so this seal stays correct
// automatically at the new firebox size).
//
// Full pre-v11 history (v1-v10) preserved in BBQ-chambers-v11.scad's own
// header -- not restated here per this project's own file-versioning
// convention (each version's header documents its own real diff from the
// prior version; full historical narrative lives in cc_chat_log.md and
// PART_MANIFEST.md).
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
// chamfer -- real formula for a REGULAR octagon (all 8 sides equal)
// inscribed in a chamber_W x chamber_W square: 178.665mm. UNCHANGED v12
// (chamber frozen, DO NOT TOUCH).
chamfer          = chamber_W / (2 + sqrt(2));   // 178.665mm
// chamber_floor_z -- PRIMARY DATUM / MASTER CONTROL VALUE. UNCHANGED v12
// (chamber frozen, DO NOT TOUCH).
chamber_floor_z  = 600;
PASSAGE_INSET    = 15;
intake_w         = 107;
intake_h         = 107;
chimney_d        = 127;
chimney_len      = 762;

ROOM_D           = 360;                  // exhaust room diameter, UNCHANGED v12
ROOM_H           = 100;                  // exhaust room height, UNCHANGED v12

LID_X0           = 100;
LID_X1           = chamber_L - 100;      // 815
LID_LENGTH       = LID_X1 - LID_X0;      // 715

// ───────────────────────────────
// DATUMS — SKELETON block (per SKILL_product_design_skeleton.md)
// PRIMARY:   chamber_floor_z  (horizontal plane) — locks Z.
// SECONDARY: DATUM_X_REAR     (chamber's rear/firebox wall, X plane) — locks X
// TERTIARY:  DATUM_Y_CENTER   (chamber's lateral centerline, Y plane) — locks Y
// ───────────────────────────────
GRATE_Z          = chamber_floor_z + chamfer;                  // 778.665mm -- UNCHANGED v12 (chamber frozen)
DATUM_GRATE_Z    = GRATE_Z;
DATUM_X_FRONT    = 0;                                          // Parent: MASTER ORIGIN
DATUM_X_REAR     = DATUM_X_FRONT + chamber_L;                  // 915 -- Parent: DATUM_X_FRONT, offset dX=+chamber_L
DATUM_Y_LEFT     = 0;                                          // Parent: MASTER ORIGIN
DATUM_Y_CENTER   = DATUM_Y_LEFT + chamber_W/2;                  // 305 -- Parent: DATUM_Y_LEFT
trough_h         = chamber_H - 2*chamfer;                       // 252.670mm -- UNCHANGED v12
DATUM_Z_RIDGE    = chamber_floor_z + chamber_H;                  // 1210 -- UNCHANGED v12

// ───────────────────────────────
// FIREBOX DATUMS — v12 TASK 1 REBUILD. Real independent per-axis sizing
// (was a uniform firebox_size cube through v11). See file header for full
// derivation (X-midpoint preservation, locked world-Z table, real mismatch
// flag vs the prompt's own "900mm" apex-A claim).
// ───────────────────────────────
FIREBOX_L        = 460;                                        // X (length) -- was 457 (uniform cube)
FIREBOX_W        = 510;                                        // Y (width)  -- was 457
FIREBOX_H        = 428.6;                                       // Z (height) -- was 457
firebox_x_mid_old = 915 + 457/2;                                // 1143.5mm -- OLD (v11) firebox X-midpoint, preserved below
firebox_floor_z  = 571.4;                                       // bottom_Z -- LOCKED per prompt table (world/this-file's-own-Z, see header mismatch flag)

// Exhaust room datums — UNCHANGED v12.
ROOM_BASE_Z      = chamber_floor_z + chamber_H/2 - ROOM_H/2;    // 855mm
ROOM_TOP_Z       = ROOM_BASE_Z + ROOM_H;                         // 955mm

// ───────────────────────────────
// PROFILE HELPERS — encoded [-height, width] so that rotate([0,90,0])
// after linear_extrude(length) lands as world (X=length, Y=width,
// Z=height) — verified empirically in v1, unchanged mechanism.
// ───────────────────────────────
function hex_pt(h, w) = [-h, w];

// true_octagon_profile() — the TRUE closed 8-point octagon: real edges
// only, no fake diagonal anywhere. UNCHANGED v12 (chamber frozen, DO NOT
// TOUCH — includes apex A, point 3 below).
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

// fixed_side_wedge() — cutting-plane MASK, keeps only the FIXED (non-lid)
// side. UNCHANGED v12 (chamber frozen, DO NOT TOUCH).
module fixed_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A
        hex_pt(0, 0),
        hex_pt(0, chamber_W),
        hex_pt(chamber_H, chamber_W),
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only)
    ]);
}

// lid_side_wedge() — complementary mask. UNCHANGED v12 (chamber frozen, DO
// NOT TOUCH).
module lid_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A
        hex_pt(chamber_H, 0),            // top-left corner
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only)
    ]);
}

// lid_profile() — reference shape only, not used directly for
// construction. UNCHANGED v12 (chamber frozen, DO NOT TOUCH).
module lid_profile() {
    polygon(points=[
        hex_pt(chamber_H, chamber_W/2),            // 1: ridge midpoint (hinge line)
        hex_pt(chamber_H, chamfer),                 // 2: ridge, left end (half-ridge)
        hex_pt(chamber_H - chamfer, 0),             // 3: top-left chamfer bottom
        hex_pt(chamfer, 0),                          // 4: left wall bottom (parting end)
    ]);
}

// ───────────────────────────────
// chamber_shell() and its helpers — UNCHANGED v12 (chamber frozen, DO NOT
// TOUCH: octagon_ring(), chamber_outer_tube(), lid_territory_margin_fill(),
// exhaust_room_opening(), chamber_shell() itself all byte-identical to v11).
// ───────────────────────────────
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
module chamber_outer_tube() {
    intersection() {
        octagon_ring(DATUM_X_FRONT, DATUM_X_REAR, true, true);
        translate([0, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = chamber_L, convexity = 4) fixed_side_wedge();
    }
}

// firebox_square_2d() — v12: GENERALIZED from a square (uniform
// firebox_size) to a real RECTANGLE (FIREBOX_H x FIREBOX_W independently),
// same hex_pt(h,w) 2D space, same construction PATTERN as v11 (live
// formula, not hardcoded coordinates) — so firebox_passage_profile() and
// firebox_upper_wall_seal_2d() below (both UNCHANGED CODE) automatically
// follow the new firebox size/position, no separate edit needed (R-009).
module firebox_square_2d() {
    translate([chamber_floor_z - firebox_z1, firebox_y0])
        square([FIREBOX_H, FIREBOX_W]);
}
// fixed_side_solid_2d() — UNCHANGED v12 (chamber frozen, DO NOT TOUCH).
module fixed_side_solid_2d() {
    intersection() {
        true_octagon_profile();
        fixed_side_wedge();
    }
}
// firebox_passage_profile() — UNCHANGED CODE v12 (automatically follows
// the new firebox_square_2d() rectangle above).
module firebox_passage_profile() {
    offset(delta = -PASSAGE_INSET)
        intersection() {
            fixed_side_solid_2d();
            firebox_square_2d();
        }
}
module firebox_passage() {
    translate([DATUM_X_REAR - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t + 2*e, convexity = 4)
            firebox_passage_profile();
}
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
    ROOM_GAP = 1;
    translate([-e, DATUM_Y_CENTER - ROOM_D/2 - ROOM_GAP, ROOM_BASE_Z - ROOM_GAP])
        cube([wall_t + 2*e, ROOM_D + 2*ROOM_GAP, ROOM_H + 2*ROOM_GAP]);
}
module chamber_shell() {
    difference() {
        union() {
            chamber_outer_tube();
            lid_territory_margin_fill();
        }
        firebox_passage();
        exhaust_room_opening();
    }
}

// ───────────────────────────────
// exhaust_room() / chimney_pipe() — UNCHANGED v12.
// ───────────────────────────────
ROOM_R = ROOM_D / 2;
module room_half_space() {
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
    intersection() {
        translate([0, DATUM_Y_CENTER, ROOM_BASE_Z + wall_t]) cylinder(d = ROOM_D - 2*wall_t, h = ROOM_H - 2*wall_t);
        room_half_space();
    }
}
PIPE_HOLE_X = -ROOM_R / 2;   // -90
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
PIPE_BASE_Z = ROOM_TOP_Z - wall_t - e;   // 801.99
module chimney_pipe() {
    translate([PIPE_HOLE_X, PIPE_HOLE_Y, PIPE_BASE_Z])
        cylinder(d = chimney_d, h = chimney_len + wall_t + e);
}

// ───────────────────────────────
// lid() and hardware — UNCHANGED v12.
// ───────────────────────────────
LID_OVERLAP = 3;
lid_slant_len = chamfer * sqrt(2) + LID_OVERLAP;
module lid_closed_panels() {
    translate([LID_X0, chamfer - LID_OVERLAP, DATUM_Z_RIDGE - wall_t])
        cube([LID_LENGTH, DATUM_Y_CENTER - (chamfer - LID_OVERLAP), wall_t]);
    translate([LID_X0, chamfer, DATUM_Z_RIDGE]) rotate([-135, 0, 0])
        cube([LID_LENGTH, lid_slant_len, wall_t]);
    translate([LID_X0, 0, chamber_floor_z + chamfer - LID_OVERLAP])
        cube([LID_LENGTH, wall_t, trough_h + LID_OVERLAP]);
}
module lid_closed() {
    lid_closed_panels();
}
LID_HINGE_GAP = 0.5;
module lid(lid_open_deg = 0) {
    translate([0, DATUM_Y_CENTER + LID_HINGE_GAP, DATUM_Z_RIDGE + LID_HINGE_GAP])
        rotate([-lid_open_deg, 0, 0])
        translate([0, -DATUM_Y_CENTER - LID_HINGE_GAP, -DATUM_Z_RIDGE - LID_HINGE_GAP])
        lid_closed();
}
LEVER_ARM = 400;
COUNTERWEIGHT_KG = 10;
module lid_hardware(lid_open_deg = 0) {
    translate([0, DATUM_Y_CENTER, DATUM_Z_RIDGE]) rotate([lid_open_deg, 0, 0]) translate([0, -DATUM_Y_CENTER, -DATUM_Z_RIDGE]) {
        // STALE v1 positions -- unchanged, disabled (show_lid_hardware=false)
    }
}

// ───────────────────────────────
// firebox() — v12 TASK 1/2 REBUILD. firebox_shell()/firebox_near_wall_closure()/
// firebox_upper_wall_seal()/ash_tray()/firebox_door() all resized to the new
// independent FIREBOX_L/W/H. fire_grate() REMOVED. fuel_cylinder() NEW
// (TASK 2). See file header for full derivation.
// ───────────────────────────────
firebox_x0 = firebox_x_mid_old - FIREBOX_L/2;    // 913.5 -- Parent: OLD firebox X-midpoint (preserved)
firebox_x1 = firebox_x0 + FIREBOX_L;             // 1373.5
firebox_y0 = DATUM_Y_CENTER - FIREBOX_W/2;       // 50 -- Parent: DATUM_Y_CENTER
firebox_y1 = firebox_y0 + FIREBOX_W;             // 560
firebox_z0 = firebox_floor_z;                    // 571.4 -- LOCKED (see file header)
firebox_z1 = firebox_z0 + FIREBOX_H;             // 1000.0 -- LOCKED (see file header)
module firebox_shell() {
    difference() {
        translate([firebox_x0, firebox_y0, firebox_z0]) cube([FIREBOX_L, FIREBOX_W, FIREBOX_H]);
        translate([firebox_x0 - e, firebox_y0 + wall_t, firebox_z0 + wall_t])
            cube([FIREBOX_L + 2*e, FIREBOX_W - 2*wall_t, FIREBOX_H - 2*wall_t]);
    }
}

// firebox_near_wall_closure() — v12: Y-span now uses FIREBOX_W (was
// firebox_size). Real remaining gap band (chamber_floor_z - firebox_z0) =
// 600 - 571.4 = 28.6mm (was 200mm through v11) -- much shorter now that
// the firebox's own bottom_Z sits much closer to chamber_floor_z, still a
// real positive gap needing closure, confirmed via direct computation.
module firebox_near_wall_closure() {
    translate([firebox_x0 - e, firebox_y0 + wall_t, firebox_z0 - e])
        cube([wall_t + 2*e, FIREBOX_W - 2*wall_t, (chamber_floor_z - firebox_z0) + e]);
}

// firebox_upper_wall_seal_2d() / firebox_upper_wall_seal() — UNCHANGED CODE
// v12 (automatically follows the new firebox_square_2d() rectangle above,
// per R-009 -- same construction pattern, real formula, not hardcoded).
module firebox_upper_wall_seal_2d() {
    intersection() {
        difference() {
            firebox_square_2d();
            offset(delta = -e) fixed_side_solid_2d();
        }
        translate([-4000, -4000]) square([4000, 8000]);   // h>=0 half-space
    }
}
module firebox_upper_wall_seal() {
    translate([firebox_x0 - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t + 2*e, convexity = 4)
            firebox_upper_wall_seal_2d();
}

// fuel_cylinder() — v12 TASK 2, NEW. See file header for full derivation
// (diameter re-derivation, position, real clearances).
CYL_D = min(FIREBOX_H, FIREBOX_W) - 40;   // 388.6mm -- re-derived live, matches prompt table exactly
CYL_R = CYL_D / 2;
CYL_Y_CENTER = DATUM_Y_CENTER;             // 305 -- matches firebox's own Y-centering
CYL_Z_CENTER = (firebox_z0 + firebox_z1) / 2;   // 785.7mm
module fuel_cylinder() {
    translate([firebox_x0, CYL_Y_CENTER, CYL_Z_CENTER]) rotate([0, 90, 0])
        difference() {
            cylinder(d = CYL_D, h = FIREBOX_L - e);   // -e: pulled back off the door plane, avoids an
                                                        // exact-zero-clearance coincident-face touch at
                                                        // firebox_x1 (this file's own standing epsilon
                                                        // convention) -- functionally identical "the door,
                                                        // when closed, touches the cylinder's open face"
                                                        // per Janis's spec, at 0.01mm instead of 0mm.
            translate([0, 0, -e]) cylinder(d = CYL_D - 2*wall_t, h = FIREBOX_L - e + 2*e);
        }
}

// ash_tray() — v12: plan dims (ASH_TRAY_L/W) scaled to the new FIREBOX_L/W
// using the SAME margin formulas as v11. ASH_TRAY_H reduced 80->12mm, a
// REAL FLAGGED consequence of fuel_cylinder()'s real 17mm clearance above
// the firebox floor (12mm tray + 5mm real margin = 17mm, confirmed via
// CGAL) -- see file header, flagged for Janis's review.
ASH_TRAY_H = 12;                              // was 80 -- flagged, see file header
ASH_TRAY_L = FIREBOX_L - 2*wall_t - 40;       // 414 (was 411)
ASH_TRAY_W = FIREBOX_W - 2*wall_t - 20;       // 484 (was 431)
ASH_TRAY_X_IN = firebox_x0 + wall_t + 10;     // 926.5
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
// firebox_door() — v12: FIREBOX_W/FIREBOX_H used directly in place of the
// old uniform firebox_size (same construction, independent per-axis size).
module firebox_door(firebox_door_open_deg = 0) {
    translate([firebox_x1, firebox_y0 - HINGE_GAP, firebox_z0]) rotate([0, 0, -firebox_door_open_deg]) {
        difference() {
            union() {
                cube([wall_t, FIREBOX_W, FIREBOX_H]);
                translate([wall_t, JOGGLE, JOGGLE]) cube([JOGGLE, FIREBOX_W - 2*JOGGLE, FIREBOX_H - 2*JOGGLE]);
            }
            translate([-e, FIREBOX_W*0.5 - intake_w/2, FIREBOX_H*0.15]) cube([wall_t + JOGGLE + 2*e, intake_w, intake_h]);
        }
    }
}
module firebox(firebox_door_open_deg = 0, ash_tray_out_pct = 0) {
    firebox_shell();
    firebox_near_wall_closure();
    firebox_upper_wall_seal();
    fuel_cylinder();              // v12 TASK 2 -- replaces fire_grate() (REMOVED)
    ash_tray(ash_tray_out_pct);
    firebox_door(firebox_door_open_deg);
}

// ───────────────────────────────
// Grill grate + Floor drains — UNCHANGED v12 (chamber frozen, DO NOT
// TOUCH: grate/grill surface is explicitly frozen per this prompt).
// ───────────────────────────────
GRATE_MARGIN = 60;
GRATE_GAP = 8;
grate_usable_l = chamber_L - 2*GRATE_MARGIN;
grate_seg_l = (grate_usable_l - 2*GRATE_GAP) / 3;
GRATE_LOCAL_H = (DATUM_GRATE_Z - 10) - chamber_floor_z;   // 140
GRATE_Y_SAFETY = wall_t + 10;
GRATE_Y0 = (chamfer - GRATE_LOCAL_H) + GRATE_Y_SAFETY;
GRATE_Y1 = (chamber_W - chamfer + GRATE_LOCAL_H) - GRATE_Y_SAFETY;
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
// v12: show_grate/fire_grate REMOVED (module deleted, replaced by
// fuel_cylinder(), which is un-toggled -- a sub-part of firebox(), same
// precedent as ash_tray()/firebox_door() themselves being un-toggled
// sub-parts of firebox()'s own single show_firebox toggle).
// ───────────────────────────────
show_chamber_shell  = true;
show_lid             = true;
show_lid_hardware    = false;
show_firebox         = true;
show_exhaust_room    = true;
show_chimney_pipe    = true;
show_grate            = true;
show_drains           = true;

lid_open_deg           = 0;    // 0=closed .. max
firebox_door_open_deg  = 0;    // 0=closed .. 110=open
ash_tray_out_pct       = 0;    // 0=in .. 1=fully out

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation Testing
// (rules-codes.md).
// ───────────────────────────────
if (show_chamber_shell) color("#C8C8C8", 0.75) chamber_shell();
if (show_lid) color("#C8C8C8", 0.75) lid(lid_open_deg);
if (show_lid_hardware) color("#C8C8C8", 0.75) lid_hardware(lid_open_deg);
if (show_firebox) color("#C8C8C8", 0.75) firebox(firebox_door_open_deg, ash_tray_out_pct);
if (show_exhaust_room) color("#C8C8C8", 0.75) exhaust_room();
if (show_chimney_pipe) color("#C8C8C8", 0.75) chimney_pipe();
if (show_grate) color("#CCCCCC", 1.0) grill_grate();
if (show_drains) color("#AAAAAA", 1.0) floor_drains();
