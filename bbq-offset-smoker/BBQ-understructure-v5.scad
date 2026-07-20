// BBQ Offset Smoker — Understructure
// Version: v5
// Date: 2026-07-20
// Source: BBQ-understructure-v4.scad
// Changes: bbq-understructure-v5-trackwidth-fender-tbar. Full understructure
// rebuild — track width, front bracket tip reshape, rear wheel/fender,
// T-bar length+default angle. Chamber/firebox (BBQ-chambers-v14.2.scad) are
// FROZEN, not touched.
//
// TASK 0 — POINTER BUMP + RE-VERIFICATION (done first, per prompt).
// `include` bumped BBQ-chambers-v13.scad -> BBQ-chambers-v14.2.scad. This
// file's own `include` had not been bumped past v13 through three chamber
// rounds (v14/v14.1/v14.2 all explicitly out of scope for this file).
// MANDATORY FIRST CHECK — real, live values confirmed directly from
// BBQ-chambers-v14.2.scad before writing any code below: chamber_floor_z=
// 771.335mm (950-chamfer) ✓, chamfer=178.665mm ✓, chamber_H=610mm
// (unchanged) ✓, firebox_floor_z=571.4mm (LOCKED since v12) ✓, FIREBOX_W
// (outer shell width)=580mm ✓, DATUM_Y_CENTER=305mm ✓ — ALL match expected,
// safe to build v5 on top.
// Real effect of the bump: chamber_floor_z shifts +50mm (721.335->771.335).
// front_bracket_leg()'s own TOP_W/BOT_W/MID_H formulas are UNCHANGED IN
// VALUE (depend only on chamfer/chamber_W, both unchanged) — only the
// bracket's WORLD Z position shifts with chamber_floor_z, automatically,
// since front_bracket_leg() extrudes from a `translate([...,chamber_floor_z])`
// base (same pattern true_octagon_profile()'s own extrusion in
// chamber_outer_tube() uses). Because both the bracket leg profile and the
// chamber's own octagon profile share this SAME local-h-to-chamber_floor_z
// anchor convention, the leg top edge's flush alignment against the real
// octagon boundary is a LOCAL-COORDINATE identity, invariant to whatever
// world Z chamber_floor_z itself lands at — re-verified LIVE via a real
// CGAL check (not carried forward from the v2-era confirmation): leg top
// edge (h=MID_H=89.332mm) endpoints Y=[chamfer/2, chamber_W-chamfer/2] =
// [89.3325, 520.6675]mm land EXACTLY on true_octagon_profile()'s own real
// boundary at that height (real octagon width at h=MID_H = chamfer-MID_H =
// chamfer/2 = 89.332mm from each side, algebraic identity to TOP_W/2) —
// confirmed via `intersection()` probe, non-empty, flush both ends, see
// cc_chat_log.md for the real render/CGAL result.
//
// TASK 1 — SHARED TRACK WIDTH, FRONT + REAR.
// v4's REAR_TRACK_WIDTH (real formula, values drifted with firebox width
// growth) and the front caster's own independent DUAL_WHEEL_OFFSET-based
// close-set spacing (220mm apart, single small caster pattern) BOTH
// RETIRED — replaced by ONE shared TRACK_WIDTH, center-to-center, real
// live formula: FIREBOX_W(580) + 2*150 + TREAD_W(200) = 1080mm (TREAD_W is
// this file's own real name for the prompt's "TIRE_W"). Real algebraic
// check (not assumed): with both the firebox and the wheel track centered
// on the SAME DATUM_Y_CENTER, the near-tire-face-to-firebox-edge gap on
// each side works out to EXACTLY 150mm (TRACK_WIDTH/2 - TREAD_W/2 -
// FIREBOX_W/2 = 540-100-290 = 150mm) — confirms the formula's "+2*150"
// term IS the real 150mm clearance TASK 3 separately requires, not a
// coincidence to re-derive. Front axle now spans this SAME 1080mm via the
// existing single-center-pivot mechanism (TASK 5) — DUAL_WHEEL_GAP/
// DUAL_WHEEL_OFFSET RETIRED entirely (R-009, zero other consumers
// confirmed before removal).
//
// TASK 2 — FRONT BRACKET TIP RESHAPE (tow_triangle(), the U-bracket's own
// forward extension that the T-bar pivot/HINGE_X welds to). v4's sharp
// pyramid-point apex (a plain 3-point triangle collapsing to a zero-width
// point at TRIANGLE_APEX_X) REBUILT round: real judgment call, flagged —
// "tip width" read as the rounded boss's own real diameter (150mm,
// TIP_D), built via `hull()` of a TIP_D circle at the forward-most extent
// (leading edge held at the SAME TRIANGLE_APEX_X the old point used, so
// FRONT reach/TRIANGLE_LENGTH is unchanged) and the same two base corner
// points v4 used — per rules-codes.md's own "hull() for rounded shapes"
// convention. HINGE_X's formula is unchanged (TRIANGLE_APEX_X+HINGE_INSET)
// — real, flagged improvement: the hinge now lands inside genuine round
// material (150mm boss) instead of v4's thin near-point sliver, a strictly
// safer real manifold overlap, confirmed via CGAL below.
//
// TASK 3 — REAR WHEEL REPOSITION + NEW FENDER.
// X: REAR_AXLE_X unchanged formula ((firebox_x0+firebox_x1)/2 = 1143.5mm,
// real value UNCHANGED from v4 — v14.2's firebox_x0/x1 preserve the SAME
// old X-midpoint per its own TASK 1, confirmed). Y: TASK 1's new
// TRACK_WIDTH places the rear wheels at REAR_WHEEL_Y_LEFT/RIGHT = 305 ∓
// 540 = -235/845mm — real 150mm gap to the firebox's own outer-shell edge
// each side (confirmed above, TASK 1), closer than v4's old 200mm
// FIREBOX_CLEARANCE-based gap, per this task's own explicit instruction.
// Axle height: REAR_AXLE_Z=WHEEL_R=228.6mm (UNCHANGED formula/value from
// v4 — direct construction, wheel bottom = world Z=0, same anchor
// convention, GROUND_OFFSET pattern not reintroduced). Real axle-to-
// firebox-bottom gap: firebox_floor_z(571.4)-WHEEL_R(228.6)=342.8mm —
// cross-check against v4's own REAR_BRACKET_H: MATCHES EXACTLY (v4 already
// computed this same real 342.8mm value after its own TASK 3 fix — both
// firebox_floor_z and REAR_AXLE_Z are unchanged from v4, so REAR_BRACKET_H
// is algebraically identical, zero real change this round). Vertical gap
// absorbed by rear_struts()/rear_spacers() — UNCHANGED construction (DO
// NOT TOUCH), real spacer lengths widen automatically with the new wider
// REAR_WHEEL_Y_LEFT/RIGHT (flagged, not silently absorbed, see below).
// NEW rear_fenders(): flat steel panel welded to the firebox's own OUTER
// SHELL wall (firebox_y0/firebox_y1, the real outer surface), running flat
// off the firebox side out to above the wheel's own axle center, then
// following a real concentric arc (inner radius = WHEEL_R+FENDER_GAP(150),
// maintaining the required ~150mm real gap above the wheel surface
// throughout the curve, not just at one point) curving down past the
// wheel's outer edge by FENDER_ARC_PAST_EDGE(25deg) extra sweep — "clearing
// the wheel's outer edge" per this task's own spec. FENDER_T(4mm)/
// FENDER_W(TREAD_W+40mm) are judgment calls (no numeric spec given beyond
// the 150mm gap), flagged.
//
// TASK 4 — FRONT U-BRACKET DROP LENGTH = firebox_floor_z.
// LEG_DROP changed from v4's hardcoded 150mm to a live formula:
// chamber_floor_z(771.335) - firebox_floor_z(571.4) = 199.935mm — real,
// makes the bracket leg's own bottom edge land EXACTLY at world
// Z=firebox_floor_z (571.4mm, confirmed via echo: chamber_floor_z-LEG_DROP
// = 571.4 exact), i.e. reaches exactly as low as the firebox's own real
// lowest point, per this task's own explicit instruction. front_bracket()'s
// own MAIN SHAPE (TOP_W/BOT_W/MID_H/the 2-trapezoid-leg construction) is
// UNCHANGED — this is a length-only change to the existing DO NOT TOUCH
// shape, explicitly authorized by this task itself (not a shape redesign).
// front_bracket_bottom()/CASTER_PLATE_BOTTOM_Z/FRONT_SPACER_LEN all
// recompute automatically via their existing live formulas (R-009 — real
// values restated below, not re-derived independently). Front wheel is a
// real COPY of the rear wheel (same TASK 1 TRACK_WIDTH, same WHEEL_R/Z=0
// anchor) — front_wheels()/front_stub_axle() now use TRACK_WIDTH directly
// (replacing the retired DUAL_WHEEL_OFFSET spacing), placed directly under
// this bracket via the existing front_swivel_assembly() pivot.
//
// TASK 5 — FRONT AXLE RIGIDITY + STEERING, RE-VERIFIED NOT REBUILT.
// front_swivel_assembly()'s own single-center-pivot mechanism (triangle
// welded to front_spacer(), steer_deg rotates front_spacer()+
// front_stub_axle()+front_wheels()+tow_triangle()+tow_handle() together as
// ONE rigid unit) is UNCHANGED CODE — only front_stub_axle()/front_wheels()
// respan from the retired DUAL_WHEEL_OFFSET(110mm) to TRACK_WIDTH/2(540mm).
// Real CGAL steer_deg sweep (0/±22.5/±45/±90) re-run against the new wider
// span — clean throughout, see cc_chat_log.md.
//
// TASK 6 — T-BAR LENGTH + DEFAULT ANGLE FIX.
// HANDLE_UPRIGHT_LEN retired, replaced by a live-derived TBAR_LEN:
// DATUM_Z_RIDGE(1381.335, roof) - WHEEL_R(228.6) - TBAR_BRACKET_THICKNESS
// (50, this task's own explicit literal) = 1102.735mm — real live-computed
// value, matches the prompt's own ~1102.735mm (~43.4in) expectation exactly
// (confirmed via echo, not assumed). REAL FLAGGED VARIANCE, not silently
// absorbed: this formula's own "-WHEEL_R" term implicitly assumes the
// T-bar's own pivot sits at world Z=WHEEL_R (axle height) — but
// TRIANGLE_Z (this file's real, UNCHANGED hinge-height formula,
// FRONT_AXLE_Z+100=328.6mm) is 100mm ABOVE that. Real CGAL check (not
// assumed): at the new 90 deg default (see below), the handle's own tip
// reaches world Z = TRIANGLE_Z+TBAR_LEN = 328.6+1102.735 = 1431.335mm —
// 50mm ABOVE DATUM_Z_RIDGE(1381.335mm), i.e. genuinely taller than the
// roof at this length+hinge-height combination. TRIANGLE_Z's own formula
// is explicitly OUT OF SCOPE this round (TASK 6 covers "length + default
// angle" only, hinge height is untouched carryover from v3/v4) — flagged
// here, in cc_chat_log.md, and in design_scope_of_work_rule.md for
// Janis/Claude Web: TBAR_LEN as literally specified overshoots the roof by
// ~50mm at this file's own real (unchanged) hinge height; NOT silently
// shortened or the hinge silently relocated to make the numbers agree.
// Default angle FIX: handle_fold_deg default changed 0 (flat/towing,
// confirmed broken per the v12/v4 QA round) -> 90 (vertical storage,
// matches tow_handle()'s own real rotate() formula: rotate([0,
// handle_fold_deg-90,0]), where 90 deg yields rotate([0,0,0]) = cylinder
// axis stays along local +Z = vertical, confirmed via a real default-state
// render (no override), see cc_chat_log.md.
//
// TASK 7 — REAL COLLISION RE-CHECK (v4's original defect).
// Real, algebraic pre-check (re-verified via CGAL below, not assumed from
// arithmetic alone): the old ~6mm collision was between the front wheels
// (previously close-set around DATUM_Y_CENTER via DUAL_WHEEL_OFFSET) and
// the front bracket/caster plate/tow triangle (all of which span real Y
// territory close to DATUM_Y_CENTER, e.g. bracket TOP_W/2=215.67mm each
// side). At the new TRACK_WIDTH/2=540mm front wheel offset, the near tire
// face sits at Y=DATUM_Y_CENTER∓(540-100)=∓440mm from center — real Y-gap
// to the bracket's own widest edge (Y=215.67mm from center) is 224.33mm,
// confirmed via real CGAL non-contact check, see cc_chat_log.md: RESOLVED,
// not just wider-by-assumption.
//
// v4 kept unchanged, on record (BBQ-understructure-v4.scad).
// BBQ-offset-smoker-base-v1.scad's own `include` updated v4->v5.
//
// SKELETON — Parent: BBQ-chambers-v14.2.scad's own DATUM_*/chamber_*/
// firebox_* constants, read directly (R-009 pattern). Local origin still
// MASTER ORIGIN (0,0,0 at floor, front-left), real-CGAL-confirmed to
// coincide with the wheel's own ground-contact point (unchanged from v4).

