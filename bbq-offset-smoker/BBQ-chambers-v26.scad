// BBQ Offset Smoker — Chambers
// Version: v26
// Date: 2026-07-30
// Source: BBQ-chambers-v25.scad
//
// Real octagon smoke chamber (true_octagon_profile()), fixed/lid split
// along the ridge (RIDGE_SPLIT_Y) and the A-B wall (NEW_SPLIT_Z), the
// firebox/inner duct assembly with its own hinged door
// (firebox_door_open_deg), the exhaust room + chimney, and the shared
// lid hinge pivot (HINGE_PIVOT_Y/HINGE_PIVOT_Z) that
// BBQ-offset-smoker-base-v12.scad's own rib assembly reads live so the
// lid shell and the 3 ribs rotate about the exact same center. Full
// round-by-round history of every prior chamber/firebox/ridge redesign
// (v1 through v25 — the fire-cylinder-to-duct conversion, the ridge
// split becoming a real tunable parameter, the -100mm grate level drop,
// the flange/end-cap rework, etc.) lives in cc_chat_log.md, not here, so
// this header always matches the live code instead of drifting into a
// stale narrative.
//
// lid_open_deg (below) is this file's own standalone-render default —
// when rendering the FULL assembly, BBQ-offset-smoker-base-v12.scad's
// own door_open_deg is the real driver (passed as an explicit argument
// to lid()); BBQ-offset-smoker-base-v12.scad suppresses this file's own
// internal lid() draw via show_lid=false so there is only ever one lid
// drawn, never two.

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

// GRATE_Z -- v22 TASK 1: RESTORED as the project's real MASTER/reference
// datum, per Janis's own explicit statement this session: this is how
// the original Skeleton file/scope of work always intended it. A prior
// (v13-era) session temporarily INVERTED this under time pressure --
// pinned the grate independently as `GRATE_Z_FIXED` (declared much later
// in this file, near `grill_grate()`) and pushed `chamber_floor_z` to a
// hardcoded `950-chamfer` literal to compensate -- that workaround is
// undone now, not re-litigated as a new design question. RENAMED from
// `GRATE_Z_FIXED` (its own old name, "TEMPORARY... decoupled from the
// chamber body" per that variable's own v13-era comment) -- it is no
// longer temporary or decoupled, this IS the real anchor everything else
// derives from. Moved here (before `chamber_floor_z`, which now depends
// on it) per rules-codes.md "declare in dependency order".
GRATE_Z = 900;   // v22 TASK 2: 1000->900, the real -100mm level drop (see file header)
// APEX_A_Z -- v22 TASK 1: RENAMED from this file's own old `GRATE_Z`
// variable (which was actually apex A's real value, misleadingly
// sharing the grate's own name) -- now a real live formula off the
// restored master, was previously computed FROM `chamber_floor_z`
// (backwards from original intent, the exact inversion being undone).
// The 50mm grate/apex-A relationship itself is UNCHANGED, only which
// side is master flips back.
APEX_A_Z = GRATE_Z - 50;   // 950mm at current GRATE_Z=1000 (v22 TASK 2 recomputes to 850 automatically, zero separate edit)

// chamber_floor_z -- v22 TASK 1: re-derived from the restored master
// (was a hardcoded `950-chamfer` literal, the v13-era workaround's own
// direct consequence). Real, live formula now; identical value at
// GRATE_Z=1000 (771.335mm), confirmed pixel-identical to v21 before
// TASK 2 changes GRATE_Z.
chamber_floor_z  = APEX_A_Z - chamfer;   // 771.335mm at current APEX_A_Z=950 (v14 comment history: was 900-chamfer through v13, then 950-chamfer literal v14-v21)
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
// DATUM_GRATE_Z -- v22 TASK 1: re-pointed to `APEX_A_Z` (this file's own
// real apex-A value, restored master chain above) -- SAME real value as
// before (950 at current settings), only its own upstream source
// changed. Real consumer confirmed: `GRATE_LOCAL_H` below, which uses
// this as a local-height reference for the octagon's own real width at
// (roughly) apex-A level -- that relationship is UNCHANGED, DO NOT
// TOUCH, per the parting-line round's own DO NOT TOUCH list.
DATUM_GRATE_Z    = APEX_A_Z;

// ───────────────────────────────
// v21 TASK 1 -- LID/FIXED PARTING LINE SHIFT, Y=0 SIDE ONLY. Real
// requirement (Janis, via the tray-relocation ask): the lid's own opening
// material starts 50mm higher, at world Z=1000mm (== GRATE_Z_FIXED,
// confirmed below as a real algebraic coincidence, NOT built by reference
// to it -- the two are independently-defined values that happen to land
// on the same number). The reclaimed 50mm band becomes genuine FIXED
// material -- real structural weld base for the relocated tray's hinges
// (TASK 2, BBQ-offset-smoker-base-v2.scad). Chamber datums (apex A=950,
// chamber_floor_z, chamfer, chamber body) all UNCHANGED -- only the
// fixed/lid MATERIAL split moves, confirmed no chamber datum itself moves.
// v22 TASK 1 UPDATE: `OLD_SPLIT_Z` re-pointed to `APEX_A_Z` (was `GRATE_Z`
// before this round's rename -- that name now means the real grate
// master, a DIFFERENT value; `OLD_SPLIT_Z`'s own real meaning was always
// "apex A", so it now reads the correctly-renamed `APEX_A_Z` variable,
// same real value, zero behavior change). REAL FINDING, stated not
// silently absorbed: given `NEW_SPLIT_Z = OLD_SPLIT_Z + 50 = (GRATE_Z-50)
// + 50 = GRATE_Z` algebraically, `NEW_SPLIT_Z` is now an EXACT identity
// with the restored master `GRATE_Z`, not merely a numeric coincidence at
// current values as the v21-era comment below assumed -- true for ANY
// future `GRATE_Z` value, a direct consequence of this round's own
// grate/apex-A 50mm relationship and the parting-line's own +50mm shift
// sharing the same real 50mm literal. Nothing to fix here, just a fact
// worth stating (per this project's own verification discipline).
// ───────────────────────────────
PARTING_SHIFT  = 50;                                    // Janis's own real spec, via the tray-relocation ask
OLD_SPLIT_Z    = APEX_A_Z;                               // 950mm at current settings -- was apex A, the ONLY split point through v20
NEW_SPLIT_Z    = OLD_SPLIT_Z + PARTING_SHIFT;            // 1000mm at current settings -- real, live-computed. Now an EXACT algebraic identity with GRATE_Z (see note above), not just a coincidence
NEW_SPLIT_H    = NEW_SPLIT_Z - chamber_floor_z;          // 228.665mm (local h) -- real point ON the true_octagon_profile()'s own existing left-wall edge (between point 3 apex A[h=chamfer=178.665] and point 4 top-left-corner[h=chamber_H-chamfer=431.335]), confirmed 178.665 < 228.665 < 431.335
DATUM_X_FRONT    = 0;                                          // Parent: MASTER ORIGIN
DATUM_X_REAR     = DATUM_X_FRONT + chamber_L;                  // 915 -- Parent: DATUM_X_FRONT, offset dX=+chamber_L
DATUM_Y_LEFT     = 0;                                          // Parent: MASTER ORIGIN
DATUM_Y_CENTER   = DATUM_Y_LEFT + chamber_W/2;                  // 305 -- Parent: DATUM_Y_LEFT
trough_h         = chamber_H - 2*chamfer;                       // 252.670mm -- UNCHANGED (no chamber_floor_z dependency)
DATUM_Z_RIDGE    = chamber_floor_z + chamber_H;                  // 1381.335mm (v14, was 1331.335)

