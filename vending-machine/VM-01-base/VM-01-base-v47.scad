// VM-01 Base Vending Machine
// Janis Product Design
// Version: v47
// Date: 2026-07-05
// Units: mm
// Purpose: Smart donation vending machine — buddha ornaments
// Payment: Online only, no cash/coin mechanism
//
// Changes from v46 (VM-01-partition-depth-door-collision-fix — 2 confirmed
// manifold problems, Janis root-caused both, no diagnosis needed):
//   PROBLEM 1: tray_compartment_partition() (v46) reached all the way to
//     the front of the compartment, physically overlapping
//     tray_zone_frame() -- present regardless of door state (2 fixed
//     parts). Functional requirement, not just clearance: the partition
//     must stop short of the front so a dropped item keeps falling
//     through the compartment's front opening instead of landing on top
//     of the partition and getting stuck. Fixed: partition's front (Y)
//     edge moved from skin_t (2mm) to tray_start_d + (tray_d-motor_d-2)
//     (526mm world) -- the SAME expression spring_coil() already uses for
//     its own rearward extent (effectively spring_l-2), not a new magic
//     number. Rear edge (598mm) unchanged. This leaves the spring's own
//     operative/product-drop length (world Y 138-526) entirely open, and
//     the region actually needing the partition (526-598, under the motor
//     /rear structure) covered. Re-verified: intersection() vs
//     tray_zone_frame() now empty by construction (505mm gap).
//   PROBLEM 2: drop_zone_guards() (v43) poked through the door's own
//     surface plane at closed position (door_open_deg=0) -- confirmed by
//     Janis via direct visual render inspection, root cause not the hinge
//     geometry or frame inset. Janis's suggested formula ("frame's front
//     face minus material thickness") and explicit flat-10mm fallback
//     were BOTH checked against live geometry (Python/shapely) and BOTH
//     found insufficient -- the hinge-side guard sits close enough to the
//     door's curved flange (which reaches up to world Y=21 there) that
//     10mm of pullback still left a confirmed 7.6mm² overlap at
//     door_open_deg=0. Verified fix instead: guard's front-most Y raised
//     to world_arc_cy+e (21.01mm) -- the SAME shell-interior-corner-curve
//     constant already used identically by both left_zone_door() and
//     tray_zone_frame() (skin_t+(corner_r-1)), not a new invented number.
//     Confirmed empty at all 9 mandated angles + a fine 0.5° sweep.
//   tray_zone_frame(), hinge geometry, and the shell's hinge recess cutout
//     confirmed UNTOUCHED (not the cause of either problem).
//
// NAMING NOTE: prompts/VM-01-tray-access-acrylic-split-flange-v45.md said
// "save as VM-01-base-v45.scad" -- that name was already taken (the prior
// governance-batch prompt shipped v45 first, merged before this prompt was
// uploaded). Built on the REAL latest file (v45, = v44 + show_frame
// toggle, zero geometry change) and saved as v46 instead, per "never
// overwrite, always increment version." Flagged explicitly, not silently
// resolved -- see cc_chat_log.md.
//
// Changes from v45 (VM-01-tray-access-acrylic-split-flange — 3 fixes):
//   TASK 1 (tray compartment access gap): entire spring tray stack shifted
//     UP 100mm (TRAY_SHIFT_UP) from tray_0_z (270, UNCHANGED baseline) to
//     tray_stack_z0 (370) -- spring_tray()/tray_rack() now reference
//     tray_stack_z0, not tray_0_z. Only tray_count=2 exists in source (no
//     3-row/"3x5" variant to shift separately -- confirmed, not guessed).
//     New tray_compartment_partition() (fixed/welded, full compartment
//     width+depth) seals the vacated space at the OLD tray_0_z=270
//     baseline -- the anchor the trays moved away from. New
//     exit_compartment_wall() (NEW module -- no existing module literally
//     matched "vertical partition/side bracket that holds the flap
//     stopper", see cc_chat_log for reasoning) seals the Y-direction
//     reach-through at Y=drop_zone_d, floor to the partition, zero gap
//     (e-overlap). Top-tray clearance vs the physical roofline/door
//     boundary: +86/+88mm, positive. vs the OLD (untouched) DATUM_TRAY_TOP
//     tray-zone/upper-display divide (512mm, tautologically defined as
//     tray_0_z+tray_zone_h, itself never an independent physical ceiling):
//     -100mm -- flagged explicitly as a stale zone-label question for
//     Claude Web/Janis, NOT a real 3D collision (nothing physical occupies
//     that Z range on the left side).
//   TASK 2 (acrylic/metal split): door's single acrylic pane split into an
//     upper acrylic portion (unchanged top boundary) and a lower plain
//     metal panel, meeting at a LIVE reference to tray_stack_z0 (not a
//     duplicated magic number) -- the post-shift lowest-tray-floor Z.
//     Both pieces share the existing show_acrylic gate (v44 Finding B fix
//     untouched).
//   TASK 3 (H-frame flange): tray_zone_frame() gets 10mm top + 10mm bottom
//     flanges for spot-welding to the shell -- built from the SAME 2D
//     cross-section as the already-verified crossbar, placed WITHIN the
//     frame's existing (already door-clearance-verified) Z range, so no
//     new Z-boundary risk.
//   TASK 4: full 9-angle CGAL-equivalent collision sweep (Python/shapely)
//     re-run against the updated frame (incl. flanges) -- ALL EMPTY, plus
//     a fine 0.5° sweep, worst-case area 0.0.
//   DO NOT TOUCH (v44 QA-passed work, confirmed unchanged): sensor
//     deletion, acrylic render_mode toggle logic, H-frame curved/inset
//     left edge, door window resize, hinge datum logic.
//
// Changes from v44 (VM-01-governance-batch-post-v44 — TASK 3, toggle-wiring
// only, ZERO geometry change): added `show_frame` isolation toggle,
// gating tray_zone_frame() in ASSEMBLY — v44 shipped the H-frame rebuild
// with no toggle at all, the exact gap that let the old wrong-referenced
// frame go unnoticed for ~10 versions (new Toggle-Completeness Rule,
// cc_rules.md). Frame's shape/position/curve/dimensions untouched.
//
// Changes from v43 (VM-01-frame-window-rebuild-v44 — real-render QA, 6 findings):
//   Finding A: sensor_strip() had a fabricated red center-beam cube
//     spanning the gap between its 2 real strips -- Janis-confirmed never
//     part of the actual design. DELETED entirely (not toggled). New
//     `show_sensor` isolation toggle gates the 2 real strips.
//   Finding B: left_zone_door()'s acrylic pane was gated on
//     `render_mode=="full" && show_acrylic` -- inconsistent with its
//     siblings (show_door/show_flap aren't render_mode-gated), and since
//     render_mode defaults to "standard" the acrylic could never render
//     regardless of show_acrylic. Now gated on `show_acrylic` alone.
//     acrylic_display() (right compartment, unrelated part) untouched.
//   Finding C: tray_zone_frame() anchored every bar at world X=0/Y=0 (the
//     shell's theoretical SHARP EXTERIOR corner), never accounting for
//     skin_t/corner_r -- visually sat at/outside the shell's real interior
//     wall. SEPARATELY confirmed via CGAL boolean intersection (9-angle
//     sweep vs left_zone_door()): the old frame's bars physically clipped
//     the door leaf for door_open_deg 0-30. Full rebuild, H-shape (2
//     full-height verticals + 1 crossbar at tray_0_z, replaces the old
//     top+bottom+short-side-bar layout), repositioned off the shell's real
//     interior corner curve (same formula as left_zone_door()'s
//     arc_cx/arc_cy), left vertical's outer edge curved to match the
//     door's own flange arc (same center/radius, pulled back by the same
//     5mm inset for door clearance). Re-verified (Python/shapely, mirrors
//     the CGAL test) at all 9 mandated angles + a fine 0.5° sweep: ZERO
//     collision across the full 0-100° door_open_deg range.
//   Window/acrylic (Janis spec): resized to match the new H-frame's inner
//     clear opening -- window_x0/window_z0/window_w/window_h updated (was
//     the old tray-zone-only slice), acrylic resizes automatically via the
//     same formula (unchanged), giving a full view of the whole
//     compartment. Superseded v43 frozen values kept in rules-dimensions.md
//     for history.
//   Door-scoped Skeleton exception (v43) extended to cover this round's
//     tray_zone_frame() rebuild too -- still no other BOM item touched.
//
// Changes from v42 (VM-01-door-datum-rebuild-v43 — FRONT DOOR ASSEMBLY ONLY):
// GOVERNANCE NOTE: .claude/SKILL_product_design_skeleton.md grandfathers
// VM-01 out of the new Skeleton/Datum-Reference-Frame system. This is a
// Janis-approved, door-scoped EXCEPTION to that clause — the corrected
// datum logic below applies to the front door assembly only (left_zone_door,
// its shell recess pocket, drop_zone_visual). No other BOM item touched.
//   1. FOOT_BASE_H added as its own explicit named constant (was silently
//      folded into DATUM_LEG_TOP = leg_h) — door's Z-stack now shows it as
//      an explicit added term (door_bot_z = FOOT_BASE_H + 0).
//   2. Hinge center is now THE datum for the entire door assembly, world
//      coords: Z = FOOT_BASE_H + 0; Y = HINGE_Y_OFFSET (25mm, fixed
//      independent constant, measured from the shell's theoretical SHARP
//      corner — NOT corner_r+5 anymore, decoupled so retuning corner_r
//      later is a separate clearance check, not an input); X = 0 -
//      (hinge_od/2) — barrel exposed on the exterior, proud of the shell's
//      exterior wall face. left_zone_door() and outer_shell()/
//      outer_shell_debug()'s recess-pocket cutout each independently
//      re-derive this SAME point from shared named constants
//      (HINGE_Y_OFFSET/hinge_od/FOOT_BASE_H) — neither reads the other's
//      local variables. See commit message for the side-by-side numbers.
//   3. Window/acrylic frozen as the door's OWN local constants
//      (window_x0=38/window_z0=220/window_w=336/window_h=242) — numerically
//      identical to v42's DATUM_TRAY_BOT/TOP-derived values, but no longer
//      named/derived as if the window depended on the tray zone (Cousin
//      reference removed; the window is the door's own feature).
//   4. Curved flange: the flange/trim polygon's hard 90° bend replaced with
//      a 12-segment arc following the shell's actual rounded corner,
//      derived live from corner_r/skin_t (same center/radius as the shell's
//      own interior corner curve: center (skin_t+(corner_r-1), skin_t+
//      (corner_r-1)), radius corner_r-1).
//   5. Epsilon fixes (e=0.01) on 3 confirmed flush-coplanar-face root
//      causes: left_zone_door() front face (was flush at world Y=skin_t),
//      sensor_strip() both strips (were flush at X=skin_t), drop_zone_
//      guards() (new module, see #6).
//   6. drop_zone_visual() replaced by drop_zone_guards(): the 4 ghost faces
//      that blocked the actual product drop path (top/bottom/front/back)
//      removed entirely; the 2 side faces (genuine hand-access safety
//      guard) kept and rebuilt as solid 2mm panels, not translucent. Left
//      guard placed clear of the door's new hinge/flange footprint
//      (X 2-5mm, Y 2-25mm) — see contact-receipt comment at the module.
//   DEFERRED (Janis, not built this round): partition + back door for
//   spare storage under the trays — TODO comment added near spring_tray()/
//   tray_rack(), no geometry added.
//
// Changes from v41 (VM-01-door-fixes-v42 — 6 issues from Janis's v41 QA):
//   1. left_zone_door() rebuilt: the return flange + main panel were two
//      disconnected cubes (20mm gap, X 5-25) — replaced with ONE
//      linear_extrude() of a single bent L-shaped polygon. True single-
//      piece manifold solid, no seam/gap possible.
//   2. New left-side-wall recess cutout in outer_shell_debug()/outer_shell()
//      so the return flange/hinge line has a real pocket to sit in.
//   3. Stopper rod moved OUT of left_zone_door()'s door_open rotation into
//      its own static module, flap_stopper_rod() — a stop that swings with
//      the thing it's stopping isn't a stop. Acrylic pane correctly stays
//      inside the rotation (it should move with the door).
//   4. New isolation toggles: show_door, show_acrylic, show_flap.
//   5. Acrylic/window framing asymmetry was a side effect of issue #1, not a
//      separate acrylic-sizing bug — resolved by Task 1 alone, acrylic
//      formula untouched.
//   6. DATUMS block added — tray_0_z and the door's window_z0/z1 were each
//      independently derived and had drifted apart (window floated way above
//      the actual trays). Single source of truth now: DATUM_LEG_TOP/
//      DATUM_FLAP_TOP/DATUM_TRAY_BOT/DATUM_TRAY_TOP/DATUM_ROOFLINE. Also
//      applied left_zone_door()'s own LOCAL origin (hinge line at floor) per
//      .claude/SKILL_reference_point_first.md — the whole leaf places with
//      ONE translate(), door_open is a plain rotate() about that same origin.
//      spring_tray()/tray_rack() also fixed to reference tray_0_z directly
//      instead of re-deriving leg_h+exit_door_h locally (same bug class,
//      not explicitly named in the v42 prompt but required for the datum
//      fix to actually move the physical trays).
//   Janis-approved 2026-07-05: tray zone position is not independently
//   locked — real constraint is the door/flap staying close to the floor
//   for customer access, which the flap's own datum chain already
//   guarantees. See rules-dimensions.md/rules-codes.md zone-stack supersession.
//
// Changes from v40:
//   front_door()+flap_door()+spring_zone_panel() DELETED, replaced by one
//   new module left_zone_door(): full-height (50-698mm) left-zone door
//   with a concealed hinge on the flat left-side wall (off the rounded
//   front-left corner, via a return flange), an inset acrylic viewing
//   window, and a top-hinged 300x150mm exit flap that swings inward to a
//   static stopper rod. New viewer/export toggles: door_open, flap_open,
//   tray_out_pct (wired into spring_tray()'s Y offset). See TASK 1/2 below.
//
// Changes from v39:
//   outer_shell_debug() built its own rounded_box() using the full total_h
//   (700) as its own extrusion height, while ASSEMBLY also translates it
//   by +leg_h (50) — double-counting leg height so the shell's real world
//   Z range was 50-750, not the intended 50-700. Fixed: module now uses a
//   local shell_h = total_h - leg_h for both rounded_box() calls. See
//   TASK 1 below. outer_shell() (unused, non-debug twin) already had this
//   fix from v14 — outer_shell_debug() never received it.
//
// Changes from v38:
//   acrylic_display() right-side panel recessed to corner_r on both Y ends
//   (was skin_t) — fixes 7.28mm protrusion past the shell's curved corner
//   wall at the front-right (and rear-right) corner. See TASK 1 below.
//
// Changes from v37:
//   Three render_mode options for STL exports:
//     render_mode = "standard" → STANDARD VIEW: full shell + all internals, acrylic panels removed
//                                Shows interior through open window (same as transparent acrylic)
//                                Export as: VM-01-v42-std.stl
//
//     render_mode = "full"     → FULL EXTERIOR: everything including acrylic panels (fully opaque)
//                                Export as: VM-01-v42-full.stl
//
//     render_mode = "open"     → OPEN SHELL (C2): set show_shell_top/left = false below for inspection
//                                Export as: VM-01-v42-C2.stl
//
//   Workflow: set render_mode → set debug toggles if needed → F6 → File > Export > STL

