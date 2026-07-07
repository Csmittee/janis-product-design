# RULES.md
# Janis Product Design — Numbered Rules Log
# Version: 2.0 — 2026-07-07
# Changes: Added R-005/R-006/R-007, extracted from archived prompts
# 2026-07-05 through today (governance-cc-intro-knowledge-map-rules-refresh).
# New structural content (new numbered rules), not a detail-only change —
# X.0 bump per the Document Versioning Rule. R-001-R-004 untouched.
# Previous: 1.0 — 2026-06-29
# Read by: cc before every SCAD task. Claude Web during diagnosis.
# Format: newest rule at TOP. Append above previous entries. Never delete — mark [DEPRECATED] if superseded.

---

## Standard Units & Governance (from rules.md — retained)

- All dimensions in MILLIMETERS — always
- Pipe OD: 25mm standard (state if different)
- Wall thickness: 2mm aluminum / 3mm steel / 4mm composite
- Tolerance: ±0.5mm unless stated
- Never overwrite files — always increment v1→v2→v3
- Every supplier export → /exports/for-supplier/
- Every prompt saved in /prompts/ before CAD session starts
- Never put more than 400 lines in any rules file — split by domain
- Never delete old rules — mark [DEPRECATED] if changed

## File Naming Convention
[PRODUCT]-[MODEL]-[COMPONENT]-[VERSION]
Examples: PR-01-base-rail-joint-v1.stl / VM-01-frame-corner-v2.scad

## Approval Gates (before moving to next component)
- F5 preview correct
- F6 full render clean — no warnings
- STL → /exports/for-supplier/
- DXF → /exports/for-cnc/
- Prompt → /prompts/
- Screenshot → /renders/
- Relevant rules file updated if new learning

---

## Numbered Rules — Newest First

## R-007 — "Patch vs. real material" pattern
Date: 2026-07-07
When a design change shortens or repositions one part and leaves a
visible/structural gap behind, close the gap by extending the ADJACENT
structural material already in that zone — not by adding a new,
separately-modeled cosmetic piece stacked on top to visually cover it.
A patch piece that renders/hides along with a sibling toggle it isn't
logically part of (e.g. it disappears when an unrelated part's own
show_* toggle is set false) is a reliable tell that it's cosmetic, not
structural — check that dependency directly rather than trusting the render.
Root cause of: vm01-shell-toggle-fix-and-hole-isolation (VM-01-base v51)
TASK 4 — the door's top "metal cap" (added in v48 to fill the gap left
when the acrylic pane's own top boundary was pulled down to clear
tray_zone_frame()'s weld flange) was a separate piece nested inside
`if (show_acrylic) {...}`, so it vanished whenever the acrylic was hidden
— proof it was cosmetic, not independent shell material. Fixed by
shrinking the door leaf's own window cutout instead, letting the leaf's
existing continuous skin fill the space (the same construction the door's
lower/flap zone already used, v49).

## R-006 — Shared-center/radius arc constraint
Date: 2026-07-06
Two geometrically independent-looking features built from the SAME circle
center + radius (e.g. a door's return-flange swing arc and a structural
frame's inner curve) cannot be resized independently without re-checking
both — growing one back toward that shared circle's true radius can
reintroduce the exact collision the resize was meant to relieve, because
both features occupy the identical locus at that radius by construction,
not by coincidence.
Root cause of: VM-01-corner-frame-redesign (v50) — tray_zone_frame()'s
left vertical could NOT be grown to touch the shell's interior wall
(radius (corner_r-1)+e) without recolliding the door, because the door's
own return-flange arc uses the IDENTICAL center/radius (corner_r-1) by
design, for a snug closed fit — confirmed via live CGAL bisection, not assumed.

## R-005 — Render-mode/toggle compound-gating trap
Date: 2026-07-05
A show_* isolation toggle can be correctly declared and correctly
referenced in code, yet still read as "does nothing" if its own
if-condition is compounded with another gate (e.g.
`render_mode=="value" && show_x`) whose value never matches by default —
setting show_x then has zero visible effect regardless of its own value.
Before concluding a toggle is broken/orphaned, grep its EXACT if-condition
and confirm every compounded term, not just the toggle's own name.
Root cause of: VM-01-frame-window-rebuild-v44 Finding B — the door's
acrylic pane was gated on `render_mode=="full" && show_acrylic`;
`render_mode` defaults to `"standard"`, so `show_acrylic` could never take
effect regardless of its own value, inconsistent with its siblings
(show_door/show_flap, which are not render_mode-gated).

## R-004 — One prompt open at a time
Date: 2026-06-29
Never push a second prompt to /prompts/ while cc is executing one.
Wait for cc_chat_log confirmation before writing the next prompt.
Stacked prompts cause version conflicts and unclear QA state.

## R-003 — Debug toggle declaration rule
Date: 2026-06-29
Never comment out a debug variable declaration line (e.g. // show_shell_back = true).
If a module references that variable, OpenSCAD warns "Ignoring unknown variable".
To hide a panel: set value to false. Keep the declaration line active always.

## R-002 — Polygon undercut minimum clearance
Date: 2026-06-29
$fn=64 cylinders undercut theoretical radius by ~0.04mm per r=33mm
formula: r × (1 - cos(180/$fn)).
Epsilon (e=0.01mm) is NOT enough for cylinder-to-flat-face contact.
Minimum clearance for any cylinder near a flat face: 2mm.
Root cause of coil-floor contact in v36 manifold chase.

## R-001 — Implicit union trap (display objects inside structural translate)
Date: 2026-06-29
In OpenSCAD, all children of translate()/rotate()/color() are implicitly unioned.
A display object (coil, motor, partition) placed as a sibling of a structural
difference() body inside the same translate() will union with that body.
If its surface touches any tray face at 0mm clearance = non-manifold.
Fix: call display objects from assembly level as their own named module —
never as siblings inside a structural translate().
Root cause of v17–v36 manifold chase (20 revisions).