// v25 NEW: ridge (C-D face) fixed/lid split, now a REAL tunable design
// param instead of the old hardcoded chamber_W/2 (= coincidentally same
// value as DATUM_Y_CENTER = 305). Moved closer to apex C per Janis's
// explicit instruction ("Adjust the top door trim line on CD plane to be
// shorter, more closer to C apex - this will help you make the hinge stay
// closer to C as much as possible"). Used in exactly 4 places (R-009
// checked): fixed_side_wedge(), lid_side_wedge(), lid_closed_panels()'s
// ridge-cap panel width, and lid()'s own rotation point.
// DATUM_Y_CENTER itself is UNCHANGED and still used for its own unrelated
// purposes (exhaust_room()/chimney_pipe() PIPE_HOLE_Y etc.) -- do not
// confuse the two.
// RIDGE_SPLIT_Y -- v25 2nd pass: 30mm -> 64mm from apex C, per Janis's
// own real chosen part: a UCP204-12 pillow block bearing (3/4" bore),
// whose own real "H0" spec dimension is 64mm -- Janis's own explicit
// instruction reuses that same real number both as the rc-to-rcs
// (door-side arm to pivot) length AND as this parting line's own
// distance from apex C. NOT re-derived by cc, executed literally.
RIDGE_SPLIT_Y    = chamfer + 64;                                // 242.665mm -- 64mm from apex C along the ridge, real UCP204-12 H0 dimension, Janis's own explicit instruction

// HINGE_PIVOT_Y/Z -- v26 NEW: the REAL, SHARED rotation center for both
// the lid (this file's own lid() below) and the rib assembly
// (BBQ-offset-smoker-base-v9.scad's own FC). Janis's own direct,
// hands-on calculation, overriding every prior pivot guess in this
// project's own history: the hinge bracket itself mounts OUTSIDE the
// door's own real operating length (X < LID_X0 or X > LID_X1, the "end
// margin zone" -- see docs/lid-hinge-counterbalance-calc.md), where the
// CD face is ALWAYS fixed material regardless of Y/Z, since no door
// exists there at all. This is what finally makes it safe to place the
// bearing's own Y EXACTLY on RIDGE_SPLIT_Y (no gap) -- earlier rounds
// this session tried to keep the pivot "safely" offset from the door's
// own edge while still living INSIDE the door's own X-span, which is a
// fundamentally different (and much harder) problem. `HINGE_PIVOT_RISE`
// is the real UCP204-12 "H0" spec dimension (64mm), same real number
// already used for `RIDGE_SPLIT_Y` above.
// CRITICAL, real consequence, per Janis's own direct instruction: since
// the lid's own rotation center HERE now exactly matches the rib
// assembly's own pivot (both share `HINGE_PIVOT_Y`/`HINGE_PIVOT_Z`), the
// lid and the ribs rotate together about the SAME point -- their
// relative geometry is therefore IDENTICAL at every angle 0-90°, by
// construction, not by a tuned standoff. This retires the entire class
// of "sink into the door" / "float above the door" bugs this session
// spent many rounds chasing (BBQ-offset-smoker-base-v8.scad's own
// header/docs/lid-hinge-counterbalance-calc.md Section 13 for the full,
// honest history of that struggle) -- not because any specific standoff
// number was finally right, but because the underlying two-different-
// rotation-centers setup that caused the drift no longer exists.
HINGE_PIVOT_RISE = 64;                                          // mm -- real UCP204-12 H0 spec dimension
HINGE_PIVOT_Y    = RIDGE_SPLIT_Y;                                // 242.665mm -- exactly on the parting line, safe because the real hinge bracket mounts outside the door's own X-span
HINGE_PIVOT_Z    = DATUM_Z_RIDGE + HINGE_PIVOT_RISE;             // 1345.34mm -- echo()-verified 2026-07-31, corrects a stale 1445.335mm comment that never matched the live computed value

