# Janis Product Design — OpenSCAD Coding Rules
> Version 1.6 — 2026-06-29
> Changes: Added COLOR CODING STANDARD and MANIFOLD SAFETY RULES (M-1 to M-4)
> Previous: 1.5 — 2026-06-29

All units: MM. All rules below are mandatory for every SCAD file in this project.

---

## OpenSCAD 2-Manifold Rules
> These rules prevent broken mesh on F6 render and STL export.
> A 2-manifold error makes the STL unusable for supplier fabrication.

**Rule: No duplicate variable declarations.**
Declare each variable once only in PARAMETERS. OpenSCAD silently uses the last
declared value — no error or warning is thrown. Duplicates cause invisible bugs
where the wrong value is used in earlier expressions.

**Rule: Epsilon offset on coplanar faces.**
Any two modules sharing the same face plane (Y=0, X=0, Z=0 etc) must be offset
by `e=0.01` on that axis. Always declare `e = 0.01` in PARAMETERS near the top.
Coplanar geometry causes z-fighting in preview and can cause 2-manifold on export.

**Rule: Shell must be fully closed.**
Hollow subtract inside a shell must use `total_h-(skin_t*2)` not `total_h-skin_t`.
All 6 faces of a shell must have skin thickness. An open face = not 2-manifold.
Top skin: `total_h-(skin_t*2)` height on hollow. Bottom skin: hollow starts at `skin_t`
(or `leg_h+skin_t` if shell origin is at Z=0 with leg zone below).

**Rule: No hull() for flat panels.**
Use `cube()` for all flat rectangular panels. Reserve `hull()` for rounded or
complex shapes only (e.g. `rounded_box()`). Thin `hull()` geometry (near-zero
thickness on one axis) causes 2-manifold warnings and unreliable STL export.

**Rule: Assembly Z offset must match module internals.**
If a module is called with `translate([0, 0, offset])`, all geometry inside that
module uses local Z=0 as its base. If the module is called without a translate,
internal geometry must use world Z coordinates directly. Never mix both patterns
in the same module — pick one and be consistent.

**Rule: Read the live .scad file before writing any fix.**
cc must open and read the full active .scad file before writing any geometry change.
The v16 Fix 2 error (shell assembly Z broken) happened because cc inferred the
assembly pattern from context instead of reading the file. If the file is not in
repo, stop and ask Janis to push it before proceeding. Never infer structure —
always read first.

**Rule: difference() inner geometry must be strictly smaller than outer on ALL faces.**
Never use outer_dimension+N for the subtract geometry — this creates an open face.
Use outer_dimension-1 (or any value less than outer) to ensure full enclosure.
Example: spring_coil() inner cylinder was spring_l+1, outer was spring_l.
         Inner protruded 1mm above outer top = open edge = non-manifold.
         Fix: inner = spring_l-1.

**Rule: union() geometry must share volume, not just edges or faces.**
Two cubes touching only at a corner edge or sharing only a coplanar face
are non-manifold in CGAL. All joined geometry must have overlapping volume.
Use epsilon or extend one bar into the other to guarantee volume overlap.

**Rule: module geometry must not land exactly flush with shell boundary.**
A component whose face is exactly coplanar with the enclosing shell face
creates a shared face = non-manifold. Always subtract skin_t or epsilon
to ensure the component is fully inside or clearly outside the shell.

**Rule: Never build a tray/box using union() of separate floor + wall pieces.**
When a thin floor cube meets tall wall cubes at a shared Z=0 base, CGAL detects
T-junction topology = non-manifold. The correct pattern is ONE solid outer box
with hollow interior subtracted via difference(). This is always manifold.
Pattern:
  difference() {
    cube([w, d, h]);                              // solid outer
    translate([wall, wall, floor])
      cube([w-(wall*2), d-(wall*2), h-floor+1]); // hollow interior, +1 open top
  }
Never use: union() { thin_floor_cube; tall_wall_cube; tall_wall_cube; }

---

## Variable Declaration Rules

**Rule: Declare in dependency order.**
Variables that reference other variables must be declared AFTER those variables.
OpenSCAD evaluates top-to-bottom. Example: `exit_door_h` must appear before
`tray_0_z = leg_h + exit_door_h`. Declaring out of order produces
"undefined variable" warnings and renders geometry at wrong positions.

