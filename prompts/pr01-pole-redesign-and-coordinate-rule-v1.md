# pr01-pole-redesign-and-coordinate-rule-v1.md
# PR-01-base — Pole Redesign + Coordinate Standard
# Version: 1.0 — 2026-06-30
# Author: Claude Web
# Reference: Janis hand sketch "Pilates_full_tower_design" — see description below

---

## 1. MANDATORY OPENING

```
git fetch origin && git pull origin main
```

Read in order before touching any code:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md — first 3 entries only
4. rules-pr.md
5. rules-dimensions.md
6. .claude/rules-codes.md
7. Latest PR-01-base scad file — read full file before any edit

Check what version exists. Save new file as next version number.

---

## 2. CONTEXT — TWO PARTS IN THIS PROMPT

PART A: Lock coordinate system standard into governance files.
PART B: Redesign pole as single continuous D-profile piece — no separate top collar component.

Janis hand-sketch reference (described, not attached as image — apply from this description):
- "BASE" view: pole base is wide/blocky, D-shaped, tapering, with a round socket pin below
- "Middle" view (plain taper): straight taper from wide base to narrow top, smooth profile
- "TOOTH ZONE" view: same taper, with a "BAR INSERT HOLE" near the very top (a hole drilled
  crosswise through the pole for the crossbar to pass through), and a "TOOTH ZONE" marked
  on the flat face in the middle-upper section (this is the rack/ladder zone for the glider)
- "D shape profile" label points at the flat-cut cross-section — confirms the pole has one
  flat face running its full length, not just at the base
- "WOOD" + "collar" small sketch: bottom of pole has a small separate collar/bushing piece
  where the pole meets the wood bed leg — this is a small bushing component, separate from
  the top of the pole (NOT the same as the previous "top_collar" component which is now removed)
- "Top" sketch: shows the very top of the pole rounded with the bar insert hole — the pole
  TOP ITSELF acts as the collar — there is no separate bolt-on top collar piece anymore

---

## 3. NEW FILES

NONE — save-as only: PR-01-base-v[N+1].scad

---

## 4. PART A — TASKS: Coordinate System Standard

### TASK A1 — Add coordinate standard to rules-dimensions.md

Insert near top of file (after units section if one exists):

```
## COORDINATE SYSTEM STANDARD — ALL MODELS (automotive convention)

Origin: front-left leg corner at floor level (Z=0)
  - "Front" = the end the user faces / foot end of reformer / door side of vending machine
  - "Left" = user's left when standing at front facing the product

X-axis: longitudinal — runs along the LONG side of the product (front to rear)
  - X=0 at front face, X increases toward rear
  - bed_l / total_l runs along X

Y-axis: lateral — runs along the WIDTH of the product (left to right)
  - Y=0 at left edge, Y increases toward right
  - bed_w / total_w runs along Y

Z-axis: vertical — runs upward, Z=0 at floor

OpenSCAD rotation reference (cylinder default axis = Z):
  - To orient cylinder along X (longitudinal): rotate([0,90,0])
  - To orient cylinder along Y (lateral):      rotate([90,0,0])
  - To orient cylinder along Z (vertical):     no rotation needed

Flat-face / D-profile orientation rule:
  - A flat face described as "front to rear / rear to front facing" means the
    flat plane's SURFACE NORMAL points along X (the flat surface lies in the Y-Z plane)
  - This is the orientation needed so a crossbar running along X can glide flush
    against the flat face

QA CHECK — Claude Web reads XYZ gizmo from every OpenSCAD screenshot before
making any orientation diagnosis. Never assume axis mapping.
```

### TASK A2 — Add PR-01 coordinate mapping to rules-pr.md

Insert below the dimensions table:

```
## PR-01 COORDINATE MAPPING (automotive convention — see rules-dimensions.md)
- X = longitudinal = bed_l direction (front foot-end to rear head-end)
- Y = lateral = bed_w direction (left pole pair to right pole pair)
- Z = vertical = floor to tower top
- Origin: front-left leg corner at floor (Z=0)
- Crossbar runs along X → rotate([0,90,0]) in OpenSCAD
- Pole runs along Z → no rotation needed
- Pole D-flat face: surface normal points along X — flat lies in Y-Z plane
- Bed width (Y) = pole-center to pole-center distance
```

### TASK A3 — Add coordinate rule to cc_rules.md

Append:

```
## COORDINATE SYSTEM — READ BEFORE ANY GEOMETRY WORK

Automotive convention (locked in rules-dimensions.md):
  X = longitudinal, Y = lateral, Z = vertical. Origin = front-left leg at floor.

Before writing any rotate()/translate() for a directional component:
1. State axis explicitly in a comment: // crossbar runs along X
2. Along X = rotate([0,90,0]); along Y = rotate([90,0,0])
3. Derive from parameter names (bed_l → X, bed_w → Y) — never assume
```

### TASK A4 — Add coordinate QA rule to chat_rules.md

Append:

```
## Coordinate System QA Rule
- Before any orientation diagnosis: read XYZ gizmo from screenshot — never assume
- Automotive convention: X=longitudinal, Y=lateral, Z=vertical, origin=front-left leg at floor
- State axis mapping out loud before writing any fix
- If no gizmo visible in screenshot: request a view that shows it before diagnosing
```

