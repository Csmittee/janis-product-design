// VM-01 Base Vending Machine
// Janis Product Design
// Version: v58
// Date: 2026-07-09
// Units: mm
// Purpose: Smart donation vending machine — buddha ornaments
// Payment: Online only, no cash/coin mechanism
//
// Changes from v57 (vm01-file-cleanup-pass — zero-geometry-change cleanup,
// confirmed via CGAL vertex/facet/volume counts identical before/after at
// every door_open_deg angle, not assumed):
//   TASK 1: removed confirmed-dead code -- left_front_acrylic() (whole
//     module, zero callers), win_z0/win_z1 (local vars, zero remaining
//     consumers since v49/v51), spring_clearance/acrylic_r/acrylic_t
//     (top-level params, zero consumers). Renamed a naming collision this
//     session's own Task 1 introduced (a local acrylic_top_z inside
//     left_zone_door() was shadowing the pre-existing top-level global of
//     the same name for the right-compartment acrylic zone) to
//     acrylic_pane_top_z. All other show_*/render_mode toggles confirmed
//     actively used, kept. clearance_zone_map() confirmed an intentional
//     permanent diagnostic tool (not a one-off), kept.
//   TASK 2: dashboard()/acrylic_display() searched in full for
//     experimental/scratch code -- none found, stated plainly.
//   TASK 3: header changelog truncated to current version's changes only
//     (was ~850 lines of duplicated per-version narrative back to v3) --
//     full history lives in cc_chat_log.md and git log. Per-module inline
//     comments (left_zone_door(), tray_zone_frame(), drop_zone_guards(),
//     sensor_strip(), compartment_divider(), etc.) condensed to current
//     rationale only, chronological "TASK N"/"vNN FIX" narrative removed.
//   TASK 4 (highest-value fix): outer_shell() and outer_shell_debug() --
//     independently-duplicated shell-cutout logic, the root cause of both
//     the v55 door-floor datum bug and the v56 corner-cutout gap -- merged
//     into ONE module. outer_shell() was confirmed 100% dead code (zero
//     callers, superseded by outer_shell_debug() once the show_shell_*
//     debug toggles were added and never removed); outer_shell_debug()
//     is the single surviving module, renamed to outer_shell(). Real
//     CGAL 11-angle sweep (0-100°, 10° steps) post-merge: Simple:yes
//     throughout, zero warnings, byte-identical facet/vertex/volume
//     counts to pre-merge at every angle tested.
//   RESULT: 2592 -> 1254 lines (52% reduction). Render time unchanged
//     (~8.5s, expected -- comment/dead-code removal doesn't affect CGAL
//     computation, only file size/readability). No file split attempted
//     this session, per explicit instruction.
//
// Full version history (v3 through v57): see cc_chat_log.md and git log.

$fn = 64;

// ─────────────────────────────
// PARAMETERS
// ─────────────────────────────

total_w = 640;
total_h = 700;
total_d = 600;
corner_r = 20;
skin_t = 2;

// Epsilon — prevents z-fighting on coincident front faces. MOVED HERE
// (v55, vm01-v55-door-floor-datum-fix) from its old spot further down the
// PARAMETERS block -- door_bot_z (below) now needs it in its OWN top-level
// formula, and OpenSCAD's top-level assignment resolution does NOT support
// a forward reference to a variable declared later in the same file
// (confirmed via a live "Ignoring unknown variable 'e'" warning when first
// attempted at the old declaration order) -- unlike a global referenced
// INSIDE a module body, which resolves at call time after the whole file
// is parsed. Moved above every consumer instead of duplicating the literal.
e = 0.01;

// Legs
leg_h = 50;
leg_od = 25;
leg_inset = 40;

// §2.1 (v43) -- explicit foot/leg-height term. DATUM_LEG_TOP used to be
// `= leg_h` directly, silently absorbing this 50mm into a datum LABEL —
// any part built on DATUM_LEG_TOP looked "floor-referenced" but was really
// one hidden addition away from true ground. FOOT_BASE_H makes that
// addition explicit; every ground-referenced Z-stack in the door assembly
// below shows it as `FOOT_BASE_H + <term>`, never folds it into a name.
FOOT_BASE_H = leg_h;   // 50mm

// Compartments
product_w = 416;
system_w = 204;    // screen board 180mm + bezel×2 + margin
divider_t = 19;

// Spring / Tray
spring_od = 66;
spring_l = 390;
motor_d = 60;
spring_gap = 13;    // OD-to-OD gap — OWNER-LOCKED (5mm clearance + 3mm partition + 5mm)
spring_lanes = 5;
tray_count = 2;
tray_floor_t = 5;
tray_wall_t = 3;
tray_h = 121;           // floor(5) + spring_od(66) + clearance(50) -- OWNER-LOCKED, see rules-dimensions.md (spring_clearance param removed v58 cleanup pass, was never wired into this formula, tray_h itself unchanged)
partition_h = 40;
tray_d = spring_l + motor_d;  // 450mm

// Tray zone -- true zone height only; Z-position now comes from DATUMS below
tray_zone_h = tray_h * tray_count;         // 242mm

// Zones
drop_zone_d = 138;
tray_start_d = drop_zone_d;

// Exit zone -- shell chute cutout + drop_zone_guards() only. No longer
// determines tray position (v42) -- see DATUMS block.
exit_door_w = 400;
exit_door_h = 250;

// Customer pickup flap — flap_w/flap_h superseded by exit_w/exit_h (v41, see below), flap_t still used
flap_t = 3;

// Tray rack
rail_w = 10;
rail_h = 10;
latch_pin_d = 8;
latch_pin_l = 10;   // 15 → 10: pin stays inside cavity, clears outer shell back face at 598mm

// Door / panel
door_t = 3;
hinge_od = 12;   // v41: also reused as left_zone_door()'s stopper-rod diameter

// v48 TASK 3a: real acrylic sheet thickness -- distinct from acrylic_t
// (above, the RIGHT-compartment acrylic_display() panel skin, unrelated
// part) -- applied ONLY to left_zone_door()'s acrylic fill piece.
door_acrylic_t = 5;

// Frame bars
// v50 TASK 2: reduced 20mm->8mm -- both verticals now extend by CURVE/
// touch-contact to reach the housing (shell corner / compartment_divider())
// instead of floating with a frame_inset gap, so less raw bar width is
// needed to still reach the door-clearance boundary. See tray_zone_frame().
frame_bar = 8;

// v48 TASK 3b: promoted from tray_zone_frame()'s own local scope to a
// shared PARAMETER -- left_zone_door()'s acrylic-vs-top-flange clearance
// calc needs the SAME values tray_zone_frame() uses for its border inset
// and weld-flange thickness, per this file's established "independently
// re-derive from shared named constants, never read another module's
// local variable" convention -- not a duplicated/guessed number.
frame_inset = 5;
FLANGE_T = 10;   // weld-flange thickness (Z), v46 TASK 3

// Left-zone front door (v41/v42/v43) — replaces front_door()+flap_door()+spring_zone_panel()
exit_w = 300;                          // supersedes old flap_w=250
exit_h = 150;                          // supersedes old flap_h=100

// §2.2 (v43) -- HINGE_Y_OFFSET is now a fixed, INDEPENDENT constant (was
// `corner_r + 5`). Measured from the shell's theoretical SHARP corner (the
// invisible intersection of the front-face plane and left-face plane,
// extended past corner_r's rounded fillet -- NOT the fillet's own center
// at (corner_r, corner_r)). Does not move if corner_r is retuned later for
// cosmetic reasons -- corner_r becomes a separate clearance check ("does
// 25mm still clear the curve"), never an input to this formula. Both
// left_zone_door() and the shell's recess-pocket cutout independently
// re-derive the hinge center from this same named constant -- see each
// module for its own local hinge_x/y/z computation.
HINGE_Y_OFFSET = 25;                   // 25mm