$fn = 64;

// ─────────────────────────────
// PARAMETERS
// ─────────────────────────────

total_w = 640;
total_h = 700;
total_d = 600;
corner_r = 20;
skin_t = 2;

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
spring_clearance = 50;
tray_h = 121;           // floor(5) + spring_od(66) + clearance(50)
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

// Frame bars
frame_bar = 20;

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

return_depth = HINGE_Y_OFFSET - skin_t;// 23mm -- flange depth, front face to hinge line (general-purpose, e.g. exit_x centering below; the shell's OWN recess-pocket cutout does NOT read this global -- it re-derives its own copy, see outer_shell()/outer_shell_debug())
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

// Mandatory clearance check (top tray vs the physical roofline/door
// boundary, only tray_count=2 exists in source -- no 3-row/"3x5" variant
// to check separately, confirmed via grep, not guessed):
//   top tray (index tray_count-1) floor  = tray_stack_z0 + (tray_count-1)*tray_h = 491mm
//   top tray ceiling                      = 491 + tray_h = 612mm
//   clearance vs door_top_z (698mm)       = 86mm  -- POSITIVE, confirmed
//   clearance vs DATUM_ROOFLINE (700mm)   = 88mm  -- POSITIVE, confirmed
// FLAG (not a 3D collision, no geometry silently changed to compensate):
// vs the UNCHANGED DATUM_TRAY_TOP (512mm) the shifted stack is -100mm
// "over" -- but DATUM_TRAY_TOP is tautologically defined as
// DATUM_TRAY_BOT+tray_zone_h (i.e. it only ever meant "wherever the
// unshifted stack's own top happens to be"), not an independent physical
// ceiling -- nothing else physically occupies world Z 512-612 on the left
// side. Whether the "upper display" zone LABEL should be redefined is a
// separate documentation question for Claude Web/Janis, out of this
// prompt's DO NOT TOUCH scope (shell/right-compartment datums untouched).

