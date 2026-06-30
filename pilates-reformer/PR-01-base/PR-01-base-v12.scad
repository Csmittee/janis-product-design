// PR-01-base-v12.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v12 — pole_top() Height Reduction + Profile Rounding
// Date: 2026-06-30
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
//
// CONTEXT: v6 (one-piece continuous pole + taper) rejected by Janis (owner).
// v7 split pole into 4 SEPARATE physical components for self-assembly —
// TOP (crossbar lock/latch junction), BODY (constant-diameter D-profile
// shaft, no taper), BASE COLLAR (split-clamp sleeve to wood leg), WOOD
// SOCKET (shallow registration insert in drilled hole).
// v8 fixed crossbar seating gap + pole overshoot. v9 made pole_body() the
// full-height uniform D-profile and rebuilt pole_base_collar() as a
// split-clamp sleeve. v10 rebuilt pole_top() as an asymmetric foot/boot
// head+neck. v11 fixed the loft's elongation axis (X, toward the bore, not
// Z) — Janis confirmed v11's orientation/axis is CORRECT.
//
// Changes from v11 (Janis QA: orientation PASS, silhouette refinement only):
//   - Head height reduced 110mm → 100mm (top_boss_h 160→150mm) for a flatter,
//     more compact profile. NOTE: head_h can't be reduced much further while
//     the bore stays centered via the existing (unchanged) xbar_z formula —
//     xbar_z = bed_h + pole_h - top_boss_h*0.5 sits at the vertical midpoint
//     of the whole neck+head envelope, so shrinking head_h directly shrinks
//     the wall material below the bore. head_h=100 keeps an ~8.5mm wall below
//     the bore (was 13.5mm at head_h=110); going lower than ~head_h=99 would
//     break the bore through the bottom face. Flagged for Janis — a flatter
//     head than this would require decoupling the head's base from the
//     bore-driven envelope, out of scope for this fix.
//   - Profile silhouette rebuilt from 10 hand-picked polygon corners to two
//     cubic-Bezier-sampled curves (13 points each, 26 total) for the back
//     and front edges — produces a continuous smooth sweep instead of
//     visible straight-line facets, while keeping the same core asymmetry
//     (flat-ish back, curved front bulge, narrowing toward the bore exit).
//   - $fn raised to 64 locally inside pole_top() only (neck/bore/screw
//     cylinders) — rest of file stays at the global $fn=32 default.
//   - Bore position/diameter (33mm), neck (50mm dia, 50mm length), and the
//     2x M6 screw joint are all UNCHANGED from v11 per this prompt's scope.
//
// ⚠ Stage 1 of 2 — architecture and resizing only. Detailed quick-release
// latch/cam/lever mechanism is Stage 2 (separate future prompt) — NOT built
// here. Wall thickness around the bore kept generous so that future stage
// isn't geometrically blocked.
// ⚠ REGRESSION CHECK: no lattice/truss/wireframe geometry anywhere — body
// is a solid D-profile only (v4 removed it, v6 mistakenly reintroduced it).
// Foldable hinge geometry explicitly deferred — not built here.

// ── Global ────────────────────────────────────────────────────────────
e           = 0.01;   // epsilon — z-fight prevention
$fn         = 32;     // default resolution (use 64 for final render)

// ── Bed dimensions ────────────────────────────────────────────────────
bed_l       = 2300;   // total bed length (longitudinal) — PENDING Janis confirm
bed_w       = 670;    // total bed width — PENDING Janis confirm
bed_h       = 500;    // floor to top of bed surface — PENDING Janis confirm
leg_w       = 180;    // bed leg width — unchanged from v6
leg_t       = 120;    // bed leg depth — unchanged from v6
frame_rail_t = 60;    // bed rail thickness (wood) — PENDING
frame_rail_h = 120;   // bed rail height — PENDING

// ── Pole body — constant D-profile, NO TAPER (rules-dimensions.md v6, PR-01) ──
pole_d        = 50;   // body diameter — constant top to bottom — Janis-confirmed
pole_r        = pole_d / 2;
pole_h        = 1600;  // exposed pole height above bed surface — PENDING

