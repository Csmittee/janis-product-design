# BBQ Offset Smoker — Design Scope of Work
> Version 1.15 — 2026-07-21
> Changes: Janis toggled the outer shell's own end-cap visibility off and
> still saw a wall — real cause: the outer shell's own tuck-under flange
> was built as a SOLID block since v14, never questioned, creating two
> redundant wall-like surfaces instead of one real cap closing a hollow
> tube. Also a real, standing inconsistency with this product's own thin-
> sheet-metal construction method. Fixed: flange rebuilt hollow (wall_t
> thick, same construction as the rest of the shell). Include bumped
> v19->BBQ-chambers-v20.scad / v10->BBQ-understructure-v11.scad (pure
> pointer bump).
> Previous: 1.14 — 2026-07-21
> Changes: Janis's own closer visual inspection of v18, looking INSIDE the
> built cylinder, found a real remaining hole in the inner cylinder's own
> end cap — same failure class as the outer shell's own Rule 1 defect,
> just never checked on this specific end cap. Fixed by directly reusing
> the Dual End-Cap Footprint Pattern (RULE 4) written earlier the same
> session — no re-derivation needed. Also: `ash_tray()` retired entirely
> per Janis's own explicit, direct instruction ("just remove this tray,
> keep cylinder clean") — flagged as asked several versions ago and never
> done. Include bumped v18->BBQ-chambers-v19.scad / v9->
> BBQ-understructure-v10.scad (pure pointer bump).
> Previous: 1.13 — 2026-07-21
> Changes: Janis's own 4-step QA simulation, run against unmerged PR #138
> (v17) before merging, alongside the new rules-bbq-fab.md "Dual End-Cap
> Independence Convention" locked the same session. Found v17's own
> flange/end-cap footprint (always-plain-square) dodged the 2 known real
> bugs (wall-blocks-interior, missing-material gap) without ever
> satisfying the new Rule 1 ("the top part follows the chamber's own real
> profile", "meets the octagon face"). Include bumped v17->
> BBQ-chambers-v18.scad / v8->BBQ-understructure-v9.scad (pure pointer
> bump). Envelope's Firebox entry: rebuilt via `union(plain square, true
> octagon profile)` minus the chamber's own real hollow-bore hole, bounded
> by a real height mask (a real bug caught before shipping via an STL
> bbox probe: a bare union reached the chamber's own ridge height) — real
> CGAL/STL re-verified: EMPTY vs the hollow cavity, NON-EMPTY vs the real
> wall material, `outer_shell()`'s own world-Z range confirmed exactly
> [420,1000].
> Previous: 1.12 — 2026-07-21
> Changes: Janis's own SECOND direct-feedback round the same day, on the
> just-pushed v16/v7 fixes. Include bumped v16->BBQ-chambers-v17.scad /
> v7->BBQ-understructure-v8.scad. Envelope's Firebox entry: the outer
> shell's own flange/end-cap footprint mechanism REBUILT again — the prior
> round's real octagon-clip (v16 TASK C) was found, via CGAL and
> re-rendering before this round shipped (not assumed), to have 2 real
> defects: (1) it solid-filled ~48.5mm of the chamber's own real hollow
> interior bore — a genuine wall blocking the chamber's interior Janis
> never asked for ("i didnt ask for this wall!"), confirmed via a real
> non-empty CGAL probe against the chamber's own hollow-cavity solid; (2)
> it also carved a real hole with NO material from either part wherever
> the firebox's own 580mm square exceeds the octagon's real width (the
> chamber has zero material of its own outside its true octagon boundary)
> — matching Janis's own separate "missing firebox outer shell end cap
> that should stretch to fuse with the chamber shell" finding. FIX (one
> redesign resolves both): the flange's own outer boundary is now ALWAYS
> the full continuous 580mm square (flush with the main body everywhere,
> zero notches, by construction identical to the plain footprint's own
> boundary), with ONLY the chamber's own real hollow-bore shape cut out of
> it so it can never block the chamber's interior. Real CGAL: EMPTY vs the
> chamber's own hollow cavity (2mm real margin, not just an exact touch),
> NON-EMPTY vs the chamber's own real wall material (genuine structural
> contact preserved). FLANGE_LEN stays 50mm, unchanged this round. Also
> new: 4 real firebox sub-part toggles (fire cylinder, its end cap, outer
> shell, its end cap), Janis's own explicit request, so future issues can
> be isolated and reported precisely.
> Envelope's Rear fender entry: re-investigated (Janis's own OpenSCAD-
> desktop screenshot showed a "coiled" look) — CODE UNCHANGED this round;
> a real matching-angle F6 (--render, full CGAL boolean) render reproduces
> the same clean flat+curved band with zero coiling, strong evidence this
> was an F5 Preview (unresolved-overlap) rendering artifact, not a real
> geometry defect — flagged for Janis to re-check specifically via F6
> (Render), not re-guessed at further.
> Understructure's Prep tray entry: real pre-existing bug found+fixed —
> `prep_shelves()`'s own right-side shelf applied `mirror()` AFTER an
> already-applied `translate()`, reflecting the pre-positioned geometry
> back around Y=0 instead of onto the chamber's opposite side — real,
> measured consequence (STL vertex-extent probe): both shelves landed on
> the SAME side, matching Janis's own "bad tray stack in each other".
> FIX: dropped the unnecessary `mirror()`, right shelf now a direct
> `translate([0,chamber_W,0])` — real, confirmed one shelf per side.
> Previous: 1.11 — 2026-07-21
> Changes: Janis's own DIRECT feedback round (not a new CC prompt) on 7 real
> defects across the firebox and understructure, explicitly flagged "told
> chat many time to fix but dont effectively fixed". Include bumped v15->
> BBQ-chambers-v16.scad / v6->BBQ-understructure-v7.scad. Envelope's Firebox
> entry: FLANGE_LEN 20mm->50mm (Janis's explicit spec change, stronger
> structural tuck-under support) — confirmed STAYS ADDITIVE, does not trim
> FIREBOX_L's own 580mm interior depth (FIREBOX_SHELL_L=630mm, was 600mm).
> Fire passage/end-cap/flange shape logic REBUILT (not a datum move):
> passage now sized/positioned from the real available octagon material at
> the chamber's rear wall (a real vertical-band calc against the cylinder's
> own clear-bore overlap), not an independent fire-volume-area formula —
> real root cause of the previous "visible hole"/"rat hole" defect: the old
> circle had 33.233mm of its own bottom sitting below chamber_floor_z with
> zero real material to begin with. fire_cylinder_end_cap()/outer_shell's
> own flange footprint both rebuilt two-zone (octagon-clipped above
> chamber_floor_z, native circle/square below) per Janis's own explicit
> shape spec. Rear fender rebuilt again (Envelope's Rear fender entry): a
> real flat plate (from the firebox wall to directly above the wheel
> center) + curved flare (from there down past the wheel's outboard tangent
> edge) — grounded in the ORIGINAL v5-round prompt's own written spec text,
> replacing v6's full-arc-from-the-wall design which was still the wrong
> shape per Janis's direct feedback. 3 items from the same feedback round
> explicitly OUT OF SCOPE this version (flagged, pending a reference image/
> clarification from Janis): prep tray/shelf location, front wheel axle
> center bracket ("T bar puller") shape.
> Previous: 1.10 — 2026-07-20
> Changes: bbq-understructure-v6-fitment-fixes. TASK 0 bumps this file's
> own `include` to BBQ-chambers-v15.scad, wiring v15's real square-shell/
> cylinder firebox redesign into the full assembly for the first time. 4
> real fitment fixes from Janis's live OpenSCAD-desktop review of v5:
> prep shelf now 3 real distributed mounting brackets (was 1, cantilevered
> ~290mm unsupported far end — kinematics were already correct, real fix
> is physical support). Track width recomputed to 980mm (100mm wheel-to-
> firebox gap, was 1080mm/150mm — firebox is insulated, wheel sits
> closer). Rear fender rebuilt as a real short flared wing (was a long
> straight panel — real cause: the flat mounting portion spanned to the
> wheel's own vertical centerline before curving; fixed by starting the
> arc almost immediately at the real angle where it naturally reaches the
> firebox wall, live-computed via acos()). T-bar bracket now mounts
> directly at the front axle's own real plane with a new curved gusset
> fillet (was floating 100mm above it, a v3-era carryover). Real,
> automatic consequences of v15's own firebox reanchor: REAR_BRACKET_H/
> LEG_DROP/FRONT_SPACER_LEN/REAR_AXLE_X all recompute via their own
> unchanged live formulas (191.4mm/351.335mm/185.4mm/+60mm respectively).
> T-bar length unaffected (1102.735mm) — the v5-flagged 50mm roof-
> overshoot flips to a genuine 50mm real clearance margin as a side
> effect of the gusset fix. Front-wheel/bracket collision re-check at the
> new geometry: still resolved (EMPTY), confirmed not assumed. REAL BUG
> FOUND+FIXED VIA CGAL DURING THE BUILD: the fender's own wider 147deg
> arc sweep broke the inherited 3-point wedge-mask technique (the chord
> between its 2 far points cut INSIDE the ring at this wider angle,
> producing disconnected slivers instead of a band, confirmed via real
> render) — fixed with a real multi-point fan mask, robust to any sweep
> angle, re-verified as a clean continuous band via CGAL.
> Previous: 1.9 — 2026-07-20
> Changes: bbq-chambers-v15-square-shell-cylinder-firebox. Real structural
> firebox redesign, source v14.2 (understructure v5 completely out of
> scope this round — a separate, already-prepared v6 round depends on this
> round's own real output). Envelope's Firebox entry REBUILT: outer shell
> rebuilt as a true 580x580x580 cube (FIREBOX_H 428.6->580mm, "dice"
> proportions per Janis's own explicit direction) — firebox_floor_z now a
> live formula (420mm, was 571.4mm literal, top pinned at 1000mm instead) —
> firebox now extends 351.335mm below chamber_floor_z (was 199.935mm),
> closing ~151mm of the real gap to the axle plane (understructure's own
> concern, next round). REAL, NECESSARY FORMULA CORRECTION found before
> shipping: firebox_x0 repinned directly at its own real weld position
> (913.5mm, unchanged value) instead of a historical-midpoint formula that
> would have pulled it 60mm into the chamber's own real territory as
> FIREBOX_L grew (460->580mm) — all +120mm of growth now happens on the
> door/far end only. Rectangular inner duct RETIRED, replaced by a real
> 456mm-dia fire cylinder (62mm wall clearance, Janis's own explicit
> choice) — real volume 5,780.25in³ = 100.75% of the 5,737in³ target. Rear
> passage rebuilt as a circle (194.898mm dia, target-area-sized) — real
> finding: the cylinder's own true center now sits BELOW chamber_floor_z,
> passage biased to the cylinder's own real top; real CGAL measurement:
> 88.7% of the circle's own area is genuinely cut through real chamber
> material, ~11.3% a real confirmed chord (matches this project's own
> v13/v14 precedent). NEW end plate locates the cylinder within the square
> shell. TWO REAL BUGS FOUND+FIXED VIA CGAL DURING THE BUILD: ash tray
> width (150mm) collided with the cylinder's own solid wall (checked the
> wrong/nearer corner, not the farther bottom face) — fixed to 80mm; the
> new end plate sat exactly coincident with the door's own face
> (Simple:no) — fixed via a real epsilon, re-verified Simple:yes. SEPARATE,
> REAL, PRE-EXISTING FINDING (flagged, not fixed, chambers frozen no
> further touching this round): the firebox door is still real, CGAL-
> confirmed non-manifold above ~90-95deg open — re-confirmed identically
> this round on the new v15 geometry, same defect flagged in the prior
> (understructure v5) round, NOT a v15 regression.
> Previous: 1.8 — 2026-07-20
> Changes: bbq-understructure-v5-trackwidth-fender-tbar. First understructure
> round since v4 (2026-07-17) — TASK 0 finally bumps this file's own
> `include` past v13 to BBQ-chambers-v14.2.scad (three chamber rounds landed
> since v4 without this pointer moving; real +50mm chamber_floor_z shift,
> front bracket leg re-verified flush via CGAL). Envelope's Understructure
> entry REBUILT: real, CGAL-confirmed, THE STANDING v4 ~6mm front-wheel/
> bracket collision (open since 2026-07-17) IS NOW RESOLVED — ONE shared
> TRACK_WIDTH=1080mm (FIREBOX_W+2*150+TREAD_W) now drives both front AND
> rear wheel position (retires the old REAR_TRACK_WIDTH formula and the
> front caster's own close-set DUAL_WHEEL_OFFSET spacing); confirmed via a
> real intersection() probe returning EMPTY, not assumed from the wider
> spacing alone. NEW rear fender (150mm real radial clearance arc, welds to
> the firebox's own outer shell — no numeric spec beyond the 150mm gap,
> panel thickness/width are judgment calls, flagged). Front bracket's
> forward tow-triangle extension rebuilt round (150mm dia boss, was a sharp
> pyramid point). Front U-bracket drop length now a live formula, lands
> exactly at firebox_floor_z. T-bar length now a live formula (1102.735mm,
> was 400mm) and its default angle FIXED 0->90 (vertical storage — was
> shipping flat, a standing v12/v4 QA defect). *** REAL, FLAGGED, NOT
> SILENTLY ABSORBED ***: at the new 90deg default, the T-bar's own numeric
> tip-Z exceeds the roof by 50mm on paper (the length formula assumes a
> wheel-height pivot; this file's real, unchanged hinge sits 100mm higher)
> — a real CGAL check confirms NO actual collision (T-bar sits outside the
> chamber's own footprint at that height), but the margin itself is
> negative, flagged for the record. SEPARATE REAL FINDING, out of this
> round's own scope, found incidentally during this round's mandatory
> kinetic sweep: the firebox door (frozen chambers code, UNCHANGED) is
> real, CGAL-confirmed non-manifold above ~90-95deg open, reproduced
> identically on standalone v14/v14.1/v14.2 with zero understructure
> geometry present — pre-existing, NOT introduced this round, NOT fixed
> (chambers frozen this round), flagged for a future chambers-scoped round.
> Grate-height-above-true-ground target (900-1000mm, locked, still an OPEN
> ITEM) UNCHANGED this round — understructure's own wheel/track work does
> not touch the chamber-side grate height question.
> Previous: 1.7 — 2026-07-20
> Changes: bbq-chambers-v14.2-passage-area-fix-real-cut-check. Two
> targeted fixes on the just-merged v14.1 — apex(950mm)/firebox
> width(580mm)/fire-volume math ALL FROZEN, unchanged. Envelope's Rear
> passage entry: trapezoid RESIZED to the real 0.008-of-fire-volume
> opening-area target (47.124in²=30,402.6mm², was 2.25x oversized at
> 106.2in²) — bottom=95.29mm/top=227.00mm, same taper. Per Janis's own
> direct clarification (overrides this round's own prompt-file "height
> frozen" note, flagged): top edge also rises to 20mm below the inner
> duct's own real top wall (960mm, was 950mm=apex A) for a real weld-
> clearance margin, bottom stays at chamber_floor_z, height grows
> 178.665->188.665mm. REAL BUG FOUND+FIXED: the outer shell's flat tuck-
> under flange (v14.1) never had the passage hole cut through it, sealing
> the passage shut (Janis's own "very large but not cut through"/"thin
> film" report, confirmed via a real CGAL ray-probe) — fixed via new
> `outer_shell_flange_cut_2d()`.
> Previous: 1.6 — 2026-07-20
> Changes: bbq-chambers-v14.1-flat-tuckunder-trapezoid-passage. Targeted
> bug-fix + simplification round on the just-merged v14 (outer shell flat-
> face fix, trapezoid passage replacing v14's circle).
> Previous: 1.5 — 2026-07-18
> Changes: bbq-chambers-v14-apex950-firebox-widen-dual-endcap. CHAMBER+
> FIREBOX round (understructure v4 COMPLETELY untouched, not opened — its
> own include bump to v14 is a later, separate round). Apex A/GRATE_Z now
> EXACTLY 950mm (was 900mm), a real algebraic reanchor. Grate-to-apex-A
> gap now 50mm (was 100mm), automatic consequence, grate itself still
> TEMPORARILY fixed at 1000mm (unchanged, still not permanent
> architecture). Firebox rebuilt as TWO fully independent welded
> assemblies (real fire-holding volume was only ~58% of the theoretical
> target and a shared end-cap created a real full-face thermal bridge —
> both fixed together): inner hot duct (540x388.6mm, real interior length
> 460mm UNCHANGED, welded directly to the chamber) + outer insulating
> shell (widened 510->580mm, structurally tucked under the chamber's rear
> wall via a new 20mm flange, physically 480mm long — a separate number
> from the duct's own 460mm interior). Real fire volume now 5,890.5in³ =
> 102.7% of the 5,737in³ target. Rear passage decoupled from the duct's
> own shape entirely — now a plain, independently-sized 197mm circle,
> explicitly flagged as a field-adjustable placeholder, NOT a locked spec.
> *** REAL FINDING, NOT SILENTLY RESOLVED ***: this 197mm circle, at the
> new 950mm-apex chamber position, does NOT fully clear real chamber
> material — the real cut is a chord-shaped opening, roughly half the true
> circle (confirmed via CGAL). A real, open decision for Janis: move the
> passage, resize it, or accept the chord shape as field-adjusted with the
> fabricator.
> Previous: 1.4 — 2026-07-17
> Changes: bbq-chambers-v13-reanchor-grate-decouple-rear-passage.
> CHAMBER-ONLY round (firebox v12, understructure v4/wheel-anchor both
> frozen, untouched). Envelope rewritten again: chamber body real-
> reanchored so apex A/GRATE_Z lands at EXACTLY 900mm (was 778.665mm, the
> v1.3 flagged real value) — a real, algebraic fix (`chamber_floor_z` is
> now a live formula, `900-chamfer`), not a paper offset. The grill
> grate itself is now DELIBERATELY, TEMPORARILY DECOUPLED from the
> chamber body — fixed at a separate, independent 1000mm, a real 100mm
> unsupported air gap above apex A, intentional (Janis's own call),
> expected to be re-merged once a future reinforcement-frame + shorter-
> door task exists — NOT permanent architecture. New rear-passage
> construction: the chamber's rear wall opening is now a real
> `intersection()` of the internal fuel cylinder's actual circle against
> the chamber's own live octagon boundary (round upper portion, octagon-
> clipped lower portion), sealed by a new dedicated firebox end-cap plate.
> *** v1.3's flagged grate-height-vs-understructure conflict is now
> PARTIALLY STALE ***: it was computed against the OLD chamber_floor_z
> (600mm); the chamber's own real position has since moved. Understructure
> (wheel world-Z=0 anchor) is untouched this round, so a fresh, real
> "grate height above true ground" figure has NOT been recomputed this
> session (the grate itself isn't even in the chamber's own coordinate
> system anymore, TEMPORARILY) — flagged as an open item for the next
> understructure-touching round, not silently resolved.
> Previous: 1.3 — 2026-07-17
> Changes: bbq-chambers-v12-firebox-rebuild-understructure-v4-wheel.
> Envelope section rewritten: firebox rebuilt from a 457mm cube to an
> insulated jacket (460x510x428.6mm, world Z=[571.4,1000] — LOCKED spec)
> around a new internal fuel cylinder (388.6mm dia, replaces the old fire
> grate concept, far-end treatment explicitly deferred per Janis's own "let
> me see how it looks" note). Wheel size FINAL at 457.2mm/18" (was
> 400mm/16"-equivalent). *** REAL, FLAGGED, UNRESOLVED CONFLICT *** — this
> round's own mandatory wheel-anchor fix (world Z=0 must equal the wheel's
> real ground-contact point, confirmed via CGAL the v3 wheel was NOT
> actually anchored there, real offset -150mm found and corrected) drops
> the real grate-height-above-ground from v3's 928.665mm back to
> 778.665mm — BELOW this section's own standing 900-1000mm target
> (locked v1.2, below). NOT silently resolved either direction — needs
> Janis/Claude Web to pick: relax the grate-height target, or authorize
> moving the chamber's own literal position (which v12's chamber-frozen
> DO NOT TOUCH blocked this round). Also flagged (deferred, not fixed):
> the intentional 100mm reinforcement-frame/shorter-door gap between the
> new firebox top (1000mm) and the real apex-A/grate line (778.665mm real,
> NOT the 900mm this round's prompt assumed — real gap is 221.335mm, still
> not closed, still deliberate headroom per Janis) — future task. A real,
> CGAL-confirmed front-wheel-vs-front-bracket collision (~6mm) was also
> found this round, unresolved, blocking fabrication — see
> BBQ-understructure-v4.scad's own header, not a scope-file item but noted
> here for visibility.
> Previous: 1.2 — 2026-07-17
> Changes: bbq-understructure-v3-wheel-height-tray-handle. Envelope
> section's grate-height control value CHANGED: 700mm (MASTER CONTROL
> VALUE) SUPERSEDED — Janis re-verified ergonomic reach height this
> session, new locked target is 900-1000mm from true ground. Real chosen
> value 928.665mm (GRATE_Z + new understructure-level GROUND_OFFSET=150mm
> -- see BBQ-understructure-v3.scad's own header for the full mechanism:
> chamber_floor_z/GRATE_Z themselves are unchanged, BBQ-chambers-v11.scad
> is completely locked -- the lift happens entirely at the understructure
> level, true ground moves relative to the fixed chamber frame). Detail
> correction to an already-FINAL section (per this file's own two-tier
> confidence system below) -- Product Identity/Envelope numbers were
> "copied verbatim from the original prompt" and FINAL as of v1.0/1.1; this
> specific figure is now Janis-superseded, explicitly, not a silent
> downgrade of the section's overall FINAL status.
> Previous: 1.1 — 2026-07-13
> Changes: bbq-offset-smoker-v1-init-ADDENDUM. Compartment Map / Functional
> Features / Appearance / Made-Buy-Hire sections REPLACED — v1.0's content
> was cc's own reconstruction from Task 2/3's technical description (no
> other source was available at the time); this version uses the content
> Claude Web supplied directly in the addendum prompt, reconstructed from
> the confirmed session handoff. Still NOT re-confirmed verbatim by Janis
> in this exact wording — see the flag below, unchanged confidence tier.
> Previous: 1.0 — 2026-07-13

Customer-facing scope only — owner vocabulary, features, envelope,
appearance. Technical/construction detail belongs in rules-bbq-fab.md, not
here (same filter VM-01/PR-01's own scope files use).

---

## ⚠️ GOVERNANCE FLAG — READ BEFORE TREATING THIS FILE AS FINAL

The original prompt (`prompts/bbq-offset-smoker-v1-init-cc-prompt.md`)
instructed the Compartment Map / Functional Features / Appearance-DoNot /
Made-Buy-Hire lists to be pulled "from the two confirmed scope drafts" of
"this session's chat log" — a Claude Web <-> Janis conversation cc has no
access to. cc correctly declined to invent this content (v1.0 of this
file used a DRAFT reconstructed from Task 2/3's technical description
instead, flagged as such).

The `bbq-offset-smoker-v1-init-ADDENDUM-cc-prompt.md` follow-up supplied
real content for these sections directly in the prompt text (Section 3a),
which is what appears below as of v1.1. Per that addendum's own stated
confidence level: this content is "reconstructed by Claude Web from the
confirmed session handoff... has NOT been re-confirmed verbatim by Janis
in this exact wording." Two tiers, same as v1.0:

- **Product Identity / Envelope** — copied verbatim from the original
  prompt itself — FINAL as stated.
- **Compartment Map / Functional Features / Appearance / Made-Buy-Hire**
  — supplied by the addendum, materially correct per Claude Web but NOT
  yet Janis-reconfirmed in this exact wording. Still requires Janis's
  explicit review before being treated as locked — not silently upgraded
  to FINAL just because it's now inline in a committed file.

Also flagged per the addendum's own DO NOT TOUCH instruction: this
addendum states "rules-dimensions.md — VM-specific, not applicable to
BBQ." That file already carries a "BBQ Offset Smoker Base" section, added
in the original v1-init session (merged, PR #115) before this addendum
existed — a real conflict between the addendum's stated scope and the
already-merged state of the repo, not resolved here (out of this
addendum's own DO NOT TOUCH scope) — left for Janis/Claude Web to decide.

---

## Product Identity
Mobile wheeled octagonal-profile offset BBQ smoker, hobbyist-commercial
grade, 2-3mm steel. V1 = pass-through smoke flow.

## Envelope
Cook chamber 915mm L x 610mm flat-to-flat cross-section (UNCHANGED,
chamber's own shape frozen).
Apex A / chamber body reference: EXACTLY 950mm world Z (REAL, BUILT,
2026-07-18 — `chamber_floor_z` is now `950-chamfer`, algebraically exact).
Supersedes the prior 900mm value (2026-07-17 round). Chamber datum itself
UNCHANGED as of 2026-07-22 (v21) — only the fixed/lid MATERIAL split
above it moved, see the lid/fixed parting-line entry below.
Lid/fixed parting line (2026-07-22, v21): real +50mm shift on the Y=0
side only — the lid's own real opening material now starts at world
Z=1000mm (was 950mm/apex A). The reclaimed 50mm band (world Z=[950,1000],
full chamber_L length, Y=0) is genuine FIXED, non-moving material —
real structural weld base for the relocated prep tray's hinges (see
Compartment Map below). Chamber body/apex-A/`chamber_floor_z`/`chamfer`
all UNCHANGED — real, live CGAL-confirmed (new band NON-EMPTY vs the
existing fixed shell; lid's own real swept volume EMPTY vs the band at
every angle from 0.5° to 120°).
Grill grate (2026-07-22, v22 — REAL CORRECTION, not a new decision): RESTORED
as the project's actual master/reference datum, per Janis's own explicit
statement that this is how the original Skeleton file/scope of work always
intended it. The "grate independently, TEMPORARILY fixed, decoupled from the
chamber body" description immediately below (2026-07-18 era) was itself the
time-pressure workaround now being undone — kept as real history, not deleted.
Real chain now: `GRATE_Z` (master, real top-level constant) -> `APEX_A_Z =
GRATE_Z - 50` (derived) -> `chamber_floor_z = APEX_A_Z - chamfer` (derived) ->
every other chamber/firebox datum. Same real -100mm level drop applied this
round: `GRATE_Z` 1000mm->900mm, `APEX_A_Z`/apex-A 950mm->850mm, entire
chamber+firebox assembly shifts -100mm (real, verified via bounding-box/
vertex check — zero shape distortion). Grate-height-above-true-ground target
(900-1000mm, locked prior round): the companion understructure round
(BBQ-understructure-v14.scad, bbq-understructure-level-drop-companion,
same day) confirms wheels/axles stay fixed to true ground Z=0 — the real
grate height above true ground is therefore now EXACTLY `GRATE_Z`=900mm
(the restored master itself), the bottom edge of the locked 900-1000mm
target range. Both rounds together are a deliberate, real step toward a
SHORTER, more flexible overall structure built on one restored master
datum (Janis's own stated goal) — flagged for Janis's own confirmation
that 900mm (not a value elsewhere in the 900-1000 range) is the intended
real target, not assumed closed automatically by this round.
2026-07-18-era entry, kept as real history (the workaround now corrected
above, not deleted):
Apex A / chamber body reference: EXACTLY 950mm world Z (REAL, BUILT,
2026-07-18 — `chamber_floor_z` is now `950-chamfer`, algebraically exact).
Supersedes the prior 900mm value (2026-07-17 round). Grill grate: still
independently, TEMPORARILY fixed at 1000mm — UNCHANGED this round. Real gap
above apex A is now 50mm (was 100mm), an automatic consequence of the
chamber's own reanchor, not a separate edit. Same future-reinforcement-
frame re-merge plan as before, still NOT permanent architecture.
Understructure (2026-07-21, v8): Janis's own SECOND direct-feedback round
the same day. Real pre-existing bug found+fixed: prep_shelves()'s own
right-side shelf applied mirror() AFTER an already-applied translate(),
reflecting the pre-positioned geometry back around Y=0 instead of onto
the chamber's opposite side — real measured consequence (STL vertex-
extent probe): both shelves landed on the SAME side (combined Y-extent
[-610,0]) — matches "bad tray stack in each other". Fixed: dropped the
unnecessary mirror(), right shelf now a direct translate([0,chamber_W,0])
— real, confirmed one shelf per side ([-300,0]/[610,910]). Also
re-investigated (unchanged code): the rear fender's "coiled" look in
Janis's own screenshot — a real matching-angle F6 render reproduces the
same clean flat+curved band, strong evidence of an F5 Preview rendering
artifact, flagged for Janis to re-check via F6 specifically.
Firebox (2026-07-21, v17): 2 real fixes to defects the v16 round's own
octagon-clip fix introduced/left unaddressed, found via CGAL and
re-rendering before this round shipped (not assumed clean). (1) the
flange solid-filled ~48.5mm of the chamber's own real hollow interior
bore — a genuine wall blocking the interior, never asked for. (2) that
same clip also carved a real hole with no material from either part
wherever the firebox's 580mm square exceeds the octagon's real width —
matches the separate "missing...end cap that should stretch to fuse"
finding. Fixed via one redesign: the flange's own outer boundary is now
always the full continuous square (flush with the main body, zero
notches), with only the chamber's own real hollow-bore shape cut out of
it. Real CGAL: EMPTY vs the hollow cavity (2mm margin), NON-EMPTY vs the
real wall material. Also new: 4 real firebox sub-part toggles (fire
cylinder/its end cap/outer shell/its end cap), per Janis's explicit
request.
Understructure (2026-07-21, v7): Janis's own DIRECT feedback, not a new CC
prompt — real pointer bump wires v16's own firebox fixes into the full
assembly. 1 real fix: rear fender REBUILT AGAIN — v6's own full-arc-from-
the-wall design was STILL the wrong shape per Janis's direct feedback.
Real root cause found by re-reading the ORIGINAL v5-round prompt's own
written spec text (not re-guessed): a FLAT plate over most of the run,
curving down ONLY after clearing the wheel's own outer edge — v6 had
overcorrected into a full arc with zero real flat run. FIX: real flat
plate from the firebox wall to directly above the wheel's own center (the
real geometric tangent point to the flare's own inner radius), then the
existing curved-flare mechanism continues from there down past the
wheel's own outboard tangent edge. Real CGAL: clears the wheel (empty),
clears the rear axle/struts (empty), real weld contact with the outer
shell (non-empty) — re-rendered visually, confirmed a real wraparound
hood shape (flat top + curved outboard flare), not a side-mounted wing.
Firebox (2026-07-21, v16): 4 real fixes to defects Janis flagged as "told
chat many time to fix but dont effectively fixed". FLANGE_LEN 20->50mm
(Janis's explicit spec change, stronger structural tuck-under support) —
confirmed STAYS ADDITIVE (FIREBOX_SHELL_L=630mm, was 600mm; FIREBOX_L's
own 580mm interior depth untouched). Rear passage REBUILT: real root
cause found via CGAL+echo diagnostics — the v15 circle (194.898mm dia)
was sized purely from the fire cylinder's own 0.008-fire-volume target-
area rule, with ZERO reference to real chamber material, leaving 33.233mm
of its own bottom below chamber_floor_z entirely (a literal hole through
nothing, matching Janis's screenshot exactly — "the hole shape is dictate
by the cut on the chamber, nothing else"). FIX: size/position now DERIVED
from the real vertical band where the cylinder's own clear bore overlaps
the chamber's real octagon material (15mm real margins both ends), built
as `intersection(candidate circle, real chamber material)` — real new
radius 65.335mm (was 97.449mm). Real CGAL: now fully contained in real
chamber material AND fully clear of the cylinder's own bore wall.
fire_cylinder_end_cap() and the outer shell's own flange/end-cap footprint
BOTH rebuilt two-zone (octagon-clipped above chamber_floor_z, native
circle/square below) per Janis's own explicit shape spec — the flange's
own two-zone shape had been flattened to a plain square back in v14.1 to
fix a different, real visible-step defect at the time; that flattening is
now retired specifically at the flange/end-cap (not at the door-end
partition, which still correctly uses the plain square, no chamber
reference there). Combined with the passage fix, real material now sits
behind wherever the passage hole is cut through the flange — resolves the
"rat hole"/unsupported-opening look Janis flagged. 3 items from the same
feedback round explicitly OUT OF SCOPE this version (flagged, pending a
reference image/clarification from Janis): prep tray/shelf location,
front wheel axle center bracket ("T bar puller") shape; the wheel-to-
firebox 100mm gap reconfirmed via echo as already exactly 100mm,
unchanged (not a defect).
Understructure (2026-07-20, v6): real pointer bump wires v15's own square-
shell/cylinder firebox into the full assembly for the first time. 4 real
fitment fixes from Janis's live desktop review of v5: prep shelf now 3
real distributed mounting brackets (was 1, cantilevered ~290mm unsupported
far end). TRACK_WIDTH recomputed 1080->980mm (100mm wheel-to-firebox gap,
was 150mm — firebox insulated, wheel sits closer). Rear fender rebuilt as
a real short flared wing (was a long straight panel — the flat mounting
portion spanned to the wheel's own centerline before curving; fixed by
starting the arc almost immediately at the real angle where it reaches
the firebox wall). T-bar bracket now mounts directly at the front axle's
own real plane (was floating 100mm above it) with a new curved gusset
fillet. Real, automatic consequences of v15's own firebox reanchor:
REAR_BRACKET_H/LEG_DROP recompute to 191.4mm/351.335mm (were 342.8mm/
199.935mm) via their own unchanged live formulas. Tow handle (T-bar):
length unchanged (1102.735mm) — the v5-flagged 50mm roof-overshoot flips
to a genuine 50mm real clearance margin as a side effect of the gusset
fix. Front-wheel/bracket collision re-checked at the new geometry: still
resolved. REAL BUG FOUND+FIXED VIA CGAL: the fender's own wider arc sweep
broke the inherited wedge-mask technique (chord cut inside the ring,
producing disconnected slivers) — fixed with a real multi-point fan mask.
Firebox: 2026-07-20 (v15) — REAL STRUCTURAL REDESIGN. Outer shell rebuilt
as a true 580x580x580mm CUBE (was 580(W) x 428.6mm(H) x 480mm physical
length under v14.2) — all three real dimensions equal, "dice" proportions
per Janis's own explicit direction against reference photos. Real, direct
consequence: firebox_floor_z drops to 420mm (was 571.4mm) — the firebox
now extends 351.335mm below chamber_floor_z (was 199.935mm), closing
~151mm of the real gap to the axle plane (understructure's own concern,
next round). Rectangular inner duct RETIRED entirely, replaced by a real
456mm-diameter fire cylinder (62mm wall clearance, Janis's own explicit
choice — well over this project's 30mm minimum, real OPEN AIR gap, not
insulation-filled, a deliberate choice not a default), full 580mm depth
(equal to W/H, per the cube requirement). Real fire volume: π×228²×580mm
= 5,780.25in³ = 100.75% of the theoretical ~5,737in³ target (was 102.7%
under the old rectangular-duct design). REAL, NECESSARY FORMULA
CORRECTION found before shipping (not a silent carryover): the firebox's
own near/weld end (`firebox_x0`) was previously derived from a historical
X-midpoint formula that only worked by coincidence while the duct's own
interior length never changed — growing it (460->580mm) under that old
formula would have pulled the firebox's own hollow cavity 60mm into the
main chamber's own real territory, a genuine new conflict risk with the
grate/lid-territory. Fixed: `firebox_x0` now pinned directly at its own
real, unchanged weld-overlap position (913.5mm) — all +120mm of this
round's own real growth happens on the door/far end only, away from the
chamber, matching how a bigger firebox physically must behave.
Rear passage: 2026-07-20 (v15) — the trapezoid (v14.1/v14.2's own LOCKED
spec, derived from the octagon's taper to match a RECTANGULAR duct)
RETIRED — that derivation has no natural basis now the duct is round.
REBUILT as a plain circle, real target area (0.008x the new real fire
volume): 46.242in² = 29,833.5mm², diameter 194.898mm. REAL FINDING, NOT
SILENTLY RESOLVED: the fire cylinder's own true center now sits BELOW
chamber_floor_z entirely (a direct consequence of the height growth
above) — the passage is positioned biased toward the cylinder's own real
top instead (5mm margin below it, judgment call, flagged). Real CGAL
measurement (STL volume, not an estimate): 88.7% of the circle's own real
area is genuinely cut through real chamber material; the remaining
~11.3% is a real, confirmed chord below the floor line — matches this
project's own repeated v13/v14 precedent for circular-passage findings,
not a novel deviation. Real cut-through ray-probe (door open) confirms a
genuine, unobstructed through-hole.
NEW end partition (fire_cylinder_partition()): square plate locating the
cylinder within the square outer shell, per Janis's reference photo.
TWO REAL BUGS FOUND+FIXED VIA CGAL DURING THIS ROUND'S BUILD (not assumed
clean): (1) the ash tray's own real safe width was first derived checking
the wrong corner (the tray's top, not its farther-from-center bottom
face) — a real, substantial 49,100mm³ overlap with the cylinder's own
solid wall was found via CGAL, fixed by shrinking the tray 150->80mm,
re-verified empty. (2) the new end partition sat exactly coincident with
the firebox door's own face (a real Simple:no non-manifold result) —
fixed via a real e=0.01mm epsilon pull-back, re-verified Simple:yes.
SEPARATE, REAL, PRE-EXISTING FINDING (flagged, not fixed — chambers
frozen, no further touching this round): the firebox door is still real,
CGAL-confirmed non-manifold above ~90-95deg open — re-confirmed
identically on this round's own new v15 geometry, same defect flagged in
the prior (understructure v5) round, NOT a v15 regression.
Far end of the internal duct/cylinder remains an explicit OPEN ITEM —
Janis: "let me see how it looks then I'll explain the adjustment."
Understructure (2026-07-22, v12): bbq-understructure-v12-tray-removal-
fender-trackwidth. TASK 1: prep tray/shelves REMOVED entirely from this
file — relocating to a separate accessories file
(BBQ-offset-smoker-base-v2.scad, later superseded by
BBQ-offset-smoker-base-v3.scad — bbq-base-chain-recalibration,
2026-07-22, linkage-only, zero content change to the tray itself) in the
immediately-following bbq-chamber-parting-shift-and-tray-init round, not
gone from the product concept (see Compartment Map/Functional Features
below). Understructure itself superseded by BBQ-understructure-v13.scad
same round (pure pointer-only bump to BBQ-chambers-v21.scad, zero
geometry change). TASK 2:
rear_fenders() rebuilt to Janis's own precise real spec (rear wheels
ONLY, no front fender) — flat 548.64mm x 300mm deck plate, 300mm real
fixed outward extension from the firebox outer shell's own wall, 15mm
droop at each 54.864mm end, fender_z(underside)=472.2mm. Real live
OpenSCAD CGAL: EMPTY vs tire (exactly 15mm real margin, bisected), EMPTY
vs axle/struts, NON-EMPTY vs firebox outer shell (real weld contact).
TASK 3: TRACK_WIDTH_FIREBOX_GAP 100->50mm, TRACK_WIDTH=880mm (was
980mm), real wheel Y=-135mm/745mm — real front-wheel-vs-bracket
collision re-checked fresh at this narrower width (the opposite
direction from the v5 fix that originally resolved it), confirmed EMPTY.
Chamber body/apex-A/grate-height items above all UNCHANGED this round
(chambers frozen, out of scope).

---

## Compartment Map — per addendum Section 3a, materially correct but NOT
yet Janis-reconfirmed in this exact wording (see flag above)
- Cook Chamber — main octagonal-profile smoking chamber, pass-through
  smoke flow (V1)
- Firebox — offset, attached at chamber rear (world X, corrected from the
  original prompt's own Y notation — see BBQ-chambers-v1.scad header).
  2026-07-17: insulated jacket around an internal cylindrical fuel vessel
  (REPLACES the old internal fire-grate concept) — see Envelope above
- Chimney — front shoulder mount, foldable, internal drop-tube down to
  grate level
- Understructure — corner-tube wheeled frame, 2 fixed + 2 swivel casters
  (18"/457.2mm wheels, FINAL as of 2026-07-17), shared 880mm track width
  front+rear (2026-07-22, v12, was 980mm — 50mm firebox-to-wheel gap,
  Janis's own real spec update), rear fenders ONLY, welds to the firebox
  outer shell, real wheel-arch cross-section per rules-bbq-fab.md's
  **Wheel-Radius-Derived Fender Arch Convention** (2026-07-22, v15 —
  flat roof + two straight sloped shoulders, a reusable WHEEL_R-
  parametric formula, not a fixed number set; replaces the flat-plate-
  with-curve-down-zone design v10-v14), T-bar tow handle mounted at the
  front axle's own real plane with a curved gusset at chimney end.
  Active file: `BBQ-understructure-v15.scad` (2026-07-22, bbq-rear-
  fender-arch-redesign — see rules-bbq-fab.md's own convention for the
  full real formula; that same file's own header states the real solved
  values at the current WHEEL_R and the real CGAL-confirmed clearance
  margins). Previous round: `BBQ-understructure-v14.scad`
  (bbq-understructure-level-drop-companion — absorbs the companion
  chambers round's own real -100mm level drop structurally: rear strut/
  beam height 191.4->91.4mm, front swivel-caster post 185.4->85.4mm,
  T-bar upright 1102.735->1002.735mm, all real, live-measured. Wheels/
  axles stay fixed to true ground Z=0, unchanged)
- ~~Prep Shelves x2 — fold-up (vertical stowed / horizontal deployed),
  left + right, front of chamber~~ — REMOVED from Understructure
  2026-07-22 (v12)
- Accessories — NEW branch, 2026-07-22 (v21/base). Active file:
  `BBQ-offset-smoker-base-v5.scad` (2026-07-22, bbq-rear-fender-arch-
  redesign — pure pointer-only bump from v4, tray content byte-
  identical, real change is the understructure fender profile it now
  points to). Supersedes `BBQ-offset-smoker-base-v2.scad`, whose own
  direct chambers include bypassed the wheels entirely. The relocated
  prep tray lives here: 2 trays (457.5mm x300mm x2mm plate each, 5mm real
  additive gap), mounted Y=0 side only, hinged to the chamber's own fixed
  band at real Z=980mm (read live from the chamber's own restored master
  datum, see Envelope above). Own independent fold parameters
  (`tray0_angle_deg`/`tray1_angle_deg`, -90° stowed / 0° deployed). A lid
  counterbalance/fulcrum mechanism is the planned NEXT addition here
  (Janis still developing the concept, not designed this round)

## Functional Features — per addendum Section 3a, see flag above
1. Full-length counterbalanced lid — lever + weight, target ~85-90%
   self-balance (slight self-closing bias, not full balance)
2. Full-width lift handle rail, 150mm standoff, 2+ mounting posts
3. 2+ floor drain valves, spaced front-third / back-third of chamber
4. Firebox door — lockable, off-shelf spiral-wire heat-safe handle
5. Laser-cut steel grill grate, 3-4 removable segments on internal
   support ledge
6. 2 fold-up prep trays (vertical stowed / horizontal deployed) —
   RELOCATED 2026-07-22 from Understructure (v12, removed) to the new
   Accessories branch (`BBQ-offset-smoker-base-v3.scad`, current active
   file as of the bbq-base-chain-recalibration round), hinged to the
   chamber's own new fixed band (see Envelope) instead of the chassis
7. Foldable chimney with internal drop-tube (smoke circulates low
   across food, not a short-circuit top vent)
8. Adjustable firebox air-intake damper
9. ~~Slide-out ash tray~~ — REMOVED 2026-07-21 per Janis's own explicit,
   direct instruction ("just remove this tray, keep cylinder clean") —
   flagged as asked several versions prior and never actually done until
   this round; fire cylinder interior is now clean/empty, no ash-handling
   feature in the current scope
10. Toggle-clamp lid latches x2+
11. Dome thermometer port (placeholder)
12. Hybrid fuel — wood or charcoal

## Appearance / Do-Not — per addendum Section 3a, see flag above
- Reference plan images (corner-tube frame, toggle-clamp lid) are
  construction-method inspiration only — do NOT copy their dimensions
- V1 is pass-through smoke flow only — reverse-flow is explicitly OUT
  OF SCOPE for this version, do not add it

## Made / Buy / Hire — per addendum Section 3a, see flag above
- Made (laser-cut / welded in-house): grill grate segments, drain valve
  bosses, chamber/firebox shells, understructure frame
- Buy (off-shelf): wheels, axle, wheel-axle joints, toggle clamp
  latches, dome thermometer, spiral-wire firebox handle, drain valves
- Hire / supplier-verify: bend allowances for formed panels (doors,
  end-caps)
