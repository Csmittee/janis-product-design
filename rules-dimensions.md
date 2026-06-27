# Janis Product Design — Confirmed Dimensions
# All units: MM

---

## VM-01 Base — Overall

| Dimension | Value | Notes |
|---|---|---|
| Total width | 620mm | |
| Total height | 800mm | |
| Total depth | 550mm | |
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
| Tray height | 86mm | Spring OD 66 + 20mm clearance — LOCKED |
| Tray zone total | 172mm | 2 x 86mm |
| Tray count | 2 | |
| Tray wall thickness | 3mm | |
| Spring OD | 66mm | |
| Spring length | 390mm | |
| Motor depth | 20mm | |
| Spring gap | 20mm | Between lanes |
| Spring lanes | 5 | Per tray |
| Partition height | 40mm | Lane dividers |
| Tray front face | OPEN | Springs visible from customer side — LOCKED |

## VM-01 Base — Tray Z Position Formula

```
z = leg_h + exit_door_h + (tray_num * tray_h)
```
LOCKED — do not change without Claude Web instruction.

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

## VM-01 Base — Acrylic Panel

| Parameter | Value | Notes |
|---|---|---|
| Zone | RIGHT compartment only | LOCKED |
| X start | product_w + divider_t | |
| Width | system_w - divider_t - skin_t | |
| Z start | Above screen | |
| Z end | total_h - skin_t | Roof |
| Left zone | Front door only, no acrylic | LOCKED |
| Left zone range | 472–800mm | |

## VM-01 Base — Screen

| Dimension | Value | Notes |
|---|---|---|
| Screen width | 165mm | |
| Screen height | 100mm | |
| Screen angle | 30° | Tilted toward user |
