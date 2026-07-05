# PART_MANIFEST.md — PR-01
# What every ASSEMBLY-called module actually IS, in plain language.
# Read by: Claude Web + cc, before any QA session and before adding any
# new part. Update this file in the SAME prompt that adds/renames/removes
# any ASSEMBLY-called module — never let it drift from the real file.
#
# Version: 1.0 — 2026-07-05
# Source: pilates-reformer/PR-01-base/PR-01-assembly-v31.scad (top-level
#   includer) + pole_top.scad/leg_socket.scad (flat included module files,
#   both unversioned per the file's own exception). PR-01 is currently
#   PAUSED (see CURRENT_STATE.md) — module names/toggles confirmed from
#   the real committed files, not guessed, per the
#   VM-01-governance-batch-post-v44 prompt's instruction not to rush a
#   guessed version.
#
# ASSEMBLY chain: PR-01-assembly-v31.scad calls `pr01_assembly()`
# (defined in pole_top.scad), which calls `bed_assembly()` +
# `pole_assembly(i)` x4 + `crossbar_assembly()` — each of those 3 is a
# thin wrapper gating its own real sub-parts. `bell_lock_collar()` and
# `leg_socket()` are called separately, directly in
# PR-01-assembly-v31.scad's own per-pole loop (NOT inside
# `pole_assembly()`) — kept there since `leg_socket()` lives in a
# separate included file.
#
# Toggle column key: a `show_*` name means the module is gated by that
# toggle, per the Toggle-Completeness Rule (cc_rules.md).

| Module | What it IS | What it is NOT (only if real confusion risk exists) | Toggle |
|---|---|---|---|
| `bed_frame()` | the bed's leg/frame structure | | `show_bed` (shared with `bed_surface()`, both inside `bed_assembly()`) |
| `bed_surface()` | the bed's flat top surface (where the user lies) | | `show_bed` (shared with `bed_frame()`) |
| `pole_wood_socket()` | old shallow bonded-pocket wood insert (20mm placeholder) | `leg_socket()` — the new >300mm pass-through sleeve design that likely supersedes this; NOT yet retired, flagged as a probable redundancy in rules-dimensions.md, not resolved | `show_wood_sockets` |
| `pole_base_collar()` | old external split-clamp collar (call site RETIRED/commented out, module kept for history) | `bell_lock_collar()` — the current bell-shaped copper/brass holder design that replaced this concept | `show_base_collars` — toggle is now INERT (nothing calls `pole_base_collar()` any more), kept only for symmetry |
| `pole_body()` | the D-profile shaft (main vertical pole, constant diameter) | | `show_pole_bodies` |
| `pole_top()` | the crossbar lock/latch junction (bell/neck/bore housing at the pole's top) | | `show_pole_tops` |
| `crossbar_body()` x2 (front+rear) | the horizontal crossbar tubes users grip | | `show_crossbars` (shared with `crossbar_end_cap()`, both inside `crossbar_assembly()`) |
| `crossbar_end_cap()` x4 | end caps on the 4 crossbar-to-pole junctions | | `show_crossbars` (shared with `crossbar_body()`) |
| `bell_lock_collar()` | bell-shaped copper/brass pole-holder, pushes into the embedded leg socket | the retired `pole_base_collar()` split-clamp design | `show_bell_collars` |
| `leg_socket()` | wood leg + foot pad + embedded pass-through socket sleeve (current design, >300mm) | `pole_wood_socket()` — the old, shallower, likely-redundant insert (see above, NOT retired) | `show_leg_sockets` |

## Toggle-completeness count (2026-07-05)

10 real sub-parts across 3 wrapper assemblies (`bed_assembly()`,
`pole_assembly()` x4, `crossbar_assembly()`) plus 2 directly-called parts
(`bell_lock_collar()`, `leg_socket()`) — **all 10 are toggle-gated**, 0
gaps. PR-01 was already fully compliant with the Toggle-Completeness Rule
before this prompt; no new toggle needed here (unlike VM-01's
`tray_zone_frame()` gap, see the VM-01 `PART_MANIFEST.md`).

Known open item (unrelated to toggle-completeness, already tracked in
rules-dimensions.md): `pole_wood_socket()` (old 20mm placeholder) is still
actively called alongside the new `leg_socket()` — likely redundant, not
resolved by any prompt so far.
