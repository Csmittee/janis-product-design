# cc Prompt — VM-02: Display Shelf + Right-Side Viewing Acrylic
# Date: 2026-07-10
# Scope: VM-02-base ONLY (source: VM-02-base-v2.scad, merged PR #112).
# VM-01 is NOT touched — stays LOCKED.

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) →
knowledge.map → rules-dimensions.md → VM-02-base-v2.scad (the actual
current file) → vending-machine/VM-02-base/design_scope_of_work_rule.md →
vending-machine/VM-02-base/PART_MANIFEST.md → SKELETON_WORKSHEET.md.
CONFIRM VM-02-base-v2.scad is the live source (Janis F6/Error-Log QA
PASS, no manifold issues, confirmed this session) before starting.
R-009 Duplication Check: before writing either task below, state
explicitly whether `acrylic_zone_bot_z` and the acrylic zone's Z-range
already exist as a live top-level datum (they should, per v2's own
header — dashboard()'s Z-chain was promoted there) — confirm you are
reading that SAME value, not re-deriving a copy.

## 2. CONTEXT

Janis wants two additions to the right/system compartment's acrylic
display zone (the upper zone above the now-solid dashboard panel added
in v2). Both are NEW features, not fixes to v2's own work.

**Claude Web's stated assumptions below are NOT confirmed against live
code — verify each against the actual v2.scad file. If the live geometry
makes either assumption ambiguous or wrong, STOP and state the ambiguity
in cc_chat_log rather than silently picking an interpretation.**

### Feature A — Display shelf (floor)

Janis: "the right system zone at the display zone with acrylic cover,
just 10mm below the acrylic edge, I need a floor start from front go all
the way back to the back panel spread fill left right, for placing
display stuffs."

Claude Web's reading: a solid floor panel sitting 10mm below
`acrylic_zone_bot_z` (the acrylic zone's own BOTTOM edge — where the
transparent viewing area begins) — i.e. `shelf_top_z = acrylic_zone_bot_z
- 10`. This creates a physical shelf just below the display window for
items to sit on, visible through the acrylic above. The floor should
span:
- Full depth (Y): from the shell's interior front face to the interior
  rear wall (same convention other full-depth panels in this file use)
- Full width (X): the full width of the system/dashboard compartment —
  read the actual interior width bounds cc's own code uses for this
  compartment (do not guess a number; derive from the same values
  `dashboard()`/`acrylic_display()` already use for this compartment's
  left/right extent)

If "10mm below the acrylic edge" could instead mean something else once
you're looking at the real acrylic zone geometry (e.g. there is more
than one distinct "acrylic edge" — top vs. bottom vs. the right-side
panel's own edge), state the ambiguity explicitly and propose the
reading that best matches "for placing display stuffs" (i.e. a shelf,
not a ceiling) — but flag it as an assumption either way, do not treat
it as settled.

### Feature B — Right-side viewing acrylic

Janis: "on the right side at the same high of current acrylic, extend
from front mid of front to back another side view acrylic screen, keep
the same high and all the level projected from the front."

Claude Web's reading: `acrylic_display()`'s existing "right panel" (the
one whose fix is documented in v1/v2's own header — full depth, at
X=total_w-skin_t*2) is INTERNAL ONLY as of v2, and CONFIRMED intentional
— Janis's own words: "i asked for this since the beginning... we never
cut the shell to let it show." Confirm explicitly: does `outer_shell()`
currently have ANY cutout on the machine's own RIGHT EXTERIOR face (the
X=total_w wall) at the acrylic zone's Z-range? Report this explicitly
either way, do not assume.

If no such cutout exists: add one. Z-range: same as the existing acrylic
zone (`acrylic_zone_bot_z` to roofline — same live datum, not a new
one) — Janis: "stretch to the top as current front view."

Y-range — CORRECTED per Janis (2026-07-10, this session): starts at the
FRONT of the compartment (same Y as the front face, aligning with the
front-right corner) and extends BACK only to the MID-POINT of the
compartment's own depth (total_d/2) — the FRONT HALF of the depth, NOT
the back half (Claude Web's first draft had this backwards — corrected
here). Janis: "it start from front to mid front back, separate by front
right corner in the balance way." The front-right rounded corner
(`corner_r`) is the natural dividing point between the EXISTING
front-facing acrylic zone (already visible in the current front view)
and this NEW right-facing acrylic zone — the two should meet/transition
at that corner in a visually BALANCED (symmetric) way, not an arbitrary
split. Use judgment on how "balanced" is best expressed given the
corner's real radius/geometry (e.g. equal visual weight on each face
approaching the corner) and state your reasoning explicitly — this is a
design-intent instruction, not a literal dimension Janis gave, so don't
force an exact formula that isn't actually derivable from the corner
geometry; flag if you had to make a judgment call.

