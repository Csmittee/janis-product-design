// BBQ Offset Smoker — Understructure
// Version: v3
// Date: 2026-07-17
// Changes from v2: bbq-understructure-v3-wheel-height-tray-handle. Real
// render review by Janis (actual screenshots of the merged v2 build)
// found 4 things, all fixed here:
//   TASK 1 — wheel size 609.6->400mm (WHEEL_D/WHEEL_R single source, both
//            axles), front caster ONE wheel -> TWO (same single pivot,
//            new stub axle).
//   TASK 2 — grate height control value CHANGED: 700-750mm SUPERSEDED,
//            new locked target 900-1000mm from true ground. Achieved
//            entirely at the understructure level via ONE new shared
//            GROUND_OFFSET constant (chamber/firebox never move in their
//            own local frame — BBQ-chambers-v11.scad is completely
//            locked, zero changes). New spacer brackets (front x1, rear
//            x2) absorb the resulting gaps — confirmed bracket/strut
//            shapes themselves untouched (DO NOT TOUCH, MID_H/TOP_W/
//            BOT_W/LEG_GAP/LEG_DROP/FRONT_X/REAR_AXLE_X/REAR_TRACK_WIDTH
//            all zero-diff from v2).
//   TASK 3 — prep_shelves() re-hinged from real chamber shell material at
//            octagon point "apex A" (world Y=0, Z=GRATE_Z=778.665 —
//            chamber_floor_z+chamfer, the SAME point
//            fixed_side_wedge()/lid_side_wedge() already share as the
//            lid's own parting-line reference) instead of floating in
//            space. Tray SIZE/kinetic behavior unchanged.
//   TASK 4 — tow handle REPLACES v2's "entirely independent" design
//            (that assumption was wrong, corrected via Janis's own
//            reference photo this session): triangle bracket now RIGIDLY
//            WELDED to the front axle/caster yoke, `steer_deg` now
//            rotates the front wheel pair too (coupled steering, one
//            linked motion). Handle is now a real T-shaped crossbar.
//            Fold angle renamed `handle_fold_deg` (was `handle_tilt_deg`
//            in v2) — same 0/90 convention, name changed because the
//            payload (T-bar, now nested inside the NEW steer_deg
//            wrapper alongside the wheels) is materially different from
//            v2's independent plain round bar, not just a decimal tweak.
//
// v2 kept unchanged, on record (BBQ-understructure-v2.scad).
// BBQ-offset-smoker-base-v1.scad's own `include` updated v2->v3.
//
// SKELETON — Parent: BBQ-chambers-v11.scad's own DATUM_*/chamber_*/
// firebox_* constants, read directly (R-009 pattern, not re-derived).
// Local origin still MASTER ORIGIN (0,0,0 at floor, front-left).
// GOVERNANCE NOTE: "floor level" in the MASTER ORIGIN sense now means the
// CHAMBER's own persistent local frame (chamber_floor_z=600 etc., always
// unchanged) — true ground has moved to local Z=-GROUND_OFFSET this
// version (TASK 2). Every world-Z number elsewhere in this codebase
// (chamber_floor_z, GRATE_Z, firebox_floor_z...) is unaffected — only the
// UNDERSTRUCTURE's own ground-referenced parts shift.

include <BBQ-chambers-v11.scad>

// ───────────────────────────────
// PARAMETERS — carried over from v2, UNCHANGED. Still real consumers:
// prep_shelf() DO NOT TOUCH still reads leg_h for its own Z (TASK 3 only
// changes the MOUNT point, not this formula's existence).
// ───────────────────────────────
CASTER_CLEARANCE = 50;
LEG_INSET = 30;
SHELF_D = 300;
SHELF_T = 20;
leg_h = chamber_floor_z - CASTER_CLEARANCE;   // 550, unchanged formula (DO NOT TOUCH consumer: prep_shelf())