return_depth = HINGE_Y_OFFSET - skin_t;// 23mm -- flange depth, front face to hinge line (general-purpose, e.g. exit_x centering below; the shell's OWN recess-pocket cutout does NOT read this global -- it re-derives its own copy, see outer_shell())
door_left_x = skin_t;                  // 2mm -- door's own width envelope, left edge
door_right_x = product_w - skin_t;     // 414mm -- LEFT ZONE ONLY, not total_w
door_w = door_right_x - door_left_x;   // 412mm -- door's own true width
exit_x = door_left_x + ((door_right_x-door_left_x-return_depth) - exit_w)/2 + return_depth; // centered in door width
flap_open_deg = 55;                    // Janis-approved, was targeting "~60 or less"
door_open_deg = 100;                   // full-open angle for door_open viewer toggle
acrylic_border = 5;                    // overlap border, screw-in material
window_flap_gap = 40;                  // clearance above the flap opening
hinge_mark_h = 20;                     // hinge seam indicator mark height
hinge_mark_d = 1;                      // hinge seam indicator mark depth (Y), flush placeholder only

// §2.3 (v43)/v44 TASK 4 -- window/acrylic FROZEN as the door's OWN local
// constants. RESIZED 2026-07-05 (v44): now matches the new H-frame's inner
// clear opening (TASK 3) instead of the old tray-zone slice -- world X
// 27-389mm (between the frame's two verticals) and world Z 55-693mm
// (near-floor to near-roof, same frame envelope), giving a full view of
// the whole compartment. Superseded values (v43): window_x0=38/
// window_z0=220/window_w=336/window_h=242 (world Z 270-512mm).
window_x0 = 25;    // local X, door's local origin -> window left edge
window_z0 = 5;     // local Z, door's local origin -> window bottom edge
window_w  = 362;
window_h  = 638;

// v57 TASK 4 (vm01-acrylic-curve-hinge-lock-fix): lock system PROVISION
// -- a reservation only, NOT full lock/latch hardware design (deliberately
// deferred, per prompt scope). Lock type, exact position, and dimensions
// are NOT determinable from any existing project file -- searched
// vending-machine/design_scope_of_work_rule.md, rules-dimensions.md, and
// cc_chat_log.md in full, no prior lock spec found anywhere -- flagged
// explicitly for Janis's input (see cc_chat_log), not invented. This is
// the most conservative/generic placeholder: a shallow rectangular recess
// sized for a common cabinet cam lock (~30x40mm mounting footprint, well
// within typical cam-lock/deadbolt hardware envelopes), NOT a functional
// mechanism. Positioned front-facing and reachable: RIGHT edge of the
// door leaf (opposite the hinge, the conventional lock position), clear
// of the flap's own full swept X-range (world X 69.5-369.5, computed live
// from exit_x/exit_w below, not hardcoded), clear of the window/acrylic
// Z-range (world Z ~370-698), and clear of the hinge-side geometry
// entirely (left edge). PLACEHOLDER -- dimensions/position not yet
// confirmed by Janis.
lock_provision_w  = 30;    // PLACEHOLDER width (X) -- not yet confirmed by Janis
lock_provision_h  = 40;    // PLACEHOLDER height (Z) -- not yet confirmed by Janis
lock_provision_d  = 1.5;   // PLACEHOLDER recess depth (Y) -- not yet confirmed by Janis; half of door_t, leaves structural material behind (not a through-hole)
lock_provision_z0 = 280;   // world Z, recess bottom -- mid-height, in the solid leaf band between the flap's full swept top (world ~235mm) and the window/acrylic's own bottom (world 370mm), confirmed clear via this file's own flap_cut_z1/split_z_local values, not guessed
lock_provision_margin = 6; // PLACEHOLDER inset from the door's own right edge (door_right_x) -- not yet confirmed by Janis

// ─────────────────────────────
// DATUMS (v42, FOOT_BASE_H term added v43 §2.1) — single source of truth
// for shared Z-reference planes. Every module below must reference ONE of
// these directly for any position shared with another module. Never derive
// a new "local" version of one of these values inside a module — reference
// the datum itself. Root cause this prevents: tray_0_z and the door's
// window_z0/z1 were each independently derived in v41 and drifted apart
// (window floated ~170mm above the actual trays). See .claude/rules-codes.md
// "Datum Rules" + .claude/SKILL_reference_point_first.md.
// ─────────────────────────────
DATUM_FLOOR    = 0;
DATUM_LEG_TOP  = FOOT_BASE_H;                        // 50 -- explicit foot-base term (§2.1), was silently `= leg_h`
DATUM_FLAP_TOP = DATUM_LEG_TOP + 30 + exit_h;        // 230 -- exit flap hinge line
DATUM_TRAY_BOT = DATUM_FLAP_TOP + window_flap_gap;   // 270 -- tray zone starts here
DATUM_TRAY_TOP = DATUM_TRAY_BOT + tray_zone_h;       // 512 -- 242mm of trays
DATUM_ROOFLINE = total_h;                            // 700 -- absolute top

// Zone stack — derived from DATUMS (was independently re-derived pre-v42;
// Janis-approved 2026-07-05: position isn't independently locked, the real
// constraint is the door/flap staying close to the floor for customer
// access, which DATUM_FLAP_TOP's own chain already guarantees).
tray_0_z        = DATUM_TRAY_BOT;                    // 270mm -- v46: kept UNCHANGED as the pre-shift baseline; tray_compartment_partition() anchors here (the point the trays moved away from). Do NOT use this for the trays' own live position -- see tray_stack_z0 below.
tray_zone_top_z = DATUM_TRAY_TOP;                    // 512mm -- v46: deliberately UNCHANGED (shell/right-compartment zone-stack datum, out of this prompt's scope) -- see tray_stack_z0 clearance note below for why this no longer equals the physical tray-stack top
upper_display_h = DATUM_ROOFLINE - tray_zone_top_z;  // 188mm
// v44: panel_zone_top_z/panel_zone_h deleted -- fully dead code, both only
// ever consumed by the old tray_zone_frame() (TASK 3 rebuild, see below),
// same "avoid dormant globals" precedent as v41's flap_w/flap_h/hinge_h removal.

// v46 TASK 1 -- tray compartment access gap fix. A hand could reach under
// the lowest spring tray into the tray compartment from the exit zone; no
// wall/floor blocked it. Fix: shift the entire tray stack UP, and seal the
// vacated space with a fixed partition (see tray_compartment_partition()/
// exit_compartment_wall() below). tray_0_z itself is NOT touched (stays
// the pre-shift anchor); spring_tray()/tray_rack() use tray_stack_z0.
TRAY_SHIFT_UP  = 100;                    // mm, Janis-approved
tray_stack_z0  = tray_0_z + TRAY_SHIFT_UP; // 370mm -- NEW lowest-tray-floor Z (live reference, spring_tray()/tray_rack()/door acrylic split all read this, not a duplicated number)

// v56 (vm01-v56-sensor-bracket-frame-joint-fix): sensor_strip()'s own Z,
// hoisted here as a SHARED datum -- was computed locally inside that
// module only (`strip_z = tray_stack_z0 - 20`). drop_zone_guards() now
// also needs this value (see FIX below) -- per this file's own lesson
// from the v55 manifold bug (a datum independently re-derived in 4 places
// drifted out of sync), this is declared ONCE here and read by both
// modules, not recomputed.
sensor_strip_z0 = tray_stack_z0 - 20;    // 350mm world
sensor_strip_h  = 8;                     // matches sensor_strip()'s own strip_h

// Mandatory clearance check (top tray vs the physical roofline/door
// boundary, tray_count=2 only, no 3-row variant exists):
//   top tray ceiling = tray_stack_z0 + tray_count*tray_h = 612mm
//   clearance vs door_top_z (698mm) = 86mm -- POSITIVE
//   clearance vs DATUM_ROOFLINE (700mm) = 88mm -- POSITIVE
// FLAG: vs the UNCHANGED DATUM_TRAY_TOP (512mm, tautologically defined as
// DATUM_TRAY_BOT+tray_zone_h, not an independent physical ceiling) the
// shifted stack reads "-100mm over" -- NOT a 3D collision, nothing else
// occupies world Z 512-612 on the left side. Whether the "upper display"
// zone LABEL should be redefined is a separate documentation question,
// out of scope (shell/right-compartment datums untouched).