If the existing internal right panel's own Y-range doesn't already match
this corrected front-half range (e.g. it currently spans the full depth,
or some other range), adjust the panel to match the new cutout's Y-range
so the material and the opening align — state explicitly what the
panel's Y-range was before this prompt and what it is after.

If a right-exterior cutout already exists in some form, state that
explicitly and describe what's actually needed to make it match Janis's
description, rather than assuming a duplicate build is required.

## 3. TASKS

TASK 1 — `outer_shell()`: add/confirm the right-exterior acrylic cutout
per Feature B — Z-range matches the existing acrylic zone datum, Y-range
is the FRONT HALF of the compartment's depth (front edge to mid-depth,
corrected range, NOT mid-to-back).

TASK 2 — Display shelf: new floor panel per Feature A, called from
ASSEMBLY. Use whatever module name/placement fits this file's existing
convention (e.g. as part of `acrylic_display()` or a new
`display_shelf()` module) — state which you chose and why.

TASK 3 — Right panel adjustment: confirm/fix `acrylic_display()`'s
existing right panel's Y-range against TASK 1's new cutout, per Feature
B above.

TASK 4 — Mandatory manifold sweep: tray_count 1/3/5, full CGAL check.
Explicit isolation checks: new shelf vs. `dashboard()`, new shelf vs.
`outer_shell()`, new shelf vs. `acrylic_display()`'s existing top/right
panels, new right-exterior cutout vs. `rear_service_door()`, new
right-exterior cutout vs. `tray_zone_frame()`. Plus the standard
battery: 11-angle door sweep, mixed `tray_out_pct`, `flap_open` true/
false, C2 mode. State `Simple: yes/no` for every check individually, not
just a summary line.

TASK 5 — Update `vending-machine/VM-02-base/PART_MANIFEST.md`: add row(s)
for the new shelf module and any changed cutout, toggle status stated
explicitly (GAP or named `show_*`, per the Toggle-Completeness Rule —
do not leave this column blank).

TASK 6 — Update `rules-dimensions.md`'s VM-02 section: document
`shelf_top_z` formula, the shelf's real X/Y span (actual values used,
not placeholders), and the right-exterior cutout's Y-range (actual
start/end values).

## 4. NEW FILES
None — this extends VM-02-base-v2.scad. Save the result as
`VM-02-base-v3.scad` (new file, v2 stays untouched, same convention as
prior versions).

## 5. DO NOT TOUCH
- VM-01 — any file, any version. Out of scope entirely.
- `dashboard()`'s own hardware modules (screen/QR/card/speaker geometry
  itself) — this prompt adds a shelf and a viewing window, not new
  hardware.
- `left_zone_door()`, tray/spring/frame geometry, `rear_service_door()`'s
  own panel geometry (only isolation-checked against, not modified
  unless TASK 1's cutout genuinely requires it — if so, STOP and flag
  rather than modifying it silently).
- `rules-dimensions.md` OWNER-LOCKED rows — none of this task should
  touch any locked value; confirm explicitly none were touched.
- `design_scope_of_work_rule.md` / `SKELETON_WORKSHEET.md` — read-only
  this round, not part of this prompt's scope.

## 6. QA VERIFICATION
Confirm all before committing. State each result explicitly in cc_chat_log:
- [ ] Stated explicitly whether a right-exterior cutout existed before
      this prompt — yes/no, with reasoning
- [ ] `shelf_top_z` formula stated, using live `acrylic_zone_bot_z` datum
      (not re-derived)
- [ ] Shelf X/Y span stated as actual values, derived from the same
      compartment-width values `dashboard()`/`acrylic_display()` use
- [ ] Right-exterior cutout Y-range stated as actual values
- [ ] Any ambiguity in Feature A or B's reading flagged explicitly, not
      silently resolved
- [ ] PART_MANIFEST.md updated, toggle column not blank
- [ ] rules-dimensions.md VM-02 section updated with real values
- [ ] Full CGAL sweep results per TASK 4, each check listed individually
- [ ] Confirm zero VM-01 files touched
- [ ] Confirm zero OWNER-LOCKED values touched
- [ ] Saved as VM-02-base-v3.scad (v2 untouched)

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP, under 10 lines
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map if any new files
4. Bump version on all changed files (PART_MANIFEST.md, rules-dimensions.md)
5. Commit all → merge to main
