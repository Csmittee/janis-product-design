# CC PROMPT — VM-01-base-v20 Fix 2-Manifold (Remaining Suspects)
> Version 1.0 — 2026-06-28
> Task: Fix remaining 2-manifold suspects not addressed in v19
> Source: vending-machine/VM-01-base/VM-01-base-v19.scad
> Save as: vending-machine/VM-01-base/VM-01-base-v20.scad
> Save this prompt to: /prompts/VM-01-base-v20-fix-manifold.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching ANYTHING. State each file read:
1. `cc_rules.md`
2. `cc_chat_log.md` (last 3 entries)
3. `rules-dimensions.md`
4. `rules-codes.md`
5. `vending-machine/VM-01-base/VM-01-base-v19.scad` ← READ FULL FILE FIRST

---

## 2. CONTEXT

KT problem analysis (Kepner-Tregoe IS/IS-NOT) was applied to the persistent
2-manifold warning. Key finding: every fix so far targeted outer_shell() but
the warning never cleared — confirming outer_shell() is NOT the source.

v19 fixed two suspects: dashboard() bracket hull and sensor_strip() laser beam.
Three suspects remain unverified, identified by Claude Web code analysis:

1. `spring_coil()` — inner cylinder `spring_l+1` taller than outer `spring_l`
   = inner protrudes 1mm beyond outer top face = open edge = non-manifold
2. `compartment_divider()` — top face lands exactly flush with shell top face
   (zero overlap, shared coplanar face = non-manifold)
3. `tray_zone_frame()` — 4 cubes sharing corner edges only (cc flagged this in v19)

Fix all three in v20. One version, all remaining suspects.

---

## 3. NEW FILES

- `vending-machine/VM-01-base/VM-01-base-v20.scad`

Add to knowledge.map. Mark v19 as Superseded.

---

## 4. TASKS

Read v19.scad fully before writing any change. Apply all three fixes:

### Fix 1 — spring_coil(): inner cylinder height

Locate `spring_coil()` module. Find the inner hollow cylinder inside `difference()`.

The inner cylinder height will be `spring_l+1` (391mm).
This makes the inner 1mm taller than the outer (390mm) = top face is open = non-manifold.

Change: inner cylinder height from `spring_l+1` → `spring_l-1`
This keeps the inner shorter than the outer on both ends — fully enclosed difference().

### Fix 2 — compartment_divider(): add epsilon to height

Locate `compartment_divider()` module.
The divider cube height is `total_h - leg_h` = 650mm.
It is placed at `translate([..., ..., leg_h])` = Z=50.
Top face lands at exactly Z=700 = exactly flush with shell top = coplanar face = non-manifold.

Change: height from `total_h - leg_h` → `total_h - leg_h - skin_t`
This pulls the divider top face 2mm below the shell top — eliminates coplanar contact.

### Fix 3 — tray_zone_frame(): eliminate shared corner edges

Locate `tray_zone_frame()` module. It has 4 cubes in a union():
- Top bar, bottom bar, left bar, right bar — all sharing only corner edges.

Corners-only contact in union() = non-manifold in CGAL evaluation.

Fix: ensure all bars OVERLAP at corners by extending each bar by `frame_bar` 
on the axis where it meets another bar, so they share volume not just edges.

Specifically:
- Left bar: already spans full height `tray_zone_h` — extend X by `frame_bar` 
  so top/bottom bars overlap into it (or extend top/bottom bars to X=0 and X=product_w)
- The cleanest fix: make top bar and bottom bar span full width X=0 to X=product_w,
  and left bar and right bar span only the middle (tray_0_z+frame_bar to tray_zone_top_z-frame_bar).
  This way every corner has solid overlap, not just a shared edge.

Read the live v19 code for exact current values before writing the fix.
Implement whichever approach eliminates all corner-only contacts.

---

## 5. DO NOT TOUCH

- `rules-dimensions.md` — read only, never edit
- `outer_shell()` — no further changes to this module
- `dashboard()` — fixed in v19, do not touch
- `sensor_strip()` — fixed in v19, do not touch
- `WORKFLOW_SKILL.md`, `chat_rules.md`
- All other modules not listed in Tasks above
- Assembly section — no changes

---

## 6. QA VERIFICATION

Before committing, confirm:

- [ ] v20 version header: Version v20, date 2026-06-28
- [ ] spring_coil(): inner cylinder height is `spring_l-1` (NOT spring_l+1)
- [ ] compartment_divider(): height is `total_h - leg_h - skin_t`
- [ ] tray_zone_frame(): no bars share corner-only contact — all corners have volume overlap
- [ ] All other modules unchanged (spot-check outer_shell, dashboard, sensor_strip)
- [ ] rules-codes.md updated with new lessons (see Task below)
- [ ] knowledge.map: v19 → Superseded, v20 → ACTIVE

### Also: Update rules-codes.md to v1.3

Append to the **OpenSCAD 2-Manifold Rules** section:

```
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
```

Bump rules-codes.md to v1.3, date 2026-06-28.

---

## 7. MANDATORY CLOSING

1. Append `cc_chat_log.md` — newest at BOTTOM. Include:
   - Confirm all 3 fixes applied (spring_coil, compartment_divider, tray_zone_frame)
   - State explicitly: "FLAG FOR CLAUDE WEB — Janis must open v20 in OpenSCAD,
     press F6, confirm 2-manifold warning status"
   - If warning still present after v20: list any remaining geometry that could be suspect
2. Archive this prompt → `prompts/archive/` stamped ✅ COMPLETE — 2026-06-28
3. Update `knowledge.map` — v19 → Superseded, v20 → ACTIVE
4. Bump version on all files changed
5. Commit all → merge to main

Confirm every file committed after merge.
