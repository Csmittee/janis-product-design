# Janis Product Design — Confirmed Dimensions
# Version: v36 — 2026-07-13
# Changes: bbq-offset-smoker-v1-init. New "BBQ Offset Smoker Base" section
# added — first dimensions for this NEW product line (GRATE_Z=700 MASTER
# CONTROL VALUE, chamber 915x610x610, firebox 457mm cube, firebox_drop=200
# OPEN FLAG not yet Janis-confirmed). Real OpenSCAD/CGAL used throughout
# (binary installed fresh this session) — full kinetic sweep (lid_open_deg,
# firebox_door_open_deg, ash_tray_out_pct, chimney_open, shelf_deployed)
# all Simple:yes; window/firebox pass-through opening confirmed genuinely
# continuous via real intersection() checks, not assumed. See
# bbq-offset-smoker/BBQ-chambers-v1.scad's own header for judgment calls
# (lid-opening extent, chimney mount point) not specified in the source
# prompt, and cc_chat_log.md for the full real-collision-found-and-fixed
# record (firebox door hinge exact-tangency, firebox far-wall design error,
# lid hinge clearance, chimney fold pivot, counterbalance standoff).
# Previous: v35 — 2026-07-10
# Changes: vm02-dashboard-shelf-and-side-acrylic. New "VM-02 Base —
# Display Shelf + Right-Side Viewing Acrylic" section added: a display
# shelf (Feature A, `shelf_top_z = acrylic_zone_bot_z - 10`, full
# compartment depth, `dash_x`/`dash_w` width, `tray_floor_t` thickness)
# and a new permanent right-exterior viewing acrylic cutout (Feature B,
# front half of the compartment's depth only — `corner_r` to `total_d/2`
# — the shell's own rounded-corner tangent point, real numeric coincidence
# with the front acrylic panel's own edge). `acrylic_display()`'s
# existing internal right panel Y-range shrunk to match (was full depth,
# now front-half). VM-02-base-v3.scad is the new active file (v2
# superseded, kept per file-versioning convention). Real OpenSCAD/CGAL
# used throughout — tray_count 1/3/5, 11-angle door sweep, mixed
# tray_out_pct, flap_open, C2 mode, all Simple:yes; explicit isolation
# checks (shelf vs. dashboard/shell/acrylic, new cutout vs. rear door/
# frame) confirmed zero real collision.
# Previous: v34 — 2026-07-10
# Changes: vm02-lower-shell-fill-and-retro-governance, Part 1. New "VM-02
# Base — System Compartment Metal Panel" section added: the right
# compartment's dashboard zone is now enclosed in solid sheet metal
# (real, confirmed gap since VM-01-base-v6, never actually built in
# either product until now — VM-01 itself untouched, still has the gap).
# 4 new individual mounting cutouts (screen+bezel+bracket, QR, card,
# speaker), each sized to real component footprint + the existing 2mm
# Global Clearance Tolerance. Real CGAL confirmed clean at tray_count
# 1/3/5 after a found-and-fixed ~3mm gap against the dashboard's own
# support bracket (a flat, non-tilted part reaching lower than the
# bezel). VM-02-base-v2.scad is the new active file (v1 superseded, kept
# per file-versioning convention).
# Previous: v33 — 2026-07-10
# Changes: vm02-derivation-from-vm01-v58, 2nd direct-chat follow-up (same
# day as v32). Janis proposed the actual fix for item (3) below (v32's
# tray_out_pct ~27% ceiling, left un-fixed): widen the tray compartment
# itself (product_w 416mm->422mm) and shift the tray's own position
# (tray_x_inset 17mm->23mm) by the same amount, keeping tray width/spring
# layout unchanged. Confirmed via a full real CGAL sweep this resolves the
# tray_zone_frame() left-vertical collision across the ENTIRE tray_out_pct
# 0-1 range (door open), not just the previously-safe ~27% — total_w now
# 584mm accordingly. Same gap confirmed still present, unfixed, in the
# locked VM-01 v58 file (out of scope there).
# Previous: v32 — 2026-07-10
# Changes: vm02-derivation-from-vm01-v58, Janis follow-up round (direct
# chat, same day). 4 corrections against v31's own draft: (1) governance
# flag acknowledged by Janis, no repo change needed. (2) system_w
# corrected 133mm→143mm — Janis confirmed a real 10mm border EACH SIDE of
# the panel (matching the prompt's own literal arithmetic), not v31's own
# 2mm-clearance-based 133mm; total_w now 578mm. (3) tray_out_pct's real
# ~27% ceiling: root-caused, NOT fixed — confirmed a genuine regression
# from VM-01 v56 (curve rebuilt for a kink fix, silently invalidated v50's
# own tray-clearance verification, confirmed by reading both archived
# files directly) — clarified this is a width/X issue, not a height/
# ceiling issue; a real fix needs ~5mm more width than is available with
# product_w unchanged, flagged for Janis's decision, not attempted. (4)
# acrylic_display() RESTORED, PERMANENT — Janis: "we need acrylic
# window." v31's removal reversed; module rebuilt for VM-02's narrower/
# portrait compartment, 3 more real manifold issues found+fixed in the
# process (see VM-02 section below + cc_chat_log.md).
# Previous: v31 — 2026-07-10
# Changes: vm02-derivation-from-vm01-v58 — new "VM-02 Base" section added
# (mirrors the VM-01 section structure per the prompt's own instruction).
# VM-02 is a NEW sibling product line derived from VM-01-base-v58 (VM-01
# itself untouched, stays LOCKED). Real values confirmed via live CGAL
# render, not assumed: system_w RECOMPUTED to 133mm (prompt suggested
# 120mm, found insufficient once the existing dash_w formula + portrait
# bezel footprint were checked, see VM-02 section for full derivation);
# total_w/total_h both now DERIVED formulas, not literals; leg_od 80mm
# clearance-checked; a real ~27% practical ceiling on tray_out_pct found
# (frame-vs-tray-wall collision, pre-existing in VM-01 too, flagged not
# fixed). GOVERNANCE FLAG carried into the new section: VM-02 has no
# design_scope_of_work_rule.md/Skeleton worksheets on record — see
# knowledge.map and cc_chat_log.md for the full note.
# Previous: v30 — 2026-07-09
# Changes: vm01-gen1-lock-and-systemw-fix (docs-only, zero .scad touched).
# `system_w` UNLOCKED per Janis (no restriction on machine width/height
# going forward) -- removed entirely from the OWNER-LOCKED DIMENSIONS
# table, not just re-valued. Separately, and independent of the unlock:
# this file had documented system_w as 185mm in 3 places while live v58
# code has used 204mm since at least v44 (confirmed via v58's own PARAMETERS
# block + its `dash_w` sanity-check comment, 204-19-4=181mm ✓) -- stale
# value corrected everywhere it appears (Compartments table, Dashboard
# "Total width" recomputed to 181mm, PENDING DESIGN DECISIONS baseline
# rebaselined off the corrected system_w=204/total_w=640, live-confirmed
# rather than assumed 620). See CURRENT_STATE.md for the companion VM-01
# Generation-1-locked marker (same session).
# Previous: v29 — 2026-07-09
# Changes: vm01-acrylic-curve-hinge-lock-fix (v57.scad, fresh session, see
# cc_chat_log.md for full 4-task write-up). Acrylic "double sheet" TOP-edge
# step FIXED (real root cause: near-coincident acrylic-top vs window-hole-
# top edges, not v56's "leaf thickness" theory -- new 2mm top border,
# mirrors the already-working left/right border). Door return-flange curve
# CONFIRMED already tangent to the shell wall (real CGAL render) -- no code
# change; frame_arc_r's 14mm cap RE-CONFIRMED unmovable via hinge_x/hinge_y
# (real parametrized bisection sweep, not arithmetic). Hinge-pivot
# reinforcement cylinder REMOVED entirely (not toggled) -- pivot point
# preserved as pure rotation math, now a LOCKED reference below. New lock-
# system PROVISION (placeholder recess, door leaf + compartment_divider(),
# dimensions/position flagged as needing Janis's input, not invented).
# Full-assembly 11-angle CGAL sweep (0-100°): Simple:yes throughout, zero
# new warnings.
# Previous: v28 — 2026-07-07
# Changes: vm01-v56-sensor-bracket-frame-joint-fix, TASK 3 follow-up (same
# v56.scad file, no prompt file). Janis tested the FIX 1/FIX 2 changes
# live and confirmed both work; her further testing found 2 more things:
# (1) her own toggle testing (show_door=false / show_shell_left=false
# clear the door-closed manifold warning, show_shell_top=false does not)
# revealed the warning's REAL trigger was never compartment_divider() (as
# v55 had concluded) -- root-caused to a real X-Y gap between two
# independently-duplicated shell cutouts (in BOTH outer_shell() and
# outer_shell_debug(), the same "duplicated datum" bug class as v55's
# door-floor fix -- editing only one copy and re-testing caught the
# second). Fixed by extending both cutouts' Y-reach to close the gap.
# RESULT: full-assembly manifold warning is COMPLETELY GONE at every
# angle -- first time ever in this file's history. (2) Janis disproved
# this session's own "acrylic recess" theory for the "double sheet" note
# by re-testing with show_acrylic=false -- the line was still there.
# Re-diagnosed by elimination (door alone, no frame/acrylic/shell, still
# shows it): it's simply the door leaf's own 3mm material thickness
# rendering as 2 edges at a grazing angle, not a bug -- corrected in both
# files rather than left standing as a wrong explanation.
# Previous: v27 — 2026-07-07
# Changes: vm01-v56-sensor-bracket-frame-joint-fix (v56, direct response to
# Janis's QA screenshots on the merged v55 PR, no prompt file). FIX 1:
# sensor_strip() was found "lifted out" of drop_zone_guards() -- a real
# side effect of v54's sensor Z-fix (moved up to clear a real collision,
# stranding it 50mm above the guard's old top). Fixed the bracket (not the
# sensor) per Janis's own instruction: guard height now covers the
# sensor's position too, via a newly-shared sensor_strip_z0/h datum (was 2
# independent copies). FIX 2: tray_zone_frame()'s left vertical bar had a
# real, CGAL/render-confirmed visible kink ("bad joint") where a v50 fix
# truncated its curve early and picked up a non-tangent straight line --
# rebuilt as a genuine concentric double-arc band, the SAME construction
# left_zone_door() itself already uses, eliminating the kink entirely with
# zero side effects on frame_bar/tray width/divider clearance. Both fixes
# re-verified via real CGAL 9-angle+ door sweeps (zero overlap) and real
# top-down renders (visual confirmation, not just arithmetic). FLAGGED,
# NOT FIXED: the acrylic "double sheet" note on the same screenshot was
# re-checked with a real render this time (v52's own fix here was
# arithmetic-only, never actually render-confirmed) -- traced to the
# acrylic's deliberate door_t recess behind the metal skin (a real
# window-with-inset-pane design, not a duplicate-object bug) -- flagged as
# a design-intent question for Janis, not guessed at.
# Previous: v26 — 2026-07-07
# Changes: vm01-v55-door-floor-datum-fix (v55, direct user question, no
# prompt file). User asked why the door-closed-only manifold warning had
# persisted across v50-v54. Re-verified the two previously-suspected
# "exact tangency" causes (door-top-vs-roof, hinge-cylinder-vs-wall) with
# a real 9-angle CGAL sweep — both are CLEAN, the earlier attribution was
# wrong. Root-caused instead: door_bot_z (and 3 independently-re-derived
# copies: shell_hinge_z x2, hinge_z) used FOOT_BASE_H+0 (legs level)
# instead of FOOT_BASE_H+skin_t (true interior floor) — a real ~2mm
# collision between the door leaf and the floor slab, confirmed via CGAL
# facet extraction. Fixed by moving the shared Z-datum (not just the
# leaf's own extrusion) to FOOT_BASE_H+skin_t-e for all 4 copies, plus
# leg() extended +e to stay flush. Bonus: this also closed the older
# unresolved "bottom-left-corner floor hole" (same stale datum). NOT
# fixed this round: compartment_divider() has its own separate touch
# with the shell (7 facets + warning), confirmed X-Y not Z (no change at
# 1mm overlap) — flagged, not guessed at. Full-assembly door-closed
# warning is still present, now solely attributable to that one isolated
# cause.
# Previous: v25 — 2026-07-07
# Changes: vm01-v54-sensor-bracket-fix (v54). Sensor strip Z corrected
# 280mm(stale tray_0_z-20)→350mm(tray_stack_z0-20) — real CGAL-confirmed
# 12-facet collision with exit_compartment_wall() at the old value,
# resolved. Drop zone side guards front edge corrected AGAIN, 21.01mm→
# 27mm — the v47 value was itself an exact-tangent touch against the
# door (not caught by that round's Python-approximated sweep), fixed with
# HINGE_Y_OFFSET+skin_t (real clearance, already-established reference
# point). Both diagnoses independently re-derived from live geometry this
# session — the source prompt's own claims (sensor "facing wrong way";
# guard "already known oversized, prior session, no harm") did not match
# what real CGAL/repo-history checks confirmed, stated explicitly rather
# than silently accepted.
# Previous: v24 — 2026-07-07
# Changes: vm01-v52-acrylic-fix-side-shell-collision-isolation (v52).
# TASK 1: investigated the double-layer-acrylic report — no duplicate
# object found in v51's code; found instead that v51's leaf-cutout fix
# landed at an exact zero-clearance plane against the acrylic's own top
# (both at world Z=682.99mm exactly), dropping the epsilon overlap the
# deleted cap always had there — restored via `acrylic_top_limit_z - e`.
# Minor precision correction to the v51 entry below, not a new dimension
# VALUE. TASK 2 (isolation only, not fixed): door-vs-shell collision at
# door_open_deg=0 traced to TWO independent exact-zero-clearance touching
# planes — door_top_z vs. the shell's own roof-skin boundary (both
# 698mm world), and the hinge-pivot reinforcement cylinder's tangent edge
# vs. the shell's flat exterior wall (both X=0mm world) — see "Left-Zone
# Front Door" and new isolation note below. Same underlying PATTERN (no
# epsilon buffer on an exact-alignment value), two different features —
# stated explicitly, not merged. No live OpenSCAD/CGAL render this
# session — arithmetic-confirmed only.
# Previous: v23 — 2026-07-07
# Changes: vm01-shell-toggle-fix-and-hole-isolation (v51) — top acrylic-zone
# metal cap DELETED (was a cosmetic patch confirmed dependent on
# show_acrylic, not independent shell material); leaf's own window cutout
# shrunk to acrylic_top_limit_z so the door's own shell skin fills that
# space directly instead — mirrors the door's lower/flap zone. This also
# resolves the entire fill-vs-frame overlap volume flagged since v49 (was
# entirely the cap's own residual). Separately: ISOLATION-ONLY finding on
# the bottom-left-corner hole (v50's corner-pole cutout also punches
# through the shell's own bottom skin at that corner — arithmetic-
# confirmed, not fixed this round). No dimension VALUES changed — see
# "Left-Front-Corner 'Pole' Removal" and "Left-Zone Front Door" sections.
# Previous: v22 — 2026-07-06
# Changes: VM-01-corner-frame-redesign (v50) — left-front-corner rebuild.
# Removed the shell's front-left corner "pole" (solid curved wall material
# never actually cut by the door/window cutouts, confirmed colliding with
# the door once tray_zone_frame() is hidden) via a new cutout in both
# outer_shell()/outer_shell_debug(), full door height. tray_zone_frame():
# frame_bar 20mm->8mm; RIGHT vertical extended to real contact with
# compartment_divider() (world X=product_w+e); LEFT vertical's radius
# LIVE-tested and found it CANNOT grow to touch the shell without
# recolliding the door (the door's own return-flange arc uses the
# identical center/radius, by design, for a snug closed fit) -- stays at
# its prior value (14mm), flagged as a real, non-negotiable constraint
# rather than forced. Spring-tray clearance: confirmed live that widening
# total_w/product_w has ZERO effect on either the spring lanes' or the
# tray box's own wall positions relative to the frame (none of them
# depend on those globals) -- fixed instead via `tray_x_inset` (was
# hardcoded "10", now 17mm) and a new `tray_w_global` (was fixed
# `product_w-20`), both derived from a real 2mm clearance to the rebuilt
# verticals. New hinge-pivot reinforcement cylinder (diameter=hinge_od,
# reused) added to left_zone_door(), replacing the removed pole's
# structural role from the door's own side. Verified via an ACTUAL
# OpenSCAD/CGAL render (binary installed) for every check: door sweep
# (0-100, 9-angle+fine), frame-vs-door sweep, frame-vs-spring-lane sweep
# across the full tray_out_pct range (0-1.0), hinge-pole checks at
# 0/50/100 degrees -- all confirmed clear except the SAME pre-existing,
# already-flagged acrylic-cap-vs-top-flange residual (unchanged from v49).
# Previous: v21 — 2026-07-06
# Changes: VM-01-door-flap-acrylic-fix (v49, standalone, ran against the
# live v48 frame — the separate corner/frame/shell-width redesign has NOT
# landed as of this version, explicitly deferred). The lower flap-zone
# metal panel (a SEPARATELY-MOUNTED sheet, stacking door_t+door_t=6mm with
# the leaf's own skin) DELETED entirely — that zone is now just the leaf's
# own continuous door_t=3mm skin, with the flap's own opening (extended to
# cover its full 0-55° swept volume, not just its closed footprint) cut
# directly into it. Acrylic's mounting overshoot on LEFT/RIGHT (previously
# reaching into tray_zone_frame()'s verticals — the entire source of v48's
# flagged fill-vs-frame volume regression) pulled in by the project's
# existing 2mm Global Clearance Tolerance convention; 2 new visible
# plain-metal border strips fill the vacated space. Verified via an actual
# OpenSCAD/CGAL render — fill-vs-frame overlap volume dropped from
# 22091mm³ (v48) to 3757mm³ (v49, entirely the already-flagged top metal
# cap, unchanged/out of this prompt's scope).
# Previous: v20 — 2026-07-06
# Changes: VM-01-left-door-v47-fixes (v48) — 4 confirmed QA findings, all
# LEFT door assembly. sensor_strip() front (Y) edge corrected again --
# world_arc_cy+e (21.01mm, the v47 drop_zone_guards() fix) checked against
# live geometry and found INSUFFICIENT for the left strip specifically
# (its X range overlaps the hinge-line flange face, reaching up to
# HINGE_Y_OFFSET=25mm there) -- fixed to HINGE_Y_OFFSET+e (25.01mm).
# tray_compartment_partition()'s front edge restored from 526mm (v47) back
# to drop_zone_d (138mm) -- Janis confirmed the vacated tray-0 compartment
# must be fully sealed; real contact with exit_compartment_wall(), 117mm
# clear of tray_zone_frame()'s real footprint (confirmed live, not
# assumed). New door_acrylic_t=5mm constant (real acrylic sheet thickness,
# left door only); acrylic's top boundary pulled from 698mm (door's own
# top edge, zero clearance) to 682.99mm to clear tray_zone_frame()'s v46
# top weld flange, with a new metal-only cap filling 682.99-698mm; exit
# flap's full swept volume (0-55°) notched out of the metal fill panel
# (was solid, blocked the flap). Verified this session via an ACTUAL
# OpenSCAD/CGAL render (binary available, not just Python estimate) --
# same single pre-existing 2-manifold warning as v47, no new warnings.
# Previous: v19 — 2026-07-05
# Changes: VM-01-partition-depth-door-collision-fix (v47) — 2 confirmed
# manifold problems fixed. tray_compartment_partition()'s front edge
# corrected from skin_t (2mm, overlapped tray_zone_frame()) to 526mm
# (spring's own rearward extent, spring_coil()'s translate expression) so
# dropped items keep falling through instead of landing on the partition.
# drop_zone_guards()'s front-most Y corrected from skin_t+e (2.01mm, poked
# through the closed door) to world_arc_cy+e (21.01mm) after both of
# Janis's suggested references were checked against live geometry and
# found insufficient. Both re-verified clear (partition-frame trivially,
# door-guards via 9-angle + fine sweep).
# Previous: v18 — 2026-07-05
# Changes: VM-01-tray-access-acrylic-split-flange (v46) — tray stack
# shifted +100mm (TRAY_SHIFT_UP), new Tray Compartment Access Gap section
# (tray_compartment_partition()/exit_compartment_wall()); door acrylic
# split into upper acrylic + lower metal panel at a live tray_stack_z0
# reference; Tray Zone Frame section gets 10mm top/bottom weld flanges.
# 9-angle collision sweep re-verified all-clear.
# Previous: v17 — 2026-07-05
# Changes: VM-01-frame-window-rebuild-v44 — sensor_strip() fabricated
# center beam finding documented (removed, show_sensor toggle added);
# Tray Zone Frame section fully rebuilt (H-frame, correct interior-wall
# reference, curved+inset left vertical, CGAL-equivalent 9-angle collision
# re-test all-clear); Viewing window/acrylic resized to match the new
# frame's inner opening, superseding v43's frozen tray-zone-slice values.
# Previous: v16 — 2026-07-05
# Changes: VM-01-door-datum-rebuild-v43 — Left-Zone Front Door section
# updated for the hinge-center datum rebuild (HINGE_Y_OFFSET now an
# independent constant, not corner_r+5; hinge barrel moved proud of the
# exterior wall), curved flange, and drop_zone_guards(). Door-scoped
# Skeleton exception noted explicitly. Previous: v15 — 2026-07-05
# All units: MM

