// BBQ Offset Smoker — Chambers
// Version: v13
// Date: 2026-07-17
// Changes from v12: bbq-chambers-v13-reanchor-grate-decouple-rear-passage.
// CHAMBER-ONLY round. Firebox (v12, 460x510x428.6mm, world Z=[571.4,1000])
// and understructure (v4, 18" wheel, world-Z=0 anchor) are BOTH already
// correct and stay completely frozen — zero changes to either's own
// dimensions/Z-anchor logic this round (per this prompt's own explicit
// scope).
//
// TASK-SPECIFIC READ — real values stated BEFORE any change:
//   chamber_floor_z (OLD, v12) = 600 (hardcoded literal)
//   GRATE_Z (OLD) = chamber_floor_z + chamfer = 778.665mm — REAL, confirmed
//     mismatch vs the v12 prompt's mistaken "900mm" claim (see v12's own
//     header — that 900mm traced back to a v3 GROUND_OFFSET constant that
//     was computed on paper via a derived reporting statistic but never
//     actually wired into any built geometry transform).
//   chamfer = 178.665mm (formula, chamber_W/(2+sqrt(2)), UNCHANGED)
//   true_octagon_profile() — real 8-point closed octagon, UNCHANGED (see
//     module below, unchanged from v12).
//   DATUM_X_REAR = 915mm — the chamber's rear end wall X-position,
//     UNCHANGED. Rear end wall's real construction (read directly, not
//     assumed): chamber_outer_tube() = intersection(octagon_ring(...,
//     cap_x0=true, cap_x1=true), fixed_side_wedge()-extrude) — a REAL
//     SOLID wall_t-thick end cap at X=[DATUM_X_REAR-wall_t, DATUM_X_REAR]
//     = [912,915], filled with `fixed_side_solid_2d()`'s own real 2D
//     cross-section (intersection of true_octagon_profile() and
//     fixed_side_wedge()) — this is what firebox_passage() cuts through.
//     Confirmed solid, not open, not a different construction.
//   grill_grate() (OLD, v12) — 3 segments, X via GRATE_MARGIN/grate_seg_l/
//     GRATE_GAP (UNCHANGED this round, per DO NOT TOUCH below), Z at
//     DATUM_GRATE_Z-10, Y-range GRATE_Y0/GRATE_Y1 derived from
//     GRATE_LOCAL_H=(DATUM_GRATE_Z-10)-chamber_floor_z (a chamfer-taper
//     formula, valid only while GRATE_LOCAL_H < chamfer — see TASK 2 note
//     below for why this formula is being READ, not touched, and why it
//     stays numerically valid).
//   BBQ-chambers-v12.scad firebox section (read, frozen, zero changes):
//     FIREBOX_L/W/H=460/510/428.6, firebox_floor_z=571.4 (top=1000),
//     fuel_cylinder(): CYL_D=388.6mm, wall=wall_t=3mm, Y-center=
//     DATUM_Y_CENTER=305, Z-center=(firebox_z0+firebox_z1)/2=785.7mm, X
//     span=[firebox_x0=913.5, firebox_x1-e=1373.49].
//
// TASK 1 — CHAMBER BODY REANCHOR (apex A -> exactly 900mm).
// `chamber_floor_z` changed from a hardcoded 600 literal to a real live
// formula: `900 - chamfer`. Since `GRATE_Z = chamber_floor_z + chamfer`
// is UNCHANGED as a formula, this makes GRATE_Z = (900-chamfer)+chamfer =
// 900 EXACTLY (algebraic cancellation, not a numeric approximation).
// Real live-derived value: chamber_floor_z = 900 - 178.665 = 721.335mm
// (matches the prompt's own ~721.335mm expectation, confirmed by direct
// computation from the live chamfer value, not copied blindly).
// Every other chamber-body element keyed off chamber_floor_z moves
// automatically via the existing dependency chain (R-009 — confirmed,
// not re-derived per element): octagon_ring()/chamber_outer_tube()
// (extrusion base Z), DATUM_Z_RIDGE = chamber_floor_z+chamber_H =
// 721.335+610 = 1331.335mm (was 1210), lid_closed_panels()/lid() (all Z
// refs relative to chamber_floor_z/DATUM_Z_RIDGE), ROOM_BASE_Z/ROOM_TOP_Z
// = 721.335+305-50/+50 = 976.335/1076.335mm (was 855/955), room_pipe_hole()/
// chimney_pipe() (both keyed off ROOM_TOP_Z). trough_h is UNCHANGED
// (chamber_H-2*chamfer, no chamber_floor_z dependency).
// Real collision check (required): firebox (frozen, world Z=[571.4,1000])
// vs the reanchored chamber — confirmed via real CGAL, see cc_chat_log.md
// for the actual probe results (chamber's own solid rear-wall material
// now only exists for Z>=721.335, a real ~149.9mm-taller unsealed band
// against the firebox's fixed Z-range than v12 had — this is exactly why
// TASK 3's new dedicated firebox end-cap plate below is now required,
// not optional). Understructure (frozen) re-checked clean, no dependency
// on chamber_floor_z's own value beyond firebox_floor_z (untouched).
//
// TASK 2 — GRATE DECOUPLING (TEMPORARY, fixed 1000mm — see the mandatory
// comment directly at GRATE_Z_FIXED's own declaration below, not just
// here). `grill_grate()`'s Z placement now reads `GRATE_Z_FIXED` (=1000,
// new independent constant) instead of `DATUM_GRATE_Z`. Real grate-to-
// apex-A gap: GRATE_Z_FIXED - GRATE_Z = 1000-900 = 100mm exactly.
// X/Y placement (GRATE_MARGIN, segment layout, GRATE_Y0/GRATE_Y1) — kept
// as the EXISTING real formulas, UNCHANGED, per this task's own explicit
// DO NOT TOUCH. Real, flagged consequence of that explicit instruction
// (stated, not silently smoothed over): GRATE_Y0/GRATE_Y1's own formula
// still derives GRATE_LOCAL_H from DATUM_GRATE_Z (=900, the chamber's own
// apex-A reference), NOT from the grate's real new independent Z
// (GRATE_Z_FIXED=1000) — GRATE_LOCAL_H = (900-10)-721.335 = 168.665mm,
// still < chamfer(178.665), so the existing chamfer-taper formula stays
// numerically VALID (no negative/nonsense result) and produces
// GRATE_Y0/Y1 = 23/587mm (564mm wide). The grate's REAL physical height
// (1000, in the straight vertical-wall zone where the true available
// width is the full chamber_W minus wall, i.e. up to ~604mm) is wider
// than what this frozen formula computes — meaning the built grate is
// narrower than geometrically necessary at its real height. This is
// SAFE (narrower always fits inside the true wider boundary, confirmed
// via real CGAL — no collision), just not width-optimal — a direct,
// intentional consequence of the prompt's own explicit "keep the
// EXISTING formulas" instruction, not a bug, flagged per that
// instruction's own spirit (state the real consequence, don't silently
// absorb it).
// Real CGAL interference check (required): grate (now floating at
// Z=1000, no supporting structure — expected, matches the deliberate
// ~100mm gap, the future reinforcement-frame/shorter-door task) vs the
// repositioned lid (closed AND full open sweep)/chimney_pipe()/
// exhaust_room() at their TASK-1 real new Z values — see cc_chat_log.md
// for the actual sweep result.
//
// TASK 3 — REAR PASSAGE REWORK (two separate solids, real intersection()
// against the live profile, not hand-derived):
// 1. Chamber's rear end wall cut: `firebox_passage_profile()` REBUILT —
//    was `offset(-PASSAGE_INSET) intersection(fixed_side_solid_2d(),
//    firebox_square_2d())` (a rectangular firebox-footprint cut, inset
//    15mm); now `intersection(fixed_side_solid_2d(),
//    fuel_cylinder_circle_2d())` — the REAL circular cross-section of the
//    ALREADY-BUILT v12 fuel_cylinder() (388.6mm dia, read live via
//    CYL_D/CYL_Y_CENTER/CYL_Z_CENTER, not re-guessed), clipped by the
//    chamber's own real solid cross-section (`fixed_side_solid_2d()`,
//    UNCHANGED module — itself already zero-area below chamber_floor_z
//    by construction, since `true_octagon_profile()` has no material
//    there, so no separate explicit floor-clamp is needed — confirmed by
//    reading that module's own real boundary, not assumed). No inset
//    margin (this is now a real welded pipe-through-wall joint, not a
//    safety-margined structural cut) — `PASSAGE_INSET` RETIRED (R-009:
//    confirmed zero other real consumers before removing).
//    `fuel_cylinder_circle_2d()` (NEW, 2D helper, same hex_pt(h,w) space
//    as every other profile in this file): circle of diameter CYL_D,
//    centered at local (h = CYL_Z_CENTER-chamber_floor_z, w =
//    CYL_Y_CENTER) — this h-value is TASK-1-dependent (chamber_floor_z
//    changed), so it automatically re-centers correctly with the
//    reanchor, confirmed live, not hardcoded.
//    Real result (see cc_chat_log.md for the actual render): round at
//    the top (circle unclipped, well inside the octagon's wide
//    vertical-wall zone there), following the octagon's own narrowing
//    chamfer/floor boundary lower down where the circle would otherwise
//    extend past real chamber material — exactly Janis's "look through
//    the door" description.
// 2. NEW `firebox_end_cap()` (+ `firebox_end_cap_2d()`) — REPLACES
//    `firebox_near_wall_closure()` AND `firebox_upper_wall_seal()` (BOTH
//    RETIRED entirely, R-009: confirmed zero other real consumers before
//    removing — the real ~149.9mm-taller unsealed band TASK 1 created
//    made both of those narrow-band modules insufficient anyway, a full
//    dedicated end-cap is the correct real fix, not a patch). ONE
//    continuous plate, positioned at the firebox's own near
//    (chamber-facing) wall, X straddling firebox_x0 (same
//    `firebox_x0-wall_t-e` / `wall_t+2*e` overshoot pattern this file's
//    retired seal modules already used, guarantees real volume overlap,
//    not a coincident-face touch): `firebox_square_2d()` (the firebox's
//    own FULL real Y-Z rectangle, reused UNCHANGED module) minus the SAME
//    passage-hole shape as cut #1 above (`intersection(fixed_side_solid_2d(),
//    fuel_cylinder_circle_2d())`) — real, direct consequence, NOT
//    separately re-derived: since that hole shape has zero area for
//    h<0 (below chamber_floor_z, `fixed_side_solid_2d()`'s own real
//    boundary), the difference leaves the FULL rectangle solid there —
//    "plain rectangle... fully solid" per the prompt's own spec, by
//    direct construction, not a separate case. Above chamber_floor_z,
//    the remaining material is the rectangle minus exactly the same
//    round-topped/octagon-bounded hole cut #1 uses — real, confirmed
//    alignment between the two plates (same 2D shape, same world Y/Z
//    reference frame, only X differs) — JUDGMENT CALL, flagged: this
//    is a plain-rectangle-minus-hole construction rather than also
//    clipping the plate's own OUTER silhouette to the octagon boundary
//    (the prompt's "follows the octagon boundary... filling the gap
//    between the firebox cube's rectangular footprint and the octagon's
//    actual narrower edge" language could be read either way) — chosen
//    because it's simpler, provably satisfies every literal requirement
//    (open only at the aligned hole; below-floor zone fully solid), and
//    is the same real construction already reused for cut #1, so the two
//    plates are provably self-consistent by sharing one 2D module rather
//    than independently re-deriving two similar-but-not-identical
//    octagon-aware shapes.
// 3/4. Real CGAL seal-weld + full-seal + old-cut-removed checks — see
//    cc_chat_log.md for the actual probe results (not assumed from
//    visual placement).
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
// inscribed in a chamber_W x chamber_W square: 178.665mm. UNCHANGED v13.
chamfer          = chamber_W / (2 + sqrt(2));   // 178.665mm
// chamber_floor_z -- v13 TASK 1: REANCHORED. Was a hardcoded 600mm
// literal through v12; now a real live formula so GRATE_Z (=
// chamber_floor_z+chamfer, unchanged formula) lands at EXACTLY 900mm by
// algebraic construction, not a numeric approximation. See file header
// for the full real-value derivation and the dependency-chain list of
// every element that moves with it.
chamber_floor_z  = 900 - chamfer;   // 721.335mm (v13, was hardcoded 600)
intake_w         = 107;
intake_h         = 107;
chimney_d        = 127;
chimney_len      = 762;

