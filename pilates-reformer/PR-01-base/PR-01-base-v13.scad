// PR-01-base-v13.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v13 — pole_top() Shape & Neck Mechanism Correction (bell/horn + sleeve)
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
// head+neck. v11 fixed the loft's elongation axis. v12 refined that
// silhouette (height reduction + Bezier rounding) — Janis confirmed v11's
// orientation was correct, but then supplied a hand sketch (BAR/POLE
// annotated) showing a different exterior concept entirely.
//
// v13 SUPERSEDES the v11/v12 asymmetric "foot/helmet" silhouette concept.
// Built fresh from the new sketch reference, NOT an iteration on v12:
//   - Head exterior is now a TRUE BODY OF REVOLUTION (rotate_extrude() around
//     the vertical Z axis) — a smooth bell/horn taper from a SMALL circular
//     end-face (tail/neck side, bottom) to a LARGE circular end-face
//     (pipe-entry side, top). The outer curve is sampled along a cubic
//     Bezier (head_loft_steps+1 = 13 points) for a continuous smooth sweep,
//     same technique as v12 but now revolved instead of extruded as an
//     asymmetric 2D side-profile. No more dir-mirroring needed for the head
//     — a circular body of revolution is identical from every pole position.
//   - Bore through the head stays CONSTANT diameter (33mm) — straight
//     cylindrical pass-through, drilled horizontally through the revolved
//     solid after the fact. Exterior tapers, bore does not.
//   - Min wall thickness around the bore at the narrowest point (head base,
//     where head radius = head_small_r = neck_or = 31.5mm) = 31.5 - 16.5
//     (bore radius) = 15mm — comfortably above the 3mm minimum spec.
//   - Neck REDESIGNED as an external sleeve: now a hollow tube (neck_id =
//     pole_d + 1mm = 51mm slip-fit clearance, neck_wall_t = 6mm,
//     neck_od = 63mm) that slides OVER the top neck_h=50mm of pole_body()
//     from outside, rather than butting on top of it as a solid insert pin.
//     pole_body() itself is untouched (per prompt scope) — the sleeve simply
//     occupies the same Z-span as the top of the existing pole_body cylinder.
//   - Neck fastening changed from 2x M6 screws into a blind/threaded hole
//     (v10-v12) to 2x M6 THROUGH-BOLT clearance holes (bolt + nut) passing
//     fully through both walls of the sleeve, axis along X (same direction
//     as the bore) at neck_h*0.3 and neck_h*0.7 — symmetric about the
//     sleeve's mid-height so the same part can be bolted/tightened from
//     either side, keeping it a single common part number for both
//     left/right mirrored pole positions.
//   - ⚑ FLAG: pole_body() currently has NO through-holes of its own to align
//     these neck bolt holes against (it's still a solid D-profile shaft) —
//     the prompt scoped this round to sleeve-only holes and explicitly said
//     not to modify pole_body(). Adding matching pole_body() holes is a
//     follow-up item for Janis to confirm before the bolts are functional.
//   - $fn=64 still applied locally inside pole_top() only.
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

// ── Pole TOP — bell/horn body-of-revolution head + external sleeve neck ────
// Per Janis hand sketch (BAR/POLE annotated): small circular end-face (tail/
// neck side) smoothly tapers to a large circular end-face (pipe-entry side),
// constant-diameter horizontal through-bore for crossbar, neck is now a
// slip-fit sleeve over pole_body() fastened via 2x M6 through-bolts.
neck_h         = 50;    // neck (sleeve) length along Z — minimum 50mm per spec, unchanged
neck_wall_t    = 6;     // TBD — sleeve wall thickness
neck_id        = pole_d + 1;       // = 51mm — slip-fit clearance over pole_od (50mm), 0.5mm/side
neck_od        = neck_id + 2 * neck_wall_t;  // = 63mm
neck_or        = neck_od / 2;      // = 31.5mm — also doubles as head_small_r (continuous, no step)
head_h         = 90;    // head height (Z) — compact/short per v12 direction, reshaped into bell taper
top_boss_h     = neck_h + head_h;  // = 140mm — total pole_top vertical envelope, same role as prior versions (drives xbar_z)
head_small_r   = neck_or;          // = 31.5mm — small end-face radius, matches neck OD (continuous transition)
head_large_r   = 46;    // TBD — large end-face radius (pipe-entry side), 92mm diameter bell mouth
head_loft_steps = 12;   // number of Bezier sample steps for the outer revolve curve, 13 points total
top_bore_d     = 33;    // TBD — grip_od(32) + 1mm/-0mm clearance, pending physical fit test vs real 32mm pipe, unchanged from v10-v12
neck_bolt_d    = 6.5;   // TBD — M6 through-bolt clearance hole diameter (bolt + nut, not a blind/threaded hole)

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

