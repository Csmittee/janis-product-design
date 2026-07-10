# SKELETON_WORKSHEET.md — VM-02
# Skeleton Definition Worksheet + BOM Subassembly Tree + Kinetic Dual-View
# table, per .claude/SKILL_product_design_skeleton.md's own 3 mandatory
# procedures.
#
# Version: 1.0 — 2026-07-10
# RETROACTIVE, per Janis's explicit decision (2026-07-10): VM-02's actual
# design/build work happened FIRST (a direct-cc-chat session, R-011),
# before this governance chain was run — "let the derivation + direct-chat
# fixes finish, then run this chain retroactively — confirming against
# what was actually built, not a blind pre-spec." Every answer below is
# grounded in what VM-02-base-v2.scad ACTUALLY contains (real datums, real
# parent/child offsets, real parts, real kinetic states) — NOT an idealized
# from-scratch skeleton. Mismatches between what was built and what an
# ideal from-scratch skeleton would specify are flagged as findings below,
# not silently smoothed over.
#
# File location note: the parent skill file does not itself specify a
# dedicated save location/filename for these 3 artifacts (only their
# content format) — placed here, in vending-machine/VM-02-base/, matching
# this project's own per-product-subfolder convention (same folder as
# PART_MANIFEST.md, design_scope_of_work_rule.md, and the .scad versions
# themselves), consolidated into ONE file rather than three, since all
# three are explicitly meant to be completed together, in order, from the
# same source material (per the skill file's own timing/sequencing).

---

## PART A — Skeleton Definition Worksheet

```
MASTER ORIGIN: (0, 0, 0) is at the front-left corner of the machine, at
  floor level — matches this project's own global coordinate convention
  (rules-dimensions.md "COORDINATE SYSTEM STANDARD"). In this file's own
  real axis usage: X = machine WIDTH (left-to-right), Y = machine DEPTH
  (front-to-back), Z = height (floor-to-roof). [NOTE: this differs from
  the project-wide doc's stated "X=longitudinal, Y=lateral" labeling —
  VM-01/VM-02 both actually build width along X and depth along Y in their
  real code (confirmed: rounded_box(total_w, h, total_d, r)'s own corner
  placements use X for w/total_w and Y for d/total_d). This is an
  inherited, pre-existing naming mismatch between the doc and the real
  code, not something introduced by VM-02 — flagged here as a retroactive
  finding, not corrected (out of this worksheet's own scope to rename an
  inherited, working convention).]

PRIMARY DATUM:   DATUM_FLOOR (Z=0, the floor plane) — locks the Z axis.
SECONDARY DATUM: The shell's own front-skin plane (world Y=0, where
  outer_shell()'s front cutouts and door_left_x/door_right_x are all
  measured from) — locks the Y axis.
TERTIARY DATUM:  The shell's own left exterior wall plane (world X=0,
  where the front-left door hinge and every X=0-based cutout in
  outer_shell() originates) — locks the X axis.

MAJOR SUB-ASSEMBLIES (one line each, real Parent + offset from the
actual v2.scad code, not idealized):

  Legs() — Parent: DATUM_FLOOR — offset: (leg_inset, leg_inset, 0) x4
    corners, sitting directly on the floor plane.
  Outer Shell (outer_shell()) — Parent: DATUM_FLOOR + DATUM_LEG_TOP
    (=FOOT_BASE_H=leg_h) — offset: ΔZ=leg_h (translate([0,0,leg_h]) in
    ASSEMBLY); the shell's own body is built local-Z-zero-based above
    that point.
  Compartment Divider (compartment_divider()) — Parent: product_w (a
    named constant, not the Skeleton directly, but the SAME shared value
    every other product_w-anchored part reads) — offset: X=product_w
    (422mm).
  Tray Rack + Spring Trays (tray_rack(), spring_tray()) — Parent:
    tray_stack_z0 (itself Parent: DATUM_LEG_TOP, via the tray_0_z/
    TRAY_SHIFT_UP chain) — offset: X=tray_x_inset (23mm), Z=tray_stack_z0
    + tray_num*tray_h (each tray is its own Child of the stack datum, at
    a per-index Z offset).
  Left-Zone Front Door (left_zone_door()) — Parent: its OWN local
    origin, the hinge point (hinge_x=-6, hinge_y=HINGE_Y_OFFSET=25,
    hinge_z=FOOT_BASE_H+skin_t-e=51.99, itself built from named Skeleton-
    level constants, not read from another module's variable) — offset:
    the entire door leaf (window, acrylic, flap, hinge marks) is built
    relative to THIS local origin, then placed in world space with one
    translate() — the exact Parent-Child pattern this skill file's own
    "PROCEDURE — CC" section describes as the target pattern, already
    correctly followed here (inherited from VM-01, not newly built for
    VM-02).
  Tray Zone Frame (tray_zone_frame()) — Parent: the shell's own interior
    corner-curve center (world_arc_cx/cy = skin_t+(corner_r-1)) —
    offset: independently re-derives this same point from the SAME named
    constants (skin_t, corner_r) the door also uses, rather than reading
    the door's own local variable — see FINDING 1 below.
  Dashboard (dashboard()) — Parent: dash_x (=product_w+divider_t+skin_t)
    and screen_top_z (a live datum derived from total_h) — offset:
    centered within dash_w, vertically anchored to screen_top_z.
  Acrylic Display (acrylic_display()) — Parent: acrylic_zone_bot_z
    (=screen_top_z + ACRYLIC_ZONE_MARGIN — a Child of the DASHBOARD's own
    Z datum, not an independent world position) — offset: front/right/top
    panels positioned relative to this Z datum plus the shell's own
    total_w/total_d envelope.
  Rear Service Door (rear_service_door()) — Parent: the system
    compartment's own X-envelope (product_w+divider_t to +system_w) and
    the world floor-to-ceiling Z range (leg_h to total_h-skin_t) —
    offset: centered within (system_w-divider_t).
  Sensor Strip (sensor_strip()) — Parent: sensor_strip_z0 (=tray_stack_z0
    -20, a Child of the tray stack's own datum) — offset: left/right at
    product_w-relative X positions.
  Drop Zone Guards / Tray Compartment Partition / Exit Compartment Wall —
    Parent: tray_0_z / HINGE_Y_OFFSET (shared named constants) — offset:
    fixed positions relative to those, safety-critical, always on.
```