// ── Pole TOP — asymmetric "foot/boot" head + neck (Stage 2 builds functional latch) ──
// Per IMG_3314 sketch: flat-ish back edge, curved front edge, wider than pole_d,
// horizontal through-bore for crossbar, neck joins pole via 2 screws (ASSY).
top_boss_h     = 150;   // total pole_top vertical envelope (neck_h + head_h) — v12: reduced 160→150mm (head_h 110→100mm) for a flatter profile, see header note on the bore-clearance floor
neck_h         = 50;    // neck length — minimum 50mm per spec, matches typical pipe-connector length
neck_d         = pole_d;  // neck diameter = pole_d exactly, no taper — Janis-confirmed
neck_r         = neck_d / 2;
head_h         = top_boss_h - neck_h;  // = 100mm (short axis — Z; v12: reduced from v11's 110mm, see header note)
head_back_w    = 40;    // head extent behind neck centerline — flat-ish back edge (unchanged from v11)
head_front_w   = 90;    // head extent in front of neck centerline — curved front edge, toward bore exit (unchanged from v11; head X total = 130mm, still the long axis vs head_h = 100mm Z)
head_depth     = 70;    // head Y-extent (lateral) — exceeds pole_d for bore wall clearance
fillet_h       = 15;    // tapered blend height at neck-to-head transition (unchanged from v11)
head_loft_steps = 12;   // v12 — number of Bezier sample steps per curve (back/front), 13 points each, 26 total — replaces v11's 10 hand-picked polygon corners for a smoother sweep
top_bore_d     = 33;    // TBD — grip_od(32) + 1mm/-0mm clearance, pending physical fit test vs real 32mm pipe
neck_screw_d       = 6.5;  // TBD — M6 clearance hole diameter, standard clearance practice
neck_screw_cb_d    = 13;   // TBD — counterbore/countersink diameter for M6 hex countersunk head
neck_screw_cb_depth = 4;   // TBD — countersink depth, pending Janis fastener confirmation

// ── Pole BASE COLLAR — split-clamp sleeve (Stage 2 = precision fit) ────
// Wraps BOTH the lower pole_body() and the top of the wood leg, spanning
// across the bed_h surface line. Split into 2 halves (front/back, cut along
// the Y centerline), joined by 3 bolt bosses per split face (6 total).
// Clamp carries the holding force — the registration pin below is
// alignment-only, not load-bearing. All values TBD — see cc_chat_log.
collar_wrap_h       = 120;            // TBD — total wrap height, split evenly above/below bed_h
collar_wall_t       = 8;              // TBD — wrap wall thickness
collar_bolt_d       = 4;              // TBD — bolt clearance hole diameter
collar_bolt_boss_d  = 10;             // TBD — boss diameter around each bolt hole
collar_id           = pole_d + 1;     // inner clearance around pole_body (0.5mm/side)
collar_od           = collar_id + 2 * collar_wall_t;
collar_z0           = bed_h - collar_wrap_h / 2;  // split roughly evenly above/below bed_h line
pin_d               = 16;             // unchanged — registration pin diameter
pin_h               = 18;             // TBD — reduced for new shallow socket, must be <= socket_depth

// ── Pole WOOD SOCKET — shallow registration insert (rules-dimensions.md v6, PR-01) ──
// Registration/alignment only — NOT load-bearing (split-clamp collar carries the holding force).
socket_od     = 60;    // ~60mm fixed-version OD — Janis-confirmed, unchanged
socket_depth  = 20;     // TBD — shallow registration depth, see cc_chat_log
socket_bore_d = pin_d + 0.5;  // bore clearance for registration pin — M-PR-1, never exact pin_d

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED — do not change without Janis approval
grip_l      = bed_l - leg_w;  // pole-center to pole-center (X-axis), not bed edge to edge
grip_offset = 0;       // lateral offset from pole centerline — TBD

// ── Debug toggles ─────────────────────────────────────────────────────
show_bed           = true;
show_pole_tops     = true;
show_pole_bodies   = true;
show_base_collars  = true;
show_wood_sockets  = true;
show_crossbars     = true;

// ── Derived ───────────────────────────────────────────────────────────
surface_t   = 30;     // bed surface platform thickness