// Left-zone door Z range — from DATUMS
door_bot_z = FOOT_BASE_H + 0;            // 50mm -- explicit ground term (§2.1/§2.2), was `DATUM_LEG_TOP`
door_top_z = DATUM_ROOFLINE - skin_t;    // 698mm
door_h     = door_top_z - door_bot_z;    // 648mm -- door's own true height, shared with the shell's left-wall recess cutout (Task 3)
exit_bot_z = door_bot_z + 30;            // 80mm -- 30mm clearance off the floor

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

// Epsilon — prevents z-fighting on coincident front faces
e = 0.01;

// Acrylic display zone (upper right compartment)
acrylic_bot_z = tray_zone_top_z;               // 542mm
acrylic_top_z = total_h - skin_t;              // 698mm
acrylic_zone_h = acrylic_top_z - acrylic_bot_z; // 156mm
acrylic_r = 8;
acrylic_t = skin_t;

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

module leg() {
    color("#AAAAAA")
    cylinder(h=leg_h, d=leg_od);
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
    tray_w = product_w - 20;
    z = tray_stack_z0 + (tray_num * tray_h);   // v46: reference tray_stack_z0 (shifted +100mm), not tray_0_z directly -- tray_0_z is now the fixed pre-shift anchor for tray_compartment_partition() only
    tray_y = tray_start_d - (tray_d * tray_out_pct);   // v41: slides toward the front opening