// ───────────────────────────────
// FIREBOX DATUMS — v15 TASK 1/2: outer shell rebuilt as a true cube, inner
// duct replaced by a cylinder. FIREBOX_W stays the OUTER SHELL's own
// width (UNCHANGED); FIREBOX_L is now the FIRE CYLINDER's own interior
// depth (580mm, was 460mm); FIREBOX_H is the outer shell's own height
// (580mm, was 428.6mm) -- all three now equal, a true cube. See file
// header for full derivation.
// ───────────────────────────────
FIREBOX_L        = 580;                                        // v15: fire cylinder's own interior depth -- was 460mm (rectangular duct's own length)
FIREBOX_W        = 580;                                        // outer shell width -- UNCHANGED since v14 TASK 2
FIREBOX_H        = 580;                                        // v15 TASK 1: outer shell height -- was 428.6mm, now equal to W/L (true cube)
FLANGE_LEN       = 50;                                          // v16 TASK D: 20->50mm (Janis's explicit spec -- stronger structural tuck-under support). ADDITIVE (not a trim), formula below UNCHANGED
FIREBOX_SHELL_L  = FIREBOX_L + FLANGE_LEN;                       // 630mm (v16, was 600mm) -- outer shell's own TOTAL physical length (real, separate from FIREBOX_L, which stays 580mm -- FLANGE_LEN is a pure extension, confirmed additive by this same UNCHANGED formula)
WALL_CLEARANCE   = 62;                                          // v15 TASK 2: fire cylinder's own uniform wall clearance, all sides -- Janis's own explicit choice, real OPEN AIR gap this round
CYL_D            = FIREBOX_W - 2*WALL_CLEARANCE;                 // 456mm -- fire cylinder diameter
CYL_R            = CYL_D / 2;                                    // 228mm
// FIREBOX_TOP_Z_FIXED -- v15: the firebox's own real fixed Z datum is now
// the TOP (1000mm, UNCHANGED since v12 -- was previously an automatic
// derived consequence of firebox_floor_z+FIREBOX_H; TASK 1 makes it the
// deliberate anchor instead, since FIREBOX_H itself is what's changing
// this round, not the top). v22 TASK 1 REAL FIX, found during the
// Mandatory First Check's own consumer sweep: this was an INDEPENDENT
// hardcoded literal (1000), never actually wired to the chamber's own
// master datum chain -- it only numerically happened to equal the old
// `GRATE_Z_FIXED` (also 1000) by coincidence. Left as a bare literal, the
// firebox would NOT have moved with TASK 2's -100mm drop (staying at
// world Z=1000 while the rest of the assembly dropped to 900), breaking
// the "entire chamber+firebox assembly" requirement. FIX: re-pointed to
// the restored master `GRATE_Z` directly -- a real, stale hardcoded copy
// corrected, not a new dependency invented.
FIREBOX_TOP_Z_FIXED = GRATE_Z;
firebox_floor_z  = FIREBOX_TOP_Z_FIXED - FIREBOX_H;              // 420mm (v15 TASK 1, was 571.4mm literal) -- real, live formula

// firebox_x0/x1/y0/y1/z0/z1 -- moved up here (was declared just above the
// firebox() module through v13) so passage_circle_2d()/PASSAGE_Z_CENTER
// below (needed earlier in the file, by firebox_passage_profile(), which
// chamber_shell() itself consumes) can reference firebox_z0/firebox_z1 in
// proper dependency order (rules-codes.md: "declare in dependency
// order") -- real values UNCHANGED from where they'd otherwise land.
// firebox_x0 -- v15 REAL FIX (see file header): pinned DIRECTLY at its own
// real weld-overlap position (913.5mm, the SAME value every version
// through v14.2 has actually built at) instead of derived from the old
// `firebox_x_mid_old` historical-midpoint formula (RETIRED, R-009 --
// that formula only worked by coincidence while FIREBOX_L never changed;
// growing FIREBOX_L under it would have pulled firebox_x0 60mm INTO the
// main chamber's own real X-territory, a genuine new conflict risk).
firebox_x0 = 913.5;                              // Parent: chamber's own real rear-wall weld-overlap position, UNCHANGED value since v12
firebox_x1 = firebox_x0 + FIREBOX_L;             // 1493.5 (v15, was 1373.5) -- all +120mm growth happens here, away from the chamber
firebox_y0 = DATUM_Y_CENTER - FIREBOX_W/2;       // 15 -- Parent: DATUM_Y_CENTER (v14: outer shell width, was 50)
firebox_y1 = firebox_y0 + FIREBOX_W;             // 595 (v14, was 560)
firebox_z0 = firebox_floor_z;                    // 420 (v15, was 571.4)
firebox_z1 = firebox_z0 + FIREBOX_H;             // 1000.0 -- matches FIREBOX_TOP_Z_FIXED exactly, confirms consistency
// Fire cylinder's own real center -- Y shared with the chamber's own
// lateral center (UNCHANGED), Z real-computed off the new firebox_z0/z1.
CYL_Y_CENTER = DATUM_Y_CENTER;                   // 305
CYL_Z_CENTER = (firebox_z0 + firebox_z1) / 2;    // 710mm (v15, was 785.7mm under the old rectangular duct)

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
// side. v21 TASK 1: real modification, NOT a brand-new independent cut --
// this is the SAME construction (chamber_outer_tube() = octagon_ring() ∩
// this extruded wedge) every prior round has used, with its own first
// vertex moved from apex A up to the new real split point (NEW_SPLIT_H,
// on the SAME w=0 wall edge) so the diagonal parting-line cut now starts
// 50mm higher. Real, automatic consequence: the true_octagon_profile()'s
// own real wall material between apex A and the new split point (world
// Z=[950,1000], full chamber_L length, since chamber_outer_tube() extrudes
// the whole length) is now included as FIXED by the SAME mechanism that
// already builds every other fixed surface -- reuses the locked
// construction, per R-014, no new insert/union needed.
module fixed_side_wedge() {
    polygon(points=[
        hex_pt(NEW_SPLIT_H, 0),          // v21: new fixed-zone top edge on the Y=0 side (was apex A)
        hex_pt(0, 0),
        hex_pt(0, chamber_W),
        hex_pt(chamber_H, chamber_W),
        hex_pt(chamber_H, RIDGE_SPLIT_Y),   // v25: ridge split, was chamber_W/2 -- now a real tunable line, moved closer to apex C
    ]);
}