// Pole corner X positions — [front-left, front-right, rear-left, rear-right]
pole_cx = [leg_w/2, bed_l - leg_w/2, leg_w/2, bed_l - leg_w/2];
// Pole corner Y positions
pole_cy = [leg_t/2, leg_t/2, bed_w - leg_t/2, bed_w - leg_t/2];

// Crossbar Y positions — front row / rear row
xbar_y_front = pole_cy[0];
xbar_y_rear  = pole_cy[2];

// Crossbar Z — seats mid-height inside the pole_top() boss (does NOT bore through pole_body())
xbar_z = bed_h + pole_h - top_boss_h * 0.5;

// ═════════════════════════════════════════════════════════════════════
// MODULES — BED
// ═════════════════════════════════════════════════════════════════════

module bed_frame() {
    color("#C8A96E", 1.0) {
        for (i = [0:3]) {
            translate([pole_cx[i] - leg_w/2, pole_cy[i] - leg_t/2, 0])
                cube([leg_w, leg_t, bed_h - surface_t]);
        }
        translate([0, 0, bed_h - surface_t - frame_rail_h])
            cube([bed_l, frame_rail_t, frame_rail_h]);
        translate([0, bed_w - frame_rail_t, bed_h - surface_t - frame_rail_h])
            cube([bed_l, frame_rail_t, frame_rail_h]);
        translate([0, 0, bed_h - surface_t - frame_rail_h])
            cube([frame_rail_t, bed_w, frame_rail_h]);
        translate([bed_l - frame_rail_t, 0, bed_h - surface_t - frame_rail_h])
            cube([frame_rail_t, bed_w, frame_rail_h]);
    }
}