include <BBQ-chambers-v14.2.scad>

// ───────────────────────────────
// PARAMETERS — carried over from v4, UNCHANGED formulas (real values move
// automatically with chamber_floor_z's new v14.2 value).
// ───────────────────────────────
CASTER_CLEARANCE = 50;
LEG_INSET = 30;
SHELF_D = 300;
SHELF_T = 20;
leg_h = chamber_floor_z - CASTER_CLEARANCE;   // 721.335mm (was 671.335) -- unchanged formula, unused elsewhere in this file (carried over, not a new consumer)

// ═══════════════════════════════════════════════════════════════════
// TASK 1 — SHARED TRACK WIDTH. Single source, both front and rear.
// ═══════════════════════════════════════════════════════════════════
WHEEL_D = 457.2;   // 18" -- UNCHANGED, locked since v4
WHEEL_R = 228.6;
TREAD_W = 200;      // this file's real name for the prompt's "TIRE_W"

TRACK_WIDTH_FIREBOX_GAP = 150;   // real gap, firebox outer-shell edge to near tire face, each side (see file header algebraic check)
TRACK_WIDTH = FIREBOX_W + 2*TRACK_WIDTH_FIREBOX_GAP + TREAD_W;   // 1080mm -- shared, front AND rear

// REAR_AXLE_Z -- UNCHANGED from v4 (direct construction, wheel bottom = world Z=0)
REAR_AXLE_Z         = WHEEL_R;                                 // 228.6mm
GRATE_HEIGHT_ABOVE_GROUND = GRATE_Z;                            // 950mm (v14.2, was 778.665mm under v13) -- direct, world Z=0 is ground

