# cc Prompt — New Skill: Clearance Zone Color Map + Apply to v52's Two
# Open Suspects (door-top-vs-roof, hinge-cylinder-vs-wall)
# Date: 2026-07-07
# Source: vending-machine/VM-01-base/VM-01-base-v52.scad (current ACTIVE)

## 1. CC INTRO

Session continuity check: main has changed since the last merge — treat
as FRESH regardless of your own session state.
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → knowledge.map → cc_chat_log.md (first 3
entries) → rules-dimensions.md →
vending-machine/VM-01-base/VM-01-base-v52.scad (current committed
source, includes v52's two unfixed findings from the isolation task).
State every file read before writing a single line.

Claude Web override: none.

## 2. CONTEXT

Real capability limit, stated upfront: OpenSCAD has no built-in distance
field or whole-model automatic proximity scan — it's a CSG solid modeler,
not an FEA engine. This is NOT a request to build that. This is a
TARGETED tool: given two specific named parts (a suspect pair), report
and visualize how close they actually are across a few discrete
clearance bands, using real CGAL boolean operations at each band — not a
guess, an actual computed result per band, just presented as color
instead of a single pass/fail line.

Method: inflate one part by a small offset using `minkowski()` with a
sphere, then `intersection()` with the other part. If the intersection is
non-empty at a given offset, the two parts are that close (or closer).
Repeat at increasing offsets to find the tightest band at which they
still don't overlap at all (real clearance), and — separately — render
the actual overlapping VOLUME at each band that DOES show overlap, so
Janis sees the actual spot in space that's close, not just a number.

Bands (adjust if a different set makes more sense for these specific
parts — state your reasoning if you change them):
- 0mm (no inflation) → RED → actual geometric overlap, a real collision
- +0.5mm inflation → ORANGE → touching / exact-zero-clearance (the
  pattern behind both of v52's open findings and the acrylic epsilon
  fix this session)
- +2mm inflation → YELLOW → tight but technically clear
- +5mm inflation, still zero overlap → GREEN (implied — nothing to
  render, absence of a red/orange/yellow blob at that pair IS the green
  result)

This is a SPY TEST / diagnostic tool — isolation only, never a substitute
for a real fix, and never left permanently wired into the normal
assembly render (it would make every render slower and isn't needed
outside active diagnosis).

## 3. NEW FILES

- `.claude/SKILL_clearance_zone_map.md` — new skill, reusable procedure
  for any future suspect pair, any product

Add to knowledge.map.

## 4. TASKS

### TASK 1 — Write `.claude/SKILL_clearance_zone_map.md`

```markdown
# SKILL_clearance_zone_map.md
# cc — Targeted Clearance Zone Color Map (diagnostic tool, on-demand)
# Version: 1.0 — 2026-07-07
# Trigger: R-111 (repeated unresolved collision), a KT Phase 4 spy test
# where exact closeness matters more than a pass/fail check, or Claude
# Web explicitly names a suspect pair and asks for this map.
# NOT a permanent toggle in any product's normal assembly — invoked only
# when a specific prompt names the exact two parts to check.

## What this is
Given two named parts/modules, compute their real clearance at a few
discrete bands using minkowski()+intersection() (real CGAL booleans, not
an estimate), and render the actual overlapping volume at each band that
shows overlap, color-coded. Absence of a colored blob at a band means
genuinely clear at that band — don't render an empty green shell, the
absence IS the result.

## Bands (default — a prompt may specify different values for a specific
## pair if warranted, state reasoning if so)
- 0mm    → color("red")    → real collision
- +0.5mm → color("orange") → touching/exact-zero-clearance
- +2mm   → color("yellow") → tight, technically clear
- (no render past this — 5mm+ clear is reported as text, not a shell)

## Construction pattern

```openscad
module clearance_zone_map(part_a, part_b, bands=[[0,"red"],[0.5,"orange"],[2,"yellow"]]) {
    for (b = bands) {
        offset = b[0]; col = b[1];
        color(col, 0.85)
        intersection() {
            minkowski() {
                part_a();
                sphere(r=offset, $fn=16);  // low $fn — this is a diagnostic
                                            // inflation, not final geometry
            }
            part_b();
        }
    }
}
```

Call this ADDITIONALLY alongside (not instead of) the normal assembly, in
a dedicated diagnostic render — never merge it into a product's default
ASSEMBLY block. Report in cc_chat_log which bands actually produced a
non-empty intersection for the named pair, and the real-world offset value
of the tightest band that showed nothing (that's the actual measured
clearance, report it as a number, not just "green").

## Do NOT
- Do not leave this wired into any product's normal render — diagnostic
  only, remove the call after the session unless Janis asks to keep it
  for ongoing monitoring of a specific known-tight pair
- Do not use high $fn on the inflation sphere — this is about a yes/no
  overlap per band, not a precision measurement; keep it cheap
- Do not report "green" by rendering an empty/invisible shell — report it
  as a stated clearance number in cc_chat_log instead
```

### TASK 2 — Apply to v52's Finding 1: door_top_z vs. shell roof skin

Using the new skill, check the door's top edge against the shell roof
skin at the bands above, with the door in its closed position
(`door_open_deg = 0`). Report which bands show overlap, and the real
clearance value.

### TASK 3 — Apply to v52's Finding 2: hinge-pivot reinforcement cylinder
### vs. shell exterior wall

Same procedure, for the hinge-pivot reinforcement cylinder (added in the
v50 corner-frame-redesign) against the shell's flat exterior wall.
Report which bands show overlap, and the real clearance value.

### TASK 4 — Do NOT fix either finding this round

Both remain isolation-only per the prior prompt's scope. This prompt adds
precision to the existing findings — it does not change the plan to fix
them in a follow-up once both are fully characterized.

### TASK 5 — Remove diagnostic calls before final commit

After Tasks 2-3 produce their reported clearance numbers, REMOVE the
`clearance_zone_map()` calls from the file entirely before committing —
do not leave them present-but-commented-out either; delete them clean.
The skill file (`SKILL_clearance_zone_map.md`) and the `clearance_zone_map()`
module definition itself stay in the codebase for reuse next time, but
the two specific diagnostic CALLS made for this session's two findings
do not persist in the committed `.scad` file. The permanent record of
what was found is the clearance numbers in `cc_chat_log.md`, not a
permanent diagnostic render sitting in the file. Confirm in cc_chat_log
that the file's line count / structure is otherwise unchanged from v52
plus only the new reusable module definition — not v52 plus two
permanent diagnostic calls.

## 5. DO NOT TOUCH

- Any other part of `VM-01-base-v52.scad` — this is a diagnostic-only
  addition, no production geometry changes
- The acrylic epsilon fix from this session — already correct, don't
  touch
- Any PR-01 file
- Do not wire `clearance_zone_map()` into the normal ASSEMBLY block

## 6. QA VERIFICATION

- [ ] `SKILL_clearance_zone_map.md` created, matches the structure above
- [ ] `clearance_zone_map()` module added, using minkowski()+intersection(),
      low $fn on the inflation sphere
- [ ] Applied to Finding 1 (door-top vs. roof) — bands reported, real
      clearance number stated
- [ ] Applied to Finding 2 (hinge-cylinder vs. wall) — bands reported,
      real clearance number stated
- [ ] Diagnostic render confirmed NOT wired into the normal ASSEMBLY block
- [ ] Diagnostic calls for both findings REMOVED before commit — not
      commented out, deleted — only the reusable `clearance_zone_map()`
      module definition itself persists
- [ ] No fix attempted on either finding — confirmed
- [ ] Version incremented v52 → v53 (diagnostic addition only, geometry
      unchanged), v52 untouched

## 7. MANDATORY CLOSING

1. Prepend `cc_chat_log.md` — newest entry at TOP, under 10 lines: new
   skill created, both findings' exact clearance values reported,
   confirmation diagnostic calls were removed before commit
2. Archive this prompt → `/prompts/archive/` ✅ COMPLETE — 2026-07-07
3. Update `knowledge.map` with the new skill file
4. No dimension changes — confirm explicitly
5. Commit all → merge to main
