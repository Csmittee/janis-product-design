# Janis Product Design — Confirmed Dimensions
# Version: v2 — 2026-06-29
# All units: MM

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

## VM-01 Base — Screen

| Dimension | Value | Notes |
|---|---|---|
| Screen width | 165mm | |
| Screen height | 100mm | |
| Screen angle | 30° | Tilted toward user |

---

## PENDING DESIGN DECISIONS (not yet locked)

| Item | Decision needed | Owner |
|---|---|---|
| Dashboard orientation | Portrait vs landscape — depends on Satu firmware | Janis + firmware team |
| system_w reduction | If portrait confirmed: 185→168mm, total_w 620→603mm | After firmware decision |
| PR-01 dimensions | Not started — Janis to provide measurements | Janis |
