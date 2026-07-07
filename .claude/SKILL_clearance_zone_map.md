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

OpenSCAD cannot pass a module name as a value to another module's
parameter and invoke it — there is no "module reference" type. The
prompt-level pseudocode (`part_a()`/`part_b()` as parameters) does not
compile as literally written; the real, working idiom is `children()`:
pass the two parts as the module's two children, index them
`children(0)`/`children(1)`. This is the actual pattern committed to code
— documented here so a future session doesn't re-discover the same
language limitation from scratch.

```openscad
module clearance_zone_map(bands=[[0,"red"],[0.5,"orange"],[2,"yellow"]]) {
    // children(0) = part A (the one that gets inflated), children(1) = part B
    for (b = bands) {
        offset = b[0]; col = b[1];
        color(col, 0.85)
        intersection() {
            if (offset == 0) {
                children(0);   // offset=0 uses the real part directly —
                                // minkowski() with sphere(r=0) is degenerate,
                                // do not call it
            } else {
                minkowski() {
                    children(0);
                    sphere(r=offset, $fn=16);  // low $fn — this is a diagnostic
                                                // inflation, not final geometry
                }
            }
            children(1);
        }
    }
}
```

Call as:
```openscad
clearance_zone_map() {
    part_a_module();
    part_b_module();
}
```

Call this ADDITIONALLY alongside (not instead of) the normal assembly, in
a dedicated diagnostic render — never merge it into a product's default
ASSEMBLY block. Report in cc_chat_log which bands actually produced a
non-empty intersection for the named pair, and the real-world offset value
of the tightest band that showed nothing (that's the actual measured
clearance, report it as a number, not just "green").

## Reading the result: exact-touching vs. a small real gap
A genuinely useful distinction real CGAL execution can reveal that pure
arithmetic (checking whether two coordinate values are numerically equal)
cannot on its own: at `offset=0`, an EXACT planar/tangent touch between two
solids has zero volume, so `intersection()` correctly reports it as EMPTY
— this is NOT proof of a small real gap. The tell is what happens at the
very next tiny positive offset (e.g. `0.02mm`): if the facet count jumps
immediately to a substantial, stable value (not growing gradually from
near-zero), that jump is the signature of an exact, already-coincident
boundary — the entire touching AREA engages at once, because any positive
inflation, however small, converts the whole zero-volume shared face into
a real shared volume. A genuine small real-world gap would instead show
NO overlap at a few small offsets before finally showing SOME overlap
once the offset exceeds the actual gap distance. Confirm which pattern you
see before reporting "clearance = Xmm" — do not report 0.02mm as "the
clearance" when it's really an exact-touch artifact of the first offset
tested.

## Isolating the right sub-region
Do not minkowski()+intersect two enormous, full, un-sliced assemblies
whole — this conflates every near-touch anywhere in the model into one
number and is needlessly slow. Instead:
- Use `intersection()` with a small, deliberately-placed bounding box to
  extract just the local region around the named suspect pair, from each
  of the two REAL modules (not a hand-reconstructed approximation) —
  this keeps the signal attributable to the one pair being asked about.
- Verify the result is robust to the box's exact placement/size (shift it
  and re-run) before reporting a finding — a result that only appears
  with one specific box is more likely a slicing artifact (the box's own
  edge coincidentally aligning with a real surface) than a genuine
  property of the model.
- Keep the Z-extent (or whichever axis is least relevant to the specific
  feature) short — this is what keeps minkowski() fast on an otherwise
  complex CSG tree; a full-height/full-object minkowski can still finish
  in ~20s for a model this size, but a tightly-scoped slice is faster and
  gives a cleaner, more attributable signal.

## Do NOT
- Do not leave this wired into any product's normal render — diagnostic
  only, remove the call after the session unless Janis asks to keep it
  for ongoing monitoring of a specific known-tight pair
- Do not use high $fn on the inflation sphere — this is about a yes/no
  overlap per band, not a precision measurement; keep it cheap
- Do not report "green" by rendering an empty/invisible shell — report it
  as a stated clearance number in cc_chat_log instead
- Do not call `minkowski()` with `sphere(r=0)` — degenerate, skip the
  minkowski step entirely at the 0mm band and test the real part directly