    translate([10, tray_y, z]) {
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
    tray_w = product_w - 20;
    color("#AAAAAA")
    for (t = [0:tray_count-1]) {
        z = tray_stack_z0 + (t * tray_h);   // v46: reference tray_stack_z0 (shifted +100mm), same fix as spring_tray()
        translate([10, tray_start_d, z - rail_h])
            cube([rail_w, tray_d, rail_h]);
        translate([10 + tray_w - rail_w, tray_start_d, z - rail_h])
            cube([rail_w, tray_d, rail_h]);
        translate([10 + tray_w/2, tray_start_d + tray_d - tray_wall_t, z + tray_h/2])
            rotate([-90, 0, 0])
                cylinder(d=latch_pin_d, h=latch_pin_l);
    }
}

// v46 TASK 1: fixed/welded horizontal panel sealing the space vacated by
// the 100mm tray-stack shift -- spans the FULL width of the tray/product
// compartment, NOT a removable/access panel. Positioned at the pre-shift
// tray_0_z (270mm) -- the anchor the trays moved away from, NOT the
// post-shift tray_stack_z0. Works together with exit_compartment_wall()
// (below) to fully close the reach-through path from the exit zone into
// the tray compartment.
//
// v47 PROBLEM 1 fix: the panel's front (Y) edge used to start at skin_t
// (2mm), reaching all the way to the front of the compartment and
// physically overlapping tray_zone_frame() -- confirmed by Janis, present
// regardless of door state (2 fixed parts). Functional requirement, not
// just a clearance fix: a dropped item must keep falling through the
// compartment's front opening (the spring's own operative/product-drop
// length, world Y 138-526) instead of landing on top of the partition and
// getting stuck. Fixed: front edge moved to tray_start_d +
// (tray_d-motor_d-2) -- the SAME expression spring_coil() already uses
// for its own rearward extent (its translate Y, effectively spring_l-2),
// not a new invented number -- so the partition now covers only the
// region behind the spring's own reach (526-598mm, under the motor/rear
// structure). Rear edge (total_d-skin_t) unchanged.
module tray_compartment_partition() {
    partition_t = tray_floor_t;   // 5mm, reuses the tray floor's own thickness convention
    partition_y0 = tray_start_d + (tray_d - motor_d - 2);  // 526mm -- spring's own rearward extent (matches spring_coil()'s translate Y), NOT the front of the compartment
    partition_y1 = total_d - skin_t;                        // 598mm -- rear wall, unchanged

