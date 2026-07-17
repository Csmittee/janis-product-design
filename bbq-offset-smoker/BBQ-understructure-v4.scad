// BBQ Offset Smoker — Understructure
// Version: v4
// Date: 2026-07-17
// Changes from v3: bbq-chambers-v12-firebox-rebuild-understructure-v4-wheel.
// TASK 3 — WHEEL SIZE CORRECTION + WORLD-Z RE-ANCHOR.
//
// *** MANDATORY REAL CHECK (performed BEFORE any other math, per this
// task's own explicit instruction) *** — Janis flagged suspicion the
// wheel's bottom may not actually sit at world Z=0. Real current (v3,
// pre-fix) REAR_AXLE_Z = 50mm (WHEEL_R(200, OLD) - GROUND_OFFSET(150)).
// Check: REAR_AXLE_Z - WHEEL_R(old) = 50 - 200 = -150mm. CONFIRMED NOT
// ZERO — the wheel's real bottom sits at raw Z=-150mm, 150mm BELOW this
// project's own standing MASTER ORIGIN/floor-level Z=0 convention
// (rules-dimensions.md: "Z-axis: vertical... Z=0 at floor"). Janis's
// suspicion is CONFIRMED REAL, not a false alarm.
//
// ROOT CAUSE (real, not previously stated this plainly): v3's own
// GROUND_OFFSET=150 was used ONLY inside REAR_AXLE_Z's formula (a
// SUBTRACTIVE term that pushes the wheel's computed position 150mm lower
// than a direct WHEEL_R placement would) and to compute a DERIVED
// reporting statistic (GRATE_HEIGHT_ABOVE_GROUND = GRATE_Z+GROUND_OFFSET
// = 928.665mm). v3's own header claimed "true ground moves to local
// Z=-GROUND_OFFSET" as if this were an actually-applied coordinate shift
// — it was NOT. Nothing in v3 (or any version before it) ever applied a
// real geometric transform anchoring literal Z=0 to the wheel's own
// ground-contact point. The 928.665mm "real grate height above true
// ground" figure was/is REAL as a physical proportion between the wheel
// and the grate (verified: GRATE_Z(778.665, chamber, frozen, unmoved) -
// wheel_bottom_raw(-150) = 928.665mm, matches exactly) — but it measures
// from an INVENTED reference plane (raw Z=-150) that was never the
// project's own real Z=0 floor datum, and was never independently
// verified as "the wheel's bottom" by anyone until this task's mandatory
// check.
//
// FIX (per this task's own explicit, unambiguous instruction: "world Z=0
// must equal the wheel's own ground-contact point, full stop"):
// REAR_AXLE_Z = WHEEL_R directly (GROUND_OFFSET's subtractive role in this
// formula RETIRED — R-009 confirmed zero other real consumers before
// removing the constant entirely). This is a DIRECT, unambiguous
// construction: a wheel's bottom is exactly WHEEL_R below its own axle
// center, by definition — for wheel-bottom to land at literal world Z=0,
// axle center must sit at literal world Z=WHEEL_R. Zero ambiguity, zero
// new transform/scoping risk (chamber_shell()'s own geometry, per
// BBQ-chambers-v12.scad's DO NOT TOUCH, cannot itself be moved by an
// outer transform without touching frozen chamber constants — this fix
// does not require one).
//
// *** REAL, FLAGGED CONSEQUENCE — NOT SILENTLY ABSORBED ***: because
// BBQ-chambers-v12.scad's own GRATE_Z stays frozen (778.665mm, chamber
// never moves), this direct anchor fix means the REAL grate-height-above-
// (now correctly zeroed)-ground becomes GRATE_Z - 0 = 778.665mm, NOT the
// v3-computed 928.665mm. This is BELOW design_scope_of_work_rule.md's
// Envelope section's standing 900-1000mm "locked target... from true
// ground" (set last round, v3). This is a REAL, direct conflict between
// (a) this task's own explicit, unambiguous "world Z=0 = wheel contact,
// full stop" instruction and (b) the standing Envelope target — NOT
// silently resolved either direction here. The only way to satisfy BOTH
// simultaneously would require moving the CHAMBER's own literal position
// (via a uniform whole-assembly transform), which is blocked by
// BBQ-chambers-v12.scad's explicit chamber-frozen DO NOT TOUCH this
// round, and which is not technically achievable via an `include`-wrapping
// transform in this codebase's current file structure (module definitions
// inside a transformed `{}` block containing an `include` fail to parse —
// verified directly via a real OpenSCAD test before choosing this
// approach, not assumed). Flagged here, in cc_chat_log.md, and in
// design_scope_of_work_rule.md's own Envelope section for Janis/Claude
// Web to resolve — a real open item, not a defect silently introduced.
//
// WHEEL_D/WHEEL_R/TREAD_W = 457.2/228.6/200mm (18" wheel — FINAL, locked,
// no further changes per this task), single source, both rear axle wheels
// and the front caster's two wheels consume it (unchanged single-source
// pattern from v3, just new values + TREAD_W is the prompt's own name,
// replaces v3's `TIRE_W`).
//
// FRONT AXLE: FRONT_AXLE_Z = REAR_AXLE_Z (unchanged v3 pattern — same
// shared anchor, keeps the whole vehicle stance level) = 228.6mm. Front
// wheel bottom = FRONT_AXLE_Z - WHEEL_R = 228.6-228.6 = 0mm — CONFIRMED
// at world Z=0, same direct-construction guarantee as the rear.
//
// REAR_BRACKET_H recomputed from the NEW firebox bottom_Z (571.4mm, LIVE
// from BBQ-chambers-v12.scad's own firebox_floor_z, read directly not
// copied) and NEW REAR_AXLE_Z: REAR_BRACKET_H = 571.4 - 228.6 = 342.8mm
// (was 350mm in v3 — real, positive, not zero/negative).
//
// FRONT_SPACER_LEN (DERIVED, automatically recomputes since FRONT_AXLE_Z
// changed, CASTER_PLATE_BOTTOM_Z=444 itself DO NOT TOUCH/unchanged):
// 444 - 228.6 = 215.4mm (was 394mm) — real, flagged, positive.
//
// REAR_WHEEL_Y_LEFT/RIGHT/REAR_TRACK_WIDTH: UNCHANGED FORMULAS (still
// firebox_y0-FIREBOX_CLEARANCE / firebox_y1+FIREBOX_CLEARANCE), but their
// REAL VALUES change as a flagged side effect of BBQ-chambers-v12.scad's
// wider firebox (FIREBOX_W=510, was 457): REAR_WHEEL_Y_LEFT -150 (was
// -123.5), REAR_WHEEL_Y_RIGHT 760 (was 733.5), REAR_TRACK_WIDTH 910mm
// (was 857mm, real +53mm, exactly matching the firebox's own +53mm width
// growth, symmetric). This is NOT "front axle span" (explicitly deferred
// per this prompt's own scope note below) — it is the REAR track width,
// not explicitly listed in this round's DO NOT TOUCH, and follows
// automatically from firebox_y0/y1 (R-009: formula unchanged, inputs
// changed) — flagged here, not silently absorbed.
//
// REAR_AXLE_X: formula updated from v3's `firebox_x0 + firebox_size/2`
// (firebox_size no longer exists — BBQ-chambers-v12.scad replaced the
// uniform cube with independent FIREBOX_L/W/H) to
// `(firebox_x0 + firebox_x1) / 2` — mathematically IDENTICAL result
// (1143.5mm, confirmed, real value UNCHANGED from v3, since v12's firebox
// is explicitly centered on the SAME old X-midpoint per its own TASK 1) —
// a construction-syntax update only, zero real value change.
//
// **Explicitly NOT in scope this round** (unchanged from the prompt):
// front axle span/parallelism vs. the new firebox width, spacer brackets
// (front/rear) RESIZING (their real lengths recompute automatically above
// via existing unchanged formulas, but no NEW spacer construction/shape
// work is done), T-bar handle rebuild, front bracket height alignment to
// the new firebox bottom — all deferred to a follow-up prompt.
//
// v3 kept unchanged, on record (BBQ-understructure-v3.scad).
// BBQ-offset-smoker-base-v1.scad's own `include` updated v3->v4.
//
// SKELETON — Parent: BBQ-chambers-v12.scad's own DATUM_*/chamber_*/
// firebox_* constants, read directly (R-009 pattern, not re-derived).
// Local origin still MASTER ORIGIN (0,0,0 at floor, front-left) — this
// version, for the FIRST time, that origin is real-CGAL-confirmed to
// coincide with the wheel's own ground-contact point (see mandatory check
// above) — "this is the anchor everything else in future prompts will be
// checked against," per this task's own instruction.

