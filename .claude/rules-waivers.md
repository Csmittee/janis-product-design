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