    // Contact receipt (Rule M-3): gap to tray_zone_frame()'s furthest
    // reach (world_arc_cy=21mm, the hinge-side curve's own top) =
    // 526 - 21 = 505mm -- confirmed clear, not just "looks fine".
    color("#AAAAAA")
    translate([skin_t, partition_y0, tray_0_z])
        cube([product_w - (skin_t*2), partition_y1 - partition_y0, partition_t]);
}

// v46 TASK 1: NEW module -- no existing v45 module literally matched "the
// vertical partition/side bracket that holds the flap stopper" (checked:
// drop_zone_guards() are 2 thin SIDE panels within the drop zone's own
// depth, Y 2-140mm, and don't block front-to-back reach past Y=drop_zone_d;
// flap_stopper_rod() is a bare rod with no bracket geometry at all).
// Flagging this explicitly rather than force-fitting an existing module.
// Rear-facing wall at Y=drop_zone_d (the drop-zone/tray-compartment
// boundary), full width, floor to Z=tray_0_z+partition_t+e -- this module
// UNCHANGED by v47 (position already correct, confirmed by Janis).
// v47 NOTE: tray_compartment_partition()'s front edge moved to 526mm
// (PROBLEM 1 fix, see that module) -- this wall (Y=138mm) no longer
// spatially overlaps the partition directly, so the two no longer share a
// physical seam. This does NOT reopen the reach-through gap: the wall
// alone already fully blocks ALL Y-direction movement at Y=drop_zone_d for
// Z 50-275 (the entire exit-zone-to-tray-compartment threat), independent
// of whatever the partition covers further back. "Zero gap" between wall
// and partition specifically is no longer a meaningful/applicable check
// under the corrected geometry -- flagged explicitly, not silently
// asserted, per cc_chat_log.
module exit_compartment_wall() {
    partition_t = tray_floor_t;   // matches tray_compartment_partition()
    wall_t = skin_t;
    color("#AAAAAA")
    translate([skin_t, drop_zone_d, leg_h])
        cube([product_w - (skin_t*2), wall_t, (tray_0_z + partition_t + e) - leg_h]);
}

module outer_shell() {
    // §2.2 (v43): shell independently re-derives the hinge center from ITS
    // OWN datum chain -- own sharp-corner reference (world X=0/Y=0, the
    // front-face-plane x left-face-plane intersection, extended past
    // corner_r's fillet) + FOOT_BASE_H + HINGE_Y_OFFSET + hinge_od -- never
    // reads left_zone_door()'s local variables. See commit message for the
    // side-by-side comparison against the door's own calculation.
    shell_hinge_x = 0 - (hinge_od / 2);        // -6mm world
    shell_hinge_y = HINGE_Y_OFFSET;             // 25mm world
    shell_hinge_z = FOOT_BASE_H + 0;            // 50mm world
    shell_return_depth = shell_hinge_y - skin_t; // 23mm -- independently derived

    color("#C8C8C8", 0.75)
    difference() {
        rounded_box(total_w, total_h, total_d, corner_r);

        // Hollow interior — local Z=skin_t preserves bottom skin; shell placed at leg_h in assembly
        translate([skin_t, skin_t, skin_t])
            rounded_box(total_w-(skin_t*2), total_h-(skin_t*2), total_d-(skin_t*2), corner_r-1);

        // Left product zone front: local Z 0-492 (world Z 50-542)
        translate([skin_t, -1, 0])
            cube([product_w-(skin_t*2), skin_t+2, tray_zone_top_z - leg_h]);

        // Exit zone internal chute cutout: local Z 0-250 (world Z 50-300)
        translate([(product_w - exit_door_w)/2, -1, 0])
            cube([exit_door_w, skin_t+2, exit_door_h]);

        // Upper front display cutout: local Z 492-650 (world Z 542-700)
        translate([skin_t, -1, tray_zone_top_z - leg_h])
            cube([product_w-(skin_t*2), skin_t+2, upper_display_h]);

        // Right compartment front face opening: local Z 0-492 (world Z 50-542)
        translate([product_w + divider_t, -1, 0])
            cube([system_w - divider_t - skin_t, skin_t+2, tray_zone_top_z - leg_h]);

        // v43 TASK 3 (§2.2): left-side-wall recess for left_zone_door()'s
        // return flange/hinge line, independently derived above.
        translate([-1, skin_t, shell_hinge_z - leg_h])
            cube([skin_t + 2, shell_return_depth, door_h]);
    }
}

module outer_shell_debug() {
    shell_h = total_h - leg_h;

    // §2.2 (v43): shell independently re-derives the hinge center from ITS
    // OWN datum chain -- own sharp-corner reference (world X=0/Y=0, the
    // front-face-plane x left-face-plane intersection, extended past
    // corner_r's fillet) + FOOT_BASE_H + HINGE_Y_OFFSET + hinge_od -- never
    // reads left_zone_door()'s local variables. See commit message for the
    // side-by-side comparison against the door's own calculation.
    shell_hinge_x = 0 - (hinge_od / 2);        // -6mm world
    shell_hinge_y = HINGE_Y_OFFSET;             // 25mm world
    shell_hinge_z = FOOT_BASE_H + 0;            // 50mm world
    shell_return_depth = shell_hinge_y - skin_t; // 23mm -- independently derived

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

        // v43 TASK 3 (§2.2): left-side-wall recess for left_zone_door()'s
        // return flange/hinge line, independently derived above.
        translate([-1, skin_t, shell_hinge_z - leg_h])
            cube([skin_t + 2, shell_return_depth, door_h]);

        // Back panel — removed when show_shell_back = false
        if (!show_shell_back)
            translate([0, total_d - skin_t - 1, 0])
                cube([total_w, skin_t + 2, total_h]);

