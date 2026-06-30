# PR-01-base-v16 — Neck-Bell Alignment Fix + rules-pr.md Governance Update

Save SCAD as PR-01-base-v16.scad (v15→v16). Update rules-pr.md (version bump
per standard rule). Two tasks, both required.

---

## TASK 1 — pole_top() neck/bell alignment fix (geometry)

**Issue A — center misalignment:** Neck's vertical centerline does not align
with the bell's centerline — visible offset in current render. Fix: neck
centerline must align exactly with the bell's central axis (the axis the
bore runs through, perpendicular to it at the union point).

**Issue B — neck intrudes into bore clear path:** Neck currently unions too
far into the bell, overlapping the small-end bore opening — the 32mm bar
would physically strike the neck wall instead of passing through cleanly.
Fix: reposition the neck attachment so it sits clear of the bore's full
diameter at every point along the bore's length — the bar's complete
horizontal path through the bell must remain unobstructed by the neck. The
neck should extend down/back from the bell's underside, past the 2x M6
screw mounting zone (mounting holes need full clearance from the bore too),
without any neck geometry crossing into the 33mm bore envelope.

**Verify:** the bore should still be visibly open and unobstructed end-to-end
when viewed along its axis (X), exactly as confirmed working in v14 — this
task is alignment/clearance only, do not regress the bore axis or diameter.

**Unchanged:** bore diameter (33mm), bore axis (X), bell wine-glass profile
intent (small-face concave correction still pending as a separate future
task — do not attempt in this prompt), pole_od=40mm / neck OD=46mm from v15,
2x M6 through-bolt mechanism.

---

## TASK 2 — rules-pr.md governance update (documentation only, no other SCAD changes)

Add the following sections/notes to rules-pr.md. Version-bump header per
standard rule. This consolidates several items discussed with Janis that
were never written into the file.

### 2a. Bar spacing / bed width constraint — NEW OPEN ITEM
Add to OPEN ITEMS or a new flagged section: "Pole-to-pole bar spacing target
= 720-740mm (ergonomic, Janis-confirmed). Unlike common market designs that
mount poles on the OUTSIDE of the bed frame (allowing a narrower bed to hit
this spacing), this design mounts poles directly through the wood leg
itself — meaning bed_w as currently scoped may be wider than needed to hit
the 720-740mm target. This must be resolved as the FIRST task of the next
bed-focused session, before any other bed geometry work — recalculate bed_w
against pole-center spacing, do not assume current bed_w value carries
forward unchanged."

### 2b. Crossbar 3-part modular structure — GAP FILL
Add to COMPONENT SPECIFICATIONS: crossbar follows the same joint-body-joint
modular logic as the pole, not a single continuous piece — a joint at each
end (where it meets pole_top's bore) plus a body section between. Update the
assembly hierarchy diagram to reflect crossbar_joint() x2 + crossbar_body(),
not a single crossbar_body() spanning the full length.

### 2c. "No floor storage — fully built-in" principle — NEW
Add as a design principle near FUTURE FEATURES: all accessory systems
(slider rail, spring system, barrel/spline adjuster) must store within the
bed structure itself when not in use — no external/floor-standing storage
components. This governs how those future systems must be designed for
retraction/concealment within bed_h and bed_w envelope.

### 2d. Flagship differentiator — repositioning note
Add a short note above or within FUTURE FEATURES making explicit that the
combined barrel + Wunda chair + Cadillac frame capability (currently listed
as 3 separate future bullet items) is the PRIMARY differentiator of this
product line, not a minor add-on — flag as patent-candidate, treat design
decisions around bed underside clearance and end-frame bolt patterns as
protecting this capability, not incidental.

### 2e. Barrel/spline system — missing mechanism detail
Update the barrel/spline future-feature bullet to include: uses U-slot PU
foam for variable curve adjustment, retracts under the bed when not in use,
and when retracted/filled acts as a flush filler so the bed surface reads as
one continuous flat static platform (functioning as a firm Cadillac-style
surface) — this dual-mode behavior must be preserved in any future bed
design, not just the curve-adjustment function alone.

### 2f. Super Luxury tier — NEW row in VARIANT MATRIX
Add a 6th variant row above or alongside Classic Std: "Super Luxury" —
copper hardware, full CNC-cast joints, crocodile/high-grade leather straps
and cable, precision fine-gear movement feel (smooth mechanical "click"
quality on all moving joints, comparable to fine watch movement), highest
price tier. Status: LATER, but explicitly distinct from Classic Std's
"Polished SS + copper accent" description — Super Luxury is a materially
different tier, not a finish variant of Classic Std.

### 2g. Quick-release grip-material rationale — clarify intent
Add a note to the TOP COLLAR / quick-release component spec: the
quick-release mechanism exists specifically to let one customer swap
between multiple grip bar materials (steel, wood dowel, leather-wrapped,
composite, padded) to solve grip-comfort pain points (sweat, sensitivity,
hand size, climate, luxury feel) — this is a named customer pain point being
solved, not a cosmetic material option. Flag: future bar-material specs may
require the bore to accommodate more than one nominal bar OD — do not assume
33mm bore forever locks in only the 32mm steel bar when material variants
are scoped later.

---

## DO NOT TOUCH
- pole_body(), pole_base_collar(), crossbar_body() geometry — not in scope
  this prompt (3a structural change is documentation-only for now)
- Any bed_*.scad geometry — explicitly deferred per 2a above
- rules-dimensions.md — not touched this prompt

## QA
- Confirm neck centerline aligned with bell axis — state alignment method used
- Confirm bore fully clear/unobstructed end-to-end (re-verify, screenshot
  along bore axis as in v14)
- Confirm neck extends past screw mounting zone without crossing bore envelope
- Confirm rules-pr.md updated with all 7 sub-items (2a-2g) above, version
  bumped
- No undefined variable warnings, version incremented to v16

## MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Bump version on all changed files (PR-01-base v15→v16, rules-pr.md)
4. Commit all → merge to main