// Left-zone door Z range -- from DATUMS. door_bot_z uses
// FOOT_BASE_H+skin_t-e (the interior floor SURFACE, nudged e below it for
// a real Rule M-1 shared volume), NOT FOOT_BASE_H+0 (the floor SKIN's own
// absolute base) -- that old value buried the door's bottom 2mm inside
// the shell's own floor slab, the real root cause of the long-standing
// door-closed manifold warning. This same constant also sets the corner-
// pole cutout's own Z-start in the shell module, closing the bottom-left
// floor hole as a side effect.
door_bot_z = FOOT_BASE_H + skin_t - e;   // 51.99mm -- was FOOT_BASE_H+0 (50mm)
door_top_z = DATUM_ROOFLINE - skin_t;    // 698mm
door_h     = door_top_z - door_bot_z;    // 646.01mm -- was 648mm, shared with the shell's left-wall recess cutout AND the corner-pole cutout (both re-derive door_bot_z/door_h independently, see below)
exit_bot_z = door_bot_z + 30;            // 81.99mm -- was 80mm, 30mm clearance off the (correct) interior floor surface

// Dashboard
dash_x = product_w + divider_t + skin_t;
dash_w = system_w - divider_t - (skin_t * 2);  // 204 - 19 - 4 = 181mm ✓
screen_w = 165;
screen_h = 100;
screen_center_z = 280;
screen_protrude = 30;   // screen protrudes this far forward of front face
screen_y = skin_t - screen_protrude;   // -28mm — 30mm forward of front skin
bracket_r = 8;
bezel_t = 3;
qr_w = 40;
qr_h = 30;
qr_d = 10;
card_w = 85;
card_h = 8;
card_d = 15;
speaker_w = 60;
speaker_h = 20;
speaker_slots = 5;

// v50 TASK 3: tray's own X-inset -- was a bare hardcoded "10" in BOTH
// spring_tray() and tray_rack() (two places, same magic number). LIVE
// geometry check found widening total_w/product_w (as the corner-frame-
// redesign prompt's literal instruction said) has ZERO effect on the
// lane-0-vs-left-vertical collision (neither depends on total_w/
// product_w) -- the REAL fix is this inset. First attempt (14mm, giving
// lane 0 a real 2mm clearance) was caught by a WIDER re-check as
// insufficient: the TRAY'S OWN BOX (not just the spring lanes -- its
// side walls) also needs clearance from both verticals, and its RIGHT
// wall position depends on product_w the SAME way the right vertical's
// touch-point does (both move together, so widening product_w cannot
// open a gap between them either -- confirmed algebraically and via
// live render, not assumed). 17mm is the minimum value giving the box's
// LEFT wall a real 2mm clearance from the left vertical's max reach
// (15mm); tray_w (below, both modules) is now sized so the box's RIGHT
// wall gets the SAME real 2mm clearance from the right vertical's touch
// point, instead of the old fixed "product_w-20" formula. Was 10
// (uninset, hardcoded, unnamed) pre-v50.
tray_x_inset = 17;

// v50 TASK 3: tray width, derived from the SAME real 2mm clearance
// convention on the box's right wall vs the right vertical's own touch
// point (product_w+e-frame_bar, see tray_zone_frame()) -- was the fixed
// "product_w - 20" (assumed a symmetric 10mm margin each side, which no
// longer fits since the right vertical now touches the divider). Both
// spring_tray() and tray_rack() reference this instead of re-deriving
// their own copy.
tray_w_global = (product_w + e - frame_bar - 2) - tray_x_inset;  // 389.01mm, was tray_w=396mm (product_w-20)

// Acrylic display zone (upper right compartment)
// acrylic_r/acrylic_t removed (v58 cleanup pass) -- both had zero
// consumers anywhere in acrylic_display() (its panels use door_t/skin_t
// directly, sharp corners throughout, no rounding applied) -- confirmed
// dead, not wired into any geometry, removing changes nothing rendered.
acrylic_bot_z = tray_zone_top_z;               // 542mm
acrylic_top_z = total_h - skin_t;              // 698mm
acrylic_zone_h = acrylic_top_z - acrylic_bot_z; // 156mm

// ─────────────────────────────
// MODULES
// ─────────────────────────────

module rounded_box(w, h, d, r) {
    hull() {
        translate([r, r, 0]) cylinder(r=r, h=h);
        translate([w-r, r, 0]) cylinder(r=r, h=h);
        translate([r, d-r, 0]) cylinder(r=r, h=h);
        translate([w-r, d-r, 0]) cylinder(r=r, h=h);
    }
}

// Height extended by e past leg_h so the top reaches e INTO the shell's
// floor skin -- a real (not degenerate) shared volume, Rule M-1.
module leg() {
    color("#AAAAAA")
    cylinder(h=leg_h + e, d=leg_od);
}

module legs() {
    positions = [
        [leg_inset, leg_inset],
        [total_w-leg_inset, leg_inset],
        [leg_inset, total_d-leg_inset],
        [total_w-leg_inset, total_d-leg_inset]
    ];
    for (p = positions)
        translate([p[0], p[1], 0]) leg();
}

module spring_coil() {
    color("#888888", 0.8)
    cylinder(h=spring_l - 2, d=spring_od - 2);  // d-2: 1mm clearance each side, clears tray wall tangent touch
}

// TODO(Janis, deferred): partition + back door for spare storage under trays

// Motor at BACK. Spring front end at Y=0 (drop zone boundary). Products fall forward.
module spring_tray(tray_num) {
    tray_w = tray_w_global;  // v50 TASK 3: was product_w-20, see PARAMETERS for the new derivation
    z = tray_stack_z0 + (tray_num * tray_h);   // v46: reference tray_stack_z0 (shifted +100mm), not tray_0_z directly -- tray_0_z is now the fixed pre-shift anchor for tray_compartment_partition() only
    tray_y = tray_start_d - (tray_d * tray_out_pct);   // v41: slides toward the front opening

    // v50 TASK 3: was hardcoded "10" -- promoted to tray_x_inset (14mm),
    // see PARAMETERS. Live sweep across the full tray_out_pct range
    // confirmed lane 0's swept footprint clears tray_zone_frame()'s
    // rebuilt left vertical (real 2mm margin) at this value.
    translate([tray_x_inset, tray_y, z]) {
        // Single solid box with hollow subtracted — no union() T-junctions, always manifold
        color("#CCCCCC")
        difference() {
            // Outer solid box — full tray footprint
            cube([tray_w, tray_d, tray_h]);

            // Hollow interior — open top (+1 overshoot)
            translate([tray_wall_t, tray_wall_t, tray_floor_t])
                cube([tray_w - (tray_wall_t * 2),
                      tray_d - (tray_wall_t * 2),
                      tray_h - tray_floor_t + 1]);

            // Open front face (Y=0) — springs and products visible from front
            translate([tray_wall_t, -1, tray_floor_t])
                cube([tray_w - (tray_wall_t * 2),
                      tray_wall_t + 2,
                      tray_h - tray_floor_t + 1]);

            // Left side wall window
            translate([-1, tray_wall_t * 2, tray_floor_t + tray_wall_t])
                cube([tray_wall_t + 2,
                      tray_d - (tray_wall_t * 4),
                      tray_h - tray_floor_t - (tray_wall_t * 2)]);

            // Right side wall window
            translate([tray_w - tray_wall_t - 1, tray_wall_t * 2, tray_floor_t + tray_wall_t])
                cube([tray_wall_t + 2,
                      tray_d - (tray_wall_t * 4),
                      tray_h - tray_floor_t - (tray_wall_t * 2)]);

            // Rear motor mount cutouts — height 36: motor top = tray_floor_t+e+35 = 40.01mm, cutout top = 41mm ✓
            for (i = [0:spring_lanes-1]) {
                x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);
                translate([x - 11, tray_d - tray_wall_t - 1, tray_floor_t])
                    cube([22, tray_wall_t + 2, 36]);
            }

            // Rear latch pin hole
            translate([tray_w/2, tray_d - tray_wall_t - 1, tray_h/2])
                rotate([-90, 0, 0])
                    cylinder(d=latch_pin_d, h=tray_wall_t + 2);
        }

        // Springs + motors — motor at back, spring front at Y=0
        // All objects offset by e from tray body faces to prevent coplanar non-manifold
        for (i = [0:spring_lanes-1]) {
            x = tray_wall_t + spring_od/2 + i*(spring_od + spring_gap);

            // Motor: confirmed innocent by isolation test — restored
            color("#555555")
            translate([x-9, tray_d - motor_d - tray_wall_t - e, tray_floor_t + e])
                cube([18, motor_d - 2, 33]);

            // Spring coil: Z centre +2mm above floor (clears $fn=64 polygon facet dip), d-2 clears walls
            color("#999999")
            translate([x, tray_d - motor_d - 2, tray_floor_t + spring_od/2 + 2])
                rotate([90, 0, 0])
                    spring_coil();

            if (i < spring_lanes-1) {
                // Partition: lifted e off floor, offset e from front wall, shortened e from rear wall inner face
                color("#BBBBBB")
                translate([x + spring_od/2 + spring_gap/2, tray_wall_t + e, tray_floor_t + e])
                    cube([2, tray_d-(tray_wall_t*2) - e, partition_h]);
            }
        }
    }
}

