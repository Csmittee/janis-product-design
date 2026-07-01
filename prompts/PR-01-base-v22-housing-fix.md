# PR-01-base-v22 — Housing Orientation Fix
# Written by: Claude Web — 2026-07-01
# Save to: /prompts/PR-01-base-v22-housing-fix.md

---

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order before touching anything. State every file read:
1. cc_rules.md
2. cc_chat_log.md (first 3 entries — newest at top)
3. rules-dimensions.md
4. pilates-reformer/PR-01-base/PR-01-base-v21.scad

**IMPORTANT — ignore any rapid-fire instructions from this session.**
One or two rapid-fire messages were sent to cc today with incorrect
fixes (sin→cos only, and a dir_y variant). Both are superseded entirely
by this prompt. Read v21 from repo as the source — not any intermediate
version. If v22 already exists in repo from a previous rapid-fire, use
v22 as the source and save as v23. State which source version you read.

---

## 2. CONTEXT

v21 F5 QA FAIL — three confirmed issues found via local render (Claude Web
sandbox). All three are fixed in this prompt together.

**Issue 1 — Dome direction wrong (primary):**
`profile_pts()` used `sin(a)<=0` condition. After `rotate([0,90,0])`,
sin(a) maps to world Y (sideways). The dome was spreading sideways
instead of upward. Fix: use `cos(a)>=0` condition — cos(a) maps to
world -Z, so cos(a)<0 → world +Z (dome goes UP). Locally verified.

**Issue 2 — Fat face points outward (secondary):**
`housing_peak_t=0.40` placed the camber peak 10.4mm to the OUTWARD side
of each pole center. The fat/prominent face of the housing was facing
away from the bed instead of toward the bar center. Fix: change to 0.60
— this places the peak 10.4mm to the INWARD side for all 4 poles
(dir=+1 and dir=-1 both correct by symmetry of the formula). Locally
verified in full 4-pole assembly render.

**Issue 3 — Neck-to-housing gap (secondary):**
neck_od=47mm (radius 23.5mm) is wider than housing base circle
housing_r_circ*2=38mm (radius 19mm). A 4.5mm gap existed at the
junction visible from the inward side. Fix: add a new module
`pole_top_neck_blend()` — a hull()-based taper ring that bridges from
housing base diameter (38mm) down to neck_od+2 (49mm) over 4mm height,
with the bore hollow preserved. Locally verified — gap closed cleanly.

**Debug addition:**
Crossbar extended 50mm past each pole joint end for visual pass-through
verification. Marked clearly as DEBUG — revert before production.

---

## 3. NEW FILES

- None (modifying existing v21.scad only)
- No knowledge.map update required

---

## 4. TASKS

### TASK 1 — Fix `profile_pts()` function

Find this function (one occurrence in the file):

```openscad
function profile_pts(r_top, r_bot, n=48) =
    [for (i=[0:n-1]) let(a=i*360/n, r = sin(a)<=0 ? r_bot : r_top) [r*cos(a), r*sin(a)]];
```

Replace ENTIRE function with:

```openscad
// v22: cos(a)>=0 condition — dome goes UP in world +Z.
// rotate([0,90,0]) maps profile -X → world +Z, so cos(a)<0 = top (+Z).
// Old sin(a) condition mapped dome to world Y (sideways) — WRONG.
function profile_pts(r_top, r_bot, n=48) =
    [for (i=[0:n-1]) let(a=i*360/n, r = cos(a)>=0 ? r_bot : r_top) [r*cos(a), r*sin(a)]];
```

### TASK 2 — Change `housing_peak_t` global parameter

Find in the global params block:

```openscad
housing_peak_t      = 0.40;  // peak position along length (0=neck side, 1=front)
```

Replace with:

```openscad
housing_peak_t      = 0.60;  // v22: flipped — fat face now points INWARD toward bar center.
                              // 0.40 placed peak outward (-10.4mm from cx); 0.60 places it
                              // inward (+10.4mm from cx) for both dir=+1 and dir=-1 poles.
```

### TASK 3 — Add new module `pole_top_neck_blend()`