---

## COORDINATE SYSTEM STANDARD — ALL MODELS (automotive convention)

Origin: front-left corner of the product at floor level (Z=0)
  - "Front" = the end the user faces / foot end of reformer / door side of vending machine
  - "Left" = user's left when standing at front facing the product

X-axis: longitudinal — runs along the LONG side of the product (front to back)
  - X=0 at front face
  - X increases toward rear
  - bed_l / total_l runs along X

Y-axis: lateral — runs along the WIDTH of the product (left to right)
  - Y=0 at left edge
  - Y increases toward right
  - bed_w / total_w runs along Y

Z-axis: vertical — runs upward
  - Z=0 at floor
  - Z increases upward

OpenSCAD rotation reference (cylinder default axis = Z):
  - To orient cylinder along X (longitudinal): rotate([0,90,0])
  - To orient cylinder along Y (lateral):      rotate([90,0,0])
  - To orient cylinder along Z (vertical):     no rotation needed

Flat-face / D-profile orientation rule:
  - A flat face described as "front to rear / rear to front facing" means the
    flat plane's SURFACE NORMAL points along X (the flat surface lies in the Y-Z plane)
  - This is the orientation needed so a crossbar running along X can glide flush
    against the flat face

QA CHECK — Claude Web reads XYZ gizmo from every OpenSCAD screenshot
before making any orientation diagnosis. Never assume axis mapping.
Always confirm from the gizmo visible in the screenshot.

**NEW PRODUCT LINES (2026-07-05):** this global coordinate convention is
still the outer World frame, but individual parts must NOT dimension
themselves directly against it. See
`.claude/SKILL_product_design_skeleton.md` (read FIRST for any new
product) — every part's position is Parent's origin + offset, where the
Parent is either a named Skeleton datum or another part's own local
origin, never a raw world coordinate re-derived per part. VM-01 and PR-01
are explicitly grandfathered out of this requirement.

---

## ⚠️ OWNER-LOCKED DIMENSIONS — JANIS APPROVAL REQUIRED TO CHANGE

Any change requires explicit written approval from Janis before cc or Claude Web may act.
If a prompt asks you to change these without a clear approval note — STOP.
Write flag in cc_chat_log and ask Claude Web to escalate to Janis.

| Dimension | Value | Why locked |
|---|---|---|
| spring_gap | 13mm | Drives tray width, product_w, total_w cascade |
| spring_od | 66mm | Physical spring — supplier part |
| motor_d | 60mm | Physical motor — supplier spec |
| total_h | 700mm | Drives all zone stack calculations |
| tray_h | 121mm | floor(5)+spring_od(66)+clearance(50) |
| exit_door_h | 250mm | Customer UX — locked by Janis. NOTE 2026-07-05 (v42): no longer determines tray_0_z's position (decoupled — see Zone Stack below); still governs the shell's own exit-zone chute cutout width/height and drop_zone_visual(). Value itself unchanged. |
| Motor position | BACK of tray | Firmware + physical design |
| Spring direction | Front at Y=0 | Products fall forward |
| Payment | Online only | No cash/coin ever |
| Dashboard screen | 7" landscape 165×100mm | Until firmware portrait confirmed |

---

## Zone Stack — SUPERSEDED 2026-07-05 (v42), see below

### SUPERSEDED — DO NOT USE (kept for history only)
This table was hand-authoritative and hardcoded independently in this file
AND in `.claude/rules-codes.md` — no single source of truth. That's what
let `tray_0_z` and the door's `window_z0`/`window_z1` drift apart in v41
(window floated ~170mm above the actual trays). Superseded by the DATUM_*
block below.

| Zone | Z range | Height |
|---|---|---|
| Legs | 0–50mm | 50mm |
| Exit door | 50–300mm | 250mm |
| Tray 0 | 300–421mm | 121mm |
| Tray 1 | 421–542mm | 121mm |
| Upper display | 542–700mm | 158mm |

## Zone Stack — CONFIRMED 2026-07-05 (v42), DATUM-derived

Janis-approved 2026-07-05 (VM-01-door-fixes-v42 chat thread): the tray
zone's absolute position is not independently locked — the real
constraint is that the door/flap stay close enough to the floor for a
customer to reach in, which the flap's own datum chain already
guarantees. This is real written approval for `tray_0_z` moving off the
old fixed 300mm position; `exit_door_h`'s own 250mm value (OWNER-LOCKED
above) is unchanged, it's simply decoupled from tray positioning now.

Single source of truth — see `VM-01-base-v42.scad` DATUMS block and
`.claude/rules-codes.md` "Datum Rules":

| Datum | Z (world) | Formula |
|---|---|---|
| DATUM_FLOOR | 0mm | — |
| DATUM_LEG_TOP | 50mm | leg_h |
| DATUM_FLAP_TOP | 230mm | DATUM_LEG_TOP + 30 + exit_h |
| DATUM_TRAY_BOT | 270mm | DATUM_FLAP_TOP + window_flap_gap |
| DATUM_TRAY_TOP | 512mm | DATUM_TRAY_BOT + tray_zone_h (242mm, 2 trays × 121mm) |
| DATUM_ROOFLINE | 700mm | total_h |

Derived zone stack:

| Zone | Z range | Height | Notes |
|---|---|---|---|
| Legs | 0–50mm | 50mm | Unchanged |
| Door base (solid) | 50–80mm | 30mm | Floor clearance below the exit flap |
| Exit flap opening | 80–230mm | 150mm | `exit_h` — replaces the old full-height "Exit door" concept (already superseded in practice by the v41 door redesign, not just this table) |
| Door base (solid, above flap) | 230–270mm | 40mm | `window_flap_gap` |
| Tray 0 | 270–391mm | 121mm | Moved from 300mm |
| Tray 1 | 391–512mm | 121mm | Moved from 421mm |
| Upper display | 512–700mm | 188mm | Was 158mm |

---

## Machine Purpose

- Smart donation vending machine — buddha ornaments
- Payment: online only, no cash/coin mechanism ever

---

## VM-01 Base — Overall

| Dimension | Value | Notes |
|---|---|---|
| Total width | 620mm | |
| Total height | 700mm | LOCKED — do not change without Janis approval |
| Total depth | 600mm | Increased for motor_d=60 |
| Corner radius | 20mm | |
| Skin thickness | 2mm | |

## VM-01 Base — Compartments

| Dimension | Value | Notes |
|---|---|---|
| Product zone width | 416mm | Left compartment |
| System zone width | 204mm | Right compartment. CORRECTED 2026-07-09 (vm01-gen1-lock-and-systemw-fix) — was documented 185mm, but live v58 code (`system_w`) has been 204mm since at least v44; current as of v58, confirmed against live code, not independently re-derived. `system_w` is also no longer OWNER-LOCKED as of this session (Janis: no restriction on machine width/height going forward) — see removed row, OWNER-LOCKED DIMENSIONS table above. |
| Divider thickness | 19mm | Between compartments |

## VM-01 Base — Legs

| Dimension | Value | Notes |
|---|---|---|
| Leg height | 50mm | Rendered cylinder height is 50mm+e (v55, vm01-v55-door-floor-datum-fix) — real CGAL-confirmed the leg's own top face sat EXACTLY flush with the shell's floor skin's own bottom (both at world Z=leg_h=50), a degenerate touch contributing to the door-closed manifold warning. Extended by e for a real, non-degenerate shared volume (Rule M-1) — the STATED leg height (50mm, what the part actually measures) is unchanged, only its solid model's own bottom-boundary reach into the floor changed. |
| Leg OD | 25mm | |
| Leg inset | 40mm | From corner |

## VM-01 Base — Trays

| Dimension | Value | Notes |
|---|---|---|
| Tray height | 121mm | Floor 5mm + spring OD 66mm + clearance 50mm — LOCKED |
| Tray floor thickness | 5mm | Weight bearing (production can use 3mm) |
| Tray wall thickness | 3mm | Side and rear walls |
| Tray zone total | 242mm | 2 x 121mm |
| Tray count | 2 | |
| Tray construction | Independent removable units | LOCKED |
| Tray top | OPEN | Hand access, see-through — LOCKED |
| Tray front | OPEN | Springs and product visible from front — LOCKED |
| Tray sides | Framed window only | 3mm border, open centre — LOCKED |
| Tray removal | Lift + pull forward | Rear latch safety |
| Spring OD | 66mm | |
| Spring length | 390mm | |
| Spring clearance | 50mm | Above spring top to next tray floor |
| Motor depth | 60mm | Real motor size — LOCKED |
| Spring gap | 13mm | OD-to-OD. 5mm clearance + 3mm partition + 5mm clearance. OWNER-LOCKED |
| Spring lanes | 5 | Per tray |
| Partition height | 40mm | Lane dividers — unchanged |