        // Top panel — removed when show_shell_top = false
        if (!show_shell_top)
            translate([0, 0, total_h - skin_t - 1])
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

module compartment_divider() {
    color("#AAAAAA", 0.9)
    translate([product_w, skin_t, leg_h])
        cube([divider_t, total_d-(skin_t*2), total_h - leg_h - skin_t]);
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
// recess-pocket cutout (outer_shell()/outer_shell_debug()) computes the
// SAME point independently too, never by reading these local variables.
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
    hinge_z = FOOT_BASE_H + 0;         // 50mm -- explicit ground term

    // door_x_offset: local-X distance from the hinge center (new origin) to
    // the door's own left-edge world position (door_left_x) -- keeps the
    // flange/panel/window/flap physically unchanged from v42 (world X moved
    // 2mm -> -6mm for the origin only; Y/Z origin values are unchanged, so
    // no compensation needed on those axes).
    door_x_offset = door_left_x - hinge_x;    // 2 - (-6) = 8mm

    door_open_angle = door_open ? door_open_deg : 0;
    front_y = -(hinge_y - skin_t) + e;   // §2.5 epsilon -- nudged e off the shell's interior front-wall face (was flush at world Y=skin_t)
    flap_top_z = DATUM_FLAP_TOP - hinge_z;      // 180mm local -- flap hinge line
    flap_angle = flap_open ? flap_open_deg : 0;

    // §2.3 frozen window constants, re-anchored to the corrected local-X origin
    win_x0 = door_x_offset + window_x0;             // 46mm local
    win_x1 = door_x_offset + window_x0 + window_w;  // 382mm local
    win_z0 = window_z0;                              // 220mm local -- Z origin unchanged, no compensation
    win_z1 = window_z0 + window_h;                   // 462mm local

    exit_x_local = door_x_offset + (exit_x - door_left_x);  // local X of the exit-flap opening
    exit_bot_local = exit_bot_z - hinge_z;                   // 30mm local

    // v46 TASK 2: acrylic/metal split point -- a LIVE reference to
    // tray_stack_z0 (the same constant driving the tray stack's actual
    // position), not a duplicated magic number. If TRAY_SHIFT_UP ever
    // changes again, this boundary moves with it automatically.
    split_z_local = tray_stack_z0 - hinge_z;   // 320mm local -- world 370mm, matches tray_stack_z0 exactly

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

        // 1+2+4+6. Single-piece L-shaped leaf: return flange + front panel in
        // ONE linear_extrude() of a bent 2D cross-section, curved corner per
        // §2.4, with the top window + exit-flap openings cut from it. True
        // manifold solid — no gap/seam possible.
        color("#888888", 0.9)
        difference() {
            linear_extrude(height = door_h)
                polygon(door_poly);

            translate([win_x0, front_y - 1, win_z0])
                cube([win_x1 - win_x0, door_t + 2, win_z1 - win_z0]);

            translate([exit_x_local, front_y - 1, exit_bot_local])
                cube([exit_w, door_t + 2, exit_h]);
        }

        // 3. Hinge seam indicators — pulled strictly INSIDE the flange body
        // (not touching its own hinge-line face) to avoid T-junction
        // contact. Concept placeholder only, NOT a protruding hinge barrel —
        // hinge hardware spec is an open item (rules-dimensions.md).
        for (pct = [0.1, 0.5, 0.9])
            color("#333333")
            translate([door_x_offset - e, -(hinge_mark_d + e), door_h*pct - hinge_mark_h/2])
                cube([door_t + e*2, hinge_mark_d, hinge_mark_h]);

        // 5. Acrylic viewing pane — mounted door_t further inside than the
        // door face; correctly moves WITH the door leaf. v44 Finding B: was
        // gated on `render_mode=="full" && show_acrylic`, inconsistent with
        // its siblings (show_door/show_flap are NOT render_mode-gated) —
        // since render_mode defaults to "standard", the acrylic could never
        // render regardless of show_acrylic. Now gated on show_acrylic alone.
        // v46 TASK 2: split into an upper ACRYLIC portion (unchanged top
        // boundary, same acrylic_border overlap convention) and a lower
        // plain METAL sheet (no acrylic material, same border/mounting
        // convention) — the split point is split_z_local, a live reference
        // to tray_stack_z0 above. Both pieces share this same show_acrylic
        // gate — do not reintroduce the v43 render_mode-gate bug.
        if (show_acrylic) {
            // Upper acrylic — from the (post-shift) lowest-tray-floor Z up
            // to the door's existing top boundary, unchanged.
            color("#ADD8E6", 0.3)
            translate([win_x0 - acrylic_border, front_y + door_t, split_z_local])
                cube([(win_x1-win_x0) + acrylic_border*2, door_t, (win_z1 + acrylic_border) - split_z_local]);

            // Lower metal panel — plain flat sheet, no vents/cutouts/branding,
            // same border/mounting convention as the acrylic above, extends
            // from the split point down to the flap area (window's original
            // bottom boundary). Nudged +e past the split so it shares real
            // volume with the acrylic piece above (Rule M-1), not just a
            // touching face.
            color("#999999")
            translate([win_x0 - acrylic_border, front_y + door_t, win_z0 - acrylic_border])
                cube([(win_x1-win_x0) + acrylic_border*2, door_t, (split_z_local + e) - (win_z0 - acrylic_border)]);
        }

