// PR-01-assembly-v28.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v28 — bed_w 670→840 (bed-width-720-crossbar-gap): sets crossbar
// gap (xbar_y_rear - xbar_y_front) = 720mm with leg_t=120 unchanged. Formula:
// bed_w = 720 + leg_t. Single dimensional change, no other line touched —
// diffed against v27 to confirm. Source: PR-01-assembly-v27.scad.
// Previous header, v27 — ghost-leak fix + toggle-block relocation
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
socket_od     = 60;
socket_depth  = 20;
socket_bore_d = pin_d + 0.5;

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

// ── Modules (all definitions live in pole_top.scad, flat — no subfolder) ──
include <pole_top.scad>

// ── Debug toggles — flip to false to hide for visual inspection ────────
show_bed           = true;
show_pole_tops     = true;
show_pole_bodies   = true;
show_base_collars  = true;
show_wood_sockets  = true;
show_crossbars     = true;

// ── RENDER — full assembly ───────────────────────────────────────────
pr01_assembly();