// lid_side_wedge() — complementary mask. v21 TASK 1: same real edit as
// fixed_side_wedge() above (first vertex moved to NEW_SPLIT_H) -- the two
// masks stay exact complements by construction (both built from the same
// 3 real points: NEW_SPLIT_H/top-left-corner/ridge-midpoint), so
// lid_territory_margin_fill() (which uses this module directly, UNCHANGED
// code) automatically shrinks to match, zero separate edit needed there.
module lid_side_wedge() {
    polygon(points=[
        hex_pt(NEW_SPLIT_H, 0),          // v21: was apex A
        hex_pt(chamber_H, 0),            // top-left corner -- UNCHANGED, real octagon corner, not itself moving
        hex_pt(chamber_H, RIDGE_SPLIT_Y),   // v25: ridge split, was chamber_W/2 -- same real point as fixed_side_wedge()'s own, complements stay exact
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

// chamber_octagon_or_open_below_2d() — v16 NEW, shared by TASK A/B/C. Real
// mask: for h>=0 (world Z>=chamber_floor_z, real chamber territory) follows
// true_octagon_profile() exactly; for h<0 (below the chamber entirely, no
// real chamber reference exists) is fully open (a large solid fill, so
// intersecting anything against this mask leaves h<0 geometry unclipped).
// Built as a union of the real octagon polygon with a big rectangle over
// the h<0 half-plane (full w range plus margin, so it can never itself be
// the binding edge) — a single 2D mask usable directly in intersection().
module chamber_octagon_or_open_below_2d() {
    union() {
        true_octagon_profile();
        translate([0, -1000]) square([2000, chamber_W + 2000]);
    }
}

// firebox_passage_profile() — v16 TASK A REBUILT (Janis's direct feedback:
// v15's own plain circle, sized purely from the fire cylinder's own
// 0.008-fire-volume target-area rule, ignored how much real chamber
// material actually exists at the passage -- see file header for the full
// real diagnosis: 33.233mm of the v15 circle's own bottom had ZERO real
// chamber material behind it, a genuine "hole through nothing"). FIX:
// size/position now DERIVED from the real vertical band where the fire
// cylinder's own clear bore actually overlaps the chamber's real octagon
// material at DATUM_X_REAR, not from an independent area formula.
CYL_WALL_MARGIN     = 15;   // real margin kept clear of the fire cylinder's own bore wall -- Janis's "Dont cut too near to edge of cylinder wall", judgment call on the exact mm, flagged
CHAMBER_EDGE_MARGIN = 15;   // real margin kept clear of the chamber's own real floor/no-material boundary -- judgment call on the exact mm, flagged
cyl_top_z        = CYL_Z_CENTER + CYL_R;                          // 938mm (world Z) -- fire cylinder's own real top
cyl_clear_bore_r = CYL_D / 2 - wall_t;                             // 225mm -- fire cylinder's own real clear interior radius
// Real overlap band -- where the cylinder's own clear interior AND the
// chamber's own real material (h>=0) both actually exist:
PASSAGE_BAND_TOP_WORLD = cyl_top_z - CYL_WALL_MARGIN;              // 923mm
PASSAGE_BAND_BOT_WORLD = chamber_floor_z + CHAMBER_EDGE_MARGIN;    // 786.335mm
PASSAGE_BAND_H         = PASSAGE_BAND_TOP_WORLD - PASSAGE_BAND_BOT_WORLD;   // 136.665mm
PASSAGE_Y_CENTER = CYL_Y_CENTER;                                   // 305, UNCHANGED
PASSAGE_Z_CENTER_WORLD = (PASSAGE_BAND_TOP_WORLD + PASSAGE_BAND_BOT_WORLD) / 2;   // 854.6675mm
// PASSAGE_R -- the real candidate radius: half the usable band (so the
// candidate circle's own vertical extent already fits within real material
// without needing the intersection below to do any clipping at all -- the
// SAME real intersection is still applied, belt-and-suspenders, so a future
// parameter change can never silently reopen the v15 defect).
PASSAGE_R_BAND = PASSAGE_BAND_H / 2;                               // 68.3325mm
// Real cylinder-wall clearance check, live not assumed: distance from the
// cylinder's own center to the passage's own farthest point must clear
// cyl_clear_bore_r by CYL_WALL_MARGIN. Confirmed via echo below this
// module: passage center is 144.665mm off cylinder center (Z only), +
// PASSAGE_R_BAND(68.3325) = 212.9975mm, vs cyl_clear_bore_r-CYL_WALL_MARGIN
// (225-15=210mm) -- 212.9975 > 210, so PASSAGE_R_BAND itself is the tighter
// constraint here (the vertical-band cap), take the min of both real caps.
PASSAGE_R_CYL_CAP = (cyl_clear_bore_r - CYL_WALL_MARGIN) - abs(PASSAGE_Z_CENTER_WORLD - CYL_Z_CENTER);   // 65.335mm -- real, binding
PASSAGE_R = min(PASSAGE_R_BAND, PASSAGE_R_CYL_CAP);                // 65.335mm real final radius
// hex_pt(h,w)'s own "h" is an OFFSET from chamber_floor_z (this profile's
// local origin, per firebox_passage()'s own translate([...,chamber_floor_z])
// below) -- NOT an absolute world Z, same convention this file already uses.
PASSAGE_Z_CENTER = PASSAGE_Z_CENTER_WORLD - chamber_floor_z;       // 83.3325mm (local h)
module firebox_passage_profile() {
    intersection() {
        translate(hex_pt(PASSAGE_Z_CENTER, PASSAGE_Y_CENTER)) circle(r = PASSAGE_R);
        offset(delta = -CHAMBER_EDGE_MARGIN) fixed_side_solid_2d();
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
// v21 TASK 1: the vertical Y=0 side panel (3rd cube below) is the lid's
// own real material at the moved boundary -- shortened by EXACTLY
// PARTING_SHIFT(50mm) so it no longer includes the new fixed band
// (world Z=[950,1000]). Bottom moved from the old apex-A-based Z up to
// NEW_SPLIT_Z (with the SAME real LID_OVERLAP convention, now overlapping
// into the new fixed band instead of into apex A's own corner material).
// Top edge UNCHANGED (still the real top-left octagon corner,
// world Z=chamber_floor_z+chamber_H-chamfer -- that corner itself does
// not move, only the fixed/lid split below it does) -- confirmed via the
// unchanged height formula's own dependency chain, not re-derived.
module lid_closed_panels() {
    translate([LID_X0, chamfer - LID_OVERLAP, DATUM_Z_RIDGE - wall_t])
        cube([LID_LENGTH, RIDGE_SPLIT_Y - (chamfer - LID_OVERLAP), wall_t]);   // v25: ridge cap width now tracks RIDGE_SPLIT_Y, was DATUM_Y_CENTER
    translate([LID_X0, chamfer, DATUM_Z_RIDGE]) rotate([-135, 0, 0])
        cube([LID_LENGTH, lid_slant_len, wall_t]);
    translate([LID_X0, 0, NEW_SPLIT_Z - LID_OVERLAP])
        cube([LID_LENGTH, wall_t, (trough_h + LID_OVERLAP) - PARTING_SHIFT]);
}
module lid_closed() {
    lid_closed_panels();
}
// LID_HINGE_GAP RETIRED v26 (R-009, zero remaining consumers confirmed
// via grep) -- was only ever used in lid()'s own rotation point below,
// which now uses the real HINGE_PIVOT_Y/Z directly (this file's own
// header) instead of a hardcoded near-ridge point plus a small epsilon
// gap.
module lid(lid_open_deg = 0) {
    translate([0, HINGE_PIVOT_Y, HINGE_PIVOT_Z])   // v26: rotation point now the REAL shared hinge pivot (this file's own header) -- was RIDGE_SPLIT_Y+LID_HINGE_GAP (basically on the ridge surface, a different point than the rib's own FC)
        rotate([-lid_open_deg, 0, 0])
        translate([0, -HINGE_PIVOT_Y, -HINGE_PIVOT_Z])
        lid_closed();
}
// lid_hardware()/LEVER_ARM/COUNTERWEIGHT_KG RETIRED v23 (Section 7.5,
// R-009) -- the real mechanism is BBQ-offset-smoker-base-v6.scad's own
// three-rib CB1 assembly, not this file.

// ───────────────────────────────
// firebox() — v15 TASK 2 REWORK. Two fully independent welded assemblies,
// SAME real architecture v14 established (reused, not reinvented): fire
// cylinder (hot, sealed to the chamber) and outer shell (insulating
// jacket, structurally tucked under the chamber's rear wall) — NO shared
// end-cap plate between them. ash_tray()/firebox_door() UNCHANGED CODE
// except ash_tray()'s own width formula (see below).
// ───────────────────────────────
// ── FIRE CYLINDER (NEW, replaces inner_duct()/inner_duct_end_cap(),
// RETIRED -- R-009, grep-confirmed zero remaining consumers) ──
module fire_cylinder() {
    // Near face starts at firebox_x0+e (not exactly firebox_x0) -- SAME
    // real epsilon-separation fix v14.2's own inner_duct() required
    // (exact-coincident-face non-manifold risk vs outer_shell()'s own
    // hollow-cavity boundary), reused here for the same reason.
    translate([firebox_x0 + e, CYL_Y_CENTER, CYL_Z_CENTER]) rotate([0, 90, 0])
        difference() {
            cylinder(d = CYL_D, h = FIREBOX_L - 2*e);
            translate([0, 0, -e]) cylinder(d = CYL_D - 2*wall_t, h = FIREBOX_L - 2*e + 2*e);
        }
}
// fire_cylinder_end_cap_bound_2d() — v19 NEW. Bounds
// fire_cylinder_end_cap_2d()'s own union (below) to the cylinder's own
// real diameter bounding box (a square of side CYL_D, centered on the
// cylinder's own real center) -- same real role as
// outer_shell_flange_footprint_2d()'s own `flange_height_bound_2d()`
// (rules-codes.md/.claude/SKILL_joint_construction.md RULE 4): without
// this bound, unioning in the raw `true_octagon_profile()` would pull in
// real octagon material without limit (the octagon's own real width only
// keeps growing with height, all the way to the chamber's own ridge) --
// the SAME real overreach bug already found and fixed once this session
// on the outer shell's own flange, pre-empted here rather than re-found.
module fire_cylinder_end_cap_bound_2d() {
    translate(hex_pt(CYL_Z_CENTER - chamber_floor_z, CYL_Y_CENTER))
        square([CYL_D, CYL_D], center = true);
}
// fire_cylinder_end_cap_2d() / fire_cylinder_end_cap() — v19 REBUILT via
// the Dual End-Cap Footprint Pattern (RULE 4), replacing v16 TASK B's own
// `intersection(circle, octagon)` construction -- a REAL, CONFIRMED
// remaining hole Janis found by looking INSIDE the built cylinder (v18's
// own QA simulation Step 2 said "pass" on the wrong basis: no OTHER hole
// existed yet at the time, but this round's own closer look found a real
// missing-material gap in the end cap ITSELF, the exact same failure
// class as v16's original mistake on the outer shell, just never checked
// here). Real root cause, confirmed by direct half-width comparison at
// world Z=chamber_floor_z (h=0): the octagon's own real half-width there
// (126.335mm) is LESS than the cylinder's own real half-width at that
// same height (219.6mm, computed from the circle's own real geometry) --
// `intersection(circle, octagon)` clips the circle DOWN to the narrower
// octagon there, and the chamber has zero material of its own outside the
// octagon's true edge to fill what gets clipped away -- a real, visible
// hole, confirmed via a real STL/CGAL residual probe (this file's own
// diagnostic session, not assumed). FIX: `union(circle, true_octagon_
// profile())`, bounded by `fire_cylinder_end_cap_bound_2d()` above (so it
// never exceeds the cylinder's own real diameter envelope), then minus
// the shared passage cut -- the end cap is now ALWAYS at least the full
// native circle (Rule 2's own "everywhere else...circle for a cylinder"),
// and reaches out to meet the chamber's own real octagon profile only
// where the octagon is genuinely wider (Rule 2's own "top zone follows
// the chamber's real profile") -- never narrower than the circle, so
// never a real hole. Welds DIRECTLY to the chamber's own octagon end cap,
// NOT to the outer shell (UNCHANGED role from v14.2/v15).
module fire_cylinder_end_cap_2d() {
    difference() {
        intersection() {
            union() {
                translate(hex_pt(CYL_Z_CENTER - chamber_floor_z, CYL_Y_CENTER)) circle(d = CYL_D);
                true_octagon_profile();
            }
            fire_cylinder_end_cap_bound_2d();
        }
        offset(delta = e) firebox_passage_profile();   // +e dilation -- same real non-manifold fix
                                                          // v14.2's own inner_duct_end_cap_2d() required
                                                          // wherever the passage's own boundary follows
                                                          // the real octagon edge, reused here.
    }
}
module fire_cylinder_end_cap() {
    // Same X overshoot convention as v14.2's own inner_duct_end_cap():
    // forward-only, into the cylinder's own X-territory (butts against
    // its open near-face), real overlap with the chamber's own solid
    // rear-wall material confirmed via CGAL below.
    translate([firebox_x0 + e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t, convexity = 4)
            fire_cylinder_end_cap_2d();
}
// fire_cylinder_partition() / fire_cylinder_partition_2d() — v15 TASK 4,
// NEW. Real end plate at the door/front end of the cylinder, physically
// locates it within the square outer shell (per Janis's reference photo).
// Built from the SAME outer_shell_footprint_2d() helper the flange/end-cap
// already use (R-009, not re-derived) minus a circle matching the
// cylinder's own real diameter -- same "footprint minus a hole"
// construction outer_shell_flange_cut_2d() already established.
// Real, found+fixed via CGAL: positioned flush at exactly X=firebox_x1
// (the door's own real near-face start) produced an exact-coincident-
// surface non-manifold result (Simple:no) against firebox_door() -- pulled
// back by e (real, negligible 0.01mm) so the partition sits at
// X=[firebox_x1-wall_t-e, firebox_x1-e], genuine real separation from the
// door, re-verified Simple:yes/empty.
module fire_cylinder_partition_2d() {
    difference() {
        outer_shell_footprint_2d();
        translate(hex_pt(CYL_Z_CENTER - chamber_floor_z, CYL_Y_CENTER)) circle(d = CYL_D + 2*e);   // +2e: real clearance vs an exact-diameter coincident-surface touch against the cylinder's own OD, same rules-codes.md epsilon convention this file already applies elsewhere
    }
}
module fire_cylinder_partition() {
    translate([firebox_x1 - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t, convexity = 4)
            fire_cylinder_partition_2d();
}

// ── OUTER SHELL (NEW construction, replaces firebox_shell(), RETIRED)
// widened to FIREBOX_W(580mm), physical length FIREBOX_SHELL_L(480mm) --
// see file header for the interior-vs-outer-length distinction. ──
// outer_shell_footprint_2d() — v14.1 TASK 1: now used DIRECTLY (unclipped)
// for the flange AND its end cap, full height, no zones. `outer_shell_
// flange_2d()` (v14, RETIRED this round, R-009 confirmed zero other real
// consumers) built a TWO-ZONE shape -- plain rectangle below chamber_floor_z,
// octagon-CLIPPED narrower shape above it -- which produced a real, visible
// abrupt WIDTH JUMP right at the chamber_floor_z transition (the octagon's
// real ~252.67mm floor-width vs. the full 580mm rectangle width): a genuine
// visible STEP (Janis's own screenshot), not a rendering artifact. FIX: use
// this plain, unclipped, full FIREBOX_H x FIREBOX_W rectangle for the
// flange's ENTIRE height -- one flat continuous plane, no clipping. Real,
// not just cosmetic: the UPPER portion (world Z=[chamber_floor_z,firebox
// top]) has real, confirmed non-empty contact with the chamber's own
// octagon material (see cc_chat_log.md for the real contact-area check);
// the LOWER portion (world Z=[firebox floor,chamber_floor_z]) has zero real
// chamber material to intersect with -- confirmed empty via CGAL, matches
// this file's own standing "no material below the floor" convention
// (true_octagon_profile()/fixed_side_solid_2d() already follow it) -- no
// collision risk, no separate notch/clip needed.
module outer_shell_footprint_2d() {
    translate([chamber_floor_z - firebox_z1, firebox_y0])
        square([FIREBOX_H, FIREBOX_W]);
}
// chamber_hollow_cavity_2d() — v17, UNCHANGED this round. The chamber's own
// real hollow interior bore -- cut out of the flange footprint below so it
// can never be plugged (Rule 1's own "outer shell end cap" must not block
// the chamber, a real CGAL-confirmed defect two rounds ago). Only exists
// for h>=0 (true_octagon_profile() has no geometry below h=0), so h<0 is
// automatically untouched by any difference() using this shape.
module chamber_hollow_cavity_2d() {
    offset(delta = -wall_t) true_octagon_profile();
}
// outer_shell_flange_footprint_2d() — v18 REBUILT to actually satisfy
// rules-bbq-fab.md's own new "Dual End-Cap Independence Convention, Rule 1"
// (locked 2026-07-21, same day): "constrained to ONLY its own square/cube
// projection...in every zone EXCEPT the top part, which follows the
// chamber's own real profile...ONE CONTINUOUS SURFACE...no step, no
// zone-clipped transition between two differently-derived shapes." v17's
// own fix (kept the footprint ALWAYS the plain square, difference() only)
// avoided the two real CGAL-confirmed bugs (wall-blocks-interior, missing-
// material gap) but did NOT actually satisfy Rule 1 -- it never lets the
// top zone reach out and match the chamber's own real profile at all,
// confirmed via a direct side-by-side walkthrough of Janis's own 4-step
// QA simulation (Step 4: "on the top you must meet the octagon face") --
// v17's square-only footprint never "meets" the octagon, it just avoids
// it. REAL FIX: `union()` the plain square with the true octagon profile,
// THEN cut the hollow-cavity hole out of the combined result -- NOT an
// `intersection()` (v16's own original mistake, clips the square DOWN to
// the octagon and creates the missing-material gap, since the chamber has
// zero material of its own outside the octagon's true edge to fill what
// gets clipped away). With `union()`: the footprint is ALWAYS >= the plain
// square (never narrower, so "no step"/"one continuous surface" holds by
// construction -- there is never a height where the boundary snaps
// inward), and for the real height range where the octagon's own true
// width EXCEEDS 580mm (world Z>=935mm, confirmed live), the boundary
// reaches out and becomes EXACTLY the octagon's own edge there -- a real,
// literal "meets the octagon face" (Rule 1's own words), not an
// approximation.
// REAL BUG FOUND+FIXED BEFORE SHIPPING (caught by a real STL bounding-box
// probe, not assumed clean from the reasoning alone): `true_octagon_
// profile()` on its own is NOT height-bounded to the flange's own real
// physical range (`FIREBOX_H`=580mm, world Z=[420,1000]) -- it's the
// chamber's own FULL profile, real local-h up to `chamber_H`(610mm),
// reaching world Z as high as `chamber_floor_z+610`=1381.335mm, the
// chamber's own RIDGE. A bare `union()` with it would have added real,
// wrong material all the way up to the ridge height -- WAY above the
// firebox's own real top (`firebox_z1`=1000mm) -- a serious new defect,
// caught here before it ever reached a render Janis would see. FIX:
// `intersection()` the union with a real height-bounding mask
// (`flange_height_bound_2d()`, spanning EXACTLY `outer_shell_footprint_2d()`'s
// own real local-h range, unbounded in width) BEFORE subtracting the
// hollow-cavity hole -- confirmed via a real STL bbox probe: footprint's
// own local-h range now exactly [-228.665,351.335] (matches
// `outer_shell_footprint_2d()`'s own range precisely), was
// [-610,351.335] (real, wrong 258.665mm overreach) before this fix.
module flange_height_bound_2d() {
    translate([chamber_floor_z - firebox_z1, -1000])
        square([FIREBOX_H, chamber_W + 2000]);
}
module outer_shell_flange_footprint_2d() {
    difference() {
        intersection() {
            union() {
                outer_shell_footprint_2d();
                true_octagon_profile();
            }
            flange_height_bound_2d();
        }
        chamber_hollow_cavity_2d();
    }
}
// outer_shell_flange_cut_2d() — v14.2 TASK 2, NEW (v16: now built on
// outer_shell_flange_footprint_2d() above, not the plain unclipped
// footprint). Real, confirmed defect found via an actual CGAL ray-probe
// (not a visual read): v14.1's TASK 1 made the flange/end-cap a PLAIN,
// UNPERFORATED rectangle (correctly fixing the visible step) but never cut
// the passage hole through it -- the flange's own footprint (580x428.6mm)
// is LARGER than the duct's own opening and sits directly in the line of
// sight through the passage, so even though the chamber's own rear wall
// and the inner duct's own end cap both have a real trapezoid hole, this
// solid flange fully blocked the view/airflow behind them. Same shared
// `firebox_passage_profile()` module, not re-derived or resized -- cutting
// the SAME real shape through every layer it needs to pass keeps them all
// aligned by construction.
module outer_shell_flange_cut_2d() {
    difference() {
        outer_shell_flange_footprint_2d();
        firebox_passage_profile();
    }
}
// outer_shell() — v20 REAL FIX to the flange's own construction. Janis's
// own direct finding: toggling `show_outer_shell_end_cap` OFF still left
// a visible wall behind it -- because the flange (this module's own
// near-end extension) was built as a SOLID 50mm-deep block (v14's own
// original choice, comment literally said "SOLID, no interior cavity"),
// not a thin wall -- creating TWO real, redundant wall-like surfaces in
// that zone (the solid block's own far face, plus the separate thin
// `outer_shell_end_cap()` plate stacked right against it) where there
// should only be ONE (Janis: "I should only see one wall, the end cap
// with the cut to match under the octagon face... I should see the
// bottom of the chamber octagon face if you do it correctly"). This was
// also a real, standing inconsistency with this project's own
// `rules-bbq-fab.md` "Construction Method" (formed/flat panels are thin
// uniform-thickness shells, not solid billets) -- inherited unquestioned
// since v14, never actually revisited until this direct visual check.
// FIX: the flange is now a proper HOLLOW extension, wall_t thick, built
// with the SAME real technique as the main hollow body below (outer
// boundary minus an inset-by-wall_t inner cavity) -- `outer_shell_
// end_cap()` (UNCHANGED position/role) is now genuinely the ONE real cap
// closing this hollow tube's far end; toggling it off now shows straight
// through the flange's own real hollow interior to the chamber's own
// material behind it, matching what Janis expects to see.
module outer_shell() {
    union() {
        // main hollow body, FIREBOX_L(460mm) span, X=[firebox_x0,firebox_x1] -- same footprint length as the duct
        difference() {
            translate([firebox_x0, firebox_y0, firebox_z0]) cube([FIREBOX_L, FIREBOX_W, FIREBOX_H]);
            translate([firebox_x0 - e, firebox_y0 + wall_t, firebox_z0 + wall_t])
                cube([FIREBOX_L + 2*e, FIREBOX_W - 2*wall_t, FIREBOX_H - 2*wall_t]);
        }
        // near-end flange, ADDITIVE 50mm (v16 TASK D, was 20mm), v20
        // REBUILT HOLLOW (wall_t thick, was a solid block -- see this
        // module's own header comment above). Spans EXACTLY
        // X=[firebox_x0-FLANGE_LEN, firebox_x0] -- NO epsilon overshoot past
        // firebox_x0 (would otherwise intrude a hair into the inner duct's
        // own separate X-territory, found via a real CGAL non-manifold
        // check -- confirmed fixed, Simple:yes, see cc_chat_log.md). The
        // flange's own hollow near-face meeting the main body's own hollow
        // near-face (that difference()'s own e-overshoot already starts the
        // cavity cut slightly before firebox_x0) at this exact shared plane
        // is a clean, compatible continuation -- same real wall thickness,
        // same real cavity, not an ambiguous coincident-face touch.
        difference() {
            translate([firebox_x0 - FLANGE_LEN, 0, chamber_floor_z]) rotate([0, 90, 0])
                linear_extrude(height = FLANGE_LEN, convexity = 4)
                    outer_shell_flange_cut_2d();
            translate([firebox_x0 - FLANGE_LEN - e, 0, chamber_floor_z]) rotate([0, 90, 0])
                linear_extrude(height = FLANGE_LEN + 2*e, convexity = 4)
                    offset(delta = -wall_t) outer_shell_flange_footprint_2d();
        }
    }
}
// outer_shell_end_cap() — v14 TASK 2 step 4, NEW (replaces the retired
// firebox_end_cap()). Thin wall_t plate at the flange's own outer/near
// face (the true near end of the outer shell, X=firebox_x0-FLANGE_LEN),
// SAME two-zone footprint as the flange it caps (v16 TASK C) -- STRUCTURAL,
// bears real load from the chamber's rear edge (Janis's explicit design
// intent, "it give stronger structure support"). Positioned FLANGE_LEN
// (50mm, v16 TASK D, was 20mm) away in X from the inner duct's own start
// (firebox_x0) -- confirmed via real CGAL zero-contact check below that it
// never touches the inner duct or the duct's own end cap.
module outer_shell_end_cap() {
    translate([firebox_x0 - FLANGE_LEN - wall_t - e, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = wall_t + 2*e, convexity = 4)
            outer_shell_flange_cut_2d();
}

// ash_tray() — v19 RETIRED (R-009, zero remaining consumers confirmed via
// grep before removing). Janis's own explicit, direct instruction: "just
// remove this tray, keep cylinder clean" -- flagged as asked "since 4-5
// vesions ago" and never actually removed (this session's own governance
// retrospective found chat had "assumed a lot of things and wrote...
// unclear instruction" in earlier rounds -- this round's instruction is
// explicit and unambiguous, acted on directly, not re-interpreted).
// ASH_TRAY_H/ASH_TRAY_L/ASH_TRAY_GAP/ASH_TRAY_W/ASH_TRAY_X_IN/
// ASH_TRAY_SLIDE_MAX all RETIRED alongside the module (zero other real
// consumers, reconfirmed via grep). `ash_tray_out_pct` parameter threading
// through `firebox()`/the DEBUG TOGGLES block REMOVED too (see both call
// sites below) -- was exclusively for this module.

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
// firebox() — v17 NEW: 4 real sub-part toggles added (Janis's own explicit
// request: "Can Can you make the inner shell of the fire box and outer
// shell of the fire box can be toggle? also specially i need both back
// end cap of the fire box both the cylinder and the square one able to
// toggle on off too. So if problem still happen i can tell chat or you
// more precisely!") -- `show_fire_cylinder`/`show_fire_cylinder_end_cap`/
// `show_outer_shell`/`show_outer_shell_end_cap`, each independent of the
// master `show_firebox` toggle (which still gates the WHOLE assembly, per
// the Toggle-Completeness Rule's existing pattern). `fire_cylinder_
// partition()`/`firebox_door()` UNCHANGED, no new toggle (not part of
// Janis's own explicit ask this round, R-009: keep scope to what was
// asked). v19: `ash_tray()` call REMOVED (module retired, see its own
// header comment above) -- `ash_tray_out_pct` parameter dropped too, zero
// remaining consumers.
module firebox(firebox_door_open_deg = 0) {
    if (show_fire_cylinder) color("#8B2E2E") fire_cylinder();
    if (show_fire_cylinder_end_cap) color("#8B2E2E") fire_cylinder_end_cap();
    color("#AAAAAA", 1.0) fire_cylinder_partition();
    if (show_outer_shell) outer_shell();
    if (show_outer_shell_end_cap) outer_shell_end_cap();
    firebox_door(firebox_door_open_deg);
}

// ───────────────────────────────
// Grill grate + Floor drains — UNCHANGED CODE v14 (grate Z anchor and X/Y
// formulas both frozen per DO NOT TOUCH; real values move automatically
// with the new chamber_floor_z/DATUM_GRATE_Z where the formula reads
// them, confirmed identical to v13, see file header). v22 TASK 1: this
// module's own `GRATE_Z_FIXED` literal RETIRED (R-009, this was the SAME
// real value as the file's own restored master `GRATE_Z`, declared much
// earlier now -- a real duplicate declaration, not a second independent
// datum) -- its one real consumer below re-points directly to `GRATE_Z`.
// ───────────────────────────────
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
        translate([DATUM_X_FRONT + GRATE_MARGIN + i*(grate_seg_l + GRATE_GAP), GRATE_Y0, GRATE_Z - 10])
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
show_firebox         = true;
// v17 NEW: 4 real sub-part toggles inside firebox() (Janis's own explicit
// request, see firebox()'s own header comment) -- each independent of
// show_firebox above (which still gates the WHOLE firebox assembly, incl.
// fire_cylinder_partition()/ash_tray()/firebox_door(), unaffected by these
// 4). All default true (full assembly, unchanged default appearance) --
// set any to false to isolate that one sub-part for a precise report.
show_fire_cylinder          = true;
show_fire_cylinder_end_cap  = true;
show_outer_shell            = true;
show_outer_shell_end_cap    = true;
show_exhaust_room    = true;
show_chimney_pipe    = true;
show_grate            = true;
show_drains           = true;

/* [Hidden] */
lid_open_deg           = 0;    // 0=closed .. max -- v24: HIDDEN from Customizer (TASK 1) -- do NOT drive this control directly, use BBQ-offset-smoker-base-v7.scad's own `door_open_deg` when rendering the full assembly. This file's own default (0) still applies when rendered standalone.

/* [Firebox] */
firebox_door_open_deg  = 0;    // 0=closed .. 110=open -- v24: moved into its own Customizer group solely to close the [Hidden] group above; still a real, independent, visible control, unchanged otherwise

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation Testing
// (rules-codes.md).
// ───────────────────────────────
if (show_chamber_shell) color("#C8C8C8", 0.75) chamber_shell();
if (show_lid) color("#C8C8C8", 0.75) lid(lid_open_deg);
if (show_firebox) color("#C8C8C8", 0.75) firebox(firebox_door_open_deg);
if (show_exhaust_room) color("#C8C8C8", 0.75) exhaust_room();
if (show_chimney_pipe) color("#C8C8C8", 0.75) chimney_pipe();
if (show_grate) color("#CCCCCC", 1.0) grill_grate();
if (show_drains) color("#AAAAAA", 1.0) floor_drains();