        // 7. Exit flap — hinged at TOP, swings inward (+Y) toward flap_open_deg.
        // Independent show_flap toggle.
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

// FIX 2: Left front acrylic panel — full left product zone, Z 50-700.
// Customer sees springs, trays, products. Replaces visual of solid front face.
module left_front_acrylic() {
    panel_x = skin_t;                        // X=skin_t
    panel_w = product_w - (skin_t * 2);      // 412mm
    panel_z = leg_h;                         // Z=50mm
    panel_h = total_h - leg_h;              // 650mm (Z 50-700)
    panel_t = door_t;                        // 3mm

    color("#ADD8E6", 0.15)
    translate([panel_x, e, panel_z])
        cube([panel_w, panel_t, panel_h]);
}

// v44 TASK 3 (Finding C): full rebuild, H-frame. The old design started
// every bar at translate([0, e*2, ...]) -- world X=0/Y=0, the shell's
// THEORETICAL SHARP EXTERIOR corner -- never accounting for skin_t or
// corner_r at all, so it visually sat at/outside the shell's actual
// interior wall. Separately CONFIRMED via CGAL boolean intersection
// (isolation-tested against left_zone_door(), 9-angle sweep 0-100deg):
// the old frame's top/bottom/right bars physically clipped the door leaf
// for door_open_deg 0-30 -- a SEPARATE issue from the wrong reference
// point, both required fixing.
//
// v46 TASK 3: 10mm top + bottom weld flanges added, for spot-welding the
// frame to the shell -- built from the SAME 2D cross-section as the
// crossbar (already proven clear of the door leaf at every angle), placed
// WITHIN the existing frame_z0..frame_z1 range, no new Z-boundary risk.
//
// New H-shape: 2 full-height verticals (frame_bar wide) + 1 crossbar
// (10mm thick) at tray_0_z -- replaces the old top+bottom+short-side-bar
// layout entirely. Repositioned off the shell's REAL interior corner
// curve (world (skin_t+(corner_r-1), skin_t+(corner_r-1)) -- SAME formula
// as left_zone_door()'s arc_cx/arc_cy, reused here independently since
// this module has no hinge-relative local origin). The left vertical's
// outer edge is curved to match that SAME curve (same center, same
// corner_r-1 radius formula) but pulled back by the SAME 5mm border inset
// already used for the frame's X/Z insets -- radius (corner_r-1)-inset =
// 14mm -- so it clears the door's hinge/flange swept volume at every
// angle. Verified (Python/shapely, mirrors the CGAL intersection() test):
// ZERO overlap at door_open_deg 0,20,25,30,35,40,45,70,100, and a finer
// 0.5-degree sweep across the full 0-100deg range -- see commit message
// for the full result table.
module tray_zone_frame() {
    frame_inset = 5;
    frame_z0 = door_bot_z + frame_inset;    // 55mm
    frame_z1 = door_top_z - frame_inset;    // 693mm
    frame_h  = frame_z1 - frame_z0;         // 638mm
    X0 = door_left_x + frame_inset;         // 7mm -- left vertical outer inset (pre-curve-clamp)
    X1 = door_right_x - frame_inset;        // 409mm -- right vertical outer edge

    // Shell's real interior corner curve, WORLD coords -- same formula as
    // left_zone_door()'s arc_cx/arc_cy (this module has no hinge-relative
    // local origin, so no further offset is needed).
    world_arc_cx = skin_t + (corner_r - 1);      // 21mm
    world_arc_cy = skin_t + (corner_r - 1);      // 21mm
    frame_arc_r  = (corner_r - 1) - frame_inset; // 14mm -- same radius formula, pulled back by the door-clearance inset
    arc_segs = 24;

    left_bar_arc = [for (i = [0:arc_segs]) let(a = 180 + i*(90/arc_segs))
        [world_arc_cx + frame_arc_r*cos(a), world_arc_cy + frame_arc_r*sin(a)]];
    left_bar_inner_x = X0 + frame_bar;             // 27mm
    frame_y0 = left_bar_arc[arc_segs][1];          // 7mm -- where the curve ends; baseline depth for the flat bars
    frame_depth = skin_t;                           // 2mm
    FLANGE_T = 10;                                   // v46 TASK 3: top/bottom weld-flange thickness (Z)

    color("#AAAAAA")
    union() {
        // Left vertical bar -- curved outer edge near the corner/hinge,
        // constant cross-section for the full frame height (Z-invariant,
        // matching how the shell's corner and the door's flange are also
        // Z-invariant extrusions).
        translate([0, 0, frame_z0])
            linear_extrude(height = frame_h)
                polygon(concat(left_bar_arc,
                    [[left_bar_inner_x, frame_y0], [left_bar_inner_x, left_bar_arc[0][1]]]));

        // Right vertical bar -- simple flat bar, far from the corner
        translate([X1 - frame_bar, frame_y0, frame_z0])
            cube([frame_bar, frame_depth, frame_h]);

        // Crossbar -- 10mm thick (Z), spans left-to-right between the verticals, at tray_0_z
        translate([left_bar_inner_x, frame_y0, tray_0_z])
            cube([(X1 - frame_bar) - left_bar_inner_x, frame_depth, 10]);

