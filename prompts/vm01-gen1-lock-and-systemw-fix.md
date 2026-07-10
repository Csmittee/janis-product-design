# cc Prompt — VM-01 Generation-1 Lock + system_w Governance Fix
# Date: 2026-07-09
# Session goal: docs/governance only. Zero .scad geometry changes.

## 1. CC INTRO

git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → rules-dimensions.md (in full) → CURRENT_STATE.md (in full) →
VM-01-base-v58.scad's own PARAMETERS block (confirm system_w's live
value before touching anything). State every file read before editing.

## 2. CONTEXT

Two owner (Janis) decisions from the 2026-07-09 planning session, direct
from Janis, not inferred:

1. **VM-01 is now locked as Generation 1 — final design.** v58 is the
   version going to the supplier (China) for a prototype build quote.
   No further structural/geometry changes expected on this generation
   unless something comes back from the physical prototype or firmware
   integration. This needs a clear, visible marker so a future session
   doesn't assume VM-01 is still mid-iteration.

2. **`system_w` is explicitly UNLOCKED — no restriction on machine
   width/height going forward, confirmed by Janis.** Separately, and
   regardless of the unlock: `rules-dimensions.md` currently documents
   `system_w` as 185mm in three places, but the live v58 code has used
   204mm since at least v44 (self-confirmed via v58's own `dash_w`
   sanity-check comment: `system_w - divider_t - (skin_t*2) = 204-19-4 =
   181mm ✓`). The doc was stale independent of today's unlock decision —
   both issues get fixed in this same pass.

## 3. NEW FILES

None. Docs-only edits to `rules-dimensions.md` and `CURRENT_STATE.md`.

## 4. TASKS

### TASK 1 — Lock VM-01 as Generation 1

In `CURRENT_STATE.md`, add a clear status marker for VM-01 (exact
placement/formatting at cc's discretion, matching this file's existing
conventions) stating:
- VM-01 — GENERATION 1 LOCKED, v58, 2026-07-09
- Sent to supplier (China) for prototype fabrication quote
- Construction reference drawing (5-page PDF, front/side/top/iso +
  tray/drop-zone/door/dashboard/back-door detail) delivered to Janis
  same session
- No further structural/geometry changes expected on this generation
  unless prompted by physical-prototype feedback or firmware
  integration — a future session proposing a geometry change here
  should treat that as a deliberate exception, not routine iteration

### TASK 2 — Fix `system_w` in `rules-dimensions.md`

Update ALL of the following (confirmed exact current locations —
re-verify line numbers against the live file since they may have
shifted, don't assume these are still exact):

1. **OWNER-LOCKED DIMENSIONS table** — the row
   `| system_w | 185mm | Drives total_w — cannot change without screen
   layout change |`
   → REMOVE this row entirely (not just correct the value). Janis has
   explicitly stated no restriction on machine width/height — this
   dimension is no longer owner-locked. Do not silently update it to
   204mm and leave it in the locked table; that would misrepresent
   today's actual decision.

2. **VM-01 Base — Compartments table** — the row
   `| System zone width | 185mm | Right compartment |`
   → update value to `204mm`. Add a short note this is current as of
   v58, confirmed against live code, not independently re-derived.

3. **VM-01 Base — Dashboard table** — the row
   `| Total width | ~160mm | system_w - divider_t - (skin_t x 2) |`
   → recompute with the corrected value: 204 - 19 - 4 = **181mm**.
   Update both the number and keep the formula note.

4. **PENDING DESIGN DECISIONS table** — the row
   `| system_w reduction | If portrait confirmed: 185→168mm, total_w
   620→603mm | After firmware decision |`
   → this row's baseline (185mm system_w, 620mm total_w) is now stale
   on TWO counts: the system_w correction above, AND total_w is 640mm
   in live v58 (not 620mm — unrelated pre-existing drift, confirm this
   too against the live file rather than assuming). Update the baseline
   numbers so this pending decision is evaluated against the real
   current values if/when firmware confirms portrait mode. Do not
   delete this row — it's a genuine open item, just needs a correct
   starting baseline.

Leave every other OWNER-LOCKED row untouched (spring_gap, spring_od,
motor_d, total_h, tray_h, exit_door_h, motor position, spring direction,
payment, dashboard screen size/orientation) — none of those were part of
Janis's unlock decision, only system_w was named.

## 5. DO NOT TOUCH

- Any `.scad` file — zero geometry changes, this is a docs-only prompt
- Any OWNER-LOCKED row other than `system_w`
- `total_h`, `tray_h`, or any other locked dimension — not part of this
  decision, do not reinterpret "no width/height restriction" as touching
  these

## 6. QA VERIFICATION

- [ ] CURRENT_STATE.md has a clear, unambiguous VM-01 Gen-1-locked marker
- [ ] `system_w` row fully REMOVED from OWNER-LOCKED table (not left in
      with an updated number)
- [ ] `system_w` corrected to 204mm everywhere else it appears
- [ ] Dashboard "Total width" recomputed to 181mm with formula intact
- [ ] PENDING DESIGN DECISIONS baseline updated to real current values
      (confirm actual current total_w from live code, don't assume 640)
- [ ] All other OWNER-LOCKED rows unchanged — diff-check this explicitly
- [ ] Zero `.scad` files touched

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines:
   Gen-1 lock added, system_w unlocked + corrected (185→204mm) + 3
   downstream doc fixes, zero geometry changed
2. Archive this prompt → `/prompts/archive/`
3. Update `knowledge.map` only if needed (unlikely — no new files)
4. Commit all → merge to main
5. Confirm to Janis: Gen-1 lock is visible in CURRENT_STATE.md,
   system_w governance is corrected