module tray_rack() {
    tray_w = tray_w_global;  // v50 TASK 3: was product_w-20, see PARAMETERS for the new derivation
    color("#AAAAAA")
    for (t = [0:tray_count-1]) {
        z = tray_stack_z0 + (t * tray_h);   // v46: reference tray_stack_z0 (shifted +100mm), same fix as spring_tray()
        // v50 TASK 3: was hardcoded "10" (3 places) -- promoted to
        // tray_x_inset (14mm), matching spring_tray()'s own value so the
        // rails/latch stay aligned with the tray body.
        translate([tray_x_inset, tray_start_d, z - rail_h])
            cube([rail_w, tray_d, rail_h]);
        translate([tray_x_inset + tray_w - rail_w, tray_start_d, z - rail_h])
            cube([rail_w, tray_d, rail_h]);
        translate([tray_x_inset + tray_w/2, tray_start_d + tray_d - tray_wall_t, z + tray_h/2])
            rotate([-90, 0, 0])
                cylinder(d=latch_pin_d, h=latch_pin_l);
    }
}

// Fixed/welded horizontal panel sealing the space vacated by the 100mm
// tray-stack shift (TRAY_SHIFT_UP) -- spans the full width of the tray/
// product compartment, NOT a removable/access panel. Positioned at the
// pre-shift tray_0_z (270mm), the anchor the trays moved away from, NOT
// tray_stack_z0. Front edge sits at drop_zone_d (138mm, the same constant
// exit_compartment_wall() uses for its own Y-position) for a real 2mm-deep
// shared volume with that wall (Rule M-1), fully sealing the compartment
// per Janis's requirement -- confirmed clear of tray_zone_frame()'s real
// footprint (max Y=21mm there, 117mm margin). Works together with
// exit_compartment_wall() (below) to fully close the reach-through path
// from the exit zone into the tray compartment. Safety-critical, always on
// (see PART_MANIFEST.md).
module tray_compartment_partition() {
    partition_t = tray_floor_t;   // 5mm, reuses the tray floor's own thickness convention
    partition_y0 = drop_zone_d;              // 138mm -- was 526mm (v47); real contact with exit_compartment_wall()
    partition_y1 = total_d - skin_t;          // 598mm -- rear wall, unchanged

    // Contact receipt (Rule M-3):
    //   vs exit_compartment_wall(): real 2mm-deep shared volume (world Y
    //     138-140mm), confirmed via its own wall_t -- not proximity.
    //   vs tray_zone_frame()'s REAL footprint at this Z-plane (270-275mm):
    //     max Y = 21mm (crossbar+both verticals, computed live) -- gap to
    //     partition_y0(138mm) = 117mm, confirmed EMPTY.
    color("#AAAAAA")
    translate([skin_t, partition_y0, tray_0_z])
        cube([product_w - (skin_t*2), partition_y1 - partition_y0, partition_t]);
}

// Rear-facing wall sealing the Y-direction reach-through at the drop-zone/
// tray-compartment boundary (Y=drop_zone_d), full width, floor to
// Z=tray_0_z+partition_t+e. Distinct from drop_zone_guards() (2 thin SIDE
// panels within the drop zone's own depth, don't block front-to-back
// reach) and flap_stopper_rod() (a bare rod, no bracket geometry). Shares
// a real 2mm-deep contact band with tray_compartment_partition()'s front
// edge (both at Y=drop_zone_d). Safety-critical, always on (see
// PART_MANIFEST.md).
module exit_compartment_wall() {
    partition_t = tray_floor_t;   // matches tray_compartment_partition()
    wall_t = skin_t;
    color("#AAAAAA")
    translate([skin_t, drop_zone_d, leg_h])
        cube([product_w - (skin_t*2), wall_t, (tray_0_z + partition_t + e) - leg_h]);
}

// Single shell module (v58 cleanup pass -- merged outer_shell()+
// outer_shell_debug()). The two existed because outer_shell() (extrusion
// height = total_h, no panel-removal toggles) predates the show_shell_*
// C2-export debug toggles; outer_shell_debug() was added later with its
// own local shell_h = total_h-leg_h (compensating for ASSEMBLY's own
// +leg_h translate) plus the 5 panel toggles, and became the ONLY one
// actually called in ASSEMBLY -- outer_shell() was left behind as dead
// code (confirmed zero callers) and had already drifted out of sync at
// least once (the v56 corner-pole Y-reach fix landed in
// outer_shell_debug() only, the copy that matters; editing outer_shell()
// first and re-testing was what caught that a second copy even existed).
// Single source of truth now -- the "debug" toggles are just normal
// parameters on this one module, not a second geometry copy.
//
// TODO (Janis, NOT resolved): a second door-closed collision (frame trim/
// joggle line at the right body edge) has not been root-caused. Not the
// recess pocket/corner cutout below (searched in full, no matching
// sub-feature) and not tray_zone_frame() (already fixed, confirmed clean)
// -- needs a render/screenshot pointing at the specific edge before a fix
// can be attempted.
module outer_shell() {
    shell_h = total_h - leg_h;

    // Shell independently re-derives the hinge center from its own datum
    // chain (world sharp-corner reference + FOOT_BASE_H + HINGE_Y_OFFSET +
    // hinge_od) -- never reads left_zone_door()'s local variables, so this
    // copy must be kept in sync with that module's own hinge_x/y/z by hand.
    shell_hinge_x = 0 - (hinge_od / 2);        // -6mm world
    shell_hinge_y = HINGE_Y_OFFSET;             // 25mm world
    shell_hinge_z = FOOT_BASE_H + skin_t - e;   // 51.99mm world
    shell_return_depth = shell_hinge_y - skin_t; // 23mm

    color("#C8C8C8", 0.75)
    difference() {
        rounded_box(total_w, shell_h, total_d, corner_r);

        // Hollow interior
        translate([skin_t, skin_t, skin_t])
            rounded_box(total_w-(skin_t*2), shell_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);

        // Left product zone front cutout
        translate([skin_t, -1, 0])
            cube([product_w-(skin_t*2), skin_t+2, tray_zone_top_z - leg_h]);

        // Exit zone chute cutout
        translate([(product_w - exit_door_w)/2, -1, 0])
            cube([exit_door_w, skin_t+2, exit_door_h]);

        // Upper front display cutout
        translate([skin_t, -1, tray_zone_top_z - leg_h])
            cube([product_w-(skin_t*2), skin_t+2, upper_display_h]);

        // Right compartment front face opening
        translate([product_w + divider_t, -1, 0])
            cube([system_w - divider_t - skin_t, skin_t+2, tray_zone_top_z - leg_h]);

        // Left-side-wall recess for left_zone_door()'s return flange/hinge line.
        translate([-1, skin_t, shell_hinge_z - leg_h])
            cube([skin_t + 2, shell_return_depth, door_h]);

        // Front-left corner "pole" removal: the solid curved wedge of
        // shell wall between the outer rounded_box (r=corner_r) and the
        // inner hollow (r=corner_r-1) at this corner was never cut by
        // either cutout above -- removed via a square cut (not inset/
        // notched, not practical in real sheet-metal forming) spanning
        // the full corner footprint at the door's own full height.
        // Architecturally the same kind of aperture as the door/window/
        // chute cutouts above -- closed by the door leaf's own return
        // flange, not meant to be watertight on its own. Y-reach extended
        // to shell_hinge_y+2 (27mm, reuses the recess pocket's own Y-limit
        // reference) -- corner_r+2(22) alone left a real X-Y gap versus
        // the recess pocket above (a genuine, if tiny, physical
        // interference with the door's return-flange footprint, not just
        // a manifold-warning-class degenerate touch).
        translate([-1, -1, door_bot_z - leg_h])
            cube([corner_r + 2, shell_hinge_y + 2, door_h]);

        // Back panel — removed when show_shell_back = false
        if (!show_shell_back)
            translate([0, total_d - skin_t - 1, 0])
                cube([total_w, skin_t + 2, total_h]);

        // Top panel — removed when show_shell_top = false. References
        // shell_h (this module's own local height), not total_h -- the
        // shell is placed at +leg_h in ASSEMBLY, so total_h would double-
        // count that offset and cut empty space above the real shell.
        if (!show_shell_top)
            translate([0, 0, shell_h - skin_t - 1])
                cube([total_w, total_d, skin_t + 2]);

        // Bottom panel — removed when show_shell_bottom = false
        if (!show_shell_bottom)
            translate([0, 0, -1])
                cube([total_w, total_d, skin_t + 2]);

        // Left panel — removed when show_shell_left = false
        if (!show_shell_left)
            translate([-1, 0, 0])
                cube([skin_t + 2, total_d, total_h]);

        // Right panel — removed when show_shell_right = false
        if (!show_shell_right)
            translate([total_w - skin_t - 1, 0, 0])
                cube([skin_t + 2, total_d, total_h]);
    }
}

