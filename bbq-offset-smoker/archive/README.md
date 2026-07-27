# bbq-offset-smoker/archive/

Superseded `.scad` versions, moved here 2026-07-26 to keep the main
`bbq-offset-smoker/` folder small enough for Janis to sync into Claude
Web's project knowledge without excluding the governance `.md` files
that live alongside them.

**Nothing is lost — this is a visibility change, not a history change.**
Full history for every file (including files that lived here before
this move) is in git regardless of which folder a file currently sits
in. `git mv` was used for every move, so `git log --follow` on any
archived file still shows its complete history.

**What stays in the main folder (live/current, synced regularly):**
- The last 3 versions of each of the 3 file families: `BBQ-chambers-vN`,
  `BBQ-understructure-vN`, `BBQ-offset-smoker-base-vN` — kept for quick
  diffing against the immediately-prior round without opening this
  folder.
- All `.md` governance files (`PART_MANIFEST.md`, `SKELETON_WORKSHEET.md`,
  `design_scope_of_work_rule.md`, `rules-bbq-fab.md`).

**What moved here:** every version older than the last 3 of each family
(as of 2026-07-26: chambers v1-v23, understructure v1-v16, base v1-v7.2).

When a new version pushes a family past 3 live versions, move the
NOW-4th-oldest into this folder in the same round (`git mv`, not a
plain move, so history stays attached) — do not let the main folder
silently regrow past 3 per family.

Janis: uncheck this `archive/` folder when syncing project knowledge —
Claude Web essentially never needs raw `.scad` content directly (see
`chat_rules.md`'s "What Claude Web Never Does" — never writes SCAD,
never reads it beyond rare special-analysis requests), so excluding it
costs nothing day-to-day.
