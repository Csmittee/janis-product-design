# Hinge Construction — Locked Reference (BBQ Offset Smoker)
> Version 1.2 — 2026-07-25
> Changes: REAL BUG FIX — Sections 3/4/6 stated `HINGE_PIVOT_Z`=
> 1445.335mm and the corrected CB1 value as (598.64, 1307.09), both
> wrong by exactly +100mm in Z. Root cause: derived from a stale inline
> comment (`GRATE_Z`=1000) instead of a live `echo()` — real live value
> is `GRATE_Z`=900 (a real -100mm level-drop from an earlier round, v22
> TASK 2, that other comments in the chambers file never got updated to
> match either). Caught by cross-checking an independent claim against a
> fresh live echo, not by re-reading more carefully. Corrected values:
> `HINGE_PIVOT_Z`=1345.34mm, CB1 closed-frame=(598.64, 1207.09). New
> Section 4.5 documents the mistake itself as a real, standing lesson
> (verify against live echo, never a comment or a prior write-up,
> including this one). The `.scad` CODE itself was never wrong (all live
> formula references) — only this doc's own written numbers were.
> Previous: 1.1 — 2026-07-25
> Changes: new file. Extracted from the bbq-lid-hinge-v9/v10 direct-cc
> session so the two real, hard-won, CONFIRMED-CORRECT results of that
> session survive a context reload — separate from the rib construction,
> which is explicitly NOT locked (Section 5). Written per Janis's own
> explicit instruction: document what's confirmed correct now, before
> continuing, so auto-renewed context can't regress into old reasoning.

**Status: Sections 1-4 are LOCKED — confirmed correct, do not re-derive
from scratch. Section 5 is an open problem, not a reference.**

---

## 1. The problem this doc's fix solves

Two rigid bodies (the lid shell, and the rib assembly welded to it) that
must move together as ONE unit, but are built/rotated as two separate
pieces of code, will drift apart at every angle except whichever one was
hand-tuned — because rotating two bodies by the same angle about TWO
DIFFERENT centers is not the same motion. This was the root, structural
cause of the entire bbq-lid-hinge-v8 "rib sinks into / floats above the
door" saga (5 real passes, all failed, each one re-tuning offsets that
were never the actual problem).

## 2. The fix — one real shared rotation center

`BBQ-chambers-v26.scad` introduced `HINGE_PIVOT_Y` / `HINGE_PIVOT_Z` —
the ONE real source of truth for the lid's pivot, read live by BOTH:
- `lid()`'s own rotation point (chambers file), and
- the rib assembly's `FC_Y` / `FC_Z` (base file).

With a shared center, the rib and the lid's relative geometry is
identical at every `door_open_deg` angle BY CONSTRUCTION — this retires
the whole class of angle-dependent sink/float bugs. It does NOT
automatically make the rib safe from the FIXED structure (see Section 5
— that is a separate, still-open concern).

## 3. The real hinge location (Janis's own hands-on numbers, final)

- **The "end margin zone"**: the region outside the door's own real
  operating length (`X < LID_X0` or `X > LID_X1`, currently 100/815mm)
  has NO door at all — the CD-face cross-section is fixed material
  regardless of Y or Z there. A pivot bracket mounted at an X inside this
  zone can sit its Y EXACTLY on the fixed/lid parting line
  (`RIDGE_SPLIT_Y`) with zero safety gap — unlike anywhere inside the
  door's own real X-span, where a gap is mandatory.