// Bottom nudged e below world Z=leg_h (a real shared volume with the
// shell's floor skin, Rule M-1, not a coincident touching face); top
// (total_h-skin_t) unaffected.
module compartment_divider() {
    color("#AAAAAA", 0.9)
    difference() {
        translate([product_w, skin_t, leg_h - e])
            cube([divider_t, total_d-(skin_t*2), total_h - leg_h - skin_t + e]);

        // v57 TASK 4 (vm01-acrylic-curve-hinge-lock-fix): lock/latch
        // STRIKE provision -- shallow recess in this wall's own
        // front-left corner, the adjacent fixed structure immediately
        // next to the door's right edge (world X=product_w), matching
        // left_zone_door()'s own lock_provision_z0/h so the two line up
        // at the same height. PLACEHOLDER ONLY -- like the door-side
        // recess, position/dimensions are not yet confirmed by Janis; a
        // future real lock design may engage a different part entirely
        // (this divider vs. a dedicated strike bracket) -- this is a
        // conservative reservation, not a commitment to this being the
        // final engaging part.
        if (show_lock_provision)
            translate([product_w - e, skin_t - e, lock_provision_z0 - e])
                cube([lock_provision_d + e, lock_provision_w, lock_provision_h + 2*e]);
    }
}

// §2.4 (v43) helper -- samples `segs+1` points on a circle, used to build
// the curved flange below (replaces the old hard 90° polygon corner with
// an arc that follows the shell's actual rounded interior corner).
function arc_pts(cx, cy, r, a0, a1, segs) =
    [for (i = [0:segs]) let(a = a0 + i*(a1-a0)/segs) [cx + r*cos(a), cy + r*sin(a)]];

// v43: Left-zone front door — replaces front_door()+flap_door()+spring_zone_panel().
// LOCAL ORIGIN (§2.2): (0,0,0) = the HINGE CENTER, the referential datum for
// the entire door assembly, world coords Z=FOOT_BASE_H+0, Y=HINGE_Y_OFFSET,
// X=0-(hinge_od/2) (barrel proud of the shell's exterior wall). Computed
// independently below from shared named constants -- the shell's own
// recess-pocket cutout (outer_shell()) computes the SAME point
// independently too, never by reading these local variables.
// door_open is a plain rotate() about this same origin. Every sub-part
// (flange/panel, window, acrylic, flap, hinge marks) is re-expressed
// relative to this origin via `door_x_offset` below -- their WORLD-SPACE
// geometry is unchanged from v42, only what they're measured FROM changed.
//
// Stopper rod lives in its own module, flap_stopper_rod() — a stop that
// swings with the thing it's stopping isn't a stop. Called separately in
// ASSEMBLY, fixed to the cabinet, unaffected by door_open. The acrylic
// pane correctly stays IN this rotation (it's mounted to the door, so it
// should move with it).
module left_zone_door() {
    // §2.2 -- hinge center, independently computed (own local vars, not
    // shared with the shell's separate calc below -- both read the same
    // named constants, never each other's variables).
    hinge_x = 0 - (hinge_od / 2);      // -6mm -- barrel proud of exterior wall (world X=0), outward by half OD
    hinge_y = HINGE_Y_OFFSET;          // 25mm
    hinge_z = FOOT_BASE_H + skin_t - e;  // 51.99mm -- v55 FIX, was FOOT_BASE_H+0 (50mm), see door_bot_z comment in PARAMETERS for the full root-cause writeup

    door_x_offset = door_left_x - hinge_x;    // 2 - (-6) = 8mm -- local-X distance from the hinge origin to the door's own left-edge world position, keeps every sub-part's world-space geometry anchored regardless of where hinge_x sits

    door_open_angle = door_open ? door_open_deg : 0;
    front_y = -(hinge_y - skin_t) + e;   // §2.5 epsilon -- nudged e off the shell's interior front-wall face (was flush at world Y=skin_t)
    flap_top_z = DATUM_FLAP_TOP - hinge_z;      // 180mm local -- flap hinge line
    flap_angle = flap_open ? flap_open_deg : 0;

    // v57 TASK 4: lock provision recess, local coords -- right edge of the
    // door (opposite the hinge), see PARAMETERS block for the full
    // placeholder note.
    lock_x1_local = (door_right_x - lock_provision_margin) - hinge_x;
    lock_x0_local = lock_x1_local - lock_provision_w;
    lock_z0_local = lock_provision_z0 - hinge_z;

    // §2.3 frozen window constants, re-anchored to the corrected local-X origin.
    // win_z0/win_z1 REMOVED (v58 cleanup pass) -- zero remaining consumers,
    // superseded by split_z_local/acrylic_top_limit_z since v49/v51 (see
    // cc_chat_log.md); window_z0/window_h themselves kept as top-level
    // PARAMETERS, still the documented "window opening" Z spec in
    // rules-dimensions.md even though no longer wired into a cut directly.
    win_x0 = door_x_offset + window_x0;             // 46mm local
    win_x1 = door_x_offset + window_x0 + window_w;  // 382mm local

    exit_x_local = door_x_offset + (exit_x - door_left_x);  // local X of the exit-flap opening
    exit_bot_local = exit_bot_z - hinge_z;                   // 30mm local

    // v46 TASK 2: acrylic/metal split point -- a LIVE reference to
    // tray_stack_z0 (the same constant driving the tray stack's actual
    // position), not a duplicated magic number. If TRAY_SHIFT_UP ever
    // changes again, this boundary moves with it automatically.
    split_z_local = tray_stack_z0 - hinge_z;   // 320mm local -- world 370mm, matches tray_stack_z0 exactly

    // acrylic_top_limit_z: pulled down to clear tray_zone_frame()'s own top
    // weld flange (world Z frame_z1-FLANGE_T..frame_z1 = 683-693mm, same
    // shared PARAMETERS both modules read) -- real 5mm acrylic at its
    // standard mounting depth would otherwise overlap the flange's front
    // face by 3.01mm. Stops e below the flange's own bottom edge (Rule M-1).
    acrylic_top_limit_z = (door_top_z - frame_inset - FLANGE_T - e) - hinge_z;  // 632.99mm local -- world 682.99mm

    // acrylic_pane_top_z: the pane's own REAL top, pulled down another 2mm+e
    // from acrylic_top_limit_z -- gives the acrylic a genuine top border
    // (same 2mm Global Clearance Tolerance convention as acrylic_x0/x1 on
    // left/right), instead of landing within 0.01mm of the window cutout's
    // own top edge. Without this gap, the pane's top edge and the cutout's
    // top edge (two different Y-depths, near-coincident Z) read as a double
    // line from any oblique angle -- see rules-dimensions.md "Acrylic/metal
    // split" history. The vacated band is filled by a visible metal border
    // piece below (mirrors the left/right border strips).
    acrylic_pane_top_z = acrylic_top_limit_z - 2 - e;  // 630.98mm local -- world 680.98mm

    // flap_cut_z1: the leaf's flap cutout must clear the flap's FULL swept
    // volume (0-55°), not just its closed-position footprint -- analytic
    // bound on the free corner's rotation radius about the top hinge line.
    flap_cut_z1 = flap_top_z + flap_t + e;    // 183.01mm local

    // acrylic_x0/x1: pulled IN from the window's own edges (win_x0/win_x1)
    // by the project's standard 2mm Global Clearance Tolerance (structural
    // face clearance, rules-dimensions.md), not overshooting outward --
    // tray_zone_frame()'s verticals sit exactly at win_x0/win_x1, so any
    // overshoot lands directly in their footprint. Vacated strips become
    // visible plain-metal borders (see acrylic_x0/x1 use below).
    acrylic_x0 = win_x0 + 2 + e;   // 29.01mm local
    acrylic_x1 = win_x1 - 2 - e;   // local

