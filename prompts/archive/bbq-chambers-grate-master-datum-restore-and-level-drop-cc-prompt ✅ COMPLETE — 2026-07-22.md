CC PROMPT — bbq-chambers-grate-master-datum-restore-and-level-drop
================================================================
Repo location: bbq-offset-smoker/BBQ-chambers-v22.scad (new, source v21)

REVISION NOTE: TWO real changes, in this order, in one round because
the second depends on the first being real, not assumed. (1) Restore
the grate as the project's actual master/reference datum — per Janis's
own explicit statement, this is how the original Skeleton file/scope of
work always intended it; a prior session temporarily inverted this
(pinned the grate as an independent fixed literal, pushed apex A down
to compensate) as a workaround under time pressure, and that workaround
is being undone now, not re-litigated as a new design question. (2)
Apply a real −100mm level drop to the ENTIRE chamber+firebox assembly —
grate moves 1000→900mm, apex A recomputes to 850mm via the restored
live formula (NOT typed in as a separate literal). Zero shape/dimension
geometry changes anywhere — this is a pure Z-translation of the whole
assembly, absorbed entirely by the understructure's support poles in a
companion prompt.

## 1. CC INTRO

Session continuity check (cc self-determines):
Are cc_rules.md, knowledge.map, and cc_chat_log.md already loaded in
your active context from earlier in THIS session, with no git
pull/merge to main since?
→ YES: CONTINUATION. Skip re-reading those three. State "Continuation —
  governance already current" and go straight to TASKS.
→ NO: FRESH. `git fetch --all && git checkout main && git pull origin
  main`. Read cc_rules.md → knowledge.map → cc_chat_log.md (first 3
  entries). State every file read before writing a line.

Claude Web override: none

Per R-014: state the SPECIFIC real check performed for every QA item,
not a generic "confirmed working."

**MANDATORY FIRST CHECK — do not assume, read the real live code**:
- State the REAL current definition of `GRATE_Z_FIXED` (or whatever its
  actual current variable name is) — is it a hardcoded literal (expect
  1000) or a formula? State it verbatim from the file.
- State the REAL current definition of apex A / `apex_A` — is it a
  hardcoded literal (expect 950, from the prior workaround) or a
  formula? State it verbatim.
- List EVERY real consumer of both values across the file (grep, don't
  guess) — `chamber_floor_z`, `chamfer`-derived values, the lid/fixed
  parting-line boundary (Z=1000 per the last round), the tray hinge
  mount reference (Z=980, defined in the base file but reads a chambers
  datum — confirm which one), firebox floor/wall values, anything else
  that reads either value. State the real, current list — this list
  determines what TASK 2 actually verifies.

## 2. CONTEXT

Real relationship being restored (Janis's own explicit statement, this
session): the grate is the project's actual master/reference datum, per
the original Skeleton file and scope of work — apex A was always meant
to be DERIVED from the grate, not independently set. A prior session
inverted this under pressure (pinned grate fixed, pushed apex A to
compensate) as a temporary workaround, now being undone.

Real numbers:
- Grate Z (master, going forward): stays 1000mm for now (TASK 1 is a
  pure re-wiring, not a value change) — TASK 2 then moves it to 900mm
- Apex A (derived, going forward): `apex_A = grate_Z − 50` — currently
  950 (1000−50), recomputes to 850 once TASK 2 changes grate_Z to 900
- The 50mm relationship itself is unchanged — only which variable is
  master and which is derived flips back to original intent

## 3. NEW FILES

None. New `BBQ-chambers-v22.scad` (source v21).

## 4. TASK 1 — Restore grate as master datum, apex A as derived formula

Change the grate's own Z value from a hardcoded literal to the real
master variable (e.g. `GRATE_Z = 1000` as a plain top-level constant,
name TBD by whatever this file's own convention is — state your real
chosen name). Change apex A's definition from a hardcoded literal to a
live formula: `apex_A = GRATE_Z - 50`.

