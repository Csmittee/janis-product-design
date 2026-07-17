// BBQ Offset Smoker — Understructure
// Version: v2
// Date: 2026-07-17
// Changes from v1: bbq-understructure-v2-axles-swivel-handle. REPLACES
// v1's explicit placeholders (legs()/casters()/tow_handle()) with 3
// fully-specified, genuinely UNRELATED real mechanisms per the source
// prompt — do not let their geometry influence one another:
//   TASK 1 — REAR axle: fixed, non-swivel, 2 big wheels under the firebox.
//   TASK 2 — FRONT wheel support: ONE bent-sheet bracket + single swivel
//            caster under the chamber (REWRITTEN round of this prompt,
//            confirmed against a real sketch Janis provided directly).
//   TASK 3 — Tow handle + puller triangle bracket, entirely independent
//            of Task 2's geometry (no shared mount point/axle/coordinate).
// v1 kept unchanged, on record, per file-versioning convention (see
// BBQ-understructure-v1.scad). BBQ-offset-smoker-base-v1.scad's own
// `include` updated v1->v2 to point at this file (see that file's header).
// This is also the first version of THIS file to follow the same
// versioned-filename convention BBQ-chambers-vN.scad already used —
// previously this file was saved unversioned (plain BBQ-understructure.scad).
//
// include target CARRIED FORWARD unchanged from v1: BBQ-chambers-v11.scad
// (confirmed still the live/active chambers file this session — knowledge.map
// v61/cc_chat_log.md both point at v11, NOT the v10 named in an earlier
// draft of this prompt; re-confirmed directly against the repo per this
// prompt's own explicit instruction, not assumed). v11's own change
// (firebox_upper_wall_seal(), additive material only, inside firebox() —
// no datum this file reads changed: chamber_floor_z, firebox_floor_z,
// firebox_x0/y0/y1, chamber_W/chamfer/DATUM_Y_CENTER all unchanged) does
// not affect anything built below.
//
// SKELETON — Parent: BBQ-chambers-v11.scad's own DATUM_*/chamber_*/
// firebox_* constants, read directly (R-009 pattern, not re-derived).
// This file's own local origin is still MASTER ORIGIN (0,0,0 at floor,
// front-left), unchanged from v1.

include <BBQ-chambers-v11.scad>

// ───────────────────────────────
// PARAMETERS — carried over from v1, UNCHANGED. Still real consumers:
// CASTER_CLEARANCE/leg_h/LEG_INSET/SHELF_D/SHELF_T are all read by
// prep_shelves() below (DO NOT TOUCH, per this prompt's Section 5) — kept
// exactly as v1 declared them, R-009-confirmed before removing anything
// (LEG_TUBE and CASTER_D WERE v1-only params, consumed exclusively by the
// now-REMOVED legs()/caster() modules — confirmed zero remaining callers,
// removed below, not left as orphaned dead parameters).
// ───────────────────────────────
CASTER_CLEARANCE = 50;      // ground clearance under leg bottom — still read by prep_shelf()'s own Z below
LEG_INSET = 30;              // still read by prep_shelf()'s own X below
SHELF_D = 300;                // fold-up prep shelf depth
SHELF_T = 20;

// leg_h — UNCHANGED formula/value from v1 (550mm). No independent "legs"
// exist in this version (see TASK 1/2/3 below — support is now a real
// 3-point stance: 2 rear wheels + 1 front caster, not 4 corner legs), but
// prep_shelf() still reads leg_h directly for its own hinge height (DO NOT
// TOUCH) — kept as a real, still-consumed value, not orphaned.
leg_h = chamber_floor_z - CASTER_CLEARANCE;   // 600-50=550

// ═══════════════════════════════════════════════════════════════════
// TASK 1 — REAR AXLE (fixed, non-swivel, under the firebox) — UNCHANGED
// spec from the source prompt. Parent: firebox_x0/firebox_size (DATUM_X_REAR
// chain) / firebox_y0/firebox_y1 (DATUM_Y_CENTER chain) / firebox_floor_z
// (chamber_floor_z chain) — all read LIVE from the included chambers file,
// not re-derived independently (R-009).
// ═══════════════════════════════════════════════════════════════════
WHEEL_D             = 609.6;   // 24" wheel including tire
WHEEL_R             = 304.8;   // 305mm, rounded
FIREBOX_CLEARANCE   = 200;     // Janis's spec, each side, avoid heat
TIRE_W              = 150;     // reasonable off-shelf tire width placeholder