    // §2.4 -- curved flange: same center/radius as the shell's own actual
    // rounded interior corner (rounded_box(..., corner_r-1) in outer_shell()),
    // sampled live from corner_r/skin_t, not hardcoded. Center in local
    // coords = shell's world corner-curve center minus the hinge origin.
    arc_cx = (skin_t + (corner_r - 1)) - hinge_x;   // local X of shell's interior corner curve center
    arc_cy = (skin_t + (corner_r - 1)) - hinge_y;   // local Y of same
    arc_r_outer = corner_r - 1;                      // matches shell's interior fillet radius
    arc_r_inner = arc_r_outer - door_t;              // concentric, offset inward by wall thickness
    arc_segs = 12;                                   // >= 12 per spec

    outer_arc = arc_pts(arc_cx, arc_cy, arc_r_outer, 180, 270, arc_segs);
    inner_arc = arc_pts(arc_cx, arc_cy, arc_r_inner, 270, 180, arc_segs);

    door_poly = concat(
        [[door_x_offset, 0]],                                    // hinge line, top
        outer_arc,                                                // hinge line -> front face, following shell's rounded corner
        [[door_x_offset + door_w, front_y],                       // front-right corner
         [door_x_offset + door_w, front_y + door_t]],             // front-right, inner face
        inner_arc,                                                 // inner front face -> inner hinge line, following same curve
        [[door_x_offset + door_t, 0]]                             // inner hinge line, top
    );

    translate([hinge_x, hinge_y, hinge_z])
    rotate([0, 0, -door_open_angle]) {

        // Single-piece L-shaped leaf: return flange + front panel in ONE
        // linear_extrude() of a bent 2D cross-section, curved corner per
        // §2.4, with the window + exit-flap openings cut from it. True
        // manifold solid -- no gap/seam possible. Window hole spans only
        // the ACRYLIC zone (split_z_local..acrylic_top_limit_z-e); below
        // split_z_local and above acrylic_top_limit_z the leaf stays fully
        // solid (its own continuous door_t skin fills both the lower
        // flap-zone and the upper border, no separately-mounted patch
        // pieces). Flap cutout's own top extends to flap_cut_z1 so the
        // flap's full 0-55° swept volume clears the solid leaf material.
        color("#888888", 0.9)
        difference() {
            linear_extrude(height = door_h)
                polygon(door_poly);

            translate([win_x0, front_y - 1, split_z_local])
                cube([win_x1 - win_x0, door_t + 2, (acrylic_top_limit_z - e) - split_z_local]);

            translate([exit_x_local, front_y - 1, exit_bot_local])
                cube([exit_w, door_t + 2, flap_cut_z1 - exit_bot_local]);

            // Lock system PROVISION -- shallow recess only (lock_provision_d,
            // half of door_t, NOT a through-hole), right edge of the door
            // opposite the hinge. PLACEHOLDER -- see PARAMETERS block for
            // the full note and Janis-input flag.
            if (show_lock_provision)
                translate([lock_x0_local, front_y - e, lock_z0_local])
                    cube([lock_provision_w, lock_provision_d + e, lock_provision_h]);
        }

        // Hinge seam indicators -- pulled strictly INSIDE the flange body
        // (not touching its own hinge-line face) to avoid T-junction
        // contact. Concept placeholder only, NOT a protruding hinge barrel —
        // hinge hardware spec is an open item (rules-dimensions.md).
        for (pct = [0.1, 0.5, 0.9])
            color("#333333")
            translate([door_x_offset - e, -(hinge_mark_d + e), door_h*pct - hinge_mark_h/2])
                cube([door_t + e*2, hinge_mark_d, hinge_mark_h]);

        // Hinge-pivot reinforcement cylinder REMOVED (v57) -- a real hinge
        // is a mating pair of fixed/dynamic knuckles with real gaps, not
        // one continuous rod; full knuckle-hinge hardware is a separate,
        // deferred future task. The pivot POINT (hinge_x/hinge_y/hinge_z
        // above, this module's own translate/rotate origin) is unaffected
        // -- pure rotation math only, door_open/door_open_deg animation
        // unchanged. Locked reference: rules-dimensions.md.

        // Acrylic viewing pane -- mounted door_t further inside than the
        // door face, moves WITH the door leaf (gated on show_acrylic).
        // Split into an upper ACRYLIC portion (a) and, below split_z_local,
        // the leaf's own continuous metal skin (no separate lower panel).
        // Three pieces share show_acrylic:
        //   (a) upper acrylic pane (real door_acrylic_t depth; X pulled in
        //       to acrylic_x0/x1, clear of the frame's verticals; top at
        //       acrylic_pane_top_z, clear of the frame's top weld flange)
        //   (b)+(c) visible plain-metal border strips (left/right) filling
        //       the space between the window's own edge and the pulled-in
        //       acrylic -- epsilon-nudged clear of tray_zone_frame()'s
        //       verticals (Rule M-1)
        //   (e) top mounting border, same construction as (b)/(c), filling
        //       the band between the pane's real top and the window
        //       cutout's own top -- see acrylic_pane_top_z's own comment
        if (show_acrylic) {
            // (a) Upper acrylic pane.
            color("#ADD8E6", 0.3)
            translate([acrylic_x0, front_y + door_t, split_z_local])
                cube([acrylic_x1 - acrylic_x0, door_acrylic_t, acrylic_pane_top_z - split_z_local]);

            // (b)/(c) Left/right plain-metal border strips.
            color("#999999")
            translate([win_x0 + e, front_y + door_t, split_z_local])
                cube([(acrylic_x0 + e) - (win_x0 + e), door_t, acrylic_top_limit_z - split_z_local]);

            color("#999999")
            translate([acrylic_x1 - e, front_y + door_t, split_z_local])
                cube([(win_x1 - e) - (acrylic_x1 - e), door_t, acrylic_top_limit_z - split_z_local]);

            // (e) Top mounting border -- (b)/(c) already run the full
            // split_z_local..acrylic_top_limit_z height and cover the two
            // top corners; this piece closes the remaining gap across the
            // top, turning what was a near-coincident double edge into one
            // continuous metal-border-then-acrylic transition.
            color("#999999")
            translate([acrylic_x0, front_y + door_t, acrylic_pane_top_z - e])
                cube([acrylic_x1 - acrylic_x0, door_t, (acrylic_top_limit_z - e) - (acrylic_pane_top_z - e)]);
        }

        // Exit flap -- hinged at TOP, swings inward (+Y) toward
        // flap_open_deg. Independent show_flap toggle. Flap's own Y-range
        // (front_y..front_y+flap_t) matches the door's structural panel
        // plane exactly (flap_t==door_t numerically), no additional offset.
        if (show_flap)
            color("#B0B0B0", 0.9)
            translate([0, front_y, flap_top_z])
            rotate([flap_angle, 0, 0])
            translate([0, -front_y, -flap_top_z])
                translate([exit_x_local, front_y, exit_bot_local])
                    cube([exit_w, flap_t, exit_h]);
    }
}

// v42 TASK 2: static stopper rod for the exit flap — moved OUT of
// left_zone_door()'s door_open rotation (a stop that swings with the thing
// it's stopping isn't a stop). Fixed to the cabinet in world coordinates,
// matching the door's CLOSED-state geometry; stops the flap regardless of
// whether the main door is open or closed. No proximity switch/sensor
// geometry — explicitly deferred (Janis).
module flap_stopper_rod() {
    stop_y = skin_t + exit_h * sin(flap_open_deg);          // flap's fully-open Y position (world, door closed)
    stop_z = DATUM_FLAP_TOP - exit_h * cos(flap_open_deg);  // flap's fully-open Z position (world)

    color("#555555")
    translate([door_left_x, stop_y, stop_z])
        rotate([0, 90, 0])
            cylinder(d=hinge_od, h=door_right_x - door_left_x);
}

