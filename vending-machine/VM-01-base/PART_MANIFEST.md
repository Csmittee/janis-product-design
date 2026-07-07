# PART_MANIFEST.md — VM-01
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.1 — 2026-07-05
# Source: vending-machine/VM-01-base/VM-01-base-v46.scad ASSEMBLY block
#   (reconciled against the real file — several rows corrected vs. the
#   VM-01-governance-batch-post-v44 prompt's pre-v44 draft, see notes below)
#
# Toggle column key: a `show_*` name means the module (or the specific
# sub-part named) is gated by that toggle, per the Toggle-Completeness
# Rule (cc_rules.md). "(none — always on, safety-critical)" is the ONLY
# other permitted value — it must be an explicit, named exception, never
# a silent gap. Anything else in this column is a CONFIRMED GAP against
# that rule, called out explicitly in cc_chat_log rather than hidden here.

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `legs()` | 4 support legs | | GAP — no toggle |
| `outer_shell_debug()` | main cabinet shell (called via `translate([0,0,leg_h])`) | | Partial — `show_shell_top`/`show_shell_bottom`/`show_shell_left`/`show_shell_back`/`show_shell_right` remove individual panels (`show_shell_bottom` added v51, vm01-shell-toggle-fix-and-hole-isolation); no single master toggle for the whole module |
| `compartment_divider()` | wall between product zone and system/dashboard zone | | GAP — no toggle |
| `tray_rack()` | fixed rails + latch pins holding trays | | GAP — no toggle |
| `spring_tray()` x2 | removable trays holding springs/product | | GAP — no toggle |
| `acrylic_display()` | RIGHT-compartment upper acrylic panel | the door's own acrylic pane — different part, different module, lives INSIDE `left_zone_door()` instead | GAP (partial) — gated on `render_mode=="full"` only, not a `show_*` isolation toggle. Do NOT add one without confirming with Janis first (per VM-01-governance-batch-post-v44 prompt) |
| `left_zone_door()` | the main hinged front door — includes window + acrylic + flap + flange | | `show_door` |
| `flap_stopper_rod()` | fixed rod that stops the exit flap at full-open | | GAP — no toggle (static, fixed to cabinet — plausible safety-critical-exception candidate, NOT yet formally confirmed by Janis, do not silently assume) |
| `tray_zone_frame()` | structural H-frame reinforcement (2 verticals + 1 crossbar), NOT viewable/acrylic | the acrylic viewing pane — that lives INSIDE `left_zone_door()` instead. Root cause of the v43/v44 QA confusion this manifest exists to prevent | `show_frame` (added v45 — v44 shipped this module's full rebuild with ZERO toggle, which is exactly why its wrong reference point went unnoticed for ~10 versions) |
| `drop_zone_guards()` | solid hand-safety side guards at the exit/drop zone | the old ghost/visual placeholder faces (`drop_zone_visual()`, removed in v43) | (none — always on, safety-critical) |
| `sensor_strip()` | 2 independent left/right sensor strips capturing product fall | a connecting center beam — that never existed in the real design, deleted in v44 | `show_sensor` (internal toggle inside the module, gates both strips) |
| `tray_compartment_partition()` | NEW (v46) — fixed/welded horizontal panel sealing the space vacated by the tray-stack shift, full compartment width x depth | a removable/access panel — it's structural, not user-facing | (none — always on, safety-critical — blocks hand access from below) |
| `exit_compartment_wall()` | NEW (v46) — fixed/welded rear-facing wall sealing front-to-back reach at the drop-zone/tray-compartment boundary | `drop_zone_guards()` — those are 2 thin SIDE panels within the drop zone's own depth; this is a full-width wall at the drop zone's REAR boundary, a different function | (none — always on, safety-critical — blocks hand access from the front) |
| `dashboard()` | ATM screen + QR + card reader + speaker | | GAP — no toggle |
| `rear_service_door()` | rear access panel | | GAP — no toggle |

## Toggle-completeness count (2026-07-05, v46)

15 modules called in ASSEMBLY (13 from v45 + 2 new safety-critical parts
this round). 3 have a real `show_*` isolation toggle (`left_zone_door`→
`show_door`, `tray_zone_frame`→`show_frame`, `sensor_strip`→
`show_sensor`). 3 are named safety-critical exceptions (`drop_zone_guards`,
`tray_compartment_partition`, `exit_compartment_wall`). That's **6 of 15
compliant** with the Toggle-Completeness Rule. The remaining **9 are
gaps** (unchanged from v45, not touched this round — out of this prompt's
scope): `legs`, `outer_shell_debug` (partial panel toggles only, no
master), `compartment_divider`, `tray_rack`, `spring_tray`,
`acrylic_display` (render_mode-gated, not `show_*`), `flap_stopper_rod`,
`dashboard`, `rear_service_door`.

**Not fixed in this pass** — the VM-01-governance-batch-post-v44 prompt's
explicit scope was TASK 3 (`show_frame` only) plus documentation; it did
not authorize retroactively adding toggles to the other 9, and
VM-01-tray-access-acrylic-split-flange's scope was the 3 specific fixes
listed in its own tasks, not a general toggle sweep. Flagged here and in
cc_chat_log for Claude Web/Janis to decide whether/which of these warrant
a toggle in a future prompt, rather than silently expanding scope or
silently letting the rule look satisfied when it isn't.
