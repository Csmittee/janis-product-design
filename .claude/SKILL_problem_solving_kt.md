# SKILL_problem_solving_kt.md
# Kepner-Tregoe Problem Solving — Janis Product Design
# Version: 2.0 — 2026-06-29
# Location: .claude/SKILL_problem_solving_kt.md
# Replaces: root/SKILL_problem_solving_kt.md (delete old) + SKILL_problem_solving_kt_scad.md (never created)
# Read when: R-111 triggered — problem not resolved within 2 fix loops

---

## WHAT IS A LOOP

One loop = Claude Web writes prompt → cc executes → Janis QAs result.
Two loops failed on the same problem = R-111. Claude Web self-triggers. No exceptions.
Janis does not need to ask.

---

## THE COMMUNICATION CONSTRAINT — DESIGN ALL TESTS AROUND THIS

Claude Web → prompt → cc executes → cc writes result to cc_chat_log → Janis reads repo → Janis tells Claude Web.
cc cannot speak to Claude Web directly. Every spy test must be designed for Janis to run in OpenSCAD.
cc_chat_log is the ONLY channel cc has to respond back. Claude Web reads it at every session open.

---

## KT PROCESS 1 — SITUATION APPRAISAL

Before any analysis, confirm what you know vs. what you are assuming.

- Raw symptom only — exact OpenSCAD output or error text, no interpretation
- Which version first showed it? Which version last did NOT show it?
- What changed between those two versions? (check cc_chat_log entries)
- Is this one problem or multiple? Separate before proceeding.

"2-manifold warning" is NOT a problem statement.
"VM-01-base-v19 F6 shows 2-manifold warning. v14 F6 did not." IS a problem statement.

---

## KT PROCESS 2 — PROBLEM ANALYSIS (IS / IS-NOT)

Fill every cell before forming any hypothesis.

| Dimension | IS | IS NOT | Distinction |
|---|---|---|---|
| WHAT | which module/geometry fails | similar modules that do not | what is unique to the failing one |
| WHERE | which file, which render mode | other files, other modes | |
| WHEN | which version introduced it | last version without it | what changed |
| EXTENT | blocks export? all modules affected? | what still works fine | |

Rule: every hypothesis must explain BOTH IS and IS-NOT columns.
If it cannot explain why similar objects do NOT fail → eliminate immediately.

---

## KT PROCESS 3 — HYPOTHESIS TESTING

List all possible causes. For each, answer both:
1. "If this is the cause — how does it explain IS?"
2. "If this is the cause — why does IS-NOT not fail?"

If either answer needs an unverifiable assumption → rank lower.
Select highest-ranked hypothesis. Design spy test before writing any fix.

**For SCAD manifold — always include these in hypothesis list:**

| Cause | Pattern to check |
|---|---|
| Coplanar face | Two objects sharing an exact face — no gap, no overlap |
| Open difference | Inner object ≥ outer on any axis inside `difference()` |
| Degenerate geometry | Any dimension < 2mm on two or more axes |
| Corner-only union | Objects share only an edge in `union()`, not a face volume |
| World/local Z mismatch | Module uses world Z but assembly already translates it |
| For-loop floor contact | Inner object Z = tray_floor_t exactly — epsilon missing |
| Hull over rotated geometry | `hull()` on `rotate() cylinder()` — non-planar result |

---

## KT PROCESS 4 — SPY TEST (one change, one observation)

Minimum invasive test to confirm hypothesis before writing any fix.
Never test two things at once — result is unreadable.
Never write a fix before spy test confirms the culprit.

**For OpenSCAD manifold — isolation test:**
Janis comments out modules ONE AT A TIME in ASSEMBLY. Presses F6 after each.
Claude Web gives Janis the exact line to comment. One module per test.

Order (most likely first):
1. Most recently added or changed module
2. Any module with a `for()` loop containing inner geometry
3. Any module using `union()` with multiple cubes
4. Any module with `difference()` subtractions
5. Core modules (outer_shell, legs) — last

Warning disappears → confirmed culprit. Stop. Claude Web writes surgical fix for that module only.
Warning stays with all modules commented → culprit is in core geometry.

---

## KNOWN SCAD MANIFOLD ROOT CAUSES — CHECK THESE FIRST

Confirmed by isolation test in this project. Skip hypothesis listing if pattern matches directly.

| Confirmed cause | Module pattern | Fix applied |
|---|---|---|
| For-loop inner objects flush on tray floor/wall | motor/spring/partition at exact tray_floor_t | `e = 0.01` on contact axes — v26 |
| Inner cylinder taller than outer in `difference()` | `cylinder(h=spring_l+1)` inside difference | Inner → `spring_l-1` — v20 |
| Compartment top flush with shell top | height = `total_h-leg_h` placed at `leg_h` | Subtract `skin_t` — v20 |
| Frame bars corner-edge only in `union()` | 4-bar frame, bars independent cubes | Bars own corners, sides shortened — v20 |
| World Z inside module with assembly translate | cutout uses `leg_h` inside already-shifted module | Local Z = 0 inside module — v18 |
| Degenerate geometry | `cube([x, 1, 1])` sensor laser visual | Minimum 2mm all axes — v19 |
| Hull over rotated cylinders | `hull(){ rotate() cylinder(); }` dashboard bracket | Replace with flat cube — v19 |

---

## EPSILON PATTERN — INNER OBJECTS INSIDE CONTAINERS

Any object inside a box/tray touching a face must use `e` offset.
Declare `e = 0.01;` in PARAMETERS — always present.

```openscad
// WRONG — coplanar face = non-manifold
translate([x, y, tray_floor_t]) cube([w, d, h]);

// CORRECT — epsilon lift from floor
translate([x, y, tray_floor_t + e]) cube([w, d, h]);

// WRONG — flush with rear wall
translate([x, tray_d - wall_t, z]) cube([w, d, h]);

// CORRECT — epsilon pull from wall
translate([x, tray_d - wall_t - e, z]) cube([w, d, h]);
```

---

## F5 vs F6 — ALWAYS CONFIRM WHICH MODE

| Mode | Key | Purpose | Transparency |
|---|---|---|---|
| Preview | F5 | Visual QA, color, acrylic see-through | YES |
| Full render | F6 | Manifold check only | NO — all opaque yellow |

Never reject a visual based on F6. Never confirm manifold using F5.

---

## IF 3RD LOOP FAILS AFTER FULL KT

State: "KT exhausted." Present full IS/IS-NOT table to Janis.
Janis decides: escalate to supplier, change design approach, or accept constraint.
Do not write another fix prompt without new information from Janis.
