CC PROMPT — bbq-governance-dual-endcap-convention
================================================================
Repo location: bbq-offset-smoker/rules-bbq-fab.md (append new section)

REVISION NOTE: docs-only, governance addition. Zero `.scad` files
touched. This locks in a standing architectural rule found necessary
during the v15 build review (real visible-hole/mismatched-passage
defects traced back to this convention being implicit rather than
written down) — the rule applies to ALL future BBQ firebox/chamber
work, not just this round, so it belongs in `rules-bbq-fab.md` next to
this file's other locked conventions (Standing Orientation Convention,
Regular Octagon Requirement), not in a single dated prompt that gets
archived and forgotten.

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

Task-specific reads:
1. bbq-offset-smoker/rules-bbq-fab.md — LIVE, in full. Confirm the
   real current section structure (Standing Orientation Convention,
   Regular Octagon Requirement, v1 Judgment Calls) so the new section
   is appended consistently with existing formatting/dating style.
2. .claude/RULES.md — confirm current rule numbering (highest live
   rule) in case this warrants its own R-number as a general
   documentation-discipline rule, separate from the BBQ-specific
   geometry convention (cc's own judgment call — state which you did
   and why).

## 2. CONTEXT

Real root cause this convention fixes: during the v15 square-shell/
cylinder-firebox round, the passage hole cut through the chamber wall
and the hole cut through the inner cylinder's own end cap were built
as two independently-derived shapes rather than one shared profile —
they didn't line up, producing a real visible defect (a second,
unintended hole/edge) that isn't caught by a single-shape containment
check. Separately, the outer shell's own end-cap construction was
built using a DIFFERENT prior fix (the flat/full-height "no material
below floor" convention, correct for the shell's SIDE WALLS) instead
of the two-zone octagon/entity-shape construction that this class of
end cap actually needs — a real conflation between two different past
fixes for two different parts of the same assembly.

Both are real, recurring architecture questions any future
firebox/chamber redesign will hit again (different fire-holding shape,
different outer shell shape, etc.) — writing the rule down once means
neither Claude Web's prompts nor cc's own judgment calls need to
re-derive or accidentally conflate this each time.

## 3. NEW FILES

None. Append to `rules-bbq-fab.md`.

## 4. TASKS

### TASK 1 — Add "Dual End-Cap Independence Convention" section

Append a new dated, locked section to `rules-bbq-fab.md`, formatted
consistently with this file's existing convention sections (see TASK-
SPECIFIC READS above for the real formatting to match). Content —
transcribe Janis's own stated rule precisely, do not paraphrase away
the specifics:

---
**Dual End-Cap Independence Convention (locked 2026-07-21)**

Every BBQ firebox/chamber assembly has TWO independent end-cap
partitions — the outer shell's own end cap, and the inner fire-holding
entity's own end cap (duct, cylinder, or whatever shape a future round
uses). They are built independently, do not share geometry, and a real
air gap exists between them (the same gap that forms the insulation
space along the assembly's side walls continues across the back, at
the end caps, too — not just the sides).

**Rule 1 — Outer shell end cap:** constrained to ONLY its own square/
cube projection (matching the outer shell's own cross-section) in
every zone EXCEPT the top part, which follows the chamber's own real
profile (octagon or whatever profile the chamber body uses — this
convention doesn't hardcode "octagon", it means "whatever
`true_octagon_profile()` or its future equivalent actually is"). This
end cap must tuck under the chamber body at a MINIMUM of 50mm. The
face is ONE CONTINUOUS SURFACE from the tuck zone down to the bottom —
no step, no zone-clipped transition between two differently-derived
shapes.

**Rule 2 — Inner (true firebox) end cap:** whatever its own shape
(circle, square, or any future entity shape), it attaches to the
chamber's own end-cap face. It does NOT influence, derive, or
re-shape the passage in any way — the passage is defined SOLELY by
the hole already cut through the chamber wall itself, and the inner
end cap must cut the EXACT SAME shared hole-profile, not an
independently-derived approximation of it. Above that shared cut, the
end cap's own top zone follows the chamber's real profile (same
"whatever the chamber's shape is" language as Rule 1); everywhere else,
it follows its own entity's real shape (circle for a cylinder, square/
rectangle for a duct, etc.).

**Why this exists**: found necessary during the v15 square-shell/
cylinder-firebox review — two independently-derived hole shapes on the
chamber wall vs. the inner cylinder's end cap produced a real
mismatched/visible defect; conflating this convention with the
separate "flat full-height side-wall" fix (a different, earlier
convention, for a different part of the assembly) produced a second,
distinct real defect on the outer shell's own end cap. This section
applies to ALL future BBQ firebox/chamber work — any prompt describing
a NEW fire-holding shape or a NEW outer shell shape must build both end
caps per this rule, not re-derive the relationship from scratch, and
must implement the passage/hole cut as ONE shared 2D profile module
reused across every surface it passes through (chamber wall, inner
end cap, and any other assembly it crosses) — never independently
re-derived per-surface.
---

### TASK 2 — Cross-reference in the standing docs

Add a one-line pointer to this new convention in whichever of
`design_scope_of_work_rule.md` / `SKELETON_WORKSHEET.md` already lists
this project's other locked conventions (Orientation, Regular Octagon)
— state which file you found that reference in and where you added
the pointer. If no such cross-reference list exists yet, state that
plainly rather than inventing one.

## 5. DO NOT TOUCH

- Every `.scad` file — zero geometry changes this round, docs only
- Existing content in `rules-bbq-fab.md` (Standing Orientation
  Convention, Regular Octagon Requirement, v1 Judgment Calls) — append
  only, do not reword or renumber anything already there

## 6. QA VERIFICATION

- [ ] New section appended to `rules-bbq-fab.md`, real content matches
      Janis's stated rule verbatim (both Rule 1 and Rule 2), dated,
      formatted consistent with the file's existing sections
- [ ] Cross-reference added (or absence stated plainly) per TASK 2
- [ ] Confirmed zero `.scad` files touched
- [ ] Confirmed zero existing rule content reworded/renumbered

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at top, under 10 lines: real
   section added, real file/line cross-reference location.
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map — governance addition, docs only (same pattern
   as the 2026-07-13 governance-inline-content-and-predelivery-check
   entry)
4. Commit → merge to main
