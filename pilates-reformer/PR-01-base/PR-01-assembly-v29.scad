// PR-01-assembly-v29.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v29 — pole-base-bell-collar-socket-build (2026-07-02): FIRST
// production geometry pass on pole holder/socket. Adds bell_lock_collar()
// (pole_top.scad, REVISED CONFIRMED dome profile + ENGINEER-PROPOSED
// thread/bayonet lock mechanism) and leg_socket() (new leg_socket.scad,
// CONFIRMED embedded pass-through socket sleeve, first-time lock).
// Replaces the old external split-clamp collar concept (pole_base_collar()
// call site commented out in pole_top.scad, module kept for history).
// bed_w=840, leg_t=120, xbar_y_front=60, xbar_y_rear=780 all UNCHANGED
// from v28 (verify via diff) — new globals only, no dimensional change to
// existing bed/pole/crossbar geometry. Source: PR-01-assembly-v28.scad.
// Previous header, v28 — bed_w 670→840 (bed-width-720-crossbar-gap), and
// before that v27 — ghost-leak fix + toggle-block relocation
// (PR-01-fix-ghost-leak-toggle-relocate-v27). Ghost-leak fix itself is an
// in-place edit to pole_top.scad (not individually versioned, per the
// established modules-file exception) — see that file's header. This file
// only carries Task 2: the 6 show_* debug toggles moved from the
// PARAMETERS block down to immediately before the final pr01_assembly()
// render call, per Janis's established working pattern. Same 6 names,
// same default values (true), no other content change anywhere else in
// the file — identical to v26 except this relocation (diffed to confirm).
// Source: PR-01-assembly-v26.scad. Module bodies live in pole_top.scad,
// flat (no subfolder) — see PR-01-flatten-modules-v26.
//
// Ordering note: globals are declared BEFORE the include (not after, as a
// literal top-to-bottom reading of the split prompt might suggest), per
// .claude/rules-codes.md's existing rule "globals first, derived values
// second, modules third, assembly last." This also means pole_top.scad's
// ghost-context stanza (which runs immediately on include) never
// references an undeclared global, even if $is_assembly is later toggled
// false in this same file for isolated-render iteration.
//
// Date: 2026-07-02
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md
//
// CONCEPT LOCK: mudguard/camber collar shape confirmed 2026-07-01 via local
// render (Claude Web sandbox). Concept is locked — no revert to bell/horn.
// DO NOT add wedge, cam, friction sleeve, or any mechanism geometry without
// explicit Janis written approval in chat.
//
// OPTION B (unified neck+collar loft) is CONFIRMED required before casting
// but explicitly DEFERRED this session — see .claude/SKILL_option_b_unified_loft.md.
// Read that file in full before touching pole_top seam/joint geometry.

// Suppress pole_top.scad's ghost-context stand-ins for full-assembly
// render — full assembly shows only real parts.
$is_assembly = true;

// ── Global ────────────────────────────────────────────────────────────
e           = 0.01;   // epsilon — z-fight prevention
$fn         = 32;     // default resolution (use 64 for final render)

// ── Bed dimensions ────────────────────────────────────────────────────
bed_l       = 2300;   // total bed length (longitudinal) — PENDING Janis confirm
bed_w       = 840;    // total bed width — Janis-confirmed 2026-07-02, sets
                       // crossbar gap (xbar_y_rear - xbar_y_front) = 720mm
                       // with leg_t=120 unchanged. Formula: bed_w = 720 + leg_t.
bed_h       = 500;    // floor to top of bed surface — PENDING Janis confirm
leg_w       = 180;    // bed leg width — unchanged from v6
leg_t       = 120;    // bed leg depth — unchanged from v6
frame_rail_t = 60;    // bed rail thickness (wood) — PENDING
frame_rail_h = 120;   // bed rail height — PENDING

// ── Pole body — constant D-profile, NO TAPER (rules-dimensions.md v6, PR-01) ──
pole_d        = 40;   // body diameter (pole_od) — Janis-approved v15
pole_r        = pole_d / 2;
pole_h        = 1600;  // exposed pole height above bed surface — PENDING