---

## 5. PART B — TASKS: Pole Redesign

### TASK B1 — Remove separate top_collar module entirely

Delete `pole_top_collar()` module and all calls to it.
The pole itself now extends to the top and serves the collar function.
Remove top_collar related parameters (collar_h, collar_od) from PARAMETERS — or mark
deprecated if other code references them, do not break F5.

### TASK B2 — Redesign pole_body() as single continuous D-profile

The pole is now ONE continuous piece from base to top with this profile, bottom to top:

**Section 1 — Base (0% to ~15% of pole_h):**
- Wide/blocky D-cross-section, approx 46mm-50mm across flat-to-round
- This is the widest point of the pole
- Smooth transition starting immediately above this zone

**Section 2 — Taper zone (~15% to ~85% of pole_h):**
- Smooth continuous taper, D-profile maintained throughout
- Logarithmic curve: wide at bottom of this zone, narrowing toward top of this zone
- At ~85% point, profile reaches approximately 36mm
- TOOTH ZONE (rack gear mounting strip) lives on the flat face within this zone —
  specifically between 40% and 100% of pole_h from the base (a 1-meter-equivalent
  zone per Janis spec — use percentage of pole_h, not fixed mm, since pole_h may change)
  - For now: model the tooth zone as a shallow rectangular groove recess in the flat
    face — do NOT model actual teeth yet, that is a future detail pass
  - Groove dimensions: width = 60% of flat face width, depth = 3mm recess

**Section 3 — Top (~85% to 100% of pole_h):**
- Profile continues narrowing slightly, rounds off at the very top
- Near the top (last ~8% of pole_h), drill a horizontal bore through the pole for
  the crossbar — this is the "BAR INSERT HOLE"
- Bore axis: along X (longitudinal) — `rotate([0,90,0]) cylinder(d = grip_od + 1, ...)`
  per coordinate standard (crossbar runs along X)
- Bore diameter: grip_od + 1mm clearance
- The very top surface is rounded/domed — not flat cut

**D-flat face orientation (CRITICAL — this was wrong in v2/v3):**
- The flat face's surface normal must point along X (front-to-rear direction)
- This means the flat plane itself lies in the Y-Z plane
- In code: if pole base cylinder is built then flat-cut with a subtracting cube,
  the cube must be positioned to remove material on the X-facing side, e.g.:
  `translate([pole_r * 0.75, 0, z]) cube([pole_r, flat_width, step_h], center=true)`
  (cube spans Y, removes material along X — verify this produces a flat face whose
  normal points in +X or -X direction, not +Y/-Y)
- Front pole pair: flat face points toward rear (+X)
- Rear pole pair: flat face points toward front (-X)
- This way the crossbar (running along X) sits flush against the flat face when
  the glider clamp is added in a future pass

### TASK B3 — Add small base collar/bushing at wood interface

Small separate component where pole meets the wood leg top surface:
- Short cylindrical bushing, slightly larger OD than pole base, ~20-30mm height
- Sits flush on top of the wood leg, pole passes through it into the socket below
- This is NOT the removed top_collar — it is a new small module: `pole_base_bushing()`
- Material color: same as mid_clamp (#2C3E50 dark anodized) per existing color table

### TASK B4 — Update crossbar to insert through the new bar-insert-hole

`crossbar_body()` now passes through the hole drilled in TASK B2 Section 3, not through
a separate collar module. Crossbar axis along X per coordinate standard. Two crossbars:
one through front pole pair holes, one through rear pole pair holes.

---

## 6. DO NOT TOUCH

- bed_l, bed_w, bed_h — no changes in this prompt
- grip_od = 32 — OWNER-LOCKED
- leg_w, leg_t — no changes (keep current values)
- pole_mid_clamp() — no changes in this prompt
- pole_base_socket() — no changes in this prompt (bushing is new/separate, socket itself unchanged)
- All VM-01 files — do not touch
- viewer/janis-product-viewer.html — do not touch

---

## 7. QA VERIFICATION

Before committing, cc confirms:
- [ ] F5 renders without errors or warnings
- [ ] No separate top_collar component exists — pole top itself is the collar
- [ ] Pole is one continuous D-profile piece, wide at base, taper through middle, narrow rounded top
- [ ] D-flat face normal points along X (front-to-rear) — NOT along Y
- [ ] Front pole pair flat faces point toward rear; rear pole pair flat faces point toward front
- [ ] Bar insert hole exists near top of each pole, bore axis along X
- [ ] Crossbar passes through bar insert holes — front crossbar through front pair, rear through rear pair
- [ ] Small base bushing component exists at wood/pole interface
- [ ] Tooth zone groove recess visible on flat face (shallow rectangular recess, no teeth yet)
- [ ] rules-dimensions.md, rules-pr.md, cc_rules.md, chat_rules.md all updated with coordinate blocks
- [ ] Version header incremented, no previous version overwritten

---

## 8. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/pr01-pole-redesign-and-coordinate-rule-v1.md ✅ COMPLETE — 2026-06-30
3. Update knowledge.map — add new scad version entry, note top_collar removal
4. Bump version on all changed files
5. Commit all → merge to main
6. Screenshot and send for QA — include a view showing the XYZ gizmo