### FINDING 1 — "Shared named constant" is this file's REAL Parent pattern, not pure single-source reference

The skill's own "Four Rules" describe a Child as parented to either (a)
the Skeleton itself, or (b) another part's own local origin. In practice,
VM-02's REAL, inherited-from-VM-01 architecture uses a THIRD pattern
throughout: several modules (`outer_shell()`'s hinge recess,
`tray_zone_frame()`'s corner curve) independently RE-DERIVE the same
point from shared NAMED CONSTANTS (`skin_t`, `corner_r`, `HINGE_Y_OFFSET`,
`hinge_od`, `FOOT_BASE_H`) rather than either reading the Skeleton
directly or reading another part's local origin variable. This is a
real, working, deliberate pattern (documented in `.claude/rules-codes.md`
as "shared named constant, not a cross-module variable read... the
correct pattern") that prevents the "Cousin" anti-pattern the skill warns
against, but it is not literally either of the two Parent types the
skill's Four Rules describe. Flagged here as an honest retroactive
finding — not corrected, since it's a proven, intentional, working
pattern from VM-01's own history, not a bug.

### FINDING 2 — DATUM_* naming predates this skill's own convention

VM-02 inherits VM-01's own `DATUM_FLOOR`/`DATUM_LEG_TOP`/`DATUM_ROOFLINE`
naming (established in VM-01-base-v42, BEFORE this Skeleton skill existed,
2026-07-05). An idealized from-scratch VM-02 skeleton, built fresh under
this skill's own convention, might use different naming (e.g.
`DATUM_PRIMARY`/`DATUM_SECONDARY`/`DATUM_TERTIARY`, matching this
worksheet's own template above). VM-02's real file keeps VM-01's original
names instead — a real, harmless naming-convention mismatch worth noting,
not something to rename retroactively (would be pure churn against a
scheme that already works and is already documented elsewhere).

---

## PART B — BOM Subassembly Tree

```
VM-02 Vending Machine (top assembly)
├── Structural Shell
│   ├── Outer Shell — stainless steel cabinet (5 independently-
│   │   isolatable panels: top/bottom/left/right/back)
│   ├── Legs (x4)
│   └── Compartment Divider
├── Left Compartment — Product/Tray Zone
│   ├── Front Door Assembly
│   │   ├── Door leaf (window cutout + acrylic pane + metal borders)
│   │   ├── Exit flap (top-hinged, swings inward)
│   │   └── Lock provision (placeholder recess only, hardware TBD)
│   ├── Flap Stopper Rod (fixed, independent of door)
│   ├── Tray Zone Frame (structural H-frame: 2 verticals + crossbar +
│   │   weld flanges)
│   ├── Tray Rack (fixed rails + latch pins, one set per tray slot,
│   │   1-5 slots depending on tray_count)
│   ├── Spring Trays (x tray_count, 1-5, default 3) — EACH tray:
│   │   ├── Tray body (floor + walls, open top/front)
│   │   ├── Spring coil + motor (x5 lanes)
│   │   ├── Lane partition (x4, between the 5 lanes)
│   │   └── Floor sensor hole (x5, one per lane — NEW this product line)
│   ├── Drop Zone Guards (x2, left/right, safety-critical)
│   ├── Tray Compartment Partition (safety-critical, seals hand-access gap)
│   ├── Exit Compartment Wall (safety-critical, seals hand-access gap)
│   └── Sensor Strip (x2, left/right, product-fall detection)
└── Right Compartment — System/Dashboard Zone
    ├── Dashboard Assembly (PORTRAIT-oriented this product line)
    │   ├── Touchscreen panel
    │   ├── Bezel
    │   ├── Support bracket
    │   ├── QR scanner
    │   ├── ID card reader
    │   └── Speaker grille
    ├── Lower Metal Panel + component mounting cutouts (NEW this
    │   session — Part 1 of vm02-lower-shell-fill-and-retro-governance)
    ├── Acrylic Display Window (front + right side + top panels)
    └── Rear Service Door (full floor-to-ceiling, this product line)
```

This tree seeds/reconciles against `PART_MANIFEST.md` (already exists for
VM-02, v1.2 as of this session) — the BOM tree above is the coarser
parts-hierarchy view; PART_MANIFEST.md remains the authoritative per-
module toggle-completeness registry. No conflict found between the two
during this extraction.

---

## PART C — Kinetic Dual-View Convention

```
KINETIC PART                    | STATE A (closed/in)      | STATE B (open/out)                | Notes
Front door (left_zone_door)     | door_open=false           | door_open=true, door_open_deg 0-100° (continuous) | Verified via real CGAL at 11 angles (0-100°, 10° steps), Simple:yes throughout
Exit flap                       | flap_open=false           | flap_open=true, flap_open_deg=55°  | Independent of door_open state — both combinations verified
Tray 0 (bottom)                 | tray_out_pct[0]=0         | tray_out_pct[0]=1 (full slide)     | INDEPENDENT per-tray vector, NOT a shared state (VM-01's own single scalar superseded here) — verified with multiple trays at different values simultaneously in one render. Full extension needs door_open=true (see design_scope_of_work_rule.md Functional Feature 8) — a real physical constraint, not a toggle bug
Tray 1                          | tray_out_pct[1]=0         | tray_out_pct[1]=1                  | Same as Tray 0, independently verified
Tray 2                          | tray_out_pct[2]=0         | tray_out_pct[2]=1                  | Same — this is the 3rd tray, present at the default tray_count=3
Tray 3 (tray_count≥4 only)      | tray_out_pct[3]=0         | tray_out_pct[3]=1                  | Only rendered/meaningful when tray_count≥4 — verified at tray_count=5
Tray 4 (tray_count=5 only)      | tray_out_pct[4]=0         | tray_out_pct[4]=1                  | Only rendered/meaningful when tray_count=5 — verified
Rear service door               | (no toggle exists)        | (no toggle exists)                 | **FINDING 3 — real Kinetic Dual-View GAP**: `rear_service_door()` is a single static flat panel with no hinge/rotate geometry and no `show_*`/open-state toggle at all in the current model, despite being a real, hinged door in the product concept (design_scope_of_work_rule.md: "single-side hinge"). Not fixed this session (out of Part 1/Part 2's own scope) — flagged here as a genuine gap for a future prompt, not silently built around.
```

**FINDING 3 detail**: per this skill's own stated rationale ("a toggle
that exists in name but was never wired to the actual geometry... is the
exact failure mode this convention prevents"), the rear service door's
current state is actually a step BEHIND that — there is no toggle at all,
in name or in wiring. Both `left_zone_door()` and the exit flap correctly
follow the Kinetic Dual-View convention (real toggles, both states CGAL-
verified). `spring_tray()`'s per-tray vector is a genuine, correctly-
implemented CONTINUOUS-range kinetic state (the skill's own "a percentage/
travel variable is acceptable if the geometry genuinely needs a continuous
range" allowance). The rear service door is the one real BOM-tree moving
part with no kinetic representation whatsoever — flagged for a future
session, not retrofitted here (this prompt's own DO NOT TOUCH list
excludes `rear_service_door()`'s dimensions, though it does not
explicitly forbid adding a toggle; left untouched out of caution against
silently expanding this session's already-large scope).