ROOM_D           = 360;                  // exhaust room diameter, UNCHANGED
ROOM_H           = 100;                  // exhaust room height, UNCHANGED

LID_X0           = 100;
LID_X1           = chamber_L - 100;      // 815
LID_LENGTH       = LID_X1 - LID_X0;      // 715

// ───────────────────────────────
// DATUMS — SKELETON block (per SKILL_product_design_skeleton.md)
// PRIMARY:   chamber_floor_z  (horizontal plane) — locks Z. v13: now a
//            live formula (900-chamfer), see PARAMETERS above.
// SECONDARY: DATUM_X_REAR     (chamber's rear/firebox wall, X plane) — locks X
// TERTIARY:  DATUM_Y_CENTER   (chamber's lateral centerline, Y plane) — locks Y
// ───────────────────────────────
GRATE_Z          = chamber_floor_z + chamfer;                  // 900mm EXACT (v13, was 778.665) -- apex A's own real world Z
DATUM_GRATE_Z    = GRATE_Z;
DATUM_X_FRONT    = 0;                                          // Parent: MASTER ORIGIN
DATUM_X_REAR     = DATUM_X_FRONT + chamber_L;                  // 915 -- Parent: DATUM_X_FRONT, offset dX=+chamber_L
DATUM_Y_LEFT     = 0;                                          // Parent: MASTER ORIGIN
DATUM_Y_CENTER   = DATUM_Y_LEFT + chamber_W/2;                  // 305 -- Parent: DATUM_Y_LEFT
trough_h         = chamber_H - 2*chamfer;                       // 252.670mm -- UNCHANGED (no chamber_floor_z dependency)
DATUM_Z_RIDGE    = chamber_floor_z + chamber_H;                  // 1331.335mm (v13, was 1210)

