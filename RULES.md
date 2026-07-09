# RULES.md
# Janis Product Design — Numbered Rules Log
# Version: 3.0 — 2026-07-09
# Changes: Added R-008/R-009/R-010/R-011, from the governance retrospective
# on the VM-01 door/manifold/acrylic saga (57 versions to fully resolve;
# governance-verification-escalation-rules). New structural content (new
# numbered rules), not a detail-only change — X.0 bump per the Document
# Versioning Rule. R-001-R-007 untouched.
# Previous: 2.0 — 2026-07-07
# Changes: Added R-005/R-006/R-007, extracted from archived prompts
# 2026-07-05 through today (governance-cc-intro-knowledge-map-rules-refresh).
# New structural content (new numbered rules), not a detail-only change —
# X.0 bump per the Document Versioning Rule. R-001-R-004 untouched.
# Previous: 1.0 — 2026-06-29
# Read by: cc before every SCAD task. Claude Web during diagnosis.
# Format: newest rule at TOP. Append above previous entries. Never delete — mark [DEPRECATED] if superseded.

---

## Standard Units & Governance (from rules.md — retained)

- All dimensions in MILLIMETERS — always
- Pipe OD: 25mm standard (state if different)
- Wall thickness: 2mm aluminum / 3mm steel / 4mm composite
- Tolerance: ±0.5mm unless stated
- Never overwrite files — always increment v1→v2→v3
- Every supplier export → /exports/for-supplier/
- Every prompt saved in /prompts/ before CAD session starts
- Never put more than 400 lines in any rules file — split by domain
- Never delete old rules — mark [DEPRECATED] if changed

## File Naming Convention
[PRODUCT]-[MODEL]-[COMPONENT]-[VERSION]
Examples: PR-01-base-rail-joint-v1.stl / VM-01-frame-corner-v2.scad

## Approval Gates (before moving to next component)
- F5 preview correct
- F6 full render clean — no warnings
- STL → /exports/for-supplier/
- DXF → /exports/for-cnc/
- Prompt → /prompts/
- Screenshot → /renders/
- Relevant rules file updated if new learning

---

## Numbered Rules — Newest First

## R-011 — Direct-CC Escalation Protocol
Date: 2026-07-09
The default flow is: Janis describes an issue to Claude Web → Claude Web
drafts a structured prompt (CC INTRO/CONTEXT/TASKS/DO NOT TOUCH/QA
VERIFICATION/MANDATORY CLOSING) → Janis sends it to cc.

Janis MAY escalate directly to cc (bypassing prompt drafting) when the
prompt-based loop is not making progress — e.g. a prompt was built on
insufficient context, cc's response reveals the actual problem needs
faster back-and-forth than the prompt format allows, or repeated prompt
rounds aren't converging. This is a LEGITIMATE, EXPECTED escape valve,
not a process failure — it exists because real-time back-and-forth is
sometimes genuinely faster than structured prompts, especially for
open-ended diagnosis.

When this happens, TWO things are required to avoid coordination
confusion between the two channels:
1. Direct-cc-chat sessions must STILL end with the same MANDATORY CLOSING
   any prompt-based session requires — cc_chat_log.md entry, prompt
   archived if one existed, version bump, commit, merge to main. No
   informal-mode exception.
2. Before the NEXT Claude Web session resumes work on the same file,
   Janis (or Claude Web, via project_knowledge_search/web_fetch on the
   real PR) must confirm the direct-cc-chat session's actual outcome from
   the real repo/cc_chat_log — Claude Web must NEVER assume what happened
   in a direct-cc-chat session from Janis's paraphrase alone when the
   real source (PR diff, cc_chat_log entry) is checkable.
Root cause of: this project's own PR #100/#101 sync-lag incidents —
running both channels on the same file without an explicit sync point
caused real confusion and repeated re-diagnosis.