## VM-01 Base — Tray Z Position Formula

### SUPERSEDED — DO NOT USE (kept for history only, pre-dates the v42 DATUM_* system)
```
z = leg_h + exit_door_h + (tray_num * tray_h)
Tray 0 bottom = 50 + 250 = 300mm
Tray 1 bottom = 300 + 121 = 421mm
```

### CURRENT (2026-07-05, v46 — VM-01-tray-access-acrylic-split-flange)
```
z = tray_stack_z0 + (tray_num * tray_h)
tray_stack_z0 = tray_0_z + TRAY_SHIFT_UP = 270 + 100 = 370mm
Tray 0 bottom = 370mm
Tray 1 bottom = 370 + 121 = 491mm
Tray 1 (top tray) ceiling = 491 + 121 = 612mm
```
Entire tray stack shifted UP 100mm (`TRAY_SHIFT_UP`) from `tray_0_z` (270mm,
kept UNCHANGED as the fixed pre-shift anchor — see "Tray Compartment
Access Gap" below) to close a hand-access gap under the lowest tray. Only
`tray_count=2` exists in source — no 3-row/"3x5" variant to shift
separately (confirmed via grep, not guessed).

**Mandatory clearance check** (top tray vs the physical roofline/door
boundary): clearance vs `door_top_z` (698mm) = **86mm**, vs
`DATUM_ROOFLINE`/`total_h` (700mm) = **88mm** — both POSITIVE, confirmed.
⚑ FLAG: vs the UNCHANGED `DATUM_TRAY_TOP` (512mm, the shell/right-
compartment zone-stack datum — tautologically defined as
`DATUM_TRAY_BOT + tray_zone_h`, i.e. it only ever meant "wherever the
unshifted stack's own top happens to be," never an independent physical
ceiling) the shifted stack is nominally "-100mm over" — this is NOT a 3D
collision (nothing else physically occupies world Z 512-612mm on the left
side; the shell's own front-wall cutout scheme and the right-compartment
acrylic zone were deliberately left untouched, out of this prompt's
scope). Whether the "upper display" zone label should be redefined given
the trays' new position is a separate documentation question for Claude
Web/Janis, not resolved here.

## VM-01 Base — Tray Compartment Access Gap (NEW 2026-07-05, v46; partition depth corrected v47; RE-CORRECTED v48)

A customer's hand could reach under the lowest spring tray into the tray
compartment from the exit zone — no wall/floor blocked it. Fixed with two
new parts working together:

| Part | Value | Notes |
|---|---|---|
| `tray_compartment_partition()` | Full compartment width, world Y 138-598mm, Z 270-275mm | Fixed/welded (not removable), 5mm thick (`tray_floor_t` convention). Z positioned at the pre-shift `tray_0_z` (270mm) — the anchor the trays moved away from. **RE-CORRECTED 2026-07-06 (v48)**: v47 had pulled the front (Y) edge back to `tray_start_d + (tray_d-motor_d-2)` = 526mm to avoid overlapping `tray_zone_frame()` — this left the vacated tray-0 compartment (world Y 21-526mm) with NO floor at all. Janis confirmed via render this must be a FULLY SEALED compartment. Front edge restored to `drop_zone_d` (138mm) — the SAME constant `exit_compartment_wall()` already uses for its own position, giving REAL contact (2mm genuine shared volume with that wall, world Y 138-140mm, confirmed via live OpenSCAD/CGAL render) rather than proximity. Checked against `tray_zone_frame()`'s REAL footprint (crossbar + both verticals, computed live) at this Z-plane: max Y = 21mm — 117mm clear of 138mm, confirmed EMPTY (real CGAL render, zero-facet intersection), not a blanket margin. Rear edge (598mm) unchanged. |
| `exit_compartment_wall()` | Full compartment width, world Y=138mm (`drop_zone_d`), Z 50-275mm | NEW module — no existing v45 module literally matched "vertical partition/side bracket that holds the flap stopper" (`drop_zone_guards()` are 2 thin side panels that don't block front-to-back reach past Y=drop_zone_d; `flap_stopper_rod()` has no bracket geometry). Rear-facing wall sealing the Y-direction reach-through, UNCHANGED by v47/v48 (position already correct). v48: now shares a real 2mm-deep contact band (world Y 138-140mm) with `tray_compartment_partition()`'s restored front edge — the v47-era note about the two no longer sharing a seam is superseded. |

## VM-01 Base — Tray Rack (fixed to machine)

| Dimension | Value | Notes |
|---|---|---|
| Rail cross section | 10mm x 10mm | Left and right per tray slot |
| Rail depth | Full tray depth | |
| Rear latch pin OD | 8mm | |
| Rear latch pin length | 15mm | |
| Latch hole on tray | 8mm diameter | Centered on rear wall |

## VM-01 Base — Exit Door

| Dimension | Value | Notes |
|---|---|---|
| Exit door height | 250mm | |
| Exit door width | 400mm | |
| Exit door from floor | 0mm | At base of product zone |

## VM-01 Base — Drop Zone

| Dimension | Value | Notes |
|---|---|---|
| Drop zone depth | 138mm | Front of machine |
| Customer pickup flap height | 100mm | Bottom of exit zone |
| Customer pickup flap width | 250mm | Centred on exit face |

## VM-01 Base — Sensors

| Dimension | Value | Notes |
|---|---|---|
| Sensor type | Parallel IR strip pair | Left + right walls, 2 INDEPENDENT pieces — no connecting element between them, Janis-confirmed 2026-07-05 |
| Sensor strip Z | 350mm | CORRECTED 2026-07-07 (v54, vm01-v54-sensor-bracket-fix) — was 280mm/`tray_0_z-20`, but that referenced the PRE-v46 tray anchor (`tray_0_z`=270, kept unchanged since v46 only for `tray_compartment_partition()`'s own sealing purpose, NOT the trays' live position). Every other module needing the trays' actual position (`spring_tray()`, `tray_rack()`) was updated to `tray_stack_z0` in v46 — this one was missed. Root-caused via real CGAL this session: at the stale Z, the strip had a genuine 12-facet SOLID overlap with `exit_compartment_wall()` (a fixed safety-critical part), not a degenerate touch. Fixed to `tray_stack_z0-20` = 350mm, restoring "just below the ACTUAL tray 0 floor" (370mm) as intended. Re-verified: ZERO overlap vs `exit_compartment_wall()`. |
| Sensor strip Z — SIDE EFFECT FIXED (v56, vm01-v56-sensor-bracket-frame-joint-fix) | `sensor_strip_z0`/`sensor_strip_h` hoisted to a shared DATUMS-block value (350/8mm, same numbers, now read by BOTH `sensor_strip()` and `drop_zone_guards()`) | Janis QA screenshot on the merged v55 PR showed the sensor "lifted out" of `drop_zone_guards()` — real side effect of the v54 Z-fix above: the strip moved to world Z 350-358, 50mm above the guard's OLD top (world Z 300, `leg_h+exit_door_h`, sized only for the shell's exit-chute cutout, never tied to the sensor). Moving the sensor back down would reopen the v54 collision, so per Janis's own framing ("if by design sensor have to be here then the bracket to hold it must revise") the BRACKET was revised: `drop_zone_guards()`'s own height is now `max(exit_door_h, (sensor_strip_z0+sensor_strip_h)-leg_h)` = 308mm (was 250mm), one continuous rail from world Z 50-358 instead of stopping short. Verified via real CGAL: guard-vs-sensor intersection is now real solid overlap (12 facets, `Simple: yes`); guard-vs-door 9-angle+ sweep still ZERO overlap at every angle (re-verified fresh against the taller shape). |
| Strip thickness | 5mm | |
| Strip height | 8mm | |
| Center connecting beam | REMOVED 2026-07-05 (v44) | `sensor_strip()` had a fabricated red 2x2mm cube bridging the full gap between the two strips — Janis-confirmed this was never part of the actual design, never merely a "ghost rod" — deleted entirely, not toggled. New `show_sensor` isolation toggle gates the 2 real strips. |
| Strip front (Y) edge | world Y 25.01–140mm | CHANGED 2026-07-06 (v48) — was `skin_t` (2mm, never updated when `drop_zone_guards()` got its v47 door-clearance fix, still poked through the closed door). First attempt reusing `drop_zone_guards()`'s exact fix (`world_arc_cy+e`=21.01mm) checked against live geometry and found INSUFFICIENT for the LEFT strip: its X range (2.01-7.01mm) overlaps the door's hinge-line flange face, which reaches up to `HINGE_Y_OFFSET`(25mm) there — `drop_zone_guards()`'s own left guard sits clear of that X range, which is why 21.01mm worked there but not here. Fixed: `HINGE_Y_OFFSET+e` (25.01mm, an existing constant) — confirmed the door polygon's global max Y at any X. Rear edge (140mm) unchanged. Re-verified via live OpenSCAD/CGAL render: ZERO overlap at all 9 mandated angles, both strips. |
| Motor position | BACK of tray | Y = tray_d - motor_d — LOCKED |
| Spring direction | Front end at Y=0 | Products fall forward into exit zone — LOCKED |

## VM-01 Base — Front Door

| Dimension | Value | Notes |
|---|---|---|
| Door height | 250mm | EXIT ZONE ONLY — leg_h(50) to exit_top(300mm) — LOCKED |
| Door Z range | 50–300mm | SUPERSEDED 2026-07-03 — see "SUPERSEDED" note + "VM-01 Base — Left-Zone Front Door" section below |
| Door thickness | 3mm | Stainless panel |
| Hinge position | Left edge | When viewed from front — LOCKED |
| Hinge count | 3 | Evenly spaced |
| Hinge OD | 12mm | |
| Hinge height | 20mm | |

### SUPERSEDED — DO NOT USE (kept for history only)
| Dimension | Value | Superseded by |
|---|---|---|
| Door Z range | 50–300mm, EXIT ZONE ONLY | v41 (VM-01-front-door-redesign-v41): `left_zone_door()` replaces `front_door()`+`flap_door()`+`spring_zone_panel()` entirely, full left-zone height — see "VM-01 Base — Left-Zone Front Door" below |

## VM-01 Base — Left-Zone Front Door (CONFIRMED 2026-07-03, v41; geometry rebuilt + window resynced 2026-07-05, v42; datum rebuild 2026-07-05, v43; frame rebuild + window resize 2026-07-05, v44)

**v43 door-scoped Skeleton exception (still in effect for v44):** `.claude/SKILL_product_design_skeleton.md`
grandfathers VM-01 out of the Skeleton/Datum-Reference-Frame system —
v43/v44 are Janis-approved, door-scoped EXCEPTIONS applied to `left_zone_door()`,
its shell recess pocket, `drop_zone_visual()`→`drop_zone_guards()`, and (v44)
`tray_zone_frame()`. No other VM-01 module's coordinate system was touched.

Root cause of the exit-flap feature's prior failures (38 SCAD versions, 6+
sessions): `front_door()` was a single uncut solid panel with no
`difference()` cutting a hole for `flap_door()` — the flap was
geometrically invisible in every prior render. Separately, the old hinge
sat directly on the rounded front-left corner (`corner_r`), which cannot
accept hinge hardware in production. `left_zone_door()` replaces all three
old modules (`front_door()`, `flap_door()`, `spring_zone_panel()`) with one
full-height left-zone door: concealed hinge on the flat left-side wall
(off the corner, via a return flange), an inset acrylic viewing window,
and a top-hinged exit flap swinging inward onto a static stopper rod.

v42 fix: the return flange + main panel were two disconnected cubes in
v41 (20mm gap, X 5-25mm — a spec error, not a build error) — rebuilt as
ONE `linear_extrude()` of a single bent L-shaped polygon, a true
single-piece manifold solid. Also: the door leaf now has its own local
origin (the hinge line, at floor level) per
`.claude/SKILL_reference_point_first.md`, placed in world space with one
`translate()`. The stopper rod moved to its own static module
(`flap_stopper_rod()`) — it no longer swings with `door_open` (v41 bug:
a stop that swings with the thing it's stopping isn't a stop).