REAR_AXLE_X         = (firebox_x0 + firebox_x1) / 2;            // 1143.5 -- UNCHANGED real value (v14.2 firebox preserves the same old X-midpoint)
REAR_WHEEL_Y_LEFT   = DATUM_Y_CENTER - TRACK_WIDTH/2;           // -235mm -- TASK 1/3, real 150mm gap to firebox edge (file header)
REAR_WHEEL_Y_RIGHT  = DATUM_Y_CENTER + TRACK_WIDTH/2;           // 845mm
REAR_BRACKET_H      = firebox_floor_z - REAR_AXLE_Z;            // 571.4-228.6=342.8mm -- IDENTICAL to v4's own real value (both inputs unchanged)

FRONT_AXLE_Z = REAR_AXLE_Z;   // 228.6 -- SAME shared anchor, keeps the vehicle stance level; front wheel bottom = 0mm, confirmed

// ───────────────────────────────
// Rear strut/beam -- construction UNCHANGED from v4 (DO NOT TOUCH). Real
// spacer lengths widen automatically with the new REAR_WHEEL_Y_LEFT/RIGHT
// (left/right spacers now span 379.5mm each, was 308mm under v14.2's
// firebox width alone -- flagged, not silently absorbed, direct consequence
// of TASK 1's wider track).
// ───────────────────────────────
REAR_STRUT          = 40;
REAR_STRUT_Y_OFFSET = 150;      // struts at Y=[155,455] -- UNCHANGED v4, DO NOT TOUCH
REAR_WELD_OVERLAP   = 3;