// H-frame: 2 full-height verticals (frame_bar wide) + 1 crossbar (10mm
// thick) at tray_0_z, + 10mm top/bottom weld flanges. Repositioned off the
// shell's REAL interior corner curve (world (skin_t+(corner_r-1),
// skin_t+(corner_r-1)) -- SAME formula as left_zone_door()'s arc_cx/arc_cy,
// independently re-derived since this module has no hinge-relative local
// origin). RIGHT vertical extends to genuine real contact with
// compartment_divider() (world X=product_w+e). LEFT vertical's outer curve
// radius is CAPPED at (corner_r-1)-frame_inset=14mm, NOT the full
// (corner_r-1)=19mm reach to the shell's own interior wall -- CONFIRMED
// via live CGAL bisection (re-verified v57) that any radius above
// ~15.96mm re-collides the door's own return-flange arc, which uses the
// IDENTICAL center and a 19mm outer radius by design (a snug closed fit
// against the shell) -- there is no radius that both touches the shell
// and clears the door at door_open_deg=0 (the tightest case). This cap is
// a real, non-negotiable geometric constraint, not an oversight -- do not
// grow frame_arc_r without re-running that same bisection. The curve's
// angle range stops at frame_y0 (a DECOUPLED fixed constant, 7mm, not
// re-derived from the curve's own endpoint) rather than the full 180-270°
// span.
module tray_zone_frame() {
    frame_z0 = door_bot_z + frame_inset;    // 55mm
    frame_z1 = door_top_z - frame_inset;    // 693mm
    frame_h  = frame_z1 - frame_z0;         // 638mm

    // Shell's real interior corner curve, WORLD coords -- same formula as
    // left_zone_door()'s arc_cx/arc_cy (this module has no hinge-relative
    // local origin, so no further offset is needed).
    world_arc_cx = skin_t + (corner_r - 1);      // 21mm
    world_arc_cy = skin_t + (corner_r - 1);      // 21mm
    frame_arc_r  = (corner_r - 1) - frame_inset; // 14mm -- v50: UNCHANGED from pre-v50 -- see module comment above (growing this re-collides the door, confirmed via live bisection; not a guess)
    frame_y0     = 7;                             // v50: DECOUPLED fixed constant -- see module comment above
    frame_depth  = skin_t;                        // 2mm

    left_bar_inner_x = door_left_x + frame_inset + frame_bar;  // 15mm -- still used by crossbar/flanges below

    // Left vertical is a genuine concentric double-arc band (outer_arc +
    // inner_arc, swept together, closed with straight RADIAL end
    // segments) -- same construction left_zone_door() uses for its own
    // curve, giving a single continuous curve into a clean vertical edge
    // (no C1 discontinuity/kink). Outer radius = frame_arc_r (14mm, the
    // proven max that clears the door). Inner radius = frame_arc_r-
    // frame_bar = 6mm. Both arcs sweep to y_stop_angle (270°, the angle
    // where the OUTER arc reaches frame_y0 exactly) -- the inner arc
    // can't physically reach frame_y0 at this radius, doesn't need to:
    // the radial end-cap segment closes the band the same way the door's
    // own front-face/inner-face closing segments do.
    inner_r = frame_arc_r - frame_bar;  // 6mm
    y_stop_angle = 180 + asin((world_arc_cy - frame_y0) / frame_arc_r);  // 270deg
    arc_segs = 24;

    // arc_pts() -- same helper left_zone_door() itself uses for its own
    // outer_arc/inner_arc. Outer forward (180->y_stop_angle), inner
    // REVERSED (y_stop_angle->180) so concat(outer, inner) traces a
    // closed loop directly, identical idiom to door_poly below.
    left_outer_arc = arc_pts(world_arc_cx, world_arc_cy, frame_arc_r, 180, y_stop_angle, arc_segs);
    left_inner_arc = arc_pts(world_arc_cx, world_arc_cy, inner_r, y_stop_angle, 180, arc_segs);

    // v50 TASK 2: right vertical extended to touch compartment_divider()
    // (starts at world X=product_w) instead of floating at the old inset
    // X1=door_right_x-frame_inset=409mm. Real contact: +e overlap.
    divider_touch_x  = product_w + e;                    // 416.01mm
    right_bar_inner_x = divider_touch_x - frame_bar;     // 408.01mm

    color("#AAAAAA")
    union() {
        // Left vertical bar -- curved outer edge wraps the corner where
        // the removed shell "pole" (v50 TASK 1) used to sit, now the sole
        // structural reinforcement there. Constant cross-section for the
        // full frame height (Z-invariant).
        translate([0, 0, frame_z0])
            linear_extrude(height = frame_h)
                polygon(concat(left_outer_arc, left_inner_arc));

        // Right vertical bar -- extended to touch compartment_divider()'s wall.
        translate([right_bar_inner_x, frame_y0, frame_z0])
            cube([divider_touch_x - right_bar_inner_x, frame_depth, frame_h]);

        // Crossbar -- 10mm thick (Z), spans left-to-right between the verticals, at tray_0_z
        translate([left_bar_inner_x, frame_y0, tray_0_z])
            cube([right_bar_inner_x - left_bar_inner_x, frame_depth, 10]);

        // Top + bottom weld flanges, 10mm each, for spot-welding to the
        // shell -- same 2D cross-section as the crossbar, within the
        // frame's existing frame_z0..frame_z1 range.
        translate([left_bar_inner_x, frame_y0, frame_z1 - FLANGE_T])
            cube([right_bar_inner_x - left_bar_inner_x, frame_depth, FLANGE_T]);
        translate([left_bar_inner_x, frame_y0, frame_z0])
            cube([right_bar_inner_x - left_bar_inner_x, frame_depth, FLANGE_T]);
    }
}

// Parallel sensor strips -- left and right walls, just below the ACTUAL
// tray 0 floor (2 independent pieces, no connecting center beam -- that
// was never part of the real design). `show_sensor` gates both. Z
// references the shared `sensor_strip_z0`/`sensor_strip_h` datum (DATUMS
// block), not a locally re-derived copy -- keeps this module and
// `drop_zone_guards()` in sync.
module sensor_strip() {
    strip_z = sensor_strip_z0;
    strip_t = 5;
    strip_h = sensor_strip_h;

    // Nudged e inward from the shell's interior left/right walls (kills a
    // coplanar-face condition).
    strip_x0 = skin_t + e;                        // left strip left edge
    strip_x1 = product_w - skin_t - strip_t - e;   // right strip left edge

    // Front (Y) edge: HINGE_Y_OFFSET+e -- confirmed the door polygon's
    // global maximum Y at ANY X (the left strip's own X range overlaps
    // the door's hinge-line flange face, which reaches further than
    // drop_zone_guards()'s own clearance value, so that value alone is
    // insufficient here). Clears the leaf at every angle.
    strip_y0 = HINGE_Y_OFFSET + e;          // 25.01mm
    strip_y1 = skin_t + drop_zone_d;        // 140mm -- rear edge

    if (show_sensor) {
        color("#222222")
        translate([strip_x0, strip_y0, strip_z])
            cube([strip_t, strip_y1 - strip_y0, strip_h]);

        color("#222222")
        translate([strip_x1, strip_y0, strip_z])
            cube([strip_t, strip_y1 - strip_y0, strip_h]);
    }
}

// ATM dashboard — right compartment.
// screen_y = -30mm (protrudes 30mm forward of front face).
module dashboard() {
    screen_z = screen_center_z - screen_h/2;  // 230mm
    qr_z     = screen_z - 50 - qr_h;          // 150mm
    card_z   = qr_z - 30 - card_h;            // 112mm
    speaker_z = card_z - 20 - speaker_h;       // 72mm

    // Screen — protrudes forward (screen_y = -30mm)
    color("#1A1A1A")
    translate([product_w + divider_t + 10, screen_y, screen_z])
        rotate([-30, 0, 0])
            cube([screen_w, 5, screen_h]);

    // Screen bezel
    color("#333333", 0.8)
    translate([product_w + divider_t + 10 - bezel_t,
               screen_y - 2, screen_z - bezel_t])
        rotate([-30, 0, 0])
            cube([screen_w + (bezel_t*2), 3, screen_h + (bezel_t*2)]);

    // Support bracket — flat crossbar cube (replaced hull+rotated cylinders, non-manifold risk)
    color("#444444")
    translate([dash_x + dash_w/2 - screen_w/2, screen_y, screen_z - bracket_r])
        cube([screen_w, 30, bracket_r * 2]);

    // QR scanner
    color("#222222")
    translate([dash_x + (dash_w - qr_w)/2, 0, qr_z])
        cube([qr_w, qr_d, qr_h]);