module bed_surface() {
    color("#222222", 1.0)
        translate([0, 0, bed_h - surface_t])
            cube([bed_l, bed_w, surface_t]);
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — POLE COMPONENTS (4 separate, logically distinct solids)
// ═════════════════════════════════════════════════════════════════════

// pole_wood_socket() — plain cylindrical insert pushed through drilled hole in wood leg.
// Sits inside the bed leg, below pole_base_collar(). Plain cylinder, no taper, no thread.
module pole_wood_socket(cx, cy) {
    color("#888888", 1.0)
        translate([cx, cy, bed_h - socket_depth])
            cylinder(h = socket_depth, d = socket_od, $fn = 64);
}

// pole_base_collar_half() — one half of the split-clamp sleeve (front or back).
// side = +1 → back half (y >= cy seam), -1 → front half (y <= cy seam).
// Wraps both pole_body() and the wood leg top, spanning across bed_h. 3 bolt
// bosses on this half's split face — mating half carries the other 3 (6 total).
module pole_base_collar_half(cx, cy, side) {
    half_h = collar_wrap_h;
    color("#2C3E50", 1.0)
        translate([cx, cy, collar_z0])
            difference() {
                union() {
                    difference() {
                        cylinder(h = half_h, d = collar_od, $fn = 64);
                        translate([0, 0, -e])
                            cylinder(h = half_h + 2 * e, d = collar_id, $fn = 64);
                    }
                    // 3 bolt bosses along the split (seam) face, evenly spaced in height
                    for (bz = [half_h * 0.2, half_h * 0.5, half_h * 0.8])
                        translate([0, side * (collar_bolt_boss_d / 2 - e), bz])
                            rotate([90, 0, 0])
                                cylinder(h = collar_bolt_boss_d, d = collar_bolt_boss_d, $fn = 32, center = true);
                }
                // keep only this half — cut away material on the far side of the seam plane
                translate([-collar_od, side > 0 ? -collar_od : 0, -e])
                    cube([collar_od * 2, collar_od, half_h + 2 * e]);
                // bolt through-holes at the same 3 heights
                for (bz = [half_h * 0.2, half_h * 0.5, half_h * 0.8])
                    translate([0, 0, bz])
                        rotate([90, 0, 0])
                            cylinder(h = collar_bolt_boss_d * 2, d = collar_bolt_d, $fn = 32, center = true);
            }
}

// pole_base_collar() — split-clamp sleeve: 2 visually separate halves (not unioned,
// consistent with how the other pole components are kept logically separate) +
// a single registration pin protruding into the shallow pole_wood_socket().
module pole_base_collar(cx, cy) {
    pole_base_collar_half(cx, cy, 1);   // back half
    pole_base_collar_half(cx, cy, -1);  // front half
    color("#2C3E50", 1.0)
        translate([cx, cy, bed_h - pin_h])
            cylinder(h = pin_h + e, d = pin_d, $fn = 64);
}

// pole_body() — D-profile shaft, constant 50mm diameter, FULL exposed pole height
// (single uniform extrusion, no base-zone offset). No bar-insert bore — crossbar
// no longer passes through the body (that is pole_top()'s job).
// dir: front pole flat faces +X (rear); rear pole flat faces -X (front) — rules-pr.md
module pole_body(cx, cy) {
    dir = (cx < bed_l / 2) ? 1 : -1;
    cut_x0 = dir > 0 ? 0.7 * pole_r : -(pole_r + 1);
    color("#CCCCCC", 1.0)
        translate([cx, cy, bed_h])
            difference() {
                cylinder(h = pole_h - top_boss_h, r = pole_r, $fn = 64);
                translate([cut_x0, -pole_r - 1, -e])
                    cube([0.3 * pole_r + 1, pole_r * 2 + 2, pole_h + 2 * e]);
            }
}

// pole_top_neck() — cylindrical neck, diameter = pole_d exactly, joins pole_body() below.
module pole_top_neck(cx, cy, z_base) {
    translate([cx, cy, z_base])
        cylinder(h = neck_h, d = neck_d, $fn = 64);
}

// cubic_bezier() — samples a smooth point on a cubic Bezier curve through 4 (x,z)
// control points. Used by pole_top_head() to build a continuous curved sweep instead
// of straight polygon segments between hand-picked corners.
function cubic_bezier(t, p0, p1, p2, p3) =
    let(u = 1 - t)
    [ u*u*u*p0[0] + 3*u*u*t*p1[0] + 3*u*t*t*p2[0] + t*t*t*p3[0],
      u*u*u*p0[1] + 3*u*u*t*p1[1] + 3*u*t*t*p2[1] + t*t*t*p3[1] ];

// pole_top_head() — asymmetric "foot/boot" head, built via linear_extrude() of a 2D
// X-Z side-view profile (NOT a body of revolution — no d1/d2 cylinder/cone). Long axis
// runs X (toward the bore/pipe exit), short axis Z (height) — orientation confirmed
// correct by Janis in v11. v12: the back and front edges are each sampled along a
// cubic Bezier curve (head_loft_steps+1 points per edge) instead of v11's straight
// hand-picked polygon corners — produces a continuous smooth sweep, not visible
// straight-line facets. Profile is asymmetric: flat-ish back edge (negative local X),
// rounded front bulge (positive local X, toward the bore), tapered fillet_h blend out
// of the neck radius at the base instead of an instant step. dir mirrors the profile
// so the curved front faces consistently per pole position (same dir convention as
// pole_body()'s flat-face cut).
module pole_top_head(cx, cy, z_base, dir) {
    // back edge: neck base -> fillet -> full back width -> top-back (4 control points)
    back_p0 = [-neck_r,            0];
    back_p1 = [-neck_r * 1.3,      fillet_h];
    back_p2 = [-head_back_w,       head_h * 0.55];
    back_p3 = [-head_back_w * 0.3, head_h];
    // front edge: top-front -> bulge -> fillet -> neck base (4 control points)
    front_p0 = [ head_front_w * 0.35, head_h];
    front_p1 = [ head_front_w,        head_h * 0.55];
    front_p2 = [ neck_r * 1.3,         fillet_h];
    front_p3 = [ neck_r,               0];

    back_curve  = [ for (i = [0 : head_loft_steps]) cubic_bezier(i / head_loft_steps, back_p0, back_p1, back_p2, back_p3) ];
    front_curve = [ for (i = [0 : head_loft_steps]) cubic_bezier(i / head_loft_steps, front_p0, front_p1, front_p2, front_p3) ];
    head_profile = concat(back_curve, front_curve);

