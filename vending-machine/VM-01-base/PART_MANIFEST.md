# PART_MANIFEST.md — VM-01
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.0 — 2026-07-05
# Source: vending-machine/VM-01-base/VM-01-base-v45.scad ASSEMBLY block
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
| `outer_shell_debug()` | main cabinet shell (called via `translate([0,0,leg_h])`) | | Partial — `show_shell_top`/`show_shell_left`/`show_shell_back`/`show_shell_right` remove individual panels; no single master toggle for the whole module |
| `compartment_divider()` | wall between product zone and system/dashboard zone | | GAP — no toggle |
| `tray_rack()` | fixed rails + latch pins holding trays | | GAP — no toggle |
| `spring_tray()` x2 | removable trays holding springs/product | | GAP — no toggle |
| `acrylic_display()` | RIGHT-compartment upper acrylic panel | the door's own acrylic pane — different part, different module, lives INSIDE `left_zone_door()` instead | GAP (partial) — gated on `render_mode=="full"` only, not a `show_*` isolation toggle. Do NOT add one without confirming with Janis first (per VM-01-governance-batch-post-v44 prompt) |
| `left_zone_door()` | the main hinged front door — includes window + acrylic + flap + flange | | `show_door` |
| `flap_stopper_rod()` | fixed rod that stops the exit flap at full-open | | GAP — no toggle (static, fixed to cabinet — plausible safety-critical-exception candidate, NOT yet formally confirmed by Janis, do not silently assume) |
| `tray_zone_frame()` | structural H-frame reinforcement (2 verticals + 1 crossbar), NOT viewable/acrylic | the acrylic viewing pane — that lives INSIDE `left_zone_door()` instead. Root cause of the v43/v44 QA confusion this manifest exists to prevent | `show_frame` (added v45 — v44 shipped this module's full rebuild with ZERO toggle, which is exactly why its wrong reference point went unnoticed for ~10 versions) |
| `drop_zone_guards()` | solid hand-safety side guards at the exit/drop zone | the old ghost/visual placeholder faces (`drop_zone_visual()`, removed in v43) | (none — always on, safety-critical) |
| `sensor_strip()` | 2 independent left/right sensor strips capturing product fall | a connecting center beam — that never existed in the real design, deleted in v44 | `show_sensor` (internal toggle inside the module, gates both strips) |
| `dashboard()` | ATM screen + QR + card reader + speaker | | GAP — no toggle |
| `rear_service_door()` | rear access panel | | GAP — no toggle |

## Toggle-completeness count (2026-07-05, v45)

13 modules called in ASSEMBLY. 3 have a real `show_*` isolation toggle
(`left_zone_door`→`show_door`, `tray_zone_frame`→`show_frame`,
`sensor_strip`→`show_sensor`). 1 is a named safety-critical exception
(`drop_zone_guards`). That's **4 of 13 compliant** with the
Toggle-Completeness Rule. The remaining **9 are gaps**: `legs`,
`outer_shell_debug` (partial panel toggles only, no master),
`compartment_divider`, `tray_rack`, `spring_tray`, `acrylic_display`
(render_mode-gated, not `show_*`), `flap_stopper_rod`, `dashboard`,
`rear_service_door`.

**Not fixed in this pass** — the VM-01-governance-batch-post-v44 prompt's
explicit scope was TASK 3 (`show_frame` only) plus documentation; it did
not authorize retroactively adding toggles to the other 9. Flagged here
and in cc_chat_log for Claude Web/Janis to decide whether/which of these
warrant a toggle in a future prompt, rather than silently expanding scope
or silently letting the rule look satisfied when it isn't.
