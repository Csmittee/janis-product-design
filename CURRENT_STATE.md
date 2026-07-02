# CURRENT_STATE.md
# Janis Product Design — Where We Left Off
# Last updated: 2026-07-03 by cc (rapid amendment on top of PR #75)
#
# UPDATE TRIGGER — read this before touching this file:
# This file is updated ONLY when Janis explicitly confirms a pause is
# starting (on any single product line, or the whole project). That
# confirmation is the ONLY trigger — never update this file just because
# a session or task ended, that would turn it into a second log. When
# Janis confirms a pause, cc (or Claude Web, if drafting a handoff) MUST
# update this file immediately, before the pause is considered complete.
#
# FORMAT — deliberately NOT one rigid line per product. Each entry holds
# whatever it takes to reconstruct exactly where things were left,
# including unfinished threads, open questions, things started but not
# decided. Structure below is a floor, not a ceiling.
#
# For raw session-by-session history, see cc_chat_log.md.
# For known-and-DELIBERATELY-ACCEPTED issues, see .claude/rules-waivers.md.
# Anything unresolved/undecided lives HERE, not in rules-waivers.md — a
# waiver requires Janis's explicit accept, an open item here does not.

## Vending Machine (VM-01) — DONE, dormant
Active: VM-01-base-v36.scad | Last confirmed good: v36, PASS
No open items.

## Pilates Reformer (PR-01) — PAUSED, awaiting customer
Active (confirmed): PR-01-assembly-v31.scad — base-file-consolidation
(PR #74) merged, zero visual/dimensional change from v30 (CSG-dump
md5sum-identical), so v30's F5/F6 confirmation still stands for v31.

Open items (unresolved, not yet decided by Janis):
- Socket is NOT physically cut into the wood leg. `leg_socket()` draws the
  wood leg as one fully solid cube and the socket sleeve as a separate
  tube occupying the same space — no boolean difference removes wood to
  make room for the sleeve. Looks correct in a colored render, would not
  be physically manufacturable as-is (no real cavity exists in the model).
  Found 2026-07-03, QA'd by Janis, NOT YET decided whether to fix now or
  waive — do not treat as accepted until Janis says so explicitly.
- W-001 dormant global-override pattern (44 instances) — see
  .claude/rules-waivers.md, already a formal waiver, cross-referenced here
  for visibility.

Next if resumed: read WORKFLOW_SKILL.md session-open steps, then the most
recent CHAT_HANDOFF file for specific open items, then this file for
anything that predates the handoff.

## Vending Machine variants (Satu, VM-1.1, VM-1.2) — NOT STARTED
Queued, no files exist yet.

## BBQ Offset Smoker (3–4 model variants planned) — NOT STARTED
Queued, no files exist yet.
