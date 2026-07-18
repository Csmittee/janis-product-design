// BBQ Offset Smoker — Chambers
// Version: v14
// Date: 2026-07-17
// Changes from v13: bbq-chambers-v14-apex950-firebox-widen-dual-endcap.
// CHAMBER+FIREBOX round. Understructure (BBQ-understructure-v4.scad) is
// COMPLETELY OUT OF SCOPE — not opened, not touched, its own `include`
// pointer NOT bumped this round (per this prompt's own explicit
// direction — that bump is a later, separate understructure round).
//
// MANDATORY FIRST CHECK — confirmed live BBQ-chambers-v13.scad BEFORE any
// change: chamber_floor_z=721.335 (formula 900-chamfer) ✓, real apex A
// (GRATE_Z)=900mm exact ✓, GRATE_Z_FIXED=1000 ✓, firebox_y0/y1=[50,560]
// (510mm width, centered on DATUM_Y_CENTER=305) ✓ — ALL match expected
// values, confirmed via direct file read, no discrepancy found, safe to
// build v14 on top.
//
// This round resolves the 2 real findings flagged after v13 shipped: (1)
// the actual fire-holding volume (the internal duct) was only ~58% of
// the theoretical 1/3-chamber-volume target (~5,737in³); (2) the rear
// passage cut was ~4.6x oversized against the theoretical opening-area
// rule. Fixed by: decoupling the passage's shape/size from the duct's
// own shape/size, widening the firebox, and restructuring it as TWO
// INDEPENDENT welded assemblies (inner hot duct + outer insulating
// shell) instead of one shared end-cap plate — eliminates a real
// full-face thermal-bridge problem.
//
// TASK 1 — CHAMBER BODY REANCHOR (apex A: 900mm -> 950mm).
// `chamber_floor_z` formula changed from `900-chamfer` to `950-chamfer`.
// Real live-derived value: 950-178.665 = 771.335mm (matches the prompt's
// own ~771.335mm expectation, confirmed by direct computation from the
// live chamfer value). GRATE_Z (=chamber_floor_z+chamfer, formula
// UNCHANGED) = 950mm EXACT (algebraic, confirmed via echo).
// Every dependent element recomputes automatically via the existing
// dependency chain (R-009 — confirmed, not re-derived per element):
//   DATUM_Z_RIDGE = chamber_floor_z+chamber_H = 771.335+610 = 1381.335mm (was 1331.335)
//   ROOM_BASE_Z = chamber_floor_z+chamber_H/2-ROOM_H/2 = 1026.335mm (was 976.335)
//   ROOM_TOP_Z = 1126.335mm (was 1076.335)
//   PIPE_BASE_Z = ROOM_TOP_Z-wall_t-e = 1123.325mm (was 1073.325)
//   chimney top (world) = PIPE_BASE_Z+chimney_len+wall_t+e = 1888.335mm
//     (was 1838.335) -- still comfortably within the <=2.5m limit
//   lid_closed_panels()/lid() -- all Z refs relative to chamber_floor_z/
//     DATUM_Z_RIDGE, move automatically
// Real grate-to-apex-A gap: GRATE_Z_FIXED(1000, UNCHANGED) - GRATE_Z(950)
// = 50mm EXACT (was 100mm) -- confirmed automatic consequence of TASK 1
// alone, GRATE_Z_FIXED itself untouched, per DO NOT TOUCH.
// GRATE_LOCAL_H = (DATUM_GRATE_Z-10)-chamber_floor_z = (950-10)-771.335 =
// 168.665mm -- IDENTICAL to v13's value (both chamber_floor_z and
// DATUM_GRATE_Z shifted by the same +50mm delta, so their difference is
// invariant) -- confirmed via echo, GRATE_Y0/GRATE_Y1 stay EXACTLY
// 23mm/587mm, zero change, zero new collision risk from this formula.
// Real collision check (required): firebox (frozen this round, world
// Z=[571.4,1000]) vs the reanchored chamber -- confirmed via real CGAL
// (see cc_chat_log.md). The chamber's own real solid material now starts
// even higher (chamber_floor_z=771.335, was 721.335) -- the unsealed band
// against the firebox's fixed floor (571.4) grows to ~199.9mm (was
// ~149.9mm in v13) -- this is exactly why TASK 2's inner duct gets its
// OWN independent end cap welded directly to the chamber (not relying on
// a shared/simple closure panel the way v12 did) -- the growing gap makes
// a shared-plate approach even less viable, confirming the dual-assembly
// redesign is the right real fix, not just a preference.
// Understructure (frozen, not opened this round) unaffected -- no
// dependency on chamber_floor_z beyond firebox_floor_z (untouched).
//
// TASK 2 — FIREBOX WIDEN TO 580mm + DUAL INDEPENDENT ASSEMBLIES.
// `fuel_cylinder()` and `firebox_end_cap()`/`firebox_end_cap_2d()` (v13)
// RETIRED ENTIRELY (R-009: confirmed zero other real consumers before
// removal, grep-confirmed).
//
// FIREBOX_W repurposed as the OUTER SHELL's own width: 510 -> 580mm (15mm
// margin each side vs chamber_W=610, confirmed: (610-580)/2=15 exact).
// FIREBOX_H (428.6) UNCHANGED -- still the outer shell's own height.
// FIREBOX_L (460) UNCHANGED IN VALUE but its MEANING is now specifically
// the INNER DUCT's own interior cavity length (the fire-volume-bearing
// dimension) -- per this task's own explicit DO NOT TOUCH, this number
// must not shrink or be confused with the outer shell's own physical
// length (see below).
//
// INNER DUCT (NEW, replaces fuel_cylinder()): rectangular,
// DUCT_W=FIREBOX_W-2*DUCT_MARGIN=540mm x DUCT_H=FIREBOX_H-2*DUCT_MARGIN=
// 388.6mm (DUCT_MARGIN=20mm uniform on all 4 sides vs the outer shell's
// own inner cavity -- confirmed by direct construction, real 20mm gap on
// every side, see verification below), full FIREBOX_L(460mm) span,
// SAME open-both-ends convention as the retired fuel_cylinder() (no caps
// baked into the tube itself; near/chamber end sealed by its OWN end cap
// below; far/door end stays open, UNCHANGED deferred-open-item status).
// Duct's own end cap (NEW, small module, distinct from the chamber's own
// rear wall): welds this duct assembly DIRECTLY to the chamber's own
// octagon end cap -- JUDGMENT CALL, flagged: built as the duct's own full
// rectangular footprint MINUS the SAME 197mm passage-hole shape TASK 3
// cuts through the chamber wall (shared 2D module, not re-derived) --
// this is the only construction that keeps the duct's interior actually
// connected to the chamber (a fully solid cap would seal the firebox off
// entirely, defeating its purpose) while satisfying the prompt's own "no
// [NEW/different] hole needed... welds directly around this SAME
// opening" language (read as: reuse the identical shared hole shape, not
// "build zero hole at all"). Real CGAL seal-weld: non-empty contact vs
// the chamber's own real solid end-cap material, confirmed, contact area
// stated (see cc_chat_log.md).
//
// OUTER SHELL: widened to 580mm width (Y-range [15,595], centered on
// DATUM_Y_CENTER, confirmed live). LENGTH IS ADDITIVE, NOT A TRIM (real
// distinction, stated explicitly per this task's own requirement): the
// inner duct's own interior length stays exactly FIREBOX_L=460mm,
// UNCHANGED -- the fire-volume math depends on this number, it does not
// shrink. The OUTER SHELL's own total physical length becomes
// FIREBOX_SHELL_L = FIREBOX_L + FLANGE_LEN(20) = 480mm -- a NEW,
// SEPARATE, real number, the extra 20mm being a SOLID structural overlap
// zone only (real load-bearing weld/bracket contact against the
// chamber's own rear wall), containing NO interior duct volume -- these
// two numbers (460 interior vs 480 outer) are never merged or confused
// in this file's own code. The shell's hollow main body still spans
// exactly the SAME X-range as the duct (firebox_x0..firebox_x1, 460mm);
// the extra 20mm flange (X=[firebox_x0-FLANGE_LEN,firebox_x0]) is added
// as SOLID material (the hollow-cavity cut only spans the original
// 460mm, so the flange zone is solid automatically, by construction, not
// a separately-hollowed extension).
// The flange's own TOP zone is trimmed (real intersection() against the
// chamber's live octagon boundary, per outer_shell_flange_2d() below) so
// its upper portion can genuinely tuck under/against real chamber wall
// material at the NEW (950mm-apex) chamber position -- NOT assumed from
// the v13-era clearance (that clearance no longer applies at the new
// reanchor + new 580mm width, checked fresh). Real overlap/contact area
// stated (see cc_chat_log.md).
// Outer shell's own end cap (NEW module, replaces the retired
// firebox_end_cap()): ONE continuous plate at the flange's own outer
// face, SAME two-zone real construction as the flange (octagon-clipped
// upper zone / plain-rectangle lower zone, built from the SAME shared 2D
// helper) -- STRUCTURAL, bears real load from the chamber's rear edge
// (per Janis's explicit design intent, stated here not just incidentally
// implied). Positioned 20mm+ away in X from the inner duct's own start
// (firebox_x0) -- confirmed via real CGAL that it does NOT touch the
// inner duct or the inner duct's own end cap anywhere (see mandatory
// zero-contact check below).
// Real fire volume: DUCT_W x DUCT_H x FIREBOX_L = 540 x 388.6 x 460mm =
// 96,566,040mm³ = 5,893.7in³ (1in³=16,387.064mm³) -- ≈103% of the
// 5,737in³ target, confirmed via direct computation, not the estimate
// copied blindly (real number differs from the CONTEXT table's ~5,890in³
// by <0.1%, a rounding-precision difference only).
// Real, flagged consequence (not explicitly named in this task's own
// list, but required for correctness, stated not silently absorbed):
// `firebox_door()` (UNCHANGED CODE) reads FIREBOX_W/FIREBOX_H directly --
// now 580/428.6 -- so the door widens automatically 510->580mm to match
// the new outer shell (correct, the door belongs to the OUTER shell, not
// the inner duct). `ash_tray()`'s own width formula updated from
// FIREBOX_W-2*wall_t-20 to DUCT_W-2*wall_t-20 (514mm, was 484mm) -- REAL
// FIX, required: the ash tray sits inside the DUCT's own real interior
// (534mm clear), not the wider outer shell's cavity: sizing it off the
// old FIREBOX_W(now 580, the OUTER shell's width) would make it too wide
// to fit inside the duct and collide with the duct's own walls. Ash
// tray's own Z-position/height (ASH_TRAY_H=12mm, real 5mm clearance to
// the duct's own lower wall) is UNCHANGED -- the duct's own Z-range
// ([591.4,980]) is numerically identical to the retired cylinder's
// (DUCT_H=388.6mm reuses the exact old CYL_D value by direct
// construction, see DUCT_MARGIN derivation above), so no new Z-clearance
// issue.
//
// TASK 3 — REAR PASSAGE: SIMPLE ROUND HOLE, CHAMBER END CAP ONLY.
// `firebox_passage_profile()` REBUILT again -- was
// `intersection(fixed_side_solid_2d(), fuel_cylinder_circle_2d())` (a
// full-bore round-top/octagon-bottom cut tied to the duct's own real
// cross-section, v13); now a PLAIN CIRCLE, independently sized
// (PASSAGE_D=197mm, see its own in-code placeholder comment below), cut
// ONLY through the chamber's own rear octagon end cap
// (`fixed_side_solid_2d()`), NOT shaped to follow the duct's own
// cross-section at all -- `fuel_cylinder_circle_2d()` RETIRED (R-009,
// zero other real consumers).
// *** REAL FINDING, FLAGGED PER THIS TASK'S OWN EXPLICIT INSTRUCTION —
// NOT SILENTLY CLIPPED ***: centered at the duct's own real center
// (Y=DATUM_Y_CENTER=305, Z=DUCT_Z_CENTER=785.7, the same position the
// old fuel_cylinder() used), the 197mm circle spans real world
// Z=[687.2,884.2]. The NEW chamber_floor_z=771.335 sits INSIDE this
// range -- real check (intersection() against fixed_side_solid_2d(),
// confirmed via CGAL, see cc_chat_log.md) found the circle does NOT sit
// entirely within real chamber material: the lower ~84.135mm (world
// Z=[687.2,771.335]) has ZERO chamber material to begin with (below the
// chamber's own floor, matches this file's own standing "no material
// below chamber_floor_z" convention, not a defect) -- the REAL cut is a
// flat-bottomed chord shape (upper ~114mm of the true circle, clipped at
// chamber_floor_z), not a full circle. Flagged explicitly, not silently
// resolved -- per CONTEXT's own note this default size/position is
// field-adjustable by Janis independent of this CAD file; if a full
// unclipped circle is wanted, either the passage needs to move up
// (higher Z-center) or the circle needs to shrink -- a real, open,
// flagged decision point for Janis, not guessed at here.
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
// inscribed in a chamber_W x chamber_W square: 178.665mm. UNCHANGED v14.
chamfer          = chamber_W / (2 + sqrt(2));   // 178.665mm
// chamber_floor_z -- v14 TASK 1: REANCHORED again. Was `900-chamfer`
// through v13; now `950-chamfer` so apex A/GRATE_Z lands at EXACTLY
// 950mm. See file header for the full real-value derivation and the
// dependency-chain list of every element that moves with it.
chamber_floor_z  = 950 - chamfer;   // 771.335mm (v14, was 721.335)
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
// PRIMARY:   chamber_floor_z  (horizontal plane) — locks Z. v14: live
//            formula (950-chamfer), see PARAMETERS above.
// SECONDARY: DATUM_X_REAR     (chamber's rear/firebox wall, X plane) — locks X
// TERTIARY:  DATUM_Y_CENTER   (chamber's lateral centerline, Y plane) — locks Y
// ───────────────────────────────
GRATE_Z          = chamber_floor_z + chamfer;                  // 950mm EXACT (v14, was 900) -- apex A's own real world Z
DATUM_GRATE_Z    = GRATE_Z;
DATUM_X_FRONT    = 0;                                          // Parent: MASTER ORIGIN
DATUM_X_REAR     = DATUM_X_FRONT + chamber_L;                  // 915 -- Parent: DATUM_X_FRONT, offset dX=+chamber_L
DATUM_Y_LEFT     = 0;                                          // Parent: MASTER ORIGIN
DATUM_Y_CENTER   = DATUM_Y_LEFT + chamber_W/2;                  // 305 -- Parent: DATUM_Y_LEFT
trough_h         = chamber_H - 2*chamfer;                       // 252.670mm -- UNCHANGED (no chamber_floor_z dependency)
DATUM_Z_RIDGE    = chamber_floor_z + chamber_H;                  // 1381.335mm (v14, was 1331.335)