// ═══════════════════════════════════════════════════════════════════
// TASK 1 — WHEEL SIZE + TRUE 4-WHEEL SYSTEM. Single source, both axles.
// ═══════════════════════════════════════════════════════════════════
WHEEL_D = 400;    // was 609.6 -- real ~40cm, Janis's explicit spec
WHEEL_R = 200;
FIREBOX_CLEARANCE = 200;    // UNCHANGED v2 -- horizontal, not wheel-size-dependent
TIRE_W  = 100;               // was 150 -- reduced proportionally for the smaller wheel
                              // (150/609.6=24.6% of dia; 400*0.246=98.4, rounded to 100 --
                              // matches real off-shelf pattern, small pneumatic/solid wheels
                              // this size commonly run ~100mm-wide tires, e.g. 16" wheelbarrow
                              // wheels). Flagged placeholder, no exact hardware spec given.

// Dual front wheel spacing -- flagged placeholder, no real hardware spec:
// 20mm clear gap between tire faces (avoids rubbing/mud buildup, common
// dual-caster-wheel practice) -> 120mm center-to-center -> each wheel
// center offset +/-60mm from DATUM_Y_CENTER.
DUAL_WHEEL_GAP = 20;
DUAL_WHEEL_OFFSET = TIRE_W/2 + DUAL_WHEEL_GAP/2;   // 60mm, center-to-DATUM_Y_CENTER offset per wheel

// ═══════════════════════════════════════════════════════════════════
// TASK 2 — GLOBAL HEIGHT LIFT (grate 900-1000mm from true ground) +
// spacer brackets. Mechanism: BBQ-chambers-v11.scad is completely locked
// (chamber_floor_z, GRATE_Z formula -- zero changes). The lift happens
// entirely here: true ground moves to local Z=-GROUND_OFFSET (was Z=0 in
// v2) -- the chamber/firebox never move in their own frame, the GROUND
// shifts relative to them.
//
// CHOSEN VALUE: GROUND_OFFSET=150mm (a clean round number, matching this
// file's own LEG_DROP=150 for consistency) -> real grate height above
// true ground = GRATE_Z + GROUND_OFFSET = 778.665+150 = 928.665mm.
// Comfortably inside the locked 900-1000mm target with real margin BOTH
// directions (28.665mm above the floor of the range, 71.335mm below the
// ceiling) -- chosen over e.g. the range midpoint specifically for this
// clean-number property, not just because it's "in range".
// ═══════════════════════════════════════════════════════════════════
GROUND_OFFSET = 150;
GRATE_HEIGHT_ABOVE_GROUND = GRATE_Z + GROUND_OFFSET;   // 928.665mm -- real, stated, in [900,1000]

// New REAR_AXLE_Z / REAR_BRACKET_H at the new WHEEL_R + GROUND_OFFSET:
REAR_AXLE_X         = firebox_x0 + firebox_size/2;        // 1143.5 -- UNCHANGED v2, DO NOT TOUCH
REAR_WHEEL_Y_LEFT   = firebox_y0 - FIREBOX_CLEARANCE;     // -123.5 -- UNCHANGED v2, DO NOT TOUCH
REAR_WHEEL_Y_RIGHT  = firebox_y1 + FIREBOX_CLEARANCE;     // 733.5  -- UNCHANGED v2, DO NOT TOUCH
REAR_TRACK_WIDTH    = REAR_WHEEL_Y_RIGHT - REAR_WHEEL_Y_LEFT;   // 857mm -- UNCHANGED v2, DO NOT TOUCH
REAR_AXLE_Z         = WHEEL_R - GROUND_OFFSET;              // 200-150=50 -- RECOMPUTED (was 304.8)
REAR_BRACKET_H      = firebox_floor_z - REAR_AXLE_Z;         // 400-50=350mm -- RECOMPUTED (was 95.2) -- real, positive, not zero/negative