    // ID card reader
    color("#333333")
    translate([dash_x + (dash_w - card_w)/2, 0, card_z])
        cube([card_w, card_d, card_h]);

    // Speaker grille — 5 slots
    slot_h = 2;
    slot_gap = 2;
    color("#444444")
    for (s = [0:speaker_slots-1]) {
        translate([dash_x + (dash_w - speaker_w)/2, 0,
                   speaker_z + s*(slot_h + slot_gap)])
            cube([speaker_w, 3, slot_h]);
    }
}

// Acrylic display — 3 faces of right compartment, Z 542-698.
module acrylic_display() {
    acrylic_front_w = system_w - divider_t - skin_t;
    acrylic_front_x = product_w + divider_t;

    color("#ADD8E6", 0.3)
    translate([acrylic_front_x, e, acrylic_bot_z])
        cube([acrylic_front_w, door_t, acrylic_zone_h]);

    // FIXED v39: recessed to corner_r on both Y ends — was skin_t, which put
    // the panel inside the shell's rounded-corner region (front AND rear),
    // causing a 7.28mm protrusion past the curved wall at the front corner.
    // Panel now starts/ends exactly where the shell wall goes flat.
    color("#ADD8E6", 0.3)
    translate([total_w - (skin_t*2), corner_r, acrylic_bot_z])
        cube([skin_t, total_d - (corner_r*2), acrylic_zone_h]);

    color("#ADD8E6", 0.3)
    translate([acrylic_front_x, skin_t, total_h - (skin_t*2)])
        cube([acrylic_front_w, total_d-(skin_t*2), skin_t]);
}

// Solid opaque hand-safety side guards (left/right, constant X, spanning
// Y-Z) at the drop zone -- the only genuine safety function of the old
// drop_zone_visual() box (its top/bottom/front/back ghost faces blocked
// the actual product drop path and were removed entirely).
// LEFT guard clears left_zone_door()'s return flange (world X 2-5mm):
// X0 = skin_t+door_t+e = 5.01mm. RIGHT guard (no hinge on this side) is
// placed symmetric to the old box's right face, X1 = 411.99mm.
// Front-most Y (guard_y0 = HINGE_Y_OFFSET+skin_t = 27mm) is the door
// polygon's global maximum Y at any X -- clears both the door's curved
// return-flange arc AND its inner hinge-line straight segment (two
// different door surfaces, both real touch risks at a smaller value).
// Height covers whichever is taller, the shell's exit-chute flank
// (exit_door_h) or the sensor strip's own top (shared sensor_strip_z0/
// sensor_strip_h datum, DATUMS block -- same value sensor_strip() reads,
// not a second independently-derived copy) -- one continuous rail.
// Safety-critical, always on (see PART_MANIFEST.md).
module drop_zone_guards() {
    guard_y0 = HINGE_Y_OFFSET + skin_t;        // 27mm
    guard_y1 = skin_t + e + drop_zone_d;       // 140.01mm -- rear edge
    guard_depth = guard_y1 - guard_y0;          // 113mm
    guard_h = max(exit_door_h, (sensor_strip_z0 + sensor_strip_h) - leg_h); // 308mm

    color("#DDDDDD")
    translate([skin_t + door_t + e, guard_y0, leg_h])
        cube([skin_t, guard_depth, guard_h]);

    color("#DDDDDD")
    translate([product_w - skin_t - skin_t - e, guard_y0, leg_h])
        cube([skin_t, guard_depth, guard_h]);
}

module rear_service_door() {
    door_w = system_w - divider_t;
    door_h = total_h * 0.5;
    color("#B8B8B8", 0.6)
    translate([product_w + divider_t, total_d - skin_t, leg_h + (total_h*0.25)])
        cube([door_w, skin_t*2, door_h]);
}

// ─────────────────────────────
// DIAGNOSTIC TOOLS — on-demand only, never called from ASSEMBLY
// ─────────────────────────────
// v53 (vm01-clearance-zone-map-skill-and-application): targeted clearance
// color map for a named suspect pair. See .claude/SKILL_clearance_zone_map.md
// for the full procedure, band definitions, and the OpenSCAD children()
// idiom this uses instead of the unsupported "pass a module as a value"
// pattern. NOT wired into ASSEMBLY — invoke only via a scratch include
// during active diagnosis, per that skill file's own "Do NOT" list.
module clearance_zone_map(bands=[[0,"red"],[0.5,"orange"],[2,"yellow"]]) {
    // children(0) = part A (the one that gets inflated), children(1) = part B
    for (b = bands) {
        offset = b[0]; col = b[1];
        color(col, 0.85)
        intersection() {
            if (offset == 0) {
                children(0);   // sphere(r=0) is degenerate -- skip minkowski at 0mm
            } else {
                minkowski() {
                    children(0);
                    sphere(r=offset, $fn=16);   // low $fn -- diagnostic inflation, not final geometry
                }
            }
            children(1);
        }
    }
}

// ─────────────────────────────
// ─────────────────────────────
// RENDER MODE — set before export
// ─────────────────────────────
// "standard" → STANDARD: shell intact, acrylic panels removed → see through window → VM-01-v38-std.stl
// "full"     → FULL EXTERIOR: everything including acrylic (fully opaque) → VM-01-v38-full.stl
// "open"     → OPEN/C2: set show_shell_top/left=false below for inspection → VM-01-v38-C2.stl
render_mode = "standard";

// DEBUG TOGGLES — used in "open" (C2) mode to remove shell panels
// ─────────────────────────────
show_shell_back   = true;
show_shell_top    = true;   // set false for C2 export
show_shell_bottom = true;   // set false for C2 export -- NEW v51 TASK 2
show_shell_left   = true;   // set false for C2 export
show_shell_right  = true;

// VIEWER TOGGLES (v41) — for multi-state STL export
// ─────────────────────────────
door_open    = false;   // true -> left_zone_door() leaf swung open (door_open_deg) for viewer STL
flap_open    = false;   // true -> exit flap swung open (flap_open_deg) for viewer STL
tray_out_pct = 0;        // 0-1, e.g. 0.3 -> tray slid 30% of tray_d out the front

// ISOLATION TOGGLES (v42/v44/v45) — for manifold-debug inspection
// ─────────────────────────────
show_door    = true;   // false -> hide left_zone_door() entirely, for inspecting the shell's left-wall cutout underneath
show_acrylic = true;   // false -> hide the acrylic pane independent of render_mode (v44: no longer render_mode-gated, see TASK 2)
show_flap    = true;   // false -> hide the exit flap independent of show_door
show_sensor  = true;   // v44 TASK 1: false -> hide both real sensor strips (fabricated center beam removed entirely, not toggled)
show_frame   = true;   // v45: false -> hide tray_zone_frame() entirely, for inspecting/isolating the H-frame independent of the door and shell (Toggle-Completeness Rule, cc_rules.md)
show_lock_provision = true;   // v57: false -> hide the lock-system PLACEHOLDER recesses (door leaf + compartment_divider() strike), for inspecting the door/divider independent of this reservation

// ─────────────────────────────
// ASSEMBLY
// ─────────────────────────────

legs();

// Outer shell — shown in all modes (show_shell_* toggles control which panels visible)
translate([0, 0, leg_h]) outer_shell();

compartment_divider();

tray_rack();
for (t = [0:tray_count-1]) spring_tray(t);

// Acrylic panels — only in "full" mode (removing them = see-through window effect)
// left_zone_door()'s inset acrylic window (v44: gated on show_acrylic alone, see TASK 2 — no longer tied to render_mode)
if (render_mode == "full") {
    acrylic_display();      // acrylic right upper zone (unrelated part, unchanged)
}

if (show_door) left_zone_door();  // v42: full-height left-zone door — isolable via show_door
flap_stopper_rod();               // v42: static, always visible regardless of show_door/show_flap
if (show_frame) tray_zone_frame();  // v45: isolable via show_frame — structural frame
drop_zone_guards();     // v43 §2.6: real solid side guards, replaces drop_zone_visual()
tray_compartment_partition();  // v46 TASK 1: fixed/welded, safety-critical (PART_MANIFEST.md) — always on
exit_compartment_wall();       // v46 TASK 1: fixed/welded, safety-critical (PART_MANIFEST.md) — always on

sensor_strip();         // parallel strips at Z=280

dashboard();            // screen + QR + card reader
rear_service_door();
