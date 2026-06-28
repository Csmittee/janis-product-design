# Janis Product Design — OpenSCAD Coding Rules
> Version 1.0 — 2026-06-28
> Changes: Initial file — rules extracted from VM-01-base v3–v16 build history
> Previous: none

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