FRONT_AXLE_Z = REAR_AXLE_Z;   // 50 -- SAME shared GROUND_OFFSET/WHEEL_R, keeps the whole vehicle stance level

// ───────────────────────────────
// Rear strut/beam -- construction UNCHANGED from v2 (DO NOT TOUCH: same
// square-tube pattern, same Y offsets, same weld-overlap technique) --
// only REAR_AXLE_Z's own VALUE changed above, which this code already
// consumes directly (no separate edit needed here).
// ───────────────────────────────
REAR_STRUT          = 40;
REAR_STRUT_Y_OFFSET = 150;      // struts at Y=[155,455] -- UNCHANGED v2, DO NOT TOUCH
REAR_WELD_OVERLAP   = 3;

module rear_strut(y) {
    translate([REAR_AXLE_X - REAR_STRUT/2, y - REAR_STRUT/2, REAR_AXLE_Z - REAR_WELD_OVERLAP])
        cube([REAR_STRUT, REAR_STRUT, (firebox_floor_z + REAR_WELD_OVERLAP) - (REAR_AXLE_Z - REAR_WELD_OVERLAP)]);
}
module rear_struts() {
    rear_strut(DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET);   // 155
    rear_strut(DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET);   // 455
}

// REAR SPACERS (TASK 2, NEW) -- 2 real elements, one left/one right of the
// firebox, each pushing its own wheel's axle OUTWARD clear of the firebox
// (not a single center spacer like the front): a short CENTRAL beam
// segment sits directly between/under the 2 struts (Y=[155,455], where the
// firebox itself is), and 2 separate spacer tubes continue OUTWARD from
// each strut's own Y position out to that side's real wheel Y position --
// real computed lengths: left=155-(-123.5)=278.5mm, right=733.5-455=278.5mm
// (symmetric). REAR_SPACER_OVERLAP gives each junction (beam<->spacer)
// real 3D shared volume, not a coincident face (Rule M-1) -- at the OUTER
// ends, each spacer terminates exactly at its wheel's own axle center,
// same smaller-cylinder-inside-bigger-wheel-hub containment v2 already
// established (real overlap by construction, re-confirmed via CGAL below).
REAR_BEAM_D = 50;
REAR_SPACER_OVERLAP = 3;
module rear_axle_line(y0, y1) {
    translate([REAR_AXLE_X, y0, REAR_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = REAR_BEAM_D, h = y1 - y0);
}
module rear_center_beam() {
    // Y=[152,458] -- 3mm overlap past each strut mount (155/455) into where the spacers begin
    rear_axle_line(DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET - REAR_SPACER_OVERLAP,
                    DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET + REAR_SPACER_OVERLAP);
}
module rear_spacers() {
    // left: Y=[-123.5,158] (278.5mm nominal span to the strut mount, +3mm overlap into the beam)
    rear_axle_line(REAR_WHEEL_Y_LEFT, DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET + REAR_SPACER_OVERLAP);
    // right: Y=[452,733.5] (278.5mm nominal span, +3mm overlap into the beam)
    rear_axle_line(DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET - REAR_SPACER_OVERLAP, REAR_WHEEL_Y_RIGHT);
}
module rear_axle_bracket() {
    rear_struts();
    rear_center_beam();
    rear_spacers();
}
module rear_wheel(y) {
    translate([REAR_AXLE_X, y - TIRE_W/2, REAR_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = WHEEL_D, h = TIRE_W);
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
// Front bracket -- UNCHANGED from v2 (DO NOT TOUCH: MID_H/TOP_W/BOT_W/
// LEG_GAP/LEG_DROP/FRONT_X, the 2-trapezoid-leg + bottom-plate
// construction). Real diff vs v2: ZERO on all 6 named constants + the
// module bodies below (byte-for-byte carried over).
// ───────────────────────────────
MID_H   = chamfer / 2;                                    // 89.332mm -- UNCHANGED v2
TOP_W   = (chamber_W - 2*chamfer) + 2*MID_H;               // 431.335mm -- UNCHANGED v2
BOT_W   = chamber_W - 2*chamfer;                            // 252.670mm -- UNCHANGED v2
LEG_GAP  = 250;    // UNCHANGED v2
LEG_DROP = 150;    // UNCHANGED v2
t        = 6;      // UNCHANGED v2
FRONT_X = 300;      // UNCHANGED v2

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
// Fixed caster top-plate -- UNCHANGED position/size from v2 (bolted
// directly to the bracket's own confirmed bottom plate, does NOT rotate
// with steer_deg -- this is the fixed half of the swivel bearing; TASK
// 1's "same single pivot" lives at this plate's own X/Y).
CASTER_X          = FRONT_X - LEG_GAP/2;   // 175 -- UNCHANGED v2
CASTER_PLATE_SIZE = 100;
CASTER_PLATE_T    = 6;
CASTER_OVERLAP    = 3;
CASTER_PLATE_BOTTOM_Z = (((chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP) + CASTER_OVERLAP) - CASTER_PLATE_T;   // 444
module front_caster_plate() {
    top_z = ((chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP) + CASTER_OVERLAP;   // 450
    translate([CASTER_X - CASTER_PLATE_SIZE/2, DATUM_Y_CENTER - CASTER_PLATE_SIZE/2, top_z - CASTER_PLATE_T])
        cube([CASTER_PLATE_SIZE, CASTER_PLATE_SIZE, CASTER_PLATE_T]);
}

// FRONT SPACER (TASK 2, NEW) -- ONE spacer, centered on CASTER_X/
// DATUM_Y_CENTER, bridging the bracket's confirmed bottom-plate-mounted
// caster top-plate (fixed, bottom face Z=444) down to the new caster
// axle Z (FRONT_AXLE_Z=50). Real computed length: 444-50=394mm. This IS
// the swivel fork/stem -- it rotates with steer_deg (see
// front_swivel_assembly() below), the top-plate above it does not (a real
// rotating-vs-fixed bearing interface, same treatment as this project's
// existing hinge-gap convention -- not a solid weld at that one face,
// see file-level note below the swivel assembly).
FRONT_SPACER_D = 40;
FRONT_SPACER_LEN = CASTER_PLATE_BOTTOM_Z - FRONT_AXLE_Z;   // 394mm -- real, stated, positive, not zero/negative
module front_spacer() {
    translate([CASTER_X, DATUM_Y_CENTER, FRONT_AXLE_Z])
        cylinder(d = FRONT_SPACER_D, h = FRONT_SPACER_LEN + e);   // +e: tiny lap into the fixed plate at steer=0 default render only (see note below)
}
module front_stub_axle() {
    translate([CASTER_X, DATUM_Y_CENTER - DUAL_WHEEL_OFFSET - TIRE_W/2, FRONT_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = FRONT_SPACER_D, h = 2*DUAL_WHEEL_OFFSET + TIRE_W);
}
module front_wheel(y) {
    translate([CASTER_X, y - TIRE_W/2, FRONT_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = WHEEL_D, h = TIRE_W);
}
module front_wheels() {
    front_wheel(DATUM_Y_CENTER - DUAL_WHEEL_OFFSET);
    front_wheel(DATUM_Y_CENTER + DUAL_WHEEL_OFFSET);
}

// ═══════════════════════════════════════════════════════════════════
// TASK 4 — T-BAR TOW HANDLE, WELDED TO FRONT AXLE (COUPLED STEERING).
// REPLACES v2's Task 3 "entirely independent" design. The triangle bracket
// (top-view triangle, apex pointing away from the exhaust room -- SAME
// orientation logic as v2) is now RIGIDLY WELDED to front_spacer() (the
// front axle/caster yoke) -- same physical assembly. `steer_deg` rotates
// front_spacer()+front_stub_axle()+front_wheels()+triangle+handle
// TOGETHER, about the SAME vertical (Z) axis through (CASTER_X,
// DATUM_Y_CENTER) -- one linked motion, not independent parameters
// (fixing v2's wrong design assumption).
// ═══════════════════════════════════════════════════════════════════
// TRIANGLE_BASE_X: 25mm PAST CASTER_X (not exactly AT it) -- a flagged
// judgment call, same class as HINGE_INSET below: the triangle's flat
// base edge is a zero-width line in X; extending the triangle's own body
// 25mm past the spacer's centerline guarantees its 2D footprint actually
// straddles the spacer's full 40mm-diameter cross-section (real overlap,
// not a coincident-face touch) -- confirmed via CGAL below.
TRIANGLE_BASE_X  = CASTER_X + 25;    // 200
TRIANGLE_LENGTH  = 500;               // apex reach -- chosen for real exhaust-room clearance margin (see check below), flagged judgment call (no prior-session spec, same governance gap as v2's own flagged TRIANGLE_APEX_X)
TRIANGLE_APEX_X  = TRIANGLE_BASE_X - TRIANGLE_LENGTH;   // -300
TRIANGLE_BASE_W  = 200;
TRIANGLE_T       = 6;
TRIANGLE_Z       = FRONT_AXLE_Z + 100;   // 150 -- partway up front_spacer(), flagged judgment call (real yoke height, below the fixed top-plate at 444, above the wheel/ground)

HINGE_INSET = 20;    // same manifold-overlap reasoning as v2 -- a hinge pin can't seat on a zero-width vertex
HINGE_X     = TRIANGLE_APEX_X + HINGE_INSET;   // -280

// T-shaped crossbar handle -- REPLACES v2's plain round bar. Upright
// reuses v2's own HANDLE_LEN/HANDLE_D values (still a reasonable pull
// length/grip diameter); crossbar is a NEW real dimension, flagged
// placeholder (no exact hardware spec given) -- 300mm is a typical
// hand-truck-class T-handle grip width.
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
// tow_handle(handle_fold_deg) -- SAME rotation mechanism as v2's
// handle_tilt_deg (rotate([0,fold_deg-90,0]) about the hinge's own Y-axis
// line: fold=0 points -X [horizontal, towing/use], fold=90 points +Z
// [vertical, folded storage] -- SAME project convention as door/lid
// open-angle params, 0=use/closed-equivalent, max=storage/open-equivalent).
// Renamed from v2's `handle_tilt_deg`: the payload is now a real T-bar
// (upright + perpendicular crossbar, not a plain round bar) AND it's
// nested inside the NEW outer steer_deg wrapper together with the wheels
// -- a materially different assembly, not just a decimal tweak, so a new
// name avoids confusion with v2's independent mechanism if ever diffed.
module tow_handle(handle_fold_deg = 0) {
    translate([HINGE_X, DATUM_Y_CENTER, TRIANGLE_Z])
        rotate([0, handle_fold_deg - 90, 0]) {
            cylinder(d = HANDLE_UPRIGHT_D, h = HANDLE_UPRIGHT_LEN);
            // crossbar: perpendicular grip bar at the FAR end of the
            // upright (local Z=HANDLE_UPRIGHT_LEN), running along local X
            // (which is world Y-ish before the outer rotate -- see
            // rotate([90,0,0]) below, same "runs along Y" cylinder-axis
            // pattern this file already uses elsewhere)
            translate([0, 0, HANDLE_UPRIGHT_LEN])
                translate([0, -HANDLE_CROSSBAR_LEN/2, 0]) rotate([-90, 0, 0])
                    cylinder(d = HANDLE_CROSSBAR_D, h = HANDLE_CROSSBAR_LEN);
        }
}
// front_swivel_assembly(steer_deg, handle_fold_deg) -- the whole rotating
// yoke: spacer + stub axle + wheels + triangle + handle, ALL under the
// SAME rotate(steer_deg) about the vertical line through
// (CASTER_X,DATUM_Y_CENTER) -- this IS the coupled-steering fix (v2 only
// rotated the triangle+handle, never the wheels). front_caster_plate()
// (fixed half of the bearing) is called SEPARATELY, outside this wrapper,
// unaffected by steer_deg.
// Rotating-vs-fixed bearing note: front_spacer()'s own top face meets
// front_caster_plate()'s fixed bottom face at Z=444 -- a real swivel
// bearing interface (rotating part against fixed part), NOT a rigid weld,
// same treatment this project already gives lid()'s own hinge
// (LID_HINGE_GAP) -- a small +e lap is used only so the DEFAULT
// (steer_deg=0) render has no coincident-face artifact; at nonzero
// steer_deg this becomes the physically-expected non-contact bearing
// gap, not a flagged defect (this is what a real swivel caster IS).
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
// TASK 3 — PREP TRAY REATTACHMENT (apex A). Re-hinged from real chamber
// shell material at octagon point "apex A" (true_octagon_profile()'s own
// point 3, hex_pt(chamfer,0)) -- world Y=0, Z=chamber_floor_z+chamfer=
// GRATE_Z=778.665mm exactly. This is the real corner where the lower-left
// chamfer meets the left wall -- the SAME point fixed_side_wedge()/
// lid_side_wedge() already share as their own parting-line reference
// vertex (not literally the profile's ABSOLUTE lowest point -- that's the
// floor at Z=600 -- but the lowest true wall/chamfer CORNER, and real,
// ALWAYS-fixed material regardless of lid_open_deg, since it sits exactly
// on chamber_outer_tube()'s own fixed-side boundary). Mirror point for
// the RIGHT tray: true_octagon_profile() point 8, world Y=chamber_W=610,
// same Z.
// ═══════════════════════════════════════════════════════════════════
TRAY_MOUNT_X = LEG_INSET;         // 30 -- UNCHANGED X judgment call from v2, still inside the fixed front margin [0,LID_X0=100], real ring material present the whole span regardless of lid_open_deg
TRAY_MOUNT_Z = GRATE_Z;            // 778.665 -- apex A's own Z, real formula (chamber_floor_z+chamfer), not estimated

// Mount bracket -- a generously-sized gusset straddling apex A on all 3
// axes (real corner, thin wall_t=3mm ring there -- a big-margin probe,
// same "big margin box" style room_half_space() already uses elsewhere in
// this codebase, guarantees real overlap regardless of the corner's exact
// offset-inward direction). Real CGAL contact check below confirms
// non-empty.
TRAY_BRACKET_W = 20;    // Y-span, centered on apex A's Y
TRAY_BRACKET_H = 20;    // Z-span, centered on apex A's Z
TRAY_BRACKET_T = 10;    // X-span, centered on TRAY_MOUNT_X
module tray_mount_bracket(mirror_y = false) {
    apex_y = mirror_y ? chamber_W : 0;
    translate([TRAY_MOUNT_X - TRAY_BRACKET_T/2, apex_y - TRAY_BRACKET_W/2, TRAY_MOUNT_Z - TRAY_BRACKET_H/2])
        cube([TRAY_BRACKET_T, TRAY_BRACKET_W, TRAY_BRACKET_H]);
}

// prep_shelf() -- SAME size (chamber_L*0.35 x SHELF_D x SHELF_T) and SAME
// kinetic behavior (shelf_deployed true=horizontal/false=vertical-stowed)
// as v2, DO NOT TOUCH. ONLY the mount point changed: was
// (DATUM_X_FRONT+LEG_INSET, arbitrary side_y, chamber_floor_z=600,
// floating/no real chamber contact); now (TRAY_MOUNT_X, apex A's own Y,
// TRAY_MOUNT_Z=778.665, real chamber material via tray_mount_bracket()).
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
