## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in your
active context from earlier in THIS session, with no git pull/merge to
main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation —
  governance already current" and go straight to TASKS.
→ NO (new session/chat, first prompt of the day, or main changed since):
  FRESH. git fetch --all && git checkout main && git pull origin main.
  Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3 entries).
  State every file read before writing a line.

Before writing any fix (per R-009, RULES.md): confirm whether the
value/logic being changed exists in more than one place in the file (or
in any other file in the same part's module group) — state this check
explicitly in cc_chat_log, even if the answer is "no duplicates found."
If a duplicate is found, the fix must be applied to ALL copies in the
same pass, not just the one that triggered the bug report.

Claude Web override: none.

Task-specific reads (read these regardless of continuation/fresh):
- rules-dimensions.md (read only)
- RULES.md
- bbq-offset-smoker/rules-bbq-fab.md — specifically the "Three-Rib Lid
  Counterbalance System" convention (locked 2026-07-24) and the
  "Standing Orientation Convention" section (lid = Y<DATUM_Y_CENTER,
  fixed shell = Y>DATUM_Y_CENTER)
- bbq-offset-smoker/PART_MANIFEST.md
- docs/lid-hinge-counterbalance-calc.md
- prompts/archive/bbq-lid-hinge-three-rib-v2-cc-prompt ✅ COMPLETE — 2026-07-24.md
  (Section 3.5's UCP204-12 table and Section 4's construction-order
  rules — both still authoritative, unchanged by this prompt)
- bbq-offset-smoker/BBQ-offset-smoker-base-v6.1.scad (current source)
- bbq-offset-smoker/BBQ-chambers-v23.scad (current source)

## 2. CONTEXT

Janis reviewed the real v6.1 render (live OpenSCAD desktop) and found 3
real problems, root-caused this session against the actual v6.1 code —
not re-guessed:

**Problem 1 — `door_open_deg` moves the rib but not the lid.** The
mechanism relies on OpenSCAD's "last top-level assignment wins" rule:
`BBQ-offset-smoker-base-v6.1.scad` reassigns `lid_open_deg =
door_open_deg;` textually after the include chain, intending this to
override the chambers file's own default. This is fragile in practice
because `lid_open_deg` is ALSO a bare top-level assignment inside
`BBQ-chambers-v23.scad` — OpenSCAD's Customizer auto-detects every such
assignment across the full include tree and gives it its own exposed
control, and Customizer's own render pass injects a `-D` command-line
override for every variable it tracks. A `-D` override wins over any
in-file reassignment regardless of textual position. The result: the
base file's reassignment can be silently defeated by Customizer's own
default for the chambers-internal variable of the same name.

**Problem 2 — the axle/bearing pivot is mounted on the LID, not the
fixed shell.** `FC_Y`/`FC_Z` (the fulcrum the axle and both UCP204-12
pillow blocks are built from) are derived from `RIB_REF_C = [chamfer,
DATUM_Z_RIDGE]` — apex C. Per this project's own locked Standing
Orientation Convention, the lid occupies the Y<DATUM_Y_CENTER side and
the fixed shell occupies the Y>DATUM_Y_CENTER side. `chamfer` (~178.7mm)
is less than `DATUM_Y_CENTER` (~305mm, half of chamber_W=610mm) — apex C
sits on the LID's own half of the ridge, not the fixed half. This is why
the bearing housing renders embedded in the door: it is structurally
attached to the lid, not the fixed body. This also means the CB1
moment-balance derivation in `docs/lid-hinge-counterbalance-calc.md`
currently assumes a fixed pivot that isn't actually fixed — it is not
trustworthy until this is corrected.

Note: apex D (`RIB_REF_D = [chamber_W - chamfer, DATUM_Z_RIDGE]`) IS
provably on the fixed side (431.3mm > 305mm) and is already the
reference the CB1 branch is built from (170.8mm from apex D along the
D-E edge). Using D as the new pivot reference keeps the fixed pivot and
the fixed-side CB1 anchor on the same real structure, which the C-based
version did not achieve.

**Problem 3 — rib margin.** RIB0_X/RIB2_X currently sit 150mm in from
the lid's own end margins (LID_X0=100, LID_X1=815) — confirmed by
Janis's own read of the numbers (250-100=150, 815-665=150). Too far in
from the edge; Janis wants 100mm.

## 3. NEW FILES

- `bbq-offset-smoker/BBQ-offset-smoker-base-v7.scad` (new, source v6.1)
- `bbq-offset-smoker/BBQ-chambers-v24.scad` (new, source v23)
- `bbq-offset-smoker/BBQ-understructure-v17.scad` (new, source v16 —
  pure pointer-only bump, same pattern as the v15→v16 chain-break fix:
  v16's own `include` currently points at chambers-v23 directly; if
  chambers bumps to v24, v16 must bump to v17 so v24 is actually the one
  in the real render chain, or v24 will be committed but silently
  orphaned, same failure class this project has already hit twice)

Add all 3 to knowledge.map.

## 4. TASKS

### TASK 1 — Fix the door/lid sync so `door_open_deg` drives both

Root cause per Section 2, Problem 1. Do not re-attempt the
reassignment-after-include trick — replace it with an explicit parameter
pass so there is no second top-level variable for Customizer to
independently pin:

- In `BBQ-chambers-v24.scad`: find `lid_open_deg`'s own top-level
  default declaration and its use in `if (show_lid) ... lid(lid_open_deg);`.
  Do NOT delete the default (chambers must still render standalone on
  its own, per this project's existing convention — confirm this by
  re-reading how other kinetic parameters in this file already work
  standalone). Move `lid_open_deg`'s declaration into a `/* [Hidden] */`
  Customizer group (OpenSCAD's own recognized syntax for excluding a
  variable from the Customizer UI/override list) so Customizer no longer
  auto-generates a competing control or `-D` override for it.
- Confirm `BBQ-offset-smoker-base-v7.scad`'s own `lid_open_deg =
  door_open_deg;` reassignment (still textually after the include chain)
  is now the only real driver reaching the chambers file's `lid()` call.
- R-009 duplication check: search the full include tree for any OTHER
  top-level assignment to `lid_open_deg` (not just the two known ones)
  before declaring this done.

### TASK 2 — Move the axle/bearing pivot off the lid, onto the fixed side

Root cause per Section 2, Problem 2. Rebuild `FC_Y`/`FC_Z` from
`RIB_REF_D` instead of `RIB_REF_C`:

- `FC_Y = RIB_REF_D[0] - 15` (same 15mm-along-the-ridge offset concept
  as the old C-based formula, now measured inward from D toward C —
  confirm the result is still comfortably on the fixed side, i.e.
  provably > DATUM_Y_CENTER with real margin, not just barely past it —
  state the actual margin).
- `FC_Z = RIB_REF_D[1] + 33.3` (UCP204-12's real H dimension, UNCHANGED
  value — the table in the archived source prompt, Section 3.5, is
  still authoritative: bore 3/4", H=33.3mm, L=127mm, J=95mm, A=38mm,
  bolt M10, weight 0.7kg — do not re-derive, this part spec did not
  change, only its mounting location did).
- This is a structural relocation, not a coordinate tweak: the rib
  spine connecting the door-side arm (anchored at the real parting line,
  per the v6.1 fix) through the new fixed pivot to the CB1 branch (still
  anchored at apex D, UNCHANGED) must be re-verified, not assumed
  correct by analogy to the old C-based geometry. Apply the same
  Construction Order discipline as the original build (archived prompt
  Section 4): fixed references first, door-side arm swept and confirmed
  clear BEFORE the CB-side connection is redrawn.
- Re-run the apex-D corner clearance check (rules-bbq-fab.md's own
  "Apex/corner clearance rule" — minimum 20mm real clearance, worst
  case, full 0-90° sweep, fine steps) now that the pivot itself sits
  much closer to D than before — do not assume the existing 45mm-radius
  arc fix is still sufficient without re-checking.

### TASK 3 — Reduce rib margin from 150mm to 100mm

- `RIB0_X = LID_X0 + 100` (200mm)
- `RIB2_X = LID_X1 - 100` (715mm)
- `RIB1_X` formula unchanged (stays the midpoint)
- Re-run the rib-vs-tray interference sweep (full `door_open_deg` ×
  tray-angle combinatorial space, same method as the original v6 build)
  at these NEW positions — do not assume it is still a FAIL matching the
  original 150mm finding, or still clear; check fresh at the new X
  values, since geometry has shifted from the state that finding was
  based on.

## 5. DO NOT TOUCH

- `rules-dimensions.md` — read only
- CB1 pipe's own absolute position formula (`cb1_pipe_center_open`,
  170.8mm from apex D along the D-E edge) and its mass/no-fill-weight
  spec — Janis has explicitly deferred CB1/stopper visual review until
  the door can be opened; do not recompute or re-tune this
- The U-prong stopper/holder construction
- `HANDLE_Y`/`HANDLE_Z` (already corrected in v6.1, unchanged this round)
- All other `.scad` files not listed in Section 3
- Any content in `BBQ-chambers-v24.scad` beyond the `lid_open_deg`
  Customizer-visibility change in TASK 1 — everything else must remain
  byte-identical to v23 (confirm via diff before committing, same
  discipline as the v22→v23 R-009 retirement)

## 6. QA VERIFICATION

- Customizer panel check: confirm only ONE control drives door/lid
  motion (`door_open_deg`) — no separate `lid_open_deg` slider visible
  anywhere in the panel (any tab/group)
- No OpenSCAD/CGAL binary available in this execution environment
  (state this explicitly, same as prior rounds) — verify analytically:
  simulate the variable-resolution chain in Python/logic trace to
  confirm `lid_open_deg` has exactly one real top-level assignment
  reaching the render (the base file's), and flag if this can't be
  fully confirmed without a live Customizer render — if so, say so
  plainly rather than asserting it's fixed
- Confirm new `FC_Y` value is > `DATUM_Y_CENTER` with real numeric
  margin stated (not just "greater than")
- Real sweep: apex-D clearance, full 0-90° `door_open_deg`, fine steps,
  minimum 20mm net clearance — report the actual worst-case number
- Real sweep: rib0/rib2 (at new X=200/717.5mm) vs prep trays, full
  `door_open_deg` × tray-angle combinatorial space — report PASS or FAIL
  explicitly, per this project's Verification Discipline Rule; do not
  report "clear" if it isn't
- `HANDLE_Y`/`HANDLE_Z` are fixed at global-origin coordinates and are
  NOT derived from `FC_Y`/`FC_Z` — confirm the handle's own world
  position is unchanged by this prompt. What DOES need rebuilding is the
  rib spine's own path from the relocated pivot out to that fixed handle
  point (part of the Task 2 re-sweep, not a separate handle change).
  `R_HANDLE` (handle-to-pivot radius) will change as a pure consequence
  of the pivot moving — state the new value, and flag that the calc
  doc's force curve is stale again (same class of flag as the v6.1
  `HANDLE_Y` change) — do not recompute the physics this round since
  CB1/stopper review is still deferred
- Confirm CB1 pipe geometry and U-prong stopper are UNCHANGED from v6.1
  (diff or explicit statement)
- No undefined-variable warnings
- Version incremented on all 3 files — never overwrite

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map (3 new files)
4. Bump version on all changed files (PART_MANIFEST.md,
   SKELETON_WORKSHEET.md, docs/lid-hinge-counterbalance-calc.md if the
   pivot relocation affects any stated value there)
5. Commit all → merge to main
