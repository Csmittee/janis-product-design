# PART_MANIFEST.md — VM-02
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.4 — 2026-07-10 (vm02-dashboard-shelf-and-side-acrylic): NEW
# `display_shelf()` module added (Feature A, real `show_display_shelf`
# toggle from its first commit). `outer_shell()`'s entry updated — new
# permanent right-exterior viewing acrylic cutout added (Feature B, front
# half of the compartment's depth only). `acrylic_display()`'s entry
# updated — its own internal right panel's Y-range shrunk to match the
# new cutout (was full depth, now front-half only). Source now
# VM-02-base-v3.scad (v2 superseded, kept per file-versioning
# convention).
# Previous: 1.3 — 2026-07-10 (vm02-lower-shell-fill-and-retro-governance):
# outer_shell()'s entry updated — right-compartment cutout now solid below
# the acrylic zone, with 4 individual dashboard mounting cutouts (a real
# confirmed design gap fix, not new scope creep). Retroactive governance
# chain completed this session (design_scope_of_work_rule.md,
# SKELETON_WORKSHEET.md, both in this same folder) — see
# SKELETON_WORKSHEET.md Finding 3 for a real Kinetic Dual-View gap found
# during that pass: rear_service_door() has no open/close toggle at all,
# not fixed this session, flagged for a future prompt.
# Previous: 1.2 — 2026-07-10 (2nd follow-up, same day): tray_zone_frame()'s
# entry updated — the left-vertical clearance gap flagged in 1.1 is now
# FIXED (product_w widened 416->422mm, tray_x_inset shifted 17->23mm),
# not just flagged. See that row and cc_chat_log.md.
# Source: vending-machine/VM-02-base/VM-02-base-v2.scad ASSEMBLY block.
# VM-02 inherits most of VM-01's module set/toggle convention unchanged
# (same names, same architecture) — this manifest mirrors VM-01's own
# structure per the prompt's explicit instruction, with entries updated
# for the parts that actually changed this session (3rd spring tray live
# via tray_count, per-lane sensor holes, resized legs, resized/rebuilt
# rear door, restored+resized acrylic_display()).
# Previous: 1.0 — 2026-07-10, same day. v1.0 had removed acrylic_display()
# as a judgment call — Janis's direct follow-up ("we need acrylic
# window") reversed that; restored here as a real ASSEMBLY entry with its
# own new show_acrylic_display toggle (v1.0's removal note deleted, not
# kept as history, since it was reversed same-session before any other
# session read it).
#
# Toggle column key: a `show_*` name means the module (or the specific
# sub-part named) is gated by that toggle, per the Toggle-Completeness
# Rule (cc_rules.md). "(none — always on, safety-critical)" is the ONLY
# other permitted value — it must be an explicit, named exception, never
# a silent gap. Anything else in this column is a CONFIRMED GAP against
# that rule, called out explicitly in cc_chat_log rather than hidden here.

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `legs()` | 4 support legs, leg_od RESIZED 25mm->80mm this session (Task C) — real corner/leg-inset clearance check done, see cc_chat_log | | GAP — no toggle (inherited from VM-01, unchanged this session) |
| `outer_shell()` | main cabinet shell (called via `translate([0,0,leg_h])`) — left-zone cutout simplified to full floor-to-ceiling height (v1, Task B, resolves the DATUM_TRAY_TOP cross-cutting dependency). Right-compartment cutout CHANGED in v2 (vm02-lower-shell-fill-and-retro-governance): now only the UPPER (acrylic) zone is open — the lower (dashboard) zone is solid sheet metal with 4 individual mounting cutouts (screen+bezel+bracket, QR, card, speaker). CHANGED AGAIN in v3 (2026-07-10, vm02-dashboard-shelf-and-side-acrylic, Feature B): NEW permanent right-EXTERIOR viewing acrylic cutout (X=total_w wall) added — confirmed none existed before (`show_shell_right` only fully removes the panel for debug, never a permanent opening). Z = same live `acrylic_zone_bot_z`-to-roofline datum as the front cutout; Y = `corner_r` to `total_d/2` (front half of the compartment's depth only, the exact tangent point of the shell's own rounded front-right corner — see VM-02-base-v3.scad's own header for the full reasoning + real numeric coincidence with the front acrylic panel's own edge) | | Partial — `show_shell_top`/`show_shell_bottom`/`show_shell_left`/`show_shell_back`/`show_shell_right` remove individual panels; no single master toggle for the whole module; the new right-exterior cutout itself has no independent toggle (same as the other permanent cutouts in this module) |
| `compartment_divider()` | wall between product zone and system/dashboard zone | | GAP — no toggle |
| `tray_rack()` | fixed rails + latch pins holding trays — rail contact FIXED this session (real epsilon-class manifold bug found via the tray_out_pct sweep, see cc_chat_log) | | GAP — no toggle |
| `spring_tray()` x`tray_count` (1-5, live Customizer, default 3 — VM-02 Task A) | removable trays holding springs/product; NEW per-tray floor sensor hole (Task A.4); NEW TRAY_TOP_CLEARANCE vertical gap between stacked trays (real manifold fix, see cc_chat_log) | | GAP — no toggle (per-tray `tray_out_pct[tray_num]` vector IS the kinetic state for each tray, not a show_*-style visibility toggle) |
| `left_zone_door()` | the main hinged front door — includes window + acrylic + flap + flange; stretches automatically with VM-02's derived `total_h` (Task D) | | `show_door` |
| `flap_stopper_rod()` | fixed rod that stops the exit flap at full-open | | GAP — no toggle (static, fixed to cabinet — same open item as VM-01, not resolved here) |
| `tray_zone_frame()` | structural H-frame reinforcement (2 verticals + 1 crossbar), NOT viewable/acrylic; stretches automatically with VM-02's derived `total_h` (Task D). Left-vertical clearance gap (root-caused as a VM-01 v56 regression, initially only flagged) FIXED via widening `product_w`/shifting `tray_x_inset` (see PARAMETERS section) — full `tray_out_pct` 0-1 range now real, not capped at ~27%, see cc_chat_log | the acrylic viewing pane — that lives INSIDE `left_zone_door()` instead | `show_frame` |
| `drop_zone_guards()` | solid hand-safety side guards at the exit/drop zone | | (none — always on, safety-critical) |
| `tray_compartment_partition()` | fixed/welded horizontal panel sealing the space vacated by the tray-stack shift, full compartment width x depth | a removable/access panel — it's structural, not user-facing | (none — always on, safety-critical — blocks hand access from below) |
| `exit_compartment_wall()` | fixed/welded rear-facing wall sealing front-to-back reach at the drop-zone/tray-compartment boundary | `drop_zone_guards()` — those are 2 thin SIDE panels within the drop zone's own depth; this is a full-width wall at the drop zone's REAR boundary | (none — always on, safety-critical — blocks hand access from the front) |
| `sensor_strip()` | 2 independent left/right sensor strips capturing product fall — Z position (350mm world) UNCHANGED, DO-NOT-TOUCH zone per this session's prompt | the NEW per-tray floor sensor holes (Task A.4) — those are a different part, drilled through each tray's own floor, not this strip | `show_sensor` |
| `dashboard()` | ATM screen (PORTRAIT mount this session, Task B.1/B.2) + QR + card reader + speaker | the OLD landscape mount (superseded) | GAP — no toggle |
| `acrylic_display()` | RESTORED, PERMANENT (Janis-confirmed 2026-07-10: "we need acrylic window") — 3 faces (front + right side + top) of the right compartment, resized/re-anchored for VM-02's narrower/portrait compartment and now-variable `total_h`. 3 real manifold issues found+fixed while resizing in v2 (right panel vs. shell interior wall; top panel vs. BOTH the shell's roof and rear_service_door() simultaneously; front panel vs. the shell's own cutout edge — an algebraic coincidence for any system_w, only surfaced in the full assembly, not isolated pairwise tests). CHANGED AGAIN in v3 (2026-07-10, vm02-dashboard-shelf-and-side-acrylic, TASK 3): the internal right panel's own Y-range shrunk from full depth (`corner_r` to `total_d-corner_r`) to front-half only (`corner_r` to `total_d/2`), to match the new right-exterior cutout above so the glazing material and its opening align. REAL CGAL FINDING: sizing the panel's Y-range to exactly match the new cutout's own boundaries (both ends) produced a real coincident-edge non-manifold result (confirmed via isolated `intersection()`, 6-13 facets/2-3 volumes) — fixed with the SAME real `ACRYLIC_OVERLAP` (1mm) margin this module's other 2 panels already use, extended past the cutout on both Y ends. Confirmed clean via the FULL ASSEMBLY render (the authoritative test — `intersection()` probes on this pair kept showing non-manifold even after the real fix, a known CGAL isolation-test false-positive per this same module's own v2 history). See VM-02-base-v3.scad's own comments and cc_chat_log.md | VM-01's own equivalent (render_mode-gated only, a confirmed Toggle-Completeness GAP per its own manifest) | `show_acrylic_display` — added properly here since the module was rebuilt from scratch this session, better than the GAP it started as in VM-01 |
| `rear_service_door()` | rear access panel — REBUILT this session (Task B.6): full floor-to-ceiling height (was a fixed 50%-height panel in VM-01), width = system_w-10 | | GAP — no toggle. ALSO a real Kinetic Dual-View gap (SKELETON_WORKSHEET.md Finding 3, 2026-07-10): drawn as a single static flat panel with no hinge/rotate geometry at all, despite being a real hinged door in the product concept — not fixed this session |
| `display_shelf()` | NEW 2026-07-10 (vm02-dashboard-shelf-and-side-acrylic, Feature A) — physical floor for display items in the right/system compartment's acrylic display zone, top surface 10mm below `acrylic_zone_bot_z` (`shelf_top_z`). Full interior depth (`skin_t` to `total_d-skin_t`, minus a real `SHELF_REAR_GAP` off `rear_service_door()`'s own front face — same coincident-face class `acrylic_display()`'s top panel hit in v2, fixed the same way). Full width reuses `dash_x`/`dash_w` verbatim (the same compartment left/right extent `dashboard()`/`acrylic_display()` already establish — FLAGGED: this is a dashboard-component mounting envelope, narrower than the true wall-to-wall interior, used per the prompt's explicit instruction to reuse these exact values). Thickness = `tray_floor_t` (5mm, reused floor-thickness convention, no number given in the prompt for this). Confirmed zero collision (real `intersection()`, genuinely empty result) against `dashboard()`, `outer_shell()`, and `acrylic_display()`, at `tray_count` 1/3/5 | `acrylic_display()` — that's the viewing glass above; this is the solid floor below it, a separate physical part | `show_display_shelf` — added properly from this module's first commit (Toggle-Completeness Rule), not a GAP |