- Real UCP204-12 pillow-block numbers (3/4" bore), Janis's own literal
  spec, not re-derived: `L`=127mm (foot width in Y, centered on the
  pivot), `A`=38mm (foot width in X), `H0`=64mm (pivot rise above the
  ridge). Bracket's near edge sits 25mm from `LID_X0`/`LID_X1`.
- Resulting constants (`BBQ-chambers-v26.scad`), READ LIVE, not
  hardcoded (see the Section 4.5 warning below for why this matters):
  - `HINGE_PIVOT_Y = RIDGE_SPLIT_Y = chamfer + 64` = 242.665mm (does not
    depend on `GRATE_Z`, safe to quote as a literal)
  - `HINGE_PIVOT_Z = DATUM_Z_RIDGE + 64` — DOES depend on `GRATE_Z`
    (via `chamber_floor_z`/`DATUM_Z_RIDGE`). Currently (`GRATE_Z`=900)
    this is **1345.34mm** — NOT 1445.335mm (that number came from a
    stale assumption `GRATE_Z`=1000; see 4.5). Always confirm this one
    with a live `echo()`, never quote it from memory or from an old
    inline comment.
- Real bonus finding: apex B, apex C, and the pivot are EXACTLY
  collinear (same 45° line as the B-C wall's own chamfer) — a
  regular-octagon-construction coincidence, not assumed.

## 4. The "open-then-freeze" construction method

This is the METHOD, generalized — confirmed correct today
(2026-07-25) by catching a real bug with it (Section 5's own history).
Use this for ANY point on the rib that needs to be positioned relative
to a real physical target on the door/lid surface:

1. Rotate the relevant reference point(s) to their TRUE OPEN-state world
   position using `rib_world_from_closed(pt, deg)` — do NOT reuse a
   native/closed-frame point and just relabel it "open."
2. For DIRECTION vectors (not points), rotate them the SAME way but
   WITHOUT the pivot translation (pure rotation component only).
3. Build/verify the target point relative to this TRUE open-state
   geometry — e.g., "parallel to the real open DE face, standing off it
   by a real air gap" is easy to state and check correctly ONLY in this
   frame, because that's the frame where the physical constraint is
   actually true.
4. Convert the result back to native/closed frame via
   `rib_closed_from_world(pt, deg)` — this "freezes" the point into the
   rigid rib body's own permanent shape.
5. Result: at door_open_deg=0 the frozen point swings up/away with the
   rest of the rib; at door_open_deg=90 it lands exactly back at the
   real open-state target you built it against.

**Real bug this method just caught (2026-07-25, not yet fixed in code):**
the CB1 counterbalance pipe's position (`CB1_OPEN`, unchanged since v6,
always marked "LOCKED — do not recompute") was built by taking the
NATIVE-frame apex D and NATIVE-frame `DE_DIR`/`DE_NORM`, using them
directly (i.e., already in closed-frame numbers), then passing that
result through `rib_closed_from_world(..., 90)` as if it were a genuine
open-world coordinate. That applies an extra, spurious rotation the
math was never supposed to have. Algebraically this makes the old
formula's real closed-frame result equal
`rib_closed_from_world(D_native + offsets, 90)`, NOT simply
`D_native + offsets` — and numerically, evaluated against the CURRENT
live constants (`GRATE_Z`=900), it lands CB1 at closed-frame
**(380.9, 1701.3)**, which is physically wrong (about 360mm floating in
the air above the ridge, nowhere near the door).

The CORRECT value, worked out via the real open-then-freeze method
above and confirmed against LIVE constants (`GRATE_Z`=900,
`DATUM_Z_RIDGE`=1281.34): closed-frame **(598.64, 1207.09)**. This is
simply the naive native-frame formula
(`RIB_REF_D + CB1_EDGE_DIST*DE_DIR + CB1_STANDOFF*DE_NORM`) evaluated
directly with NO extra rotation applied — the open-world round trip,
done correctly, algebraically cancels back to exactly that. **This
correct value has NOT yet been written into any `.scad` file** — this
doc records the confirmed-correct math; the code fix is a pending task
(see `cc_chat_log.md`, 2026-07-25 entry).

## 4.5. A real mistake THIS doc itself made — verify against live echo, never a comment

This doc's own first draft stated `HINGE_PIVOT_Z`=1445.335mm and the
corrected CB1 value as (598.64, 1307.09) — BOTH WRONG by exactly
+100mm in Z. Root cause: the Python side-checks used to derive those
numbers assumed `APEX_A_Z`=950 (`GRATE_Z`=1000), copied from a STALE
INLINE COMMENT in `BBQ-chambers-v26.scad` (e.g. `// 950mm at current
GRATE_Z=1000`) instead of an actual live `echo()` of the running file.
The real live value is `GRATE_Z`=900 (`chamber_floor_z`=671.335,
`DATUM_Z_RIDGE`=1281.34) — a real -100mm level-drop from an earlier
round (v22 TASK 2) that several OTHER inline comments in the same file
never got updated to reflect either.

**This mistake was caught by cross-checking a claim from a completely
independent source (another cc/chat session working from this same
doc) against a fresh live `echo()` — not by re-reading the comments more
carefully.** The general lesson (also see `RULES.md` R-014,
Verification Discipline): a `.scad` file's own inline comments are
DOCUMENTATION, not a source of truth — they drift, silently, across
rounds that touch an upstream constant (`GRATE_Z` here) without
re-checking every downstream comment. Any number quoted in THIS doc (or
anywhere else) that depends on a live formula chain must be re-verified
with a real `echo()` against the CURRENT file before being trusted,
every time context reloads or a session resumes — never carried forward
from a prior write-up, including this one.

Importantly: the actual `.scad` CODE was never wrong — `FC_Z =
HINGE_PIVOT_Z;` and `RIB_REF_D = [chamber_W - chamfer,
DATUM_Z_RIDGE];` are live references, so real renders (the v9/v10
screenshots already sent to Janis) always computed the correct live
geometry regardless of this doc's own stale prose. Only the WRITTEN
numbers in this doc, `cc_chat_log.md`, and `CURRENT_STATE.md` were
wrong — all now corrected.

## 5. What is NOT locked — do not treat as reference

The rib's own door-side spine construction, as it exists in
`BBQ-offset-smoker-base-v9.scad`/`v10.scad` today (`RIB_SPLIT_PT`,
`RIB_B_OFFSET`, `SPLIT_STANDOFF`, `B_STANDOFF`, the `miter_point()` call
at apex B), is flagged STALE this round — Janis's own words: "still look
like old copy and refer to something that not relevant." It was built by
re-deriving placeholder standoff offsets from scratch rather than
directly tracing the REAL lid panel shape that already exists in
`BBQ-chambers-v26.scad` (see `lid_profile()` — currently an unused
reference-only module — and `fixed_side_wedge()`/`lid_side_wedge()`,
which encode the real fixed/lid split polygons). The planned real fix:
copy the actual door shape from the ridge down to the AB wall directly,
connect that to the handle, and remove the old placeholder-offset
points entirely — not yet done. Do NOT copy today's rib spine
construction into a future product line as a pattern; it is scheduled
for a full rebuild, not a proven convention.

Also NOT yet re-examined: whether the door-side rib (built near apex
B/C, which are on the FIXED side of `RIDGE_SPLIT_Y`, unlike apex D which
is lid-side) needs a genuine angle-sweep clearance check against the
fixed structure — Section 2's shared-pivot fix only guarantees rib-vs-
LID-surface consistency across the sweep, NOT rib-vs-FIXED-structure
consistency, since the fixed structure doesn't rotate at all. This is a
real, separate, still-open question, flagged here so it isn't lost.

## 6. Concrete rebuild checklist (delete vs. keep)

Confirmed with Janis 2026-07-25, after this doc's first draft — written
here explicitly so it doesn't depend on that chat turn being remembered:

**DELETE (both are re-derived guesswork, not real geometry):**
- Door side: `RIB_SPLIT_PT`, `RIB_B_OFFSET`, `SPLIT_STANDOFF`,
  `B_STANDOFF`, and the `miter_point()` CALL at apex B (the function
  itself is fine — see KEEP below).
- CB1/hinge side: the current `CB1_OPEN`/`CONTACT_OPEN` formula (the one
  with the rotation bug, Section 4), and the `RIDGE_HOVER`/`D_HOVER` link
  points built on top of it in `v10.scad`.

**KEEP (locked, real, do not re-derive):**
- `HINGE_PIVOT_Y`/`HINGE_PIVOT_Z` and `FC_Y`/`FC_Z` — the shared pivot
  itself (Sections 2-3).
- The real octagon reference points (`RIB_REF_B`, `RIB_REF_C`,
  `RIB_REF_D`, `RIB_REF_E`) — real chamber geometry, not placeholders;
  the new rib traces FROM these, it doesn't replace them.
- The `miter_point()` FUNCTION — a correct, reusable formula. Re-apply
  it to the real traced shape instead of arbitrary offset points.
- The corrected CB1 value from Section 4 (598.64, 1207.09 — verify
  against a live `echo()` before using, per Section 4.5) — this
  replaces the deleted formula's output, derived via the open-then-
  freeze method, not re-guessed.

Net effect: this is not "start from zero" — it's "delete the two
guessed constructions, keep the two locked reference systems (the pivot,
and the chamber's own real geometry), rebuild the rib as a direct trace
between them."

## References

- `BBQ-chambers-v26.scad` — `HINGE_PIVOT_Y`/`HINGE_PIVOT_Z`, `lid()`
- `BBQ-offset-smoker-base-v9.scad` — `FC_Y`/`FC_Z`, the shared-pivot consumer (last CLEAN/committed version)
- `BBQ-offset-smoker-base-v10.scad` — WIP, uncommitted-as-final, CB1 fix from Section 4 not yet applied, rib spine still the stale Section-5 construction
- `docs/lid-hinge-counterbalance-calc.md` Section 15 — the shared-pivot narrative, full detail
- `cc_chat_log.md`, 2026-07-25 entries — the CB1 bug discovery and the rib-rebuild decision, full detail
- `rules-bbq-fab.md` — locked lessons list (shared rotation center, end margin zone)
