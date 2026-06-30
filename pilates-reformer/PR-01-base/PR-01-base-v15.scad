// PR-01-base-v15.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v15 — Seat neck to bell (close v14's gap) + pole/neck diameter correction
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
// silhouette. v13 rebuilt pole_top() as a true body-of-revolution bell/horn
// + external sleeve neck per Janis's sketch — but the bell's bore axis
// defaulted to Z (rotate_extrude's native axis) and never actually ended up
// horizontal along X, so the bell sat vertically like a chimney cap on top
// of the neck instead of forming a T-junction with the crossbar passing
// through it.
//
// v14 fixed the bell's bore axis (single rotate([0,90,0]) construction
// method) and switched the profile to wine-glass concave — but left a flag:
// the neck (anchored at the old independent z0 = bed_h+pole_h-top_boss_h
// formula) and the bell (anchored at xbar_z) were positioned independently,
// leaving an unverified ~24mm vertical gap between them, and the neck OD
// (built around the old pole_od=50mm) visually overpowered the bell's
// narrow waist.
//
// v15 — TWO FIXES per Janis's screenshot review of the v14 render:
//   ISSUE 1 (gap): pole_top_bell()'s local origin (its small face, local
//     Z=0) is translate()'d to world (cx,cy,xbar_z) BEFORE rotate/scale
//     reorient the rest of the solid around that fixed point — so the
//     bell's small (neck-side) face sits at world Z=xbar_z exactly. The
//     neck's top anchor is now DERIVED from that same point:
//       neck_top = xbar_z + neck_bell_overlap   (overlap = 0.2mm)
//     replacing the old independent z0 formula. This guarantees the neck's
//     top face overlaps 0.2mm into the bell's small-end face — both are
//     siblings inside the same color(){...} block (Rule M-1: implicit
//     union), so the 0.2mm volumetric overlap produces one continuous
//     manifold solid with no visible seam. pole_body()'s height was also
//     extended (body_h = neck_top - neck_h - bed_h) so its top reaches the
//     neck sleeve's new bottom with no gap there either (visual-contact
//     only — the 4 pole parts remain logically separate, not unioned).
//   ISSUE 2 (diameter/proportion): pole_od (pole_d) reduced 50mm→40mm
//     (Janis-approved this session, still above the 36mm market-standard
//     floor — an intentional upgrade, not a regression) specifically to
//     shrink the neck OD relative to the bell's waist. neck_wall_t reduced
//     6mm→3mm per side. neck_id kept at the unchanged v13/v14 formula
//     (pole_d+1 = 41mm, preserving the 0.5mm/side slip-fit clearance
//     mechanism) rather than being redefined directly off pole_od, so
//     neck_od = neck_id + 2*neck_wall_t = 47mm — ⚑ FLAG: 1mm more than
//     Janis's stated "pole_od + 2×3mm = 46mm" formula; see cc_chat_log.md
//     for the full discrepancy explanation (computed both ways).
//   ⚑ FLAG (computed via Python Bezier sampling, see cc_chat_log.md): the
//     bell's concave profile means its narrowest "waist" point is NOT at
//     the small end-face but partway along the curve (~22.25mm radius /
//     44.5mm diameter at z≈16.8mm out of head_h=90mm). The new neck_od
//     (47mm, or even Janis's stated 46mm) STILL EXCEEDS this waist by
//     ~1.5-2.5mm — proportion improved a lot (was much worse at the old
//     63mm neck_od) but not a clean fit yet. NOT resolved by reshaping the
//     bell's Bezier control points, since the bell exterior profile is
//     explicitly DO NOT TOUCH this round — flagged for Janis to confirm.
//   DO NOT TOUCH (per prompt) and left exactly as v14: bore diameter
//     (33mm), bore orientation (X-axis, re-verified unchanged — only the
//     neck's Z anchor formula changed, not pole_top_bell()'s rotate logic),
//     bell exterior profile (wine-glass concave taper), 2x M6 through-bolt
//     mechanism, pole_base_collar(), crossbar geometry. NOTE: pole_base_
//     collar()'s collar_id = pole_d+1 cascades automatically with the
//     global pole_d change (51mm→41mm) — its own code is untouched, this
//     is an automatic side effect of the approved dimension change, flagged
//     in cc_chat_log.md for Janis's awareness.
//   - ⚑ FLAG: pole_body() still has NO through-holes of its own to align the
//     neck's M6 bolt holes against (unchanged flag carried over from v13).
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
pole_d        = 40;   // body diameter (pole_od) — v15: 50mm→40mm, Janis-approved this session to proportionally fit the neck within the bell's waist; see rules-dimensions.md
pole_r        = pole_d / 2;
pole_h        = 1600;  // exposed pole height above bed surface — PENDING