Re-point EVERY real consumer found in the Mandatory First Check above
to read from whichever variable (grate or apex A) it should logically
depend on — do NOT leave any consumer holding a stale hardcoded copy of
either value. State each consumer's real before/after wiring explicitly
in your response (this is the list that must be complete for TASK 2 to
be trustworthy).

**Mandatory real check**: full render at CURRENT values (grate=1000,
apex_A=950 via the new formula) — confirm PIXEL-IDENTICAL to v21's own
render. This proves the re-wiring is truly a no-op at current values,
not an accidental geometry change disguised as a datum restore.

## 5. TASK 2 — Apply the −100mm level drop

Change `GRATE_Z` from 1000 to 900. Confirm `apex_A` recomputes to 850
automatically via TASK 1's formula (do not set it separately). State
the real, live-recomputed value of every consumer identified in the
Mandatory First Check — every one of them should now reflect the drop
without any additional manual edit, since TASK 1 wired them to follow
the master.

If ANY consumer does NOT automatically follow (i.e. still shows its old
Z value after the change) — STOP, do not patch it with a one-off fix,
state which consumer failed and why, so the real wiring gap can be
identified rather than silently patched over.

Zero shape, dimension, wall-thickness, or profile geometry changes
anywhere in this file — this task is a pure Z-translation of the whole
assembly (chamber body, firebox, lid, grate, door, fixed band, tray
hinge reference) achieved entirely through the master-datum formula
chain, not by editing individual module geometry.

**Mandatory real checks, each with its specific probe (per R-014)**:
- Full assembly render at the new values — `Simple: yes`
- Real measurement confirming the ENTIRE assembly (every named part:
  chamber shell, firebox, lid, grate, fixed band) shifted by exactly
  −100mm in world Z, with zero shape distortion — compare a real
  bounding-box/vertex check against v21's own geometry, offset by
  exactly 100mm, not just "looks lower"
- Full kinetic sweep (lid open/close, door, tray angles) re-verified
  `Simple: yes` at the new elevation — same relative geometry, just
  100mm lower, confirm no new collision was introduced against
  anything still fixed in world space (there shouldn't be any at this
  stage — understructure absorbs the shift in a companion round — but
  confirm rather than assume)

## 6. DO NOT TOUCH

- Any shape, profile, wall thickness, or dimension value — this round
  changes Z position only, via the master-datum formula chain
- `BBQ-understructure-v13.scad`, `BBQ-offset-smoker-base-v3.scad` — out
  of scope, a companion round handles understructure's own absorption
  of this shift
- The 50mm grate/apex-A relationship itself, and the 50mm fixed-band /
  980mm hinge-mount relationships from the prior parting-line round —
  unchanged, only re-expressed through the restored master datum

## 7. QA VERIFICATION

- [ ] Mandatory First Check: real current wiring of GRATE_Z_FIXED/apex_A
      stated verbatim, real consumer list stated
- [ ] TASK 1: real re-wiring confirmed, full consumer list re-pointed,
      render confirmed pixel-identical to v21 at current values
- [ ] TASK 2: real drop applied via GRATE_Z only, apex_A confirmed
      auto-recomputed to 850, every consumer confirmed following (or
      explicitly flagged if one didn't), zero shape changes confirmed
      via real measurement
- [ ] Full CGAL manifold sweep, `Simple: yes`
- [ ] Full kinetic sweep at new elevation, `Simple: yes` throughout
- [ ] Screenshots: iso/front/side/rear at new elevation, one
      side-by-side-style note comparing new vs. v21's old position
- [ ] Error-Log clean

## 8. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: state
   plainly this restores grate as master datum (real prior-session
   workaround being undone, not new design) and applies the real
   −100mm drop, list real before/after values.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map, PART_MANIFEST.md, SKELETON_WORKSHEET.md — Part
   A's own master reference point entry corrected back to grate (state
   this explicitly as a correction, not a new decision), real new Z
   values throughout
4. Update `bbq-offset-smoker/design_scope_of_work_rule.md` if it states
   apex A as the reference anywhere — correct to grate
5. Save as BBQ-chambers-v22.scad (v21 kept, unmodified, on record)
6. Commit all → merge to main
