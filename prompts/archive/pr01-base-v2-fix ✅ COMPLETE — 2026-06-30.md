# pr01-base-v2-fix.md
# PR-01-base — v2 Fix Prompt
# Version: 1.0 — 2026-06-30
# Author: Claude Web
# Target file: pilates-reformer/PR-01-base/PR-01-base-v2.scad

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
7. pilates-reformer/PR-01-base/PR-01-base-v1.scad — read full file

---

## 2. CONTEXT

PR-01-base-v1.scad was committed as a skeleton. Three structural issues need fixing in v2.
This prompt addresses geometry + dimension changes only. No new components added.

---

## 3. NEW FILES

NONE — save-as only: PR-01-base-v2.scad

---

## 4. TASKS

### TASK 1 — Fix top collar crossbar orientation

**Root cause:** `pole_top_collar()` module renders the crossbar bore as a vertical cylinder (Z-axis). The crossbar is a horizontal longitudinal bar — it must pass through the collar along the Y-axis (front-to-back direction).

**Fix:** In `pole_top_collar()` and `crossbar_body()`:
- The crossbar cylinder must be oriented with `rotate([90,0,0])` so it runs along Y-axis
- The collar bore that accepts the crossbar must also be Y-axis aligned
- The collar body remains vertical (Z-axis) — only the through-bore and crossbar orientation changes
- Verify visually: collar sits at top of pole like a ring, crossbar passes horizontally through it front-to-back

---

### TASK 2 — Leg size increase + ergonomic bed width confirmation

**Root cause:** Legs appear too slender relative to pole load. Ergonomic research confirms bed_w 670mm is correct (matches Cadillac industry standard ~74cm usable width). No bed width change. Legs need to be 50% larger.

**Fix — parameter changes only:**
```openscad
// FROM:
leg_w       = 120;    // bed leg width
leg_t       = 80;     // bed leg depth

// TO:
leg_w       = 180;    // bed leg width — increased 50% for structural proportion
leg_t       = 120;    // bed leg depth — increased 50% for structural proportion
```

**Pole position rule (confirm in code):** Pole centerline must remain at center of leg face.
- pole_cx[i] must equal leg_corner_x + leg_w/2 (already derived this way — verify only, do not move pole)
- bed_w stays 670mm — no change

---

### TASK 3 — Pole shape: D-profile with logarithmic taper

**Root cause:** Current `pole_body()` is a plain cylinder. Design requires:
- D-shaped cross-section (flat face inward, curved face outward)
- Fat at base: ~46mm effective diameter
- Smooth logarithmic taper from 46mm at base to 36mm at 40% of pole_h
- Stays at 36mm (circular, no longer D) from 40% point to top
- The D cross-section applies only in the tapered lower section (0% to 40%)
- Upper section (40% to 100%) is circular cylinder at 36mm OD

**Implementation approach — approximate loft using hull() steps:**

Use a for-loop with `hull()` to loft cross-sections from base to 40% height.
At each step height `z_i`, compute radius `r_i` using logarithmic decay:

```
// Logarithmic taper: r(z) = r_top + (r_base - r_top) * (1 - ln(1 + z/taper_h) / ln(2))
// where z goes from 0 (base) to taper_h (40% point)
// r_base = 23 (half of 46mm)
// r_top  = 18 (half of 36mm)
// taper_h = pole_h * 0.4
```

For each step, the cross-section is a D-shape:
- Full circle of radius r_i
- MINUS a flat slice on the inward face: `translate([-r_i, 0, 0]) cube([r_i * 0.25, r_i*2, step_h + e], center=true)`
- The flat cut depth = approximately 15% of diameter (aesthetic, not structural spec yet)
- Flat face direction: faces inward toward bed centerline (negative Y in the assembly)

Upper section (40% to 100% of pole_h):
- Simple `cylinder(h = pole_h * 0.6, d = 36, $fn = 64)`
- Translate to start at z = bed_h + pole_h * 0.4

**Color:** Keep `#CCCCCC` (brushed steel) — no change.

**Manifold check:** Ensure hull() steps overlap slightly (step_h + e overlap) to prevent zero-thickness faces between steps. Use at least 12 steps for the taper section.

---

## 5. DO NOT TOUCH

- rules-dimensions.md — read only
- All .scad files except PR-01-base-v2.scad (new file — do not overwrite v1)
- bed_l = 2300 — no change
- bed_w = 670 — no change (ergonomically confirmed correct)
- bed_h = 500 — no change
- grip_od = 32 — OWNER-LOCKED
- All VM-01 files — do not touch
- viewer/janis-product-viewer.html — do not touch

---

## 6. QA VERIFICATION

Before committing, cc confirms:
- [ ] F5 renders without errors or undefined variable warnings
- [ ] Top collar crossbar is visually horizontal — crossbar runs front-to-back through collar ring
- [ ] Legs are visibly larger/blockier than v1
- [ ] Pole lower section has visible D-profile taper — fatter at base, slimmer at ~40% height
- [ ] Pole upper section is a clean round cylinder
- [ ] All 4 poles render correctly with new shape
- [ ] Version header updated: `// Version: v2`
- [ ] No v1 file overwritten

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/pr01-base-v2-fix.md ✅ COMPLETE — 2026-06-30
3. Update knowledge.map — add PR-01-base-v2.scad entry
4. Bump version on cc_chat_log.md header
5. Commit all → merge to main