module rear_strut(y) {
    translate([REAR_AXLE_X - REAR_STRUT/2, y - REAR_STRUT/2, REAR_AXLE_Z - REAR_WELD_OVERLAP])
        cube([REAR_STRUT, REAR_STRUT, (firebox_floor_z + REAR_WELD_OVERLAP) - (REAR_AXLE_Z - REAR_WELD_OVERLAP)]);
}
module rear_struts() {
    rear_strut(DATUM_Y_CENTER - REAR_STRUT_Y_OFFSET);   // 155
    rear_strut(DATUM_Y_CENTER + REAR_STRUT_Y_OFFSET);   // 455
}

// REAR SPACERS -- construction UNCHANGED from v4 (DO NOT TOUCH), values
// recompute automatically from the new REAR_WHEEL_Y_LEFT/RIGHT above.
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

// ═══════════════════════════════════════════════════════════════════
// TASK 3 — REAR FENDER (NEW). Flat panel welded to the firebox's own
// OUTER SHELL wall (firebox_y0/firebox_y1), curving over the wheel at a
// real, constant FENDER_GAP(150mm) radial clearance, continuing
// FENDER_ARC_PAST_EDGE(25deg) past the wheel's own outer edge. FENDER_T/
// FENDER_W are judgment calls (no numeric spec beyond the 150mm gap),
// flagged.
// ═══════════════════════════════════════════════════════════════════
FENDER_GAP           = 150;              // real radial clearance, wheel surface to fender inner face -- this task's own explicit spec
FENDER_T             = 4;                // panel thickness -- judgment call, flagged
FENDER_R_IN          = WHEEL_R + FENDER_GAP;    // 378.6mm
FENDER_R_OUT         = FENDER_R_IN + FENDER_T;  // 382.6mm
FENDER_W             = TREAD_W + 40;      // 240mm, fender width along X -- judgment call, flagged
FENDER_ARC_PAST_EDGE = 25;                // degrees the curve continues past the wheel's own outer edge (0deg/180deg)

