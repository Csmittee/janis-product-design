CC PROMPT — bbq-rear-fender-arch-redesign
================================================================
Repo location: bbq-offset-smoker/BBQ-understructure-v15.scad (new,
source v14)

REVISION NOTE: Replaces the rear fender's cross-sectional profile
entirely — was a flat rectangular plate with 10%-length curve-down
zones at front/rear (the original v10/v12 spec); becomes a real
wheel-arch shape (flat roof + two straight sloped shoulders), solved
directly from wheel radius. This is a genuine geometry redesign of
`rear_fender()`'s profile, not a linkage or datum change. The outward
extension from the firebox shell (300mm, world Y) is UNCHANGED — only
the fender's own length-wise (X-Z, side-view) cross-section changes.

Janis has confirmed, this session: the wheel is a fixed axle with no
suspension travel, so a static build-time clearance check is the real
and complete safety check — no dynamic/compression scenario to design
around.

Janis has also confirmed this construction should be written as a
REUSABLE, WHEEL_R-parametric formula (not today's specific numbers),
because future builds with different wheel sizes must re-derive this
automatically — this is the actual point of this round, not just
building today's fender.

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in
your active context from earlier in THIS session, with no git
pull/merge to main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation —
  governance already current" and go straight to TASKS.
→ NO: FRESH. `git fetch --all && git checkout main && git pull origin
  main`. Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3
  entries). State every file read before writing a line.

Claude Web override: none

Per R-014: state the SPECIFIC real check performed for every QA item,
not a generic "confirmed working."

**MANDATORY FIRST CHECK**: confirm `BBQ-understructure-v14.scad` is
real and current, state its real `rear_fender()` module in full (the
flat-box + curve-down-zone version being replaced), state the real live
`WHEEL_R` value (expect 228.6mm) and `REAR_AXLE_Z` (expect 228.6mm,
world Z=0 convention — confirm live).

## 2. CONTEXT — the real formula, general and parametric

All of the following is a function of `WHEEL_R` alone (plus two fixed
tuning constants below) — NOT hardcoded to today's 228.6mm. State every
computed value live, off the real `WHEEL_R` this file uses, so the same
formula reproduces correctly if `WHEEL_R` ever changes in a future
build.

Fixed tuning constants (name them as real top-level constants, not
inline literals):
- `FENDER_ARCH_TOP_CLEARANCE = 100` (mm) — how far above wheel center
  the flat roof's height is set: `roof_z = WHEEL_R + FENDER_ARCH_TOP_CLEARANCE`
- `FENDER_ARCH_SOLVE_SWING_DEG = 15` — reference swing angle used ONLY
  to solve for the roof half-angle (step 1 below), not the built angle
- `FENDER_ARCH_BUILD_SWING_DEG = 10` — the REAL swing angle the A/B
  slopes are built at (pulls the real edge back from the tangent line
  for margin, confirmed by Janis this session as the working value)

**Step 1 — solve for the roof half-angle `θ`** (no closed form, real
numeric solve required — do NOT hardcode 24.3 as a literal):

```
find θ such that:
  (WHEEL_R + FENDER_ARCH_TOP_CLEARANCE) * sin(θ + FENDER_ARCH_SOLVE_SWING_DEG)
    / cos(θ)  =  WHEEL_R
```

Implement a real numeric solve (bisection over a reasonable θ range,
e.g. 5°–45°, converging to within 0.01° — or an equivalent real
iterative method, state your own chosen approach). Self-check: at
`WHEEL_R = 228.6mm`, this must converge to `θ ≈ 24.3°` — state your
real solved value and confirm it matches this self-check before
proceeding. If it doesn't match, STOP — the solver has a real bug, do
not proceed with a wrong θ.

**Step 2 — construct the profile from the solved `θ`**:
- Roof height: `roof_z = WHEEL_R + FENDER_ARCH_TOP_CLEARANCE`
- Roof half-width: `roof_half_w = roof_z * tan(θ)`
- Roof tip radius from wheel center: `R_tip = roof_z / cos(θ)`
- Zone C: flat segment from `(-roof_half_w, roof_z)` to
  `(roof_half_w, roof_z)` (X-Z, relative to wheel center)
- Zone A/B: STRAIGHT lines (not arcs) from each roof tip to a point at
  angle `(θ + FENDER_ARCH_BUILD_SWING_DEG)`, SAME radius `R_tip` (not
  re-solved — same radius as the tip, only the angle changes):
  `end_x = R_tip * sin(θ + FENDER_ARCH_BUILD_SWING_DEG)`,
  `end_z = R_tip * cos(θ + FENDER_ARCH_BUILD_SWING_DEG)`