**Rule: Group derived values together.**
Keep all variables that depend on each other in the same named block. Do not
scatter them across sections. Example — keep together:
```
exit_door_h = 250;
tray_0_z    = leg_h + exit_door_h;
tray_zone_top_z = tray_0_z + tray_zone_h;
```

**Rule: Comment every derived value with its resolved number.**
```
tray_0_z        = leg_h + exit_door_h;   // 300mm
tray_zone_top_z = tray_0_z + tray_zone_h; // 542mm
```
This makes QA instant — no mental arithmetic required to verify zone stacks.

---

## Module Structure Rules

**Rule: Every module max 30 lines.**
If a module exceeds 30 lines, split it. Long modules hide bugs and make QA
impossible in screenshots.

**Rule: No hardcoded numbers inside modules.**
All dimensions come from named parameters declared in PARAMETERS. If a number
appears inside a module that is not a named parameter, it must be moved up.
Exception: epsilon-style literal offsets (e.g. `h+1` for clean boolean cuts).

**Rule: Use `difference()` with overshooting subtractors.**
Boolean cutouts must extend 1mm past the face being cut to avoid coplanar
subtraction artifacts. Pattern: `translate([x, -1, z]) cube([w, skin_t+2, h])`.
The `-1` and `+2` ensure clean cuts with no paper-thin leftover faces.

**Rule: $fn = 64 for all cylinders and curved geometry.**
Set at top of file as a global. Never override per-shape unless specifically
required. Lower values cause faceted curves on supplier STL.

---

## File and Version Rules

**Rule: Never overwrite — always increment version.**
v13 → v14, never save back to v13. Every version is a permanent record.
The active version is always the highest number in cc_chat_log.md.

**Rule: Version header in every file.**
Every SCAD file must begin with:
```
// Version: vN
// Date: YYYY-MM-DD
// Changes from vN-1:
//   Fix 1: ...
```

**Rule: Keep PARAMETERS section at top, before all modules.**
OpenSCAD is declarative — parameters can be referenced before they appear in
module definitions. But derived variables (expressions) must appear after their
dependencies. Always: globals first, derived values second, modules third,
assembly last.

---

## Z-Stack and Positioning Rules

**Rule: World coordinates, not local, in all module translates.**
Modules that represent fixed machine geometry (shell, doors, trays) must use
world Z coordinates. Use named variables (`tray_0_z`, `leg_h`) — never
hardcode the Z value inside a translate.

**Rule: The zone stack is the source of truth.**
All vertical positioning derives from the locked zone stack in rules-dimensions.md:
```
Legs:         Z   0–50mm
Exit door:    Z  50–300mm
Tray 0:       Z 300–421mm
Tray 1:       Z 421–542mm
Upper display: Z 542–700mm
```
Any module that diverges from this stack is wrong regardless of how it looks
in preview. QA against rules-dimensions.md, not the render.

**Rule: Spring direction is locked.**
Motor at BACK of tray (Y = tray_d - motor_d). Spring front end at Y=0
(drop zone boundary). Products fall forward into exit zone. Never reverse.

**Rule: Local vs world Z — never mix inside one module.**
If a module is called with translate([0,0,offset]) in assembly, ALL geometry
inside that module must use local Z (Z=0 at module base). World Z values must
be converted: local_z = world_z - assembly_offset.
Example: outer_shell() is called with translate([0,0,leg_h]).
Inside outer_shell(), a cutout at world Z=300 must be written as Z=300-leg_h=250.
Never use world Z values directly inside an offset-assembled module.

---

## Color and Opacity Rules

**Rule: Outer shell opacity 0.75 for normal rendering.**
Use 0.15 only for deliberate QA-transparent sessions. Never commit 0.15 as
the final opacity — always restore to 0.75 before supplier export.

**Rule: Acrylic panels: #ADD8E6, opacity 0.15–0.25.**
Left product zone front panel: 0.25 (customer-facing, slightly more visible).
Spring zone selection panel: 0.15 (thinner visual).
Right compartment upper display: 0.30 (decorative display zone).