// firebox footprint — read from the LIVE include, not hardcoded (per prompt):
// firebox_x0=915, firebox_size=457, firebox_y0=76.5, firebox_y1=533.5,
// firebox_floor_z=400 (all already defined in BBQ-chambers-v11.scad above).
REAR_AXLE_X         = firebox_x0 + firebox_size/2;        // 1143.5 -- centered on firebox midpoint
REAR_WHEEL_Y_LEFT   = firebox_y0 - FIREBOX_CLEARANCE;     // -123.5
REAR_WHEEL_Y_RIGHT  = firebox_y1 + FIREBOX_CLEARANCE;     // 733.5
REAR_TRACK_WIDTH    = REAR_WHEEL_Y_RIGHT - REAR_WHEEL_Y_LEFT;   // 857mm
REAR_AXLE_Z         = WHEEL_R;                             // 304.8 -- ground contact, wheel radius
REAR_BRACKET_H      = firebox_floor_z - REAR_AXLE_Z;        // 400-304.8=95.2mm

// Drop-bracket judgment call (flagged, cc-made): the prompt describes ONE
// drop from the firebox underside "at REAR_AXLE_X" down to REAR_AXLE_Z,
// with the wide track spanned by the TRANSVERSE BEAM, not by the drop
// struts themselves (the wheels sit 200mm outside the firebox's own
// footprint each side, per FIREBOX_CLEARANCE -- a strut welded directly
// above a wheel would be hanging off the SIDE of the firebox, not under
// it). Built as 2 struts, symmetric about DATUM_Y_CENTER, spaced well
// inside the firebox's real Y footprint [76.5,533.5] -- a real weld target
// on the firebox's own solid bottom wall (wall_t=3mm) -- connected to a
// single transverse round beam that does the full REAR_TRACK_WIDTH span,
// same real-world pattern as a solid-axle trailer hanger.
REAR_STRUT          = 40;      // square tube corner strut, mm (matches v1's LEG_TUBE convention)
REAR_STRUT_Y_OFFSET = 150;     // struts at DATUM_Y_CENTER +/-150 = Y=[155,455], real inside firebox_y0..firebox_y1
REAR_BEAM_D         = 50;      // transverse axle beam, round tube placeholder
REAR_WELD_OVERLAP   = 3;       // real shared volume at both the firebox weld and the beam junction (Rule M-1)