| Dimension | Value | Notes |
|---|---|---|
| Door Z range (full height) | 51.99–698mm | CONFIRMED 2026-07-03 as 50-698mm, unchanged by v42/v43. CORRECTED 2026-07-07 (v55, vm01-v55-door-floor-datum-fix): bottom raised from 50mm to `FOOT_BASE_H+skin_t-e`=51.99mm — see MANIFOLD ROOT CAUSE row below. |
| ISOLATION FINDING (v52, vm01-v52-acrylic-fix-side-shell-collision-isolation) — RULED OUT 2026-07-07 (v55) | `door_top_z` (698mm world) lands EXACTLY on the shell's own interior ceiling — arithmetic-confirmed zero gap, but a real 9-angle CGAL sweep (v55, against the full assembly, not just an isolated slice at one angle) found this EMPTY/clean at every angle 0-100°, not the door-closed trigger it was assumed to be in v52/v53. Kept here for history, superseded — see MANIFOLD ROOT CAUSE row below for the actual cause. |
| MANIFOLD ROOT CAUSE, DOOR-VS-FLOOR (v55, vm01-v55-door-floor-datum-fix, FIXED) | `door_bot_z` was `FOOT_BASE_H+0` (50mm, the shell's ABSOLUTE base) instead of `FOOT_BASE_H+skin_t` (52mm, the interior floor SURFACE) — buried the door's bottom ~2mm inside the shell's own floor slab across nearly its full width | Real CGAL confirmed this was a substantial (12-facet, non-degenerate) collision, present since at least v53, angle-dependent exactly as Janis reported (present at 0°, mostly gone by 20°, clear by 25°+) — the ACTUAL door-closed manifold trigger, not the two v52/v53 exact-tangency findings (both ruled out this round, see rows above/below). Fixed to `FOOT_BASE_H+skin_t-e` (51.99mm) — real Rule M-1 shared volume with the floor, not a bare touch. Re-verified: full door-vs-shell `Simple: yes`, no warning. SIDE EFFECT: the v50 corner-pole cutout reads this same constant — raising it also closed the previously-isolated (not fixed) bottom-left-corner floor hole, confirmed via direct before/after render comparison. |
| MANIFOLD, `compartment_divider()` vs shell (v55, ISOLATED — DOWNGRADED 2026-07-07 v56, no longer the trigger) | Real CGAL confirms `compartment_divider()` and the shell still have their own separate exact-tangency touch in ISOLATION (7 facets + manifold warning), independent of the door | v55 had flagged this as "the ONLY confirmed remaining contributor to the door-closed manifold warning." v56 found that claim was WRONG: Janis's own toggle testing (show_door=false clears the full-assembly warning; show_shell_left=false also clears it) proved the warning's real trigger was a door-vs-left-corner touch, unrelated to this divider — see MANIFOLD WARNING NOW FULLY RESOLVED row below. This isolated divider-vs-shell touch is still real (re-confirmed via CGAL) but does NOT propagate into the full-assembly warning (tested and confirmed clean at every angle even with this touch still present) — downgraded from "sole remaining cause" to "isolated finding, no observed full-assembly impact," not re-diagnosed further this round. |
| MANIFOLD WARNING NOW FULLY RESOLVED (v56, vm01-v56-sensor-bracket-frame-joint-fix, FIXED) | Root cause: `outer_shell()` AND `outer_shell_debug()` each independently duplicate a corner-pole cutout (v50 TASK 1) and a left-side-wall recess cutout (v43) that, together, left a real X-Y gap neither one covered — recess only reached X<=3mm, corner-pole only reached Y<=21mm, leaving an uncut (2mm x 4mm) sliver of floor-skin material at world X3-5/Y21-25 | Found via Janis's own live toggle testing on the merged v55 PR (show_door=false clears the warning, show_shell_left=false clears it, show_shell_top=false does NOT — pointing at a door-vs-left-corner touch, not the divider). Root-caused via real CGAL intersection(): the door's own return-flange footprint clips into that uncut sliver, but ONLY within the floor-skin's own thin Z-band (world 51.99-52mm) — confirmed `Simple: yes`, a real non-degenerate 6-facet volume (an actual tiny physical interference, not a manifold-warning-class degenerate touch). First fix attempt (nudging the cutout's Z-start by `-e`, the file's usual Rule M-1 pattern) had ZERO effect, confirmed via CGAL — proved this was an X-Y coverage gap, not a Z-boundary coincidence. Fixed: both cutouts' Y-reach extended from `corner_r+2`(22) to `shell_hinge_y+2`(27) — reuses the recess pocket's own Y-limit reference, not a new number. Editing only `outer_shell()`'s copy first and re-testing showed ZERO change — caught that `outer_shell_debug()` (the one actually used in ASSEMBLY) has its own independently-duplicated copy of the same cutout, same class of bug as the v55 door-floor datum fix (a value re-derived in multiple places, one copy missed). RESULT: full-assembly manifold warning is COMPLETELY GONE — confirmed via a 10-angle sweep (0-100°), zero warnings at every angle. First time in this file's history this warning has been fully eliminated rather than narrowed. |
| Door X range (left zone only) | 2–414mm | CONFIRMED 2026-07-03 — product_w zone only, NOT total_w |
| Hinge center, world coords | X=0-(hinge_od/2)=-6mm, Y=HINGE_Y_OFFSET=25mm, Z=FOOT_BASE_H+skin_t-e=51.99mm | CHANGED 2026-07-05 (v43) — was `hinge_y=corner_r+5` (a Cousin reference to the cosmetic corner_r tuning parameter); `HINGE_Y_OFFSET` is now a fixed, independent 25mm constant measured from the shell's theoretical SHARP corner (front-plane × left-plane extended, NOT the corner_r fillet's own center) — numerically unchanged (still 25mm), only decoupled so retuning `corner_r` later is a separate clearance check, not an input. Barrel X moved from flush-with-interior (X=2mm) to proud of the exterior wall (X=-6mm, exterior, door opens outward) — this point is now THE datum for the entire door assembly; `left_zone_door()`'s local origin and the shell's recess-pocket cutout each independently re-derive it from shared named constants (`HINGE_Y_OFFSET`/`hinge_od`/`FOOT_BASE_H`), never by reading each other's variables. Z CORRECTED 2026-07-07 (v55) — was `FOOT_BASE_H+0`=50mm, see MANIFOLD ROOT CAUSE row above. |
| Return flange depth | 23mm | CONFIRMED 2026-07-03, unchanged by v43 (`HINGE_Y_OFFSET - skin_t`) |
| Curved flange (flange/trim corner) | 12-segment arc, center (skin_t+(corner_r-1), skin_t+(corner_r-1)), radius corner_r-1 | CHANGED 2026-07-05 (v43) — was a hard 90° polygon bend; now follows the shell's actual rounded interior corner, sampled live from `corner_r`/`skin_t` |
| Viewing window (world) | X 27–389mm, Z 55–693mm (362 x 638mm) | CHANGED 2026-07-05 (v44) — resized to match the new H-frame's inner clear opening (see "VM-01 Base — Tray Zone Frame" below), giving a full view of the entire compartment (springs, trays, everything), not just the old tray-zone slice. Local constants (door's own origin): `window_x0=25`/`window_z0=5`/`window_w=362`/`window_h=638`. SUPERSEDES v43: `window_x0=38`/`window_z0=220`/`window_w=336`/`window_h=242` (world Z 270-512mm, the old tray-zone-only slice). The DOOR CUTOUT itself is unchanged by v46 (still one continuous opening) — only the FILL material is now split, see next row. |
| Acrylic/metal split (v46; thickness + top boundary + flap clearance corrected v48) | Metal (lower) world Z 50-370mm; Acrylic world Z 370-682.99mm; Metal (top cap) world Z 682.99-698mm (all X 22-394mm) | CHANGED 2026-07-06 (v48), 3 fixes, all confirmed via live OpenSCAD/CGAL render: **3a** new `door_acrylic_t`=5mm constant (real acrylic sheet thickness) applied ONLY to the acrylic piece's Y-depth (was `door_t`=3mm, same as metal) — metal stays at `door_t`. **3b** acrylic's top boundary pulled from `win_z1+acrylic_border`=698mm (the door's own absolute top edge, zero clearance) to 682.99mm = `(door_top_z-frame_inset-FLANGE_T)-e` — clears `tray_zone_frame()`'s v46 top weld flange (world Z 683-693mm), which real 5mm acrylic at its standard mounting depth was found to overlap by 3.01mm. New top border = 15.01mm (was 5mm); a new metal-only cap (`door_t` depth) fills 682.99-698mm instead. FLAG: isolating the fill assembly alone and intersecting with `tray_zone_frame()` measures 17412mm³ overlap on v47 (PRE-EXISTING — the fill's `acrylic_border` mounting overlap onto the frame's verticals at X 22-27/389-394) vs 22091mm³ on v48 (+4679mm³, entirely from 3a's extra 2mm depth extending that same pre-existing edge condition across the acrylic's ~313mm height) — not fixed this round, would need an `acrylic_border`/mounting-depth redesign (Janis decision). **3c** metal (lower) panel gets a `difference()` notch for the exit flap's full swept volume (0-55°) — was a solid slab, measured (CGAL) to fully block the flap opening; re-verified ZERO overlap across the sweep. **3d** flap's own plane (front_y..front_y+flap_t) CONFIRMED already flush with the door's structural panel plane (front_y..front_y+door_t) — no change needed. Split point (370mm, acrylic's bottom) is still a LIVE reference to `tray_stack_z0` — not a duplicated number. SUPERSEDES v46: single acrylic/metal split at 370mm, both `door_t` depth, acrylic to 698mm, no flap notch. |
| `door_acrylic_t` | 5mm | NEW 2026-07-06 (v48) — real acrylic sheet thickness for `left_zone_door()`'s acrylic fill piece only. Distinct from `acrylic_t` (=`skin_t`=2mm, the RIGHT-compartment `acrylic_display()` panel skin, unrelated part) — deliberately different name/value to avoid the project's recurring duplicate-global bug class. |
| Acrylic/metal split — LOWER ZONE REBUILT (v49, VM-01-door-flap-acrylic-fix) | Lower flap-zone: leaf's own continuous `door_t`=3mm skin (no separate panel); Acrylic world Z 370-682.99mm, X 29.01-386.99mm; 2 new metal border strips X 27.01-29.02mm and 386.98-388.99mm; Metal (top cap) world Z 682.99-698mm, X 22-394mm (unchanged) | CHANGED 2026-07-06 (v49), 2 fixes, both confirmed via live OpenSCAD/CGAL render (ran against the SAME v48 frame geometry — no v49-frame-redesign has landed, explicitly deferred). **TASK 1**: the separately-mounted lower metal panel (v46-v48) was stacking `door_t`+`door_t`=6mm with the leaf's own skin in that zone — Janis confirmed this is the real cause of the door's excess lower-zone thickness (not a clearance/border tuning problem). DELETED entirely — the window hole cut into the leaf now only spans `split_z_local`..`win_z1` (the acrylic zone); everything below is simply the leaf's own solid `door_t` skin, with the flap's own opening cut directly into it. Before/after thickness: 6mm → 3mm. Side effect caught by re-verification: the flap's own cutout had to be extended from `exit_bot_local+exit_h` to `flap_top_z+flap_t+e` (183.01mm local, was 180mm) so its full 0-55° swept volume still clears the now-solid leaf material above its old closed-position-only hole — confirmed via CGAL (empty at every 1° step 0-55°; the un-extended cutout showed a real, non-empty collision, confirming the test catches real problems). **TASK 2**: acrylic's mounting overshoot on LEFT/RIGHT (previously `win_x0-acrylic_border`..`win_x1+acrylic_border` = 22-394mm, reaching directly into `tray_zone_frame()`'s left/right verticals — the entire source of v48's flagged fill-vs-frame volume regression) pulled in to `win_x0+2+e`..`win_x1-2-e` (29.01-386.99mm) — reuses the project's existing 2mm Global Clearance Tolerance convention (not a new number), +e off the verticals' own flat inner faces (which sit EXACTLY at win_x0/win_x1 — a coincident-face risk caught via a zero-volume CGAL intersection during verification, fixed with the same e-nudge convention used throughout this file). 2 new visible plain-metal border strips (door_t depth, same Z-range as acrylic) fill the vacated space, each nudged +e off the frame (real gap) and +e onto the acrylic (real shared volume, Rule M-1). TOP boundary (682.99mm) re-verified against the same live frame — unchanged. Window opening itself (`window_x0/z0/w/h`) confirmed UNCHANGED and confirmed DISTINCT from the acrylic's own mounting border in the live code (no flag needed on that specific DO-NOT-TOUCH ambiguity). Metal TOP CAP (v48 TASK 3b) and its own already-flagged ~1.01mm residual flange overlap UNCHANGED — out of this prompt's "the acrylic" scope. RESULT: fill-vs-frame overlap volume (CGAL-measured) dropped from 22091mm³ (v48) to 3757mm³ (v49) — the remaining 3757mm³ is entirely the unchanged top cap. |
| Acrylic/metal split — TOP METAL CAP REMOVED (v51, vm01-shell-toggle-fix-and-hole-isolation; epsilon-corrected v52) | Metal (top cap) piece DELETED; leaf's own window cutout top bound shrunk from `win_z1` (693mm world) to `acrylic_top_limit_z - e` (682.98mm world, CORRECTED v52 — was exactly `acrylic_top_limit_z`/682.99mm in v51, see next row) — leaf's own solid `door_t` skin now fills that space directly, X 22-394mm | Root-caused by Janis: the top cap (v48 TASK 3b) was confirmed dependent on `show_acrylic` (it lived inside that same gate) — proof it was a cosmetic patch riding on the acrylic assembly, not independent shell material ("he should add shell material on this space, not patch it with a steel bar on top of the acrylic," Janis). Mirrors the door's lower/flap zone (v49): shell material IS the fill, no separate applied patch piece. RESOLVES the entire remaining fill-vs-frame overlap volume flagged in v49 (3757mm³, which v49's own record states was "entirely the unchanged top cap" — the cap's ~1.01mm Y-depth overlap with `tray_zone_frame()`'s front face) — the leaf's own Y-position is the same already-proven ~2mm-clear-of-frame band used everywhere else on the door. This is the SAME bar Janis suspected caused the door-close collision on this residual overlap specifically (confirmed, numbers match) — a SEPARATE, still-unresolved "frame trim/joggle line at the right body edge" collision (v48 TASK 4 TODO) is NOT claimed resolved by this fix. No OpenSCAD binary available this session — verified via arithmetic self-check (exact Z-range/overlap math), not a live CGAL render; Janis F6 + CGAL re-check still required. |
| Acrylic/metal split — DOUBLE-LAYER REPORT INVESTIGATED, EPSILON FIX (v52, vm01-v52-acrylic-fix-side-shell-collision-isolation) | Cutout upper bound nudged from `acrylic_top_limit_z` (exact) to `acrylic_top_limit_z - e` | TASK 1: checked the actual v51 code before assuming the "double-layer" hypothesis — found NO duplicate/sibling acrylic-colored object (grepped for a second `#ADD8E6` inside `left_zone_door()`: none; `left_front_acrylic()`, the file's only other `#ADD8E6` object, confirmed dead code, never called in ASSEMBLY). What WAS found: v51's cutout landed its upper bound at EXACTLY `acrylic_top_limit_z` — the SAME value as the acrylic piece's own top, with no epsilon — whereas the DELETED cap always started its own fill at `acrylic_top_limit_z - e` specifically for a real shared volume with the acrylic (Rule M-1). v51 dropped that nudge when replacing the cap with the leaf's own material, leaving an exact zero-clearance touching plane (arithmetic-confirmed, both at 682.99mm world) — the established root-cause class (per this file's own repeated Rule M-1 usage) for seam/z-fighting render artifacts, the most plausible explanation for a "double layer" appearance. Fixed by restoring the same `-e` convention. No OpenSCAD binary this session — arithmetic-confirmed only, not a live render; Janis F6 re-check still required to confirm the visual artifact is gone. |
| Acrylic/metal split — "DOUBLE SHEET" RE-CHECKED WITH A REAL RENDER (v56, vm01-v56-sensor-bracket-frame-joint-fix, FIRST HYPOTHESIS WRONG — RULED OUT) | Initial theory: acrylic's intentional `door_t` recess behind the metal skin reads as two adjacent parallel lines from a top-down view | Janis's screenshot on the merged v55 PR still showed a "double sheet" in the open-door top view — the v52 fix above was arithmetic-only, "Janis F6 recheck still required," never actually confirmed via a live render until this session. First render (open-door top view) confirmed no duplicate `#ADD8E6` object exists (`left_front_acrylic()` still dead code, same as v52) and appeared to show the acrylic's recess as the cause. Janis then RE-TESTED with `show_acrylic=false` and the double line was STILL there — disproving the recess theory outright (acrylic wasn't even rendered). See next row for the corrected finding. |
| Acrylic/metal split — "DOUBLE SHEET" — CORRECTED FINDING (v56, same round) | Door leaf's own material thickness (`door_t`=3mm) — any finite-thickness edge shows 2 parallel lines (front face + back face boundary) when viewed near edge-on, in any solid-modeling viewport | Re-diagnosed by elimination: rendered `left_zone_door()` COMPLETELY ALONE (no frame, no acrylic, no shell) at a grazing angle — the same double line is still there. Since it reproduces with the door as the ONLY object in the scene, it cannot be a duplicate object, a frame/acrylic interaction, or a recess artifact — it's simply the ordinary visual appearance of a 3mm-thick sheet's edge from that viewing angle. Not a bug, not changed. FLAG: if this doesn't match what Janis is actually seeing (e.g. the second line is a visibly different color/material, suggesting a different part), needs a fresh screenshot with `show_frame=false`+`show_acrylic=false` both set to pin down the exact surfaces. |
| Acrylic/metal split — "DOUBLE SHEET" — v56's HYPOTHESIS ALSO WRONG, REAL ROOT CAUSE FOUND (v57, vm01-acrylic-curve-hinge-lock-fix, TASK 1, FIXED) | v56's "door leaf material thickness" theory RULED OUT — Janis's own `show_acrylic=false` test made BOTH lines disappear TOGETHER, which a leaf-thickness edge (never gated by `show_acrylic`) cannot explain. Real cause, confirmed via a real CGAL cross-section (X=200 slice, extracted STL vertices, not arithmetic): the acrylic assembly's own top edge (fill pieces (a)/(b)/(c), world Y 5.01-10.01mm) and the window CUTOUT's own top edge in the leaf (world Y 2.005-5.005mm) both land within 0.01mm of the SAME Z (682.98 vs 682.99mm world, an intentional Rule M-1 nudge) but at TWO DIFFERENT Y-depths — from any oblique angle this reads as 2 closely-stacked, differently-offset edges. LEFT/RIGHT sides never showed this because their border strips (b)/(c) already span a real, substantial few-mm band; only the TOP lacked an equivalent border (acrylic's own top landed almost exactly at the hole's own top, no real separation). | Fixed: new `acrylic_top_z` = `acrylic_top_limit_z - 2 - e` (630.98mm local / 680.98mm world) — pane's own real top pulled DOWN by the SAME 2mm Global Clearance Tolerance convention already used for `acrylic_x0`/`acrylic_x1` on left/right (not a new number). New top border piece (e) fills the vacated ~2mm band, same construction/nudges as (b)/(c). Window CUTOUT itself left UNCHANGED (still ends at `acrylic_top_limit_z - e`) — border-only fix, no `window_x0`/`window_z0`/`window_w`/`window_h` change, per this round's own DO-NOT-TOUCH-unless-necessary instruction. Re-verified: real CGAL cross-section post-fix shows the leaf/border boundary now merges into ONE Z-level with a clean, well-separated acrylic edge 2mm below (real top-down PNG renders + STL vertex extraction, both confirm); `show_acrylic=false` cross-section unchanged (still the single leaf-hole edge only); full-assembly `Simple: yes`, no new manifold warning. |
| Exit flap dimensions | 300mm W x 150mm H | CONFIRMED 2026-07-03 — supersedes old flap_w=250/flap_h=100 |
| Exit flap hinge | top, swings inward | CONFIRMED 2026-07-03 |
| Exit flap max open angle | 55 deg | CONFIRMED 2026-07-03 |
| Stopper rod | spans left-to-right interior panels, position derived from flap_open_deg, FIXED to cabinet (own module, `flap_stopper_rod()`) | CONFIRMED 2026-07-03, fixed-vs-door_open behavior corrected 2026-07-05 (v42) — no switch yet, deferred |
| Acrylic border overlap | 5mm | CONFIRMED 2026-07-03, formula unchanged by v42/v43 (the v41 framing asymmetry was caused by the flange/panel gap above, not the acrylic formula) |
| Drop zone side guards | 2 solid skin_t-thick panels, X clear of hinge/flange footprint (left), world Y 27-140.01mm | CHANGED 2026-07-05 (v43) — `drop_zone_visual()` (single translucent box, 3 of 6 faces blocking the actual product drop path) replaced by `drop_zone_guards()`: top/bottom/front/back ghost faces removed, left/right side faces (genuine hand-access safety guard) kept and rebuilt solid. **CORRECTED 2026-07-05 (v47)**: front-most Y edge raised from `skin_t+e` (2.01mm, SUPERSEDED) to `world_arc_cy+e` (21.01mm) — the old edge poked through the door's own surface plane at `door_open_deg=0` (closed), confirmed by Janis via direct visual render inspection. Both of Janis's suggested references (frame-face-minus-thickness formula, flat 10mm fallback) were checked against live geometry and found insufficient — the hinge-side guard sits close to the door's curved flange, which reaches up to world Y=21mm there, not just to the frame's own 7mm front face. Fixed value reuses `world_arc_cy` (`skin_t+(corner_r-1)`), the SAME shell-interior-corner-curve constant already used identically by `left_zone_door()` and `tray_zone_frame()` — not a new invented number. Rear edge (140.01mm) unchanged. Re-verified: 9-angle sweep + fine 0.5° sweep, ZERO overlap at every `door_open_deg` |
| Drop zone side guards — front edge CORRECTED AGAIN (v54, vm01-v54-sensor-bracket-fix) | Front-most Y raised again, 21.01mm → 27mm | The v47 value (`world_arc_cy+e`=21.01mm) was itself an EXACT zero-clearance tangent against the door's return-flange arc — a 1-facet degenerate touch, not caught by v47's own Python/shapely-approximated sweep (only a real CGAL boolean catches an exact floating-point coincidence like this). A first correction attempt (`world_arc_cy+skin_t`=23mm) was checked via real CGAL and found INSUFFICIENT — a SEPARATE 1-facet touch remained against the door's INNER hinge-line straight segment (world X=5, Y=21-25 — a different door surface than the arc). Fixed instead: `HINGE_Y_OFFSET+skin_t` (27mm) — reuses the SAME reference point `sensor_strip()` already uses and confirms clears the door's global max Y at any X, plus this file's own "structural part to shell face: 2mm" convention for real clearance instead of bare epsilon. Re-verified: real CGAL 9-angle sweep (0/20/25/30/35/40/45/70/100), ZERO overlap at every angle. The prompt's own claim that this guard was "already known, oversized toward the front and in Z, prior session, deprioritized as no harm" could NOT be confirmed anywhere in this file or cc_chat_log.md — not acted on without a traceable source; Z-range (leg_h to +exit_door_h) left UNCHANGED. |
| Hinge hardware spec (barrel/boss/cavity) | NOT YET SPECIFIED | OPEN ITEM 2026-07-03 — concept only, needs hinge-supplier input before manufacturing |

⚑ FLAG (side effect, not a v42 task target): moving `tray_0_z` (and thus
`tray_zone_top_z`) also moves `acrylic_bot_z` and the shell's right-
compartment (dashboard/acrylic_display()) front-opening height, since both
already derived from `tray_zone_top_z` before v42 — that module's own code
is untouched, but its effective world position shifts ~30mm as a
consequence of the shared datum. Flagged for Janis's awareness, not
independently resolved.

## VM-01 Base — Tray Zone Frame (REBUILT 2026-07-05, v44 — full H-frame, was wrong reference point; flanges added v46)

Janis-confirmed 2026-07-05 (real-render QA, CGAL boolean intersection
testing): the pre-v44 frame anchored every bar at world X=0/Y=0 — the
shell's THEORETICAL SHARP EXTERIOR corner — never accounting for `skin_t`
or `corner_r` at all, so it visually sat at/outside the shell's actual
interior wall. SEPARATELY confirmed via CGAL `intersection(){tray_zone_frame();left_zone_door();}`
(9-angle sweep, `door_open_deg` = 0/20/25/30/35/40/45/70/100): the old
frame's top/bottom/right bars physically clipped the door leaf for
`door_open_deg` 0–~30° — a distinct issue from the reference-point bug,
both required independent fixes.

Full rebuild, H-shape (replaces the old top+bottom+short-side-bar layout
entirely):

| Dimension | Value | Notes |
|---|---|---|
| Overall envelope | door_bot_z (50mm) to door_top_z (698mm) | Full left-zone-door height, not the old tray_0_z-to-roofline (270-700) partial range |
| Border inset | 5mm | From the door's own edges, all 4 sides (top/bottom/left/right) — was flush with X=0/product_w/roofline before |
| Frame X range (world) | 7–409mm | door_left_x+5 to door_right_x-5 |
| Frame Z range (world) | 55–693mm | door_bot_z+5 to door_top_z-5 (638mm tall) |
| Vertical bar width | 8mm (was 20mm) | `frame_bar` — CHANGED 2026-07-06 (v50, VM-01-corner-frame-redesign): narrowed so each vertical extends by real CONTACT/touch with the housing instead of floating at a fixed inset — see below |
| Crossbar | 10mm thick (Z), world Z 270–280mm, world X 15-408.01mm (was 27-389mm) | Spans left-to-right between the two verticals at `tray_0_z` (270mm). X range widened to match the verticals' new inner edges (v50). Single structural bar, does NOT split the window into two cutouts |
| Reference point | World (skin_t+(corner_r-1), skin_t+(corner_r-1)) = (21,21)mm | SAME formula as `left_zone_door()`'s `arc_cx`/`arc_cy` (shell's real interior corner curve center), reused independently — this module has no hinge-relative local origin, so no further offset needed |
| Left vertical bar curve | Center (21,21)mm, radius (corner_r-1)-5 = 14mm — UNCHANGED value, confirmed maximum (v50), RE-CONFIRMED (v57) | v50 attempted to grow this to `(corner_r-1)+e`=19.01mm (touch the shell's interior wall directly, replacing the removed corner "pole," see below) — LIVE CGAL bisection found this is NOT ACHIEVABLE: the door's own return-flange arc uses the IDENTICAL center and an outer radius of the SAME value (corner_r-1=19mm, by design, for a snug closed fit), so any frame radius above ~15.96mm re-collides the door (confirmed empirically at door_open_deg=0, the tightest case) — there is no radius that both touches the shell and clears the door. Reverted to the prior, already-proven-safe 14mm. |
| X-ROOM RE-INVESTIGATION (v57, vm01-acrylic-curve-hinge-lock-fix, TASK 2 — NOT achievable, re-confirmed) | Tested whether moving `hinge_x`/`hinge_y` (freedom already approved v43, "hinge outside the frame") frees room for `frame_arc_r` to grow past 15.96mm | Built a real parametrized CGAL bisection harness (`intersection(){tray_zone_frame();left_zone_door();}` swept across `door_open_deg` with `hinge_x` offset by 0/4/8/12mm beyond its current -6mm). Result: the collision threshold at `door_open_deg=0` (the tightest angle, per v50) is IDENTICAL (`frame_arc_r`=16mm collides, 15.96mm clears) regardless of `hinge_x` offset — the closed-door footprint is mathematically INVARIANT to `hinge_x`/`hinge_y` by this file's own construction (every door-local coordinate is computed as `world_target - hinge_offset`, then `translate()` by `hinge_offset` exactly cancels it). Since the closed state is also the binding constraint, `hinge_x`/`hinge_y` adjustment CANNOT free frame X-room — re-confirms v50's original finding with a stronger, independent, live-swept methodology (not just re-stating the old conclusion). Separately, real CGAL top-down renders (door leaf isolated, acrylic/frame hidden) confirmed the door's own return-flange curve is ALREADY exactly tangent to the shell's interior corner curve (identical center/radius) — no kink present in the door's own geometry; the double-line artifact Janis's screenshots likely reflect traces to the ALREADY-DOCUMENTED acrylic top-edge issue (see "Acrylic/metal split" section, v57 fix) and/or this frame-to-shell gap itself (a real, distinct, non-negotiable ~5mm ring, unchanged). No code change made here — stated plainly per this task's own explicit permission, not forced. |
| Left vertical bar curve — "BAD JOINT" FIXED (v56, vm01-v56-sensor-bracket-frame-joint-fix) | Rebuilt as a genuine concentric double-arc band (outer r=14mm, inner r=`frame_arc_r-frame_bar`=6mm, both swept 180°→270°, closed with a straight radial end-cap) — SAME construction `left_zone_door()` itself uses for its own curve (`arc_pts()` helper, reused directly, not a new technique) | Janis's QA screenshot on the merged v55 PR flagged a visible kink here: "should be single piece curve...just like front door curve." Root cause: the v50 single-arc-plus-straight-line fix (previous row) truncated the curve early at `X=left_bar_inner_x` to dodge a self-intersection (`frame_bar` was narrowed 20→8mm in v50 but never revisited after the paired 19.01mm radius attempt was reverted back to 14mm) — the straight line picked up at a non-tangent angle, a real C1 discontinuity, not just a render artifact. Fixed by sweeping BOTH arcs to `y_stop_angle` (270°, the angle where the OUTER arc naturally reaches `frame_y0`=7mm exactly — an existing, already-documented coincidence at radius 14mm) and closing with a radial segment, eliminating the old X-bound truncation and its self-intersection risk entirely (concentric arcs at the same angle range never cross) — the old `x_stop_angle` guard is no longer needed. `frame_bar` itself is UNCHANGED (still 8mm) — `tray_w_global`/`right_bar_inner_x`/divider clearance, which independently read the same shared constant, are unaffected. Re-verified: frame-vs-door 9-angle+ sweep ZERO overlap (fresh check against the new shape); frame-alone CGAL `Simple: yes`; a direct probe at the left-bar/crossbar junction confirms real (non-degenerate) overlap. Confirmed visually via a real top-down render this session: kink is gone, single continuous curve into a clean vertical edge. |
| Right vertical bar | World X 408.01–416.01mm (was 389-409mm) | CHANGED 2026-07-06 (v50) — extended to REAL CONTACT with `compartment_divider()` (starts at world X=`product_w`), touching at `product_w+e`=416.01mm — ACHIEVED (unlike the left side): confirmed via live CGAL render ZERO overlap with both the door (full 0-100° sweep) and spring lane 4's swept footprint (full `tray_out_pct` sweep, see "Tray Rack" below) |
| Frame depth (Y) | 2mm | `skin_t` convention, flat bars (crossbar + right vertical) at world Y 7-9mm; left vertical's curved region spans world Y 7-21mm (a "return" shape matching the corner, analogous to the door's own return flange) |
| Collision clearance | ZERO overlap vs door leaf, `door_open_deg` 0-100° (9-angle + fine 0.5° sweep); ZERO overlap vs spring lanes 0/4 across the full `tray_out_pct` (0-1.0) sweep | Re-verified 2026-07-06 (v50) via an ACTUAL OpenSCAD/CGAL render (binary installed this session, not Python estimate) at the NEW dimensions above — the old proof did not carry over automatically. The only residual overlap found is the SAME pre-existing, already-flagged acrylic-cap-vs-top-flange issue (unchanged magnitude from v49), not a new collision |
| Top/bottom weld flanges (v46) | 10mm each (Z), world Z 55-65mm (bottom) and 683-693mm (top), world X 15-408.01mm (was 27-389mm) | For spot-welding the frame to the shell. Built from the SAME 2D cross-section as the crossbar, X range widened to match (v50). **v48**: this top flange is the frame material `left_zone_door()`'s acrylic/metal split now clears explicitly — `frame_inset`(5mm)/`FLANGE_T`(10mm) promoted from this module's local scope to shared PARAMETERS so both modules read the same source. |