## R-010 — Repeat-Touch Escalation: 3 strikes means question the design, not just patch it
Date: 2026-07-09
If the same module/feature is the subject of 3 or more separate fix
prompts/sessions without full resolution (tracked informally via
cc_chat_log entry titles/scope), the NEXT prompt targeting that same
module/feature MUST include an explicit "is this the right underlying
design" question as its own task — not just another incremental patch
attempt. This applies even if each individual prompt's specific bug was
real and worth fixing at the time; the escalation is about stepping back
to question the approach, not about any single fix being wrong.
Root cause of: the hinge-pivot reinforcement cylinder was investigated or
re-touched in v50 (introduced), v52 (isolation finding), v53 (precision-
confirmed via CGAL), and v55 (ruled out as the manifold-warning cause via
a full 9-angle sweep) — 4 separate sessions touching the same part before
its fundamental design (a continuous rod vs. a real hinge's mating
knuckle pair) was ever questioned, at v57. That one question — "is this
how real hinge hardware actually works" — resolved the recurring
collision-ambiguity problem in a single step, where 4 prior rounds of
re-diagnosis had only ever isolated or ruled out individual symptoms.

## R-009 — Duplication Check: before fixing, search for copies
Date: 2026-07-09
Before writing a fix to any module/value, search the ENTIRE active file
(and any other files in the same part's module group) for other places
the same logic/value/constant may be independently re-derived. If any
duplicate is found, the fix must be applied to ALL copies in the same
pass — not just the one that triggered the bug report — and
cc_chat_log.md must state explicitly how many copies were found and
fixed. A fix that only addresses one copy of a duplicated pattern is
INCOMPLETE, not done.
Root cause of: `door_bot_z` was independently re-derived in 4 places
(v55 — `door_bot_z` itself plus 3 copies: `hinge_z` in `left_zone_door()`,
`shell_hinge_z` in both `outer_shell()` and `outer_shell_debug()`);
`outer_shell()`/`outer_shell_debug()` each maintained their own
independent copy of the same corner-pole cutout (v56) — both bugs
recurred specifically because only one copy got fixed at a time, and a
second fix round was needed once the still-broken duplicate was found.

## R-008 — Verification Discipline: no "CONFIRMED"/"RULED OUT" without an attached real check
Date: 2026-07-09
A finding may only be written into rules-dimensions.md using the words
"CONFIRMED", "RULED OUT", "FIXED", or "RESOLVED" if a real geometry check
(CGAL `intersection()`, a real render, an actual measurement) was
performed AND the method AND its scope are stated alongside the finding
(e.g. "9-angle CGAL sweep, full assembly" vs. "single-angle CGAL check,
isolated slice" vs. "single-angle arithmetic estimate"). A narrowly-scoped
check that is real (not arithmetic) can still be misleading if its
result is generalized beyond what it actually tested — state the SCOPE,
not just whether a real tool was used.
Findings that are arithmetic-only, single-angle, or isolated-slice-only
MUST be labeled explicitly as such — e.g. "UNVERIFIED — arithmetic only,
full sweep pending" or "ISOLATED CHECK ONLY — confirms tangency at this
one spot, does NOT confirm this is the cause of the full-assembly
warning" — and CANNOT be treated as closed. Any future session that
reads such a finding and relies on it for a decision must either perform
the real, appropriately-scoped check itself first, or explicitly flag
the reliance as provisional in its own cc_chat_log entry.
Root cause of: v52's two "exact tangency" findings started as
arithmetic-only. v53 upgraded one to a REAL CGAL measurement (0.000mm
exactly, isolated single-configuration test) — a genuinely correct,
tool-verified result — but this got treated as confirming those two spots
were THE cause of the full-assembly door-closed manifold warning, an
inference no full-sweep test had actually checked. v55's real 9-angle
CGAL sweep against the full assembly found both spots completely clean
at every angle — neither was ever the real trigger. The failure mode
was not "no real tool was used" (v53 did use CGAL) but "a real, narrowly-
scoped result was generalized past what it actually verified."

## R-007 — "Patch vs. real material" pattern
Date: 2026-07-07
When a design change shortens or repositions one part and leaves a
visible/structural gap behind, close the gap by extending the ADJACENT
structural material already in that zone — not by adding a new,
separately-modeled cosmetic piece stacked on top to visually cover it.
A patch piece that renders/hides along with a sibling toggle it isn't
logically part of (e.g. it disappears when an unrelated part's own
show_* toggle is set false) is a reliable tell that it's cosmetic, not
structural — check that dependency directly rather than trusting the render.
Root cause of: vm01-shell-toggle-fix-and-hole-isolation (VM-01-base v51)
TASK 4 — the door's top "metal cap" (added in v48 to fill the gap left
when the acrylic pane's own top boundary was pulled down to clear
tray_zone_frame()'s weld flange) was a separate piece nested inside
`if (show_acrylic) {...}`, so it vanished whenever the acrylic was hidden
— proof it was cosmetic, not independent shell material. Fixed by
shrinking the door leaf's own window cutout instead, letting the leaf's
existing continuous skin fill the space (the same construction the door's
lower/flap zone already used, v49).

## R-006 — Shared-center/radius arc constraint
Date: 2026-07-06
Two geometrically independent-looking features built from the SAME circle
center + radius (e.g. a door's return-flange swing arc and a structural
frame's inner curve) cannot be resized independently without re-checking
both — growing one back toward that shared circle's true radius can
reintroduce the exact collision the resize was meant to relieve, because
both features occupy the identical locus at that radius by construction,
not by coincidence.
Root cause of: VM-01-corner-frame-redesign (v50) — tray_zone_frame()'s
left vertical could NOT be grown to touch the shell's interior wall
(radius (corner_r-1)+e) without recolliding the door, because the door's
own return-flange arc uses the IDENTICAL center/radius (corner_r-1) by
design, for a snug closed fit — confirmed via live CGAL bisection, not assumed.

## R-005 — Render-mode/toggle compound-gating trap
Date: 2026-07-05
A show_* isolation toggle can be correctly declared and correctly
referenced in code, yet still read as "does nothing" if its own
if-condition is compounded with another gate (e.g.
`render_mode=="value" && show_x`) whose value never matches by default —
setting show_x then has zero visible effect regardless of its own value.
Before concluding a toggle is broken/orphaned, grep its EXACT if-condition
and confirm every compounded term, not just the toggle's own name.
Root cause of: VM-01-frame-window-rebuild-v44 Finding B — the door's
acrylic pane was gated on `render_mode=="full" && show_acrylic`;
`render_mode` defaults to `"standard"`, so `show_acrylic` could never take
effect regardless of its own value, inconsistent with its siblings
(show_door/show_flap, which are not render_mode-gated).

## R-004 — One prompt open at a time
Date: 2026-06-29
Never push a second prompt to /prompts/ while cc is executing one.
Wait for cc_chat_log confirmation before writing the next prompt.
Stacked prompts cause version conflicts and unclear QA state.

## R-003 — Debug toggle declaration rule
Date: 2026-06-29
Never comment out a debug variable declaration line (e.g. // show_shell_back = true).
If a module references that variable, OpenSCAD warns "Ignoring unknown variable".
To hide a panel: set value to false. Keep the declaration line active always.

## R-002 — Polygon undercut minimum clearance
Date: 2026-06-29
$fn=64 cylinders undercut theoretical radius by ~0.04mm per r=33mm
formula: r × (1 - cos(180/$fn)).
Epsilon (e=0.01mm) is NOT enough for cylinder-to-flat-face contact.
Minimum clearance for any cylinder near a flat face: 2mm.
Root cause of coil-floor contact in v36 manifold chase.

## R-001 — Implicit union trap (display objects inside structural translate)
Date: 2026-06-29
In OpenSCAD, all children of translate()/rotate()/color() are implicitly unioned.
A display object (coil, motor, partition) placed as a sibling of a structural
difference() body inside the same translate() will union with that body.
If its surface touches any tray face at 0mm clearance = non-manifold.
Fix: call display objects from assembly level as their own named module —
never as siblings inside a structural translate().
Root cause of v17–v36 manifold chase (20 revisions).
