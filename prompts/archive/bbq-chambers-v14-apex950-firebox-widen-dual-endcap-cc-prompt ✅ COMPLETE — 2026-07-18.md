CC PROMPT — bbq-chambers-v14-apex950-firebox-widen-dual-endcap
================================================================
Repo location: bbq-offset-smoker/BBQ-chambers-v14.scad (new, source v13)

REVISION NOTE: chamber+firebox only this round, same scope discipline
as v13. Understructure (BBQ-understructure-v4.scad) is COMPLETELY OUT
OF SCOPE — do not open, do not touch, do not bump its include pointer
in this prompt (that bump happens in a LATER, separate understructure
round once this chamber/firebox work is confirmed stable — Janis's
explicit direction).

This round resolves the two real, unresolved findings flagged right
after v13 shipped: (1) the actual fire-holding volume (the internal
duct) was only ~58% of the theoretical 1/3-chamber-volume target, and
(2) the rear passage cut was ~4.6x oversized against the theoretical
opening-area rule. Both are fixed by the same real design change:
decoupling the passage's shape/size from the duct's own shape/size,
widening the firebox, and restructuring the firebox as TWO
INDEPENDENT welded assemblies (inner hot box + outer insulating
shell) instead of one shared end-cap plate — eliminating a real
full-face thermal-bridge problem Janis identified in the prior
concept before it was ever built.

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in
your active context from earlier in THIS session, with no git
pull/merge to main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation
  — governance already current" and go straight to TASKS.
→ NO: FRESH. `git fetch --all && git checkout main && git pull origin
  main`. Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3
  entries). State every file read before writing a line.

Claude Web override: none

**MANDATORY FIRST CHECK — confirm v13 is actually what's in main.**
Before touching anything, state the real, live values currently in
BBQ-chambers-v13.scad: `chamber_floor_z` (expect 721.335), real apex A
(expect exactly 900mm), `GRATE_Z_FIXED` (expect 1000), firebox
Y-range (expect firebox_y0/y1 centered on DATUM_Y_CENTER at 510mm
width). If ANY of these differ from what's expected, STOP and flag —
do not silently build v14 on top of an unexpected v13 state.

Task-specific reads (read regardless of continuation/fresh):
1. bbq-offset-smoker/BBQ-chambers-v13.scad — LIVE, in full. State real
   current `chamber_floor_z`, `chamfer`, `DATUM_Y_CENTER`, `chamber_W`,
   `true_octagon_profile()`'s full real boundary (need this for TASK 2's
   tuck-under check AND TASK 3's passage check), `DATUM_X_REAR`, the
   firebox's real current Y-range/width, and `grill_grate()`'s current
   `GRATE_Z_FIXED` value and its real gap to apex A.
2. BBQ-chambers-v13.scad's firebox section — state real
   `FIREBOX_L/W/H`, `firebox_floor_z`/top, `fuel_cylinder()`'s real
   diameter/wall/length, `firebox_end_cap()`'s real current
   construction (this module is being RETIRED and replaced by two
   separate modules this round — read its current logic first so the
   replacement can be judged against it).
3. .claude/SKILL_joint_construction.md
4. .claude/rules-codes.md
5. bbq-offset-smoker/design_scope_of_work_rule.md — Envelope section
   (firebox dimensions AND the theoretical sizing-ratio numbers both
   change this round)

**Historical precedent, read before TASK 2/3** — this project has hit
this exact class of mistake before (v6, v8/v10, and v13 itself all
required a REAL boolean/geometric check rather than an assumed
boundary). TASK 2's tuck-under and TASK 3's passage placement both
require real checks against the live `true_octagon_profile()` at the
NEW (950mm-apex) chamber position — do not assume the old v13
clearances still hold just because the shapes look similar.

## 2. CONTEXT

Real numbers driving this round (confirmed this session, Janis +
Claude Web, using the real octagon chamber volume ~17,211in³ and the
standing 1/3-rule target ~5,737in³):