- State your real computed values for all of the above (roof_z,
  roof_half_w, R_tip, end_x, end_z) at the current live `WHEEL_R`.

## 3. NEW FILES

None. New `BBQ-understructure-v15.scad` (source v14).

## 4. TASK 1 — Rebuild `rear_fender()`'s profile using the formula above

Replace the existing flat-box + curve-down-zone cross-section entirely
with the C/A/B arch profile (Section 2), extruded along the fender's
existing 300mm outward width (world Y, UNCHANGED from the original
spec — do not re-derive or touch this dimension). Rear wheels only,
same scope as before — confirm no analogous change needed/made to the
front wheels (none exist, unchanged).

Construction: real solid geometry (steel plate representation,
consistent with this project's sheet-metal parts) following the C/A/B
profile as its cross-section, swept/extruded along Y for the 300mm
outward reach. State your real chosen OpenSCAD construction method
(e.g. `linear_extrude` of a 2D profile built from the C/A/B points, or
an equivalent real method) and why.

Weld/attachment to the firebox outer shell: same real requirement as
before — real CGAL contact check, non-empty, genuine structural weld
contact, not just proximity.

**Mandatory real CGAL checks, each with its specific probe (per
R-014)**:
- Fender profile vs. tire (wheel circle, full 360° swept as a solid):
  EMPTY at every point along the new profile, state real margin at the
  closest point (expect real margin near the A/B slope ends, per the
  10° build-swing pulling back from the tangent line — state the real
  distance found, this is the number that proves the clearance claim)
- Fender vs. rear axle/struts: EMPTY, state real margin
- Fender vs. firebox outer shell: NON-EMPTY (real weld contact)
- Full CGAL manifold sweep: `Simple: yes`

## 5. TASK 2 — Lock the formula as a reusable, named convention

This is the actual point of this round — future wheel-size changes must
re-derive this automatically, without a new design conversation.

Add a new named, documented convention to `rules-bbq-fab.md` — suggest
calling it the **Wheel-Radius-Derived Fender Arch Convention** (or your
own better name, state it explicitly if you choose differently) — with
the real formula from Section 2 written out in full, parametrized by
`WHEEL_R`, `FENDER_ARCH_TOP_CLEARANCE`, `FENDER_ARCH_SOLVE_SWING_DEG`,
and `FENDER_ARCH_BUILD_SWING_DEG`. State explicitly: any future fender
build for a different wheel size re-solves θ from this same formula —
this is not a one-off, re-verify by re-running the numeric solve, do
not manually estimate a new θ for a different `WHEEL_R`.

Update `design_scope_of_work_rule.md`'s fender entry to reference this
convention by name rather than restating today's specific numbers.

## 6. DO NOT TOUCH

- Fender's 300mm outward extension (world Y) — unchanged
- Wheel/axle positions, track width — unchanged
- `BBQ-chambers-v22.scad` — read only, zero changes
- Front wheels — no fender exists or is added here, confirm unchanged
- Everything else in `BBQ-understructure-v14.scad` — this round is the
  fender profile only

## 7. QA VERIFICATION

- [ ] Mandatory First Check: real current fender module and live
      WHEEL_R/REAR_AXLE_Z stated
- [ ] Step 1 solve: real numeric method stated, real solved θ stated,
      self-check against θ≈24.3° at WHEEL_R=228.6mm confirmed
- [ ] Step 2 construction: real computed roof_z/roof_half_w/R_tip/
      end_x/end_z stated
- [ ] TASK 1: real construction method stated, all 4 CGAL checks stated
      with specific real probe/margin (especially the tire-clearance
      margin at the A/B slope ends — this is the number that matters)
- [ ] TASK 2: new named convention written into rules-bbq-fab.md in
      full, formula stated parametrically (not with today's numbers
      hardcoded into the rule text itself), design_scope_of_work_rule.md
      updated to reference it by name
- [ ] Full kinetic sweep (steer/fold, lid/door/tray) — `Simple: yes`
      throughout, confirm fender doesn't interfere with anything moving
- [ ] Screenshots: iso/front/side/rear + fender close-up showing the
      new arch profile and the real tire clearance margin
- [ ] Error-Log clean

## 8. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: real
   solved θ, real tire-clearance margin, confirm new convention written.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md — new
   fender profile description, reference the new named convention
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md` and
   `rules-bbq-fab.md` per TASK 2
5. Save as BBQ-understructure-v15.scad (v14 kept, unmodified, on
   record). Bump `BBQ-offset-smoker-base-vX.scad` to the next real
   version (pointer-only), state the real new base filename.
6. Commit all → merge to main