include <BBQ-chambers-v12.scad>

// ───────────────────────────────
// PARAMETERS — carried over from v3, UNCHANGED. Still real consumers:
// prep_shelf() DO NOT TOUCH still reads leg_h for its own Z.
// ───────────────────────────────
CASTER_CLEARANCE = 50;
LEG_INSET = 30;
SHELF_D = 300;
SHELF_T = 20;
leg_h = chamber_floor_z - CASTER_CLEARANCE;   // 550, unchanged formula (DO NOT TOUCH consumer: prep_shelf())

// ═══════════════════════════════════════════════════════════════════
// TASK 3 — WHEEL SIZE + WORLD-Z RE-ANCHOR. Single source, both axles.
// ═══════════════════════════════════════════════════════════════════
WHEEL_D = 457.2;   // 18" -- FINAL, locked, no further changes (was 400)
WHEEL_R = 228.6;
TREAD_W = 200;      // was TIRE_W=100 in v3 -- renamed to match this prompt's own naming exactly
FIREBOX_CLEARANCE = 200;    // UNCHANGED v3 -- horizontal, not wheel-size-dependent

// Dual front wheel spacing -- flagged placeholder, no real hardware spec
// (unchanged reasoning from v3, just re-derived off the new TREAD_W):
// 20mm clear gap between tire faces -> 220mm center-to-center -> each
// wheel center offset +/-110mm from DATUM_Y_CENTER.
DUAL_WHEEL_GAP = 20;
DUAL_WHEEL_OFFSET = TREAD_W/2 + DUAL_WHEEL_GAP/2;   // 110mm (was 60mm), center-to-DATUM_Y_CENTER offset per wheel