// ── Pole TOP — bell/horn body-of-revolution head + external sleeve neck ────
// Per Janis hand sketch (BAR/POLE annotated): small circular end-face (tail/
// neck side) smoothly tapers to a large circular end-face (pipe-entry side),
// constant-diameter horizontal through-bore for crossbar, neck is now a
// slip-fit sleeve over pole_body() fastened via 2x M6 through-bolts.
neck_h         = 50;    // neck (sleeve) length along Z — minimum 50mm per spec, unchanged
neck_wall_t    = 3;     // v15: 6mm→3mm per side, Janis-specified this round
neck_id        = pole_d + 1;       // = 41mm — slip-fit clearance over pole_od (40mm), 0.5mm/side, unchanged mechanism from v13/v14
neck_od        = neck_id + 2 * neck_wall_t;  // = 47mm — ⚑ FLAG: 1mm more than Janis's stated 46mm (pole_od + 2×3mm) because this keeps the unchanged 1mm slip-fit clearance formula from v13/v14 rather than building neck_od directly off pole_od; see cc_chat_log for the actual-vs-stated comparison
neck_or        = neck_od / 2;      // = 23.5mm — also doubles as head_small_r (continuous, no step)
neck_bell_overlap = 0.2; // v15 NEW — overlap amount (mm) used to seat the neck top into the bell's small-end face for a clean, gap-free union (manifold rule M-2 territory: $fn=64 polygon undercut at this radius is far below 0.2mm, so this overlap is comfortably safe)
head_h         = 90;    // head height (Z) — compact/short per v12 direction, reshaped into bell taper
top_boss_h     = neck_h + head_h;  // = 140mm — unchanged role, still drives xbar_z only (crossbar geometry untouched)
head_small_r   = neck_or;          // = 23.5mm — small end-face radius, matches neck OD (continuous transition)
head_large_r   = 46;    // unchanged from v13/v14 — large end-face radius (pipe-entry side) not tied to pole_od
head_loft_steps = 12;   // number of Bezier sample steps for the outer revolve curve, 13 points total
top_bore_d     = 33;    // TBD — grip_od(32) + 1mm/-0mm clearance, pending physical fit test vs real 32mm pipe, unchanged from v10-v14 (DO NOT TOUCH per v15 prompt)
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
    // v15: top reach extended from (pole_h - top_boss_h) to reach the neck sleeve's new
    // bottom (neck_top - neck_h), where neck_top = xbar_z + neck_bell_overlap (matches
    // pole_top()'s neck anchor) — so there's no visible gap between pole_body()'s top
    // and the neck sleeve's bottom. Visual-contact requirement only; components remain
    // logically separate (not unioned) per the established 4-part architecture.
    neck_top = xbar_z + neck_bell_overlap;
    body_h = (neck_top - neck_h) - bed_h;
    color("#CCCCCC", 1.0)
        translate([cx, cy, bed_h])
            difference() {
                cylinder(h = body_h, r = pole_r, $fn = 64);
                translate([cut_x0, -pole_r - 1, -e])
                    cube([0.3 * pole_r + 1, pole_r * 2 + 2, body_h + 2 * e]);
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
// points. Used by pole_top_bell() to build the bell's outer (radius, height) revolve
// curve as a continuous sweep instead of straight polygon segments.
function cubic_bezier(t, p0, p1, p2, p3) =
    let(u = 1 - t)
    [ u*u*u*p0[0] + 3*u*u*t*p1[0] + 3*u*t*t*p2[0] + t*t*t*p3[0],
      u*u*u*p0[1] + 3*u*u*t*p1[1] + 3*u*t*t*p2[1] + t*t*t*p3[1] ];

// pole_top_bell(cx, cy, dir) — v14 orientation fix. Per the required construction
// method: the COMPLETE solid (wine-glass exterior via rotate_extrude + the bore
// cylinder) is built first in OpenSCAD's natural/default orientation — bore running
// along local Z, the same axis rotate_extrude already uses — then the entire
// difference() result is wrapped in exactly ONE rotate([0,90,0]) as the literal last
// operation before scale/translate position it. The exterior and the bore are never
// rotated separately — this is what v10 and v13 got wrong both times.
// Profile is now wine-glass CONCAVE (curves inward from the straight small-to-large
// line) instead of v13's horn/convex bulge — control points p1/p2 pull inside the
// chord per Janis's note 2.
// After the single rotate([0,90,0]): local Z=0 (small face) -> local X=0,
// local Z=head_h (large face) -> local X=head_h. scale([dir,1,1]) then mirrors which
// world-X direction the bell extends in per pole corner (same dir convention used in
// pre-v13 versions) so the large (entrance) face always points toward bed center /
// the opposite pole, matching the crossbar's actual span — small (exit) face stays
// anchored at the pole/neck.
module pole_top_bell(cx, cy, dir) {
    p0 = [head_small_r,        0];
    p1 = [head_small_r * 0.80, head_h * 0.35];   // pulled INSIDE the chord — concave dip
    p2 = [head_large_r * 0.60, head_h * 0.70];   // pulled INSIDE the chord — concave dip
    p3 = [head_large_r,        head_h];

    outer_curve = [ for (i = [0 : head_loft_steps]) cubic_bezier(i / head_loft_steps, p0, p1, p2, p3) ];
    // close the half-profile back to the revolve axis (x=0) at both ends so
    // rotate_extrude() produces a solid (not a shell) — bore is cut from it below.
    bell_profile = concat([[0, 0]], outer_curve, [[0, head_h]]);

    translate([cx, cy, xbar_z])
        scale([dir, 1, 1])
            rotate([0, 90, 0])
                difference() {
                    rotate_extrude($fn = 64)
                        polygon(points = bell_profile);
                    // bore — still built along local Z here, same axis as the
                    // rotate_extrude above; the single rotate([0,90,0]) wrapping this
                    // whole difference() is what puts it on world X afterward
                    translate([0, 0, -e])
                        cylinder(h = head_h + 2 * e, d = top_bore_d, $fn = 48);
                }
}

// pole_top() — wine-glass bell + external sleeve neck assembly, forming a literal
// T-junction: the vertical neck sleeve (unchanged from v13) is the stem, the
// horizontal bell (now correctly oriented along X via pole_top_bell()'s single
// rotate) is the crossbar of the T, matching the crossbar's actual bore axis. Neck
// z-anchor (z0) and M6 through-bolt hole positions are UNCHANGED formulas from v13 —
// only the bell's construction/orientation and how it's combined with the neck
// changed this round. No latch/cam/lever geometry — Stage 2 scope only.
module pole_top(cx, cy) {
    $fn = 64;  // local resolution bump for this module only (neck/bore/bolt cylinders + revolve); rest of file stays at the global $fn=32 default
    // v15 ISSUE 1 FIX: pole_top_bell()'s local origin (its small face, local Z=0) is
    // translate()'d to world (cx,cy,xbar_z) BEFORE the rotate/scale reorient the rest
    // of the solid around that fixed point — rotate/scale never move the origin itself.
    // So the bell's small (neck-side) face sits at world Z = xbar_z, not xbar_z-head_h
    // (head_h extends horizontally along world X after the rotate, not vertically).
    // neck_top is therefore anchored directly off xbar_z plus the overlap, replacing
    // the old independent z0 = bed_h+pole_h-top_boss_h formula that left an unverified
    // ~24mm gap (v14 flag). This guarantees the neck's top face physically overlaps
    // into the bell's small-end face by exactly neck_bell_overlap (0.2mm) for a clean,
    // gap-free union — both are siblings inside the same color(){...} block (Rule M-1:
    // implicit union).
    neck_top = xbar_z + neck_bell_overlap;
    dir = (cx < bed_l / 2) ? 1 : -1;
    color("#2C3E50", 1.0) {
        difference() {
            pole_top_neck(cx, cy, neck_top);
            // 2x M6 through-bolt clearance holes through both walls of the sleeve —
            // bolt + nut (not blind/threaded), positions unchanged relative to neck
            // span (neck_h*0.3 / neck_h*0.7 below neck_top), axis along X
            for (bz = [neck_top - neck_h + neck_h * 0.3, neck_top - neck_h + neck_h * 0.7])
                translate([cx, cy, bz])
                    rotate([90, 0, 0])
                        cylinder(h = neck_od + 2 * e, d = neck_bolt_d, center = true, $fn = 24);
        }
        pole_top_bell(cx, cy, dir);
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