// pole_top_neck() — external sleeve, hollow tube (neck_id slip-fit clearance over
// pole_od, neck_wall_t wall) that slides OVER the top neck_h of pole_body() from
// outside (NOT an insert pin like v10-v12). z_top = head base (= top of pole_body(),
// unchanged anchor) — sleeve spans downward from z_top so it overlaps the top
// neck_h-length of the existing pole_body() cylinder. pole_body() itself is untouched.
module pole_top_neck(cx, cy, z_top) {
    translate([cx, cy, z_top - neck_h])
        difference() {
            cylinder(h = neck_h, d = neck_od, $fn = 64);
            translate([0, 0, -e])
                cylinder(h = neck_h + 2 * e, d = neck_id, $fn = 64);
        }
}

// cubic_bezier() — samples a smooth point on a cubic Bezier curve through 4 control
// points. Used by pole_top_head() to build the head's outer (radius, height) revolve
// curve as a continuous sweep instead of straight polygon segments.
function cubic_bezier(t, p0, p1, p2, p3) =
    let(u = 1 - t)
    [ u*u*u*p0[0] + 3*u*u*t*p1[0] + 3*u*t*t*p2[0] + t*t*t*p3[0],
      u*u*u*p0[1] + 3*u*u*t*p1[1] + 3*u*t*t*p2[1] + t*t*t*p3[1] ];

// pole_top_head() — TRUE body of revolution (rotate_extrude() around Z), per the new
// sketch reference: a smooth bell/horn taper from a small circular end-face (bottom,
// matches neck_or — continuous, no step) to a large circular end-face (top, pipe-entry
// side). The outer (radius, height) curve is sampled along a cubic Bezier
// (head_loft_steps+1 = 13 points) for a continuous smooth sweep. No dir/mirroring
// needed — identical from every pole position since it's circular.
module pole_top_head(cx, cy, z_base) {
    p0 = [head_small_r,        0];
    p1 = [head_small_r * 1.05, head_h * 0.35];
    p2 = [head_large_r * 0.85, head_h * 0.75];
    p3 = [head_large_r,        head_h];

    outer_curve = [ for (i = [0 : head_loft_steps]) cubic_bezier(i / head_loft_steps, p0, p1, p2, p3) ];
    // close the half-profile back to the revolve axis (x=0) at both ends so
    // rotate_extrude() produces a solid (not a shell) — bore is cut afterward.
    head_profile = concat([[0, 0]], outer_curve, [[0, head_h]]);

    translate([cx, cy, z_base])
        rotate_extrude($fn = 64)
            polygon(points = head_profile);
}

// pole_top() — bell/horn head + external sleeve neck assembly (Janis hand sketch
// reference, supersedes v11/v12's asymmetric foot/helmet concept). Head sits atop the
// neck, perforated by a constant-diameter horizontal through-bore for the crossbar
// (aligned to the existing unmodified xbar_z, axis along X matching crossbar
// orientation), plus 2 M6 through-bolt clearance holes through the sleeve walls (bolt +
// nut, not blind/threaded). No latch/cam/lever geometry — Stage 2 scope only.
// Visually and parametrically distinct from pole_base_collar() (different params,
// different bolt count, different shape).
module pole_top(cx, cy) {
    $fn = 64;  // local resolution bump for this module only (neck/bore/bolt cylinders + revolve); rest of file stays at the global $fn=32 default
    z0  = bed_h + pole_h - top_boss_h;  // head base — matches pole_body()'s top (pole_body height = pole_h - top_boss_h, unchanged formula)
    color("#2C3E50", 1.0)
        difference() {
            union() {
                pole_top_neck(cx, cy, z0);
                pole_top_head(cx, cy, z0);
            }
            // through-bore for crossbar — constant 33mm diameter, passes through the
            // HEAD only, axis along X (matches crossbar_body()'s rotate([0,90,0])
            // X-axis orientation), aligned to the existing unmodified xbar_z
            translate([cx, cy, xbar_z])
                rotate([0, 90, 0])
                    cylinder(h = head_large_r * 4, d = top_bore_d, center = true, $fn = 48);
            // 2x M6 through-bolt clearance holes through both walls of the sleeve —
            // bolt + nut (not blind/threaded), symmetric about sleeve mid-height so the
            // same part bolts from either side; positions at neck_h*0.3 / neck_h*0.7
            // below z0, axis along X (same direction as the bore)
            for (bz = [z0 - neck_h + neck_h * 0.3, z0 - neck_h + neck_h * 0.7])
                translate([cx, cy, bz])
                    rotate([90, 0, 0])
                        cylinder(h = neck_od + 2 * e, d = neck_bolt_d, center = true, $fn = 24);
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
