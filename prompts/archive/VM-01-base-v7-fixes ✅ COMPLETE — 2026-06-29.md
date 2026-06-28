Hey cc, Claude Web here. QA failed on v6. Fix and save as v7.

Read in this order:
1. cc_rules.md
2. WORKFLOW_SKILL.md Section 7
3. rules-dimensions.md (root only)
4. vending-machine/VM-01-base/VM-01-base-v6.scad

Action first:
- DELETE .claude/rules-dimensions.md
- Add to WORKFLOW_SKILL.md Section 7:
  "rules-dimensions.md root is authoritative.
  No duplicate in .claude/ folder ever."

---

## SAVE AS: vending-machine/VM-01-base/VM-01-base-v7.scad

---

## FIX 1 — Total height reduced
total_h = 700 (was 800)

Zone stack confirmed:
- 0–50mm: legs
- 50–300mm: exit door zone
- 300–421mm: tray 0
- 421–542mm: tray 1
- 542–700mm: upper display zone (158mm)

Update every module that references total_h —
audit entire file, do not leave any hardcoded 800 values.

## FIX 2 — Zone heights audit
Verify these exact parameter values:

leg_h = 50
exit_door_h = 250
tray_h = 121
tray_count = 2
tray_zone_h = tray_h * tray_count   // = 242mm
total_h = 700

## FIX 3 — Exit door position
Exit door cutout in outer_shell:
- Z start: leg_h = 50mm
- Z height: exit_door_h = 250mm
- Z end: 300mm
- Width: exit_door_w = 400mm
- Centered on product_w
- Must NOT extend above 300mm

Flap door module same Z:
- translate Z = leg_h = 50mm
- height = exit_door_h = 250mm

## FIX 4 — Spring trays position
Tray 0 bottom Z = 300mm
Tray 1 bottom Z = 421mm
Formula in spring_tray module:
z = leg_h + exit_door_h + (tray_num * tray_h)

## FIX 5 — TFT screen visible
screen_mount module:
- Location: right compartment front face
- X: product_w + divider_t + 10
- Screen center Z: 280mm from ground
  (adjusted for new total_h 700, approx 40% = 280mm)
- Angle: 30 degrees — rotate([-30, 0, 0])
- Screen size: 165mm wide x 100mm tall
- Recessed: Y = skin_t + 20 (pushed 30% into panel)
- Curved support bracket: hull() between two cylinders
  r=8mm below screen, depth 30mm
- Screen color: #1A1A1A
- Bezel: #333333 3mm border

Verify screen_mount() called in ASSEMBLY section.

## FIX 6 — Acrylic display zone
Right compartment only, three faces:
- Z start: 542mm (top of tray zone)
- Z end: total_h - skin_t = 698mm
- Acrylic height: 156mm

Front panel:
- X: product_w + divider_t
- Width: system_w - divider_t - skin_t
- Rounded corners: hull() with cylinder r=8mm
- Color: #ADD8E6 opacity 0.3

Right side panel:
- Y: skin_t to total_d - skin_t
- X: total_w - skin_t
- Same height and color

Top panel:
- Z: total_h - skin_t
- X: product_w + divider_t to total_w - skin_t
- Y: skin_t to total_d - skin_t
- Color: #ADD8E6 opacity 0.3

## FIX 7 — Upper front door cutout in shell
- Z start: leg_h + exit_door_h + tray_zone_h = 542mm
- Z height: total_h - 542 = 158mm
- Width: product_w - (skin_t x 2)
- This is the main front door opening above tray zone

## FIX 8 — Dashboard elements
screen_mount, QR scanner, ID card slot, speaker grille
all must sit within Z range 50–542mm on right compartment.
Verify no dashboard element exceeds Z = 542mm.

QR scanner:
- Cutout 40mm wide x 30mm tall x 10mm deep
- Z: screen bottom minus 50mm
- Color: #222222

ID card reader:
- Cutout 85mm wide x 8mm tall x 15mm deep
- Z: QR bottom minus 30mm
- Color: #333333

Speaker grille:
- Cutout 60mm wide x 20mm tall
- 5 horizontal slots 2mm each, 2mm gap
- Z: ID slot bottom minus 20mm
- Color: #444444

---

## UPDATE rules-dimensions.md
Change:
- Total height: 700mm (was 800mm)
- Upper display zone: 158mm (542–700mm)
- Zone stack confirmed:
  legs 0-50 | exit door 50-300 |
  tray 0 300-421 | tray 1 421-542 |
  upper display 542-700

## UPDATE WORKFLOW_SKILL.md
Section 6:
- VM-01-base-v6: COMMITTED — zones wrong, height wrong
- VM-01-base-v7: IN PROGRESS

Section 7 add/update:
- Total height = 700mm LOCKED — do not change without Janis approval
- Upper display zone = 158mm (542–700mm)
- Zone stack locked as above

Confirm every file committed.
Claude Web will QA via screenshot from Janis.