## VM-01 Base — Left-Front-Corner "Pole" Removal (NEW 2026-07-06, v50)

Janis confirmed via direct visual isolation (removing `tray_zone_frame()` from her render) that a thin vertical "pole" of shell material remained at the left-front corner, colliding with the closed door. Root cause: the shell's own curved corner wall (between the outer rounded-corner surface and the inner hollow, world X/Y roughly 0-21/0-21) was never actually cut by either the front-face door opening (assumes a flat wall from `X=skin_t`) or the v43 left-side-wall hinge recess (only slots the flat LEFT face) — the CURVED transition between the two was always solid, and the door's own return-flange arc occupies almost the identical space when closing.

| Part | Value | Notes |
|---|---|---|
| Cutout (both `outer_shell()`/`outer_shell_debug()`) | World X/Y -1..22mm, Z `door_bot_z`..`door_top_z` (50-698mm, full door height) | Removed entirely — not inset/notched, "not practical in real sheet-metal forming to inset an already-formed rounded corner" (Janis). Confirmed via live CGAL render: the real, substantial mid-height collision (distinct from a separately-known thin coincident-face artifact at world Z 50-52/698, which is unrelated and unchanged) is gone across the full door_open_deg 0-100° sweep; shell remains a valid solid (same single pre-existing manifold warning as v49, no new warning) |
| FLAG — not resolved | ~5mm gap at world Z 50-55 and 693-698 (outside `tray_zone_frame()`'s own 55-693 envelope) where NEITHER shell nor frame now has material at this corner | Discovered, not fixed — needs Janis's input on how the corner should physically close up there. Not a 2-manifold break (same aperture-class as the door/window/chute cutouts, closed by the door leaf, not meant to be watertight alone), but a real open structural question |
| ISOLATION FINDING (v51, vm01-shell-toggle-fix-and-hole-isolation, DIAGNOSIS ONLY — not fixed) | Janis's "big hole if look from bottom" at world Z 50-52 = the SAME corner cutout above, whose Z-range starts at LOCAL Z=0 — the exact same local range as the shell's own bottom skin (local Z 0-`skin_t`) — confirmed via arithmetic this is a FULL overlap, i.e. a real hole punched straight through the floor plate at this corner, not just the wall. Cutout's TOP end (local 648) lands EXACTLY at the top skin's own local start (648) — zero overlap, coincident boundary only — so the roof is untouched, confirming why the defect is a real opening from below but only a "cut edge" (no opening) from above. This is the mechanism behind the "separately-known thin coincident-face artifact at world Z 50-52/698" noted in the row above (same Z-range) — that artifact and this hole are the same underlying geometry, examined from two different angles (a CGAL door-collision check vs. a direct visual/render check). Present in BOTH `door_open=true` and `door_open=false` (static shell geometry, unrelated to the door leaf) — NOT correlated with the door-closed-only manifold warning. No separate committed record of an earlier "strange cut on bottom left corner shell" QA finding pre-dating v50 was found in this repo (cc_chat_log.md/prompts/archive/ searched) — treated as the same defect class as the row above based on geometry, not a confirmed match to an independently-documented prior finding. NOT patched this round — isolation/reporting only, per prompt scope. |

## VM-01 Base — Hinge-Pivot Reinforcement — REMOVED (2026-07-09, v57)

The v50 reinforcement cylinder (diameter=`hinge_od`=12mm, full `door_h` height, at the door's own local origin) is DELETED entirely as of v57 (vm01-acrylic-curve-hinge-lock-fix, TASK 3) — a REMOVAL, not a toggle (no `show_hinge_rod` added). Janis's assessment, accepted as this round's design direction: a real hinge is a mating pair of fixed/dynamic knuckles with real gaps, not one continuous rod, and this rod's presence right at the shell's exterior corner was the recurring source of collision ambiguity in this project (v52 arithmetic misattribution, v55 "ruled out", re-suspected then re-cleared during v57's own curve investigation — see Left-Zone Front Door / TASK 2 notes above). Full knuckle-hinge hardware (mating fixed/dynamic pairs, top/mid/bottom) is a SEPARATE, DEFERRED future task — not attempted this round, too much placement precision risk to combine with v57's other 3 tasks. Re-verified via a real CGAL 11-angle sweep (0-100°, 10° steps) post-removal: `Simple: yes` at every angle, zero manifold warnings — a rod's removal can only reduce collision risk (confirmed explicitly, not assumed). `door_open`/`door_open_deg` animation confirmed unchanged (the cylinder was pure added reinforcement mass, never part of the rotation math itself).

Prior history (kept for the record): shape/position and the v55 "ruled out" tangent-edge finding are described in git history/cc_chat_log.md — not reproduced here now that the geometry itself is gone.

### HINGE PIVOT POINT — LOCKED REFERENCE, DO NOT MODIFY WITHOUT RE-VERIFYING TASK 2's CURVE TANGENCY (v57)

The pivot point itself (pure rotation math only, no physical solid geometry at this location as of v57) is unchanged by the rod's removal and remains the datum the entire door assembly is built from. Final values, confirmed live via `left_zone_door()`'s own independently-re-derived copy (matches `outer_shell()`/`outer_shell_debug()`'s `shell_hinge_x/y/z`, never cross-read):

| Axis | World value | Formula |
|---|---|---|
| `hinge_x` | -6mm | `0 - (hinge_od / 2)` — barrel line proud of the shell's exterior wall face (X=0), outward by half the (former) barrel OD |
| `hinge_y` | 25mm | `HINGE_Y_OFFSET` — fixed, independent constant (v43 §2.2), measured from the shell's theoretical sharp corner, decoupled from `corner_r` |
| `hinge_z` | 51.99mm | `FOOT_BASE_H + skin_t - e` — interior floor surface (v55 fix) |

v57 TASK 2 re-confirmed (real CGAL top-down renders, door leaf isolated with acrylic/frame hidden) that the door's return-flange curve is ALREADY exactly tangent to the shell's own interior corner curve at these hinge values (identical center/radius, zero kink) — and a real parametrized CGAL bisection sweep confirmed `hinge_x`/`hinge_y` adjustment has ZERO effect on the door's closed-state (`door_open_deg=0`) footprint, the binding constraint on `tray_zone_frame()`'s `frame_arc_r` cap (this file's own "world value minus hinge offset, then translate by hinge offset" construction makes the closed state mathematically invariant to these 3 values). A future session MUST NOT casually retune `hinge_x`/`hinge_y`/`hinge_z` without re-running that same tangency + frame-clearance verification — the "already tangent" and "frame cap unmovable" findings are specific to these exact numbers, not general properties of the design.

## VM-01 Base — Tray X-Inset / Width (CHANGED 2026-07-06, v50)

| Parameter | Value | Notes |
|---|---|---|
| `tray_x_inset` | 17mm (was a bare hardcoded "10" in both `spring_tray()` and `tray_rack()`) | Janis's instruction was to widen `total_w`/`product_w` for spring-tray clearance — LIVE geometry check found this has ZERO effect: neither the spring lanes' absolute X position (derived from `spring_od`/`spring_gap`/`tray_wall_t` + this inset only) nor the tray box's own wall positions relative to `tray_zone_frame()`'s new touch-points depend on `total_w`/`product_w` at all (confirmed algebraically and via live render). 17mm gives the box's LEFT wall (and spring lane 0) a real 2mm clearance from the left vertical's max reach (15mm) |
| `tray_w_global` | `(product_w + e - frame_bar - 2) - tray_x_inset` = 389.01mm (was fixed `product_w-20`=396mm) | Gives the box's RIGHT wall (and spring lane 4) the SAME real 2mm clearance from the right vertical's own touch point (`product_w+e-frame_bar`), which now scales with the SAME parameters the old `product_w-20` formula assumed a fixed 10mm margin against — that assumption no longer holds once the right vertical touches the divider. Confirmed via a full `tray_out_pct` (0-1.0) sweep: ZERO overlap, both walls and both outermost lanes |
| Total width increase | 0mm — `total_w`/`product_w` UNCHANGED | Stated explicitly per the finding above, rather than forcing an ineffective widening to satisfy the prompt's literal instruction |

SUPERSEDED — DO NOT USE: `Frame bar width=20mm (all four sides)` /
`Frame Z range=300-542mm` (pre-v44 values, wrong reference point + door
collision, see above).

## VM-01 Base — Dashboard (right compartment)

| Dimension | Value | Notes |
|---|---|---|
| Style | ATM recessed | 30 degree screen — LOCKED |
| X start | product_w + divider_t + skin_t | |
| Total width | 181mm | system_w - divider_t - (skin_t x 2) = 204-19-4 = 181mm. CORRECTED 2026-07-09 (vm01-gen1-lock-and-systemw-fix) — was ~160mm, using the stale 185mm system_w value; live v58's own `dash_w` sanity-check comment already confirmed 181mm, this just brings the doc in sync. |
| Screen size | 165mm x 100mm | 7" TFT touch |
| Screen angle | 30° | From horizontal |
| Screen recess | 30% into panel | |
| Screen center Z | 280mm from ground | 40% of total_h 700 |
| QR scanner cutout | 40mm x 30mm x 10mm deep | Below screen |
| QR Z | screen bottom - 50mm | |
| ID card slot | 85mm x 8mm x 15mm deep | Below QR |
| Speaker grille | 60mm x 20mm | 5 slots x 2mm, 2mm gap |

## VM-01 Base — Acrylic Display Zone

| Parameter | Value | Notes |
|---|---|---|
| Zone | RIGHT compartment only | LOCKED |
| Faces covered | Front + right side + top | 3 faces — LOCKED |
| Bottom Z | 542mm | Top of tray zone |
| Top Z | total_h - skin_t = 698mm | Roof |
| Height | 156mm | |
| Front panel corner radius | 8mm | hull + cylinders |
| Left zone | Front door only, no acrylic | LOCKED |
| Right panel Y-range | corner_r to total_d - corner_r | As of v39 (was skin_t to total_d - skin_t). Reason: shell corner clearance — the flat panel was protruding 7.28mm past the shell's curved corner wall at the front-right corner. Confirmed by Janis this session: production acrylic is a flat sheet screwed in from inside the metal frame, so it does not need to match the shell's curve — recessing to the flat-wall region is the correct fix. |

## VM-01 Base — Screen

| Dimension | Value | Notes |
|---|---|---|
| Screen width | 165mm | |
| Screen height | 100mm | |
| Screen angle | 30° | Tilted toward user |

---

## VM-02 Base — NEW sibling product line (2026-07-10, vm02-derivation-from-vm01-v58)

VM-02 is a NEW product line derived from VM-01-base-v58 (same base
architecture: DATUM_* chain, coordinate convention, module set), NOT a
new VM-01 version — VM-01 stays LOCKED at v58, unchanged. GOVERNANCE
FLAG: VM-02 has no `design_scope_of_work_rule.md` or Skeleton/BOM/Kinetic
worksheets on record (see knowledge.map GOVERNANCE section and
cc_chat_log.md for the full note) — every value below is inherited from
or directly derived off VM-01's existing datum chain, not independently
invented. Mirrors the VM-01 section structure above; only rows that
differ from VM-01 are given full tables — everything else (spring/motor
specs, coordinate system, drop zone, sensors' Z-position, front door
Z-formulas) is UNCHANGED, see the matching VM-01 section above.

### VM-02 Base — Overall

| Dimension | Value | Notes |
|---|---|---|
| Total width | 584mm | DERIVED (product_w + divider_t + system_w = 422+19+143), not a literal — see "system_w RECOMPUTED" below. product_w itself is 422mm here (not 416mm) — see "Trays" section below, "Tray/frame clearance FIXED" |
| Total height | DERIVED, live | `tray_stack_z0 + tray_zone_h + ROOFLINE_MARGIN(88)` — varies with `tray_count`: 579mm (tray_count=1) / 700mm (2) / 821mm (3, default) / 942mm (4) / 1063mm (5) |
| Total depth | 600mm | UNCHANGED |
| Corner radius | 20mm | UNCHANGED |
| Skin thickness | 2mm | UNCHANGED |

### VM-02 Base — Compartments

| Dimension | Value | Notes |
|---|---|---|
| Product zone width | 422mm | CHANGED 2026-07-10 (2nd Janis follow-up), +6mm from the original 416mm — see "Trays" section below, "Tray/frame clearance FIXED", for why. The narrower portrait dashboard's freed compartment width still comes off TOTAL MACHINE WIDTH (system_w unaffected by this change) — this 6mm is a separate, additional widening specifically for tray clearance |
| System zone width | 143mm | RECOMPUTED TWICE, Janis-confirmed 2026-07-10. The source prompt's own "10mm border + 100mm mounted + 10mm border = 120mm" framing didn't account for the EXISTING `dash_w = system_w - divider_t - skin_t*2` formula (unchanged, reused from VM-01) — at system_w=120mm, dash_w=97mm, but the portrait screen's own bezel footprint (100mm panel + 2×3mm bezel = 106mm) is already wider than that, a real confirmed collision. cc's first correction (133mm) used the project's 2mm Global Clearance Tolerance convention instead of the prompt's own literal border framing — Janis corrected this: the border really is a full 10mm EACH SIDE of the panel's own mounted width (matching the prompt's own arithmetic), so dash_w target = 10+100+10 = 120mm; system_w = 120+19+4 = 143mm |
| Divider thickness | 19mm | UNCHANGED |

### VM-02 Base — Legs

| Dimension | Value | Notes |
|---|---|---|
| Leg height | 50mm | UNCHANGED |
| Leg OD | 80mm | CHANGED from 25mm (Task C). Real clearance check (CGAL boolean, not arithmetic-only): leg fully contained within the shell's rounded-corner footprint at the unchanged 40mm inset, confirmed at BOTH VM-01's original 640mm width (regression) and VM-02's derived 568mm width — worst-case point of the leg's own circle sits ~14.6mm from the corner arc's center, vs. the arc's own 20mm radius, a real ~5.4mm margin. Leg-to-leg spacing confirmed trivially clear (hundreds of mm) at every width tested. |
| Leg inset | 40mm | UNCHANGED — confirmed NOT needing to change, see clearance check above |

### VM-02 Base — Trays

| Dimension | Value | Notes |
|---|---|---|
| Tray count | 1-5, live Customizer parameter, default 3 | CHANGED from a fixed 2 (Task A.1/A.2). `total_h` now DERIVES from this (see Overall table above) — tested at 1/3/5, real CGAL `Simple: yes` at every value |
| Tray height | 121mm | UNCHANGED, OWNER-LOCKED |
| Tray slide (`tray_out_pct`) | length-5 Customizer vector, independent per tray, full [0:1] range now physically achievable (door open) | CHANGED from a single shared scalar (Task A.3) — `spring_tray(tray_num)` indexes its own entry. TRAY/FRAME CLEARANCE — ROOT-CAUSED THEN FIXED (2 direct-chat follow-ups, both 2026-07-10). Initial finding: only ~0-0.27 was physically achievable before the tray's own left wall collided with `tray_zone_frame()`'s fixed left-vertical closing face (real CGAL bisection: clean at 0.27, non-manifold at 0.28+). ROOT CAUSE (confirmed by reading the archived VM-01-base-v55.scad vs v56.scad directly, NOT a height/ceiling issue — horizontal X-axis only): this is a genuine REGRESSION from VM-01 v56 (vm01-v56-sensor-bracket-frame-joint-fix) — v50 set `tray_x_inset`=17mm for a real 2mm clearance verified against the left vertical's curve construction AT THE TIME (capped at X=15mm); v56 rebuilt that same curve to fix an unrelated visible kink, sweeping it further (to `y_stop_angle`=270°, where the closing point's X reduces to the arc center's own X=21mm regardless of radius) — v56's own testing was door-vs-frame only, never re-checked tray clearance, so this went undetected for 2 versions. FIXED (2nd follow-up, Janis's own proposed direction): widened the compartment instead of touching the frame or the tray's own width — `product_w` 416mm→422mm (+6mm) and `tray_x_inset` 17mm→23mm (the SAME +6mm shift), so `tray_w_global`'s formula evaluates to the exact same 389.01mm as before (tray width/spring-lane layout UNCHANGED, only its position shifts right). Works because the frame's LEFT vertical is anchored to the shell's fixed corner (independent of `product_w`, doesn't move) while its RIGHT vertical (anchored to `product_w+e`) shifts by the same +6mm as the tray's own right wall, preserving the existing 2mm right-side clearance automatically. Confirmed via a full CGAL sweep, `tray_out_pct` 0 through 1.0 (door open — the physically valid state for a fully-extended tray; a tray at 100% still legitimately collides with a CLOSED door, an unrelated, unavoidable physical fact), Simple:yes throughout. Same gap CONFIRMED still present, UNFIXED, in the LOCKED VM-01 v58 file (out of scope to touch there). |
| Sensor hole (per tray, per lane) | 3mm diameter, vertical (Z-axis), through the tray FLOOR, centered at the existing lane centerline X, Y=5mm from the tray's own front edge (local Y=0) | NEW (Task A.4). Confirmed clear of the rear motor-mount cutouts (real Y-gap, front vs. rear) via real CGAL render |

Two real manifold bugs found and fixed via the mandatory `tray_out_pct`
sweep (both confirmed via real CGAL, see VM-02-base-v1.scad's own
`tray_rack()`/`spring_tray()` comments and cc_chat_log.md for full
detail): (1) at `tray_out_pct`=1.0 exactly, a sliding tray's rear edge
lands exactly on `tray_rack()`'s own fixed rail (a real 0mm coincident
touch, same pre-existing bug confirmed present in locked VM-01 v58, out
of scope there) — fixed with a real 1mm rail overlap. (2) Adjacent
stacked trays share an exact coincident Z-face, tolerated when both are
retracted but a real T-junction once either slides — fixed with a new
2mm `TRAY_TOP_CLEARANCE` gap between tray slots (`tray_h`, the OWNER-
LOCKED slot spacing, is unchanged; only the tray body's own physical
height shrinks by 2mm, invisible headroom at the top).

### VM-02 Base — System Compartment (dashboard + back door)

| Dimension | Value | Notes |
|---|---|---|
| Dashboard orientation | PORTRAIT | CHANGED from landscape (Task B.1) — physical panel dims UNCHANGED (165mm x 100mm), remounted so the 165mm edge runs vertical. Screen/bezel/support-bracket rebuilt against new `screen_mount_w`(100mm)/`screen_mount_h`(165mm) locals inside `dashboard()`; same -30° tilt mechanic |
| Screen position | `screen_top_z = max(total_h-400, 383)` | CHANGED from a fixed `screen_center_z=280` (Task B.2). The literal "400mm below shell top" rule alone pushes the QR/card/speaker stack below the floor at `tray_count` 1-2 (`total_h` 579-700mm) — real conflict found via the mandatory 1/3/5 sweep, fixed with a `max()` clamp (floor value 383mm = `leg_h+10` + the stack's own 323mm vertical span) so the rule applies whenever the machine is tall enough, otherwise the stack is pushed up just enough to stay valid |
| Rear service door | Full floor-to-ceiling (`leg_h` to `total_h-skin_t`, world Z), width = `system_w-10` = 133mm, centered in the compartment's own interior width | CHANGED from a fixed 50%-height panel (Task B.6). Position/centering is cc's discretion per the prompt — centered for symmetric best access |
| `acrylic_display()` | RESTORED, PERMANENT (Janis-confirmed 2026-07-10: "we need acrylic window") | cc's first draft had removed this as a judgment call — reversed per Janis's explicit instruction. Rebuilt for VM-02's own narrower/portrait compartment: front panel width = `dash_w` (120mm), Z-zone anchored to a new shared `screen_top_z`-based datum (above the dashboard's own screen assembly, up to the roofline) instead of the removed tray-stack-derived datum. This still resolves the `DATUM_TRAY_TOP`/`tray_zone_top_z` cross-cutting dependency the prompt flagged — that entire datum chain stays REMOVED from VM-02's file; the shell's own left-zone and right-compartment front cutouts are both simplified to one full-height cutout each, and the acrylic panel simply glazes the upper portion of that same opening. Three real manifold issues found and fixed while resizing this module (all real CGAL, see VM-02-base-v1.scad's own `acrylic_display()` comments and cc_chat_log.md) |

Everything NOT listed above (spring/motor physical specs, coordinate
system, drop zone dimensions, sensor Z-position (350mm world, UNCHANGED,
DO-NOT-TOUCH), front door Z-formulas, tray rack/lock provision) is
UNCHANGED from the VM-01 sections above — VM-02 inherits them formulaically,
confirmed via real render at `tray_count` 1/3/5, not re-stated here.

### VM-02 Base — System Compartment Metal Panel (NEW 2026-07-10, v2, vm02-lower-shell-fill-and-retro-governance)

Real, confirmed design gap, NOT a regression this build introduced —
Janis's original spec (restated 2026-07-10): the dashboard's lower zone
should sit inside SOLID sheet metal, with the acrylic display window
starting only above it. Live code check (Claude Web, reading
`outer_shell()` directly) confirmed this was NEVER built — since VM-01-
base-v6, the right-compartment front-face cutout has always been one
continuous open hole spanning the entire lower zone, dashboard components
floating in open space. VM-01 (locked) has the identical gap, untouched.

| Dimension | Value | Notes |
|---|---|---|
| Right-compartment UPPER cutout | `acrylic_zone_bot_z` to roofline (world Z) | CHANGED — was full floor-to-ceiling (VM-02 v1). Now matches `acrylic_display()`'s own Z-zone exactly (the SAME live datum, not re-derived) — one cutout per one glazed opening |
| Right-compartment LOWER zone | SOLID shell material, `skin_t` thick, floor to `acrylic_zone_bot_z` | NEW — achieved by simply not cutting a hole there; the base shell already provides this skin wherever nothing else cuts it |
| Screen+bezel+bracket mounting cutout | Real footprint + 2mm clearance (`PANEL_CUTOUT_CLEARANCE`) on all sides. Z-lower-bound uses `max(bezel_t, bracket_r)`, not just the bezel | REAL CGAL FINDING: a first pass sized only to the bezel's own flat footprint left a genuine ~3mm gap against the dashboard's SEPARATE, flat (non-tilted) support bracket, which reaches lower than the bezel does (`bracket_r`=8mm vs `bezel_t`=3mm) — found by isolating `intersection(){dashboard();outer_shell();}` and reading the real colliding part's bounds, not guessed |
| QR / card reader / speaker mounting cutouts | Each component's own real footprint (`qr_w`×`qr_h`, `card_w`×`card_h`, `speaker_w`×`speaker_h`) + 2mm clearance on all sides | `speaker_h` reused as the grille's own established total-footprint-height allocation (same value `DASH_STACK_H`'s own chain already uses), not a re-derived slot-by-slot span |
| `dashboard()`'s own Z-position chain | PROMOTED to shared top-level DATUMs (`screen_mount_w/h`, `screen_z`, `qr_z`, `card_z`, `speaker_z`) | Was module-local only in v1 — `outer_shell()`'s new cutouts now read the SAME live values, never an independently re-derived copy (Datum Rules; R-009 Duplication Check performed first, confirmed this chain existed in exactly one place before this change) |

Real CGAL sweep: zero collision between `dashboard()` and `outer_shell()`
at `tray_count`=1/3/5 (`screen_top_z`'s own clamp shifts the dashboard's Z
position differently at each), full assembly `Simple: yes` throughout.
Also confirmed zero new collision with `rear_service_door()`,
`tray_zone_frame()`, `compartment_divider()`, `acrylic_display()` at
`tray_count` 1/3/5. Door sweep, mixed `tray_out_pct`, `flap_open`, and C2
mode all re-verified clean (this change is confined to the right
compartment, no interaction expected or found with the left-side door/
tray/frame geometry).

### VM-02 Base — Display Shelf + Right-Side Viewing Acrylic (NEW 2026-07-10, v3, vm02-dashboard-shelf-and-side-acrylic)

Two NEW features in the right/system compartment's acrylic display zone
(not fixes to v2's own work). R-009 Duplication Check performed first:
`acrylic_zone_bot_z` already existed as a live top-level DATUM (promoted
in v2) — both features read that same value, nothing re-derived.

| Dimension | Value | Notes |
|---|---|---|
| Display shelf top surface (`shelf_top_z`) | `acrylic_zone_bot_z - 10` (`SHELF_TOP_MARGIN`) | Janis: "just 10mm below the acrylic edge" — read as the shelf's own TOP surface (where items sit), not its underside. Only one live "acrylic edge" exists in this file (one acrylic zone, one Z-range) — not a genuine ambiguity |
| Display shelf X-span | `dash_x` (443mm) to `dash_x+dash_w` (563mm), width 120mm | Reuses the SAME X-extent `dashboard()`/`acrylic_display()` already establish for this compartment, per the prompt's explicit instruction, not re-derived. FLAGGED: this is a dashboard-component MOUNTING envelope, narrower than the compartment's true wall-to-wall interior (divider's right face at 441mm to the shell's own interior right wall at 582mm) — used verbatim anyway per the prompt's explicit direction to reuse these two named values |
| Display shelf Y-span | `skin_t` (2mm) to `(total_d-skin_t)-SHELF_REAR_GAP` (597mm) | Same "interior front face to interior rear wall" full-depth convention `compartment_divider()` already uses. REAL CGAL FINDING: the un-gapped rear edge landed exactly on `rear_service_door()`'s own front face (Rule M-1) — fixed with a real 1mm `SHELF_REAR_GAP`, not a bare epsilon |
| Display shelf thickness | `tray_floor_t` (5mm) | No thickness given in the prompt — reused this file's own existing "floor" thickness convention (`tray_compartment_partition()`), not a new invented constant |
| Right-exterior viewing acrylic cutout (`outer_shell()`) | Z: `acrylic_zone_bot_z` to roofline (same live datum as the front cutout). Y: `corner_r` (20mm) to `total_d/2` (300mm) — FRONT HALF of the compartment's depth only | CONFIRMED no such cutout existed anywhere in `outer_shell()` before this session (`show_shell_right` only fully removes the panel for debug isolation). Y-range corrected mid-session per Janis (front half, not back half). `corner_r` is the exact tangent point of the shell's own rounded front-right corner (not an arbitrary split) — real numeric coincidence confirms this reading: the front acrylic panel's own right edge (`dash_x+dash_w`=563mm) lands within 1mm of this same tangent point (`total_w-corner_r`=564mm) |
| `acrylic_display()`'s internal right panel Y-range | Was `corner_r` to `total_d-corner_r` (20-580mm, full depth) — now `corner_r-1` to `total_d/2+1` (19-301mm, front half + real `ACRYLIC_OVERLAP` margin each end) | CHANGED to match the new cutout's own opening so the glazing material and its opening align. REAL CGAL FINDING: sizing the panel's Y-range to exactly match the cutout's own boundaries produced a real coincident-edge non-manifold result — fixed with the SAME real `ACRYLIC_OVERLAP` (1mm) margin this module's other 2 panels already use |

Real CGAL verification (real OpenSCAD binary, not estimates): full
assembly `tray_count`=1/3/5, 11-angle `door_open_deg` sweep (0-100 step
10, `door_open`=true), mixed `tray_out_pct` (including all-trays-at-100%,
`tray_count`=5), `flap_open` true/false, C2 mode (`show_shell_top`/
`show_shell_left`=false) — `Simple: yes` at every single check, no
exceptions. Explicit isolation checks (real `intersection()`, confirmed
genuinely EMPTY = zero collision unless noted): `display_shelf()` vs.
`dashboard()`, vs. `outer_shell()`, vs. `acrylic_display()` — all empty,
re-confirmed at `tray_count` 1 and 5 too (shelf sits `screen_top_z+40`
regardless of `tray_count`, by construction). New cutout vs.
`tray_zone_frame()` — empty. New cutout vs. `rear_service_door()` —
non-empty (Vertices:17/Facets:10/Volumes:2) but confirmed BYTE-IDENTICAL
to the same pair's own pre-existing v2 baseline (same real, already-
accepted overlap, zero new collision introduced by this session's work).
NOTE on methodology: the `acrylic_display()`-vs-`outer_shell()`
`intersection()` probe kept reporting non-manifold even AFTER the real
`ACRYLIC_OVERLAP` fix was confirmed correct — the FULL ASSEMBLY render
(the authoritative test) was `Simple: yes` throughout; isolated
`intersection()` probes are a known false-positive source for this
specific module pair, already documented in this file's own v2 section
above ("did NOT reproduce in isolated pairwise intersection tests...
only surfaced once the full boolean union was actually computed").

---

## PR-01 Base — 4-Part Split Architecture (v7, Stage 1) — Janis-confirmed this session

Janis rejected the v6 one-piece continuous-pole/taper concept (written approval given
in chat this session to update this section). Pole is now 4 separate physical
components, self-assembled by customer: pole_top() (crossbar lock/latch junction,
placeholder), pole_body() (D-profile shaft), pole_base_collar() (insert pin to wood
socket, placeholder), pole_wood_socket() (drilled-in insert).

| Dimension | Value | Notes |
|---|---|---|
| PR-01 body D-section | 40mm constant diameter | No taper — body is constant-diameter top to bottom. pole_od changed 50mm→40mm — Janis-approved in chat, 2026-06-30, to proportionally fit pole_top() neck within bell waist. Still above 36mm market-standard floor. SUPERSEDES prior 50mm value and prior flat_w_base/flat_w_top taper values below. |
| PR-01 wood socket OD | ~60mm | Fixed (non-foldable) version. Plain cylindrical insert pushed through drilled hole in wood leg. |
| bed_w | 840mm | Janis-confirmed 2026-07-02, derived from 720mm crossbar-gap target (bed_w = 720 + leg_t, leg_t=120mm unchanged). Supersedes prior 670mm PENDING value. |

### SUPERSEDED — DO NOT USE (kept for history only)
| Dimension | Value | Superseded by |
|---|---|---|
| flat_w_base (pole flat-face width @ base) | 100mm | v7 — replaced by constant 50mm D-section, no taper |
| flat_w_top (pole flat-face width @ top) | 60mm | v7 — replaced by constant 50mm D-section, no taper |
| pole taper concept (horn-curve loft, r_base~70mm/r_top~42mm) | — | v7 — taper concept dropped entirely |

Foldable hinge geometry remains explicitly deferred — not part of this fixed-version dimension set.

---

### SUPERSEDED — DO NOT USE (kept for history only)
Replaced 2026-07-02 by the Bell Collar concept below. External split-clamp
bracket approach abandoned in favor of pole pushing directly into an embedded
leg socket.

NOTE: rules-dimensions.md never carried a discrete numeric table for the
split-clamp collar (collar_wrap_h/collar_wall_t/collar_bolt_d/etc.) — those
placeholder values live only in .scad file comments (PR-01-base-v9.scad
onward, see cc_chat_log.md 2026-06-30 entry) and in the pole_base_collar()
prose reference just above. This note is placed here, against that prose
reference, as the closest existing textual anchor for the superseded concept —
flagging this explicitly rather than inventing a table that was never
committed to this file.

## PR-01 Base — Pole Holder, Bell Collar (CONCEPT CONFIRMED via Customizer, 2026-07-02)

Replaces the external split-clamp collar above (superseded, kept for history)
with a bell-shaped copper/brass holder — pole pushes directly into an embedded
leg socket, no external bracket. Values confirmed live by Janis via OpenSCAD
Customizer. Proportion/appearance only — NOT load-tested, not production-ready.

| Parameter | Value | Note |
|---|---|---|
| r_base | 51mm | foot ring radius, flush at wood surface |
| r_top | 29mm | neck radius, meets washer/cap |
| foot_h | 8mm | straight vertical foot ring height |
| dome_h | 35mm | curved dome height |
| dome_steps | 16 | loft resolution |
| curve_power | 1.4 | profile exponent: 1=straight cone, >1=convex bulge, <1=concave converge |
| cap_h | 10mm | knurled brass cap height |
| cap_knurl_count | 45 | knurl notch count |
| washer_h | 5mm | copper washer reveal height |
| washer_overhang | 1mm | copper washer reveal radial overhang beyond dome top |
| pole_od | 40mm | LOCKED, unchanged from existing spec |

Still open, not yet decided:
- Socket-to-wood depth/architecture — Janis directed a >300mm pass-through
  sleeve through a fully drilled leg channel (replaces shallow bonded pocket),
  not yet reconciled with this collar concept.
- Internal lock mechanism — hybrid thread+cam single bezel vs. 3-part reference
  system (separate socket thread + holder bayonet + compression cap/washer).
  Not decided.

### SUPERSEDED BY REVISED VALUES BELOW (kept for history only)
The table above (r_top=29mm, curve_power=1.4) is superseded by the REVISED —
CONFIRMED table immediately below (r_top=25mm, curve_power=2.2), confirmed by
Janis via a second Customizer screenshot, 2026-07-02.

## PR-01 Base — Pole Holder, Bell Collar — REVISED — CONFIRMED via Customizer screenshot, 2026-07-02

Supersedes the r_top=29/curve_power=1.4 table above. Same bell-shaped
copper/brass holder concept — pole pushes directly into an embedded leg
socket, no external bracket. Values confirmed live by Janis via OpenSCAD
Customizer (`bell_holder_customizer.scad`). Proportion/appearance only —
NOT load-tested, not production-ready. First production geometry pass
committed in `bell_lock_collar()` (pole_top.scad), pole-base-bell-collar-
socket-build, 2026-07-02.

| Parameter | Value | Note |
|---|---|---|
| r_base | 51mm | foot ring radius, flush at wood surface |
| r_top | 25mm | neck radius, meets washer/cap |
| foot_h | 8mm | straight vertical foot ring height |
| dome_h | 35mm | curved dome height |
| dome_steps | 16 | loft resolution |
| curve_power | 2.2 | profile exponent: 1=straight cone, >1=convex bulge, <1=concave converge |
| cap_h | 12mm | knurled brass cap height |
| cap_knurl_count | 45 | knurl notch count |
| washer_h | 5mm | copper washer reveal height |
| washer_overhang | 4mm | copper washer reveal radial overhang beyond dome top |
| pole_od | 40mm | LOCKED, unchanged from existing spec (= pole_d in SCAD) |

## PR-01 Base — Socket/Leg Architecture (CONFIRMED, first-time lock, 2026-07-02)

First-time lock — was PLACEHOLDER before this. Confirmed by Janis via
Customizer screenshot (`pole_top_housing_customizer` leg/bed panel).
Resolves the "Socket-to-wood depth/architecture" open item above: a
>300mm pass-through sleeve through a fully drilled leg channel, replacing
the old shallow bonded pocket (`pole_wood_socket()`, socket_depth=20mm —
NOTE: that module remains actively called alongside this new one in the
committed SCAD, not yet retired; flagged as a likely redundancy, not
resolved by this entry). Committed in new `leg_socket.scad`.

| Parameter | Value | Note |
|---|---|---|
| leg_h | 600mm | leg's own full height — RECONCILED against bed_h 2026-07-02 (bed-height-pad-cutaway-fix): see `bed_h` row below, no change to leg_h itself |
| leg_w | 180mm | shared with existing bed_frame()/pole_top.scad global, unchanged |
| leg_t | 120mm | shared with existing bed_frame()/pole_top.scad global, unchanged |
| bed_h | 600mm | floor to top of bed surface — Janis-confirmed 2026-07-02 (bed-height-pad-cutaway-fix), reconciled to leg_h(600mm) so the bed surface sits flush on top of the embedded-socket leg instead of appearing sunk below it (was 500mm, PENDING). Supersedes prior 500mm PENDING value. Fix required removing a dormant pole_top.scad self-reassignment bug (same class as pole_cx/pole_cy) that was silently collapsing bed_h to a hardcoded 500 fallback — see PR-01-assembly-v30.scad / cc_chat_log. |
| socket_depth | 400mm | pass-through sleeve depth (named `leg_socket_depth` in SCAD — see below) |
| socket_od | 46mm | named `leg_socket_od` in SCAD |
| socket_wall_t | 2.5mm | named `leg_socket_wall_t` in SCAD |
| pole_od | 40mm | LOCKED, unchanged from existing spec (= pole_d in SCAD) |

### SUPERSEDED — DO NOT USE (kept for history only)
| Dimension | Value | Superseded by |
|---|---|---|
| pad_t | 20mm | Foot pad removed entirely, 2026-07-02 (bed-height-pad-cutaway-fix) — Janis-confirmed, was never part of the intended design, only surfaced on first visual render of leg_socket(). Draw call commented out in leg_socket.scad, variable kept unused for history. |
| pad_overhang | 50mm | Same as above — removed with pad_t, kept unused for history. |

Derived: socket_id = socket_od - 2×socket_wall_t = 41mm. Radial clearance
against pole_od(40mm) = 0.5mm — tight tolerance, not a blocker, flagged for
print/fit tolerance awareness.

NAMING NOTE: the SCAD globals are `leg_socket_od`/`leg_socket_wall_t`/
`leg_socket_depth`, deliberately NOT `socket_od`/`socket_depth` — those
names already exist as PR-01-assembly globals (60mm/20mm, used by
`pole_wood_socket()`); reusing them would silently override
`pole_wood_socket()`'s values via OpenSCAD's last-declaration-wins
duplicate-variable behavior — the same bug class already chased twice
this project. Renamed to avoid it outright.

## PR-01 Base — Lock Mechanism (ENGINEER-PROPOSED, NOT Janis-measured, NOT validated, 2026-07-02)

Thread + bayonet + cap engagement specs were NOT part of either Customizer
screenshot set — Janis explicitly delegated these to Claude Web as
engineering judgment based on standard practice for hand-assembled
quick-release fittings at this scale. ENGINEER-PROPOSED, NOT Janis-measured,
NOT load-tested. Committed as simplified representative geometry (visual
single-start helix / lug bumps, not a literal mating female thread/slot cut
into the cap) in `bell_thread()`/`bell_bayonet()` (pole_top.scad) — avoids
first-pass manifold risk on an unvalidated spec. Requires prototype
fit-test before tooling.

| Parameter | Value | Note |
|---|---|---|
| thread_pitch | 3mm | single-start |
| thread_depth | 1.5mm | radial depth |
| thread_engagement_l | 8mm | of cap_h's 12mm total — remaining ~4mm proud as knurled grip reveal |
| bayonet_lug_count | 3 | lugs |
| bayonet_spacing | 120° | between lugs |
| bayonet_lug_w | 5mm | lug width |
| bayonet_engagement_depth | 3mm | |
| bayonet_rotation | 30° | rotation to lock |

---

## BBQ Offset Smoker Base — NEW product line (2026-07-13, bbq-offset-smoker-v1-init)

First dimensions for this product. Full derivation/comments live in
bbq-offset-smoker/BBQ-chambers-v1.scad's own PARAMETERS/DATUMS block
(per the SKILL_product_design_skeleton.md convention for new products —
this section is a summary pointer, not a second independent copy).

| Parameter | Value | Note |
|---|---|---|
| GRATE_Z | 700mm | MASTER CONTROL VALUE, not derived |
| grate_clearance | 100mm | chamber_floor_z = GRATE_Z - 100 = 600mm |
| chamber_L x chamber_W x chamber_H | 915 x 610 x 610mm | length(X) x width(Y) x full hex height |
| chamfer | 150mm | 45-degree chamfer, equal rise/run |
| firebox_size | 457mm cube | |
| firebox_drop | 200mm | ⚠️ OPEN FLAG — Claude Web's assumption, NOT yet Janis-confirmed, per the source prompt itself |
| window_w x window_h | 254 x 119mm | pass-through opening, chamber rear wall + firebox near face |
| intake_w x intake_h | 107 x 107mm | firebox door damper |
| chimney_d / chimney_len | 127mm / 762mm | built length, not the raw volume formula; top stays <=2.5m from ground (confirmed: 1932mm world Z) |
| wall_t | 3mm | shell thickness, all parts |

**Coordinate correction from the source prompt**, stated explicitly (see
BBQ-chambers-v1.scad header): the prompt's own module sketches used Y as
the length axis. This project's locked "COORDINATE SYSTEM STANDARD — ALL
MODELS" (above, this file) puts X as the longitudinal/length axis for
every product, new lines included — chamber_L runs along X here, not Y.

**Judgment calls, not in the source prompt** (flagged, not silently
resolved — full reasoning in BBQ-chambers-v1.scad's own header):
lid-opening extent (`LID_MARGIN_FRONT`=300mm / `LID_MARGIN_REAR`=60mm),
chimney mounted on the fixed shell rather than the lid.

**Real CGAL-found-and-fixed issues this session** (not in the source
prompt — only discoverable by rendering, see cc_chat_log.md for the full
record): firebox door hinge exact-tangency (`HINGE_GAP`=0.5mm), firebox's
far/outward wall was wrongly solid in a first pass (design error, not
just a manifold nudge — the door would have covered a wall that
shouldn't have existed, and the ash tray collided with it when sliding
out), lid hinge clearance past the fixed rear-margin shell
(`HINGE_CLEARANCE`=15mm), chimney fold pivot height (`FOLD_PIVOT_Z`, above
the ridge, not the recessed weld base), counterbalance lever standoff
(`LEVER_CLEARANCE`=50mm).

---

## PENDING DESIGN DECISIONS (not yet locked)

| Item | Decision needed | Owner |
|---|---|---|
| Dashboard orientation | Portrait vs landscape — depends on Satu firmware | Janis + firmware team |
| system_w reduction | If portrait confirmed: system_w 204→187mm, total_w 640→623mm (same 17mm reduction as originally proposed, rebaselined 2026-07-09 off the corrected current values — was stated against a stale 185mm/620mm baseline; live v58 is 204mm/640mm, confirmed against code, not assumed). NOTE: `system_w` is no longer OWNER-LOCKED as of this session (see removed row above) — this item now describes a design option, not an approval gate on a locked dimension. | After firmware decision |
| PR-01 dimensions | Not started — Janis to provide measurements | Janis |
| BBQ firebox_drop | 200mm is Claude Web's assumption (source prompt's own OPEN FLAG), not yet Janis's explicit number | Janis |
| BBQ scope file / SKELETON_WORKSHEET.md content | Compartment Map / Functional Features / Appearance / Made-Buy-Hire / BOM tree / Kinetic table are cc-reconstructed DRAFTs — the source prompt's referenced confirmed chat-log content was not available to cc. See bbq-offset-smoker/design_scope_of_work_rule.md and SKELETON_WORKSHEET.md's own governance flags | Janis |

---

## Global Clearance Tolerance
| Context | Minimum gap | Reason |
|---|---|---|
| Display object to any tray body face | 2mm | Implicit union → manifold risk (R-001) |
| Cylinder to any flat face | 2mm | Polygon undercut at $fn=64 (R-002) |
| Structural part to shell face | skin_t (2mm) | Standard skin thickness |
| Coplanar face suppression (epsilon) | e = 0.01mm | Geometry z-fight only — NOT for display objects |

---

## Coordinate Reference Points — LOCKED
| Name | World coords | Description |
|---|---|---|
| Machine origin | X=0, Y=0, Z=0 | Front-left corner at floor level |
| Tray local origin | X=lane_x, Y=tray_start_d, Z=tray_z | Front-left of tray floor |
| Spring lane centre | X = tray_wall_t + spring_od/2 + i*(spring_od+spring_gap) | Per lane i (0-indexed) |
| Drop zone boundary | Y = tray_start_d = 138mm | Products fall forward from here |
| Motor rear limit | Y = tray_d - tray_wall_t - e | Never touches or exits rear wall |
| Coil front face | Y = tray_start_d (local Y=0) | Drop zone boundary |

---

## Spring Coil Physical Spec
| Parameter | Value | Note |
|---|---|---|
| OD | 66mm | Supplier part — LOCKED |
| Wire diameter | 3mm | |
| ID | 60mm | OD - 2×wire_d |
| Pitch | 25mm | |
| Length | 390mm | spring_l parameter |
| SCAD model | solid cylinder d=spring_od-2, h=spring_l-2 | 1mm clearance each side — display only |