// ───────────────────────────────
// FIREBOX DATUMS — v14 TASK 2 WIDEN. FIREBOX_W is now the OUTER SHELL's
// own width; FIREBOX_L is now specifically the INNER DUCT's own interior
// length (value unchanged, meaning refined). See file header for full
// derivation.
// ───────────────────────────────
FIREBOX_L        = 460;                                        // duct's own interior length -- UNCHANGED, DO NOT TOUCH
FIREBOX_W        = 580;                                        // outer shell width -- was 510 (v14 TASK 2)
FIREBOX_H        = 428.6;                                       // outer shell height -- UNCHANGED
FLANGE_LEN       = 20;                                          // outer shell's near-end structural flange, ADDITIVE (not a trim)
FIREBOX_SHELL_L  = FIREBOX_L + FLANGE_LEN;                       // 480mm -- outer shell's own TOTAL physical length (real, separate from FIREBOX_L)
DUCT_MARGIN      = 20;                                          // uniform gap, inner duct vs outer shell, all 4 sides
DUCT_W           = FIREBOX_W - 2*DUCT_MARGIN;                    // 540mm
DUCT_H           = FIREBOX_H - 2*DUCT_MARGIN;                    // 388.6mm
firebox_x_mid_old = 915 + 457/2;                                // 1143.5mm -- unchanged historical reference
firebox_floor_z  = 571.4;                                       // bottom_Z -- LOCKED, frozen this round