| Item | v13 (current) | v14 (this round) |
|---|---|---|
| Apex A (world Z) | 900mm | **950mm** |
| Grate `GRATE_Z_FIXED` | 1000mm (unchanged) | 1000mm (unchanged) |
| Grate-to-apex-A gap | 100mm | **50mm** (real, automatic consequence of the apex move — not a separate task) |
| Firebox width (Y) | 510mm | **580mm** (15mm margin each side vs. chamber's own 610mm width) |
| Firebox length (X) | 460mm | 460mm — **UNCHANGED, do not lengthen** |
| Fire-holding shape | Round duct, shared end-cap with outer shell | **Rectangular duct, fully independent from outer shell** |
| Fire volume vs. 5,737in³ target | ~58% | **~103%** (real, from width increase alone — confirmed math, do not re-derive differently) |
| Rear passage | Full-bore round-top/octagon-bottom `intersection()`, tied to duct's own face | **Simple round hole in the chamber's own end cap only, independently sized — default 197mm diameter** |

**Why two independent assemblies, stated explicitly for the geometry
logic below:** the inner duct (hot) is now built and sealed FIRST,
welded directly to the chamber's own octagon end cap — it does not
rely on, touch, or share any part with the outer shell. The outer
shell (insulating jacket) is built SECOND, around the outside, and
tucks partially under the chamber's own rear wall for structural
support — it also does not touch the inner duct anywhere. This
eliminates what would otherwise be a full-face thermal bridge between
the two if they shared one end-cap plate (the concept this replaces).

**Passage sizing — explicitly NOT locked to a strict formula this
round.** Default working value is a 197mm diameter circle (≈ the
0.008-rule target using the new ~103%-of-target fire volume), but
Janis may adjust this shape/size in the field with the fabricator
(oval, square, trapezoidal, oversized-with-a-flap) independent of this
file. Build the 197mm circle as the real CAD value, but flag clearly
in-code that this specific number is a placeholder subject to
non-CAD field adjustment, not a locked spec like the other numbers in
this table.

## 3. NEW FILES

None. New `BBQ-chambers-v14.scad` (source v13).

## 4. TASKS — IN THIS ORDER, EACH DEPENDS ON THE PRIOR TASK'S REAL OUTPUT

### TASK 1 — Chamber body reanchor (apex A: 900mm → 950mm)

Change `chamber_floor_z`'s formula from `900 - chamfer` to
`950 - chamfer` (expect ~771.335mm, derive and state live, don't copy
blindly). Every dependent element (ridge, exhaust room, lid, chimney,
`DATUM_Z_RIDGE`) recomputes automatically via the existing dependency
chain — confirm explicitly, state real new Z values for each.

Real verification: confirm apex A is now exactly 950mm. Confirm
`grill_grate()`'s real gap to apex A is now exactly 50mm (was 100mm) —
this is an automatic consequence of `GRATE_Z_FIXED` staying at 1000
while apex A moves; state it as a confirmed real number, not assumed.
Confirm no new collision between the reanchored chamber and the
frozen firebox (world Z=[571.4,1000]) or the frozen understructure.

### TASK 2 — Firebox widen to 580mm + dual independent end-cap restructure

This is the core task. Build in this real construction sequence,
matching Janis's own fabrication logic — state real confirmation at
each step, do not collapse into a single boolean pass:

1. **Inner duct** (replaces `fuel_cylinder()` entirely — RETIRE that
   module): rectangular, cross-section = (580 − 2×20)mm ×
   (FIREBOX_H − 2×20)mm = **540mm × 388.6mm**, full FIREBOX_L(460mm)
   span, same door-side/far-end convention as the retired cylinder
   (flush to door-side face minus epsilon, far end still open — UNCHANGED
   open-item status, not resolved this round).
2. **Inner duct's own end cap** (new, small module — the duct's own
   sealing plate at its chamber-facing end, distinct from the chamber's
   own rear wall): weld this duct assembly DIRECTLY to the chamber's
   own octagon end cap — real CGAL seal-weld check (U-shaped top
   contact + side fusion, non-floating, confirmed contact area stated).
   This assembly should look structurally similar to how the CURRENT
   (v13) firebox looks internally — state this comparison explicitly
   to confirm the mental model matches.