**Rule: Color is for visualization only — not for supplier.**
STL export strips all color. Color in SCAD is QA tooling, not production spec.
Material and finish specs go in rules-materials.md.

---

## QA Checklist — Before Every Commit

- [ ] F5 preview: no obvious geometry errors or missing faces
- [ ] Error log: zero warnings (especially undefined variable, undefined operation)
- [ ] Version header matches filename (VM-01-base-v16.scad → Version: v16)
- [ ] One declaration per variable in PARAMETERS
- [ ] All modules under 30 lines
- [ ] No hardcoded numbers inside modules
- [ ] e=0.01 declared and applied to all coplanar face modules
- [ ] Shell hollow uses `total_h-(skin_t*2)` on both top and bottom
- [ ] Zone stack matches rules-dimensions.md
- [ ] cc_chat_log.md updated before committing

---

## Module Isolation Testing — MANDATORY for Manifold Debugging

Every SCAD file must support module-level isolation: each module in ASSEMBLY
can be commented out independently without breaking other modules.

Pattern — ASSEMBLY must be structured so each line is standalone:
// legs();
// outer_shell();
// for (t = [0:tray_count-1]) spring_tray(t);  ← comment to isolate
// front_door();

Never combine unrelated modules into one assembly call.

When 2-manifold warning appears — isolate first, fix second.
Method: comment out one module at a time, press F6. Warning disappears = culprit confirmed.
Never write a fix before culprit is confirmed by Janis isolation test.

Inner objects inside tray/box must never land exactly on floor or wall faces.
Offset by e = 0.01 on any contact axis. See .claude/SKILL_problem_solving_kt.md epsilon pattern.

---

## COLOR CODING STANDARD
Color by part type — never by material. Makes manifold contact visually obvious during QA.

| Part type           | Color    | Opacity  |
|---|---|---|
| Tray structural body | #CCCCCC | 1.0      |
| Motor (display only) | #555555 | 1.0      |
| Spring coil (display only) | #888888 | 0.8 |
| Partition (display only)   | #BBBBBB | 1.0 |
| Rack rails and legs        | #AAAAAA | 1.0 |
| Outer shell                | #C8C8C8 | 0.75    |
| Acrylic panels             | #ADD8E6 | 0.15–0.30 |

Display objects (motor, coil, partition) must NEVER use the same color as structural bodies.
Color difference makes surface tangency visible during F5 inspection.

---

## MANIFOLD SAFETY RULES
# Hard-won from v17–v36 manifold chase. Violation = multi-revision debug loop.

### Rule M-1 — Implicit Union Rule (CRITICAL)
All children of translate()/rotate()/color() are implicitly unioned by OpenSCAD.
A display object placed as a SIBLING of a structural difference() body inside the
same translate() will be UNIONED with that body. Surface at 0mm = non-manifold.

WRONG:
  translate([x, y, z]) {
      difference() { tray_body(); cutouts(); }  // structural
      cylinder(h=spring_l, d=spring_od);         // display — SILENTLY UNIONED
  }

RIGHT:
  translate([x, y, z]) difference() { tray_body(); cutouts(); }
  spring_display(lane=i, tray_z=z);  // display called from assembly level

### Rule M-2 — Polygon Undercut Rule
$fn=64 cylinders dip below theoretical radius: r × (1 - cos(180/$fn)) ≈ 0.04mm at r=33mm.
Epsilon e=0.01mm is NOT sufficient for cylinder-to-flat-face contact.
Minimum clearance for any cylinder near a flat face: 2mm.

### Rule M-3 — Contact Receipt Rule
Any object within 5mm of another face MUST have a calculation comment showing gap:
  // Motor rear face: tray_d - motor_d - tray_wall_t - e = 386.99mm — gap to rear wall = 60.01mm ✓
  // Coil bottom: tray_floor_t + 2 = 7mm — gap to floor top = 2mm ✓
No geometry placed near a boundary without a written receipt.

### Rule M-4 — Debug Toggle Rule
Debug visibility toggles MUST be declared as variable assignments above ASSEMBLY.
NEVER comment out a declaration line — set to false to hide. See R-003.