// ───────────────────────────────
// FIREBOX DATUMS — v12, FROZEN this round (DO NOT TOUCH, read only).
// ───────────────────────────────
FIREBOX_L        = 460;
FIREBOX_W        = 510;
FIREBOX_H        = 428.6;
firebox_x_mid_old = 915 + 457/2;                                // 1143.5mm -- unchanged historical reference
firebox_floor_z  = 571.4;                                       // bottom_Z -- LOCKED, frozen this round

// Exhaust room datums — v13: real values move automatically with the new
// chamber_floor_z (formula itself UNCHANGED).
ROOM_BASE_Z      = chamber_floor_z + chamber_H/2 - ROOM_H/2;    // 976.335mm (v13, was 855)
ROOM_TOP_Z       = ROOM_BASE_Z + ROOM_H;                         // 1076.335mm (v13, was 955)

// ───────────────────────────────
// PROFILE HELPERS — encoded [-height, width] so that rotate([0,90,0])
// after linear_extrude(length) lands as world (X=length, Y=width,
// Z=height) — verified empirically in v1, unchanged mechanism.
// ───────────────────────────────
function hex_pt(h, w) = [-h, w];

// true_octagon_profile() — the TRUE closed 8-point octagon: real edges
// only, no fake diagonal anywhere. UNCHANGED v13 (chamber's own shape
// frozen, DO NOT TOUCH — includes apex A, point 3 below; only the WORLD Z
// this profile's local h=0 origin sits at has changed, via
// chamber_floor_z, TASK 1).
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
// side. UNCHANGED v13.
module fixed_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A
        hex_pt(0, 0),
        hex_pt(0, chamber_W),
        hex_pt(chamber_H, chamber_W),
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only)
    ]);
}