// REAR_AXLE_Z -- v4 TASK 3 FIX: direct construction, wheel bottom = world
// Z=0 (see file header mandatory check + fix rationale). GROUND_OFFSET
// (v3 constant) RETIRED entirely -- R-009 confirmed zero other real
// consumers in this file before removal.
REAR_AXLE_Z         = WHEEL_R;                               // 228.6mm -- wheel bottom = REAR_AXLE_Z-WHEEL_R = 0mm exactly
GRATE_HEIGHT_ABOVE_GROUND = GRATE_Z;                          // 778.665mm -- now DIRECT (world Z=0 IS ground, post-fix); see file header flagged conflict vs the 900-1000mm Envelope target

REAR_AXLE_X         = (firebox_x0 + firebox_x1) / 2;          // 1143.5 -- construction updated for v12's independent firebox_x0/x1 (real value UNCHANGED from v3, see file header)
REAR_WHEEL_Y_LEFT   = firebox_y0 - FIREBOX_CLEARANCE;         // -150 -- UNCHANGED FORMULA, real value shifts w/ v12's wider firebox (flagged, file header)
REAR_WHEEL_Y_RIGHT  = firebox_y1 + FIREBOX_CLEARANCE;         // 760  -- UNCHANGED FORMULA, real value shifts w/ v12's wider firebox (flagged, file header)
REAR_TRACK_WIDTH    = REAR_WHEEL_Y_RIGHT - REAR_WHEEL_Y_LEFT;   // 910mm (was 857mm, flagged, file header)
REAR_BRACKET_H      = firebox_floor_z - REAR_AXLE_Z;            // 571.4-228.6=342.8mm (was 350mm) -- real, positive, not zero/negative

FRONT_AXLE_Z = REAR_AXLE_Z;   // 228.6 -- SAME shared anchor, keeps the whole vehicle stance level; front wheel bottom = 0mm, confirmed (file header)

// ───────────────────────────────
// Rear strut/beam -- construction UNCHANGED from v3 (DO NOT TOUCH: same
// square-tube pattern, same Y offsets, same weld-overlap technique) --
// only REAR_AXLE_Z's own VALUE changed above, which this code already
// consumes directly (no separate edit needed here).
// ───────────────────────────────
REAR_STRUT          = 40;
REAR_STRUT_Y_OFFSET = 150;      // struts at Y=[155,455] -- UNCHANGED v3, DO NOT TOUCH
REAR_WELD_OVERLAP   = 3;