// ── Pole TOP — mudguard/camber housing (concept10, concept-locked 2026-07-01) ──
// Housing: asymmetric camber cross-section (large r_top / near-flat r_bot),
// multi-step loft along X-axis. Neck: straight D-profile sleeve over pole_body().
// Lever: Stage 2 placeholder only — no mechanism geometry.
neck_h         = 70;    // retained from v20 — concept10's 50mm fails 15mm bolt-edge rule:
                         // bolts at 35mm and 55mm → min edge gap = 15mm exactly at bottom ✓
neck_wall_t    = 3;     // wall thickness per side
neck_id        = pole_d + 1;           // = 41mm — slip-fit clearance over pole_od (0.5mm/side)
neck_od        = neck_id + 2 * neck_wall_t;  // = 47mm — retained; concept10's 44mm gives 1.5mm wall < 2mm min
neck_bolt_d    = 6.5;   // M6 through-bolt clearance hole diameter
top_bore_d     = 32;    // TBD — 32mm pipe clearance pending physical multi-pipe OD measurement

// ── Housing geometry (concept10 mudguard/camber cross-section) ────────
housing_len         = 104;   // total length along X-axis (pole-to-pipe span)
housing_r_circ      = 19;    // base circular radius (constant fore/aft symmetry)
housing_camber_rise = 16;    // additional camber rise at top peak (r_top_max = 35mm)
housing_peak_t      = 0.60;  // v23: flipped — fat face now points INWARD toward bar center.
                              // 0.40 placed peak outward (-10.4mm from cx); 0.60 places it
                              // inward (+10.4mm from cx) for both dir=+1 and dir=-1 poles.
housing_bump_w      = 0.55;  // bump half-width (smooth_bump C2 kernel)
housing_steps       = 60;    // loft slices — more = smoother
housing_neck_t      = 0.50;  // position of neck bottom-bulge peak along housing length
housing_bulge_rise  = 5;     // bottom bulge rise at neck connection zone
housing_bulge_w     = 0.18;  // bottom bulge half-width

// ── Pole BASE COLLAR — split-clamp sleeve (Stage 2 = precision fit) ────
collar_wrap_h       = 120;
collar_wall_t       = 8;
collar_bolt_d       = 4;
collar_bolt_boss_d  = 10;
collar_id           = pole_d + 1;
collar_od           = collar_id + 2 * collar_wall_t;
collar_z0           = bed_h - collar_wrap_h / 2;
pin_d               = 16;
pin_h               = 18;

// ── Pole WOOD SOCKET ──────────────────────────────────────────────────
// NOTE: still called (pole_wood_socket(), show_wood_sockets) alongside the
// new leg_socket() below — a likely redundancy now that leg_socket()
// exists, NOT retired by this prompt (only the split-clamp collar
// retirement was explicitly requested) — flagged in cc_chat_log.
socket_od     = 60;
socket_depth  = 20;
socket_bore_d = pin_d + 0.5;

// ── Bell Lock Collar — REVISED CONFIRMED via Customizer screenshot,
// 2026-07-02 (bell_holder_customizer.scad). Supersedes the earlier
// r_top=29/curve_power=1.4 rules-dimensions.md table entry. ───────────
r_base           = 51;    // foot ring radius, flush at wood surface (leg_socket.scad leg top)
r_top            = 25;    // neck radius, meets washer/cap
foot_h           = 8;     // straight vertical foot ring height
dome_h           = 35;    // curved dome height
dome_steps       = 16;    // loft resolution
curve_power      = 2.2;   // profile exponent: 1=straight cone, >1=convex bulge, <1=concave converge
cap_h            = 12;    // knurled brass cap height
cap_knurl_count  = 45;    // knurl notch count
washer_h         = 5;     // copper washer reveal height
washer_overhang  = 4;     // copper washer reveal radial overhang beyond dome top
// pole_od (bell dome table) = pole_d above (40mm, LOCKED) — reused directly,
// not redeclared under a second name.