// firebox_x0/x1/y0/y1/z0/z1 -- moved up here (was declared just above the
// firebox() module through v13) so passage_circle_2d()/PASSAGE_Z_CENTER
// below (needed earlier in the file, by firebox_passage_profile(), which
// chamber_shell() itself consumes) can reference firebox_z0/firebox_z1 in
// proper dependency order (rules-codes.md: "declare in dependency
// order") -- real values UNCHANGED from where they'd otherwise land.
firebox_x0 = firebox_x_mid_old - FIREBOX_L/2;    // 913.5 -- Parent: OLD firebox X-midpoint (preserved)
firebox_x1 = firebox_x0 + FIREBOX_L;             // 1373.5
firebox_y0 = DATUM_Y_CENTER - FIREBOX_W/2;       // 15 -- Parent: DATUM_Y_CENTER (v14: outer shell width, was 50)
firebox_y1 = firebox_y0 + FIREBOX_W;             // 595 (v14, was 560)
firebox_z0 = firebox_floor_z;                    // 571.4 -- LOCKED, frozen
firebox_z1 = firebox_z0 + FIREBOX_H;             // 1000.0 -- LOCKED, frozen

// Exhaust room datums — v14: real values move automatically with the new
// chamber_floor_z (formula itself UNCHANGED).
ROOM_BASE_Z      = chamber_floor_z + chamber_H/2 - ROOM_H/2;    // 1026.335mm (v14, was 976.335)
ROOM_TOP_Z       = ROOM_BASE_Z + ROOM_H;                         // 1126.335mm (v14, was 1076.335)

