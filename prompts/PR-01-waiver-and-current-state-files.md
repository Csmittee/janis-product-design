# cc Prompt — New Files: rules-waivers.md + CURRENT_STATE.md
# Date: 2026-07-03
# Session goal: two new governance files, both documentation-only, zero
# .scad geometry change. Janis is pausing the project for an extended
# period and wants both in place before handoff.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 5 entries — includes both
the bed-height-pad-cutaway-fix and base-file-consolidation entries this
covers) → knowledge.map → .claude/rules-codes.md
State every file read before writing a single line.

## 2. CONTEXT

Two gaps found this session, during a pre-pause review:

1. No registry exists for issues that are known, discussed, and deliberately
   accepted as "not fixing this now" — like the 44 dormant global-override
   warnings found during base-file-consolidation (2026-07-03). Without a
   registry, every future session/cc run that stumbles on this has to either
   re-discover it from scratch or read back through 1000+ lines of
   cc_chat_log to confirm it's already known. Janis wants a "waiver" file:
   short, declarative, checked FIRST before treating a discovered issue as
   new.
2. No single current-state snapshot exists across Janis's product lines
   (vending machine, pilates reformer, more products queued). Reconstructing
   "what's actually active" requires reading scattered file header comments
   plus cc_chat_log archaeology. Janis wants one file, conclusions only, no
   history — overwritten each update, not appended to (cc_chat_log stays the
   append-only raw log; this is the opposite of that).

## 3. NEW FILES

### File 1: `.claude/rules-waivers.md`

```
# rules-waivers.md
# Janis Product Design — Accepted/Waived Issues Registry
# Version: 1.0 — 2026-07-03
# Location: .claude/rules-waivers.md
# Read by: Claude Web AND cc — check here FIRST when something looks broken
# or produces a warning. If it's declared here, it's already known,
# already assessed by Janis + chat, and deliberately deferred — do not
# re-flag it as new, do not re-litigate it, unless its own "Revisit if"
# condition is met.
# Cap: 200 lines. When full, move CLOSED waivers to
# .claude/rules-waivers-archive.md, keep OPEN waivers here only.

## WAIVER FORMAT
ID | Product | Date accepted | Status | What | Why accepted | Revisit if

---

## W-001 — Dormant global-override pattern

Product: PR-01 (Pilates Reformer)
Date accepted: 2026-07-03
Accepted by: Janis + Claude Web (base-file-consolidation session)
Status: OPEN — accepted as harmless today, not fixed

What: a self-referential standalone-default pattern
(`X = is_undef(X) ? default : X;`) silently discards the assembly's real
value for that variable when the file containing this line is `include`d
by the assembly — because the include-flattened "last assignment wins"
resolution makes the self-reference resolve as undefined, regardless of
any earlier same-named assignment. Confirmed via actual OpenSCAD compiler
WARNING output (not estimated): 44 instances total — 20 in pole_top.scad,
24 in leg_socket.scad (8 pre-existing + 16 bell-collar params added
2026-07-03). Full variable list logged in cc_chat_log, entry
"base-file-consolidation", 2026-07-03.

Why accepted: every fallback value currently equals the assembly's real
confirmed value — harmless today, confirmed via matching render checksums
before/after the base-file-consolidation change. This exact bug already
cost one real fix cycle (bed_h, 2026-07-02) when a value needed to
actually change — the fix pattern is known and proven (remove the
self-reassignment, use a file-local `ghost_*` name instead, scoped only to
where the file's own standalone ghost-preview needs it) but applying it to
all 44 at once is a dedicated audit task, not a side effect of unrelated
work — do not blanket-fix without Janis's explicit go-ahead.

Revisit if: (a) any future task needs one of these 44 values to actually
differ between the assembly and its module-file fallback — same trigger
that forced the bed_h fix, or (b) before any future extended project
pause, whichever comes first.
```

### File 2: `CURRENT_STATE.md` (repo root)

