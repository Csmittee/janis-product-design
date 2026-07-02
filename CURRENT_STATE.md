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
Active (confirmed): PR-01-assembly-v31.scad
Last confirmed good render: v30, F5/F6 confirmed by Janis, 2026-07-03.
base-file-consolidation-fix (moves bell_lock_collar() from pole_top.scad
to leg_socket.scad) is MERGED as of this file's creation — verified via
git log directly (v31 present in main, PR #74 merged), per REPO TRUTH
rule; zero visual/dimensional change from v30 (CSG-dump md5sum-identical),
so v30's F5/F6 confirmation still stands for v31's actual geometry.
Open waivers: W-001 (dormant global-override, 44 instances — see
.claude/rules-waivers.md)
Next if resumed: read WORKFLOW_SKILL.md session-open steps, then the most
recent CHAT_HANDOFF file for specific open items.

## Vending Machine variants (Satu, VM-1.1, VM-1.2) — NOT STARTED
Queued, no files exist yet.

## BBQ Offset Smoker (3–4 model variants planned) — NOT STARTED
Queued, no files exist yet.