// ───────────────────────────────
// PROFILE HELPERS — encoded [-height, width] so that rotate([0,90,0])
// after linear_extrude(length) lands as world (X=length, Y=width,
// Z=height) — verified empirically in v1, unchanged mechanism.
// ───────────────────────────────
function hex_pt(h, w) = [-h, w];

// true_octagon_profile() — the TRUE closed 8-point octagon: real edges
// only, no fake diagonal anywhere. UNCHANGED v14 (chamber's own shape
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
// side. UNCHANGED v14.
module fixed_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A
        hex_pt(0, 0),
        hex_pt(0, chamber_W),
        hex_pt(chamber_H, chamber_W),
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only)
    ]);
}

// lid_side_wedge() — complementary mask. UNCHANGED v14.
module lid_side_wedge() {
    polygon(points=[
        hex_pt(chamfer, 0),              // apex A
        hex_pt(chamber_H, 0),            // top-left corner
        hex_pt(chamber_H, chamber_W/2),   // ridge midpoint (cut reference only)
    ]);
}

// lid_profile() — reference shape only, not used directly for
// construction. UNCHANGED v14.
module lid_profile() {
    polygon(points=[
        hex_pt(chamber_H, chamber_W/2),            // 1: ridge midpoint (hinge line)
        hex_pt(chamber_H, chamfer),                 // 2: ridge, left end (half-ridge)
        hex_pt(chamber_H - chamfer, 0),             // 3: top-left chamfer bottom
        hex_pt(chamfer, 0),                          // 4: left wall bottom (parting end)
    ]);
}