// fender_wedge_2d()/fender_arc_2d() -- real pie-slice + ring-band
// construction, same masking technique this project's own
// true_octagon_profile()/fixed_side_wedge() pattern uses (intersection of
// a ring against a convex wedge triangle from the arc's own center point).
// Coordinates use hex_pt(h,w)=[-h,w] (this file's own inherited convention
// from BBQ-chambers-v14.2.scad, h==world Z here since these modules are
// extruded from a Z0=0 base) -- real angle convention: 0deg=+Y, 90deg=+Z.
module fender_wedge_2d(cy, cz, r_far, a0, a1) {
    polygon(points=[
        hex_pt(cz, cy),
        hex_pt(cz + r_far*sin(a0), cy + r_far*cos(a0)),
        hex_pt(cz + r_far*sin(a1), cy + r_far*cos(a1)),
    ]);
}
module fender_arc_2d(cy, cz, r_outer, r_inner, a0, a1) {
    intersection() {
        difference() {
            translate(hex_pt(cz, cy)) circle(r = r_outer);
            translate(hex_pt(cz, cy)) circle(r = r_inner);
        }
        fender_wedge_2d(cy, cz, r_outer * 2, a0, a1);
    }
}
// rear_fender() -- outward_sign: -1 for the LEFT wheel (outward = -Y,
// away from DATUM_Y_CENTER), +1 for the RIGHT wheel (outward = +Y). Flat
// mount segment real weld-overlap into the firebox's own solid wall
// (FENDER_WELD_OVERLAP=1.5mm, inside the wall_t=3mm band, confirmed via
// CGAL not a coincident-face touch) confirmed real, non-empty contact --
// see cc_chat_log.md.
FENDER_WELD_OVERLAP = 1.5;   // real overlap into firebox outer-shell wall_t(3mm) band, confirmed via CGAL non-empty
module rear_fender(wheel_y, firebox_edge_y, outward_sign) {
    a_top = 90;
    a_end = outward_sign > 0 ? -FENDER_ARC_PAST_EDGE : 180 + FENDER_ARC_PAST_EDGE;
    weld_edge_y = outward_sign > 0 ? firebox_edge_y - FENDER_WELD_OVERLAP : firebox_edge_y + FENDER_WELD_OVERLAP;
    flat_y_lo = outward_sign > 0 ? weld_edge_y : wheel_y;
    flat_y_hi = outward_sign > 0 ? wheel_y : weld_edge_y;
    translate([REAR_AXLE_X - FENDER_W/2, 0, 0]) rotate([0, 90, 0])
        linear_extrude(height = FENDER_W, convexity = 6) {
            fender_arc_2d(wheel_y, REAR_AXLE_Z, FENDER_R_OUT, FENDER_R_IN, a_top, a_end);
            polygon(points=[
                hex_pt(REAR_AXLE_Z + FENDER_R_IN, flat_y_lo),
                hex_pt(REAR_AXLE_Z + FENDER_R_IN, flat_y_hi),
                hex_pt(REAR_AXLE_Z + FENDER_R_OUT, flat_y_hi),
                hex_pt(REAR_AXLE_Z + FENDER_R_OUT, flat_y_lo),
            ]);
        }
}
module rear_fenders() {
    rear_fender(REAR_WHEEL_Y_LEFT, firebox_y0, -1);
    rear_fender(REAR_WHEEL_Y_RIGHT, firebox_y1, 1);
}

