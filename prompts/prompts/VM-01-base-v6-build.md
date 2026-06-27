Hey cc, Claude Web here. This is a major rebuild. 

Read these files from repo github.com/Csmittee/janis-product-design IN THIS ORDER:
1. cc_rules.md
2. WORKFLOW_SKILL.md
3. rules-dimensions.md
4. rules-materials.md
5. vending-machine/VM-01-base/VM-01-base-v5.scad

---

## SAVE AS: vending-machine/VM-01-base/VM-01-base-v6.scad
Never overwrite v5.

---

## PART 1 — TRAY SYSTEM FULL REDESIGN

### Tray parameters to update:
tray_floor_t = 5        // floor thickness (was tray_wall 3mm)
tray_wall_t = 3         // side/rear wall thickness
spring_od = 66
spring_clearance = 50   // space above spring top to next tray floor
tray_h = 121            // tray_floor_t(5) + spring_od(66) + spring_clearance(50)
tray_count = 2
tray_gap = 0            // no gap — next tray floor sits directly above clearance zone

### Tray construction — each tray is INDEPENDENT removable unit:
- Floor: 5mm solid (product weight bearing)
- Front face: FULLY OPEN — no wall, springs and product visible from front
- Top: FULLY OPEN — hand can reach in to lift tray, see-through
- Rear wall: 3mm with motor mount cutouts + latch pin hole (d=8mm, centered)
- Side walls: FRAMED WINDOW only
  - 3mm border frame around perimeter of each side
  - Centre of side wall open (not solid)
  - This allows visibility and hand access
- Lane partitions: DO NOT TOUCH — keep exactly as v5

### Rack structure (new module: tray_rack):
- Fixed to machine body
- Two horizontal rails left and right, depth = tray depth
- Rail cross section: 10mm x 10mm
- Tray slides onto rails from front
- Rear latch: small pin 8mm diameter, 15mm long, on rear wall of rack
  catches latch hole on rear of tray
- Color: #AAAAAA

### Tray Z positions:
- Tray 0 bottom = leg_h + exit_door_h = 50 + 250 = 300mm
- Tray 1 bottom = 300 + 121 = 421mm
- Formula: z = leg_h + exit_door_h + (tray_num * tray_h)

---

## PART 2 — FLOOR PANEL (close product trap gap)

Add new module: trap_floor
- A solid panel that closes the gap between exit zone top and tray 0 bottom
- Position: z = leg_h + exit_door_h = 300mm
- This IS tray 0 floor — so no separate panel needed if tray 0 sits at 300mm
- Verify tray 0 floor sits flush at 300mm with no gap below it
- If any gap exists between 300mm and tray 0 floor bottom face, add a 
  5mm solid panel: full product_w width, full depth minus drop_zone_d

---

## PART 3 — FRONT DOOR

Add new module: front_door
- Single large door covering entire front face of spring + exit zone
- Height: from leg_h(50) to leg_h + exit_door_h + tray_zone_h = 50 + 250 + 242 = 542mm
- Width: product_w - (2 x skin_t) = 412mm
- Thickness: 3mm (stainless panel)
- Hinge: LEFT edge of machine when viewed from front (x = skin_t)
- Shown CLOSED in model
- Color: #C0C0C0 opacity 0.6
- Add hinge cylinders: 3 hinges evenly spaced on left edge
  - Hinge OD: 12mm, height: 20mm
  - Color: #888888

---

## PART 4 — SPRING COMPARTMENT WINDOW FRAME

Add new module: tray_zone_frame
- Visible structural frame around entire tray zone opening on front face
- This is what you see when front door is open
- Top frame bar: 20mm high x product_w wide x skin_t deep at z = 542mm
- Bottom frame bar: 20mm high x product_w wide at z = 300mm  
- Left frame bar: 20mm wide x tray_zone_h tall on left edge
- Right frame bar: 20mm wide x tray_zone_h tall on right edge (at product_w)
- Color: #AAAAAA
- This creates a window-like opening showing the spring trays inside

---

## PART 5 — DASHBOARD (right compartment front face)

