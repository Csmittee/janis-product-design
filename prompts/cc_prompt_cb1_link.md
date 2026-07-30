# cc PROMPT — CB1 Lateral Link, Middle Rib (RIB1) — Rebuild from Locked Base

## Do not touch — LOCKED geometry
`BBQ-offset-smoker-base-v11.scad`'s existing t1–t6 profile (`rib_profile_2d_native()`,
`part1_2d()`, the existing `part2_2d()`/whatever currently builds t4-t5-t6) is
CONFIRMED and must not be redrawn or reshaped. Reuse it exactly as-is.

Semantics, confirmed by Janis directly — get this right before writing any code:
- **t1** = a CENTER (handle bore, real hole, has its own radius R1).
- **t6** = a CENTER (rotation/pivot axis for the whole rib+lid assembly, real hole, radius R6=28.5, axle bore d=27 cut through it).
- **t2, t3, t4, t5** = EDGE points, not centers. They define the blade's boundary directly (each still carries a local width value R2-R5=20 for the hull-chain construction, but they are not "features" or bosses — do not enlarge them, do not add extra anchor/patch circles at them).
- **t4 to t5 must be FLAT** — both sit at the same Z (1301.34), and since neither is a center, the segment between them is a straight, flat edge. (A previous draft attempt distorted this with oversized "anchor" circles trying to force OpenSCAD boolean connectivity — that was a mistake, not part of the design. Do not reintroduce it.)

## New construction — CB1 lateral link (extends from t6 onward)

Everything below is built in the **door_open_deg=90 (open) reference frame**
against the fixed C, D, E octagon points (these never rotate — they're defined
from fixed chamber constants), then frozen back to the native/closed frame by
rotating -90° about the shared pivot (FC_Y, FC_Z), exactly like t1-t6's own
"open-then-freeze" convention already in the file (see `docs/hinge-construction.md`).

**Fork / bracket (unchanged from earlier confirmed round):**
- CB1 = 4" square tube (101.6mm), positioned 30% along D→E, floating 20mm off the DE face.
- Ua/Ub/Uc = U-shaped welded bracket wrapping CB1 on 3 sides, 20mm wall, Ua/Uc reach 2" (50.8mm) along the pipe face, Uc's outer face is the DE-contact stopper.
- Ubbc = point on Ub's own back edge (intersection of Ub's centerline parallel to DE, and Ub's back edge perpendicular to DE).

**neck_l / neck_r (per Janis, this round):**
- Two lines parallel to DE, offset from Ubbc by 20mm each side (40mm total neck width) — `neck_l` is the side closer to the chamber/DE face, `neck_r` is the top-ridge side (matches Ua's side).
- **The neck itself — from the fork out to t7 — is a RIGID, FIXED length: 25mm, on both neck_l and neck_r.** This is the primary control. t7 (bottom) and its counterpart on neck_r (top) are simply the points 25mm out from the bracket along each line — **not** overlapping or colliding with the bracket's own footprint. If a 25mm offset from Ubbc lands inside or against Ub's own physical extent, that's a real conflict to flag back to Janis, not something to silently resolve by moving t7 closer.

**t6be (bottom rib origin point — a POINT, not a center, no boss radius):**
- A vertical line through t6, offset downward by ≥15mm, giving a startup point clear of the t6 boss. This is just a coordinate, like t2-t5 — do not give it an oversized anchor circle.

**Bottom rib line:** t5 (existing) → t6be → t7, where the t6be→t7 line is drawn at
**whatever angle is needed** to reach the point on neck_l that is exactly 25mm
from the bracket (Ubbc). t7 then connects directly onward into neck_l → the fork.

**This 25mm point is a strict requirement, not an approximate target.** t7 is
NOT "wherever the t6be line happens to reach neck_l" — it is defined FIRST as
the fixed point sitting exactly 25mm out from Ubbc along neck_l (a true rib
zone, not a loose aim point), and the t6be→t7 line is then drawn to hit that
exact point, at whatever angle that requires. Compute t7 from the 25mm
constraint first; derive the line's angle second. Get this order backwards
and the neck collapses toward Ubbc again, same failure as before.

**Top rib line:** t4 (existing, edge point, already carries ~40mm of rib material above it) →
a point 40mm vertically above t7 → continues into neck_r → the fork. (Note: re-derive this
top-side point fresh once t7's real position is settled — don't reuse a stale "+40mm above t7"
value from a previous, now-superseded t7.)

Add fillets/smoothing only after the base shape (straight lines, sharp joints OK) is
confirmed connected and correctly clears D/C. Cosmetic pass comes later.

## QA checklist — verify before showing Janis anything
1. **Connectivity**: export the 2D profile to DXF, confirm exactly 3 closed loops (outer boundary + pivot bore + handle bore), zero stray/disconnected islands. `Simple: yes` on a full `--render` at door_open_deg=0 and 90.

2. **D-apex clearance — VERTICAL direction only, not radial.** Check the Z (vertical) separation between the built boundary and apex D, not full Euclidean distance in every direction. Must be ≥20mm vertically wherever the boundary passes near D's Y-position. This includes double-checking the fork/Ub bracket itself — a prior round found Ub's own corner sits only ~5mm from D (CB1's 30%-along-D-E position combined with Ub's 70.8mm reach-back toward D). **This is still unresolved** — either shift CB1 further from D or resize Ub; needs Janis's call, don't decide unilaterally.

3. **CD-face clearance — this is NOT a check against apex C.** C itself is already safe: t4→t5 is flat, and the path continues straight to t6be, which is the *lowest* edge of the whole assembly when the door is open — apex C is never the risk. The real risk is **t6be being miscalculated and colliding with the CD face itself** (the horizontal ridge surface, not just the point C). Check t6be's clearance against the full CD plane/surface, not against the C endpoint.

4. **Material around the t6 bore (pivot, 3/4" bore per spec) must be ≥20mm thick everywhere, for strength.** Check the full perimeter around the bore, not just one direction — no point on the boundary should come within 20mm of the bore's own edge.

5. **neck_l / neck_r's "25mm above Ubbc" points are a true rib zone, strictly enforced — not an approximate target.** The line drawn from t6be must actually touch neck_l exactly at the point 25mm above Ubbc to form t7. If this isn't hit exactly, the neck collapses toward Ubbc again — same failure as the last draft.

6. t4-t5 segment reads visually flat/straight in a rendered section view — if it doesn't, something (like an oversized anchor circle) has distorted it.

## A real technical trap hit repeatedly this session — worth knowing
OpenSCAD's 2D `union()`/boolean engine has shown genuine (non-numerical) small
gaps between separately-constructed pieces that *should* geometrically overlap
(confirmed: circles with identical center/radius as an existing hull, or two
circles with a real measured 3-5mm gap, sometimes fail to merge; `offset(delta=-X)
offset(delta=X)` "closing" does NOT reliably fix this in OpenSCAD as it would in
a true morphological closing implementation). If this recurs: verify with an
isolated minimal test file first (2-3 primitives only) before assuming the
full-assembly geometry is wrong — the disconnect may be a boolean-engine
artifact, not a real design error. Don't paper over it with oversized anchor
circles (that's what distorted t4-t5 this round) — find the minimal real fix,
or flag it rather than guessing.
