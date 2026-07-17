# SKELETON_WORKSHEET.md — BBQ Offset Smoker
> Version 1.11 — 2026-07-17
> Changes: bbq-understructure-v3-wheel-height-tray-handle. Understructure
> branch of Part B's BOM tree REBUILT again: (1) WHEEL_D/WHEEL_R
> 609.6/304.8 -> 400/200, single source both axles, front caster ONE wheel
> -> TWO (same pivot). (2) PRIMARY DATUM chain gets a NEW ground reference:
> true ground moves to local Z=-GROUND_OFFSET(150mm) — chamber_floor_z/
> GRATE_Z themselves UNCHANGED (BBQ-chambers-v11.scad completely locked),
> real grate height above true ground now 928.665mm (was ~700mm),
> superseding the old design_scope_of_work_rule.md target. REAR_AXLE_Z/
> REAR_BRACKET_H recomputed (50mm/350mm); new spacer brackets (front x1
> 394mm, rear x2 278.5mm each) absorb the resulting gaps — front bracket's
> own MID_H/TOP_W/BOT_W/LEG_GAP/LEG_DROP/FRONT_X and rear's own
> REAR_AXLE_X/REAR_TRACK_WIDTH confirmed ZERO diff from v2. (3) Prep trays
> re-hinged at real octagon "apex A" (world Y=0/610, Z=GRATE_Z=778.665 —
> the lid's own parting-line reference point), real CGAL contact confirmed
> (were floating in v2). (4) Tow handle now RIGIDLY WELDED to the front
> axle/caster yoke (v2's "entirely independent" design was WRONG, corrected
> via Janis's own reference photo) — `steer_deg` now coupled-rotates the
> front wheel pair too; handle is now a real T-shaped crossbar,
> `handle_fold_deg` (renamed from v2's `handle_tilt_deg`). Part A's
> Understructure row, Part B's BOM tree, and Part C's Kinetic table all
> updated below. Detail/content update within the SAME 3-part structure,
> not a new artifact — X.Y bump, per this file's own standing convention.
> Previous: 1.10 — 2026-07-17
> Changes: bbq-understructure-v2-axles-swivel-handle. Understructure branch
> of Part B's BOM tree REBUILT: v1's placeholder `legs()`/`casters()`/
> `tow_handle()` REPLACED by 3 real, mutually-independent mechanisms —
> `rear_axle()` (TASK 1, fixed non-swivel, 2 wheels under the firebox,
> REAR_TRACK_WIDTH=857mm real-derived), `front_wheel_support()` (TASK 2,
> REWRITTEN this round against a real Janis sketch — ONE bent-sheet
> bracket, real trapezoid MID_H/TOP_W/BOT_W derived from the chamber's own
> chamfer/chamber_W, CGAL-confirmed flush against `true_octagon_profile()`
> at h=MID_H, single swivel caster reusing TASK 1's own wheel spec),
> `tow_handle_assembly()` (TASK 3, top-view triangle + hinged handle,
> `handle_tilt_deg`/`steer_deg` kinetic, CGAL-confirmed clear of
> `exhaust_room()` at full-vertical tilt by a real 137.5mm/155mm margin).
> Part A's Understructure row and Part C's Kinetic table both updated
> below. `prep_shelves()` UNCHANGED (DO NOT TOUCH) — real intersection
> probe vs the new `front_wheel_support()` confirmed EMPTY (no conflict).
> Detail/content update within the SAME 3-part structure (this file's own
> Part A/B/C), not a new artifact — X.Y bump, per this file's own standing
> versioning convention.
> Previous: 1.9 — 2026-07-17
> Changes: bbq-chambers-v11-firebox-wall-seal. THE REAL FIX for the
> "triangle leak" (1.8's entry below left it KT-exhausted/unexplained).
> Root cause found by Janis directly, independently confirmed by Claude
> via a real local render before any code was written: the octagon
> narrows near the floor (bottom two chamfers); the firebox is a plain
> square — above `chamber_floor_z` the square sticks out past the true
> octagon boundary on both sides, and no part ever closed that region
> (`firebox_near_wall_closure()` only ever covered BELOW `chamber_floor_z`).
> New `firebox_upper_wall_seal()` closes exactly that region, built from
> the real `firebox_square_2d()`/`fixed_side_solid_2d()` boolean (both
> unchanged). Verified: real CGAL probe confirms the two former-gap
> triangles now solid; full kinetic sweep 0-120° and the full assembly
> chain both `Simple: yes`; both panels 5218.8436mm² each, confirmed
> mirror-symmetric. New "Firebox upper wall seal" bullet added to Part B's
> skeleton tree below; Toggle-Completeness count updated.
> Previous: 1.8 — 2026-07-16
> Changes: bbq-chambers-v9-firebox-passage-true-profile. DOES NOT FIX THE
> "TRIANGLE LEAK" — the source prompt theorized `firebox_passage_profile()`'s
> use of `fixed_shell_profile()` (fake diagonal) was the cause; a real
> geometric XOR test proved `fixed_shell_profile()` and the proposed
> replacement (`true_octagon_profile()` ∩ `fixed_side_wedge()`) are
> IDENTICAL shapes, so the rebuild changes zero geometry (passage area
> unchanged, 88209.549116mm² exact match to v8). Still implemented as a
> real cleanup: new `fixed_side_solid_2d()` 2D helper, `fixed_shell_profile()`
> DELETED (zero remaining callers). Part B's Firebox Passage entry
> corrected below to state this plainly — the "triangle leak" symptom is
> UNEXPLAINED after 3 real investigation rounds (PR #121 x2, this
> session), KT-exhausted per this project's own protocol, needs Janis's
> direct input rather than a 4th guess. Detail correction, not a new
> artifact — X.Y bump.
> Previous: 1.7 — 2026-07-16
> Changes: bbq-chambers-v8-regular-octagon-continuous-channel. Two related
> fixes. (1) `chamfer` corrected 150mm->178.665mm (real
> `chamber_W/(2+sqrt(2))` regular-octagon formula — see rules-bbq-fab.md's
> new "Regular Octagon Requirement" section). This forced Part A's PRIMARY
> DATUM to FLIP: `chamber_floor_z` is now the fixed/independent anchor
> (was derived FROM `DATUM_GRATE_Z`); `GRATE_Z` is now DERIVED
> (`chamber_floor_z + chamfer` = 778.665mm, was hardcoded 750mm) —
> `GRATE_Z = chamber_floor_z + chamfer` is circular otherwise, since the
> old chain derived chamber_floor_z FROM GRATE_Z. `grate_clearance`
> RETIRED (its only consumer was the old, now-reversed, chamber_floor_z
> formula). (2) `lid_territory_end_caps()` (PR #121/v6) REMOVED, folded
> into new `lid_territory_margin_fill()` — Part B's Chamber Shell sub-tree
> updated: both the fixed-side tube and the lid-side margin fill are now
> built from the SAME shared `true_octagon_profile()`+`octagon_ring()`
> construction (were two independently-profiled shapes in v7, meeting at
> a seam) — real CGAL boundary probe confirms no closing wall at
> LID_X0/LID_X1 (cross-section area ~5096mm² at the boundary, consistent
> with thin wall_t ring material, not the ~308258mm² a solid closing panel
> would show). Detail correction/addition within the SAME 3-part
> structure, not a new artifact — X.Y bump.
> Previous: 1.6 — 2026-07-15
> Changes: bbq-chambers-v7-fixed-shell-open-channel-rebuild (R-111 territory,
> 3 prior real-but-wrong-module fixes: PR #119 color/opacity, v5's own
> end-cap gap, PR #121's lid_territory_end_caps() hollow rebuild). REAL
> root cause: `fixed_shell_profile()`'s own PARTING-line closing edge (apex
> A to ridge midpoint) was never a real octagon edge -- extruding it the
> full chamber_L length turned that seam into a permanent spanning panel.
> Fixed via `true_octagon_profile()` (real 8-point octagon, no fake edge)
> + `fixed_side_wedge()` (cutting-plane mask applied to an already-hollow
> ring, not baked into the profile). Part B's Chamber Shell entry CORRECTED
> below -- it claimed "TRUE octagon closure" since v3, which was never
> actually true until this version; now accurate. `fixed_shell_profile()`
> KEPT (R-009 duplication check found a 3rd real caller,
> `firebox_passage_profile()`, an explicit separate open item) but no
> longer used by `chamber_outer_tube()`/`chamber_inner_cavity()`. Detail
> correction within the SAME 3-part structure, not a new artifact — X.Y bump.
> Previous: 1.5 — 2026-07-14
> Changes: direct-cc fix (R-011, no prompt file) — Janis's live OpenSCAD-
> desktop review of v5 found the "reads solid, not hollow" complaint STILL
> unresolved (2nd loop on this symptom), plus 3 more concrete items, all
> investigated first via real CGAL checks (R-008). RE-DIAGNOSIS:
> `lid_territory_end_caps()` (v5's own Finding-1 fix) was a SOLID fill
> sitting exactly in an open-lid viewer's sightline — a real design gap in
> the v5 fix itself, not a repeat of PR #119's color/opacity root cause.
> REBUILT as a proper hollow shell. Part A's Lid row updated (margin
> widened 10mm->100mm each end — LID_X0=100/LID_X1=815). Part B's Firebox
> Passage entry updated (inset 10mm->15mm, "triangle gap" investigated —
> no CGAL-provable defect found, real wall material confirmed present).
> Grill Grate entry updated (GRATE_Z repositioned 700->750, aligned to the
> lid parting line, chamber_floor_z unaffected). Detail/content update
> within the SAME 3-part structure, not a new artifact — X.Y bump.
> Previous: 1.4 — 2026-07-14 (direct-cc fix, R-011, no prompt file — 3
> findings from Janis's annotated OpenSCAD-desktop screenshots of the v4
> build): Part B's BOM tree gets 2 new `chamber_shell()` sub-parts:
> `lid_territory_end_caps()` (closes a CGAL-confirmed real gap at both
> lid-territory end margins) and `firebox_passage()` (replaces
> `window_hole()`). Grill Grate entry updated (Y-range CGAL-confirmed
> collision-fixed against the fixed shell's own bottom chamfers).
> Previous: 1.3 — 2026-07-14 (bbq-chambers-v3-closure-exhaust-resize-lid-
> mirror): Part A's Lid row updated (mirrored to Y=0 side, per the new
> Standing Orientation Convention in rules-bbq-fab.md) and Exhaust Room row
> updated (resized 200/200->360/100). Part B's BOM tree gets a new
> Firebox-near-wall-closure sub-part (closes a real gap below
> chamber_floor_z). Part C's Lid kinetic row updated (rotation sign
> flipped, real CGAL-verified, not assumed from mirror symmetry).

## ⚠️ GOVERNANCE FLAG — same as design_scope_of_work_rule.md

The original prompt states these 3 parts are "exactly as confirmed this
session... Copy verbatim from chat log" — a Claude Web chat log cc has no
access to. The `bbq-offset-smoker-v1-init-ADDENDUM-cc-prompt.md` follow-up
confirmed the correct handling for each part:

- **Part A (datum chain)** — fully specified directly in the original
  prompt's own TASK 2 (GLOBAL PARAMS + DATUMS + module descriptions are
  literal, not log-referenced), GROUNDED IN THE REAL BUILT FILE
  (BBQ-chambers-v1.scad, real CGAL-verified — see cc_chat_log.md). The
  addendum's own Section 3b restates Part A using the original prompt's
  pre-correction "Y=chamber_L" notation — this file uses the CORRECTED
  axis (X=chamber_L) throughout, matching the actually-built file and
  rules-dimensions.md's locked all-models coordinate standard (see
  BBQ-chambers-v1.scad's header for the full correction rationale).
- **Parts B/C (BOM tree, Kinetic table)** — the addendum confirms these
  were never a verbatim Janis-confirmed source to begin with, and
  instructs deriving them mechanically from the module list already
  locked in Task 2/3 — exactly what this file already did. Confirmed
  correct, not rewritten. Per the addendum's own instruction: stated
  explicitly here that Parts B/C are CC-DERIVED from the geometry spec,
  not copied from a prior Janis confirmation — still requires Janis's
  review, not silently presented as pre-confirmed.

---

## PART A — Skeleton Definition Worksheet

```
MASTER ORIGIN: (0, 0, 0) at floor level, front-left corner of the product
  footprint (chimney/tow-handle end = front, firebox end = rear) — matches
  rules-dimensions.md's global "front-left at floor" convention.

PRIMARY DATUM:   chamber_floor_z (horizontal plane, Z=600mm, unchanged
                 numeric value — MASTER CONTROL VALUE / independent input)
                 — locks Z. v8: FLIPPED from DATUM_GRATE_Z (was
                 "grate-down": chamber_floor_z derived FROM the grate).
                 GRATE_Z is now DERIVED (= chamber_floor_z + chamfer =
                 778.665mm, v8 — was hardcoded 750mm) — a real geometric
                 constraint (the grate sits exactly at the top of the
                 lower chamfer, the lid parting line), not an
                 independently-set ergonomic pick. `grate_clearance`
                 RETIRED (its only consumer was the old, now-reversed,
                 chamber_floor_z formula). firebox_floor_z's own direction
                 off chamber_floor_z is UNCHANGED either way.
SECONDARY DATUM: DATUM_X_REAR (chamber's rear/firebox wall, X=915mm) —
                 locks X. Firebox is Parent: DATUM_X_REAR, not an
                 independently-set X position.
TERTIARY DATUM:  DATUM_Y_CENTER (chamber's lateral centerline, Y=305mm) —
                 locks Y. Firebox and chimney are both Parent:
                 DATUM_Y_CENTER (centered on the chamber's own width).

MAJOR SUB-ASSEMBLIES:
  Grill Grate      — Parent: DATUM_GRATE_Z (now itself Parent: chamber_floor_z) — offset: (0,0,0), fixed
  Cook Chamber      — Parent: chamber_floor_z              — offset: (0,0,0), fixed (v8 — chamber_floor_z is now the direct anchor, was dZ=-100 off DATUM_GRATE_Z)
  Lid               — Parent: Cook Chamber's ridge midpoint — offset: length-wise hinge at (-, DATUM_Y_CENTER, DATUM_Z_RIDGE); opens toward Y=0 (v3 mirror, was Y=chamber_W in v2) per the Standing Orientation Convention (rules-bbq-fab.md); margin widened v6 (LID_X0=100/LID_X1=815, was 10/905)
  Firebox           — Parent: Cook Chamber's rear wall (DATUM_X_REAR)   — offset: own floor via firebox_drop; near-wall closure panel added v3 (firebox_floor_z..chamber_floor_z step)
  Exhaust room      — Parent: Cook Chamber's front end-cap (DATUM_X_FRONT) — offset: welded flush at X=0; RESIZED v3 (360mm dia x 100mm height, was 200/200 v2)
  Chimney pipe      — Parent: Exhaust room's own top plate — offset: coaxial with the room's pipe-mounting hole; RE-POSITIONED v3 (real clearance now, not a forced overhang)
  Understructure     — Parent: Cook Chamber's chamber_floor_z / firebox_* / DATUM_Y_CENTER / GRATE_Z, PLUS a NEW v3 ground reference (GROUND_OFFSET=150, true ground = local Z=-GROUND_OFFSET, chamber/firebox never move): rear_axle() Parent: firebox_floor_z/firebox_x0/y0/y1 + GROUND_OFFSET (offset: down to REAR_AXLE_Z=WHEEL_R-GROUND_OFFSET=50, real spacer brackets absorb the gap); front_wheel_support(steer_deg,handle_fold_deg) Parent: chamber_floor_z/chamfer/chamber_W/DATUM_Y_CENTER + GROUND_OFFSET (offset: down to chamber_floor_z-LEG_DROP, then a real front spacer down to the shared FRONT_AXLE_Z) — v3: tow_triangle()/tow_handle() are now children of front_wheel_support()'s own front_swivel_assembly(), Parent: front_spacer() (RIGIDLY WELDED, replaces v2's wrong "independent" design), NOT DATUM_Y_CENTER alone; prep_shelves() Parent: octagon "apex A" (world Y=0/610, Z=GRATE_Z=778.665 — v3, was chamber_floor_z/arbitrary-floating-point in v2/v1, real chamber-material contact now via tray_mount_bracket())
```

## PART B — BOM Subassembly Tree

```
BBQ Offset Smoker V9 (top assembly)
├── Cook Chamber
│   ├── Chamber shell (fixed side only: floor+RIGHT wall+right chamfer+
│   │   half ridge, wall_t hollow — v7 REBUILT from a real 8-point
│   │   `true_octagon_profile()` [real edges only] clipped to the fixed
│   │   side via a `fixed_side_wedge()` cutting-plane mask applied AFTER
│   │   hollowing, not before; this is the first version where "TRUE
│   │   octagon closure" is actually true — v3-v6 used
│   │   `fixed_shell_profile()`'s own fake diagonal closing edge instead,
│   │   which is what caused the "reads solid, flat panel across the
│   │   opening" defect. v3 MIRRORED, was left-side in v2. v8: octagon is
│   │   now genuinely REGULAR — chamfer corrected 150->178.665mm, real
│   │   `chamber_W/(2+sqrt(2))` formula, all 8 sides confirmed 252.670mm)
│   │   ├── Lid-territory margin fill (v8 — REPLACES `lid_territory_end_caps()`,
│   │   │   PR #121/v6, folded into a new construction: same shared
│   │   │   `true_octagon_profile()`+`octagon_ring()` helper the fixed-side
│   │   │   tube itself uses [was a DIFFERENT profile, `lid_profile()`, in
│   │   │   v6/v7 — two independently-modeled shapes meeting at a seam,
│   │   │   which is what Janis was seeing as a visible wall at the
│   │   │   X=LID_X0/LID_X1 boundary]. Real wall_t end cap ONLY at the true
│   │   │   outer end (X=0 or X=915), fully OPEN at LID_X0/LID_X1 — no
│   │   │   separate closing face. Real CGAL boundary probe confirms
│   │   │   continuous wall_t-only material through the boundary (~5096mm²
│   │   │   cross-section, not the ~308258mm² a solid closing panel would
│   │   │   show). Same X-range as before: X=0-100 and X=815-915)
│   │   └── Firebox passage (REPLACES the old fixed 254x119mm
│   │       window_hole(); profile-intersection opening, offset v6: -15mm
│   │       around the cut, was -10mm — retains partition strength per
│   │       Janis's explicit request. v8: area changed 92741.2mm² ->
│   │       88209.5mm² [~4.9% smaller] as a real side effect of the
│   │       corrected chamfer — code itself unchanged, flagged not
│   │       silently absorbed. v9: rebuilt to intersect against
│   │       `fixed_side_solid_2d()` [real edges only, `fixed_shell_profile()`
│   │       DELETED] instead of the fake-diagonal profile — independently
│   │       verified this is a code-quality cleanup ONLY (real XOR test:
│   │       identical shapes, area unchanged at 88209.549116mm²), NOT a
│   │       fix for the "triangle leak" Janis has reported 3 times — that
│   │       symptom remains UNEXPLAINED, KT-exhausted, needs Janis's
│   │       direct input. See BBQ-chambers-v9.scad header for the full
│   │       verification record)
│   ├── Lid (ridge-hinged, 3 flat panels: half-ridge+chamfer+wall — v3
│   │   MIRRORED to Y=0 side, was Y=chamber_W side in v2; v6: margin
│   │   widened to 100mm each end, LID_LENGTH=715, was 895)
│   │   ├── Lift handle rail (2 standoff posts) — still DISABLED, stale positions
│   │   ├── Toggle-clamp latches x2 (BUY, off-shelf placeholder) — still DISABLED
│   │   ├── Dome thermometer (BUY, off-shelf placeholder) — still DISABLED
│   │   └── Counterbalance lever + weight — still DISABLED
│   ├── Grill grate (3 removable segments — v6: GRATE_Z REPOSITIONED
│   │   700->750, aligned to the lid parting line per Janis's explicit
│   │   spec; Y-range formula (v5 fix) re-evaluated at the new height,
│   │   re-verified collision-free against shell and closed lid. v8:
│   │   GRATE_Z now FORMULA-DERIVED (`chamber_floor_z + chamfer`, real
│   │   value 778.665mm, was hardcoded 750) — moves automatically with the
│   │   corrected chamfer, "lifts up naturally" per Janis; Y-range formula
│   │   itself unchanged, DO NOT TOUCH, updates automatically too)
│   └── Floor drain valves x2 (BUY, off-shelf placeholder)
├── Firebox
│   ├── Firebox shell (4-wall hollow box, open both ends)
│   ├── Firebox near-wall closure (v3 — closes the firebox_drop step gap,
│   │   strictly BELOW chamber_floor_z only)
│   ├── Firebox upper wall seal (v11 NEW — THE REAL "triangle leak" FIX.
│   │   Closes the region AT/ABOVE chamber_floor_z where the firebox's
│   │   square footprint sticks out past the narrowing octagon —
│   │   `firebox_square_2d()` minus `fixed_side_solid_2d()`, clipped to
│   │   h>=0. Two mirror-symmetric panels, 5218.8436mm² each. Real CGAL
│   │   probe + full kinetic sweep + full assembly chain all confirmed
│   │   Simple:yes; see BBQ-chambers-v11.scad header for the full
│   │   verification record)
│   ├── Fire grate (welded bars)
│   ├── Ash tray (slide-out)
│   └── Firebox door (hinged, joggle-step joint)
│       └── Air-intake damper cutout
├── Exhaust Room (half-cylinder, welded to front end-cap) — RESIZED v3 (360x100mm, was 200x200mm v2)
│   └── Chimney Pipe (coaxial, sits on the room's own top plate) — RE-POSITIONED v3
└── Understructure (v3 — 4 real fixes from Janis's actual v2 screenshot
    │   review: wheel size+count, GROUND_OFFSET height lift + spacer
    │   brackets, tray reattachment, coupled-steering T-bar handle)
    ├── Rear axle (fixed, non-swivel. WHEEL_D/WHEEL_R 400/200 [v3, was
    │   609.6/304.8]. 2 struts [UNCHANGED v2, DO NOT TOUCH] from the
    │   firebox underside down to REAR_AXLE_Z=50 [v3, was 304.8 —
    │   WHEEL_R-GROUND_OFFSET], REAR_BRACKET_H=350mm [v3, was 95.2].
    │   REAR_AXLE_X=1143.5/REAR_TRACK_WIDTH=857mm ZERO diff from v2, DO NOT
    │   TOUCH. No kinetic parameter — static)
    │   └── Rear spacers x2 (TASK 2, NEW — 278.5mm each, symmetric,
    │       pushing each wheel axle outward from the strut mount clear of
    │       the firebox to the real wheel Y. Real CGAL junction+hub-
    │       containment checks confirmed)
    ├── Front wheel support (bracket UNCHANGED v2, DO NOT TOUCH:
    │   MID_H=89.332mm/TOP_W=431.335mm/BOT_W=252.670mm/LEG_GAP=250mm/
    │   FRONT_X=300, real-CGAL-reconfirmed flush against
    │   true_octagon_profile() at h=MID_H, zero diff. Fixed caster top-
    │   plate unchanged position)
    │   ├── Front spacer (TASK 2, NEW — 394mm, bridges the fixed top-plate
    │   │   down to the new shared FRONT_AXLE_Z=50. Real CGAL junction
    │   │   checks confirmed both ends)
    │   ├── Dual swivel wheels (TASK 1 — was ONE wheel v2, now TWO, same
    │   │   single pivot, new stub axle, 120mm center-to-center [100mm tire
    │   │   + 20mm gap], WHEEL_D/WHEEL_R shared with rear axle — 400/200)
    │   └── Tow handle + puller triangle bracket (TASK 4, REBUILT — v2's
    │       "entirely independent" design was WRONG, corrected via Janis's
    │       own reference photo this session: the triangle [apex forward,
    │       same orientation logic as v2] is now RIGIDLY WELDED to the
    │       front spacer/axle yoke — real CGAL weld-contact confirmed, not
    │       a floating near-touch. Handle is now a real T-shaped crossbar
    │       [HANDLE_UPRIGHT_LEN=400/HANDLE_CROSSBAR_LEN=300], REPLACES v2's
    │       plain round bar. GOVERNANCE FLAG carried from v2: TRIANGLE_*/
    │       HINGE_X numbers remain a flagged cc judgment call, no Janis-
    │       confirmed prior-session record)
    │       ├── Kinetic: handle_fold_deg (renamed from v2's
    │       │   handle_tilt_deg — 0=towing/use .. 90=folded vertical
    │       │   storage, same door/lid-angle convention. Real CGAL vs
    │       │   exhaust_room() at full fold: 87.5mm X / 292.5mm Z real
    │       │   clearance — re-derived at the new height+geometry, v2's
    │       │   old 137.5/155mm numbers NOT reused)
    │       └── Kinetic: steer_deg — NOW COUPLED (TASK 4 fix): rotates the
    │           triangle+handle AND the front wheel pair together, one
    │           linked motion (was independent of the wheels in v2). Real
    │           CGAL sweep (0/+-22.5/+-45/90) vs front bracket + prep
    │           trays confirmed empty at every tested angle
    └── Prep shelves x2 (fold-up, left + right, SAME size/kinetic behavior
        as v1/v2, DO NOT TOUCH) — TASK 3, RE-HINGED: was an arbitrary
        floating mount point [confirmed NO real chamber contact]; now real
        octagon "apex A" [world Y=0/610, Z=GRATE_Z=778.665mm, the lid's own
        parting-line reference point] via new tray_mount_bracket(), real
        CGAL contact check confirms genuine shared material. Re-verified
        empty vs the new Front wheel support bracket+spacer at the new
        mount position/stack height
```

## PART C — Kinetic Dual-View Table

Per the Kinetic Dual-View Convention (SKILL_product_design_skeleton.md),
every part below got both end states established as real toggles/
parameters from its first committed version, and both states were
verified via real CGAL render this session (not just the default state
— see cc_chat_log.md for the actual sweep record):

| KINETIC PART | STATE A | STATE B | Notes |
|---|---|---|---|
| Lid | closed (`lid_open_deg=0`) | open (`lid_open_deg` up to 120, real CGAL-confirmed ceiling, re-verified after the v3 mirror — stays clean well past that too, 120 chosen as a practical usable-design max, not a hard collision limit) | v3: ridge-hinged, full-length, rotate([-deg,0,0]) about an X-axis line — SIGN FLIPPED from v2's rotate([+deg,0,0]) since the lid is now mirrored to the opposite (Y=0) side; verified via real CGAL bounding-box check, not assumed from symmetry |
| Firebox door | closed (`firebox_door_open_deg=0`) | open (up to ~110) | Continuous angle, unchanged from v1 (DO NOT TOUCH this session) |
| Ash tray | in (`ash_tray_out_pct=0`) | out (`ash_tray_out_pct=1`) | Full-out only physically valid with door open — same accepted door-dependency pattern as VM-02's `tray_out_pct`, not a bug. Unchanged from v1 |
| Chimney (fold) | REMOVED v2 | REMOVED v2 | v1's foldable chimney/drop-tube replaced by a fixed exhaust room + pipe (v2 TASK 2) — no fold mechanism in this version, flagged as a real scope change, not silently dropped |
| Prep shelves | deployed (`shelf_deployed=true`, horizontal) | stowed (`shelf_deployed=false`, vertical) | Discrete boolean, unchanged from v1 |
| Tow handle (TASK 4, v3 REBUILT) | towing/use (`handle_fold_deg=0`, horizontal) | folded vertical storage (`handle_fold_deg=90`) | Continuous angle, renamed from v2's `handle_tilt_deg`. Real CGAL-confirmed clear of `exhaust_room()` at full fold (87.5mm real X clearance, 292.5mm real Z clearance — re-derived at the new height+coupled geometry, v2's old 137.5/155mm numbers NOT reused). `steer_deg` is now COUPLED (TASK 4 fix — was independent of the wheels in v2): rotates the triangle+handle AND the front wheel pair together as one rigid assembly — still a SEPARATE parameter from fold (no fixed "both end states"), not its own dual-view row, but no longer an independent mechanism either |

Static/removable parts (Grill grate segments, floor drain valves, toggle-
clamp latches, Rear axle — fixed/non-swivel, no kinetic parameter, and
Front wheel support's own bracket — fixed weldment, the caster's swivel
IS the `steer_deg` kinetic captured above, not separately modeled) are NOT
independently kinetic beyond what's listed — they get a `show_*`
isolation toggle only (Toggle-Completeness Rule), not a dual-view kinetic
state.

## Toggle-Completeness count (2026-07-17, v1.11)

BBQ-chambers-v11.scad ASSEMBLY: 8 modules called (`chamber_shell`, `lid`,
`lid_hardware`, `firebox`, `exhaust_room`, `chimney_pipe`, `grill_grate`,
`floor_drains`) — all 8 have a real `show_*` toggle, carried over
unchanged from v2. 8/8 compliant. `firebox_near_wall_closure()`,
`firebox_upper_wall_seal()` (v11 NEW — same no-separate-toggle sub-part
status, called from `firebox()` alongside `firebox_near_wall_closure()`),
`lid_territory_margin_fill()` (v8 — REPLACES `lid_territory_end_caps()`,
PR #121/v6, same no-separate-toggle sub-part status), and
`firebox_passage()` are all sub-parts called from within
`chamber_shell()`/`firebox()`, same pattern as `fire_grate()`/`ash_tray()`
— no separate toggle needed. `chamber_inner_cavity()` RETIRED entirely as
a standalone module (v8 — its job is now `octagon_ring()`'s own internal
step, reused by both `chamber_outer_tube()` and
`lid_territory_margin_fill()`), never had its own toggle either way (not
ASSEMBLY-called). `fixed_shell_profile()` DELETED (v9 — zero remaining
real callers after `firebox_passage_profile()`'s rebuild), also never
ASSEMBLY-called, no toggle count change. `show_lid_hardware` still
defaults FALSE — see PART_MANIFEST.md.

BBQ-understructure-v3.scad ASSEMBLY: 3 modules called (`rear_axle`,
`front_wheel_support`, `prep_shelves`) — was 4 in v2 (`show_tow_handle_assembly`
correctly RETIRED, not a gap: the triangle/handle are no longer an
independent mechanism, TASK 4 rigidly welds them into
`front_wheel_support()`'s own swivel assembly, so they're now a sub-part
of that ONE toggle, same as any other sub-part). 3/3 compliant. Sub-parts
(`rear_axle_bracket()`/`rear_spacers()`/`rear_wheels()`,
`front_bracket()`/`front_caster_plate()`/`front_swivel_assembly()`/
`front_spacer()`/`front_stub_axle()`/`front_wheels()`/`tow_triangle()`/
`tow_handle()`, `tray_mount_bracket()`) are called from within their own
single ASSEMBLY-toggled wrapper — same no-separate-toggle sub-part pattern
`chamber_shell()`'s own sub-parts already use, not a new exception.

No safety-critical no-toggle exceptions needed this version (nothing in
this product blocks hand access the way VM-01/VM-02's drop-zone guards
do).