3. **Outer firebox shell**: widen to 580mm width (Y-range centered on
   `DATUM_Y_CENTER`, expect [15, 595] real — 15mm margin each side vs.
   chamber's own 610mm width, confirm live).

   **Length — ADDITIVE, not a trim, real distinction required:** the
   20mm tuck-under is a structural flange ADDED to the shell's near
   end, not a cut into the existing interior length. The inner duct's
   own interior cavity length stays exactly `FIREBOX_L`(460mm),
   UNCHANGED — that number is what the fire-volume math in CONTEXT
   depends on and must not shrink. The OUTER SHELL's own total
   physical length becomes **460 + 20 = 480mm** — the extra 20mm is a
   solid structural overlap zone only (bears real load against the
   chamber's rear wall), contains no interior duct volume, and must
   NOT be confused with or subtracted from `FIREBOX_L`. State both
   numbers explicitly and separately in your response — interior
   length (460, unchanged) vs. outer shell physical length (480,
   real, new) — do not report a single merged number.

   Trim the shell's own TOP zone at this new near-end flange so its
   upper edge can tuck UNDER the chamber's rear wall at the 580mm
   width — **real `intersection()` check required**: confirm this
   tuck-under zone actually falls within the octagon's real material
   at the NEW (950mm-apex) chamber position; do not assume the
   v13-era clearance still applies. State the real overlap/contact
   area.
4. **Outer shell's own end cap** (new module, replaces `firebox_end_cap()`
   — RETIRE that module): one continuous plate, upper zone follows the
   real octagon boundary (matching the tuck-under geometry from step 3),
   lower zone is a plain rectangle matching the outer shell's own
   width/height. This plate is **structural** (bears real load from the
   chamber's rear edge, per Janis's explicit design intent — state this
   in the code comment, not just as an incidental contact) — but must
   NOT touch the inner duct or the inner duct's own end cap anywhere.
5. **Mandatory real CGAL check**: confirm ZERO contact between (outer
   shell + its end cap) and (inner duct + its own end cap) at every
   point — state this as an explicit non-overlap probe, not inferred
   from the construction sequence alone.

Real verification: confirm real fire-volume (540×388.6×460mm) ≈
5,890in³ ≈ 103% of the 5,737in³ target — state the real computed
number, don't copy this estimate blindly.

### TASK 3 — Rear passage: simple round hole, chamber end cap only

Replace the retired `firebox_passage()`/`firebox_passage_profile()`
`intersection()`-against-octagon logic entirely. New passage is a
**plain circular hole, 197mm diameter**, cut ONLY through the
chamber's own rear octagon end cap — NOT through the inner duct's own
end cap (that's already a separate sealed plate per TASK 2, no hole
needed there since the duct welds directly around this same opening),
and NOT shaped to follow the duct's cross-section.

Real verification required (do NOT assume clear): confirm this 197mm
circle, positioned within the available Z-band between the new
`chamber_floor_z`(~771.335mm) and the duct's own real vertical
position, sits entirely within the octagon's real material at that
height — i.e., confirm it does NOT need any octagon-boundary clipping
the way v13's passage did. State this as an explicit real check
(intersection or containment test against `true_octagon_profile()`),
not an assumption from the numbers looking like they should fit. If
the real check finds it does NOT fully clear, flag this explicitly
rather than silently clipping it — this default size is adjustable,
see CONTEXT above.

Add an explicit in-code comment (not just file header) that this
197mm value is a placeholder default, not a strictly locked spec —
final passage shape/size may be field-adjusted independent of this
CAD file.

## 5. DO NOT TOUCH

- `BBQ-understructure-v4.scad` — entirely out of scope this round, do
  not open, do not bump its include pointer
- `GRATE_Z_FIXED`(1000mm) — unchanged; its gap to apex A shrinking to
  50mm is a real automatic consequence of TASK 1, not a separate edit
- `grill_grate()`'s X/Y placement formulas — unchanged
- **Interior/functional firebox length** (the inner duct's own cavity
  length, which the fire-volume math in CONTEXT depends on) —
  `FIREBOX_L` stays **460mm, UNCHANGED**. Confirmed unnecessary to
  increase per the real volume math above. This is NOT the same
  number as the outer shell's total physical length — see TASK 2 step
  3 for the required distinction
- Wheel size, world-Z=0 anchor, `REAR_BRACKET_H`, front axle span,
  spacer brackets, T-bar/tow-handle geometry — all still deferred from
  prior rounds, not this prompt
- The intentional future reinforcement-frame/shorter-door work — still
  not built this round; note its trigger gap is now 50mm, not 100mm
- rules-dimensions.md, cc_rules.md — read only

## 6. QA VERIFICATION

- [ ] Real new `chamber_floor_z` stated (expect ~771.335mm, live-derived)
- [ ] Real apex A confirmed exactly 950mm
- [ ] Real grate-to-apex-A gap confirmed exactly 50mm
- [ ] Every chamber-body element dependent on `chamber_floor_z` listed
      with real new Z value; no new collision vs. frozen firebox/
      understructure
- [ ] Inner duct real cross-section stated (540×388.6mm), real 20mm
      gap confirmed on all sides vs. outer shell
- [ ] Inner duct + its own end cap: real CGAL seal-weld confirmed vs.
      chamber's own octagon end cap (non-floating, contact area stated)
- [ ] Outer shell widened to 580mm, real Y-range stated (expect
      [15,595]), 15mm margin each side vs. chamber width confirmed
- [ ] **Interior duct length confirmed still 460mm (unchanged) AND
      outer shell physical length confirmed 480mm (460+20mm flange) —
      both numbers stated separately, not merged or confused**
- [ ] Outer shell tuck-under: real `intersection()` check vs. live
      octagon boundary at the NEW chamber position — confirmed
      clearing, real overlap/contact area stated
- [ ] Outer shell's own end cap: real construction confirmed (octagon
      upper zone / rectangle lower zone, ONE continuous plate)
