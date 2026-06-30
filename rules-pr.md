# rules-pr.md
# Janis Product Design — PR-01 Pilates Reformer Rules & Configuration
# Version: 1.2 — 2026-06-30
# Owner: Janis
# Written by: Claude Web
# Read by: cc before every PR-01 SCAD task

---

## PROJECT IDENTITY

Product family: PR-01 Pilates Reformer with Full Tower
Priority variants: Classic Std (fixed pole) + Classic Foldable (fold-inward pole)
First SCAD focus: Joints and frame structure only — no sliding bed, no springs, no straps yet

---

## OVERALL DIMENSIONS — REFERENCE (from supplier images)

| Parameter | Value | Source |
|---|---|---|
| total_l | 2300mm | Maple Reformer ref — PENDING Janis final |
| total_w | 670mm | Maple Reformer ref — PENDING Janis final |
| tower_h | 2060mm | Maple Reformer ref — PENDING Janis final |
| bed_h | 500mm | Estimated from images — PENDING Janis confirm |
| pole_exposed_h | 1560mm | tower_h - bed_h — derived |
| pole_od | 48mm | Default structural pole — PENDING Janis lock |
| grip_bar_od | 32mm | OWNER-LOCKED — human grip, lady/child must hold |
| crossbar_l | 2300mm | Matches total_l — longitudinal only |
| pole_count | 4 | One at each bed corner |

## PR-01 COORDINATE MAPPING (automotive convention — see rules-dimensions.md)
- X = longitudinal = bed_l direction (front foot-end to rear head-end)
- Y = lateral = bed_w direction (left pole pair to right pole pair)
- Z = vertical = floor to tower top
- Origin: front-left leg corner at floor (Z=0)
- Crossbar runs along X → rotate([0,90,0]) in OpenSCAD
- Pole runs along Z → no rotation needed
- Pole D-flat face: surface normal points along X — flat lies in Y-Z plane
- Bed width (Y) = pole-center to pole-center distance

**NOTE:** All dimensions PENDING until Janis measures physical sample or confirms.
Do NOT lock any dimension without Janis written approval in chat.
Exception: grip_bar_od = 32mm is OWNER-LOCKED.

---

## MODULAR ASSEMBLY PHILOSOPHY — CRITICAL

Every component must be designed as a standalone module in SCAD.
Assembly = calling modules, never inline geometry.
This mirrors the physical product: customer assembles with no screwdriver.

### Assembly hierarchy:
```
pr01_assembly()
├── bed_assembly()
│   ├── bed_frame()          — wood box frame, legs, crossmembers
│   └── bed_surface()        — platform top (no slider yet)
├── pole_assembly(corner)    — called 4x, one per corner
│   ├── pole_base_socket()   — female insert drilled into bed leg
│   ├── pole_body()          — main vertical tube
│   ├── pole_mid_clamp()     — adjustable height clamp (spring hook points)
│   └── pole_top_collar()    — crossbar receiver, quick release
└── crossbar_assembly()
    ├── crossbar_body()      — horizontal bar, longitudinal, both front and rear
    └── crossbar_end_cap()   — cap or joint at pole top
```

Foldable variant adds:
```
└── pole_fold_joint()        — replaces pole_body() at fold point
    ├── fold_cone_base()     — strong cone sits on bed surface
    ├── fold_u_bracket()     — pivot holder, heavy duty
    └── fold_hinge()         — folds inward toward bed centerline
```

---

## COMPONENT SPECIFICATIONS

### 1. BED FRAME
- Material: Thai hardwood (ไม้สัก Teak / ไม้ประดู่ Padauk) — premium models
- Low cost alternative: North American Maple or Oak
- Full aluminum option: for budget/commercial line
- Bed frame is a rectangular box — 4 legs + longitudinal rails + end crossmembers
- Legs are thick — must accept pole_base_socket drill-in insert
- No visible external brackets on premium model

### 2. POLE BASE SOCKET (key innovation — patent candidate)
- Concept: like a wall anchor — a metal collar pressed/threaded into drilled hole in bed leg
- The pole snaps or threads into this collar from above
- Customer assembly: zero tools — rotate large knurled nut OR quarter-turn snap lock
- Socket flush with bed leg surface when pole removed
- Material: cast aluminum or stainless steel — machined interior bore
- SCAD model: cylinder with threaded interior detail (display only), flange at top

### 3. POLE BODY
- Structural tube — OD TBD (48mm default, Janis to confirm)
- Options: stainless steel / aluminum alloy / future D-profile
- Exterior: knurled or ladder groove on two faces for height reference and grip hooks
- Length: pole_exposed_h + socket_depth
- SCAD model: cylinder with ladder detail on surface (display ridges)