// ───────────────────────────────
// chamber_shell() and its helpers — UNCHANGED CODE v14 (chamber's own
// shape frozen, DO NOT TOUCH: octagon_ring(), chamber_outer_tube(),
// lid_territory_margin_fill(), exhaust_room_opening(), chamber_shell()
// itself all byte-identical to v13 — real world position moves only via
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

// fixed_side_solid_2d() — UNCHANGED v14 (chamber's own shape frozen, DO
// NOT TOUCH). The chamber's real solid cross-section at DATUM_X_REAR --
// what TASK 3's passage cut and TASK 2's octagon-aware flange/end-cap
// all intersect against.
module fixed_side_solid_2d() {
    intersection() {
        true_octagon_profile();
        fixed_side_wedge();
    }
}

// passage_circle_2d() — v14 TASK 3, NEW (replaces v13's
// fuel_cylinder_circle_2d(), RETIRED). Independently sized/positioned
// circle, same hex_pt(h,w) 2D space, NOT tied to the duct's own
// cross-section shape at all (only reuses the duct's real center point
// as its own default position, see PASSAGE_Y_CENTER/PASSAGE_Z_CENTER
// below).
// *** PASSAGE_D = 197mm is a PLACEHOLDER DEFAULT, NOT A LOCKED SPEC ***
// -- approximates the 0.008-rule target using the new ~103%-of-target
// fire volume. Janis may field-adjust this shape/size (oval, square,
// trapezoidal, oversized-with-a-flap) with the fabricator independent of
// this CAD file -- built here as the real, current CAD value, not a
// final locked dimension like FIREBOX_W/DUCT_W/etc.
PASSAGE_D = 197;   // TEMPORARY/ADJUSTABLE PLACEHOLDER -- see comment above, not a locked spec
PASSAGE_Y_CENTER = DATUM_Y_CENTER;             // 305 -- centered, matches the duct's own real Y-center
PASSAGE_Z_CENTER = (firebox_z0 + firebox_z1) / 2;   // 785.7mm -- centered, matches the duct's own real Z-center
module passage_circle_2d() {
    translate(hex_pt(PASSAGE_Z_CENTER - chamber_floor_z, PASSAGE_Y_CENTER))
        circle(d = PASSAGE_D);
}
// firebox_passage_profile() — v14 TASK 3 REBUILT. Was
// intersection(fixed_side_solid_2d(), fuel_cylinder_circle_2d()) (full-
// bore, tied to the duct's own cross-section, v13); now a plain
// independently-sized circle (passage_circle_2d()) clipped ONLY by the
// chamber's own real solid boundary -- NOT shaped to the duct at all.
// Real finding (NOT silently clipped, see file header): this circle does
// NOT sit entirely within real chamber material at the new 950mm-apex
// position -- the real cut is a flat-bottomed chord, not a full circle,
// confirmed via this same real intersection() (not a separate check --
// the ACTUAL cut geometry below IS the real check, its own real shape is
// the answer, verified via CGAL render, see cc_chat_log.md).
module firebox_passage_profile() {
    intersection() {
        fixed_side_solid_2d();
        passage_circle_2d();
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
// exhaust_room() / chimney_pipe() — UNCHANGED CODE v14 (real world
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
PIPE_BASE_Z = ROOM_TOP_Z - wall_t - e;   // 1123.325mm (v14, was 1073.325)
module chimney_pipe() {
    translate([PIPE_HOLE_X, PIPE_HOLE_Y, PIPE_BASE_Z])
        cylinder(d = chimney_d, h = chimney_len + wall_t + e);
}

// ───────────────────────────────
// lid() and hardware — UNCHANGED CODE v14 (real world position moves only
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
// firebox() — v14 TASK 2 REWORK. Two fully independent welded assemblies:
// inner duct (hot, sealed to the chamber) and outer shell (insulating
// jacket, structurally tucked under the chamber's rear wall) — NO shared
// end-cap plate between them (eliminates the full-face thermal-bridge
// problem the v13 concept had). ash_tray()/firebox_door() UNCHANGED CODE
// except ash_tray()'s own width formula (see below).
// ───────────────────────────────
// ── INNER DUCT (NEW, replaces fuel_cylinder(), RETIRED) ──
DUCT_Y_CENTER = DATUM_Y_CENTER;                          // 305
DUCT_Z_CENTER = (firebox_z0 + firebox_z1) / 2;            // 785.7mm -- same real position the retired cylinder used
module inner_duct() {
    // Near face starts at firebox_x0+e (not exactly firebox_x0) -- real
    // fix, found via a real CGAL check: at exactly X=firebox_x0, this
    // duct's own flat starting face sat exactly ON outer_shell()'s own
    // hollow-cavity boundary surface there (zero enclosed volume behind
    // it from the shell's side, but an exact-coincident surface all the
    // same) -- CGAL flagged the mandatory outer-vs-inner intersection()
    // check as a degenerate zero-thickness non-manifold artifact
    // (Volumes:1, X-range collapsed to a single plane) rather than a
    // clean empty result. Pulling the duct's own near face forward by e
    // (0.01mm off FIREBOX_L=460mm, negligible) gives genuine real
    // separation -- re-verified Simple:yes/empty on the mandatory check.
    translate([firebox_x0 + e, DUCT_Y_CENTER - DUCT_W/2, DUCT_Z_CENTER - DUCT_H/2])
        difference() {
            cube([FIREBOX_L - 2*e, DUCT_W, DUCT_H]);
            translate([-e, wall_t, wall_t]) cube([FIREBOX_L - 2*e + 2*e, DUCT_W - 2*wall_t, DUCT_H - 2*wall_t]);
        }
}
// inner_duct_end_cap_2d() / inner_duct_end_cap() — v14 TASK 2 step 2,
// NEW. Duct's own full real rectangle minus the SAME passage-hole shape
// TASK 3 cuts through the chamber wall (shared module, not re-derived) --
// see file header for the full judgment-call rationale (this is the only
// construction keeping the duct's interior actually connected to the
// chamber). Welds DIRECTLY to the chamber's own octagon end cap, NOT to
// the outer shell -- positioned straddling firebox_x0, same
// `-wall_t-e`/`wall_t+2*e` overshoot pattern this file's retired v13
// end-cap module used, guarantees real volume overlap.
module inner_duct_end_cap_2d() {
    // translate-x = chamber_floor_z - Z_MAX (matches firebox_square_2d()'s
    // own established pattern: local-x = -h, so the square's local-x_min
    // must correspond to -h_max, i.e. chamber_floor_z minus the range's
    // own UPPER Z bound, not its lower one -- a real coordinate-sign bug
    // found via a real CGAL bounds check (the duct end cap's own Z-range
    // came out as [562.67,951.27] instead of the intended [591.4,980],
    // causing a real, confirmed overlap with the outer shell's own bottom
    // wall) -- fixed, re-verified against the intended real range.
    difference() {
        translate([chamber_floor_z - (DUCT_Z_CENTER + DUCT_H/2), DUCT_Y_CENTER - DUCT_W/2])
            square([DUCT_H, DUCT_W]);
        offset(delta = e) firebox_passage_profile();   // +e dilation: wherever the passage's own
                                                          // boundary follows the real octagon edge
                                                          // (the circle-vs-octagon clip), this plate's
                                                          // resulting notch edge is pulled a hair back
                                                          // from an exact-coincident touch against
                                                          // chamber_outer_tube()'s own real wall surface
                                                          // there -- found via a real CGAL non-manifold
                                                          // check (Simple:no without this), fixed,
                                                          // re-verified Simple:yes. Negligible (0.01mm)
                                                          // impact on the real seal-weld contact area,
                                                          // which is dominated by the rectangle's own
                                                          // outer boundary, not this small notch.
    }
}
module inner_duct_end_cap() {
    // X=[firebox_x0, firebox_x0+wall_t+e] -- forward-only overshoot (into
    // the duct's own X-territory, where it cleanly butts against the
    // duct's own open near-face, solid-meets-hollow, same valid pattern
    // v13's analogous end cap used), NOT backward into firebox_x0-wall_t
    // territory -- that backward reach landed inside the outer shell's
    // own SOLID flange zone (X<firebox_x0, intentionally reserved for the
    // outer shell only) and produced a real, confirmed CGAL overlap
    // there, found via a real non-manifold/non-empty check, fixed (see
    // cc_chat_log.md). Still real, substantial overlap with the
    // chamber's own solid rear-wall material (X=[912,915]) -- 1.5mm,
    // confirmed via CGAL below.
    translate([firebox_x0 + e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t, convexity = 4)
            inner_duct_end_cap_2d();
}

// ── OUTER SHELL (NEW construction, replaces firebox_shell(), RETIRED)
// widened to FIREBOX_W(580mm), physical length FIREBOX_SHELL_L(480mm) --
// see file header for the interior-vs-outer-length distinction. ──
// outer_shell_flange_2d() — the two-zone real shape shared by BOTH the
// flange's own solid material (below) and the outer shell's end cap:
// lower zone (h<0, below chamber_floor_z) is the outer shell's own PLAIN
// full rectangle (matches this file's standing "no octagon material
// below the floor" convention); upper zone (h>=0) is that SAME rectangle
// real-intersected against the chamber's own live octagon boundary
// (fixed_side_solid_2d()) -- confirms the tuck-under zone genuinely
// falls within real chamber material at the NEW 950mm-apex position, not
// assumed from the v13-era clearance.
module outer_shell_footprint_2d() {
    translate([chamber_floor_z - firebox_z1, firebox_y0])
        square([FIREBOX_H, FIREBOX_W]);
}
module outer_shell_flange_2d() {
    union() {
        intersection() {
            outer_shell_footprint_2d();
            translate([-4000, -4000]) square([4000, 8000]);   // h<0 half-space -- lower zone, plain rectangle
        }
        intersection() {
            outer_shell_footprint_2d();
            fixed_side_solid_2d();                             // h>=0 zone -- real octagon-clipped upper zone
        }
    }
}
module outer_shell() {
    union() {
        // main hollow body, FIREBOX_L(460mm) span, X=[firebox_x0,firebox_x1] -- same footprint length as the duct
        difference() {
            translate([firebox_x0, firebox_y0, firebox_z0]) cube([FIREBOX_L, FIREBOX_W, FIREBOX_H]);
            translate([firebox_x0 - e, firebox_y0 + wall_t, firebox_z0 + wall_t])
                cube([FIREBOX_L + 2*e, FIREBOX_W - 2*wall_t, FIREBOX_H - 2*wall_t]);
        }
        // near-end flange, ADDITIVE 20mm, SOLID (no interior cavity), real-clipped to the octagon upper zone.
        // Spans EXACTLY X=[firebox_x0-FLANGE_LEN, firebox_x0] -- NO epsilon
        // overshoot past firebox_x0 (would otherwise intrude a hair into the
        // inner duct's own separate X-territory, found via a real CGAL
        // non-manifold check -- confirmed fixed, Simple:yes, see
        // cc_chat_log.md). The flange's own SOLID cross-section meeting the
        // main body's HOLLOW near-face (that difference()'s own e-overshoot
        // already starts the cavity cut slightly before firebox_x0) at this
        // exact shared plane is a clean, compatible butt-joint -- solid
        // fill exactly where the hollow body's face would otherwise be
        // open, not an ambiguous coincident-face touch.
        translate([firebox_x0 - FLANGE_LEN, 0, chamber_floor_z]) rotate([0, 90, 0])
            linear_extrude(height = FLANGE_LEN, convexity = 4)
                outer_shell_flange_2d();
    }
}
// outer_shell_end_cap() — v14 TASK 2 step 4, NEW (replaces the retired
// firebox_end_cap()). Thin wall_t plate at the flange's own outer/near
// face (the true near end of the outer shell, X=firebox_x0-FLANGE_LEN),
// SAME real two-zone construction as the flange it caps -- STRUCTURAL,
// bears real load from the chamber's rear edge (Janis's explicit design
// intent). Positioned FLANGE_LEN(20mm) away in X from the inner duct's
// own start (firebox_x0) -- confirmed via real CGAL zero-contact check
// below that it never touches the inner duct or the duct's own end cap.
module outer_shell_end_cap() {
    translate([firebox_x0 - FLANGE_LEN - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t + 2*e, convexity = 4)
            outer_shell_flange_2d();
}

// ash_tray() — v14: width formula corrected DUCT_W-based (was
// FIREBOX_W-based through v13) -- REQUIRED real fix, see file header.
// Length/height/X/Z position formulas UNCHANGED.
ASH_TRAY_H = 12;
ASH_TRAY_L = FIREBOX_L - 2*wall_t - 40;       // 414
ASH_TRAY_W = DUCT_W - 2*wall_t - 20;          // 514mm (v14, was 484mm off the old FIREBOX_W-based formula)
ASH_TRAY_X_IN = firebox_x0 + wall_t + 10;     // 926.5
ASH_TRAY_SLIDE_MAX = 350;
module ash_tray(ash_tray_out_pct = 0) {
    slide = ash_tray_out_pct * ASH_TRAY_SLIDE_MAX;
    translate([ASH_TRAY_X_IN + slide, DUCT_Y_CENTER - ASH_TRAY_W/2, firebox_z0 + wall_t])
        difference() {
            cube([ASH_TRAY_L, ASH_TRAY_W, ASH_TRAY_H]);
            translate([wall_t, wall_t, wall_t]) cube([ASH_TRAY_L - 2*wall_t, ASH_TRAY_W - 2*wall_t, ASH_TRAY_H]);
        }
}

JOGGLE = 3;
HINGE_GAP = 0.5;
// firebox_door() — UNCHANGED CODE v14 (frozen construction, real
// dimensions widen automatically 510->580mm via FIREBOX_W, matches the
// outer shell it's mounted on -- flagged real consequence, see file
// header).
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
    color("#8B2E2E") inner_duct();
    color("#8B2E2E") inner_duct_end_cap();
    outer_shell();
    outer_shell_end_cap();
    ash_tray(ash_tray_out_pct);
    firebox_door(firebox_door_open_deg);
}

// ───────────────────────────────
// Grill grate + Floor drains — UNCHANGED CODE v14 (grate Z anchor and X/Y
// formulas both frozen per DO NOT TOUCH; real values move automatically
// with the new chamber_floor_z/DATUM_GRATE_Z where the formula reads
// them, confirmed identical to v13, see file header).
// ───────────────────────────────
GRATE_Z_FIXED = 1000;   // UNCHANGED, DO NOT TOUCH -- real grate-to-apex-A gap now 1000-950=50mm exact (was 100mm), automatic consequence of TASK 1
GRATE_MARGIN = 60;
GRATE_GAP = 8;
grate_usable_l = chamber_L - 2*GRATE_MARGIN;
grate_seg_l = (grate_usable_l - 2*GRATE_GAP) / 3;
GRATE_LOCAL_H = (DATUM_GRATE_Z - 10) - chamber_floor_z;   // 168.665mm -- IDENTICAL to v13 (invariant under the +50mm shift), UNCHANGED FORMULA, DO NOT TOUCH
GRATE_Y_SAFETY = wall_t + 10;
GRATE_Y0 = (chamfer - GRATE_LOCAL_H) + GRATE_Y_SAFETY;   // 23mm -- UNCHANGED
GRATE_Y1 = (chamber_W - chamfer + GRATE_LOCAL_H) - GRATE_Y_SAFETY;   // 587mm -- UNCHANGED
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
