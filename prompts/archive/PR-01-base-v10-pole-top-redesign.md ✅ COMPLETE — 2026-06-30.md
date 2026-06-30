# cc PROMPT — PR-01-base-v10 — pole_top() Correct Asymmetric Shape + Through-Bore

## 1. REQUIRED READS BEFORE STARTING
- git fetch + pull latest main
- rules-dimensions.md (read only — confirm pole_d=50mm, grip_od=32mm before touching anything)
- cc_rules.md
- pilates-reformer/PR-01-base/PR-01-base-v9.scad (current file — this is the base to modify)
- IMG_3314 sketch description (below in Section 2) — this is the authoritative shape reference, not any prior pole_top() implementation

## 2. CONTEXT
Every prior version (v2–v9) built pole_top() as a placeholder symmetric frustum/cone
(body of revolution). This was never correct. Janis's actual design (sketched in
IMG_3314, two views of the same part) is an **asymmetric "foot/boot"-shaped head**:
flat-ish back edge, rounded/curved front contour, with a **horizontal through-bore**
passing through the WIDE HEAD portion (not the neck) for the crossbar pipe to pass
through and lock. Below the head, the shape necks down to a cylindrical neck that
joins the pole via 2 screws ("ASSY" label in sketch) — this is a separate mechanism
from pole_base_collar()'s 3-bolt split-clamp (already correctly built in v9 — do not
touch or confuse with this part).

This part will require a quick-release latch system in a future stage (NOT this
prompt) — keep wall thickness generous and avoid thin/fragile sections so that
stage isn't blocked by this geometry, but do not design or imply any latch/cam/lever
detail here.

## 3. NEW FILES
NONE — new version of existing PR-01-base file.

## 4. TASKS

1. **pole_top() — full rebuild as asymmetric hull/loft shape, NOT a body of revolution:**
   - Cross-section profile (in the X-Z plane, viewed from the side) is asymmetric:
     flat/near-vertical back edge, curved/rounded front edge — a "foot" or "boot"
     silhouette, wider at top than at the neck. Build via `hull()` of offset 2D
     profile shapes extruded/lofted, or via `hull()` of a small set of primitive
     solids (e.g. a flattened sphere/cylinder stack) positioned to match this
     silhouette — cc's implementation choice, but result must be visibly asymmetric
     front-to-back, not a cone/frustum.
   - Head footprint: scale proportionally to pole_d=50mm — head width and depth
     should clearly exceed the pole diameter (this is the wide "head"), exact
     proportions are cc's design judgment, but must comfortably contain the bore
     in Task 2 with real wall thickness around it (state actual head dimensions
     used in cc_chat_log).
   - Head sits atop a **neck**: cylindrical, diameter = pole_d = 50mm (matches pole
     exactly, no taper), **neck length = 50mm minimum** (matches typical pipe-connector
     length). Neck transitions into the head shape above and aligns with pole_body()
     below.

2. **Through-bore (the crossbar pass-through):**
   - Horizontal bore through the WIDE HEAD portion (not the neck), diameter = 33mm
     (grip_od=32mm + 1mm/-0mm clearance — flag as TBD pending physical fit test,
     this is a snug-fit dimension Janis will need to verify against an actual
     32mm pipe sample).
   - Position the bore so it passes through the head with solid wall material
     visible all around it in the head silhouette (no thin/blown-out walls) —
     keep clearance generous since a future quick-release/latch mechanism will
     need to interface with this region.
   - Bore axis is horizontal, perpendicular to the pole's vertical axis, consistent
     with crossbar orientation already established (read xbar_z / crossbar geometry
     from v8/v9 — do not modify crossbar code, only ensure pole_top()'s bore aligns
     with the existing crossbar Z-position and axis).

3. **Neck-to-pole joint (ASSY, 2 screws):**
   - 2 screw bosses at the neck, M6 hex countersunk screws (clearance hole sized
     for M6 hex countersunk head + shaft, use standard M6 clearance practice —
     state actual hole/counterbore dimensions used in cc_chat_log as this is a
     new placeholder, flag as TBD pending Janis fastener confirmation).
   - This is a 2-screw joint, distinct from pole_base_collar()'s 3-bolt split-clamp
     (6 bolts total) — do not merge or reuse that geometry/parameter set.

4. Update file header comment block: version v9→v10, note the pole_top() asymmetric
   rebuild + through-bore + neck screw joint, date.

## 5. DO NOT TOUCH
- rules-dimensions.md — read only. pole_d=50mm and grip_od=32mm are reference values,
  not to be changed.
- pole_body() — unchanged, full-height uniform 50mm D-profile from v9, do not touch.
- pole_base_collar() — unchanged, v9 split-clamp sleeve (3 bolts/face, 6 total) —
  do NOT confuse with or merge into the new 2-screw neck joint built in this prompt.
- pole_wood_socket() — unchanged.
- Crossbar geometry (xbar_z, grip_l, end caps) — unchanged, only read xbar_z to align
  the bore, do not modify crossbar code itself.
- Any latch/cam/lever/quick-release geometry — explicitly OUT of scope this prompt.
  Generous wall thickness only — no functional latch mechanism yet.
- VM-01-base — not in scope.

## 6. QA VERIFICATION
- [ ] No undefined variable warnings in SCAD
- [ ] Version incremented — save as PR-01-base-v10.scad, never overwrite v9
- [ ] Confirm pole_top() is built via hull/loft of an asymmetric profile — explicitly
      state in cc_chat_log that it is NOT a body of revolution (no d1/d2 cylinder/cone)
- [ ] State actual head width/depth/height dimensions used
- [ ] Confirm neck diameter = 50mm (matches pole_d exactly) and neck length >= 50mm —
      state actual neck length used
- [ ] Confirm bore diameter = 33mm, bore passes through the HEAD (not the neck),
      bore axis aligns with existing crossbar xbar_z and orientation
- [ ] Confirm solid wall material surrounds the bore on all sides (state minimum
      wall thickness measured around the bore)
- [ ] Confirm 2 screw bosses present at the neck (not 3 or 6 — do not confuse with
      base collar), sized for M6 hex countersunk, state actual hole/counterbore
      dimensions used
- [ ] Confirm NO latch/cam/lever/quick-release geometry present anywhere (explicit
      visual code check, state confirmation)
- [ ] Confirm pole_top() renders as visually distinct from pole_base_collar() (no
      shared geometry/parameters between the two)
- [ ] State every placeholder/TBD value used (bore_d=33mm pending fit test, screw
      hole/counterbore dims pending fastener confirm) explicitly in cc_chat_log

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map if new files created
4. Bump version on all changed files (PR-01-base v9→v10)
5. Commit all → merge to main