module rear_strut(y) {
    translate([REAR_AXLE_X - REAR_STRUT/2, y - REAR_STRUT/2, REAR_AXLE_Z - REAR_WELD_OVERLAP])
        cube([REAR_STRUT, REAR_STRUT, (firebox_floor_z + REAR_WELD_OVERLAP) - (REAR_AXLE_Z - REAR_WELD_OVERLAP)]);
}
module rear_struts() {
    rear_strut(DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET);   // 155
    rear_strut(DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET);   // 455
}

// REAR SPACERS -- construction UNCHANGED from v3 (DO NOT TOUCH), values
// recompute automatically from REAR_WHEEL_Y_LEFT/RIGHT above (real: left/
// right spacer span 308mm each, was 278.5mm -- +29.5mm real length each,
// tracking the wider rear track, flagged not silently absorbed).
REAR_BEAM_D = 50;
REAR_SPACER_OVERLAP = 3;
module rear_axle_line(y0, y1) {
    translate([REAR_AXLE_X, y0, REAR_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = REAR_BEAM_D, h = y1 - y0);
}
module rear_center_beam() {
    rear_axle_line(DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET - REAR_SPACER_OVERLAP,
                    DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET + REAR_SPACER_OVERLAP);
}
module rear_spacers() {
    rear_axle_line(REAR_WHEEL_Y_LEFT, DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET + REAR_SPACER_OVERLAP);
    rear_axle_line(DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET - REAR_SPACER_OVERLAP, REAR_WHEEL_Y_RIGHT);
}
module rear_axle_bracket() {
    rear_struts();
    rear_center_beam();
    rear_spacers();
}
module rear_wheel(y) {
    translate([REAR_AXLE_X, y - TREAD_W/2, REAR_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = WHEEL_D, h = TREAD_W);
}
module rear_wheels() {
    rear_wheel(REAR_WHEEL_Y_LEFT);
    rear_wheel(REAR_WHEEL_Y_RIGHT);
}
module rear_axle() {
    color("#AAAAAA", 1.0) rear_axle_bracket();
    color("#333333", 1.0) rear_wheels();
}

// ───────────────────────────────
// Front bracket -- UNCHANGED from v3 (DO NOT TOUCH: MID_H/TOP_W/BOT_W/
// LEG_GAP/LEG_DROP/FRONT_X, the 2-trapezoid-leg + bottom-plate
// construction). Real diff vs v3: ZERO on all 6 named constants + the
// module bodies below (byte-for-byte carried over, none depend on
// WHEEL_R/REAR_AXLE_Z/firebox size).
// ───────────────────────────────
MID_H   = chamfer / 2;                                    // 89.332mm -- UNCHANGED
TOP_W   = (chamber_W - 2*chamfer) + 2*MID_H;               // 431.335mm -- UNCHANGED
BOT_W   = chamber_W - 2*chamfer;                            // 252.670mm -- UNCHANGED
LEG_GAP  = 250;    // UNCHANGED
LEG_DROP = 150;    // UNCHANGED
t        = 6;      // UNCHANGED
FRONT_X = 300;      // UNCHANGED

BOT_OVERLAP = 3;

module front_bracket_leg_profile() {
    polygon(points=[
        hex_pt(MID_H, DATUM_Y_CENTER - TOP_W/2),
        hex_pt(MID_H, DATUM_Y_CENTER + TOP_W/2),
        hex_pt(-LEG_DROP, DATUM_Y_CENTER + BOT_W/2),
        hex_pt(-LEG_DROP, DATUM_Y_CENTER - BOT_W/2),
    ]);
}
module front_bracket_leg(xc) {
    translate([xc - t/2, 0, chamber_floor_z]) rotate([0, 90, 0])
        linear_extrude(height = t, convexity = 4) front_bracket_leg_profile();
}
module front_bracket_bottom() {
    translate([FRONT_X - LEG_GAP, DATUM_Y_CENTER - BOT_W/2, (chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP])
        cube([LEG_GAP, BOT_W, t]);
}
module front_bracket() {
    front_bracket_leg(FRONT_X);
    front_bracket_leg(FRONT_X - LEG_GAP);
    front_bracket_bottom();
}
// Fixed caster top-plate -- UNCHANGED position/size from v3.
CASTER_X          = FRONT_X - LEG_GAP/2;   // 175 -- UNCHANGED
CASTER_PLATE_SIZE = 100;
CASTER_PLATE_T    = 6;
CASTER_OVERLAP    = 3;
CASTER_PLATE_BOTTOM_Z = (((chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP) + CASTER_OVERLAP) - CASTER_PLATE_T;   // 444
module front_caster_plate() {
    top_z = ((chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP) + CASTER_OVERLAP;   // 450
    translate([CASTER_X - CASTER_PLATE_SIZE/2, DATUM_Y_CENTER - CASTER_PLATE_SIZE/2, top_z - CASTER_PLATE_T])
        cube([CASTER_PLATE_SIZE, CASTER_PLATE_SIZE, CASTER_PLATE_T]);
}

// FRONT SPACER -- construction UNCHANGED from v3 (DO NOT TOUCH). Real
// LENGTH recomputes automatically (215.4mm, was 394mm -- flagged, file
// header) since FRONT_AXLE_Z changed above; this IS the swivel fork/stem,
// rotates with steer_deg.
FRONT_SPACER_D = 40;
FRONT_SPACER_LEN = CASTER_PLATE_BOTTOM_Z - FRONT_AXLE_Z;   // 215.4mm (was 394mm) -- real, stated, positive
module front_spacer() {
    translate([CASTER_X, DATUM_Y_CENTER, FRONT_AXLE_Z])
        cylinder(d = FRONT_SPACER_D, h = FRONT_SPACER_LEN + e);
}
module front_stub_axle() {
    translate([CASTER_X, DATUM_Y_CENTER - DUAL_WHEEL_OFFSET - TREAD_W/2, FRONT_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = FRONT_SPACER_D, h = 2*DUAL_WHEEL_OFFSET + TREAD_W);
}
module front_wheel(y) {
    translate([CASTER_X, y - TREAD_W/2, FRONT_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = WHEEL_D, h = TREAD_W);
}
module front_wheels() {
    front_wheel(DATUM_Y_CENTER - DUAL_WHEEL_OFFSET);
    front_wheel(DATUM_Y_CENTER + DUAL_WHEEL_OFFSET);
}

// ═══════════════════════════════════════════════════════════════════
// TOW HANDLE -- UNCHANGED from v3 (DO NOT TOUCH this round, per prompt's
// own explicit scope note: "T-bar handle rebuild... explicitly deferred").
// TRIANGLE_Z's formula (FRONT_AXLE_Z+100) automatically stays valid at the
// new FRONT_AXLE_Z (100mm above the new axle, still well within
// front_spacer()'s own real span [FRONT_AXLE_Z, CASTER_PLATE_BOTTOM_Z] =
// [228.6,444] -- confirmed real, positive margin both directions, not
// just assumed).
// ═══════════════════════════════════════════════════════════════════
TRIANGLE_BASE_X  = CASTER_X + 25;    // 200 -- UNCHANGED
TRIANGLE_LENGTH  = 500;               // UNCHANGED
TRIANGLE_APEX_X  = TRIANGLE_BASE_X - TRIANGLE_LENGTH;   // -300
TRIANGLE_BASE_W  = 200;
TRIANGLE_T       = 6;
TRIANGLE_Z       = FRONT_AXLE_Z + 100;   // 328.6 (was 150) -- still real/positive within front_spacer()'s new span, confirmed

HINGE_INSET = 20;
HINGE_X     = TRIANGLE_APEX_X + HINGE_INSET;   // -280

HANDLE_UPRIGHT_LEN = 400;
HANDLE_UPRIGHT_D   = 25;
HANDLE_CROSSBAR_LEN = 300;
HANDLE_CROSSBAR_D   = 25;

module tow_triangle_profile() {
    polygon(points=[
        [TRIANGLE_APEX_X, DATUM_Y_CENTER],
        [TRIANGLE_BASE_X, DATUM_Y_CENTER - TRIANGLE_BASE_W/2],
        [TRIANGLE_BASE_X, DATUM_Y_CENTER + TRIANGLE_BASE_W/2],
    ]);
}
module tow_triangle() {
    translate([0, 0, TRIANGLE_Z]) linear_extrude(height = TRIANGLE_T, convexity = 2) tow_triangle_profile();
}
module tow_handle(handle_fold_deg = 0) {
    translate([HINGE_X, DATUM_Y_CENTER, TRIANGLE_Z])
        rotate([0, handle_fold_deg - 90, 0]) {
            cylinder(d = HANDLE_UPRIGHT_D, h = HANDLE_UPRIGHT_LEN);
            translate([0, 0, HANDLE_UPRIGHT_LEN])
                translate([0, -HANDLE_CROSSBAR_LEN/2, 0]) rotate([-90, 0, 0])
                    cylinder(d = HANDLE_CROSSBAR_D, h = HANDLE_CROSSBAR_LEN);
        }
}
module front_swivel_assembly(steer_deg = 0, handle_fold_deg = 0) {
    translate([CASTER_X, DATUM_Y_CENTER, 0]) rotate([0, 0, steer_deg]) translate([-CASTER_X, -DATUM_Y_CENTER, 0]) {
        color("#AAAAAA", 1.0) {
            front_spacer();
            front_stub_axle();
            tow_triangle();
        }
        color("#333333", 1.0) front_wheels();
        color("#AAAAAA", 1.0) tow_handle(handle_fold_deg);
    }
}
module front_wheel_support(steer_deg = 0, handle_fold_deg = 0) {
    color("#AAAAAA", 1.0) {
        front_bracket();
        front_caster_plate();
    }
    front_swivel_assembly(steer_deg, handle_fold_deg);
}

// ═══════════════════════════════════════════════════════════════════
// PREP TRAY -- UNCHANGED from v3 (DO NOT TOUCH this round). Mount point
// (apex A, GRATE_Z=778.665) is chamber-frozen, unaffected by TASK 3.
// ═══════════════════════════════════════════════════════════════════
TRAY_MOUNT_X = LEG_INSET;         // 30
TRAY_MOUNT_Z = GRATE_Z;            // 778.665

TRAY_BRACKET_W = 20;
TRAY_BRACKET_H = 20;
TRAY_BRACKET_T = 10;
module tray_mount_bracket(mirror_y = false) {
    apex_y = mirror_y ? chamber_W : 0;
    translate([TRAY_MOUNT_X - TRAY_BRACKET_T/2, apex_y - TRAY_BRACKET_W/2, TRAY_MOUNT_Z - TRAY_BRACKET_H/2])
        cube([TRAY_BRACKET_T, TRAY_BRACKET_W, TRAY_BRACKET_H]);
}
module prep_shelf(apex_y, shelf_deployed = true) {
    translate([TRAY_MOUNT_X, apex_y, TRAY_MOUNT_Z])
        rotate([shelf_deployed ? 0 : -90, 0, 0])
            cube([chamber_L*0.35, SHELF_D, SHELF_T]);
}
module prep_shelves(shelf_deployed = true) {
    tray_mount_bracket(false);
    tray_mount_bracket(true);
    translate([0, -SHELF_D, 0]) prep_shelf(0, shelf_deployed);
    mirror([0, 1, 0]) translate([0, chamber_W - SHELF_D, 0]) prep_shelf(0, shelf_deployed);
}

// ───────────────────────────────
// DEBUG TOGGLES
// ───────────────────────────────
show_rear_axle           = true;
show_front_wheel_support = true;
show_shelves               = true;
shelf_deployed              = true;

handle_fold_deg = 0;    // 0=towing/use (horizontal) .. 90=folded vertical storage
steer_deg        = 0;    // rotates front_spacer()+front_stub_axle()+front_wheels()+triangle+handle TOGETHER (coupled steering)

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation Testing
// (rules-codes.md).
// ───────────────────────────────
if (show_rear_axle) rear_axle();
if (show_front_wheel_support) front_wheel_support(steer_deg, handle_fold_deg);
if (show_shelves) color("#AAAAAA", 1.0) prep_shelves(shelf_deployed);
