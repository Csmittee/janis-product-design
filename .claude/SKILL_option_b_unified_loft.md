# SKILL_option_b_unified_loft.md
# Option B — Unified Neck+Collar Loft for pole_top — Janis Product Design
# Version: 1.0 — 2026-07-01
# Location: .claude/SKILL_option_b_unified_loft.md
# Status: DEFERRED — approved architecture, not yet built. See STATUS below.
# Read when: any session resumes work on pole_top geometry, seam/T-junction
# fixes, or casting-readiness passes on PR-01-base.

---

## STATUS (update this block every time this file is touched)

| Field | Value |
|---|---|
| Decision | CONFIRMED by Janis — Option B is mandatory before casting |
| Build status | NOT STARTED — deferred in favor of assembly completeness (2026-07-01) |
| Reason for deferral | Customer review needs full assembly (base, poles, gears) before deep-polishing one joint |
| Source geometry to build from | PR-01-base-v24.scad — pole_top_housing() + pole_top_neck() (T-junction union, NOT unified) |
| Trigger to resume | Janis says "resume Option B" or "fix pole_top seam" explicitly |
| Re-photo required on resume | YES — Janis will re-supply F5/F6 screenshots of whatever the current pole_top state is at resume time, since other sessions may touch the assembly file structure (e.g. multi-file split) in between |

**Whoever picks this up next (Claude Web or cc): read this entire file before touching pole_top geometry. Do not reconstruct the plan from memory or from CHAT_HANDOFF — CHAT_HANDOFF is single-use and may not contain this detail by the time you read it.**

---

## PROBLEM (why Option B exists)

Current architecture (v18–v24): `pole_top()` = `pole_top_housing()` UNION
`pole_top_neck()` — two separately-lofted bodies joined at a flat interface.
This creates a hard T-junction seam at the neck-to-collar base.

Confirmed by Janis on 2026-07-01 (F6 mesh-view screenshots, v24): the seam
is real geometry — a visible shoulder/step where surface direction and mesh
density change abruptly. It is NOT a rendering artifact; F5 shaded preview
hides it but it will not disappear in cast metal.

**Unacceptable for production** because: aluminum casting with an internal
wedge-lock mechanism (Stage 2, patent-sensitive, deferred) requires a fully
seamless single body — a parting-line/seam at this location interferes with
mold split and internal mechanism clearance.

---

## SOLUTION — pole_top_body() single unified loft

Replace `pole_top_housing()` + `pole_top_neck()` with ONE module,
`pole_top_body()`, lofted continuously from neck bottom to housing bore
end-face. No union of separate bodies.

### Parameterization
Loft runs s=0 (neck bottom) → s=1 (housing far end/bore end-face).

**Zone 1 — Neck (s = 0 → s_blend)**
- Cross-section: circle, d = neck_od (read from rules-dimensions.md — do
  not hardcode; was 47mm as of v24, confirm current value before building)
- Orientation: horizontal plane (XY), stacked vertically along Z
- Equivalent to current neck cylinder — unchanged shape, just now part of
  one continuous loft instead of a separate unioned body

**Zone 2 — Transition blend (s_blend → s_housing_start)** — THE NEW PART
- Cross-section: morphs from circle (neck) to teardrop (housing profile)
  via `lerp(circle_pts, teardrop_pts, t)`
- Orientation: rotates from vertical stack (Z axis) to horizontal loft
  (X axis) via `rotate([0, lerp(0,90,t), 0])`, t: 0→1 across this zone
- Implementation: `hull()` between adjacent rotating profile slices,
  ~20–30 steps for smoothness (more steps = smoother, slower render —
  keep isolated in its own module file so this cost doesn't hit every
  full-assembly render, see multi-file split note below)
- Centerline path: a smooth ARC from (cx, cy, xbar_z − housing_r_circ)
  curving to (cx + dir·…, cy, xbar_z) — explicitly NOT a sharp corner
- This zone is what eliminates the T-junction. Zones 1 and 3 are largely
  unchanged from v24; this is the only genuinely new geometry.

**Zone 3 — Housing (s_housing_start → 1)**
- Cross-section: `profile_pts(r_top, r_bot)` — same smooth cosine blend
  fix already confirmed working in v24 (`(1-cos(a))/2`, see R-112 below)
- Orientation: YZ plane, lofted along X axis
- Same as current housing loft — do not re-solve this, it already passed
  F5 shape QA in v24

### Preserve unchanged from v24 (do not touch)
- D-profile bore subtraction — applies in the neck zone
- Bolt holes — neck zone
- Lever placeholder attachment — housing zone top, unchanged
- `housing_peak_t = 0.60` — confirmed correct in v23/v24
- Smooth cosine profile blend for teardrop cross-section (R-112)

### Explicitly deferred, do not build yet
- Wedge-lock internal mechanism (Stage 2) — patent-sensitive, requires
  Janis's explicit unlock. Lever placeholder only, no internal geometry.

---

## KEY LESSONS THAT PRODUCED THIS PLAN (carry forward — do not repeat)

1. **R-112**: A binary profile condition (`sin(a)>0` or `cos(a)>=0` as a
   hard branch) always creates a sharp corner at the transition angle.
   Always use a smooth blend, e.g. `(1-cos(a))/2`. This was the v23→v24
   fix and it worked — reuse the same principle in the Zone 2 blend above.
2. Rapid-fire prompts are dangerous for geometry. Always local-render
   first (see SKILL_local_render.md) — never send an unverified geometry
   prompt to cc, even a "small" one.
3. A T-junction (union of two separately-lofted bodies) is architecturally
   wrong whenever the part must be cast as one piece. This should be
   decided at Day 1 of any new part, not discovered during QA. Apply this
   lesson proactively to the upcoming base/poles/gears modules too.
4. Max 3 sandbox render loops per session on this problem. If 3 loops
   pass without a confirmed fix, write handoff and stop — do not chase
   perfection in one session (Janis's rule, added Session 4).

---

## BUILD SEQUENCE WHEN RESUMED

1. Confirm this file's STATUS block still matches reality (source version,
   any multi-file split that happened since) — update if stale.
2. Read current rules-dimensions.md for neck_od and any other values that
   may have changed since v24.
3. PRE-SESSION STEP 0 (per chat_rules.md): install OpenSCAD locally,
   verify with `xvfb-run -a openscad --version`.
4. Build Zone 2 (transition blend) FIRST and in isolation — this is the
   only new geometry. Local-render it alone before combining with Zones 1/3.
5. Combine into full `pole_top_body()`, local-render all angles per
   SKILL_local_render.md (iso, side, front minimum; top/bottom/rear for
   this complexity level).
6. Only once local render confirms a seamless result across all angles:
   write the cc prompt replacing `pole_top_housing()` + `pole_top_neck()`
   with `pole_top_body()`. Follow the 7-section template exactly.
7. Janis re-supplies F5 + F6 screenshots on the new version. PASS requires
   both: no visible shoulder/step at former T-junction location, AND no
   2-manifold warning.
8. Max 3 loops. R-111 triggers per normal rules if exceeded.
