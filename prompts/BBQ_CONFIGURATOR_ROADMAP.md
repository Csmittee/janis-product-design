# FUTURE INITIATIVE — PARKED, NOT ACTIVE
## BBQ Smoker Designer / Recipe-to-Prompt Configurator
Status: captured for later, not scheduled — trigger when real customer
demand for customization exists. No cc work, no repo changes from this
document alone.

---

## The vision, in Janis's own words (this session)

Current process: Ideation with chat → cc builds → debug → send to
viewer/three.js tool → 3D viewer ready for social/PDF/video → any
change means going all the way back to step 1.

Target future process: Design dashboard (three.js + WASM in-browser) →
pick a base product (BBQ / pilates / vending, from the repo) → adjust
shape, size, features freely by eye → dashboard generates a structured
parameter "recipe" → bring the recipe back to Claude Web → Claude Web
maps it through the project's own design-template skill/rules → drafts
ONE cc prompt → cc builds the real .scad → done, no debug loop.

## Why this is real, not just a nice idea

Two things already true in this project point the same direction:
1. OpenSCAD's own Customizer (`// [-50:5:50]`-style annotations) already
   gives live parameter sliders for free, IF the underlying values are
   genuine formulas, not hardcoded literals — the audit-and-wire work
   this project keeps doing anyway (apex A, grate, fender) is the same
   work a configurator needs, just done once per parameter instead of
   reactively.
2. The cc prompt template itself is already structured/schema-like
   (7 fixed sections, explicit tasks, explicit datums) — a filled
   "recipe" is mechanically close to what a prompt already contains,
   just without the free-text explanation.

## Staged build (not a single project — do incrementally)

**Stage 1 — Recipe schema (cheapest, most immediately useful)**
A structured config file (JSON/YAML) whose fields map ~1:1 to what a
cc prompt needs: product line, base version, changed parameters +
values, feature toggles. Claude Web's job becomes "translate a filled
recipe into a real cc prompt using the product's own locked
conventions" — most of what makes today's prompts long is re-deriving
context; a recipe states it directly. This is the piece that most
directly cuts token burn on routine changes, and could realistically
start soon, independent of the dashboard.

**Stage 2 — Modular swappable features (the real engineering cost)**
Numeric features (length, grate height, wheel size, intake size) are
the easy case — live formulas + bounded Customizer ranges, same
pattern as apex A. Structural features (chamber shape: cylinder /
hexagon / octagon / square; door type: swing / slide, degree of open;
firebox insulated/non-insulated, square/round, with/without ash tray)
are NOT parameters — they're different code paths. Each needs to be
built as an interchangeable module sharing a common interface (same
anchor points, same function signature) so grate/lid/firebox modules
don't care which variant is plugged in. Real modular-architecture work,
done once per feature — best tackled incrementally, folded into
whatever subsystem is already being touched for a real reason (same
pattern as this session's apex-A Customizer wiring), not as one big
refactor.

**Stage 3 — The web dashboard itself**
Live in-browser 3D + WASM configurator. Technically real (OpenSCAD has
been compiled to WASM before; browser-based parametric configurators
exist), but needs its own small prototype to confirm real constraints
before assuming it layers cleanly on top of Stage 1/2 — not fully
verified, worth a dedicated spike when this stage is actually reached.

## Feature list Janis wants selectable (BBQ line, initial draft)

- Chamber shape: cylinder (bullet), hexagon, octagon, square
- Length: freely specified
- Grate height
- Door type: swing-up, slide-out; degree of open
- Firebox: insulated / non-insulated; square / round; with / without
  ash tray
- Intake size
- Exhaust type, size
- Wheel size
- T-bar: present / absent, length

Special/one-off features (not on this list) get built from scratch as
needed, then standardized into a new module/object for future reuse —
same "build once, then generalize" pattern already used in this
project (e.g. the Dual End-Cap pattern, now a named reusable
convention).

## Trigger condition

Revisit this document when real customer demand for customization
exists — not before. Until then, each subsystem touched for a real
reason should still get audited/formula-wired where practical (as with
apex A this session), so Stage 1/2 has less catch-up work whenever it
does start.