// lid_side_wedge() — complementary mask. UNCHANGED v13.
module lid_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A
        hex_pt(chamber_H, 0),            // top-left corner
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only)
    ]);
}

// lid_profile() — reference shape only, not used directly for
// construction. UNCHANGED v13.
module lid_profile() {
    polygon(points=[
        hex_pt(chamber_H, chamber_W/2),            // 1: ridge midpoint (hinge line)
        hex_pt(chamber_H, chamfer),                 // 2: ridge, left end (half-ridge)
        hex_pt(chamber_H - chamfer, 0),             // 3: top-left chamfer bottom
        hex_pt(chamfer, 0),                          // 4: left wall bottom (parting end)
    ]);
}

// ───────────────────────────────
// chamber_shell() and its helpers — UNCHANGED CODE v13 (chamber's own
// shape frozen, DO NOT TOUCH: octagon_ring(), chamber_outer_tube(),
// lid_territory_margin_fill(), exhaust_room_opening(), chamber_shell()
// itself all byte-identical to v12 — real world position moves only via
// chamber_floor_z's own new value, TASK 1, automatically).
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

// firebox_square_2d() — UNCHANGED CODE v13 (still the firebox's own full
// real Y-Z rectangle footprint, same hex_pt(h,w) space) — reused by the
// NEW firebox_end_cap_2d() below (TASK 3), same R-009 live-formula
// pattern as v12.
module firebox_square_2d() {
    translate([chamber_floor_z - firebox_z1, firebox_y0])
        square([FIREBOX_H, FIREBOX_W]);
}
// fixed_side_solid_2d() — UNCHANGED v13 (chamber's own shape frozen, DO
// NOT TOUCH).
module fixed_side_solid_2d() {
    intersection() {
        true_octagon_profile();
        fixed_side_wedge();
    }
}

