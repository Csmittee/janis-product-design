# BBQ Offset Smoker — Design Scope of Work
> Version 1.6 — 2026-07-20
> Changes: bbq-chambers-v14.1-flat-tuckunder-trapezoid-passage. Targeted
> bug-fix + simplification round on the just-merged v14 — apex(950mm)/
> firebox width(580mm)/fire-volume math ALL FROZEN, unchanged. Envelope's
> Firebox entry: outer shell's rear tuck-under flange (+ its end cap)
> simplified from a 2-zone octagon-clipped shape (the real visible STEP
> Janis screenshotted) to ONE flat, full-height, unclipped plane — real
> CGAL-confirmed genuine contact with chamber material above the floor
> line, zero material below it, no size change. Rear passage: the plain
> 197mm circle (flagged chord-shaped, did not fully clear chamber
> material) RETIRED — replaced by a real trapezoid derived directly from
> the octagon's own boundary (bottom 226.67mm/top 540mm duct-governed, top
> edge lands EXACTLY on apex A=950mm by construction) — a LOCKED spec, not
> a placeholder. Real CGAL confirms full containment, no chord/partial-
> clip.
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
Supersedes the prior 900mm value (2026-07-17 round).
Grill grate: still independently, TEMPORARILY fixed at 1000mm — UNCHANGED
this round. Real gap above apex A is now 50mm (was 100mm), an automatic
consequence of the chamber's own reanchor, not a separate edit. Same
future-reinforcement-frame re-merge plan as before, still NOT permanent
architecture.
Grate-height-above-true-ground target (900-1000mm, locked prior round) —
still an OPEN ITEM, still not resolved (understructure untouched again
this round).
Firebox: REBUILT as two fully independent welded assemblies (2026-07-18),
replacing the prior shared-end-cap concept (a real, confirmed full-face
thermal-bridge problem). Inner hot duct: 540mm(W) x 388.6mm(H) x 460mm(L
interior, UNCHANGED), rectangular, welded directly to the chamber's own
octagon end cap. Outer insulating shell: widened 510->580mm(W) x
428.6mm(H), physical length 480mm (a NEW, separate number from the duct's
own 460mm interior — the extra 20mm is a solid structural flange only,
tucked under the chamber's own rear wall for real support). 2026-07-20
(v14.1): outer shell's rear tuck-under flange (+ its end cap) SIMPLIFIED
from a 2-zone octagon-clipped shape (the real visible STEP Janis
screenshotted) to ONE flat, full-height, UNCLIPPED plane — real CGAL-
confirmed genuine contact with chamber material above the floor line,
zero material below it (no size change, shape simplification only). Real
fire volume: 5,890.5in³ ≈ 103% of the theoretical ~5,737in³ target (was
~58% under the old round-duct design) — unaffected by the v14.1 changes.
Rear passage: 2026-07-20 (v14.1) — the plain 197mm circle (flagged
chord-shaped, field-adjustable placeholder) RETIRED, REPLACED by a real
trapezoid cut through the chamber's own octagon end cap only, a LOCKED
spec (Janis's real heat-rises/ash-avoidance design choice, not a
placeholder): bottom edge 226.67mm wide at the chamber floor line, top
edge 540mm wide (capped by the inner duct's own real width) at world
Z=950mm — lands EXACTLY on apex A by construction. Real CGAL confirms
full containment, no chord/partial-clip (unlike the retired circle).
Far end of the internal duct remains an explicit OPEN ITEM — Janis: "let
me see how it looks then I'll explain the adjustment."

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
  (18"/457.2mm wheels, FINAL as of 2026-07-17), tow handle at chimney end
- Prep Shelves x2 — fold-up (vertical stowed / horizontal deployed),
  left + right, front of chamber

## Functional Features — per addendum Section 3a, see flag above
1. Full-length counterbalanced lid — lever + weight, target ~85-90%
   self-balance (slight self-closing bias, not full balance)
2. Full-width lift handle rail, 150mm standoff, 2+ mounting posts
3. 2+ floor drain valves, spaced front-third / back-third of chamber
4. Firebox door — lockable, off-shelf spiral-wire heat-safe handle
5. Laser-cut steel grill grate, 3-4 removable segments on internal
   support ledge
6. 2 fold-up prep shelves (vertical stowed / horizontal deployed)
7. Foldable chimney with internal drop-tube (smoke circulates low
   across food, not a short-circuit top vent)
8. Adjustable firebox air-intake damper
9. Slide-out ash tray below the firebox's internal fuel cylinder (2026-07-17:
   firebox's old internal fire grate REMOVED, replaced by a cylindrical
   fuel vessel — see Envelope above; ash tray height reduced to fit the
   real clearance beneath it, flagged for review)
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