// ── Lock Mechanism — ENGINEER-PROPOSED (Claude Web, market-standard
// practice), NOT Janis-measured, NOT physically validated, 2026-07-02.
// See bell_thread()/bell_bayonet() in pole_top.scad for the disclaimer
// comment required verbatim at the geometry site. ─────────────────────
thread_pitch              = 3;    // single-start, mm
thread_depth               = 1.5;  // radial depth, mm
thread_engagement_l        = 8;    // of cap_h's 12mm total — remaining ~4mm proud as knurled grip
bayonet_lug_count          = 3;    // lugs, 120° spacing
bayonet_lug_w              = 5;    // lug width, mm
bayonet_engagement_depth   = 3;    // mm
bayonet_rotation           = 30;   // degrees to lock (documented spec — not a static geometry driver)

// ── Socket/Leg Architecture — CONFIRMED via Customizer screenshot,
// first-time lock, 2026-07-02 (pole_top_housing_customizer leg/bed panel).
// leg_socket_od/leg_socket_wall_t/leg_socket_depth deliberately NOT named
// socket_od/socket_depth — see leg_socket.scad header for why. ────────
leg_h              = 600;   // NEW leg's own full height (see leg_socket.scad INTERPRETATION FLAG)
pad_t              = 20;    // foot pad thickness
pad_overhang       = 50;    // foot pad radial overhang beyond leg footprint
leg_socket_depth   = 400;   // pass-through sleeve depth, replaces old shallow bonded pocket
leg_socket_od      = 46;
leg_socket_wall_t  = 2.5;
// leg_socket_id = leg_socket_od - 2*leg_socket_wall_t = 41mm (derived in leg_socket.scad)
// Radial clearance vs pole_d(40mm) = 0.5mm — tight tolerance, not a
// blocker, flagged for print/fit tolerance awareness.

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED
grip_l      = bed_l - leg_w;
grip_offset = 0;

// ── Derived ───────────────────────────────────────────────────────────
surface_t   = 30;

pole_cx = [leg_w/2, bed_l - leg_w/2, leg_w/2, bed_l - leg_w/2];
pole_cy = [leg_t/2, leg_t/2, bed_w - leg_t/2, bed_w - leg_t/2];

xbar_y_front = pole_cy[0];
xbar_y_rear  = pole_cy[2];

// v21: xbar_z derived from housing geometry — camber top lands exactly at bed_h+pole_h
// housing_r_circ=19, housing_camber_rise=16 → r_top_peak=35
// xbar_z + r_top_peak = bed_h + pole_h → xbar_z = 2100 - 35 = 2065  ✓
xbar_z = bed_h + pole_h - housing_r_circ - housing_camber_rise;  // = 2065mm

// ── Modules (all definitions live in pole_top.scad / leg_socket.scad,
// flat — no subfolder) ──────────────────────────────────────────────
include <pole_top.scad>
include <leg_socket.scad>

// ── Debug toggles — flip to false to hide for visual inspection ────────
show_bed           = true;
show_pole_tops     = true;
show_pole_bodies   = true;
show_base_collars  = true;   // pole_base_collar() call site is retired (commented out) — toggle now inert, kept for symmetry
show_wood_sockets  = true;
show_crossbars     = true;
show_bell_collars  = true;
show_leg_sockets   = true;

// ── RENDER — full assembly ───────────────────────────────────────────
pr01_assembly();

// Bell lock collar + leg socket — top-level includer instantiation only
// (TASK 3 scope), per-pole loop mirroring pole_assembly()'s existing
// pattern. Kept out of pole_top.scad's pole_assembly() itself since
// leg_socket() is defined in a separate included file.
for (i = [0 : 3]) {
    if (show_bell_collars) bell_lock_collar(pole_cx[i], pole_cy[i]);
    if (show_leg_sockets)  leg_socket(pole_cx[i], pole_cy[i]);
}
