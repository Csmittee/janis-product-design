# PR-01-base-v24 — Smooth Profile Function + Remove Blend Ring
# Written by: Claude Web — 2026-07-01
# Save to: /prompts/PR-01-base-v24-smooth-profile.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order. State every file read:
1. cc_rules.md
2. cc_chat_log.md (first 3 entries)
3. rules-dimensions.md
4. pilates-reformer/PR-01-base/PR-01-base-v23.scad

Source: v23. Save as: v24.

---

## 2. CONTEXT

v23 F5 QA FAIL — two related issues, same root cause:

**Issue A — Polygon/diamond end-face profile:**
`profile_pts()` used `cos(a)>=0 ? r_bot : r_top` — a binary step.
After `rotate([0,90,0])`, cos(a)=0 at a=90° and a=270° (world ±Y sides).
This creates a sudden jump from r_bot=19mm to r_top=35mm at the sides,
producing visible sharp corners — the housing end-face appears as a
diamond/octagon instead of a smooth oval. Confirmed in multiple F5 angles.

**Issue B — Side gap at neck junction:**
With the binary condition, at a=90° and a=270° (world ±Y sides),
r=r_bot=19mm. The neck has r=23.5mm. Housing is 4.5mm narrower than
the neck at the sides — visible gap.

**Root cause:** binary step function. Both issues disappear with a smooth
cosine blend: `blend=(1-cos(a))/2` gives r=r_bot at bottom (a=0°),
r=r_top at top (a=180°), r=(r_bot+r_top)/2=27mm at sides (a=90°,270°).
27mm > 23.5mm neck radius — side gap closed. No sharp corners.

**Consequence — remove pole_top_neck_blend():**
The blend ring module was added in v23 to close the side gap. With the
smooth profile, the housing sides now cover the neck (r=27mm > 23.5mm)
naturally. The blend ring is no longer needed and creates a double-ring
z-fighting artifact at the housing base. Remove it entirely.

Locally verified in sandbox — smooth profile alone produces a clean
T-junction crease (same as approved concept10). No gap, no polygon.

---

## 3. NEW FILES

NONE.

---

## 4. TASKS

### TASK 1 — Replace `profile_pts()` function

Find this function (one occurrence):

```openscad
function profile_pts(r_top, r_bot, n=48) =
    [for (i=[0:n-1]) let(a=i*360/n, r = cos(a)>=0 ? r_bot : r_top) [r*cos(a), r*sin(a)]];
```

Replace ENTIRE function with:

```openscad
// v24: smooth cosine blend — no sharp corners at sides.
// blend=0 at bottom (a=0°), 0.5 at sides (a=90°/270°), 1 at top (a=180°).
// At sides: r=(r_bot+r_top)/2 ≈ 27mm > neck radius 23.5mm — side gap closed.
// Dome remains on world +Z (top) — direction unchanged from v23.
function profile_pts(r_top, r_bot, n=48) =
    [for (i=[0:n-1]) let(a=i*360/n, blend=(1-cos(a))/2,
        r=r_bot+(r_top-r_bot)*blend) [r*cos(a), r*sin(a)]];
```

### TASK 2 — Remove `pole_top_neck_blend()` module

Delete the entire `pole_top_neck_blend(cx, cy)` module declaration
(added in v23). It is no longer needed — smooth profile closes the gap.
The module is approximately:

```openscad
module pole_top_neck_blend(cx, cy) {
    difference() {
        hull() { ... }
        ...
    }
}
```

Remove the entire module body and its comment header.

### TASK 3 — Remove blend call from `pole_top()` union

In `pole_top()`, find the union block:

```openscad
            union() {
                pole_top_housing(cx, cy, dir);
                pole_top_neck(cx, cy, dir);
                pole_top_neck_blend(cx, cy);  // v22: neck-to-housing gap bridge
            }
```

Replace with:

```openscad
            union() {
                pole_top_housing(cx, cy, dir);
                pole_top_neck(cx, cy, dir);
            }
```

---

## 5. DO NOT TOUCH

- rules-dimensions.md — read only
- VM-01-base — not in scope
- housing_peak_t = 0.60 — correct, do not change
- crossbar_body() DEBUG extension — keep as-is from v23
- pole_top_housing(), pole_top_neck(), pole_top_lever_placeholder() — unchanged
- All global parameters — unchanged
- pole_body(), pole_base_collar(), pole_wood_socket() — unchanged

---

## 6. QA VERIFICATION

State each result explicitly in cc_chat_log:

- [ ] No undefined variable warnings in SCAD console
- [ ] Version saved as v24 — never overwrite v23
- [ ] `profile_pts` uses `blend=(1-cos(a))/2` formula — NOT binary cos/sin.
      State exact function body.
- [ ] `pole_top_neck_blend` module is GONE — confirm deleted.
- [ ] `pole_top()` union has exactly 2 calls: housing + neck. State it.
- [ ] `housing_peak_t` still = 0.60. Confirm.
- [ ] Brace/paren/bracket balance verified. State counts.
- [ ] F5 preview: housing end-face profile is a smooth oval (NOT diamond/
      polygon). State what you see.
- [ ] F5 preview: neck-to-housing junction shows a clean T-junction crease
      with no obvious gap on the sides. State what you see.

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest at TOP, max 10 lines
2. Archive → /prompts/archive/ ✅ COMPLETE — 2026-07-01
3. knowledge.map — no new files, no update needed
4. Bump version v23 → v24
5. Commit all → merge to main