## Toggle-completeness count (2026-07-10, v1.4)

16 modules called in ASSEMBLY (was 15 — `display_shelf()` added this
session). 5 have a real `show_*` isolation toggle (`left_zone_door`→
`show_door`, `tray_zone_frame`→`show_frame`, `sensor_strip`→
`show_sensor`, `acrylic_display`→`show_acrylic_display`,
`display_shelf`→`show_display_shelf`, NEW this session). 3 are named
safety-critical exceptions (`drop_zone_guards`,
`tray_compartment_partition`, `exit_compartment_wall`). That's **8 of 16
compliant** with the Toggle-Completeness Rule — the new module added its
own real toggle from its first commit rather than starting as a GAP, same
reasoning `acrylic_display()` used in v2. The remaining **8 are gaps**,
all inherited unchanged from VM-01's own pre-existing gaps (not
introduced or newly created this session, not retroactively fixed either
— out of this prompt's scope, same as VM-01's own manifest states):
`legs`, `outer_shell` (partial panel toggles only, no master),
`compartment_divider`, `tray_rack`, `spring_tray`, `flap_stopper_rod`,
`dashboard`, `rear_service_door`. Flagged here for Claude Web/Janis to
decide whether/which of these warrant a toggle in a future prompt,
rather than silently expanding this session's scope.
