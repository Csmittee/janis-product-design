# Janis Product Design — Confirmed Dimensions
# Version: v19 — 2026-07-05
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
| system_w | 185mm | Drives total_w — cannot change without screen layout change |

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
| System zone width | 185mm | Right compartment |
| Divider thickness | 19mm | Between compartments |

## VM-01 Base — Legs

| Dimension | Value | Notes |
|---|---|---|
| Leg height | 50mm | |
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

## VM-01 Base — Tray Compartment Access Gap (NEW 2026-07-05, v46; partition depth corrected v47)

A customer's hand could reach under the lowest spring tray into the tray
compartment from the exit zone — no wall/floor blocked it. Fixed with two
new parts working together:

| Part | Value | Notes |
|---|---|---|
| `tray_compartment_partition()` | Full compartment width, world Y 526-598mm, Z 270-275mm | Fixed/welded (not removable), 5mm thick (`tray_floor_t` convention). Z positioned at the pre-shift `tray_0_z` (270mm) — the anchor the trays moved away from. **CORRECTED 2026-07-05 (v47)**: Y (front) edge moved from `skin_t` (2mm, SUPERSEDED) to `tray_start_d + (tray_d-motor_d-2)` = 526mm — the panel was reaching all the way to the front and physically overlapping `tray_zone_frame()` (confirmed by Janis). Functional requirement: a dropped item must keep falling through the spring's own operative/product-drop length (world Y 138-526mm), not land on the partition and get stuck. New front edge reuses `spring_coil()`'s own rearward-extent expression (`tray_d-motor_d-2`, effectively `spring_l-2`) — not a new magic number. Gap to `tray_zone_frame()`'s furthest reach (`world_arc_cy`=21mm): 505mm |
| `exit_compartment_wall()` | Full compartment width, world Y=138mm (`drop_zone_d`), Z 50-275mm | NEW module — no existing v45 module literally matched "vertical partition/side bracket that holds the flap stopper" (`drop_zone_guards()` are 2 thin side panels that don't block front-to-back reach past Y=drop_zone_d; `flap_stopper_rod()` has no bracket geometry). Rear-facing wall sealing the Y-direction reach-through, UNCHANGED by v47 (position already correct). NOTE (v47): since the partition's Y-range moved to 526-598mm, this wall no longer spatially overlaps the partition directly — this does NOT reopen the gap, since the wall alone already fully blocks all Y-direction movement at Y=138mm for Z 50-275mm regardless of what's further back. "Zero gap to the partition" is no longer a meaningful check under the corrected geometry, flagged explicitly rather than silently asserted |

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
| Sensor strip Z | 280mm | Just below tray 0 floor (tray_0_z - 20) |
| Strip thickness | 5mm | |
| Strip height | 8mm | |
| Center connecting beam | REMOVED 2026-07-05 (v44) | `sensor_strip()` had a fabricated red 2x2mm cube bridging the full gap between the two strips — Janis-confirmed this was never part of the actual design, never merely a "ghost rod" — deleted entirely, not toggled. New `show_sensor` isolation toggle gates the 2 real strips. |
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
| Door Z range (full height) | 50–698mm | CONFIRMED 2026-07-03, unchanged by v42/v43 |
| Door X range (left zone only) | 2–414mm | CONFIRMED 2026-07-03 — product_w zone only, NOT total_w |
| Hinge center, world coords | X=0-(hinge_od/2)=-6mm, Y=HINGE_Y_OFFSET=25mm, Z=FOOT_BASE_H+0=50mm | CHANGED 2026-07-05 (v43) — was `hinge_y=corner_r+5` (a Cousin reference to the cosmetic corner_r tuning parameter); `HINGE_Y_OFFSET` is now a fixed, independent 25mm constant measured from the shell's theoretical SHARP corner (front-plane × left-plane extended, NOT the corner_r fillet's own center) — numerically unchanged (still 25mm), only decoupled so retuning `corner_r` later is a separate clearance check, not an input. Barrel X moved from flush-with-interior (X=2mm) to proud of the exterior wall (X=-6mm, exterior, door opens outward) — this point is now THE datum for the entire door assembly; `left_zone_door()`'s local origin and the shell's recess-pocket cutout each independently re-derive it from shared named constants (`HINGE_Y_OFFSET`/`hinge_od`/`FOOT_BASE_H`), never by reading each other's variables. |
| Return flange depth | 23mm | CONFIRMED 2026-07-03, unchanged by v43 (`HINGE_Y_OFFSET - skin_t`) |
| Curved flange (flange/trim corner) | 12-segment arc, center (skin_t+(corner_r-1), skin_t+(corner_r-1)), radius corner_r-1 | CHANGED 2026-07-05 (v43) — was a hard 90° polygon bend; now follows the shell's actual rounded interior corner, sampled live from `corner_r`/`skin_t` |
| Viewing window (world) | X 27–389mm, Z 55–693mm (362 x 638mm) | CHANGED 2026-07-05 (v44) — resized to match the new H-frame's inner clear opening (see "VM-01 Base — Tray Zone Frame" below), giving a full view of the entire compartment (springs, trays, everything), not just the old tray-zone slice. Local constants (door's own origin): `window_x0=25`/`window_z0=5`/`window_w=362`/`window_h=638`. SUPERSEDES v43: `window_x0=38`/`window_z0=220`/`window_w=336`/`window_h=242` (world Z 270-512mm, the old tray-zone-only slice). The DOOR CUTOUT itself is unchanged by v46 (still one continuous opening) — only the FILL material is now split, see next row. |
| Acrylic/metal split (v46) | Acrylic world Z 370-698mm; metal panel world Z 50-370mm (both X 22-394mm) | CHANGED 2026-07-05 (v46) — the single acrylic fill split into an upper ACRYLIC portion (unchanged top boundary, world Z 698mm) and a lower plain METAL sheet (no vents/cutouts/branding, same border/mounting convention). Split point is a LIVE reference to `tray_stack_z0` (370mm, the post-shift lowest-tray-floor Z) — not a duplicated magic number; if `TRAY_SHIFT_UP` changes again this boundary moves with it. Both pieces share the same `show_acrylic` gate fixed in v44 (Finding B) — not reintroduced as a render_mode bug. SUPERSEDES v44: single acrylic pane, world Z 50-698mm (whole door height). |
| Exit flap dimensions | 300mm W x 150mm H | CONFIRMED 2026-07-03 — supersedes old flap_w=250/flap_h=100 |
| Exit flap hinge | top, swings inward | CONFIRMED 2026-07-03 |
| Exit flap max open angle | 55 deg | CONFIRMED 2026-07-03 |
| Stopper rod | spans left-to-right interior panels, position derived from flap_open_deg, FIXED to cabinet (own module, `flap_stopper_rod()`) | CONFIRMED 2026-07-03, fixed-vs-door_open behavior corrected 2026-07-05 (v42) — no switch yet, deferred |
| Acrylic border overlap | 5mm | CONFIRMED 2026-07-03, formula unchanged by v42/v43 (the v41 framing asymmetry was caused by the flange/panel gap above, not the acrylic formula) |
| Drop zone side guards | 2 solid skin_t-thick panels, X clear of hinge/flange footprint (left), world Y 21.01-140.01mm | CHANGED 2026-07-05 (v43) — `drop_zone_visual()` (single translucent box, 3 of 6 faces blocking the actual product drop path) replaced by `drop_zone_guards()`: top/bottom/front/back ghost faces removed, left/right side faces (genuine hand-access safety guard) kept and rebuilt solid. **CORRECTED 2026-07-05 (v47)**: front-most Y edge raised from `skin_t+e` (2.01mm, SUPERSEDED) to `world_arc_cy+e` (21.01mm) — the old edge poked through the door's own surface plane at `door_open_deg=0` (closed), confirmed by Janis via direct visual render inspection. Both of Janis's suggested references (frame-face-minus-thickness formula, flat 10mm fallback) were checked against live geometry and found insufficient — the hinge-side guard sits close to the door's curved flange, which reaches up to world Y=21mm there, not just to the frame's own 7mm front face. Fixed value reuses `world_arc_cy` (`skin_t+(corner_r-1)`), the SAME shell-interior-corner-curve constant already used identically by `left_zone_door()` and `tray_zone_frame()` — not a new invented number. Rear edge (140.01mm) unchanged. Re-verified: 9-angle sweep + fine 0.5° sweep, ZERO overlap at every `door_open_deg` |
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
| Vertical bar width | 20mm | `frame_bar`, unchanged value — both verticals |
| Crossbar | 10mm thick (Z), world Z 270–280mm | Spans left-to-right between the two verticals (world X 27-389mm) at `tray_0_z` (270mm) — the natural exit/tray-zone boundary. Single structural bar, does NOT split the window into two cutouts |
| Reference point | World (skin_t+(corner_r-1), skin_t+(corner_r-1)) = (21,21)mm | SAME formula as `left_zone_door()`'s `arc_cx`/`arc_cy` (shell's real interior corner curve center), reused independently — this module has no hinge-relative local origin, so no further offset needed |
| Left vertical bar curve | Center (21,21)mm, radius (corner_r-1)-5 = 14mm | Outer edge curved to match the door's own flange arc (same center/radius formula) but pulled back by the SAME 5mm border inset already used for the frame's X/Z insets — clears the door's hinge/flange swept volume at every angle |
| Frame depth (Y) | 2mm | `skin_t` convention, flat bars (crossbar + right vertical) at world Y 7-9mm; left vertical's curved region spans world Y 7-21mm (a "return" shape matching the corner, analogous to the door's own return flange) |
| Collision clearance | ZERO overlap, `door_open_deg` 0-100° | Re-verified (Python/shapely, mirrors the CGAL `intersection()` test) at all 9 mandated angles + a 0.5°-resolution fine sweep across the full 0-100° range — see `cc_chat_log.md` for the full result table |
| Top/bottom weld flanges (v46) | 10mm each (Z), world Z 55-65mm (bottom) and 683-693mm (top) | NEW 2026-07-05 (v46) — for spot-welding the frame to the shell. Built from the SAME 2D cross-section as the crossbar (already proven clear of the door leaf at every angle), placed WITHIN the frame's existing, already-verified Z range (55-693mm) — no new Z-boundary risk. Re-verified: 9-angle sweep + fine sweep, ZERO overlap, same result as above |

SUPERSEDED — DO NOT USE: `Frame bar width=20mm (all four sides)` /
`Frame Z range=300-542mm` (pre-v44 values, wrong reference point + door
collision, see above).

## VM-01 Base — Dashboard (right compartment)

| Dimension | Value | Notes |
|---|---|---|
| Style | ATM recessed | 30 degree screen — LOCKED |
| X start | product_w + divider_t + skin_t | |
| Total width | ~160mm | system_w - divider_t - (skin_t x 2) |
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

## PENDING DESIGN DECISIONS (not yet locked)

| Item | Decision needed | Owner |
|---|---|---|
| Dashboard orientation | Portrait vs landscape — depends on Satu firmware | Janis + firmware team |
| system_w reduction | If portrait confirmed: 185→168mm, total_w 620→603mm | After firmware decision |
| PR-01 dimensions | Not started — Janis to provide measurements | Janis |

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
