# CC PROMPT — PR-01-base v17 — Neck-Bell True Alignment + Seam Blend + Bolt Edge Clearance

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. cc_chat_log.md (first 3 entries — newest at top)
3. rules-dimensions.md
4. rules-pr.md
5. pilates-reformer/PR-01-base/PR-01-base-v16.scad (the live file — read in full, do not infer structure from cc_chat_log summaries)

## 2. CONTEXT

Janis QA'd v16 via F5/F6 screenshots — result: FAIL, two issues, both
alignment/clearance category (not a redesign, not a shape change).

v16's cc_chat_log claimed the neck and bell were "already both anchored at
the same (cx,cy) — no true coordinate mismatch." Janis's actual render
shows that claim was incomplete: there is still a visible offset between
the neck's centerline and the bell's central (bore) axis, AND the joint
between the square neck and round bell reads as a hard seam — looking like
two separate assembled components rather than one continuous cast part.
This is a real-manufacturing problem: pole_top() is scoped as a 3D-print/
casting candidate (aluminum), not a placeholder — a visible seam line is
not acceptable on a single-piece casting.

Separately: the 2x M6 through-bolt holes in the neck are now sitting too
close to the neck's edges (both the bell-side joint edge and the bottom/
pole-side edge) after v16 moved neck_top down to fix bore clearance. Bolt
torque near a thin cast edge risks cracking — holes need real clearance
from both edges, not just the old 0.3/0.7 fraction split applied blindly
to a shorter span.

## 3. NEW FILES

NONE — new version of the existing PR-01-base file (save-as v17).

## 4. TASKS

### TASK 1 — True centerline alignment, re-derived (not assumed)

Do not trust v16's stated "(cx,cy) already matches" conclusion at face
value — re-derive and state explicitly, in cc_chat_log, the actual world
coordinates of:
- the bell's central/bore axis line (the line the 33mm bore cylinder runs
  along, post the single rotate([0,90,0]))
- the neck's central axis line (the line neck_id/neck_od cylinders are
  built around)

These two lines must be coincident (same line in 3D space, not just same
(cx,cy) at one Z height) before any other change. If they are NOT
coincident, state the actual numeric discrepancy found (do not just say
"fixed" — show the before/after numbers). Fix by adjusting neck position
only — bell geometry (profile, bore axis, bore diameter) stays untouched.

### TASK 2 — Blend the neck-bell seam into one continuous casting

Currently the neck (square-ish cross-section with rounded corners) butts
directly into the bell's round small-face — a hard seam line, visible in
Janis's renders. Add a short transition/blend zone between the two cross-
sections so the part reads as one continuous lofted/cast solid rather than
two stacked components:
- Use a hull() or loft between the neck's top cross-section and a matching-
  diameter circular cross-section at the bell's small face, over a short
  transition height (use a reasonable parametric value, e.g. 8-12mm — flag
  exact value chosen as TBD pending Janis's aesthetic confirmation, do not
  treat it as final).
- This transition is purely cosmetic/manufacturing continuity — it must
  NOT change the bore diameter, bore axis, or intrude into the bore
  envelope at any point (re-use the existing bore-envelope subtraction
  logic from v16 so the transition zone is also bore-safe by construction).
- Keep neck and bell inside the same color() block (Rule M-1 implicit
  union) so the result is a single manifold solid.

### TASK 3 — Lengthen neck, shift bolt holes for edge clearance

- Increase `neck_h` (currently 50mm) by a reasonable amount to create real
  margin — propose and state a specific new value (e.g. 65-70mm), explain
  the margin math in cc_chat_log (distance from each bolt hole center to
  the nearest edge, both top/seam-side and bottom/pole-side).
- Reposition both M6 bolt hole Z-positions so each hole has a minimum
  15mm clearance (state this as a placeholder minimum — flag as TBD
  pending real fastener/casting spec) from both the top (bell-seam/
  transition-zone) edge and the bottom (pole-body) edge of the neck.
  Do not just keep the old 0.3/0.7 fraction split — recompute explicitly
  against the new neck_h and state the actual hole-to-edge distances
  achieved.
- pole_body() height must extend/adjust to match the new (longer) neck
  bottom — no gap, same logic as prior versions.

## 5. DO NOT TOUCH

- Bore diameter (33mm) and bore axis (X) — unchanged, re-verify only, do
  not regress
- Bell exterior wine-glass profile — unchanged (large-face concave
  correction is explicitly a separate future task, not this prompt)
- pole_od (40mm), neck_od (47mm) — unchanged from v15/v16
- pole_base_collar(), pole_wood_socket(), crossbar geometry — not in scope
- rules-dimensions.md — read only
- VM-01-base — not in scope
- Any latch/cam/lever quick-release mechanism — Stage 2, explicitly deferred
- All .scad files not named in TASKS

## 6. QA VERIFICATION

Before committing, confirm all of the following, with explicit numeric
statements (not "looks aligned" / "should be fine"):

- [ ] State the bell's bore-axis line and the neck's central-axis line in
      world coordinates — confirm coincident, show the math
- [ ] State the transition-zone height used and confirm it does not
      intrude into the bore envelope at any point (re-use bore-envelope
      subtraction)
- [ ] Confirm neck + bell + transition are siblings in one color() block
      → single manifold solid (Rule M-1)
- [ ] State new neck_h value and the actual hole-to-edge distances for
      both bolt holes (top and bottom edge)
- [ ] Confirm pole_body() height adjusted to meet new neck bottom, no gap
- [ ] No undefined variable warnings, brace/paren balance clean
- [ ] Version incremented — save as PR-01-base-v17.scad, v16 not overwritten
- [ ] State explicitly: no OpenSCAD binary available in cc sandbox, so this
      is a code-review + coordinate-math verification only — Janis must
      F5/F6 render and confirm visually before this is treated as PASS

## 7. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP. Include all QA verification
   numbers above, not just confirmations. Flag clearly: "Janis F5/F6 render
   required — this fix is code-verified only, not visually confirmed."
2. Archive this prompt → /prompts/archive/ stamped ✅ COMPLETE — [date]
3. Update knowledge.map — v16 → Superseded, v17 → ACTIVE
4. Bump version header on every file changed (v17 scad, cc_chat_log.md,
   knowledge.map)
5. Commit all → merge to main

Confirm what you changed after commit.