        // v46 TASK 3: top + bottom flanges, 10mm each, for spot-welding to
        // the shell. Built from the SAME 2D cross-section as the crossbar
        // above (already proven clear of the door's swept volume at every
        // mandated angle) -- reused here rather than a new shape, and
        // placed WITHIN the frame's existing, already-verified Z range
        // (frame_z0..frame_z1), not extending past it, so no new
        // Z-boundary risk is introduced.
        translate([left_bar_inner_x, frame_y0, frame_z1 - FLANGE_T])
            cube([(X1 - frame_bar) - left_bar_inner_x, frame_depth, FLANGE_T]);
        translate([left_bar_inner_x, frame_y0, frame_z0])
            cube([(X1 - frame_bar) - left_bar_inner_x, frame_depth, FLANGE_T]);
    }
}

// Parallel sensor strips — left and right walls at Z=280mm.
// v44 Finding A: the old module also drew a red 2x2mm cube spanning the
// FULL GAP between the two strips, reading as a connecting beam/rod —
// Janis-confirmed this center element was never part of the actual
// design (2 independent side pieces only, nothing bridging them).
// Deleted entirely, not just hidden. `show_sensor` gates both real strips.
module sensor_strip() {
    strip_z = tray_0_z - 20;   // 280mm
    strip_t = 5;
    strip_h = 8;

    // §2.5 (v43) epsilon fix -- both strips were flush at X=skin_t (left
    // strip's own face, right strip's own face) against the shell's
    // interior left/right walls. Nudged e inward (away from each wall) to
    // kill the coplanar-face condition.
    strip_x0 = skin_t + e;                        // left strip left edge
    strip_x1 = product_w - skin_t - strip_t - e;   // right strip left edge

    if (show_sensor) {
        color("#222222")
        translate([strip_x0, skin_t, strip_z])
            cube([strip_t, drop_zone_d, strip_h]);

        color("#222222")
        translate([strip_x1, skin_t, strip_z])
            cube([strip_t, drop_zone_d, strip_h]);
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

// §2.6 (v43): drop_zone_visual() removed entirely -- its top/bottom/front/
// back faces were ghost surfaces that blocked the ACTUAL product drop path
// (vertical fall-through and front-to-back access). Only the 2 side faces
// (left/right, constant X, spanning Y-Z) were a genuine safety guard against
// a hand reaching in sideways toward the mechanism above -- kept below,
// rebuilt as solid opaque panels (skin_t thick), not translucent.
//
// LEFT panel receipt: left_zone_door()'s return flange occupies world
// X = door_left_x .. door_left_x+door_t = 2..5mm, Y = skin_t .. HINGE_Y_OFFSET
// = 2..25mm (§2.2). Left guard placed just past the flange's right edge:
// X0 = skin_t + door_t + e = 5.01mm -- clears the flange, no intersection.
// RIGHT panel: no hinge on this side (hinge is LEFT edge only, rules-
// dimensions.md) -- placed symmetric to the old drop_zone_visual() box's
// right face, X1 = product_w - skin_t - skin_t - e = 411.99mm.
//
// v47 PROBLEM 2 fix: at door_open_deg=0 (closed), both guards' OLD
// front-most Y (skin_t+e = 2.01mm) poked through the door's own surface
// plane -- confirmed by Janis via direct visual render inspection. Both
// of Janis's suggested references were checked against live geometry
// (Python/shapely) and found INSUFFICIENT for the hinge-side guard: the
// "frame face minus thickness" formula and the flat 10mm fallback both
// still left a confirmed overlap (10mm pullback -> 7.6mm² overlap at
// door_open_deg=0), because that guard sits close to the door's curved
// flange, which reaches up to world Y=world_arc_cy(21mm) there -- not
// just to tray_zone_frame()'s own front face (7mm). Fixed instead: guard
// front-most Y raised to world_arc_cy+e (21.01mm) -- the SAME shell-
// interior-corner-curve constant (skin_t+(corner_r-1)) already used
// identically by both left_zone_door() and tray_zone_frame(), not a new
// invented number. Rear edge (skin_t+e+drop_zone_d = 140.01mm) UNCHANGED.
// Re-verified: 9-angle sweep (0/20/25/30/35/40/45/70/100) + fine 0.5°
// sweep, ZERO overlap at every angle -- see cc_chat_log.md.
module drop_zone_guards() {
    // Independently computed here (same formula as left_zone_door()'s
    // arc_cy and tray_zone_frame()'s world_arc_cy) -- never read another
    // module's local variable, per this file's established datum pattern.
    world_arc_cy_local = skin_t + (corner_r - 1);   // 21mm

    guard_y0 = world_arc_cy_local + e;         // 21.01mm -- was skin_t+e (2.01mm)
    guard_y1 = skin_t + e + drop_zone_d;       // 140.01mm -- rear edge, unchanged
    guard_depth = guard_y1 - guard_y0;          // 118.99mm

    color("#DDDDDD")
    translate([skin_t + door_t + e, guard_y0, leg_h])
        cube([skin_t, guard_depth, exit_door_h]);

    color("#DDDDDD")
    translate([product_w - skin_t - skin_t - e, guard_y0, leg_h])
        cube([skin_t, guard_depth, exit_door_h]);
}

module rear_service_door() {
    door_w = system_w - divider_t;
    door_h = total_h * 0.5;
    color("#B8B8B8", 0.6)
    translate([product_w + divider_t, total_d - skin_t, leg_h + (total_h*0.25)])
        cube([door_w, skin_t*2, door_h]);
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
show_shell_back  = true;
show_shell_top   = true;   // set false for C2 export
show_shell_left  = true;   // set false for C2 export
show_shell_right = true;

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

// ─────────────────────────────
// ASSEMBLY
// ─────────────────────────────

legs();

// Outer shell — shown in all modes (debug toggles control which panels visible)
translate([0, 0, leg_h]) outer_shell_debug();

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
