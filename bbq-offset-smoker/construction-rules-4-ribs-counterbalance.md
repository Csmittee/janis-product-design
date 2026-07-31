# Construction Rules — 4. Ribs + Counterbalance System (Lid Hinge)
> New 2026-07-31. Concept + generalizable rules for the lid hinge / rib /
> CB1 counterbalance subsystem — the most iterated, most difficult part
> of this product (v6 through v20, still not fully meeting Janis's own
> holding-force target). This doc is a navigational layer over
> `rules-bbq-fab.md`'s "Three-Rib Lid Counterbalance System" section
> (locked 2026-07-24, the primary source for every rule below) and
> `docs/hinge-construction.md` (the shared-pivot construction method) —
> read both before making a structural change here, this doc summarizes
> and points, it does not replace either.

## Concept

The lid opens on a single shared rotation center (`HINGE_PIVOT_Y`/
`HINGE_PIVOT_Z`, defined once in the chambers file, read live by both
the visual lid shell and the rib assembly) via **3 identical ribs**, not
a differentiated center rib. Each rib carries three real control points:
a grab handle, a pivot axle, and a counterbalance arm (CB1). CB1 is a
real mass (a 4" square counterweight pipe, both ends capped) mounted on
the far side of the pivot from the door's own bulk — its entire purpose
is shifting the gravity-moment curve so the door doesn't require
constant muscle to hold open. This pattern — one shared pivot, N
identical ribs, one counterweight arm sized by a real moment-balance
calc — is the reusable structural concept for ANY future product line's
lid hinge, not just this round's specific numbers (`rules-bbq-fab.md`
states this explicitly).

## Generalizable rules

**Physics-first, not geometry-first:**
1. Size/tune CB1 from a real Python moment-balance model (not OpenSCAD),
   using each mass's real CG (from actual STL volume/centroid
   integration, not hand-derived box math) — see
   `docs/lid-hinge-moment-analysis.md` for the current live method and
   closed-form `M(θ) = -g·(A·cosθ + B·sinθ)`. Target the force at BOTH
   sweep extremes (0° and 90°) as the primary constraint; a mid-sweep
   sign change partway through is expected, not a defect, as long as
   both endpoints land in a comfortable range.
2. Start with ONE counterbalance arm; only add a second (differentiated
   on one rib) if a real moment-balance calculation PROVES one arm
   cannot meet the target force range — never default to a two-arm
   design as a first attempt.

**Shared rotation center (see `docs/hinge-construction.md` for the full
worked method):**
3. Two rigid bodies that must move together (the lid shell, the rib/
   hinge structure) MUST share the literal SAME rotation center — not
   just numerically-close ones. A 5-round saga (v8) was caused entirely
   by two independently-tuned `FC_Y`/`FC_Z`-equivalent points in two
   different files; no per-corner standoff tuning can fix a structurally
   wrong setup like that. Fix: one real named constant pair, read live
   by every rotation call on both sides of the joint.
4. Any reference point pulled from the chamber's own profile (an
   octagon vertex, or a round variant's tangent point) used as a fixed-
   side anchor must be numerically checked against the real fixed/lid
   parting line — never assumed from a name or a sketch. Root cause of
   2 separate real bugs in this project's own history.
5. A feature meant to rest against fixed structure ONLY WHEN THE DOOR IS
   OPEN (a stopper, a link) must be built via the real "open-then-freeze"
   method — compute the target in the OPEN frame, then convert to
   native/closed frame via the shared pivot's own rotation formula
   (`freeze_from_open()`). Building it directly from a fixed reference
   point as if that were already the closed-frame coordinate bakes the
   contact state into the WRONG door position (backwards). This is the
   single most dangerous class of mistake in this subsystem's own
   history — verify any new instance by rendering BOTH door states, not
   by trusting the algebra alone.

**Rigid-body reach and rendered length (locked 2026-07-31, v19/v20
saga — the newest and most consequential lessons this round):**
6. **A part's own RENDERED length must be verified constant across the
   full sweep** (`echo()` at fine angle steps, not one sample) whenever
   it represents a single rigid piece of real stock — a formula that
   "looks right" in a render at 2-3 angles can still describe a bar that
   silently changes length across the sweep, which no real steel bar can
   do (v19's `lc=midpoint(ts,tt)` defect, undetected by every collision
   probe and every render, only caught by reading what the code
   actually computes).