    translate([cx, cy, z_base])
        scale([dir, 1, 1])
            translate([0, head_depth / 2, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = head_depth)
                        polygon(points = head_profile);
}

// pole_top() — asymmetric head+neck assembly (IMG_3314 sketch reference). Head sits
// atop the neck, perforated by a horizontal through-bore for the crossbar (aligned to
// the existing xbar_z, axis along X matching crossbar orientation — crossbar code itself
// is untouched), plus 2 neck screw holes for the pole ASSY joint. No latch/cam/lever
// geometry — Stage 2 scope only. Visually and parametrically distinct from
// pole_base_collar() (different params, different bolt count, different shape).
module pole_top(cx, cy) {
    $fn = 64;  // v12 — local resolution bump for this module only (neck/bore/screw cylinders); rest of file stays at the global $fn=32 default
    z0  = bed_h + pole_h - top_boss_h;  // matches pole_body()'s top (pole_body height = pole_h - top_boss_h, unchanged formula)
    dir = (cx < bed_l / 2) ? 1 : -1;
    color("#2C3E50", 1.0)
        difference() {
            union() {
                pole_top_neck(cx, cy, z0);
                pole_top_head(cx, cy, z0 + neck_h, dir);
            }
            // through-bore for crossbar — passes through the HEAD only, axis along X
            // (matches crossbar_body()'s rotate([0,90,0]) X-axis orientation), aligned
            // to the existing unmodified xbar_z
            translate([cx, cy, xbar_z])
                rotate([0, 90, 0])
                    cylinder(h = (head_back_w + head_front_w) * 2, d = top_bore_d, center = true, $fn = 48);
            // 2 neck screw holes (M6 hex countersunk clearance + countersink) — ASSY
            // joint to pole, distinct from pole_base_collar()'s 3-bolt/6-bolt split clamp
            for (sz = [z0 + neck_h * 0.3, z0 + neck_h * 0.7])
                translate([cx, cy, sz])
                    rotate([90, 0, 0]) {
                        cylinder(h = neck_d + 2 * e, d = neck_screw_d, center = true, $fn = 24);
                        translate([0, 0, neck_d / 2 - neck_screw_cb_depth])
                            cylinder(h = neck_screw_cb_depth + e, d = neck_screw_cb_d, $fn = 24);
                    }
        }
}

// ═════════════════════════════════════════════════════════════════════
// MODULES — CROSSBAR (X-axis: longitudinal along bed length)
// Seats against pole_top() junctions only — does not pass through pole_body().
// ═════════════════════════════════════════════════════════════════════

module crossbar_body(y_pos) {
    color("#DDDDDD", 1.0)
        translate([leg_w/2, y_pos, xbar_z])
            rotate([0, 90, 0])
                cylinder(h = grip_l, d = grip_od);
}

module crossbar_end_cap(x_pos, y_pos) {
    color("#AAAAAA", 1.0)
        translate([x_pos, y_pos, xbar_z])
            sphere(d = grip_od + 4);
}

// ═════════════════════════════════════════════════════════════════════
// SUB-ASSEMBLIES — 4 pole parts kept logically separate (not unioned)
// ═════════════════════════════════════════════════════════════════════

module bed_assembly() {
    if (show_bed) {
        bed_frame();
        bed_surface();
    }
}

module pole_assembly(i) {
    cx = pole_cx[i];
    cy = pole_cy[i];
    if (show_wood_sockets) pole_wood_socket(cx, cy);
    if (show_base_collars) pole_base_collar(cx, cy);
    if (show_pole_bodies)  pole_body(cx, cy);
    if (show_pole_tops)    pole_top(cx, cy);
}

module crossbar_assembly() {
    if (show_crossbars) {
        crossbar_body(xbar_y_front);
        crossbar_body(xbar_y_rear);
        crossbar_end_cap(pole_cx[0], xbar_y_front);
        crossbar_end_cap(pole_cx[1], xbar_y_front);
        crossbar_end_cap(pole_cx[2], xbar_y_rear);
        crossbar_end_cap(pole_cx[3], xbar_y_rear);
    }
}

// ═════════════════════════════════════════════════════════════════════
// FULL ASSEMBLY (combined preview render — components visually aligned,
// logically separate solids, NOT unioned into one continuous pole)
// ═════════════════════════════════════════════════════════════════════

module pr01_assembly() {
    bed_assembly();
    for (i = [0:3]) pole_assembly(i);
    crossbar_assembly();
}

// ── RENDER ────────────────────────────────────────────────────────────
pr01_assembly();