Add new module: dashboard
Located on RIGHT compartment front face:
X start = product_w + divider_t + skin_t
Total width = system_w - divider_t - (skin_t x 2) = approx 160mm

### Screen mount (ATM style):
- 7" TFT touch screen
- Physical size: 165mm wide x 100mm tall
- Angle: 30 degrees from horizontal
- Style: recessed 30% into front panel (push screen back into body)
- Curved support bracket underneath (hull between two cylinders, r=10mm)
- Screen center Z: 40% from floor = 320mm from ground
- Screen color: #1A1A1A
- Bezel: #333333, 3mm border around screen

### QR scanner:
- Position: below screen, centered on dashboard
- Cutout: 40mm wide x 30mm tall x 10mm deep
- Z: screen bottom - 50mm
- Color: #222222

### ID card reader slot:
- Position: below QR scanner
- Cutout: 85mm wide x 8mm tall x 15mm deep (card slot)
- Z: QR bottom - 30mm
- Color: #333333

### Speaker grille:
- Position: below ID slot, near bottom of dashboard
- Cutout: 60mm wide x 20mm tall
- Pattern: 5 horizontal slots, 2mm each, 2mm gap
- Z: ID slot bottom - 20mm
- Color: #444444

---

## PART 6 — ACRYLIC DISPLAY ZONE (right compartment)

Replace current acrylic_panel module completely.

### New acrylic covers THREE faces of right compartment:
All above dashboard zone, from dashboard top to roof.

Dashboard top Z = approximately 430mm from ground (above screen + all elements)
Acrylic bottom Z = 430mm
Acrylic top Z = total_h - skin_t = 798mm
Acrylic height = 368mm

#### Front face acrylic panel:
- X: product_w + divider_t
- Width: system_w - divider_t - skin_t
- Depth: skin_t (thin panel in front face)
- Rounded edges: hull with cylinder r=8mm on all 4 corners
- Color: #ADD8E6 opacity 0.3

#### Right side acrylic panel:
- Same height as front panel
- Y: skin_t to total_d - skin_t
- X: total_w - skin_t
- Width: skin_t
- Color: #ADD8E6 opacity 0.3

#### Top acrylic panel:
- Covers top of right compartment
- Z: total_h - skin_t
- Color: #ADD8E6 opacity 0.3

---

## PART 7 — UPDATE rules-dimensions.md

Update these values:
- Tray height: 121mm (floor 5mm + spring OD 66mm + clearance 50mm)
- Tray floor thickness: 5mm (production can use 3mm)
- Tray zone total: 242mm (2 x 121mm)
- Tray construction: independent removable units, open top, open front
- Tray removal: lift + pull forward, rear latch safety
- Rack: fixed rails 10x10mm, rear latch pin 8mm
- Dashboard: right compartment front, ATM style, 30deg screen recess
- Acrylic zone: right compartment only, above dashboard (~430mm) to roof
- Add: Machine purpose = smart donation vending machine, buddha ornaments
- Add: Front door = single panel, left hinge, covers z 50-542mm

---

## PART 8 — UPDATE WORKFLOW_SKILL.md

Update Section 6 Current Status:
- VM-01-base-v5: COMMITTED — springs visible, acrylic wrong position
- VM-01-base-v6: IN PROGRESS — major rebuild, all systems

Update Section 7 Critical Design Decisions Locked — add:
- Tray height = 121mm (5 floor + 66 spring + 50 clearance)
- Trays are INDEPENDENT removable units — not stacked boxes
- Tray top = OPEN, tray front = OPEN, tray sides = framed window only
- Rear latch on every tray — 8mm pin
- Front door = single panel, left hinge, z 50–542mm
- Dashboard = right compartment, ATM style recessed 30deg screen
- Acrylic = right compartment only, above 430mm to roof, 3 faces
- Machine purpose = smart donation vending machine for buddha ornaments
- Payment = online only, no cash/coin mechanism ever

---

After all commits confirm:
1. Every file committed with filename
2. Section 6 WORKFLOW_SKILL.md updated
3. Any dimension ambiguity flagged back to Claude Web before proceeding

Claude Web will QA via screenshot from Janis.
