# Construction Rules — 5. Tray System
> New 2026-07-31. Concept + generalizable rules for the folding prep
> tray subsystem. Same cross-referencing policy as the other 4 subsystem
> docs. Primary source for full detail: `docs/tray-relocation-bracket.md`
> (the complete v15→v20 build history, read it before touching
> `tray()`/`tray_link()`) — this doc summarizes the reusable rules, it
> does not replace that history.

## Concept

Each tray mounts on the chamber/understructure via a real hinge
(`tray_hinge()`) and folds between two states — **0°=deployed
(horizontal, in-use) and +90°=stowed (vertical, tip toward the
ground)** — for compact transport/storage. A folding link
(`tray_link()`) constrains the tray's own motion to that intended arc
and keeps it from swinging freely; the link is real, visible hardware
(a flat steel strip with clevis+pin joints), not just a computed
distance. This deployable-tray-on-a-constrained-link pattern is the
reusable concept for any future BBQ variant's own prep tray — the
specific link geometry is re-solved per product, the fold convention and
construction discipline below are not.

## Generalizable rules

1. **Fold direction convention (LOCKED 2026-07-24, v17): 0°=deployed
   (horizontal) .. +90°=stowed (vertical, tip toward ground), clockwise
   about X viewed from +X when deploying.** Confirmed only by an actual
   colored full-CGAL render, never by sign-reasoning alone — an earlier
   attempt built from "CCW=negative" reasoning and got the direction
   backwards (tray folded UP past the fixed structure instead of down),
   undetected until a real render with distinct colors was produced.
   Any future fold-direction convention gets the same treatment: state
   it, then confirm it with a real render before calling it correct.
2. **A tray's own rotation pivot must sit at the real physical hinge
   knuckle's own location — not an arbitrary offset borrowed from
   solving a different, unrelated clearance problem.** A leftover inner-
   face offset (originally added for a wall-clearance fix) caused a real
   near-full-stow collision once the actual fold geometry was built —
   root-caused only when Janis inspected a render by eye and pointed at
   the literal tip of the hinge notch vs. where the code had it.
3. **Two rigid, same-width bars sharing one pivot cannot fold together
   without interpenetrating unless offset in DEPTH, not in-plane** —
   confirmed via a real rectangle-overlap (SAT) simulation before
   building it: an in-plane pivot offset only relocates the collision,
   sometimes making it worse; only a genuine out-of-plane (depth) split
   gives the two bars a real separating axis at every fold angle, the
   same reason real hinges/scissors stack their leaves.
4. **Collision QA for a link/hinge assembly must check the moving part
   against EVERY nearby solid it could touch — not just the most obvious
   target.** A real, undetected overlap between the link's own fixed
   anchor and the mounting bracket's own solid material survived 3 full
   rounds because every prior sweep only checked the link against the
   tray plate, never the bracket itself.
5. **An isolated collision probe reporting EMPTY does not prove the full
   assembly stays manifold.** Two parts intentionally mounted flush
   (a coincident, zero-volume touching face) can still make a full-
   assembly union non-manifold even with zero real interpenetration —
   use this project's own standard `e` epsilon (a genuine tiny overlap,
   not a coincident face) for any intentional flush mount, and re-check
   the FULL assembly's own `Simple: yes/no` after any pivot change, not
   just the narrower isolated probe.
6. **A rigid 2-bar link's mid-joint cannot be forced to stay near both
   of its own endpoints once the endpoint gap shrinks well below each
   bar's own fixed segment length.** Only a genuine slotted/telescoping
   joint resolves this (real variable pin position along one bar's own
   length) — never a different root selection on the same rigid circle/
   circle solve, and never a bar whose own RENDERED length silently
   changes (that "solves" the symptom by making the part non-physical —
   see `construction-rules-4-ribs-counterbalance.md` rules 6-7 for the
   full lesson, shared verbatim between the tray link and the lid-rib
   link since both are rigid-link-on-a-rotating-anchor mechanisms).
7. **Tray skirt**: a real lip (currently 10mm) covers the hinge and
   finishes the raw tray edge at every fold angle — placed on the tip +
   side edges, with ZERO skirt on the hinge-side edge on purpose (the
   hinge itself occupies that edge; a skirt there would be redundant or
   would collide with the link).

## Current live implementation (BBQ-offset-smoker, v20)

- `BBQ-offset-smoker-base-v20.scad`: `tray(x0, angle_deg)`/`trays()`
  (the tray bodies), `tray_hinge()`/`tray_hinges()` (real hinge knuckle
  at the block's own outer tip), `tray_bracket()` (triangular gusset
  mount), `tray_link()`/`flat_link()`/`hinge_u()` (the folding link
  hardware — flat steel strip, U-clevis+pin joints).
- **v20's real mechanism** (replaces v19's non-physical shrinking-bar
  fix — full derivation `docs/tray-relocation-bracket.md`'s v20
  section): both of the link's own halves are TRUE fixed-length rigid
  arms (`TRAY_LINK_C_HALF`, ~110.76mm, verified constant via `echo()`
  across the full sweep, never changes). One arm's own bearing sweeps
  freely and monotonically; the other carries a real ~30mm SLOT so the
  shared pin can ride at a variable distance along it — this is the
  slotted-joint pattern rule 6 above describes, applied for real.
- **Known open items, not resolved this round**: `ts`'s own hinge
  (`al`) still sits exactly on one of `tray_bracket()`'s own 3 triangle
  vertices (unchanged since only the arm bearings/reach changed, not
  `ts`'s own Y/Z position); `TRAY_LINK_BRACKET_CLEAR`'s existing
  X-offset makes `ts` look shifted to an asymmetric corner instead of
  staying centered on the bracket's own face — Janis's own separate,
  unresolved complaint.

## New-variant checklist

1. State the new tray's own fold-direction convention explicitly, then
   confirm it with a real colored render before building the link.
2. Place the pivot at the real physical hinge knuckle location — verify
   against the actual hinge hardware's own geometry, not a value that
   happens to fix an unrelated clearance issue.
3. Before finalizing any 2-bar link, run a full-sweep `echo()` check
   that both halves' own rendered lengths stay truly constant, and
   verify the pin's own reach never exceeds either anchor's constant
   orbit radius (same checks as the rib/CB1 link — see
   `construction-rules-4-ribs-counterbalance.md`).
4. Run collision QA against EVERY nearby solid (bracket, plate, other
   trays' own footprint), not just the most obvious target, and
   re-verify the FULL assembly `Simple: yes` after any pivot change.