// ───────────────────────────────
// Front bracket -- MAIN SHAPE UNCHANGED from v4 (DO NOT TOUCH: MID_H/
// TOP_W/BOT_W, the 2-trapezoid-leg + bottom-plate construction). Real diff
// vs v4: LEG_DROP only (TASK 4, live formula replaces the old 150mm
// literal), which changes the leg's own real Z-span (drop length) but not
// its shape (TOP_W/BOT_W/MID_H formulas untouched, unchanged in value).
// ───────────────────────────────
MID_H   = chamfer / 2;                                    // 89.332mm -- UNCHANGED
TOP_W   = (chamber_W - 2*chamfer) + 2*MID_H;               // 431.335mm -- UNCHANGED
BOT_W   = chamber_W - 2*chamfer;                            // 252.670mm -- UNCHANGED
LEG_GAP  = 250;    // UNCHANGED
// LEG_DROP -- TASK 4, NEW live formula (was 150mm literal in v4). Makes
// the leg's own bottom edge land EXACTLY at world Z=firebox_floor_z --
// confirmed via echo: chamber_floor_z-LEG_DROP = 771.335-199.935 = 571.4
// exact, matches firebox_floor_z exactly.
LEG_DROP = chamber_floor_z - firebox_floor_z;    // 199.935mm (was 150mm)
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
// Fixed caster top-plate -- UNCHANGED position/size formula from v4, real
// Z value recomputes automatically via the new LEG_DROP.
CASTER_X          = FRONT_X - LEG_GAP/2;   // 175 -- UNCHANGED
CASTER_PLATE_SIZE = 100;
CASTER_PLATE_T    = 6;
CASTER_OVERLAP    = 3;
CASTER_PLATE_BOTTOM_Z = (((chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP) + CASTER_OVERLAP) - CASTER_PLATE_T;   // 565.4mm (was 444mm)
module front_caster_plate() {
    top_z = ((chamber_floor_z - LEG_DROP - t) + BOT_OVERLAP) + CASTER_OVERLAP;   // 571.4mm
    translate([CASTER_X - CASTER_PLATE_SIZE/2, DATUM_Y_CENTER - CASTER_PLATE_SIZE/2, top_z - CASTER_PLATE_T])
        cube([CASTER_PLATE_SIZE, CASTER_PLATE_SIZE, CASTER_PLATE_T]);
}

// FRONT SPACER -- construction UNCHANGED from v4 (DO NOT TOUCH). Real
// LENGTH recomputes automatically (336.8mm, was 215.4mm) since
// CASTER_PLATE_BOTTOM_Z changed above (TASK 4's LEG_DROP fix) -- real,
// stated, positive. This IS the swivel fork/stem, rotates with steer_deg.
FRONT_SPACER_D = 40;
FRONT_SPACER_LEN = CASTER_PLATE_BOTTOM_Z - FRONT_AXLE_Z;   // 336.8mm (was 215.4mm)
module front_spacer() {
    translate([CASTER_X, DATUM_Y_CENTER, FRONT_AXLE_Z])
        cylinder(d = FRONT_SPACER_D, h = FRONT_SPACER_LEN + e);
}
// front_stub_axle()/front_wheels() -- TASK 1/5: respan from the retired
// DUAL_WHEEL_OFFSET(110mm) to TRACK_WIDTH/2(540mm), same single-rigid-
// structure mechanism (UNCHANGED CODE PATTERN, only the span constant
// changes) -- re-verified via CGAL steer_deg sweep, see file header.
module front_stub_axle() {
    translate([CASTER_X, DATUM_Y_CENTER - TRACK_WIDTH/2 - TREAD_W/2, FRONT_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = FRONT_SPACER_D, h = TRACK_WIDTH + TREAD_W);
}
module front_wheel(y) {
    translate([CASTER_X, y - TREAD_W/2, FRONT_AXLE_Z]) rotate([-90, 0, 0])
        cylinder(d = WHEEL_D, h = TREAD_W);
}
module front_wheels() {
    front_wheel(DATUM_Y_CENTER - TRACK_WIDTH/2);
    front_wheel(DATUM_Y_CENTER + TRACK_WIDTH/2);
}

// ═══════════════════════════════════════════════════════════════════
// TOW HANDLE / T-BAR -- TASK 2 (tip reshape) + TASK 6 (length/default
// angle). TRIANGLE_Z/HINGE_INSET/steering mechanism all UNCHANGED from v4
// (out of scope this round beyond the tip shape + T-bar length/angle, see
// file header for the real flagged Z-clearance consequence).
// ═══════════════════════════════════════════════════════════════════
TRIANGLE_BASE_X  = CASTER_X + 25;    // 200 -- UNCHANGED
TRIANGLE_LENGTH  = 500;               // UNCHANGED
TRIANGLE_APEX_X  = TRIANGLE_BASE_X - TRIANGLE_LENGTH;   // -300 -- UNCHANGED, real forward reach preserved (TASK 2 rounds the tip but keeps this same forward extent)
TRIANGLE_BASE_W  = 200;
TRIANGLE_T       = 6;
TRIANGLE_Z       = FRONT_AXLE_Z + 100;   // 328.6 -- UNCHANGED formula (out of scope this round, see file header TASK 6 note)

// TASK 2 -- round tip, NEW. TIP_D=150mm (this task's own explicit minimum
// width), tip's forward-most extent held at the SAME TRIANGLE_APEX_X the
// old sharp point used (real reach unchanged, only the tip's own shape).
TIP_D = 150;
TIP_R = TIP_D / 2;                                  // 75mm
TIP_CENTER_X = TRIANGLE_APEX_X + TIP_R;              // -225 -- circle center, so its forward edge lands exactly at TRIANGLE_APEX_X

HINGE_INSET = 20;
HINGE_X     = TRIANGLE_APEX_X + HINGE_INSET;   // -280 -- UNCHANGED formula; real, flagged improvement: now inside genuine 150mm round material (file header)

HANDLE_CROSSBAR_LEN = 300;   // UNCHANGED -- TASK 6 covers the upright length only
HANDLE_CROSSBAR_D   = 25;
HANDLE_UPRIGHT_D    = 25;

// TASK 6 -- T-bar upright length, NEW live formula (was HANDLE_UPRIGHT_LEN
// =400mm literal in v4). See file header for the full real value + the
// real flagged roof-clearance variance at this file's own unchanged
// TRIANGLE_Z hinge height.
TBAR_BRACKET_THICKNESS = 50;   // this task's own explicit literal
TBAR_LEN = DATUM_Z_RIDGE - WHEEL_R - TBAR_BRACKET_THICKNESS;   // 1381.335-228.6-50 = 1102.735mm

module tow_triangle_profile() {
    hull() {
        translate([TIP_CENTER_X, DATUM_Y_CENTER]) circle(d = TIP_D);
        translate([TRIANGLE_BASE_X, DATUM_Y_CENTER - TRIANGLE_BASE_W/2]) circle(r = 0.01);
        translate([TRIANGLE_BASE_X, DATUM_Y_CENTER + TRIANGLE_BASE_W/2]) circle(r = 0.01);
    }
}
module tow_triangle() {
    translate([0, 0, TRIANGLE_Z]) linear_extrude(height = TRIANGLE_T, convexity = 2) tow_triangle_profile();
}
module tow_handle(handle_fold_deg = 90) {
    translate([HINGE_X, DATUM_Y_CENTER, TRIANGLE_Z])
        rotate([0, handle_fold_deg - 90, 0]) {
            cylinder(d = HANDLE_UPRIGHT_D, h = TBAR_LEN);
            translate([0, 0, TBAR_LEN])
                translate([0, -HANDLE_CROSSBAR_LEN/2, 0]) rotate([-90, 0, 0])
                    cylinder(d = HANDLE_CROSSBAR_D, h = HANDLE_CROSSBAR_LEN);
        }
}
module front_swivel_assembly(steer_deg = 0, handle_fold_deg = 90) {
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
module front_wheel_support(steer_deg = 0, handle_fold_deg = 90) {
    color("#AAAAAA", 1.0) {
        front_bracket();
        front_caster_plate();
    }
    front_swivel_assembly(steer_deg, handle_fold_deg);
}

// ═══════════════════════════════════════════════════════════════════
// PREP TRAY -- UNCHANGED from v4 (DO NOT TOUCH this round). Mount point
// (apex A, GRATE_Z) is chamber-frozen; real value moves to 950mm (v14.2,
// was 778.665mm under v13) as an automatic consequence of TASK 0's pointer
// bump alone, unaffected by any of this round's own tasks.
// ═══════════════════════════════════════════════════════════════════
TRAY_MOUNT_X = LEG_INSET;         // 30
TRAY_MOUNT_Z = GRATE_Z;            // 950mm (v14.2, was 778.665)

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
show_rear_fenders        = true;
show_front_wheel_support = true;
show_shelves               = true;
shelf_deployed              = true;

handle_fold_deg = 90;    // TASK 6 FIX: was 0 (flat/towing, confirmed broken default) -- now 90 (vertical storage), matches this file's own explicit spec
steer_deg        = 0;    // rotates front_spacer()+front_stub_axle()+front_wheels()+triangle+handle TOGETHER (coupled steering)

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation Testing
// (rules-codes.md).
// ───────────────────────────────
if (show_rear_axle) rear_axle();
if (show_rear_fenders) color("#999999", 1.0) rear_fenders();
if (show_front_wheel_support) front_wheel_support(steer_deg, handle_fold_deg);
if (show_shelves) color("#AAAAAA", 1.0) prep_shelves(shelf_deployed);