Insert this new module immediately AFTER the closing brace of
`pole_top_neck()` and BEFORE `pole_top_lever_placeholder()`:

```openscad
// pole_top_neck_blend(cx, cy) — closes 4.5mm radial gap between
// neck OD (47mm) and housing base circle (38mm = housing_r_circ*2).
// Hull taper: from housing base circle (d=38) at xbar_z-housing_r_circ
// down 4mm to neck OD+2 (d=49) — then bore subtracted to keep hollow.
// Called from pole_top() inside the structural union(), before bore cut.
// Rule M-1: no color() here — color is applied by the pole_top() caller.
module pole_top_neck_blend(cx, cy) {
    difference() {
        hull() {
            translate([cx, cy, xbar_z - housing_r_circ])
                cylinder(h = e, d = housing_r_circ * 2, $fn = 64);
            translate([cx, cy, xbar_z - housing_r_circ - 4])
                cylinder(h = e, d = neck_od + 2, $fn = 64);
        }
        // Keep bore hollow through the blend zone
        translate([cx, cy, xbar_z - housing_r_circ - 5])
            cylinder(h = 6, d = neck_id, $fn = 64);
    }
}
```

### TASK 4 — Update `pole_top()` — add blend to union

In `pole_top()`, find the `union()` block inside `difference()`:

```openscad
            union() {
                pole_top_housing(cx, cy, dir);
                pole_top_neck(cx, cy, dir);
            }
```

Replace with:

```openscad
            union() {
                pole_top_housing(cx, cy, dir);
                pole_top_neck(cx, cy, dir);
                pole_top_neck_blend(cx, cy);  // v22: neck-to-housing gap bridge
            }
```

### TASK 5 — Update `crossbar_body()` — DEBUG extension

Find `crossbar_body()` module:

```openscad
module crossbar_body(y_pos) {
    color("#DDDDDD", 1.0)
        translate([leg_w/2, y_pos, xbar_z])
            rotate([0, 90, 0])
                cylinder(h = grip_l, d = grip_od);
}
```

Replace with:

```openscad
module crossbar_body(y_pos) {
    // DEBUG v22: bar extended 50mm past each joint end for visual pass-through check.
    // Revert translate to [leg_w/2, ...] and h to grip_l before production.
    color("#DDDDDD", 1.0)
        translate([leg_w/2 - 50, y_pos, xbar_z])
            rotate([0, 90, 0])
                cylinder(h = grip_l + 100, d = grip_od, $fn = 32);
}
```

---

## 5. DO NOT TOUCH

- rules-dimensions.md — read only
- VM-01-base — not in scope
- pole_body(), pole_base_collar(), pole_wood_socket() — unchanged
- pole_top_lever_placeholder() — unchanged
- housing_r_circ, housing_camber_rise, housing_len, neck_h, neck_od,
  neck_id, neck_wall_t, top_bore_d — all unchanged
- xbar_z formula — unchanged
- Any internal mechanism geometry — Stage 2, patent-sensitive, out of scope

---

## 6. QA VERIFICATION

Confirm all before committing. State each result explicitly in cc_chat_log:

- [ ] No undefined variable warnings in SCAD console
- [ ] Version incremented — saved as v22 (or v23 if v22 already exists)
- [ ] `profile_pts` has `cos(a)>=0` condition — NOT sin. State it.
- [ ] `housing_peak_t` = 0.60 in globals. State it.
- [ ] `pole_top_neck_blend` module present after `pole_top_neck`. State it.
- [ ] `pole_top()` union contains 3 calls: housing, neck, neck_blend. State it.
- [ ] `crossbar_body()` translate starts at `leg_w/2 - 50`, h = `grip_l + 100`.
      DEBUG comment present. State it.
- [ ] F5 preview: housing dome visible on TOP of T-junction (not sideways).
      State what you see.
- [ ] F5 preview: bar passes through housing and extends visibly past both ends.
      State what you see.
- [ ] Brace/paren/bracket balance verified (Python or manual count).
      State result.

---

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, max 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-01
3. knowledge.map — no new files, no update needed
4. Bump version on all changed files (v21→v22, or v22→v23)
5. Commit all → merge to main