### 4. POLE MID CLAMP (from CADAM image 1)
- Cylindrical collar clamp body — slides to any height on pole ladder
- Has spring hook eyes on sides (multiple attachment points)
- Thumb-screw or lever lock mechanism — one-hand operation
- Material: cast aluminum body + stainless hardware
- Colors: dark anodized body, polished clamp hardware, red accent lever
- This is the key adjustable element — height sets resistance levels
- SCAD model: cylinder collar + 2 hook eyes + lever accent

### 5. POLE TOP COLLAR — CROSSBAR RECEIVER (key innovation)
- Sits at top of pole
- Crossbar (32mm grip bar) passes through this collar longitudinally
- Quick release: push-button or quarter-turn cam lock
- Must look strong, machined, premium — not a simple clamp
- Options: threaded locking ring (rotate to lock) OR push-pin with spring detent
- Material: cast aluminum or stainless — CNC finished
- SCAD model: cylindrical receiver body, bore = grip_bar_od + tolerance, cam detail

### 6. CROSSBAR (longitudinal grip bar)
- OD: 32mm OWNER-LOCKED
- Two bars: front pair + rear pair (or single front + single rear depending on model)
- Spans full total_l — passes through all 4 pole top collars
- Material options: stainless / aluminum / composite / wood dowel (classic model)
- End caps at each end — decorative + safety
- SCAD model: cylinder, length = total_l, collar positions at pole X coordinates

### 7. FOLD JOINT (foldable variant only)
- Located at bed surface height (fold_z = bed_h = 500mm from floor)
- Fold direction: INWARD toward bed centerline (front pole folds toward rear, rear toward front)
- Components:
  - Cone base: strong truncated cone, sits flat on bed surface, wide base for stability
  - U-bracket pivot: heavy forged bracket, accepts pole pivot pin
  - Hinge pin: large diameter, through-bolt with locking nut — no wiggle
- Fully locked in use, fully flat when folded — poles lie flat on bed surface
- Material: forged steel or cast aluminum — NO sheet metal
- SCAD model: cone + bracket + hinge body, fold angle parameter (0=upright, 90=flat)

---

## VARIANT MATRIX

| Variant | Pole type | Fold | Bed material | Hardware finish | Status |
|---|---|---|---|---|---|
| Classic Std | Fixed | No | Thai hardwood | Polished SS + copper accent | FIRST TO BUILD |
| Classic Foldable | Foldable | Yes inward | Thai hardwood | Polished SS + copper accent | SECOND |
| Contemporary Std | Fixed | No | Oak/Maple or Aluminum | Matte anodized | LATER |
| Contemporary Foldable | Foldable | Yes | Oak/Maple | Matte anodized | LATER |
| Contemporary Electric | Fixed | No | TBD | TBD | FUTURE — separate project |

---

## FUTURE FEATURES — DO NOT MODEL YET

Document here so design leaves space for them. cc reads this and ensures
no geometry blocks these future additions.

- Sliding carriage rail: runs inside bed frame longitudinally — bed frame must have interior clearance
- Spring attachment system: connects to pole mid clamp hook eyes and bed anchor points
- Barrel / spline adjuster: snake rail under bed surface — bed must have underside clearance
- Wunda chair conversion: foot pedal system at foot end — bed end frame must accept bolt pattern
- Cadillac static frame: push bar and roll-down bar — uses existing pole top collar
- Built-in AI sensor: pole body has channel for sensor wire routing — pole must have wire slot
- Variable load system: replaces manual spring hooks — clamp body must accept future module
- Strap / leather cable system: hook eyes on mid clamp already accommodate this

---

## COLOR CODING — PR-01

| Part | Color | Opacity |
|---|---|---|
| Bed frame (wood) | #C8A96E (warm maple) | 1.0 |
| Bed surface platform | #222222 (dark leather) | 1.0 |
| Pole body | #CCCCCC (brushed steel) | 1.0 |
| Mid clamp body | #2C3E50 (dark anodized) | 1.0 |
| Mid clamp hardware | #AAAAAA (polished) | 1.0 |
| Mid clamp lever accent | #C0392B (red) | 1.0 |
| Top collar body | #2C3E50 | 1.0 |
| Crossbar (grip) | #DDDDDD (bright steel) | 1.0 |
| Base socket | #888888 | 1.0 |
| Fold cone base | #555555 (dark steel) | 1.0 |
| Fold lever accent | #C0392B (red) | 1.0 |

---

## SCAD PARAMETER BLOCK — STARTER

cc uses this as the top of PR-01-base-v1.scad:

```openscad
// PR-01-base-v1.scad
// Janis Product Design — Pilates Reformer with Full Tower
// Version: v1
// Date: [cc fills]
// Focus: Frame structure + joints only. No slider, no spring, no strap.
// Rules: rules-pr.md, rules-dimensions.md, .claude/rules-codes.md

// ── Global ────────────────────────────────────────────────────────────
e           = 0.01;   // epsilon — z-fight prevention
$fn         = 32;     // default resolution (use 64 for final render)

// ── Bed dimensions ────────────────────────────────────────────────────
bed_l       = 2300;   // total bed length (longitudinal) — PENDING Janis confirm
bed_w       = 670;    // total bed width — PENDING Janis confirm
bed_h       = 500;    // floor to top of bed surface — PENDING Janis confirm
leg_w       = 120;    // bed leg width (square) — PENDING
leg_t       = 80;     // bed leg depth — PENDING
frame_rail_t = 60;    // bed rail thickness (wood) — PENDING
frame_rail_h = 120;   // bed rail height — PENDING

// ── Pole dimensions ───────────────────────────────────────────────────
pole_od     = 48;     // pole outer diameter — PENDING Janis lock
pole_wall   = 3;      // pole wall thickness (hollow tube)
pole_id     = pole_od - 2*pole_wall;
pole_h      = 1600;   // exposed pole height above bed surface — PENDING
socket_depth = 150;   // how deep socket inserts into bed leg — PENDING
total_pole_l = pole_h + socket_depth;

// ── Grip bar (crossbar) ───────────────────────────────────────────────
grip_od     = 32;     // OWNER-LOCKED — do not change without Janis approval
grip_l      = bed_l;  // crossbar length = bed length
grip_offset = 0;      // lateral offset from pole centerline — TBD

// ── Clamp / collar ────────────────────────────────────────────────────
clamp_h     = 80;     // mid clamp body height
clamp_od    = pole_od + 30; // clamp outer diameter
collar_h    = 60;     // top collar height
collar_od   = pole_od + 25; // top collar outer diameter
lever_l     = 40;     // lock lever length

// ── Fold joint ────────────────────────────────────────────────────────
fold_z      = bed_h;  // fold hinge height = bed surface height
cone_base_d = 120;    // fold cone base diameter — PENDING
cone_top_d  = pole_od + 10; // cone top diameter (accepts pole)
cone_h      = 80;     // cone height
fold_angle  = 0;      // 0 = upright, 90 = folded flat on bed

// ── Debug toggles ─────────────────────────────────────────────────────
show_bed        = true;
show_poles      = true;
show_crossbars  = true;
show_mid_clamps = true;
show_top_collars = true;
show_base_sockets = true;
show_fold_joints = false;  // foldable variant — off by default in Classic Std
```

---

## COMPONENT MODE — VIEWER COMPONENTS

When viewer v1.1 is built, these are the PR-01 component names to expose:

| Component ID | Label | Module |
|---|---|---|
| bed_frame | Bed Frame | bed_frame() |
| bed_surface | Bed Surface | bed_surface() |
| pole_body | Pole Body | pole_body() |
| base_socket | Base Socket | pole_base_socket() |
| mid_clamp | Mid Clamp | pole_mid_clamp() |
| top_collar | Top Collar | pole_top_collar() |
| crossbar | Crossbar | crossbar_body() |
| fold_joint | Fold Joint | pole_fold_joint() |

---

## MANIFOLD RULES — PR-01 SPECIFIC

All global manifold rules (M-1 through M-4 in rules-codes.md) apply.
Additional PR-01 specific risks:

- Pole cylinder is hollow (difference) — inner/outer must have wall_t minimum 2mm
- Clamp collar around pole: clamp_id = pole_od + 0.5mm clearance (not 0, not e)
- Fold cone: truncated cone via cylinder(r1, r2) — no coincident faces at bed surface
- Socket bore: bore_d = pole_od + 0.5mm clearance minimum — never pole_od exactly

---

## BUILD SEQUENCE FOR CC

Session 1 (current): Create rules-pr.md (this file) + PR-01-base-v1.scad skeleton
Session 2: bed_frame() + bed_surface() — wood structure, 4 legs, rails
Session 3: pole_base_socket() + pole_body() — socket in leg, tube above
Session 4: pole_mid_clamp() — the adjustable clamp with hook eyes
Session 5: pole_top_collar() + crossbar_body() — top assembly
Session 6: Full assembly — pr01_assembly() calling all modules
Session 7: pole_fold_joint() — foldable variant
Session 8: QA + STL export per component for supplier review

One session = one prompt = one PR. No session starts without prior session QA PASS.