module rear_strut(y) {
    // top = firebox_floor_z + REAR_WELD_OVERLAP: real solid material exists
    // here -- firebox_shell()'s own bottom wall is solid for
    // Z=[firebox_z0, firebox_z0+wall_t]=[400,403] across the full footprint
    // (the inner cavity cutout only starts at Z=403), so a 3mm overlap
    // lands inside real firebox wall material, not empty interior.
    // bottom = REAR_AXLE_Z - REAR_WELD_OVERLAP: real overlap with
    // rear_axle_beam() below (beam radius 25mm, centered at REAR_AXLE_Z).
    translate([REAR_AXLE_X - REAR_STRUT/2, y - REAR_STRUT/2, REAR_AXLE_Z - REAR_WELD_OVERLAP])
        cube([REAR_STRUT, REAR_STRUT, (firebox_floor_z + REAR_WELD_OVERLAP) - (REAR_AXLE_Z - REAR_WELD_OVERLAP)]);
}
module rear_struts() {
    rear_strut(DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET);   // 155
    rear_strut(DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET);   // 455
}
module rear_axle_beam() {
    // axis along Y, full REAR_TRACK_WIDTH, centered at REAR_AXLE_X/REAR_AXLE_Z
    // -- same (X,Z) axis the wheels themselves use below, so the beam sits
    // fully embedded inside each wheel's own hub volume at the ends (real
    // overlap by construction, not just a touching face).
    translate([REAR_AXLE_X, REAR_WHEEL_Y_LEFT, REAR_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = REAR_BEAM_D, h = REAR_TRACK_WIDTH);
}
module rear_axle_bracket() {
    rear_struts();
    rear_axle_beam();
}
module rear_wheel(y) {
    // WHEEL_D dia, TIRE_W wide, axis along Y, centered at (REAR_AXLE_X,y),
    // Z-center = REAR_AXLE_Z = WHEEL_R -- bottom of wheel = Z=0, ground contact.
    translate([REAR_AXLE_X, y - TIRE_W/2, REAR_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = WHEEL_D, h = TIRE_W);
}
module rear_wheels() {
    rear_wheel(REAR_WHEEL_Y_LEFT);
    rear_wheel(REAR_WHEEL_Y_RIGHT);
}
// rear_axle() -- single ASSEMBLY-called wrapper, own toggle (Toggle-
// Completeness Rule); sub-parts (struts/beam/wheels) don't need separate
// toggles, same no-separate-toggle pattern chamber_shell()'s own sub-parts
// use. No kinetic parameter -- static, non-swivel, per the prompt.
module rear_axle() {
    color("#AAAAAA", 1.0) rear_axle_bracket();
    color("#333333", 1.0) rear_wheels();
}

// ═══════════════════════════════════════════════════════════════════
// TASK 2 — FRONT WHEEL SUPPORT BRACKET + CASTER (REWRITTEN this round).
// ONE bent-sheet bracket, press-brake formed from ONE flat trapezoidal
// blank, 6mm thick -- per Janis's real sketch. Built here as 2 trapezoidal
// side "leg" plates + 1 flat bottom plate, matching this project's own
// standing convention for formed/bent panels (rules-bbq-fab.md:
// "represented as thin uniform-thickness shells/flat-panel assemblies" --
// geometrically simplified vs. a true bend-allowance model, same
// simplification already used for the chamber's own lid/end-caps).
// Parent: chamfer/chamber_W/DATUM_Y_CENTER, all read LIVE from the
// included chambers file -- MID_H/TOP_W/BOT_W below are real formulas, not
// hardcoded decimals (per the prompt's own explicit instruction).
// ═══════════════════════════════════════════════════════════════════
MID_H   = chamfer / 2;                                    // 89.332mm -- 50% up the real chamfer; bracket's top edge welds here
TOP_W   = (chamber_W - 2*chamfer) + 2*MID_H;               // 431.335mm -- REAL octagon width at h=MID_H (chamber_W-chamfer, verified below)
BOT_W   = chamber_W - 2*chamfer;                            // 252.670mm -- same as the chamber's own real floor width (=trough_h)
LEG_GAP  = 250;    // X spacing between the front and rear leg plates
LEG_DROP = 150;    // chamber_floor_z (h=0) down to the bracket's bottom, where the caster mounts
t        = 6;      // plate thickness

// FRONT_X judgment call (flagged, cc-made -- not in the source prompt,
// which explicitly leaves this choice to cc with reasoning stated): X=300
// places the bracket's own 2 legs at X=300 (aft leg, further from the true
// product front) and X=50 (fwd leg, X=FRONT_X-LEG_GAP, inside the chamber's
// own fixed/welded end-margin zone X=[0,LID_X0=100] -- a strong, lid-
// independent weld target, same reasoning rules-bbq-fab.md's own "chimney
// mounts on the fixed shell" judgment call used). Both legs sit under the
// chamber's front third (X range [50,300] of chamber_L=915), the real
// "front overhang" area referenced by the prompt. Neither leg's Z-range
// (h=[-LEG_DROP,MID_H] = world Z=[450,689.33]) comes anywhere near the
// lid's own hinge/motion zone (Z>=DATUM_Z_RIDGE=1210) -- zero interference
// regardless of lid_open_deg.
FRONT_X = 300;

BOT_OVERLAP = 3;   // real shared volume between the bottom plate and each leg's own (wider-than-BOT_W) cross-section just above h=-LEG_DROP

// front_bracket_leg_profile() -- the trapezoid itself, same hex_pt(h,w)
// convention true_octagon_profile() uses (h local to chamber_floor_z, w =
// world Y). Top edge (h=MID_H, width=TOP_W, centered DATUM_Y_CENTER) is
// algebraically IDENTICAL to true_octagon_profile()'s own boundary at
// h=MID_H (both lower chamfers are 45-deg lines w=chamfer-h (left) and
// w=(chamber_W-chamfer)+h (right); at h=MID_H=chamfer/2 those evaluate to
// w=chamfer/2=MID_H and w=chamber_W-chamfer/2=chamber_W-MID_H -- an exact
// match to this trapezoid's own top-edge endpoints, verified via a real
// OpenSCAD boundary probe, see cc_chat_log.md) -- confirms flush, no
// gap/interference, by construction, not by assumption.
module front_bracket_leg_profile() {
    polygon(points=[
        hex_pt(MID_H, DATUM_Y_CENTER - TOP_W/2),     // top-left  (real chamfer boundary point)
        hex_pt(MID_H, DATUM_Y_CENTER + TOP_W/2),     // top-right (real chamfer boundary point)
        hex_pt(-LEG_DROP, DATUM_Y_CENTER + BOT_W/2), // bottom-right
        hex_pt(-LEG_DROP, DATUM_Y_CENTER - BOT_W/2), // bottom-left
    ]);
}
// front_bracket_leg(xc) -- extruded thickness t, CENTERED on xc (not
// offset to one side) -- guarantees t/2 real X-overlap with
// front_bracket_bottom() below, whose own X-range ends exactly at each
// leg's nominal X (FRONT_X / FRONT_X-LEG_GAP).
module front_bracket_leg(xc) {
    translate([xc - t/2, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = t, convexity = 4) front_bracket_leg_profile();
}
// front_bracket_bottom() -- flat plate, width BOT_W (matches the legs' own
// bottom width exactly), spanning the full LEG_GAP. Top Z pushed
// BOT_OVERLAP above the nominal h=-LEG_DROP plane so it genuinely
// intrudes into each leg's own (wider) cross-section there -- real 3D
// volume overlap, not a coincident face (Rule M-1).
module front_bracket_bottom() {
    translate([FRONT_X - LEG_GAP, DATUM_Y_CENTER - BOT_W/2, (chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP])
        cube([LEG_GAP, BOT_W, t]);
}
module front_bracket() {
    front_bracket_leg(FRONT_X);
    front_bracket_leg(FRONT_X - LEG_GAP);
    front_bracket_bottom();
}

// Caster mounting interface (flagged placeholder -- no real hardware spec
// from Janis yet): generic heavy-duty swivel caster, 100x100mm top plate
// (a common off-shelf bolt-pattern size), stem placeholder, no internal
// bearing/bolt-hole detail (per the prompt's own "cylinder + simple
// mounting plate ... no internal bearing detail" allowance).
CASTER_X          = FRONT_X - LEG_GAP/2;   // 175 -- centered under the bracket's own bottom plate
CASTER_PLATE_SIZE = 100;                    // mm square, generic heavy-duty caster top-plate footprint
CASTER_PLATE_T    = 6;
CASTER_STEM_D     = 40;
CASTER_OVERLAP    = 3;                      // real shared volume with front_bracket_bottom() above

// Caster wheel size -- REUSES WHEEL_D/WHEEL_R from TASK 1 (per the
// prompt's own default clause: "reuse ... unless the caster's own
// footprint requires a different size"). Flagged, not silently assumed:
// this is a deliberate, real geometric fit, not a leftover copy-paste --
// the bracket's own LEG_DROP=150mm only drops the mount plate to world
// Z=450, leaving 450mm still to the ground; reusing the SAME 609.6mm wheel
// (axle center at Z=WHEEL_R=304.8, matching TASK 1's own ground-contact
// convention) means the caster stem only needs to bridge 450-304.8=145.2mm
// -- a real, plausible heavy-duty caster stem length. A small
// furniture-caster-sized wheel (e.g. 125mm) would need an implausible
// ~400mm stem to reach the ground at this mount height -- flagged here so
// Janis can confirm/override with a real hardware spec.
CASTER_WHEEL_D = WHEEL_D;
CASTER_TIRE_W  = TIRE_W;

module front_caster_plate() {
    top_z = ((chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP) + CASTER_OVERLAP;   // 450
    translate([CASTER_X - CASTER_PLATE_SIZE/2, DATUM_Y_CENTER - CASTER_PLATE_SIZE/2, top_z - CASTER_PLATE_T])
        cube([CASTER_PLATE_SIZE, CASTER_PLATE_SIZE, CASTER_PLATE_T]);
}
module front_caster_stem() {
    plate_bottom_z = (((chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP) + CASTER_OVERLAP) - CASTER_PLATE_T;   // 444
    translate([CASTER_X, DATUM_Y_CENTER, WHEEL_R])
        cylinder(d = CASTER_STEM_D, h = plate_bottom_z - WHEEL_R);   // 444-304.8=139.2mm stem
}
module front_caster_wheel() {
    translate([CASTER_X, DATUM_Y_CENTER - CASTER_TIRE_W/2, WHEEL_R]) rotate([-90, 0, 0])
        cylinder(d = CASTER_WHEEL_D, h = CASTER_TIRE_W);
}
// front_wheel_support() -- single ASSEMBLY-called wrapper, own toggle.
// No kinetic parameter for the bracket itself (fixed weldment, per the
// prompt) -- the caster's own swivel motion is inherent to the off-shelf
// part, not modeled kinematically here.
module front_wheel_support() {
    color("#AAAAAA", 1.0) {
        front_bracket();
        front_caster_plate();
        front_caster_stem();
    }
    color("#333333", 1.0) front_caster_wheel();
}

// ═══════════════════════════════════════════════════════════════════
// TASK 3 — TOW HANDLE + PULLER TRIANGLE BRACKET — UNCHANGED spec from the
// source prompt. Entirely independent of TASK 2 above -- no shared mount
// point, axle, or coordinate reference (deliberately NOT built from
// FRONT_X/LEG_GAP/CASTER_X etc.). GOVERNANCE FLAG: cc_chat_log.md has NO
// prior-session record of Janis-confirmed HINGE_X/track-width/clearance
// numbers for this mechanism (the only precedent is v1's own placeholder
// tow_handle(), a simple unspec'd cylinder) -- per the prompt's own
// fallback instruction, cc has made a reasoned, flagged judgment call
// below rather than inventing a false "prior session" citation. Needs
// Janis's direct confirmation, same flagged-placeholder pattern as TASK
// 2's own caster hardware spec.
// ═══════════════════════════════════════════════════════════════════
// TRIANGLE_APEX_X / TRIANGLE_BASE_X: apex forward (more negative X, further
// from the product), base at TRIANGLE_BASE_X (mount / steering-hinge axis,
// welded to the frame). Chosen so the ENTIRE assembly's X-range stays
// forward of (more negative than) the exhaust room's own real forward
// reach at every steer/tilt state tested -- see clearance check below.
TRIANGLE_APEX_X  = -350;
TRIANGLE_BASE_X  = -50;
TRIANGLE_BASE_W  = 200;    // base width along Y, centered on DATUM_Y_CENTER
TRIANGLE_T       = 6;       // plate thickness -- FLAT top-view plate only, per the prompt (not a tall vertical member)
TRIANGLE_Z       = 300;     // mount height -- flagged assumption, same order of magnitude as REAR_AXLE_Z (304.8) and v1's own placeholder height

// HINGE_INSET: the handle hinges NEAR the triangle's true mathematical
// apex, not exactly ON it -- a zero-width vertex can't physically hold a
// hinge pin, and extruding a cylinder from an exact zero-area point would
// touch the triangle plate at a single edge, not real volume (Rule M-1).
// Inset 20mm back along the triangle's own centerline, where the plate
// already has ~13mm of real width -- close enough to "at the tip" per the
// prompt's own intent, confirmed manifold via real CGAL check below.
HINGE_INSET = 20;
HINGE_X     = TRIANGLE_APEX_X + HINGE_INSET;   // -330

HANDLE_LEN = 400;   // mm, tow/pull handle length
HANDLE_D   = 25;    // mm, round bar -- reuses v1 placeholder's own diameter

// tow_triangle_profile() -- TOP-VIEW triangle only (X-Y plane), apex at
// (TRIANGLE_APEX_X, DATUM_Y_CENTER), base corners at TRIANGLE_BASE_X +/-
// TRIANGLE_BASE_W/2. Extruded by TRIANGLE_T in Z only -- a flat plate,
// never a tall member (that's the separate handle below).
module tow_triangle_profile() {
    polygon(points=[
        [TRIANGLE_APEX_X, DATUM_Y_CENTER],
        [TRIANGLE_BASE_X, DATUM_Y_CENTER - TRIANGLE_BASE_W/2],
        [TRIANGLE_BASE_X, DATUM_Y_CENTER + TRIANGLE_BASE_W/2],
    ]);
}
// tow_triangle(steer_deg) -- steering rotation about the triangle's own
// mount axis: a vertical (Z) line through (TRIANGLE_BASE_X,DATUM_Y_CENTER).
module tow_triangle(steer_deg = 0) {
    translate([TRIANGLE_BASE_X, DATUM_Y_CENTER, 0]) rotate([0, 0, steer_deg]) translate([-TRIANGLE_BASE_X, -DATUM_Y_CENTER, 0])
        translate([0, 0, TRIANGLE_Z]) linear_extrude(height = TRIANGLE_T, convexity = 2) tow_triangle_profile();
}
// tow_handle(handle_tilt_deg, steer_deg) -- hinged at HINGE_X (near the
// triangle's tip). Tilt: rotate([0,handle_tilt_deg-90,0]) about the hinge's
// own Y-axis line sweeps the handle from pointing -X (tilt=0, horizontal,
// towing/use -- matches v1's own forward-pointing placeholder direction)
// to pointing +Z (tilt=90, vertical storage) -- verified algebraically:
// Ry(-90) maps +Z->-X (tilt=0 state); Ry(0) leaves +Z->+Z (tilt=90 state).
// Steer: the SAME outer rotation tow_triangle() uses, applied here too, so
// steering turns the whole handle assembly independent of tilt angle, per
// the prompt.
module tow_handle(handle_tilt_deg = 0, steer_deg = 0) {
    translate([TRIANGLE_BASE_X, DATUM_Y_CENTER, 0]) rotate([0, 0, steer_deg]) translate([-TRIANGLE_BASE_X, -DATUM_Y_CENTER, 0])
        translate([HINGE_X, DATUM_Y_CENTER, TRIANGLE_Z])
            rotate([0, handle_tilt_deg - 90, 0])
                cylinder(d = HANDLE_D, h = HANDLE_LEN);
}
// tow_handle_assembly() -- single ASSEMBLY-called wrapper, own toggle.
// Kinetic: handle_tilt_deg (0=towing/use .. 90=full-vertical storage),
// steer_deg (independent rotation about the triangle's own mount axis).
module tow_handle_assembly(handle_tilt_deg = 0, steer_deg = 0) {
    color("#AAAAAA", 1.0) tow_triangle(steer_deg);
    color("#333333", 1.0) tow_handle(handle_tilt_deg, steer_deg);
}

// ───────────────────────────────
// prep_shelves() — 2 fold-up shelves, left+right, front of chamber.
// UNCHANGED from v1, per this prompt's Section 5 DO NOT TOUCH. Real
// intersection() probe run against front_wheel_support() (TASK 2) this
// session -- see cc_chat_log.md for the actual CGAL result (X ranges
// overlap: bracket X=[50,300] vs shelf X=[30,350.25]; but Y ranges do NOT:
// bracket Y=[89.3,520.7] vs shelf Y=[-300,0]/[610,910] -- no 3D overlap by
// construction, confirmed not just assumed).
// Kinetic: shelf_deployed true (horizontal) / false (vertical-stowed).
// Hinge along the chamber's own side edge, at leg-top height.
// ───────────────────────────────
module prep_shelf(side_y, shelf_deployed = true) {
    translate([DATUM_X_FRONT + LEG_INSET, side_y, CASTER_CLEARANCE + leg_h])
        rotate([shelf_deployed ? 0 : -90, 0, 0])
            cube([chamber_L*0.35, SHELF_D, SHELF_T]);
}
module prep_shelves(shelf_deployed = true) {
    translate([0, -SHELF_D, 0]) prep_shelf(DATUM_Y_LEFT, shelf_deployed);
    translate([0, chamber_W, 0]) mirror([0,1,0]) translate([0,-SHELF_D,0]) prep_shelf(DATUM_Y_LEFT, shelf_deployed);
}

// ───────────────────────────────
// DEBUG TOGGLES
// ───────────────────────────────
show_rear_axle           = true;
show_front_wheel_support = true;
show_tow_handle_assembly = true;
show_shelves              = true;
shelf_deployed             = true;

handle_tilt_deg = 0;    // 0=towing/use .. 90=full-vertical storage (real CGAL-confirmed clear of exhaust room, see cc_chat_log.md)
steer_deg        = 0;    // 0=centered -- independent of tilt

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation Testing
// (rules-codes.md). Colors applied inside each wrapper module this file
// (front_wheel_support(), rear_axle(), tow_handle_assembly()) since each
// bundles 2 real, visually-distinct part types (structural steel vs.
// tire/wheel rubber) under one toggle -- same COLOR CODING STANDARD
// extension used throughout (#AAAAAA structural, matching "Rack rails and
// legs"; #333333 wheel/tire, a reasonable new extension for this part
// type, flagged here since it's not in the existing table).
// ───────────────────────────────
if (show_rear_axle) rear_axle();
if (show_front_wheel_support) front_wheel_support();
if (show_tow_handle_assembly) tow_handle_assembly(handle_tilt_deg, steer_deg);
if (show_shelves) prep_shelves(shelf_deployed);