```
# CURRENT_STATE.md
# Janis Product Design — Portfolio Status
# Last updated: 2026-07-03 by cc (base-file-consolidation + waiver session)
# One entry per product line. CONCLUSIONS ONLY — no session history, no
# narrative. This file is overwritten at each update, never appended to.
# For raw session-by-session history, see cc_chat_log.md.
# For known-and-accepted issues, see .claude/rules-waivers.md.

## Vending Machine (VM-01) — DONE, dormant
Active: VM-01-base-v36.scad
Last confirmed good: v36, PASS
Open waivers: none
Next if resumed: n/a — complete, untouched, out of scope until re-raised

## Pilates Reformer (PR-01) — PAUSED, awaiting customer
Active (confirmed): PR-01-assembly-v30.scad
Last confirmed good render: v30, F5/F6 confirmed by Janis, 2026-07-03
Pending: base-file-consolidation-fix prompt sent to cc 2026-07-03 (moves
bell_lock_collar() from pole_top.scad to leg_socket.scad) — will become
v31 once merged and confirmed; do not assume merged without checking
git log / asking Janis, per REPO TRUTH rule.
Open waivers: W-001 (dormant global-override, 44 instances — see
.claude/rules-waivers.md)
Next if resumed: read WORKFLOW_SKILL.md session-open steps, then the most
recent CHAT_HANDOFF file for specific open items.

## Vending Machine variants (Satu, VM-1.1, VM-1.2) — NOT STARTED
Queued, no files exist yet.

## BBQ Offset Smoker (3–4 model variants planned) — NOT STARTED
Queued, no files exist yet.
```

## 4. TASKS

### TASK 1 — Create `.claude/rules-waivers.md`
Exact content as specified in section 3, File 1 above.

### TASK 2 — Create `CURRENT_STATE.md`
Exact content as specified in section 3, File 2 above, at repo root
(same level as knowledge.map, cc_rules.md).

### TASK 3 — Update `knowledge.map`
Add two rows:
```
| .claude/rules-waivers.md | .claude/ | Known/accepted issues registry — check FIRST before flagging something as new. Read by Claude Web AND cc. |
| CURRENT_STATE.md | / (repo root) | Portfolio-wide status snapshot, one entry per product, conclusions only. Overwritten each update, never appended. Read by Claude Web AND cc. |
```
Bump knowledge.map version and date.

### TASK 4 — Flag only, do NOT fix: `.claude/rules-codes.md` is oversized
It is currently 343 lines, over Janis's standing 200-line-per-file cap for
everything under `.claude/`. State this in cc_chat_log as a flagged open
item — do not split or edit rules-codes.md in this prompt, that is a
separate, dedicated task.

## 5. DO NOT TOUCH
- All `.scad` files — zero geometry change this prompt
- `.claude/rules-codes.md` — flag only per TASK 4, do not edit content
- `rules-dimensions.md`, `chat_rules.md`, `WORKFLOW_SKILL.md`, `cc_rules.md` — unrelated
- Do not backfill CURRENT_STATE.md with more product lines than the four
  specified above — if Janis has other products in mind, that's a future
  addition, not a guess to make now

## 6. QA VERIFICATION
- [ ] `.claude/rules-waivers.md` created, matches spec exactly, W-001 entry complete
- [ ] `CURRENT_STATE.md` created at repo root, matches spec exactly, both
      real entries + both stub entries present
- [ ] knowledge.map updated with both new rows, version bumped
- [ ] cc_chat_log states the rules-codes.md oversized flag explicitly
- [ ] Confirm explicitly in cc_chat_log: zero `.scad` files touched
- [ ] Both new files under the 200-line cap (rules-waivers.md) — confirm
      line count explicitly for rules-waivers.md in cc_chat_log

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — 2026-07-03
3. knowledge.map already updated in TASK 3
4. Bump version on all changed files (done above)
5. Commit all → merge to main