- [ ] **Mandatory: real CGAL check confirms ZERO contact anywhere
      between the outer-shell assembly and the inner-duct assembly**
- [ ] Real fire volume stated (expect ≈5,890in³, ≈103% of 5,737in³
      target) — real computed number, not the estimate copied blindly
- [ ] `fuel_cylinder()` and `firebox_end_cap()` confirmed fully
      retired, zero remaining callers (grep-confirmed)
- [ ] New 197mm circular passage: real containment/clearance check
      vs. live octagon boundary at the new chamber position — stated
      explicitly, clipping-needed-or-not confirmed either way
- [ ] In-code comment present flagging the 197mm passage as an
      adjustable placeholder, not a locked spec
- [ ] Full CGAL manifold sweep, `Simple: yes` on every solid
- [ ] Full kinetic sweep (lid, door, tray, shelf, existing
      understructure kinetics) — `Simple: yes` throughout
- [ ] 4-angle screenshots (iso/front/side/rear) PLUS one real
      look-through-the-open-door shot PLUS one dimensioned side-view
      showing apex-A(950), GRATE_Z_FIXED(1000), firebox top/bottom Z,
      chamber_floor_z, and the passage circle's real position, all
      labeled with real numbers
- [ ] Error-Log clean

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: state
   real new `chamber_floor_z`, confirmed apex-A=950mm, real fire volume
   + % of target, real passage clearance finding, zero-contact
   confirmation between outer shell and inner duct.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-18
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md —
   retire `fuel_cylinder()`/`firebox_end_cap()` entries, add the new
   inner-duct-end-cap and outer-shell-end-cap modules, note the
   197mm-passage-is-a-placeholder flag in each
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md`'s Envelope
   section: apex A now 950mm, firebox width 580mm, real fire volume
   and % of theoretical target, passage now independently sized
   (197mm default, field-adjustable), grate gap now 50mm, bump version
5. Save as BBQ-chambers-v14.scad (v13 kept); update
   BBQ-offset-smoker-base-v1.scad's include v13→v14 (confirm the real
   include chain location first, same flag v13 raised about this file)
6. Commit all → merge to main
