# VM-01-acrylic-corner-fix.md
> Save this prompt to: /prompts/VM-01-acrylic-corner-fix.md

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → rules-dimensions.md →
vending-machine/VM-01-base/VM-01-base-v38.scad
State every file read before writing a single line.

## 2. CONTEXT
Janis reported: the outer shell has a smooth 20mm-radius rounded vertical
corner (corner_r), but the acrylic_display() right-side panel is a flat
cube assuming a square corner — it visibly splits away from the shell's
curve at the front-right (and, by the same math, rear-right) corner.

Root cause, confirmed by calculation (not visual guess): the panel sits at
X = total_w - (skin_t*2) = 636mm, starting at Y = skin_t = 2mm. At Y=2mm,
the shell's actual curved surface (circle of radius corner_r=20 centered
at X=620, Y=20) is only at X≈628.7mm. The flat panel protrudes 7.28mm past
the real curved wall there.

Fix confirmed via local OpenSCAD sandbox render (Claude Web, this session)
and confirmed by Janis for production reasons: in the real build, the
acrylic is a flat sheet screwed in from the inside of the metal frame —
the frame is the visible/structural element, the acrylic does not need to
follow the curve itself. So the correct fix is recessing the panel to stay
entirely within the flat-wall region, not building a curved acrylic panel.

## 3. NEW FILES
None. Save as `VM-01-base-v39.scad` — do not overwrite v38.

## 4. TASKS

### TASK 1 — Fix `acrylic_display()` right-side panel

Current (v38):
```
color("#ADD8E6", 0.3)
translate([total_w - (skin_t*2), skin_t, acrylic_bot_z])
    cube([skin_t, total_d-(skin_t*2), acrylic_zone_h]);
```

Replace with:
```
// FIXED v39: recessed to corner_r on both Y ends — was skin_t, which put
// the panel inside the shell's rounded-corner region (front AND rear),
// causing a 7.28mm protrusion past the curved wall at the front corner.
// Panel now starts/ends exactly where the shell wall goes flat.
color("#ADD8E6", 0.3)
translate([total_w - (skin_t*2), corner_r, acrylic_bot_z])
    cube([skin_t, total_d - (corner_r*2), acrylic_zone_h]);
```

Confirm the front face panel and top face panel of `acrylic_display()` are
unaffected — verified this session: front panel's right edge (X=618) falls
outside the corner's effective arc (sub-0.1mm), top panel same width, no
change needed to either. State this confirmation explicitly in cc_chat_log
rather than silently leaving them untouched.

### TASK 2 — Update `rules-dimensions.md`

Add a note under the Acrylic display zone entry: right-side panel Y-range
is `corner_r` to `total_d - corner_r` (was `skin_t` to `total_d - skin_t`)
as of v39, reason: shell corner clearance, confirmed by Janis this session
(production: acrylic is a flat sheet screwed from inside the frame, does
not need to match the shell's curve).

## 5. DO NOT TOUCH
- Any other module in the file
- `total_w`, `total_h`, `total_d`, `corner_r`, `skin_t` — unchanged values,
  only the acrylic panel's use of them changes
- Front door / flap door — separate task, not in scope here

## 6. QA VERIFICATION
- [ ] F5 renders with no warnings
- [ ] F6 full render — no 2-manifold warnings
- [ ] Acrylic right-side panel no longer extends into either rounded
      corner region (front or rear) — visually confirm against the shell's
      curve in the render
- [ ] Front and top acrylic panels confirmed unaffected (explicit statement)
- [ ] Saved as VM-01-base-v39.scad, v38 untouched
- [ ] rules-dimensions.md updated per TASK 2

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map — v39 new/ACTIVE, v38 superseded
4. Bump version on all changed files
5. Commit all → merge to main
