# SKILL_kinematic_frame_construction.md
# Positioning a Point on a Rotating Body Against a Real Physical Target
# Version: 1.0 — 2026-07-26
# Location: .claude/SKILL_kinematic_frame_construction.md
# Changes: new file. Extracted from the BBQ lid-hinge session
# (docs/hinge-construction.md Section 4) — the method itself is general
# and reusable across any product with a rotating assembly, not specific
# to BBQ's own hinge. BBQ's own real numbers (pivot coordinates, the CB1
# bug this method caught) stay in docs/hinge-construction.md; this file
# holds only the reusable technique.
# Read when: building or fixing any point on a part that rotates about a
# pivot (a hinge, a fold, a lid, a lever) where that point needs to sit
# in a specific real relationship to a target on ANOTHER part — either
# the fixed structure, or a different point on the same rotating body.

---

## WHEN TO USE THIS

Triggered any time a prompt involves:
- A point on a rotating/rigid assembly (a rib, bracket, arm, or link)
  that must land in a specific real position relative to a physical
  surface or another part, described naturally in terms of ONE specific
  angle (e.g. "when open, this pipe sits flush against that face" / "when
  closed, this bracket's foot touches the floor").
- Any construction that currently converts between a rotating body's own
  native/design frame and its real-world swept position at some angle.

Do NOT use for: a point that's ALREADY naturally specified in the body's
own native/closed frame with no real-world angle-dependent target (no
conversion needed there at all).

---

## RULE 1 — BUILD IN THE FRAME WHERE THE PHYSICAL CONSTRAINT IS ACTUALLY TRUE, THEN CONVERT

A real physical constraint ("parallel to that face," "flush against that
surface," "standing off by an air gap") is only simple to state and
verify correctly in the ONE frame where it's actually true — usually a
specific real-world angle (fully open, fully closed, some named rest
state). Do not build the point directly in the body's native/design
frame using native-frame reference geometry and just LABEL the result
"the open position" — that skips the actual rotation and produces a
number with no real geometric meaning.

**THE METHOD:**
1. Rotate the relevant reference point(s) — the target surface/part's
   own anchor point — to their TRUE position at the angle where the
   constraint is true, using the project's own real world-from-closed
   rotation function. Do not reuse a native/closed-frame point and just
   relabel it as if it were already rotated.
2. For DIRECTION vectors (face normals, edge directions — not points),
   rotate them the SAME way but WITHOUT the pivot translation (pure
   rotation component only). A direction is not a point; translating it
   by the pivot offset is a real, separate mistake from skipping
   rotation entirely.
3. Build/verify the target point relative to this TRUE rotated-position
   geometry, in the frame where the constraint is natural to state.
4. Convert the result back to the body's native/closed frame via the
   project's own real closed-from-world rotation function — this
   "freezes" the point into the rigid body's own permanent shape,
   because the native frame is what the rest of the construction (spine
   points, bore holes, other geometry) is built in.
5. Result: at the rest/native angle, the frozen point sits wherever the
   rotation naturally carries it (often away from the real target — that
   is expected, not a defect); at the specific angle the constraint was
   built against, it lands exactly on the real target.

---

## RULE 2 — A NATIVE-FRAME POINT PASSED THROUGH THE ROTATION FUNCTION ANYWAY IS A REAL, SILENT BUG CLASS

The failure mode RULE 1 exists to prevent: building `Q = target_native +
offset_native` (entirely in native-frame numbers, zero real rotation
involved), then calling `closed_from_world(Q, angle)` on it anyway
because the surrounding code pattern expects a "world-frame input."
This applies a spurious, extra rotation the math was never supposed to
have — `Q` was never a world coordinate to begin with, so "converting"
it back out of a frame it was never in produces a number with no
physical meaning. This is easy to miss because the code still runs and
produces SOME number; only a real check against the frame where the
constraint should visibly be true (a render, or the RULE 3 coordinate
dump) reveals it's wrong.

The tell: if a "world-frame" quantity was built using ONLY native-frame
constants (no call to the world-from-closed rotation anywhere upstream
of it), it is not actually in world frame — do not pass it through the
closed-from-world conversion. Algebraically, correctly rotating a
native-frame reference AND its offset out to world frame and then back
again is an identity operation — it must reduce to the same native-frame
numbers you started with. If a "round trip" changes the numbers, the
input was never actually in the frame the round trip assumes.

---

## RULE 3 — VERIFY AGAINST A LIVE VALUE, NEVER A COMMENT OR A PRIOR WRITE-UP

Any number that depends on a live formula chain (a pivot position, a
level datum, anything computed from a project's own live constants) must
be re-verified with a real `echo()` against the CURRENT file before
being trusted — never carried forward from an inline comment, a prior
session's write-up, or this skill file's own worked example, once one
exists. Comments drift silently across rounds that touch an upstream
constant without updating every downstream comment that quotes its
result. See `docs/hinge-construction.md` Section 4.5 for a real, caught
instance of exactly this (a hinge doc's own numbers were stale by
exactly the amount an earlier level-drop round shifted a datum, because
they were computed from a comment instead of a live echo).

---

## VERIFICATION FOR THIS PATTERN SPECIFICALLY

- State the actual reference point BEFORE rotation, the rotation angle
  used, and the resulting point AFTER rotation — as plain numbers (same
  general discipline as `SKILL_joint_construction.md` RULE 3), not just
  "converted to world frame."
- Confirm the round-trip identity: rotate a locked point out to the
  other frame, then back, and verify you recover the exact original
  value — this is the same self-check already used for the physics
  moment-balance checks in this project's own BBQ counterbalance work.
- Re-derive any live-formula-dependent number fresh via `echo()`
  immediately before trusting it in a fix or a write-up — do not assume
  a number from an earlier point in the same session, let alone an
  earlier session, still matches the live file.