// fuel_cylinder_circle_2d() — v13 TASK 3, NEW. The fuel cylinder's real
// circular cross-section (388.6mm dia, read live from the ALREADY-BUILT
// v12 CYL_D/CYL_Y_CENTER/CYL_Z_CENTER below), expressed in the same
// hex_pt(h,w) 2D space as every other profile in this file so it can be
// intersect()-ed directly against fixed_side_solid_2d(). Local h-center
// = CYL_Z_CENTER-chamber_floor_z -- TASK-1-dependent, re-centers
// automatically with the reanchor (confirmed live, not hardcoded).
module fuel_cylinder_circle_2d() {
    translate(hex_pt(CYL_Z_CENTER - chamber_floor_z, CYL_Y_CENTER))
        circle(d = CYL_D);
}
// firebox_passage_profile() — v13 TASK 3 REBUILT. Was
// offset(-PASSAGE_INSET) intersection(fixed_side_solid_2d(),
// firebox_square_2d()) (rectangular firebox-footprint cut, inset 15mm);
// now the REAL circular fuel-cylinder cross-section clipped by the
// chamber's own real solid boundary -- no inset (real welded joint, not
// a safety-margined structural cut). PASSAGE_INSET RETIRED (R-009:
// confirmed zero other real consumers). Automatically zero-area below
// chamber_floor_z (fixed_side_solid_2d()'s own real boundary), no
// separate floor-clamp needed -- confirmed by reading that module, not
// assumed.
module firebox_passage_profile() {
    intersection() {
        fixed_side_solid_2d();
        fuel_cylinder_circle_2d();
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
// exhaust_room() / chimney_pipe() — UNCHANGED CODE v13 (real world
// position moves only via ROOM_BASE_Z/ROOM_TOP_Z's own new values, TASK 1,
// automatically).
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
PIPE_BASE_Z = ROOM_TOP_Z - wall_t - e;   // 1023.325mm (v13, was 801.99)
module chimney_pipe() {
    translate([PIPE_HOLE_X, PIPE_HOLE_Y, PIPE_BASE_Z])
        cylinder(d = chimney_d, h = chimney_len + wall_t + e);
}

// ───────────────────────────────
// lid() and hardware — UNCHANGED CODE v13 (real world position moves only
// via chamber_floor_z/DATUM_Z_RIDGE's own new values, TASK 1,
// automatically).
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
// firebox() — v13 TASK 3 REWORK. firebox_shell()/ash_tray()/firebox_door()/
// fuel_cylinder() all UNCHANGED CODE, frozen per DO NOT TOUCH.
// firebox_near_wall_closure() + firebox_upper_wall_seal() RETIRED, both
// REPLACED by the new firebox_end_cap(). See file header for full
// derivation.
// ───────────────────────────────
firebox_x0 = firebox_x_mid_old - FIREBOX_L/2;    // 913.5 -- Parent: OLD firebox X-midpoint (preserved)
firebox_x1 = firebox_x0 + FIREBOX_L;             // 1373.5
firebox_y0 = DATUM_Y_CENTER - FIREBOX_W/2;       // 50 -- Parent: DATUM_Y_CENTER
firebox_y1 = firebox_y0 + FIREBOX_W;             // 560
firebox_z0 = firebox_floor_z;                    // 571.4 -- LOCKED, frozen
firebox_z1 = firebox_z0 + FIREBOX_H;             // 1000.0 -- LOCKED, frozen
module firebox_shell() {
    difference() {
        translate([firebox_x0, firebox_y0, firebox_z0]) cube([FIREBOX_L, FIREBOX_W, FIREBOX_H]);
        translate([firebox_x0 - e, firebox_y0 + wall_t, firebox_z0 + wall_t])
            cube([FIREBOX_L + 2*e, FIREBOX_W - 2*wall_t, FIREBOX_H - 2*wall_t]);
    }
}

// firebox_end_cap_2d() / firebox_end_cap() — v13 TASK 3, NEW. REPLACES
// firebox_near_wall_closure() + firebox_upper_wall_seal() (BOTH RETIRED,
// R-009 confirmed zero other real consumers). ONE continuous plate: the
// firebox's own full real Y-Z rectangle (firebox_square_2d(), UNCHANGED
// module) minus the SAME passage-hole shape cut #1 (firebox_passage_profile())
// uses -- real, direct, not separately re-derived. That hole shape has
// zero area below chamber_floor_z (fixed_side_solid_2d()'s own real
// boundary), so the difference leaves the FULL rectangle solid there --
// "plain rectangle... fully solid" by direct construction. Above
// chamber_floor_z, the remaining material is the rectangle minus exactly
// the round-topped/octagon-bounded hole -- real, provable alignment with
// cut #1 (same 2D shape, same world Y/Z frame, only X differs). See file
// header for the full judgment-call note on this construction choice.
module firebox_end_cap_2d() {
    difference() {
        firebox_square_2d();
        firebox_passage_profile();
    }
}
module firebox_end_cap() {
    translate([firebox_x0 - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t + 2*e, convexity = 4)
            firebox_end_cap_2d();
}

// fuel_cylinder() — UNCHANGED CODE v13 (frozen, DO NOT TOUCH). Real seal-
// weld: the cylinder's own near end (world X=firebox_x0, no epsilon
// pull-back on that end, per v12's own construction) now passes directly
// through firebox_end_cap()'s aligned hole (also straddling firebox_x0)
// AND on through chamber's own rear-wall cut at DATUM_X_REAR (915) --
// real 3D overlap confirmed via CGAL, see cc_chat_log.md.
CYL_D = min(FIREBOX_H, FIREBOX_W) - 40;   // 388.6mm -- UNCHANGED, frozen
CYL_R = CYL_D / 2;
CYL_Y_CENTER = DATUM_Y_CENTER;             // 305
CYL_Z_CENTER = (firebox_z0 + firebox_z1) / 2;   // 785.7mm -- UNCHANGED, frozen (firebox itself frozen)
module fuel_cylinder() {
    translate([firebox_x0, CYL_Y_CENTER, CYL_Z_CENTER]) rotate([0, 90, 0])
        difference() {
            cylinder(d = CYL_D, h = FIREBOX_L - e);
            translate([0, 0, -e]) cylinder(d = CYL_D - 2*wall_t, h = FIREBOX_L - e + 2*e);
        }
}

// ash_tray() — UNCHANGED CODE v13 (frozen, DO NOT TOUCH).
ASH_TRAY_H = 12;
ASH_TRAY_L = FIREBOX_L - 2*wall_t - 40;       // 414
ASH_TRAY_W = FIREBOX_W - 2*wall_t - 20;       // 484
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
// firebox_door() — UNCHANGED CODE v13 (frozen, DO NOT TOUCH).
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
    firebox_end_cap();            // v13 TASK 3 -- replaces firebox_near_wall_closure()+firebox_upper_wall_seal()
    fuel_cylinder();
    ash_tray(ash_tray_out_pct);
    firebox_door(firebox_door_open_deg);
}

// ───────────────────────────────
// Grill grate + Floor drains.
// v13 TASK 2: grill_grate()'s Z anchor DECOUPLED from the chamber body's
// own DATUM_GRATE_Z -- see GRATE_Z_FIXED's own mandatory comment right
// below. X/Y placement formulas (GRATE_MARGIN/grate_seg_l/GRATE_GAP/
// GRATE_Y0/GRATE_Y1/GRATE_LOCAL_H) are UNCHANGED CODE, per this task's own
// explicit DO NOT TOUCH -- see file header for the real, flagged
// consequence (GRATE_LOCAL_H still derives from DATUM_GRATE_Z, not
// GRATE_Z_FIXED, by explicit instruction).
// Floor drains UNCHANGED.
// ───────────────────────────────
// GRATE_Z_FIXED -- v13 TASK 2, NEW. *** TEMPORARY *** -- the grate's Z is
// intentionally DECOUPLED from the chamber body's own coordinate system
// this round (Janis's explicit call). Fixed at 1000mm, floating ~100mm
// above the reanchored apex A (GRATE_Z=900) with a real, currently-
// unsupported air gap -- expected, NOT a defect, matches the chamber's
// new position. Once the future reinforcement frame at chamber face A-B
// and the correspondingly shortened door are built (a later, separate
// session), the grate is intended to be RE-MERGED back into the chamber
// body's own coordinate system (i.e. this fixed constant should be
// revisited/removed at that time, formula reverted to DATUM_GRATE_Z-10 or
// equivalent) -- this is NOT permanent architecture, do not build further
// features assuming this decoupling is final.
GRATE_Z_FIXED = 1000;   // TEMPORARY, see comment above -- real grate-to-apex-A gap = 1000-900 = 100mm exactly
GRATE_MARGIN = 60;
GRATE_GAP = 8;
grate_usable_l = chamber_L - 2*GRATE_MARGIN;
grate_seg_l = (grate_usable_l - 2*GRATE_GAP) / 3;
GRATE_LOCAL_H = (DATUM_GRATE_Z - 10) - chamber_floor_z;   // 168.665mm (v13) -- UNCHANGED FORMULA, still keyed to DATUM_GRATE_Z (chamber's own apex-A datum), NOT GRATE_Z_FIXED, per this task's own explicit DO NOT TOUCH (see file header for the real consequence)
GRATE_Y_SAFETY = wall_t + 10;
GRATE_Y0 = (chamfer - GRATE_LOCAL_H) + GRATE_Y_SAFETY;   // 23mm (v13)
GRATE_Y1 = (chamber_W - chamfer + GRATE_LOCAL_H) - GRATE_Y_SAFETY;   // 587mm (v13)
module grill_grate() {
    for (i = [0:2])
        translate([DATUM_X_FRONT + GRATE_MARGIN + i*(grate_seg_l + GRATE_GAP), GRATE_Y0, GRATE_Z_FIXED - 10])
            cube([grate_seg_l, GRATE_Y1 - GRATE_Y0, 10]);
}
module floor_drains() {
    for (xp = [DATUM_X_FRONT + chamber_L/3, DATUM_X_FRONT + chamber_L*2/3])
        translate([xp, DATUM_Y_CENTER, chamber_floor_z - 30])
            cylinder(d = 25, h = 30 + wall_t + e);
}

// ───────────────────────────────
// DEBUG TOGGLES — module isolation, per rules-codes.md Rule M-4.
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
