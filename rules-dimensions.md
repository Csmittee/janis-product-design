# Janis Product Design — Confirmed Dimensions
# Version: v12 — 2026-07-03
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
| exit_door_h | 250mm | Customer UX — locked by Janis |
| Motor position | BACK of tray | Firmware + physical design |
| Spring direction | Front at Y=0 | Products fall forward |
| Payment | Online only | No cash/coin ever |
| Dashboard screen | 7" landscape 165×100mm | Until firmware portrait confirmed |
| system_w | 185mm | Drives total_w — cannot change without screen layout change |

---

## Zone Stack — LOCKED

| Zone | Z range | Height |
|---|---|---|
| Legs | 0–50mm | 50mm |
| Exit door | 50–300mm | 250mm |
| Tray 0 | 300–421mm | 121mm |
| Tray 1 | 421–542mm | 121mm |
| Upper display | 542–700mm | 158mm |

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

```
z = leg_h + exit_door_h + (tray_num * tray_h)
Tray 0 bottom = 50 + 250 = 300mm
Tray 1 bottom = 300 + 121 = 421mm
```
LOCKED — do not change without Claude Web instruction.

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
| Sensor type | Parallel IR strip pair | Left + right walls |
| Sensor strip Z | 280mm | Just below tray 0 floor (tray_0_z - 20) |
| Strip thickness | 5mm | |
| Strip height | 8mm | |
| Motor position | BACK of tray | Y = tray_d - motor_d — LOCKED |
| Spring direction | Front end at Y=0 | Products fall forward into exit zone — LOCKED |

## VM-01 Base — Front Door

| Dimension | Value | Notes |
|---|---|---|
| Door height | 250mm | EXIT ZONE ONLY — leg_h(50) to exit_top(300mm) — LOCKED |
| Door Z range | 50–300mm | EXIT ZONE ONLY — spring zone 300-542 is OPEN — LOCKED |
| Door thickness | 3mm | Stainless panel |
| Hinge position | Left edge | When viewed from front — LOCKED |
| Hinge count | 3 | Evenly spaced |
| Hinge OD | 12mm | |
| Hinge height | 20mm | |

## VM-01 Base — Tray Zone Frame

| Dimension | Value | Notes |
|---|---|---|
| Frame bar width | 20mm | All four sides |
| Frame Z range | 300–542mm | Tray zone opening |

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
