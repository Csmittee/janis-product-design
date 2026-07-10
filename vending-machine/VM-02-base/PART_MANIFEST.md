# PART_MANIFEST.md — VM-02
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.0 — 2026-07-10
# Source: vending-machine/VM-02-base/VM-02-base-v1.scad ASSEMBLY block.
# VM-02 inherits most of VM-01's module set/toggle convention unchanged
# (same names, same architecture) — this manifest mirrors VM-01's own
# structure per the prompt's explicit instruction, with entries updated
# for the parts that actually changed this session (3rd spring tray live
# via tray_count, per-lane sensor holes, resized legs, resized/rebuilt
# rear door) and acrylic_display() removed (no longer an ASSEMBLY entry).
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
| `outer_shell()` | main cabinet shell (called via `translate([0,0,leg_h])`) — left-zone + right-compartment front cutouts simplified to full floor-to-ceiling height this session (Task B, resolves the DATUM_TRAY_TOP cross-cutting dependency) | | Partial — `show_shell_top`/`show_shell_bottom`/`show_shell_left`/`show_shell_back`/`show_shell_right` remove individual panels; no single master toggle for the whole module |
| `compartment_divider()` | wall between product zone and system/dashboard zone | | GAP — no toggle |
| `tray_rack()` | fixed rails + latch pins holding trays — rail contact FIXED this session (real epsilon-class manifold bug found via the tray_out_pct sweep, see cc_chat_log) | | GAP — no toggle |
| `spring_tray()` x`tray_count` (1-5, live Customizer, default 3 — VM-02 Task A) | removable trays holding springs/product; NEW per-tray floor sensor hole (Task A.4); NEW TRAY_TOP_CLEARANCE vertical gap between stacked trays (real manifold fix, see cc_chat_log) | | GAP — no toggle (per-tray `tray_out_pct[tray_num]` vector IS the kinetic state for each tray, not a show_*-style visibility toggle) |
| `left_zone_door()` | the main hinged front door — includes window + acrylic + flap + flange; stretches automatically with VM-02's derived `total_h` (Task D) | | `show_door` |
| `flap_stopper_rod()` | fixed rod that stops the exit flap at full-open | | GAP — no toggle (static, fixed to cabinet — same open item as VM-01, not resolved here) |
| `tray_zone_frame()` | structural H-frame reinforcement (2 verticals + 1 crossbar), NOT viewable/acrylic; stretches automatically with VM-02's derived `total_h` (Task D). FLAGGED (not fixed): left vertical's closing face limits real tray travel to ~27% of the `tray_out_pct` range, see cc_chat_log | the acrylic viewing pane — that lives INSIDE `left_zone_door()` instead | `show_frame` |
| `drop_zone_guards()` | solid hand-safety side guards at the exit/drop zone | | (none — always on, safety-critical) |
| `tray_compartment_partition()` | fixed/welded horizontal panel sealing the space vacated by the tray-stack shift, full compartment width x depth | a removable/access panel — it's structural, not user-facing | (none — always on, safety-critical — blocks hand access from below) |
| `exit_compartment_wall()` | fixed/welded rear-facing wall sealing front-to-back reach at the drop-zone/tray-compartment boundary | `drop_zone_guards()` — those are 2 thin SIDE panels within the drop zone's own depth; this is a full-width wall at the drop zone's REAR boundary | (none — always on, safety-critical — blocks hand access from the front) |
| `sensor_strip()` | 2 independent left/right sensor strips capturing product fall — Z position (350mm world) UNCHANGED, DO-NOT-TOUCH zone per this session's prompt | the NEW per-tray floor sensor holes (Task A.4) — those are a different part, drilled through each tray's own floor, not this strip | `show_sensor` |
| `dashboard()` | ATM screen (PORTRAIT mount this session, Task B.1/B.2) + QR + card reader + speaker | the OLD landscape mount (superseded) | GAP — no toggle |
| `rear_service_door()` | rear access panel — REBUILT this session (Task B.6): full floor-to-ceiling height (was a fixed 50%-height panel in VM-01), width = system_w-10 | | GAP — no toggle |

## Removed this session (VM-02 v1, not an ASSEMBLY entry)

| Module | Why removed |
|---|---|
| `acrylic_display()` | Judgment call (Cross-Cutting Warning, prompt's own instruction to evaluate rather than blindly keep/delete) — the 120mm(then re-derived 133mm)-wide portrait-dashboard compartment has no remaining width/volume for a distinct "display" function separate from the dashboard's own front cutout, and the compartment now requires full floor-to-ceiling rear service access. See VM-02-base-v1.scad header changelog and cc_chat_log.md for full reasoning — flagged for Janis to confirm/override, not silently decided. |

## Toggle-completeness count (2026-07-10, v1)

14 modules called in ASSEMBLY. 3 have a real `show_*` isolation toggle
(`left_zone_door`→`show_door`, `tray_zone_frame`→`show_frame`,
`sensor_strip`→`show_sensor`). 3 are named safety-critical exceptions
(`drop_zone_guards`, `tray_compartment_partition`, `exit_compartment_wall`).
That's **6 of 14 compliant** with the Toggle-Completeness Rule. The
remaining **8 are gaps**, all inherited unchanged from VM-01's own
pre-existing gaps (not introduced or newly created this session, not
retroactively fixed either — out of this prompt's scope, same as VM-01's
own manifest states): `legs`, `outer_shell` (partial panel toggles only,
no master), `compartment_divider`, `tray_rack`, `spring_tray`,
`flap_stopper_rod`, `dashboard`, `rear_service_door`. Flagged here for
Claude Web/Janis to decide whether/which of these warrant a toggle in a
future prompt, rather than silently expanding this session's scope.