7. **A point rigidly attached to a rotating body orbits that body's own
   pivot at a CONSTANT radius — a hard geometric fact.** Any other
   part's own reach from that point is bounded by it; forcing a link tip
   onto a target without checking this can produce a tip swinging past
   the anchor's own physically reachable orbit (a real, caught mistake
   this round). A slotted/telescoping joint (real variable reach along
   one bar's own length, not a bar that itself changes length) is the
   correct mechanism when a fixed-length 2-bar link cannot geometrically
   reach a required alignment — see `docs/tray-relocation-bracket.md`'s
   v20 section for the worked example (same principle used there for
   the tray folding link, not the lid ribs, but the lesson is shared
   across every rigid-link mechanism on this product).

**Construction discipline (full detail in `rules-bbq-fab.md`'s locked
section — read before reusing):**
8. Rib profile: minimum width by default, widened ONLY at real
   transition zones (weld-contact, handle-wrap, CB-branch), smooth
   hull-of-circles fillets between them.
9. A multi-piece bracket assembled from several rectangles sharing a
   coincident (not overlapping) edge can still hit OpenSCAD's 2D
   boolean coincident-edge gap trap even with analytically exact
   coordinates — trace it as ONE single polygon instead.
10. A convex-corner clearance fix (arc-around-the-corner vs. a single
    pushed closest-approach point) is NOT universally correct either
    way — it depends how close the pivot itself sits to that corner;
    re-test the technique fresh any time the pivot moves closer to a
    previously-cleared corner.
11. A pivot's own fixed distance to a nearby corner is a PROVABLE
    CEILING on any branch's clearance built from it — state this ceiling
    explicitly (and flag if the product's own meat-around-bore
    convention makes the formal clearance target unreachable) rather
    than iterating construction techniques indefinitely.

## Current live implementation (BBQ-offset-smoker, v20/v26)

- `BBQ-offset-smoker-base-v20.scad`: `lid_rib_rotate()`/
  `lid_rib_assembly()` (the 3-rib assembly), `rib_solid(RIB_X,
  with_cb1)`, `cb1_pipe()` (the real 8kg counterweight mass),
  `hinge_bracket()`/`lid_hinge_assembly()` (fixed-side mount).
- `BBQ-chambers-v26.scad`: `HINGE_PIVOT_Y=242.665mm`,
  `HINGE_PIVOT_Z=1345.34mm` (the one shared rotation center), `lid()`.
- Full current moment analysis: `docs/lid-hinge-moment-analysis.md` —
  20.93kg total rotating mass, 2.46 kgf startup lift, zero-crossing at
  89.4°, only 0.03 kgf holding force at full open (near-neutral, NOT
  Janis's stated ~5 kgf self-holding target — a real open tuning item on
  CB1's own 3 adjustable knobs, not a code defect, not resolved this
  round since the CB1 bracket is called "locked").
- **Known open items, not resolved this round**: `ts`'s own hinge (`al`)
  still sits exactly on one of `tray_bracket()`'s own 3 triangle
  vertices (a tray-system interaction, not a rib defect per se — see
  `construction-rules-5-tray-system.md`); `TRAY_LINK_BRACKET_CLEAR`'s
  X-offset makes the tray-side anchor look shifted to an asymmetric
  corner, Janis's own flagged complaint, not addressed.

## New-variant checklist

1. Fix the new product's own shared rotation center FIRST (one named
   constant pair, read live by both the lid shell and the rib assembly)
   before drawing any rib geometry.
2. Build and kinetically sweep-test the door-side rib arm alone before
   drawing the counterbalance branch.
3. Run a real Python moment-balance model off actual STL mass/CG data
   before sizing CB1 — never guess a counterweight size from the rib
   geometry alone.
4. Verify every rigid link's own rendered length stays constant across
   a full-sweep `echo()` check, and every rotating point's reach stays
   inside its own anchor's constant orbit radius, before accepting any
   new link mechanism.
