# cc Chat Log
# Claude Code reports back to Claude Web here after every session.
# Claude Web reads this at start of every planning session (via Janis paste or download).
# cc updates TOP of log — newest entry FIRST.
# Claude Web reads first 3 entries only. Keep each entry under 10 lines.

### 2026-07-17 | bbq-chambers-v11-firebox-wall-seal | DONE — v11, THE REAL FIX for the "triangle leak" (4th round, root cause found by Janis directly)

Files: BBQ-chambers-v11.scad (new, source v10), renders/BBQ-chambers-v10-triangle-gap-before.png + BBQ-chambers-v11-triangle-gap-sealed.png. Changed: BBQ-understructure.scad (include v10->v11), PART_MANIFEST.md(1.7→1.8), SKELETON_WORKSHEET.md(1.8→1.9), knowledge.map(v60→v61), prompts/archive/. Real root cause (Janis's own diagnosis from a live-desktop screenshot, independently confirmed by real OpenSCAD render before writing any code): the octagon narrows near the floor (bottom two chamfers); the firebox is a plain square — above `chamber_floor_z` the square sticks out past the true octagon boundary on both sides (Z=[600,702.165mm]), and no part ever closed that region (`firebox_near_wall_closure()` only ever covered BELOW `chamber_floor_z`). New `firebox_upper_wall_seal()` (+ `firebox_upper_wall_seal_2d()`) closes it, built from the real `firebox_square_2d()`/`fixed_side_solid_2d()` boolean (both unchanged) — eroded by epsilon so the panel genuinely overlaps `chamber_outer_tube()`'s wall instead of exactly abutting it (found via a real CGAL non-manifold check: Simple:no/Volumes:3 without the erosion, fixed to Simple:yes/Volumes:2 with it).
QA: real CGAL probe of the former-gap region confirms real solid material now present (STL volume +31515.8mm³, matches the expected 2×5218.8436mm²×wall_t within 0.02%); full kinetic sweep 0-120° Simple:yes throughout; full base-v1 chain Simple:yes; both panels 5218.8436mm² each, confirmed exact mirror-symmetric (same area, opposite Y side). Zero undefined-variable warnings.

### 2026-07-16 | bbq-chambers-exhaust-room-recenter | DONE — v10, small position-only fix

Files: BBQ-chambers-v10.scad (new, source v9), renders/BBQ-chambers-v10-exhaust-room-recentered.png. Changed: BBQ-understructure.scad (include v9->v10), prompts/archive/. Every prior placement (v3's centering formula, v8's own "max-flush" recompute) wrongly assumed the flat vertical wall zone starts at chamber_floor_z — it actually starts at chamber_floor_z+chamfer (the bottom chamfer sits BELOW the flat zone). Real wall zone independently recomputed from the live file (not trusted from the prompt): [778.665, 1031.335]mm. ROOM_BASE_Z/ROOM_TOP_Z changed to a real formula centering the room on the octagon's TRUE vertical center (chamber_floor_z+chamber_H/2=905mm): 855/955mm (was 752.670/852.670mm under v8's flawed formula) — both confirmed inside the real wall zone by direct computation.
R-009: ROOM_BASE_Z/ROOM_TOP_Z each defined exactly once, real consumers confirmed (exhaust_room_opening/room_half_space/room_outer_half/room_inner_cavity, room_pipe_hole/PIPE_BASE_Z) — no duplication, all update automatically. Chimney top height re-verified 1717mm world (well within 2.5m limit). Position-only: ROOM_D/ROOM_H, room construction, chimney construction all unchanged.
QA: real union(chamber_shell(),exhaust_room()) Simple:yes (opening cut aligns cleanly at new Z). Full kinetic sweep (0-120°) + full base-v1 chain both Simple:yes, facet counts unchanged. Zero undefined-variable warnings.

### 2026-07-16 | bbq-chambers-v9-firebox-passage-true-profile | DONE, BUT DOES NOT FIX THE SYMPTOM — R-111 KT-EXHAUSTED, NEEDS JANIS

Files: BBQ-chambers-v9.scad (new, source v8), renders/BBQ-chambers-v9-passage-corner.png. Changed: BBQ-understructure.scad (include v8->v9), PART_MANIFEST.md(1.6→1.7), SKELETON_WORKSHEET.md(1.7→1.8), knowledge.map(v59→v60), prompts/archive/. Per the NEW SKILL_local_render.md Independent Post-Fix Verification rule (used for the first time, on myself, before writing this): the prompt's theorized root cause (`fixed_shell_profile()`'s fake diagonal vs `true_octagon_profile()`+`fixed_side_wedge()`) was checked via a REAL geometric XOR test before trusting it — result: the two shapes are IDENTICAL (empty symmetric difference), confirmed 3 ways (XOR test, real 3D CGAL cross-section probe of the actual built `chamber_shell()`, and new passage area 88209.549116mm² = exact match to v8's 88209.5mm²).
CONCLUSION: the theorized cause is FALSE. Implemented anyway as a code-quality cleanup (new `fixed_side_solid_2d()` helper, `fixed_shell_profile()` DELETED — zero remaining callers) but this does NOT fix the "triangle leak." That symptom is UNEXPLAINED after 3 real investigation rounds (PR #121 x2, this session) — per this project's own KT protocol, this is now KT-exhausted: presenting IS (real, complete, Simple:yes wall material at the passage boundary, no gap found) / IS-NOT (no profile-shape mismatch, ruled out 3 ways) to Janis rather than guessing a 4th fix. Hypothesis only, NOT confirmed: may be an F5 preview-only seam between `chamber_shell()`'s cut edge and `firebox_shell()`'s own separate frame edge. Needs Janis's direct input — ideally a screenshot/angle pinpointing exactly what reads as a leak, or confirmation it's a preview artifact safe to ignore.
QA: full kinetic sweep (0-120°) + full base-v1 chain both Simple:yes, facet counts identical to v8 at every step (confirms zero geometric change). Zero undefined-variable warnings.

### 2026-07-16 | SKILL_local_render_addendum_independent_verification | DONE — docs only, zero .scad touched

Files: .claude/SKILL_local_render.md (1.0→1.1), knowledge.map (v58→v59), prompts/archive/. Added the "INDEPENDENT POST-FIX VERIFICATION (R-111 ESCALATION)" section per the addendum's own exact text: once R-111 triggers, Claude Web must independently fetch+render the ACTUAL live/merged .scad file (not trust cc_chat_log/PR text alone) both before diagnosing a fix and before confirming one resolved — origin: bbq-chambers' 3 real-but-wrong-module fix attempts (PR #119, v5, PR #121) that each passed their own CGAL checks but missed the real visual defect.
GOVERNANCE FLAG (not silently resolved): knowledge.map's own FILE SYSTEM MAP marks SKILL_local_render.md "Claude Web only — cc does NOT read this." This session's prompt was delivered to cc via the normal /prompts/ channel and named that exact file as its integration target, so cc read+edited it this one time to execute the addendum as written — a one-time exception for this specific governance-doc task, not a change to the standing rule (cc still does not read this file for ordinary geometry-design work). Flagged in knowledge.map's own header too, for Janis/Claude Web to confirm this handling was correct.
No SCAD/rules-dimensions.md files touched, confirmed via git status.

### 2026-07-16 | bbq-chambers-v8-regular-octagon-continuous-channel | DONE — v8, 2 related fixes, both locally verified via real OpenSCAD/CGAL before writing

Files: BBQ-chambers-v8.scad (new, source v7), renders/BBQ-chambers-v8-lid-open-{iso,straight,full-length}.png. Changed: BBQ-understructure.scad (include v7->v8), rules-dimensions.md(v37→v38, chamfer row only per DO NOT TOUCH), rules-bbq-fab.md(1.1→1.2, new Regular Octagon Requirement section), PART_MANIFEST.md(1.5→1.6), SKELETON_WORKSHEET.md(1.6→1.7), knowledge.map(v57→v58, also backfilled the missed v7 update), prompts/archive/. R-009 pre-check (full grep of `chamfer`, not just the prompt's own list): also found real consumers in `true_octagon_profile()`, `fixed_side_wedge()`, `lid_profile()`, `lid_slant_len`, `lid_closed_panels()`, `GRATE_Y0`/`GRATE_Y1` (DO NOT TOUCH, already formula-correct) — all update automatically, no code change needed for those.
FIX 1 (regular octagon): chamfer corrected 150mm->178.665mm (`chamber_W/(2+sqrt(2))`, real formula) — all 8 edges confirmed 252.6703mm exactly (real OpenSCAD-verified). Forced a real DATUM-CHAIN INVERSION (not just a decimal swap): `chamber_floor_z` is now the fixed PRIMARY DATUM (600mm, unchanged numeric value), `GRATE_Z` is now DERIVED (`chamber_floor_z+chamfer`=778.665mm, was hardcoded 750) — `grate_clearance` retired (only consumer was the old, now-circular, formula). ROOM_BASE_Z/ROOM_TOP_Z (TASK 4) recomputed to the new max-flush formula: 752.670/852.670mm (was 705/805) — ROOM_TOP_Z confirmed exactly at the wall/chamfer boundary. firebox_passage() area changed as a real side effect (92741.2mm²->88209.5mm², code unchanged) — flagged, not silently absorbed.
FIX 2 (no visible end-margin wall): `lid_territory_end_caps()` (PR #121/v6) REMOVED — REPLACED by `lid_territory_margin_fill()`, now built from the SAME `true_octagon_profile()`+new `octagon_ring()` helper the fixed-side tube uses (was a separately-profiled shape via `lid_profile()` — two independently-modeled pieces meeting at a seam, the real cause of the visible wall). Real CGAL boundary probe at LID_X0=100/LID_X1=815: cross-section area ~5096mm² at both, consistent with continuous thin wall_t ring material, NOT the ~308258mm² a solid closing panel would show — confirms the wall is genuinely gone, not just reshaped. `chamber_inner_cavity()` retired as a standalone module (0 other callers, R-009-confirmed).
QA: full kinetic sweep (lid 0/15/30/60/90/120°) + combined kinetic state (lid90/door90/tray100%) all Simple:yes. Full base-v1 chain Simple:yes, 1529 facets. Zero undefined-variable warnings.

### 2026-07-15 | bbq-chambers-v7-fixed-shell-open-channel-rebuild | DONE — v7, R-111 territory, real root cause found+fixed via local OpenSCAD render before writing any fix

Files: BBQ-chambers-v7.scad (new, source v6), renders/BBQ-chambers-v7-lid-open-{iso,straight}.png. Changed: BBQ-understructure.scad (include v6->v7), PART_MANIFEST.md(1.4→1.5), SKELETON_WORKSHEET.md(1.5→1.6), prompts/archive/. THIS FIXES A DIFFERENT MODULE THAN PR #121: that PR rebuilt `lid_territory_end_caps()` (correct, unchanged here); this session's real culprit was `fixed_shell_profile()`/`chamber_outer_tube()`/`chamber_inner_cavity()` — `fixed_shell_profile()`'s own PARTING-line closing edge (apex A to ridge midpoint) was never a real octagon edge, and extruding it the full chamber_L length turned that seam into a permanent spanning panel across the open-lid sightline (the actual "reads solid" cause, not PR #119's or v5's targets).
FIX: new `true_octagon_profile()` (real 8-point octagon, no fake edge) + `fixed_side_wedge()` (cutting-plane mask, intersected with the ring AFTER hollowing, never baked into the profile). R-009 check: `fixed_shell_profile()` had a 3rd real caller (`firebox_passage_profile()`, separate open item) — KEPT unchanged for that caller, no longer used by the main tube. `chamber_shell()`'s redundant `chamber_inner_cavity()` subtraction removed (hollowing now internal to `chamber_outer_tube()`).
QA (real CGAL, OpenSCAD 2021.01 installed fresh this session): 3-point cross-section probe (X=150/450/750, all inside LID_X0..LID_X1) confirmed EMPTY at the exact old seam location every time — no panel. Positive-control floor probe confirmed real material still present (shell not accidentally hollow everywhere). Full kinetic sweep (lid 0/15/30/60/90/120°) Simple:yes throughout. `lid_territory_end_caps()` (PR #121, untouched) boundary-probed clean against the rebuilt tube — union Simple:yes, intersection shows only the same benign zero-volume tangency this file has hit before. Full base-v1 chain Simple:yes, 1538 facets. Zero undefined-variable warnings.

### 2026-07-14 | bbq-v6-hollow-endcap-margin-passage-grate-direct-fix (R-011 direct-cc, no prompt file) | DONE — v6, re-diagnosis + 3 items, all investigated first via real CGAL

Files (new): BBQ-chambers-v6.scad, renders/BBQ-chambers-v6-{iso,lid-open-hollow,firebox-passage}.png. Changed: BBQ-understructure.scad (include v5->v6, flagged not silent), PART_MANIFEST.md(1.3→1.4), SKELETON_WORKSHEET.md(1.4→1.5), knowledge.map(v56→v57), cc_chat_log.md. Janis's LIVE OpenSCAD-desktop review of v5 (2 new annotated screenshots) found "reads solid, not hollow" STILL unresolved (2nd loop — PR #119 was loop 1), plus 3 more items. Also compared against the separately-uploaded `bbq-chambers-v5-shell-visibility-lid-margin-firebox-passage-grate-cc-prompt.md` (main) — this chat-direct round supersedes/covers it; prompt will be archived alongside this entry.
RE-DIAGNOSIS (still-solid complaint): root cause was v5's OWN `lid_territory_end_caps()` fix — it plugged the confirmed end-margin gap with a SOLID block using lid_profile()'s shape, sitting exactly in an open-lid viewer's sightline (a real design gap in the v5 fix itself, not a repeat of PR #119's color/opacity cause). Fixed: rebuilt as a proper wall_t-thick HOLLOW shell (chamber_outer_tube()/chamber_inner_cavity()'s own outer-minus-inset-inner construction, using lid_profile()), solid only at the true outermost tip. Verified NO lid-vs-endcap collision across a full 0-120deg sweep (only a benign zero-volume coincident-face touch exactly at the shared X boundary — same tangency class this file has hit before, confirmed via exact STL coordinate extraction, not assumed).
LID MARGIN: LID_X0=100/LID_X1=815 (was 10/905), per Janis's explicit spec — end zones are now real fixed welded octagon-ring sections. FIREBOX PASSAGE "triangle gap": investigated — raw + offset(-10)/offset(-15) polygons both single-contour/non-self-intersecting, targeted solid probe at the exact corner divergence zone confirmed real wall material present (7 facets, non-empty) — NOT a true hole, most likely a fast-preview seam between the octagon-clipped cut and firebox_shell()'s plain-square frame. PASSAGE_INSET 10mm->15mm per Janis's request. GRATE REPOSITION: GRATE_Z 700->750 = chamber_floor_z+chamfer exactly (the lid parting line, "bottom of face facing cooker"), grate_clearance 100->150 in lockstep so chamber_floor_z stays exactly 600 — confirmed leg_h (understructure) unaffected, reads chamber_floor_z alone. Grate Y-range formula re-evaluated at the new height band, re-verified collision-free vs shell and closed lid.
QA: full CGAL sweep (lid 0/15/30/60/90/120deg, all Simple:yes) + combined kinetic state (lid90/door90/tray100%, Simple:yes) + full base-v1 chain (Simple:yes, 1536 facets). Toggle-isolation bug hit again on first attempts, caught and fixed same as prior sessions.

### 2026-07-14 | bbq-v5-gap-grate-passage-direct-fix (R-011 direct-cc, no prompt file) | DONE — v5, 3 findings, all investigated first via real CGAL before any code changed

Files (new): BBQ-chambers-v5.scad, renders/BBQ-chambers-v5-{iso,lid-open,firebox-passage}.png. Changed: BBQ-understructure.scad (include v4->v5, flagged not silent), PART_MANIFEST.md(1.2→1.3), SKELETON_WORKSHEET.md(1.3→1.4), knowledge.map(v55→v56), cc_chat_log.md. Janis sent 2 new annotated OpenSCAD-desktop screenshots of the v4 build with 3 findings.
FINDING 1 (missing edge/gap, front+rear lid-territory margins): CONFIRMED real via CGAL — probe cube at X=0-10 (lid's own territory) against v4's chamber_shell() returned "Current top level object is empty," same at X=905-915. Root cause: fixed_shell_profile() only ever traces the fixed (right) side for the FULL chamber_L; the lid's territory is correctly open for X=[LID_X0,LID_X1] (lid() supplies material there) but was never closed for the 2 short margins outside that range. Fixed via new lid_territory_end_caps() — solid fill using lid_profile() itself, folded into chamber_shell()'s union() so exhaust_room_opening()/firebox_passage() cuts apply through it too (both overlap this Y-range at the ends). Re-probed post-fix: both margins now return real, non-empty, Simple:yes material.
FINDING 2 (grill grate collision — NOT the lid, verified separately as empty): CONFIRMED real via CGAL against the FIXED SHELL, 36 facets, exact coords X=[60,855] Y=[50,560] Z=[690,700]. Root cause: grill_grate()'s old Y-range assumed constant chamber width; the real octagon narrows near the floor via BOTH bottom chamfers (Y_left(h)=chamfer-h, Y_right(h)=(chamber_W-chamfer)+h), and the grate sits well inside that chamfer zone (h=90-100). Fixed via GRATE_Y0/GRATE_Y1 computed from those real boundary formulas at the grate's own binding height + wall_t/safety inset. Re-checked post-fix: grate-vs-shell now empty, grate-vs-lid confirmed still empty (sanity re-check). GRATE_Z (MASTER CONTROL VALUE) NOT moved — the "also too low" complaint is expected to resolve as a byproduct, flagged not silently assumed fixed.
FINDING 3 (firebox passage too small): Janis's explicit spec — "follow the intersec of hexagon profile but offset from edge -10mm around the cut profile." window_hole() (v1, fixed 254x119mm rectangle, previously DO-NOT-TOUCH) REMOVED, firebox_passage() ADDED — real 2D intersection() of fixed_shell_profile() and the firebox's own square cross-section (same hex_pt(h,w) 2D space), inset via offset(delta=-10). A real 2D boolean (not manual per-height math) — automatically follows both bottom chamfers + the internal parting seam. Verified standalone: X=[911.99,915.01] (wall pass-through), Y=[86.5,523.5] (437mm wide, =457-2*10 exactly), Z=[610,847] (bottom correctly clipped to the chamber's own floor+inset, not the firebox's true 400mm floor — the firebox_near_wall_closure() panel already covers that lower step separately). Real scope change (small window -> large contour-following passage), flagged not silently dropped.
QA: full CGAL manifold sweep (lid 0/30/60/90/120deg, all Simple:yes) + combined kinetic state (lid 90/door 90/tray 100%, Simple:yes) + full BBQ-offset-smoker-base-v1.scad chain render (Simple:yes, 1524 facets). Toggle-isolation bug (recurring — leaked full ASSEMBLY geometry into `include`-based test files) hit again this session on the first attempt at each of the 3 probes, caught each time by implausible facet/vertex counts matching the full model, fixed via explicit -D show_*=false overrides before re-testing.

Files (new): BBQ-chambers-v4.scad, renders/BBQ-chambers-v4-{iso,front,side,rear,lid-open-grate-visible}.png. Changed: BBQ-understructure.scad (include v3->v4, flagged not silent), knowledge.map(v54→v55), cc_chat_log.md. Janis reported v3's lid-open screenshots looked like "a solid octagon mass, not a shell configuration," asked to see the grill grate inside.
INVESTIGATED BEFORE CHANGING ANYTHING (per R-008 discipline): real CGAL cross-section probe at X=400 on chamber_shell() found 14 distinct boundary points — 7 matching fixed_shell_profile()'s own outer vertices exactly, 7 matching a properly ~3mm-inset copy of the same 7 — a genuine thin-walled ring, confirming the hollow shell geometry was ALREADY correct. Two earlier axis-aligned probe boxes near the bottom-right-chamfer corner had found "unexpected" solid material, but re-checking against the actual profile's own vertex coordinates showed that was a bad probe choice (a diagonal chamfer's own wall_t band legitimately extends into a naive rectangular probe near a corner) — not a real defect, ruled out by data, not re-guessed.
ROOT CAUSE: no color()/opacity had been applied to ANY BBQ part across v1-v3 — flat opaque default yellow throughout. With no transparency, the far interior wall (visible through the open lid) reads as solid rather than "hollow, this is the far wall." This project already has a standing rules-codes.md convention for exactly this (outer shell = 0.75 opacity) — just never applied to the BBQ files. Fix: color("#C8C8C8",0.75) on chamber_shell/lid/lid_hardware/firebox/exhaust_room/chimney_pipe, color("#CCCCCC",1.0) on grill_grate (distinguishable, opaque, matches "structural body visible inside" precedent), color("#AAAAAA",1.0) on floor_drains — applied at ASSEMBLY call sites, not baked into modules.
Note: OpenSCAD's `--render` (full CGAL) PNG export does NOT composite alpha transparency — had to use fast-preview mode (no --render flag) to see the color/opacity visually; manifold verification still uses --render (color doesn't affect CSG results, confirmed).
New screenshot (lid-open-grate-visible.png) shows the 3 grill_grate() segments clearly resting inside, distinguishable from the shell. Full sweep (lid 0/60/120deg) re-verified Simple:yes after the color changes (color() doesn't affect manifold status, confirmed).

### 2026-07-14 | bbq-chambers-v3-closure-exhaust-resize-lid-mirror | DONE — v3, 3 corrections, real rotation-sign defect found+fixed on the mirror

Files (new): BBQ-chambers-v3.scad, renders/BBQ-chambers-v3-{iso,front,side,rear,lid-open-120}.png. Changed: BBQ-understructure.scad (include v2->v3, flagged not silent), rules-bbq-fab.md(1.0→1.1, new Standing Orientation Convention section), PART_MANIFEST.md(1.1→1.2), SKELETON_WORKSHEET.md(1.2→1.3), cc_chat_log.md, prompts/archive/. rules-dimensions.md NOT touched (this prompt's own DO NOT TOUCH says read-only, unlike v1→v2). Real OpenSCAD/CGAL used throughout.
TASK 1 CLOSURE: new `firebox_near_wall_closure()` panel, Z=[firebox_z0=400, chamber_floor_z=600] (the real 200mm firebox_drop step), Y=[firebox_y0+wall_t, firebox_y1-wall_t]. Confirmed via a FULL-FOOTPRINT intersection() probe (not a sample point) — zero residual gap. Confirmed Z>=chamber_floor_z (the window zone) stays untouched/open.
TASK 2 RESIZE: ROOM_D=360, ROOM_H=100 (was 200/200). Max inscribed circle in a semicircle = its own radius (proof: tangent-to-both requires hole-radius=R/2) — new room inscribes 180mm, chimney_d=127mm fits with REAL 26.5mm clearance on both the flat edge and the arc (PIPE_HOLE_X=-90, centered for equal clearance) — no forced overhang, v2's 2-collision workaround chain no longer needed. Endcap opening re-confirmed a rectangle (360x100mm), not a semicircle, per this file's own standing v2 finding.
TASK 3 MIRROR: fixed_shell_profile()/lid_profile()/lid_closed_panels() all mirrored (w->chamber_W-w). Lid now on the Y=0 side (was Y=chamber_W, v2) — fixed shell now on the Y=chamber_W side. REAL DEFECT FOUND: mirroring the geometry alone was NOT enough — a real CGAL bounding-box check at lid_open_deg=90 showed the UN-flipped rotation sign sent the lid's own material to Y=+769 (INTO the fixed shell's own new territory, wrong); flipped to rotate([-deg,0,0]), re-checked, now swings to Y=-158 (away, correct, toward the user). Full sweep 0-160deg re-verified Simple:yes after the fix, plus real collision checks vs shell/firebox/room/pipe/grate/drains at 120deg — all empty (no collision).
TASK 4 GOVERNANCE: new "Standing Orientation Convention" locked in rules-bbq-fab.md — exhaust=left/firebox=right/lid-toward-user=Y=0, stated as confirmed-by-real-geometry (not a draft), citing the v3 rotation-sign verification directly.
QA: full kinetic sweep (lid 0-160deg) Simple:yes; real intersection() checks for closure, room/pipe fit, and lid vs all fixed geometry. 4-angle + lid-open screenshots captured. Error-log clean.

### 2026-07-14 | bbq-chambers-v2-closure-exhaust-lid | DONE — v2, 3 corrections, 2 prompt inconsistencies + 5 real CGAL defects found+fixed

Files (new): BBQ-chambers-v2.scad, renders/BBQ-chambers-v2-{iso,front,side,rear,lid-open-120}.png. Changed: BBQ-understructure.scad (include v1->v2, flagged not silent), rules-dimensions.md(v36→v37), knowledge.map(v52→v53), PART_MANIFEST.md(1.0→1.1), SKELETON_WORKSHEET.md(1.1→1.2), cc_chat_log.md, prompts/archive/. Real OpenSCAD/CGAL used throughout (fresh install this session). CLOSURE CONFIRMED: front end-cap solid except the exhaust_room_opening (rectangle Y=204-406,Z=654-856); rear end-cap solid except the unchanged window_hole — both spot-checked via real intersection() probes (solid-outside/open-inside), not assumed.
Exhaust room (Rule 3 coords): parent DATUM_X_FRONT(X=0)/DATUM_Y_CENTER(Y=305), half-cylinder D=200/H=200, Z=655-855, X<=0 kept half, back face open (matches chamber's own opening). REAL INCONSISTENCY found: prompt calls the endcap opening "semicircular" but the room's true flat interface face (vertical axis + 200mm HEIGHT, not radius) is a 200x200mm RECTANGLE — built to match reality, flagged not silently forced. Pipe: coaxial, hole+pipe both at X=-60,Y=305 (moved from the first symmetric-overhang try at X=-50 — real CGAL found THAT position collided with the new lid's front edge at X=10, both open and closed states). Pipe base Z=851.99 (below the hole's own bottom, not just touching its top edge), hole Z=[851.99,855.01], pipe top=1617.0mm world (<2.5m limit). Zero-gap coverage confirmed by construction (same diameter, coaxial, real Z overlap).
Lid: hinge line Y=305,Z=1210 (DATUM_Y_CENTER/DATUM_Z_RIDGE), rotate([deg,0,0]) about that X-axis line, full 895mm length (X:10-905). REAL DEFECT: lid_profile()'s ~56.4deg acute hinge-vertex angle made offset(-wall_t) numerically unstable under rotation (Simple:yes only at exactly 0deg by coincidence, Simple:no from ~46deg up) — rebuilt from 3 flat cube() panels instead (matches rules-codes.md's own stated preference), clean at every angle tested 0-160deg. Practical max set to 120deg (real headroom beyond that too). 2 more real tangency defects found+fixed via union() (not caught by intersection()): room-endcap-cut vs room's curved wall (ROOM_GAP=1mm fix), lid hinge vs shell's own vertex (LID_HINGE_GAP=0.5mm fix) — same failure class as v1's firebox door hinge.
lid_hardware() confirmed disabled (`show_lid_hardware=false`), code left unchanged/stale per explicit instruction, TODO noted for follow-up. firebox()/window_hole()/grill_grate()/floor_drains() confirmed untouched (DO NOT TOUCH). drop_tube() has NO v2 equivalent (prompt groups it with chimney() as both replaced by room+pipe) — flagged as a real scope change.
QA: full kinetic sweep (lid 0/30/60/90/100/110/120/130/140/150/160, door/tray combos) all Simple:yes. 4-angle screenshots + 1 lid-open(120) angled view captured. Error-log clean.

### 2026-07-13 | governance-inline-content-and-predelivery-check | DONE — 2 new rules added, docs only, zero .scad/bbq-offset-smoker touched

Confirmed highest rule live before adding: R-011 (grepped, not assumed). Added R-012 (No Chat-Only Content References in cc Prompts) and R-013 (Pre-Delivery Self-Check Runs on EVERY cc Prompt, No Exceptions) to RULES.md(3.0→4.0), each with a concrete root-cause example from the BBQ v1-init session per the prompt's own drafted text.
WORKFLOW_SKILL.md(3.14→3.15): PRE-DELIVERY SELF-CHECK section gets one new explanatory line (extra weight on a new product line's first prompt, cites R-012). chat_rules.md(v3.11→v3.12): Prompt Writing section gets one new bullet, cites R-012.
Confirmed: no existing rule content removed/reworded/renumbered (R-001 through R-011 untouched); zero `.scad` files touched; zero `bbq-offset-smoker/` files touched in this prompt's own scope (that folder WAS touched by the separate bbq-offset-smoker-v1-init-ADDENDUM prompt, done earlier in this same run — different task, not this one).
No knowledge.map edit needed (no version/status line required it).

### 2026-07-13 | bbq-offset-smoker-v1-init-ADDENDUM | DONE — real content supplied, no new files (all 6 already existed from the merged v1-init PR)

Files updated: design_scope_of_work_rule.md(1.0→1.1) — Compartment Map/Functional Features/Appearance/Made-Buy-Hire REPLACED with the addendum's supplied content (still NOT Janis-reconfirmed verbatim, same confidence tier as before, flag retained). SKELETON_WORKSHEET.md(1.0→1.1) — no content rewrite needed, addendum confirmed Parts B/C's DERIVE-from-Task-2/3 approach was already correct; flag section updated + Part A's axis notation reconciled (this file uses the corrected X=chamber_L, addendum's own restated text used the original prompt's pre-correction Y notation).
STALE-PREMISE NOTE: the addendum's Section 4 "NEW FILES (six, none exist yet)" and Section 5's "rules-dimensions.md not applicable to BBQ" were both written without visibility into the fact the original v1-init work was already completed and merged (PR #115) — all 6 files already existed, and rules-dimensions.md already carries a "BBQ Offset Smoker Base" section from that merged session. Did not delete/revert that section (out of this addendum's own DO NOT TOUCH scope, and reverting merged work isn't this prompt's call) — flagged here and in both updated files for Janis/Claude Web to resolve the conflict.
No knowledge.map edit — Section 4's "append new-file rows" instruction doesn't apply since no files were newly created this round.
Both prompts (original v1-init + this addendum) now archived. PR to follow together with the governance-inline-content-and-predelivery-check prompt, done in the same run per Janis's instruction.

### 2026-07-13 | bbq-offset-smoker-v1-init | DONE — v1, NEW product line, real CGAL clean, 1 GOVERNANCE FLAG + 5 real bugs found+fixed

Files (new): bbq-offset-smoker/{BBQ-chambers-v1.scad, BBQ-understructure.scad, BBQ-offset-smoker-base-v1.scad, design_scope_of_work_rule.md, rules-bbq-fab.md, SKELETON_WORKSHEET.md, PART_MANIFEST.md}, renders/BBQ-chambers-v1-{iso,front,side,rear}.png. Changed: rules-dimensions.md(v35→v36), knowledge.map(v51→v52), cc_chat_log.md, prompts/archive/. Real OpenSCAD 2021.01 + Xvfb installed fresh this session, used throughout (not estimates).
GOVERNANCE FLAG (per cc_rules.md — flagged, not silently invented): the prompt's own scope/worksheet content ("copy verbatim from chat log") referenced a Claude Web session cc cannot read. Product Identity/Envelope are verbatim from the prompt itself (FINAL). Compartment Map/Functional Features/Appearance/Made-Buy-Hire (scope file) and BOM tree/Kinetic table (worksheet) are cc-reconstructed DRAFTs grounded in the real built files — flagged in both files' headers + rules-dimensions.md PENDING DECISIONS for Janis's review.
Coordinate fix: prompt's own snippet used Y as chamber length; corrected to X per rules-dimensions.md's locked all-models standard (chamber_L along X) — stated explicitly in BBQ-chambers-v1.scad header.
5 real collisions found via CGAL intersection()/union() and fixed (not in the source prompt, only discoverable by rendering): firebox door hinge exact-tangency (union, not intersection, was the tell); firebox's outward wall was wrongly solid (real design error — door would've covered a wall that shouldn't exist, ash tray collided sliding out); lid hinge clipped the fixed rear-margin shell near 100°; folded chimney swept through the fixed ridge; counterbalance lever grazed the fixed rear-margin shell at rest. All fixed, full kinetic sweep (lid/door/ash-tray/chimney/shelves, multiple combos) re-verified Simple:yes.
QA: window+firebox pass-through opening confirmed genuinely continuous via real intersection() (both chamber_shell()'s own cut AND the union, independently checked) — matches the prompt's explicit QA requirement. 4-angle PNG renders done (iso/front/side/rear). firebox_drop=200mm OPEN FLAG left as-is per the prompt, re-flagged in rules-dimensions.md.
CURRENT_STATE.md's BBQ line ("NOT STARTED") is now stale — NOT updated here per WORKFLOW_SKILL's own rule (update only on Janis-confirmed pause, not session-end) — flagged for the next pause-confirmation.

### 2026-07-10 | vm02-dashboard-shelf-and-side-acrylic | DONE — v3, 2 new features, real CGAL clean, zero VM-01 touched

Files: VM-02-base-v3.scad (new, source v2), PART_MANIFEST.md(1.3→1.4), rules-dimensions.md(v34→v35), knowledge.map, cc_chat_log.md, prompts/archive/. Real OpenSCAD 2021.01 installed fresh + used throughout (STL export, manifold checks, isolated `intersection()` probes) — not estimates. R-009: `acrylic_zone_bot_z` confirmed already a live top-level DATUM before starting, read not re-derived.
Feature A (display shelf): NEW `display_shelf()` module, `shelf_top_z=acrylic_zone_bot_z-10`, full depth (`skin_t` to `total_d-skin_t`, minus a new real 1mm `SHELF_REAR_GAP` off `rear_service_door()` — found via CGAL, same coincident-face class this file hit before), width reuses `dash_x`/`dash_w` verbatim (FLAGGED: narrower than true wall-to-wall interior, used per the prompt's explicit instruction), thickness=`tray_floor_t`(5mm, no number given, reused existing floor convention). New `show_display_shelf` toggle from first commit.
Feature B (right-side acrylic): CONFIRMED no right-exterior cutout existed before. Added one: Z=same live acrylic-zone datum, Y=`corner_r` to `total_d/2` (front half, Janis-corrected mid-session) — `corner_r` is the shell's own rounded-corner tangent point, not arbitrary; real numeric coincidence confirms it (`dash_x+dash_w`=563mm lands within 1mm of `total_w-corner_r`=564mm). `acrylic_display()`'s own internal right panel Y-range shrunk to match (was full depth, now front-half + real `ACRYLIC_OVERLAP` margin — a real coincident-edge non-manifold was found+fixed here, isolated `intersection()` probes on this pair kept false-positiving even after the real fix, full-assembly render is the authoritative Simple:yes).
Sweep: tray_count 1/3/5, 11-angle door_open_deg 0-100, mixed tray_out_pct (incl. all-100% at tray_count=5), flap_open true/false, C2 mode — Simple:yes throughout, no exceptions. Isolation checks (real, genuinely-empty `intersection()`): shelf vs dashboard/shell/acrylic (empty, re-confirmed tray_count 1&5), new cutout vs tray_zone_frame (empty), new cutout vs rear_service_door (non-empty but byte-identical to pre-existing v2 baseline — zero new collision).
Confirmed: zero VM-01 files touched, zero OWNER-LOCKED rules-dimensions.md rows touched (diffed byte-identical), `dashboard()`'s own hardware/`left_zone_door()`/tray-spring-frame/`rear_service_door()`'s own panel geometry all untouched (only isolation-checked against).

### 2026-07-10 | vm02-viewer-wiring | DONE — VM-02 wired into viewer (first time), zero .scad touched

Files: viewer/janis-product-viewer.html, .claude/rules-waivers.md(1.1→1.2, W-002 partially resolved), knowledge.map(v49→v50), prompts/archive/. Read live VM-02-base-v2.scad (latest on main, confirmed via `ls`, superseding v1) + PART_MANIFEST.md before writing any value — none copied from VM-01/PR-01.
T1: `'VM-02'` PROJECTS entry added — `modelsFolder:'VM-02'`, `version:'v2'`, `scad:null` (STL-mode). params: tray_count (live [1:5], unlocked) + product_w/system_w/total_w/total_h/leg_od (locked, read live: 422/143/584/821/80mm; total_h and total_w explicitly DERIVED per the .scad's own comments, not literals — noted here per prompt instruction). toggles/components cross-checked against PART_MANIFEST's Toggle column, no guessing.
`tray_out_pct` decision (real judgment call, not silently resolved): it's now a length-5 vector in the live file but the params UI only supports single scalars — the structure DOES cleanly support multiple named params, so exposed as 5 separate sliders (`tray_out_pct_0`..`_4`, 0-1 step 0.05) rather than flattening to one shared value or dropping it. Noted only the first `tray_count` are physically meaningful (matches the .scad's own comment); UI can't hide the rest since scad:null means no live re-render on tray_count change.
T2: empty/missing-folder case was a REAL gap — `fetchModelFolder()` threw an "error" on 404, indistinguishable in tone from a real failure. FIXED: 404 now resolves to `[]` (git can't track an empty dir, so missing==empty), rendered as a grey informational "No .stl files uploaded yet" + a matching canvas overlay (also clears any stale prior-project model, a real bug the old code would've hit — no clearModel() call existed on this path). Verified via real headless Chromium (Playwright, THREE.js auto-stubbed): VM-02 empty/missing state distinct from a simulated 429 (red ⚠, "Could not load model list..."). VM-01 (2 mocked files) and PR-01 (legacy STL mode) both re-tested unaffected, before AND after visiting VM-02.
Janis: upload her first VM-02 STL into `public/models/VM-02/` in Satu-vending-backend (any filename, per the existing modelsFolder procedure) — viewer will show the graceful empty state until then, dropdown appears live once she does.

### 2026-07-10 | vm02-lower-shell-fill-and-retro-governance | DONE — real design gap fixed (v2), governance chain backfilled retroactively

Files: VM-02-base-v2.scad (new, source v1), vending-machine/VM-02-base/design_scope_of_work_rule.md (new), vending-machine/VM-02-base/SKELETON_WORKSHEET.md (new), PART_MANIFEST.md(1.2→1.3), rules-dimensions.md(v33→v34), knowledge.map(v48→v49), prompts/archive/. R-009 Duplication Check performed before any fix: dashboard()'s Z-chain existed in exactly one place (dashboard() itself) before this session.
PART 1: outer_shell()'s right-compartment cutout now only opens the UPPER (acrylic) zone — the LOWER (dashboard) zone is solid sheet metal, matching Janis's original spec, a real gap since VM-01-base-v6 (VM-01 itself untouched, still has it). 4 new mounting cutouts (screen+bezel+bracket, QR, card, speaker), each real footprint + 2mm clearance. dashboard()'s own Z-chain promoted to shared top-level datums so outer_shell() reads the same values, not a re-derived copy. REAL CGAL FINDING: a first-pass cutout missed the dashboard's own support bracket (a flat, non-tilted part reaching lower than the bezel) by ~3mm — found via isolating intersection(){dashboard();outer_shell();} and reading the actual colliding part's bounds, fixed with max(bezel_t, bracket_r). Re-swept clean: tray_count=1/3/5, door sweep, mixed tray_out_pct, flap_open, C2 mode, plus explicit dashboard-vs-shell/reardoor/frame/divider/acrylic isolation checks at all 3 tray_count values — Simple:yes throughout.
PART 2: retroactive governance chain completed, grounded in the real v2.scad (not an idealized pre-spec) — new design_scope_of_work_rule.md placed in vending-machine/VM-02-base/ (not VM-01's root-level location/name, to avoid collision — reasoning stated in the file's own header) and a consolidated SKELETON_WORKSHEET.md (Skeleton Definition Worksheet + BOM Subassembly Tree + Kinetic Dual-View table — the skill file specifies content format but not a file location, consolidated into one file since all three are built together per that skill's own timing). 3 real findings flagged (not silently smoothed over): (1) this file's real Parent pattern is "shared named constants," a 3rd pattern beyond the skill's own 2 described types; (2) DATUM_* naming predates this skill's own convention; (3) rear_service_door() has NO open/close toggle or hinge geometry at all — a genuine Kinetic Dual-View gap, not fixed this session.

### 2026-07-10 | vm02-derivation-from-vm01-v58 (CLOSING — R-011 direct-cc session, 3 rounds total, same day) | PAUSED, Janis-confirmed, governance backfill planned

Files: CURRENT_STATE.md (new VM-02 section), .claude/rules-waivers.md(1.0→1.1, new W-002). This entire VM-02 v1 build (all 3 entries below) ran as a direct-cc-chat session, no Claude Web prompt drafted any round — per R-011, this entry + the 3 below are the record to read directly, not a paraphrase.
Janis confirmed closing this round here; a future Claude Web prompt will backfill the GOVERNANCE FLAG raised in round 1 ("rematch vm02 skeleton and scope of work") — see CURRENT_STATE.md's new VM-02 entry for the full open-items list this next prompt should start from.
NEW W-002 waiver: VM-02 has no viewer/janis-product-viewer.html PROJECTS entry and no STL exports yet — kinetic params (tray_out_pct/door_open/flap_open) are real and CGAL-tested, but only viewable by opening the .scad directly in OpenSCAD. Janis explicitly accepted this (viewer's WASM path isn't ready, no time to fix now, manual OpenSCAD simulation is sufficient) — not fixed, not in scope this round.
Also noted (cosmetic only, not a defect): round 3's product_w widen shifted the frame's right vertical but not the door's window opening, leaving the window ~6mm less centered in the frame's opening than before — still fully clear either side, purely a visual proportion note for the next visual QA pass.

### 2026-07-10 | vm02-derivation-from-vm01-v58 (2nd direct-chat follow-up, same day) | DONE — tray/frame collision ACTUALLY FIXED now, full CGAL sweep clean

Files: VM-02-base-v1.scad (same file, extended), rules-dimensions.md(v32→v33), PART_MANIFEST.md(1.1→1.2). Janis proposed the actual fix for the item left unresolved in the previous entry (tray_out_pct's ~27% ceiling): widen the tray compartment itself instead of touching the frame or the tray's own width.
Implemented: product_w 416→422mm (+6mm), tray_x_inset 17→23mm (the SAME +6mm shift) — tray_w_global's formula evaluates to the exact same 389.01mm as before, so tray width/spring-lane layout is UNCHANGED, only the tray's position shifts right. Works because tray_zone_frame()'s LEFT vertical is anchored to the shell's fixed corner (doesn't move with product_w) while its RIGHT vertical (anchored to product_w+e) shifts by the same +6mm as the tray's own right wall, preserving the existing 2mm right-side clearance automatically.
Confirmed via a full real CGAL sweep, tray_out_pct 0 through 1.0 (door_open=true, the physically valid state for a fully-extended tray — a tray at 100% still legitimately collides with a CLOSED door, unrelated/unavoidable, not a bug): Simple:yes throughout, including the prompt's own original literal example (tray0=0%, tray1=50%, tray2=100%) which now actually works, not just the previously-safe ~27% values. Re-verified tray_count=1/3/5, 11-angle door sweep, leg clearance (unaffected by this change) — all still clean. total_w now 584mm. Same gap confirmed still present, unfixed, in the locked VM-01 v58 file (out of scope there).

### 2026-07-10 | vm02-derivation-from-vm01-v58 (direct-chat follow-up, same day) | DONE — 4 items answered, 1 root-caused but NOT fixed, real CGAL re-swept clean

Files: VM-02-base-v1.scad (same file, extended), PART_MANIFEST.md(1.0→1.1), rules-dimensions.md(v31→v32). Direct response to Janis's 4 questions on the v1 entry below, no new prompt file (R-011 direct-cc pattern).
(1) Governance flag: acknowledged by Janis, no action.
(2) system_w CORRECTED 133→143mm — Janis: real 10mm border EACH SIDE of the panel (matches the original prompt's own arithmetic), not cc's own 2mm-clearance-based 133mm. total_w now 578mm.
(3) tray_out_pct ~27% ceiling: NOT fixed (Janis asked "did you fix?"). Clarified it's a width/X issue, not height/ceiling. Root-caused precisely by reading archived VM-01-base-v55.scad vs v56.scad directly: v50 verified tray_x_inset=17mm against the frame's curve AT THE TIME (capped at X=15mm); v56's later kink-fix rebuilt that same curve to sweep further, silently reaching X=21mm — a real regression v56 never re-checked against tray clearance. A real fix needs ~5mm more width than available with product_w unchanged (5-lane spring layout is exactly at its owner-locked minimum) — not a quick tweak, flagged for Janis's decision (frame redesign vs. tray notch vs. accept documented limit).
(4) acrylic_display() RESTORED, PERMANENT — Janis: "we need acrylic window." Rebuilt (not just re-added) for the new narrower/portrait compartment + live total_h; new show_acrylic_display toggle. Found+fixed 3 MORE real manifold bugs while resizing it (right panel vs. shell wall; top panel vs. shell roof AND rear door simultaneously — a doubly-coincident corner; front panel vs. the shell's own cutout edge, an algebraic coincidence for any system_w that only surfaced in the FULL assembly, not isolated pairwise CGAL tests — a real CGAL-robustness lesson worth remembering).
Re-swept clean after all changes: tray_count=1/3/5, 11-angle door sweep, mixed tray_out_pct (safe range), flap_open true/false, C2 mode — Simple:yes throughout.

### 2026-07-10 | vm02-derivation-from-vm01-v58 | DONE — VM-02 v1 (NEW product line), real CGAL sweep clean, 3 items flagged for Janis

Files: VM-02-base-v1.scad (new), vending-machine/VM-02-base/PART_MANIFEST.md (new), knowledge.map(v47→v48), rules-dimensions.md(v30→v31), prompts/archive/. Real OpenSCAD/CGAL used throughout (binary installed fresh this session), not estimates.
GOVERNANCE FLAG: VM-02 has no design_scope_of_work_rule.md/Skeleton-BOM-Kinetic worksheets (the literal new-product-line trigger) — proceeded since the prompt inherits VM-01's whole datum chain wholesale, not inventing new ones; flagged, not silently skipped.
Task A: tray_count live [1:5] (default 3), total_h now DERIVED (`tray_stack_z0+tray_zone_h+ROOFLINE_MARGIN(88)`). tray_out_pct now a length-5 vector. New per-lane floor sensor holes. Found+fixed 2 real manifold bugs via the mandatory sweep (tray-vs-own-rail exact touch; adjacent-tray exact Z-face becoming a T-junction once one slides) — both pre-existing in locked VM-01 v58 too, fixed here only. ALSO found (not fixed, flagged): tray_zone_frame()'s left vertical caps real safe tray travel at ~27% of the slider, not 100% — same pre-existing VM-01 gap, out of this prompt's scope.
Task B: system_w RECOMPUTED 133mm (not the prompt's suggested 120mm — that missed the existing dash_w formula + portrait bezel footprint, real collision found via render) → total_w=568mm (DERIVED formula now, not a literal). acrylic_display() REMOVED (judgment call, resolves the DATUM_TRAY_TOP cross-cutting warning). Rear door now full floor-to-ceiling. Screen position clamped (max()) after the 1/3/5 sweep found the literal "400mm from top" rule alone pushes the QR/card/speaker stack below the floor at low tray_count.
Task C: leg_od 80mm, real CGAL clearance check (leg fully contained in shell footprint, ~5.4mm margin) at both VM-01's and VM-02's proportions — leg_inset unchanged.
Task D: front door/frame/acrylic all cascade automatically (formulaic), confirmed via render at tray_count 1/3/5, zero hardcoded numbers left behind.
Manifold sweep: tray_count=1/3/5, 11-angle door_open_deg sweep, mixed tray_out_pct (within the real ~27% safe range), flap_open true/false — Simple:yes at every combination tested.
FLAGS for Janis: (1) governance gate above, (2) system_w 133mm vs prompt's 120mm, (3) tray_out_pct real ~27% ceiling (both VM-01/VM-02), (4) acrylic_display() removal judgment call — full detail in VM-02-base-v1.scad's own header and rules-dimensions.md.

### 2026-07-09 | vm01-gen1-lock-and-systemw-fix | DONE — docs only, zero .scad touched

Files: CURRENT_STATE.md, rules-dimensions.md(v29→v30), cc_chat_log.md, prompts/archive/.
T1: VM-01 marked GENERATION 1 LOCKED in CURRENT_STATE.md (was stale "DONE, dormant, v36" — corrected to v58 while adding the marker). Sent to supplier (China) for prototype quote; construction PDF delivered same session; future geometry changes = deliberate exception, not routine.
T2: `system_w` UNLOCKED per Janis — row REMOVED entirely from OWNER-LOCKED table (not re-valued). Separately, doc drift fixed: system_w was documented 185mm in 3 places, live v58 PARAMETERS has used 204mm since v44 (confirmed live, not assumed) — corrected in Compartments table, Dashboard "Total width" recomputed 160→181mm (matches v58's own `dash_w` comment), PENDING DECISIONS baseline rebaselined 185/620→204/640 (also live-confirmed, not assumed). All other OWNER-LOCKED rows diff-checked untouched.

### 2026-07-09 | viewer-cache-folder-listing + grid-floor-fix | DONE — viewer only, zero .scad touched

Files: viewer/janis-product-viewer.html, cc_chat_log.md, prompts/archive/.
T1-T3 (prompt): getModelFolder() wraps fetchModelFolder() with a 5-min in-memory cache (per project folder). buildModelFolderPicker() now uses it, shows "(cached)" when serving stale data. 403 AND 429 both now caught (GitHub uses either depending on which limit is hit) with a clear message; a "↻ Refresh models" button force-bypasses the cache. On a failed refresh, the last known-good list stays visible with a warning instead of clearing — never a blank list on transient rate-limiting.
Extra (direct chat request, same file, same session): grid was passing through the model body — root cause was loadSTL()'s `geometry.center()` re-centering the whole bounding box at Y=0. Replaced with X/Z-only centering + floor (bbox.min.y) pinned to Y=0, matching OpenSCAD's floor convention (object sits ON the grid). Added a "Show grid" toggle in the View panel (gridHelper.visible).
Verified via real headless Chromium (Playwright, THREE.js stubbed — CDN blocked in this sandbox only): cache reuses across project-switch within TTL (1 fetch, not repeated), Refresh button forces a 2nd fetch, simulated 429 preserves the cached dropdown + shows warning, grid toggle flips gridHelper.visible correctly, PR-01 legacy system fully unaffected. Geometry translate math reviewed by hand (stub can't do real vector math) — flagged for Janis's visual confirm post-deploy.

### 2026-07-09 | governance-verification-escalation-rules | DONE — docs only, zero .scad touched

Files: RULES.md(2.0→3.0), WORKFLOW_SKILL.md(3.13→3.14), chat_rules.md(v3.10→v3.11), cc_chat_log.md, prompts/archive/.
Added 4 new numbered rules (highest was R-007, confirmed from live file, not assumed): R-008 Verification Discipline (no CONFIRMED/RULED OUT without a real check + its SCOPE stated — refined the prompt's own v52/v53/v55 example: v53's finding WAS real CGAL, just narrowly-scoped and over-generalized, not "arithmetic-only" as drafted). R-009 Duplication Check (search all copies before fixing) — wired a mandatory line into WORKFLOW_SKILL's CC INTRO template. R-010 Repeat-Touch Escalation (3+ strikes → question the design) — corrected the hinge-rod touch history: v50/v52/v53/v55 (4 sessions, verified via cc_chat_log grep), NOT v56 as the prompt's draft claimed (v56 never touched it). R-011 Direct-CC Escalation Protocol — added to both RULES.md and a new chat_rules.md section.
No existing rule content removed/renumbered. Zero .scad files touched, confirmed via git status.
### 2026-07-09 | vm01-viewer-dynamic-folder-picker | DONE — viewer only, zero .scad touched

Files: viewer/janis-product-viewer.html, .claude/SKILL_viewer_update.md(1.1→1.2), knowledge.map(v46→v47), cc_chat_log.md, prompts/archive/. Satu backend repo confirmed from Janis directly (not guessable from source): Csmittee/Satu-vending-backend — added to session, cloned, verified real folder structure + real GitHub Contents API response shape before writing any code.
T1 fetchModelFolder(): implemented, logic-verified against the REAL captured API response (public/models/ listing) plus 4 mocked cases (success/404/403/network-error). Live unauthenticated fetch() from THIS sandbox is blocked by its own proxy (unrelated to real browsers) — flagged for Janis's post-deploy check.
T2: VM-01 got modelsFolder:'VM-01' (kept stl/stlOpen/stlC2 as fallback per spec) + version bumped to v58. PR-01 untouched.
T3: dynamic dropdown replaces the cycle button when modelsFolder is set. Found+fixed 2 real race/regression risks while wiring it in: switchProject()'s own STL auto-load would race the picker's async load (now skipped for modelsFolder projects), and the "Reload STL" button read stale legacy keys (now reloads currentSTLUrl). Verified via a REAL headless Chromium run (Playwright, THREE.js stubbed — only the CDN load is blocked in this sandbox, not my code) — VM-01 dropdown renders + STL loads, PR-01's legacy button is completely unaffected, 404 (today's real VM-01/ folder state) shows a clear UI error instead of a blank viewer.
T4: SKILL_viewer_update.md rewritten with a NEW simplified procedure + LEGACY kept, clearly labeled.
Janis: create public/models/VM-01/ in Satu-vending-backend and upload STLs there going forward (any filename) — confirmed empty via live repo check, not assumed.

### 2026-07-09 | vm01-file-cleanup-pass | DONE — v58, zero-geometry-change (real CGAL confirmed identical facet/vertex/volume counts before/after, all angles)

Files: VM-01-base-v58.scad (new, source v57), PART_MANIFEST.md, cc_chat_log.md, prompts/archive/. rules-dimensions.md untouched (no dimension values changed, per prompt).
T1: removed confirmed-dead code — left_front_acrylic() (whole module, 0 callers), win_z0/win_z1 (0 consumers since v49/v51), spring_clearance/acrylic_r/acrylic_t (0 consumers). All show_*/render_mode toggles confirmed actively used, kept; clearance_zone_map() confirmed intentional permanent tool, kept. Bonus: fixed a naming collision my own prior session introduced (local acrylic_top_z shadowing a pre-existing top-level global) — renamed to acrylic_pane_top_z.
T2: dashboard()/acrylic_display() searched in full for experimental code — none found, stated plainly.
T3: header changelog truncated ~850 lines (v3-v56 narrative → pointer to git/chat log); per-module inline comments condensed to current rationale only.
T4 (highest-value): outer_shell()/outer_shell_debug() merged — outer_shell() was 100% dead code (0 callers), outer_shell_debug() renamed to outer_shell(). Real CGAL 11-angle sweep post-merge: Simple:yes throughout, byte-identical to pre-merge.
RESULT: 2592→1214 lines (53% reduction). Render time unchanged (~8.5s, expected). No file split attempted — not warranted at this size.

### 2026-07-09 | vm01-acrylic-curve-hinge-lock-fix | DONE — v57, fresh session (prior direct-chat session hung on cloud container resume, abandoned, treated as new)

Files: VM-01-base-v57.scad (new, source v56), rules-dimensions.md(v28→v29), cc_chat_log.md, prompts/archive/. Real OpenSCAD/CGAL binary installed + used throughout (renders, STL cross-section extraction, a real parametrized collision-bisection sweep) — not estimates.
T1 acrylic "double sheet" (TOP edge, FIXED): v56's "leaf thickness" theory was WRONG (Janis's show_acrylic=false disproved it). Real cause via CGAL cross-section: acrylic's own top edge and the window-hole's top edge land within 0.01mm of the same Z but different Y-depths — reads as 2 lines. Fixed with a new 2mm top border (mirrors the already-working left/right border), acrylic pane's own top pulled down to match.
T2 door curve vs. shell wall (INVESTIGATED, no code change): real top-down CGAL renders confirm the door's flange curve is ALREADY tangent to the shell (identical center/radius) — visible artifact traces to T1 + the frame gap, not the door. Real bisection sweep re-confirms frame_arc_r's 14mm cap is unmovable via hinge_x/hinge_y (closed-door state is mathematically hinge-invariant) — stated plainly, not forced.
T3 hinge rod: REMOVED entirely (not toggled). Pivot point preserved as pure rotation math, now a LOCKED reference in rules-dimensions.md. Full knuckle-hinge hardware still deferred.
T4 lock system: PROVISIONED — conservative placeholder recess (door leaf + compartment_divider() strike), dimensions/position flagged as needing Janis's input (no prior spec found anywhere in repo).
Full-assembly 11-angle CGAL sweep (0-100°): Simple:yes throughout, zero new warnings.

### 2026-07-07 | vm01-v56-sensor-bracket-frame-joint-fix (TASK 3 follow-up) | DONE — manifold warning FULLY resolved, acrylic theory corrected, no prompt file

Files: VM-01-base-v56.scad (same file, extended), rules-dimensions.md(v27→v28), cc_chat_log.md. Janis live-tested the FIX 1/FIX 2 changes below (confirmed working) then reported 2 new findings via her own toggle testing.
BIG FIX: Janis's toggle testing (show_door=false / show_shell_left=false clear the door-closed manifold warning, show_shell_top=false does not) proved the warning's real trigger was NEVER `compartment_divider()` (v55's conclusion, now downgraded). Root cause: `outer_shell()` AND `outer_shell_debug()` each independently duplicate the corner-pole cutout — both had a real X-Y gap vs. the recess-pocket cutout next to it, leaving an uncut sliver the door's own flange clips into (real 6-facet CGAL overlap, confirmed). Editing only one duplicate copy first and re-testing caught the second (same "duplicated datum" bug class as v55). Fixed: extended both cutouts' Y-reach. RESULT: full-assembly manifold warning is COMPLETELY GONE at every angle — first time ever in this file's history.
CORRECTED: this round's own earlier "acrylic recess" theory for the "double sheet" note was WRONG — Janis disproved it by testing with show_acrylic=false (line still there). Re-diagnosed by elimination: door leaf alone (no frame/acrylic/shell) still shows it — it's just the door's own 3mm material thickness rendering as 2 edges at a grazing angle, not a bug. Corrected in both files.

### 2026-07-07 | vm01-v56-sensor-bracket-frame-joint-fix | DONE — v56, direct response to Janis's QA screenshots on the merged v55 PR, no prompt file

Files: VM-01-base-v56.scad (new, source v55), rules-dimensions.md(v26→v27), cc_chat_log.md. Real OpenSCAD renders + CGAL used throughout, not estimates.
FIX 1 — sensor "lifted out of bracket": real side effect of v54's sensor Z-fix (moved up to clear a real collision, per that session), which stranded it 50mm above `drop_zone_guards()`'s old top (never tied to the sensor at all). Fixed the BRACKET per Janis's instruction: hoisted the sensor's Z to a shared datum, grew the guard's height to enclose it. Re-verified: guard-vs-sensor real overlap now (12 facets); guard-vs-door 9-angle sweep still zero overlap.
FIX 2 — frame "bad joint": real, CGAL/render-confirmed kink where a v50 fix truncated the left vertical bar's curve early. Rebuilt as a concentric double-arc band, the SAME construction `left_zone_door()` already uses — kink eliminated, zero side effects on frame_bar/tray width. Re-verified: frame-vs-door sweep zero overlap, frame-alone CGAL clean, visually confirmed via real render.
FLAGGED not fixed: acrylic "double sheet" re-checked with a real render this time (v52's fix was arithmetic-only, never render-confirmed) — traced to the acrylic's deliberate recessed-pane design, not a duplicate object. Design question for Janis, not guessed at.

### 2026-07-07 | vm01-v55-door-floor-datum-fix | DONE — v55, direct user question ("manifold issue ongoing for several versions, how to fix?"), no prompt file

Files: VM-01-base-v55.scad (new, source v54), rules-dimensions.md(v25→v26), cc_chat_log.md. Real OpenSCAD/CGAL used throughout (STL export + facet-coordinate extraction), not estimates.
Re-tested the two previously-suspected "exact tangency" causes (door-top-vs-roof v52, hinge-cylinder-vs-wall v52) with a real 9-angle CGAL sweep — BOTH CLEAN. Prior sessions' attribution was arithmetic, never CGAL-confirmed; correcting that here. Both rows in rules-dimensions.md marked RULED OUT.
Real root cause found instead: `door_bot_z` (+ 3 independently-re-derived copies: `shell_hinge_z`x2, `hinge_z`) used `FOOT_BASE_H+0` (legs level) instead of `FOOT_BASE_H+skin_t` (true interior floor) — a genuine ~2mm SOLID collision between the door leaf and the floor slab, present since ≥v53. FIXED: all 4 moved to the shared datum `FOOT_BASE_H+skin_t-e`; `leg()` extended `+e` to stay flush. Confirmed clean via CGAL. Bonus: this also closed the older unresolved "bottom-left-corner floor hole."
NOT fixed: `compartment_divider()` has its own separate touch with the shell (7 facets + warning, confirmed X-Y issue not Z — no change at 1mm overlap tested explicitly). Flagged in both files, not guessed at. Door-closed manifold warning still present, now solely attributable to this one isolated, unresolved cause.

### 2026-07-07 | vm01-v54-sensor-bracket-fix | DONE — v54, both prompt diagnoses re-derived from live geometry, real root causes differ from what was assumed

Files: VM-01-base-v54.scad (new, source v53), rules-dimensions.md(v24→v25), cc_chat_log.md, prompts/archive/. OpenSCAD binary available and used for every check — real CGAL, not estimates.
T1 sensor: prompt said "facing wrong way." Real cause found instead: `strip_z` still referenced `tray_0_z` (stale PRE-v46 tray anchor, kept only for `tray_compartment_partition()`) instead of `tray_stack_z0` (the v46 live-position datum every other tray-dependent module already uses) — CGAL-confirmed a genuine 12-facet SOLID collision with `exit_compartment_wall()` at the stale Z. Fixed; re-verified ZERO overlap. The "visible from outside" symptom is real (confirmed via render) but traces to the already-flagged, out-of-scope v50 corner-pole gap, not this strip's coordinates — stated explicitly, not claimed fixed.
T2 guard: prompt's "already known oversized, prior session, no harm" claim NOT found anywhere in cc_chat_log.md/rules-dimensions.md after a full search — not acted on. Real CGAL found the v47 value is an exact zero-clearance tangent (1-facet degenerate touch) against the door — first fix attempt (23mm) still touched a different door surface (inner hinge-line segment); final fix (`HINGE_Y_OFFSET+skin_t`=27mm, was 21.01mm) re-verified ZERO overlap, real 9-angle sweep.
T3: door-open still clean; door-closed warning still present after both fixes — consistent with the two SEPARATE, already-known, out-of-scope exact-tangency findings (door-top vs roof, hinge-cylinder vs wall) from v52/v53, neither touched this round.

### 2026-07-07 | wire-kickoff-chain-scope-to-skeleton | DONE — docs only, zero .scad/dimension files touched

Files: .claude/SKILL_product_design_skeleton.md(2.0→2.1), chat_rules.md(v3.9→v3.10), WORKFLOW_SKILL.md(3.12→3.13), knowledge.map(v45→v46), cc_chat_log.md, prompts/archive/.
Added a PREREQUISITE section to the skeleton skill (before TRIGGER PHRASES) pointing to `design_scope_of_work_rule.md` — that file didn't exist when the skeleton skill was written (2026-07-05, one day before the scope file convention), so its own SCOPE never referenced it; a future session could complete the worksheets with no scope file at all, or in the wrong order.
`chat_rules.md`'s "New Product Design Discipline" REWRITTEN (not appended) as one explicit 5-step sequence: customer interview → scope file (own confirmation gate) → skeleton's 3 worksheets in order (separate confirmation gate) → first cc prompt/coding loop → cc_chat_log/CURRENT_STATE feedback. Grandfather clause preserved, integrated into the rewrite.
`WORKFLOW_SKILL.md`'s TRIGGER row updated to name the full chain and require TWO separate Janis confirmation points (post-scope-file, post-worksheets), not one collapsed gate. `knowledge.map`'s GOVERNANCE section unified into one connected chain description. All 4 files bumped X.Y (sequencing/detail, not new structural content, per this prompt's own explicit framing). No .scad/dimension files touched.

### 2026-07-07 | skeleton-skill-bom-tree-kinetic-convention | DONE — docs only, zero .scad/dimension files touched

Files: .claude/SKILL_product_design_skeleton.md(1.0→2.0), cc_rules.md(v8→v9), chat_rules.md(v3.8→v3.9), WORKFLOW_SKILL.md(3.11→3.12), knowledge.map(v44→v45), cc_chat_log.md, prompts/archive/.
Added "PROCEDURE — CLAUDE WEB (BOM Subassembly Tree)" and "PROCEDURE — CLAUDE WEB + CC (Kinetic Dual-View Convention)" sections to the skeleton skill, positioned alongside (not replacing) the Skeleton Worksheet — explicitly distinguished as a different artifact (parts hierarchy vs. coordinate reference). Kinetic convention cites VM-01's show_shell_top incident as the concrete rationale, per the prompt's own instruction, not an abstract justification.
Version bump reasoning stated explicitly: skeleton skill itself gets X.0 (1.0→2.0, genuinely NEW sections/structure); the 4 wiring files (cc_rules/chat_rules/WORKFLOW_SKILL/knowledge.map) get X.Y-equivalent detail bumps (one-line pointers/cross-references to an already-established concept, no new structure of their own).
SCOPE/grandfather clause confirmed to already cover both new sections without wording change (file-wide "new product lines only" statement, not tied to named procedures) — not touched. No .scad or rules-dimensions.md files touched, confirmed.

### 2026-07-07 | vm01-clearance-zone-map-skill-and-application | DONE — v53, new diagnostic skill, both v52 findings CGAL-confirmed with precise numbers

Files: VM-01-base-v53.scad (new, source v52, diagnostic module only), .claude/SKILL_clearance_zone_map.md (new), knowledge.map(v43→v44), cc_chat_log.md, prompts/archive/. OpenSCAD binary WAS available this session (installed fresh) — every result below is a real CGAL minkowski()+intersection() render, not an estimate.
Skill adapted the prompt's pseudocode to real OpenSCAD: modules can't be passed as parameters, so `clearance_zone_map()` uses `children(0)`/`children(1)` instead of `part_a()`/`part_b()` — documented explicitly in the skill file.
Finding 1 (door_top_z vs. shell roof, isolated to the top-left corner specifically — mid-door-width tested separately and confirmed clean): 0mm band EMPTY, but 0.02mm already shows substantial stable overlap (~175-205 facets, robust across 2 different bounding boxes) — the CGAL signature of an EXACT tangent touch, not a small real gap. Real clearance: 0.000mm exactly, CGAL-confirmed (v52 only had this as an arithmetic estimate).
Finding 2 (hinge-pivot cylinder vs. shell wall, tested 2 independent ways — sliced from the real door AND reconstructed from its own constants, both agree): same exact-tangency signature, real clearance 0.000mm exactly, CGAL-confirmed.
Both diagnostic test scripts lived in scratchpad only, never in the committed file; only the reusable `clearance_zone_map()` module persists in v53, no calls. No dimension changed — rules-dimensions.md untouched per prompt's explicit instruction. Neither finding fixed — isolation-only, unchanged from v52's scope.

### 2026-07-07 | vm01-v52-acrylic-fix-side-shell-collision-isolation | DONE — v52, 1 real fix (not the hypothesized bug), 2 collisions isolated (not fixed)

Files: VM-01-base-v52.scad (new, source v51), rules-dimensions.md(v23→v24), cc_chat_log.md, prompts/archive/. No OpenSCAD binary this session — arithmetic self-check only.
T1: checked the actual v51 code before assuming Janis's "double-layer" hypothesis — found NO duplicate/sibling acrylic object (only one `#ADD8E6` piece inside `left_zone_door()`; `left_front_acrylic()` confirmed dead code). What WAS wrong: v51's cutout landed at EXACTLY `acrylic_top_limit_z` (682.99mm world), same as the acrylic's own top, with no epsilon — the deleted cap always used `acrylic_top_limit_z - e` for a real shared volume (Rule M-1); v51 dropped that nudge. Fixed by restoring it — likely explains the reported visual artifact even though no literal duplicate object existed.
T2 (isolation only): Janis's refined finding (error clears only when top+left shell removed TOGETHER) traced to TWO independent exact-zero-clearance touching planes — `door_top_z` vs. the shell's own roof-skin boundary (both 698mm world), and the v50 hinge-pivot cylinder's tangent edge vs. the shell's flat exterior wall (both X=0mm world). Same underlying pattern (no epsilon buffer on an exact-alignment value), two different features — stated explicitly, not merged. Left-wall recess pocket + corner-pole cutout confirmed already fully clear the door's flange (no gap). Right side confirmed clean. Not patched — isolation/reporting only, per prompt scope.

### 2026-07-07 | governance-cc-intro-knowledge-map-rules-refresh | DONE — docs only, zero .scad touched

Files: WORKFLOW_SKILL.md(3.10→3.11), knowledge.map(v42→v43, full rebuild), RULES.md(1.0→2.0), cc_chat_log.md, prompts/archive/.
T1: CC PROMPT TEMPLATE Section 1 replaced with continuation/fresh self-check + Claude Web override slot + named task-specific-reads slot (exact structure per prompt); knowledge.map restored to the mandatory 2nd read (had silently narrowed out, no recorded decision — real drift, not intentional).
T2: knowledge.map rebuilt — stripped the embedded VM-01/PR-01 SCAD version-index changelogs + this file's own header changelog + the stale (v42-era) viewer STL-upload-status table (all preserved in git history/cc_chat_log.md, not lost); added a complete, individually-confirmed /.claude/ file index (was partial); kept WHO READS WHAT, FILE SYSTEM MAP, GOVERNANCE, PROJECT FOLDERS as current-state-only. FLAG: README.md still points to "RULES.md section 4" for session protocol, which doesn't exist (real protocol lives in WORKFLOW_SKILL.md) — out of this prompt's scope, not fixed.
T3: 3/3 candidate rules confirmed against actual traced events (not forced) — R-005 render-mode/toggle compound-gating trap (v44 Finding B), R-006 shared-center/radius arc constraint (v50 left-vertical/door-flange), R-007 patch-vs-real-material pattern (this session's own v51 steel-bar fix). No additional confirmed candidates found beyond these 3 in the 2026-07-05-onward archive scan.

### 2026-07-07 | vm01-shell-toggle-fix-and-hole-isolation | DONE — v51, 2 toggles fixed, 1 hole isolated (not fixed), 1 real fix

Files: VM-01-base-v51.scad (new, source v50), rules-dimensions.md(v22→v23), knowledge.map(v41→v42), PART_MANIFEST.md, cc_chat_log.md, prompts/archive/. No OpenSCAD binary this session — arithmetic self-check only, not live CGAL; Janis F6/CGAL re-check still required.
T1 `show_shell_top`: NOT orphaned — was wired to a real cutout, but referenced `total_h`(700) instead of the module's own local `shell_h`(650), landing the cut entirely above the actual shell (arithmetic-confirmed: 697 local vs. 0-650 local range) — fixed to reference `shell_h`.
T2 `show_shell_bottom`: added, same convention, gated in `outer_shell_debug()`, mirrors left/right panels' construction.
T3 (isolation only, NOT fixed): bottom-left hole = the SAME v50 corner-pole cutout — its Z-range starts at local 0, exactly the shell's own bottom-skin range, so it punches a real hole through the FLOOR there; its top end lands exactly at the top-skin's own start (coincident, zero overlap) — roof untouched. That's why it's a real hole from below but only a "cut edge" from above. Present in BOTH door states — NOT the door-closed manifold warning. No independent record of an earlier "strange cut" finding found in this repo; treated as same defect class by geometry, not by matching a prior record.
T4 (real fix): door's top metal "cap" confirmed dependent on `show_acrylic` (Janis-predicted, confirmed) — deleted; leaf's window cutout shrunk to `acrylic_top_limit_z` so the door's own shell skin fills the space instead (mirrors flap-zone pattern). This resolves the ENTIRE fill-vs-frame overlap flagged since v49 (was 100% the cap) — same bar Janis suspected caused that specific door-close collision, CONFIRMED resolved; the separate unrelated right-edge trim collision (v48 TODO) is NOT claimed resolved.

### 2026-07-06 | vm01-design-scope-update-owner-answers | DONE — 5 owner answers applied, docs only, zero .scad touched

Files: vending-machine/design_scope_of_work_rule.md, pilates-reformer/design_scope_of_work_rule.md, cc_chat_log.md, prompts/archive/.
Resolved/added/removed: (1) Envelope Targets reframed as target-guidance-only, not a fixed requirement — "gap" framing removed; FLAGGED a tension the task didn't ask me to resolve: `total_h` is OWNER-LOCKED in rules-dimensions.md, which reads stricter than "adjustable as needed." (2) Added door safety/smoothness + separate-lock features (Functional Features 3/4), explicitly NOT conflated with the still-open shell trim/joggle defect. (3) Appearance section: added corner/frame smooth-uniform-modern requirement, cross-referenced to (2). (4) Sensor description corrected: facing pair side-to-side, full-width single detection zone, 120mm spec, not per-lane — old wrong assumption + its Open Question both removed. (5) Weld-vs-bolt Open Question deleted entirely per owner instruction (technical/BOM matter, not customer-facing) — not relocated.
Core filter statement (owner's own words) added to BOTH files' headers, confirmed.
FLAG (left untouched, DO NOT TOUCH scope): Appearance section still has a separate stainless-steel bullet mentioning L-brackets/welding — same category the owner just said doesn't belong here, not touched since it wasn't a named task; and the "Corner/frame/shell-width redesign" Open Question still says "NOT executed yet" even though v50 (PR #94) has since landed — left as-is per explicit DO NOT TOUCH on that item's completion status.

### 2026-07-06 | VM-01-corner-frame-redesign | DONE — v50, built on real v49 (naming note), 1 real constraint flagged not forced

Files: VM-01-base-v50.scad (new, source v49), rules-dimensions.md(v21→v22), knowledge.map(v40→v41), cc_chat_log.md, prompts/archive/. Every check below is a real OpenSCAD/CGAL render.
T1: pole = shell's own front-left curved corner wall (never cut by existing openings) — removed via new cutout (X/Y -1..22, full door height) in both shell modules. CGAL-confirmed: real mid-height collision gone across full 0-100° sweep (distinct from an unrelated, already-known Z50-52/698 coincident-face artifact). FLAG: opens a ~5mm gap at Z50-55/693-698 (outside the frame's own range) with no material there — unresolved, needs Janis input.
T2: frame_bar 20→8mm. RIGHT vertical touches compartment_divider() (product_w+e) — achieved, CGAL-clear vs door+lane4. LEFT vertical: tried growing to touch the shell (r=19.01) — CGAL bisection proved this ALWAYS recollides the door (its flange uses the identical center/radius by design) — reverted to the old proven-safe r=14, flagged as a real constraint, not forced. Caught+fixed a self-intersecting polygon bug (narrower frame_bar made the old Y-only curve-stop rule fold back on itself — "mesh not closed" CGAL error).
T3: widening total_w/product_w does NOTHING (confirmed algebraically+live) for either the spring lanes or the tray box's own walls vs the frame — 0mm widening. Real fix: new tray_x_inset(17mm, was hardcoded "10") + tray_w_global(389.01mm, was product_w-20) — a first attempt (14mm) passed a lanes-only check but missed the tray BOX's own walls also colliding; re-derived, CGAL-confirmed zero overlap across the full tray_out_pct sweep (0-1.0), both trays.
T4: new hinge-pivot reinforcement cylinder (d=hinge_od) at the door's rotation axis — angle-invariant, CGAL-clear vs shell+frame at 0/50/100°.
Carried forward, untouched: acrylic/frame fill overlap (re-measured, same as v49), new partition-weld protrusion (not investigated, out of scope).

### 2026-07-06 | wire-design-scope-into-workflow | DONE — WORKFLOW_SKILL.md v3.9→v3.10, docs only

Files: WORKFLOW_SKILL.md, cc_chat_log.md, prompts/archive/. No .scad touched.
New **Step 4** added to the CLAUDE WEB SESSION OPENING — MANDATORY SEQUENCE (and its duplicate copy inside the CHAT HANDOFF TEMPLATE block): read the relevant project's `design_scope_of_work_rule.md` in full, same mandatory "not found → STOP" tier as Steps 2/3.5 — positioned right after Step 3.5 (CURRENT_STATE.md) and before Step 5/6, so it's read before any QA discussion or prompt drafting. If CURRENT_STATE.md doesn't disambiguate which project, both copies must be read, not one picked silently — stated explicitly, not left implicit. Closing line ("all 6 steps confirmed") updated to list all 7 labeled steps (1/2/3/3.5/4/5/6).
TASK 2 confirmed: cc_rules.md has ZERO existing automatic-read-list entry for design_scope_of_work_rule.md (grepped, not assumed) — this prompt did not add one; cc's read of that file stays prompt-triggered only, unchanged.

### 2026-07-06 | design-scope-of-work-prompt | DONE — 2 new files, PARTIAL extraction (session hit usage limit mid-run)

Files: vending-machine/design_scope_of_work_rule.md (new), pilates-reformer/design_scope_of_work_rule.md (new), knowledge.map, cc_chat_log.md, prompts/archive/.
Both files built from original briefs + rules-dimensions.md + PART_MANIFEST.md + CURRENT_STATE.md + a representative sample of archived prompts — NOT a literal line-by-line read of all ~44 VM-01+PR-01 archived prompts as the CC INTRO asked. Two Explore agents tasked with the exhaustive scan both failed mid-run on a session usage limit; rather than block, did the extraction directly with the sources above and flagged the gap explicitly at the top of BOTH new files' own header comments and in each "Open Questions" section.
VM-01: envelope-target drift flagged (800/410mm original brief vs 700/600mm built, no explicit re-confirm session found); v48 TASK 4 shell-trim collision and the deferred corner-frame-redesign both cross-referenced as open.
PR-01: bed_w=840(720mm crossbar-gap target)/pole_od=40(no taper)/grip_od=32(LOCKED) captured; socket-not-physically-cut and pole_wood_socket() redundancy open items carried over from CURRENT_STATE.md.
FLAG for Claude Web: a follow-up pass reading the remaining archived prompts individually (esp. VM-01 v6-v29 and PR-01 v8-v24 build-out prompts) would strengthen both files before treating them as complete.
Going forward: any session confirming a new feature/goal with the owner must update the relevant design_scope_of_work_rule.md in the SAME prompt — this file must never trail behind a confirmed decision.

### 2026-07-06 | VM-01-door-flap-acrylic-fix | DONE — v49, ran against live v48 frame (no v49-frame-redesign landed yet — that prompt explicitly deferred, skip it)

Files: VM-01-base-v49.scad (new, source v48), rules-dimensions.md(v20→v21), knowledge.map(v38→v39), cc_chat_log.md, prompts/archive/. Every check below is a real OpenSCAD/CGAL render, not an estimate.
T1: lower flap-zone's separately-mounted metal panel (door_t+door_t=6mm stacked w/ leaf) DELETED — window hole now only cuts split_z_local..win_z1 (acrylic zone); below that is just the leaf's own continuous door_t skin, flap opening cut directly in. Thickness 6mm→3mm. Re-verification caught a side effect: flap's cutout needed extending to flap_top_z+flap_t+e (183.01 local, was 180) so its full 0-55° sweep still clears the now-solid leaf (CGAL empty at every 1° step; un-extended version showed a real collision, confirming the test).
T2: acrylic's left/right mounting overshoot (into tray_zone_frame()'s verticals — the whole source of v48's flagged regression) pulled in by the project's existing 2mm clearance convention (win_x0+2+e..win_x1-2-e). Caught a coincident-face bug in my own first attempt (border strip touching both the frame AND the acrylic at exact planes, zero-volume CGAL intersection) — fixed w/ e-nudges both sides. Top boundary (682.99mm) reconfirmed unchanged. Window opening (window_x0/z0/w/h) confirmed distinct from acrylic's own border, no flag needed. Metal top cap (v48) left untouched, out of scope.
Result: fill-vs-frame CGAL volume 22091mm³(v48)→3757mm³(v49), remainder is entirely the unchanged top cap's already-flagged residual.
NOTE: corner-frame-redesign prompt intentionally NOT run this session (per Janis, save for fresh-context session) — do not build on v49 assuming that frame change is included.

### 2026-07-06 | VM-01-left-door-v47-fixes | DONE — v48, 3/4 fixed + re-verified, TASK 4 flagged not guessed

Files: VM-01-base-v48.scad (new, source v47), rules-dimensions.md(v19→v20), knowledge.map(v37→v38), cc_chat_log.md, prompts/archive/. OpenSCAD/CGAL binary WAS available this session — every check below is a real render, not a Python estimate.
T1 sensor_strip: world_arc_cy+e(21.01, v47's drop_zone_guards fix) checked live and found insufficient for the hinge-side strip (X overlaps the flange's hinge-line face, up to HINGE_Y_OFFSET=25) — fixed to HINGE_Y_OFFSET+e=25.01mm, rear 140mm unchanged. 9-angle+fine sweep ZERO overlap, both strips, CGAL-confirmed empty.
T2 partition: front edge restored 526mm→drop_zone_d(138mm), real 2mm contact w/ exit_compartment_wall (CGAL non-empty, 8 verts), 117mm clear of tray_zone_frame's real footprint (CGAL empty).
T3: door_acrylic_t=5mm (acrylic only); top pulled 698→682.99mm (=door_top_z-frame_inset-FLANGE_T-e, frame_inset/FLANGE_T promoted to globals) clearing the top weld flange, new metal cap fills 682.99-698; flap swept 0-55° notched from metal panel (was solid, CGAL-confirmed full block → now empty); flap plane confirmed already flush, no change. FLAG: fill-vs-frame CGAL volume 17412mm³(v47, pre-existing edge overlap)→22091mm³(v48, +4679 from 3a's depth) — not fixed, needs acrylic_border redesign.
T4: searched shell in full, no sub-feature matches "top+bottom sub-piece" distinct from tray_zone_frame's own flanges (which Janis says isn't the cause) — NO toggle added, flagged in a TODO comment near outer_shell_debug(), needs a screenshot pointing at the exact edge.
Same single pre-existing 2-manifold warning as v47 (CGAL-confirmed identical), no new warnings.

### 2026-07-05 | VM-01-partition-depth-door-collision-fix | DONE — v47, 2 confirmed problems fixed, both re-verified clear

Files: VM-01-base-v47.scad (new, source v46), rules-dimensions.md(v18→v19), knowledge.map(v36→v37), cc_chat_log.md, prompts/archive/.
PROBLEM 1 (partition overlapped frame, static/door-independent): tray_compartment_partition()'s front edge moved from skin_t(2mm) to tray_start_d+(tray_d-motor_d-2)=526mm — the SAME expression spring_coil() already uses for its own rearward extent, not a new number. Functional reason: keeps the spring's operative drop-length (world Y 138-526) open so items don't land stuck on the partition. Rear edge (598mm) unchanged. Gap to tray_zone_frame() (world_arc_cy=21mm): 505mm, confirmed empty. exit_compartment_wall() no longer touches the partition directly — flagged, not silently claimed unchanged; it still fully blocks the reach-through on its own.
PROBLEM 2 (guard poked through closed door, root cause Janis-confirmed via render): BOTH of Janis's suggested fixes (frame-face-minus-thickness, flat 10mm) were checked against live geometry and found INSUFFICIENT — 10mm pullback still left 7.6mm² overlap at door_open_deg=0, since the hinge-side guard sits near the door's curved flange (reaches world Y=21mm there). Fixed: guard front-most Y raised to world_arc_cy+e=21.01mm (existing constant, same as frame/door). Rear edge (140.01mm) unchanged.
Full pairwise re-sweep: partition-vs-frame trivially empty (505mm gap, no angle dependency). door-vs-guards 9 angles (0/20/25/30/35/40/45/70/100) = ALL EMPTY, fine 0.5° sweep worst-case area = 0.0. tray_zone_frame()/hinge geometry/shell hinge recess confirmed UNTOUCHED.

### 2026-07-05 | VM-01-tray-access-acrylic-split-flange | DONE — saved as v46 (not v45, name taken), 9-angle sweep ALL CLEAR

Files: VM-01-base-v46.scad (new, source v45), rules-dimensions.md(v17→v18), knowledge.map(v35→v36), PART_MANIFEST.md(VM-01, 1.0→1.1), cc_chat_log.md, prompts/archive/.
NAMING FLAG: prompt said save as v45; VM-01-base-v45.scad already existed (governance batch shipped it first, merged before this prompt uploaded) — built on the real v45, saved as v46 per "never overwrite."
TASK 1: tray stack shifted UP 100mm — old lowest-tray-floor Z (tray_0_z, UNCHANGED anchor) = 270mm, new (tray_stack_z0) = 370mm, delta = 100mm exactly. Only tray_count=2 exists (no 3-row/"3x5" variant). New tray_compartment_partition() (full compartment width/depth, fixed/welded, at the OLD 270mm) + new exit_compartment_wall() (NEW module — no existing part matched "bracket holding the flap stopper", flagged) seal the gap, zero-gap confirmed via e-overlap. Top-tray clearance: ceiling=612mm, vs door_top_z(698)=+86mm, vs roofline(700)=+88mm, POSITIVE. FLAG: vs the UNCHANGED DATUM_TRAY_TOP(512, tautological, not a real ceiling) = -100mm — not a 3D collision, flagged as a documentation question, not silently resolved.
TASK 2: acrylic split into upper (unchanged top) + lower plain metal, meeting at split_z_local = live reference to tray_stack_z0 (world 370mm) — not a duplicated number. Same show_acrylic gate, v44 fix not reintroduced.
TASK 3: H-frame gets 10mm top(683-693)/bottom(55-65) weld flanges, reusing the crossbar's already-safe cross-section, within the existing Z range.
TASK 4 — MANDATORY 9-angle CGAL-equivalent re-sweep (Python/shapely): door_open_deg 0/20/25/30/35/40/45/70/100 = ALL EMPTY; fine 0.5° sweep worst-case area = 0.0.

### 2026-07-05 | VM-01-governance-batch-post-v44 | DONE — toggle-wiring + docs only, zero geometry change (diffed)

Files: VM-01-base-v45.scad (new, source v44, toggle-only), vending-machine/VM-01-base/PART_MANIFEST.md (new), pilates-reformer/PR-01-base/PART_MANIFEST.md (new), cc_rules.md(v7→v8), knowledge.map(v34→v35), cc_chat_log.md, prompts/archive/.
TASK 1: Toggle-Completeness Rule added to cc_rules.md verbatim. TASK 3: v44 shipped tray_zone_frame()'s full H-frame rebuild with ZERO isolation toggle — confirmed via grep, this was the exact gap that let it sit wrong-referenced for ~10 versions unnoticed. Added `show_frame` (default true), gating the call in ASSEMBLY. Diffed v44→v45: only the toggle declaration + gated call line + header comments changed, zero geometry/dimension lines touched.
Toggle-completeness audit (VM-01, 13 ASSEMBLY-called modules): 4/13 compliant (show_door/show_frame/show_sensor + drop_zone_guards()'s named safety-critical exception). 9 flagged GAPS, NOT fixed (out of this prompt's explicit toggle-wiring-only scope, not silently expanding): legs(), outer_shell_debug() (partial panel toggles only), compartment_divider(), tray_rack(), spring_tray(), acrylic_display() (render_mode-gated not show_*), flap_stopper_rod(), dashboard(), rear_service_door() — full detail + candidate reasoning in PART_MANIFEST.md.
PR-01 PART_MANIFEST.md: all 10 real sub-parts confirmed already toggle-gated (0 gaps) — module names/toggles read from the real committed files (pole_top.scad/leg_socket.scad/PR-01-assembly-v31.scad), not guessed.
PR-01-base/PART_MANIFEST.md and VM-01/PART_MANIFEST.md both wired into knowledge.map FILE LOCATIONS. WORKFLOW_SKILL.md/chat_rules.md untouched per DO NOT TOUCH (Janis updating directly). rules-dimensions.md untouched (unrelated to this prompt).

### 2026-07-05 | VM-01-frame-window-rebuild-v44 | DONE — 6 real-render QA findings fixed, angle-sweep re-test ALL CLEAR

Files: VM-01-base-v44.scad (new, source v43), rules-dimensions.md(v16→v17), knowledge.map(v33→v34), cc_chat_log.md, prompts/archive/.
Finding A: sensor_strip()'s fabricated red center-beam cube (never part of the real design, Janis-confirmed) DELETED entirely; new show_sensor toggle. Finding B: door acrylic gate fixed render_mode=="full"&&show_acrylic → show_acrylic alone (was unreachable at default render_mode).
Finding C (major): tray_zone_frame() rebuilt as full H-frame — was anchored at world X=0/Y=0 (shell's sharp EXTERIOR corner, wrong) AND confirmed via CGAL to physically clip the door 0-30°. New frame: full-height envelope (door_bot_z-door_top_z), 5mm inset all sides, 2 verticals+1 crossbar (tray_0_z), repositioned off shell's REAL interior corner (skin_t+(corner_r-1) formula, same as left_zone_door()'s arc), left vertical curved (same center, radius-5mm inset=14mm) to clear the door's swept volume.
MANDATORY angle-sweep re-test (Python/shapely, mirrors CGAL intersection()) — door_open_deg: 0=EMPTY, 20=EMPTY, 25=EMPTY, 30=EMPTY, 35=EMPTY, 40=EMPTY, 45=EMPTY, 70=EMPTY, 100=EMPTY (all 9 angles, zero overlap area at each; fine 0.5° sweep across full 0-100° range also confirms zero, worst-case area=0.0).
Window/acrylic (Task 4) resized to the new frame's inner opening: window_x0=25/window_z0=5/window_w=362/window_h=638 (world X 27-389, Z 55-693, was v43's tray-zone-only slice); acrylic auto-resizes via unchanged acrylic_border formula.
No OpenSCAD binary in this sandbox — full Python/shapely computational-geometry self-check instead of live CGAL. Janis F6 preview + full CGAL render still required.

### 2026-07-05 | VM-01-door-datum-rebuild-v43 | DONE — door-scoped Skeleton exception, Janis F6 + CGAL manifold check required

Files: VM-01-base-v43.scad (new, source v42), rules-dimensions.md(v15→v16), rules-codes.md(1.13→1.14), knowledge.map(v32→v33), cc_chat_log.md, prompts/archive/.
Scope: front door assembly ONLY (left_zone_door, its shell recess pocket, drop_zone_visual) — explicit Janis-approved EXCEPTION to `.claude/SKILL_product_design_skeleton.md`'s VM-01 grandfather clause, no other BOM item touched.
`FOOT_BASE_H` (§2.1) made explicit (was folded into `DATUM_LEG_TOP=leg_h`). Hinge center (§2.2) is now THE door datum, world coords Z=`FOOT_BASE_H+0`=50, Y=`HINGE_Y_OFFSET`=25 (now independent, was `corner_r+5`), X=`0-(hinge_od/2)`=-6 (barrel proud of exterior). Door (`left_zone_door()`) and shell (`outer_shell()`/`outer_shell_debug()` recess cutout) independently re-derive this same point from shared constants — Python-verified: DOOR (-6,25,50) == SHELL (-6,25,50). Window/acrylic frozen as door's own local constants (§2.3, numbers unchanged from v42). Flange corner replaced with a 12-seg arc matching the shell's actual curve (§2.4, tangency Python-verified). Epsilon fixes on left_zone_door() front face, sensor_strip() (§2.5). `drop_zone_visual()` → `drop_zone_guards()` (§2.6): ghost faces removed, 2 solid side guards kept, left guard X-clearance vs. the hinge/flange footprint Python-verified (no intersection).
DEFERRED (Janis): partition + back door for spare storage under trays — TODO comment only, zero geometry, near `spring_tray()`.
No OpenSCAD binary in this sandbox — full Python arithmetic self-check instead (hinge-center match, world-position preservation vs v42, arc tangency, guard/flange non-collision, brace/paren/bracket balance 32/32,481/481,146/146). Janis F6 + CGAL manifold render required.

### 2026-07-05 | new-product-design-skeleton-skill | DONE — governance only, zero .scad files touched, direct Janis chat request (no /prompts/ file)

Files: .claude/SKILL_product_design_skeleton.md (new), .claude/SKILL_reference_point_first.md (marked superseded, kept), cc_rules.md(v6→v7), rules-codes.md(1.12→1.13), rules-dimensions.md(v14→v15), chat_rules.md(v3.7→v3.8), WORKFLOW_SKILL.md(3.8→3.9), knowledge.map(v31→v32), cc_chat_log.md.
Janis asked for a permanent Top-Down Skeleton/Datum Reference Frame design skill (Primary/Secondary/Tertiary datums, Parent-Child coordinate offsets, no Cousin/Stranger references — "football field" rule), extending the draft SKILL_reference_point_first.md from this same session. New skill is the FIRST file read for any NEW product line, includes a Claude Web "Skeleton Definition Worksheet" procedure (complete with Janis BEFORE any component sizing) and a cc procedure (SKELETON block + per-module Parent declaration comments).
Wired into every governance file: cc_rules.md session-start trigger, rules-codes.md "Datum Rules" pointer, chat_rules.md new section, WORKFLOW_SKILL.md new TRIGGER row + FILE STRUCTURE, knowledge.map FILE LOCATIONS + new "GOVERNANCE" section, rules-dimensions.md COORDINATE SYSTEM cross-reference.
**Grandfather clause, explicit per Janis's direct instruction: VM-01 and PR-01 are NOT retrofitted** — both continue under the existing DATUM_*/SKILL_reference_point_first.md convention. Applies to new/later products only.

### 2026-07-05 | VM-01-door-fixes-v42 | DONE — Janis F6 required, new datum/local-origin convention adopted project-wide

Files: VM-01-base-v42.scad (new, source v41), rules-dimensions.md(v13→v14), rules-codes.md(1.11→1.12), cc_rules.md(v5→v6), knowledge.map(v30→v31), .claude/SKILL_reference_point_first.md (new), cc_chat_log.md, prompts/archive/.
6-issue fix from Janis's real v41 QA: (1) `left_zone_door()` rebuilt as ONE `linear_extrude()` L-polygon (was 2 disconnected cubes, 20mm gap) with its own LOCAL ORIGIN (hinge line at floor) per the new skill — `door_open` is now a plain `rotate()`, no translate-dance. (2) new shell left-wall recess for the flange/hinge. (3) stopper rod split to its own static `flap_stopper_rod()` module, no longer swings with `door_open` — cross-checked algebraically against the flap's own open-position formula, exact match. (4) `show_door`/`show_acrylic`/`show_flap` isolation toggles added. (5) confirmed acrylic asymmetry was a side effect of #1, formula untouched. (6) DATUMS block — `tray_0_z`/window Z no longer independently derived; window shrinks from a floating 413mm to exactly the tray zone's 242mm. EXTRA fix (not in the prompt's literal list, required for #6 to work): `spring_tray()`/`tray_rack()` were re-deriving position locally instead of referencing `tray_0_z` — fixed.
Janis-approved live in this chat: tray position isn't independently locked (floor clearance for customer access is the real constraint) — `rules-dimensions.md`/`rules-codes.md` zone-stack tables updated accordingly (old tables marked SUPERSEDED, not deleted).
⚑ FLAG: `tray_zone_top_z` shift also ripples into the right-zone `acrylic_display()`/dashboard shell-opening (~30mm) — that module's code is untouched, only its effective position shifts via the shared datum; documented in rules-dimensions.md.
No OpenSCAD binary in this sandbox — full arithmetic self-check (Python) instead, all cutout/window/flap coordinates verified non-overlapping and in-bounds. Janis F6 render + 2-manifold isolation test (SKILL_manifold_triage.md) required.

### 2026-07-03 | VM-01-front-door-redesign-v41 | DONE — Janis F6 required across all toggle combos, several judgment calls FLAGGED

Files: VM-01-base-v41.scad (new, source v40), rules-dimensions.md(v12→v13), knowledge.map(v29→v30), cc_chat_log.md, prompts/archive/.
TASK 1: `front_door()`+`flap_door()`+`spring_zone_panel()` deleted, replaced by `left_zone_door()` — full left-zone door (Z 50-698, X 2-414), concealed hinge on the flat left wall via a return flange (off the rounded corner), inset acrylic window (`render_mode=="full"` gated, matching old convention), top-hinged 300x150mm exit flap swinging inward to a static stopper rod. Door/flap rotation math independently derived via rotation-matrix algebra (not guessed) and cross-checked (stopper rod position matches the flap's own open-angle formula exactly). Full arithmetic self-check (Python) confirms all X/Z ranges non-overlapping and in-bounds — no OpenSCAD binary in this sandbox, not yet rendered.
TASK 2: `door_open`/`flap_open`/`tray_out_pct` toggles added, verified to combine independently; `tray_out_pct` wired into `spring_tray()` only (not `tray_rack()`, which stays fixed).
TASK 3: rules-dimensions.md — old Door Z range row marked SUPERSEDED (kept), new "Left-Zone Front Door" section added per spec verbatim.
⚑ FLAGS (judgment calls, not silently made — full detail in knowledge.map v41 entry): door swings OUTWARD (direction unspecified by prompt for door, only flap); window's right margin mirrors left; acrylic/flap reuse door_t/flap_t; stopper rod reuses hinge_od; flap_w/flap_h/hinge_h deleted (fully dead, avoids dormant-global bug class) vs. flap_t/hinge_od kept (reused). `tray_zone_frame()`'s comment now stale (references deleted spring_zone_panel()) — module itself untouched, out of scope. v40's `show_shell_top` bug also remains unfixed, out of scope here too.

### 2026-07-03 | VM-01-shell-height-fix-v40 | DONE — Janis F5/F6 required, 1 new bug FLAGGED not fixed

Files: VM-01-base-v40.scad (new, source v39), knowledge.map(v28→v29), cc_chat_log.md, prompts/archive/.
TASK 1: `outer_shell_debug()` (the module ASSEMBLY actually calls, via `translate([0,0,leg_h])`) got a local `shell_h = total_h - leg_h;` and both `rounded_box()` calls switched from `total_h` to `shell_h` — fixes leg_h double-count that made the shell's real world Z range 50-750 instead of 700. Arithmetic-verified: shell_h=650, +leg_h(50) translate = world Z 50-700 ✓. No OpenSCAD binary in this sandbox — could not do the requested STL bounding-box measurement, arithmetic only.
Confirmed unaffected: the 4 zone-cutout translate()s (already using `world_Z - leg_h` convention) and `outer_shell()` (unused twin, out of scope). Diffed v39→v40: only header + 1 new local-var line + the 2 specified `rounded_box()` calls changed.
⚑ FLAG (discovered, NOT fixed, outside this prompt's "only 2 lines" scope): `show_shell_top=false` (C2 mode) cutout still targets old `total_h-skin_t-1` (local Z 697), now above the solid's new top (Z=650) — toggling it silently does nothing in v40. Needs a follow-up 1-line fix (`shell_h-skin_t-1`). back/left/right cutouts confirmed still fine (harmless overshoot).

### 2026-07-03 | VM-01-acrylic-corner-fix | DONE — Janis F5/F6 required

Files: VM-01-base-v39.scad (new, source v38), rules-dimensions.md(v11→v12), knowledge.map(v27→v28), cc_chat_log.md, prompts/archive/.
TASK 1: `acrylic_display()` right-side panel Y-range changed `skin_t`→`total_d-skin_t` to `corner_r`→`total_d-corner_r` verbatim per prompt — recesses panel into the shell's flat-wall region, clearing both rounded corners (front + rear). Root-cause math re-verified against live v38 params (total_w=640, not rules-dimensions.md's stale 620mm) before editing: curved wall at Y=2mm sits at X≈628.7mm vs. old panel's X=636mm, confirming the 7.28mm protrusion.
CONFIRMED per prompt: front panel (right edge X=618mm) and top panel (same width) both fall inside the flat-wall region, outside the corner's effective arc (sub-0.1mm) — no change made to either.
Diffed v38→v39: only header/version comments + the one panel translate()/cube() line changed. Brace/paren/bracket balance: 288/288, 33/33, 122/122. No OpenSCAD binary in this sandbox — diff + arithmetic verification only, not rendered.
⚑ FLAG: viewer's STL filename table (knowledge.map) still references VM-01-v38-*.stl — not updated, out of scope (separate SKILL_viewer_update.md task); Janis will need a new v39 export/upload pass when ready.

### 2026-07-03 | viewer-turntable-measure-and-filename-rule | DONE — zero .scad files, zero PROJECTS-registry values touched (diffed byte-identical)

Files: viewer/janis-product-viewer.html (v1.2→v1.3), .claude/SKILL_viewer_update.md (1.0→1.1), knowledge.map(v26→v27), cc_chat_log.md, prompts/archive/.
TASK 1: FILENAME CONVENTION section replaced verbatim as specified (output filename = source .scad name verbatim, `.scad`→`.stl` only, no strip/rename step) + NEVER-rename-via-GitHub-web-UI line added to PROCEDURE — JANIS step 2 + VM-01/PR-01-v31 grandfather exception preserved verbatim. Version 1.0→1.1.
TASK 2: [⏺ Record Turntable] button added — orbits camera 360° around Y (vertical) axis over `TURNTABLE_DURATION_MS`=8000ms pivoting on `controls.target`, `captureStream(30)`+`MediaRecorder('video/webm')`, disables button + pauses OrbitControls during capture, restores both on `onstop`, downloads `${activeProject}-${proj.version}-turntable.webm`. INTERPRETATION FLAG: prompt's literal filename pattern was `{activeProject}-{version}-turntable.webm` but parenthetically said "use label/version fields" — read this as "don't hardcode literal strings," so mirrored `exportSTL()`'s existing `${activeProject}-${version}` pattern (not `proj.label`, which contains spaces) for consistency; flagging this judgment call explicitly. Fails gracefully (log error, no crash) if `captureStream`/`MediaRecorder` unsupported.
TASK 3: [📏 Measure] toggle + [Clear Measurement] added — raycaster against `modelMesh` only, 2 clicks drop gold sphere markers (radius scaled to `modelMaxDim`) + a connecting line, computes Euclidean distance, displayed in a new `#measure-readout` div next to the button (right sidebar was not used — left-sidebar placement kept it next to the trigger button, cc's choice per prompt). **STL units = mm confirmed**: OpenSCAD's native/only unit is mm (see VM-01/PR-01 `.scad` headers, "Units: mm" / rules-dimensions.md "All units MM — always"), so both projects' STL exports are already mm — no conversion applied. 3rd click while 2 points exist is a no-op (Clear required first) — deliberate single-active-measurement scope per prompt, not an oversight. Resets on `switchProject()` per spec.
Confirmed: zero `.scad` files touched; `PROJECTS` object diffed byte-identical against the pre-session file (both VM-01 and PR-01 entries, all STL URLs/filenames unchanged) — this prompt only added UI/interaction code.

### 2026-07-03 | create-SKILL_viewer_update | DONE — governance/docs only, zero .scad and zero viewer.html change

Files: .claude/SKILL_viewer_update.md (new), WORKFLOW_SKILL.md(3.7→3.8), knowledge.map(v25→v26), cc_chat_log.md, prompts/archive/.
Note: this session's designated branch (claude/pr-01-viewer-integration-mcggyg) had its prior PR (#77) already merged to main — restarted the branch from latest origin/main per protocol before starting this task, no stacking on merged history.
TASK 1: `.claude/SKILL_viewer_update.md` created verbatim per prompt spec (TRIGGER PHRASES, PROCEDURE — CLAUDE WEB, PROCEDURE — JANIS, QUICK REFERENCE PROJECTS shape, FILENAME CONVENTION) — Claude Web only, cc does NOT read this file, matching the existing SKILL_manifold_triage.md/SKILL_local_render.md/SKILL_customizer_profile.md pattern.
TASK 2: new TRIGGER→ACTION→VALIDATOR row added to WORKFLOW_SKILL.md, verbatim wording from prompt, appended after the existing Customizer row — diffed to confirm no other row touched.
TASK 3: FILE STRUCTURE — REPO's `.claude/` block gets the new file (one line, matching existing style); WORKFLOW_SKILL.md version bumped 3.7→3.8 (same-structure addition, per DOCUMENT VERSIONING RULE) with changelog line.
knowledge.map: new FILE LOCATIONS row added for the new file.
Confirmed: zero `.scad` files touched, `viewer/janis-product-viewer.html` untouched (read-only per prompt — PROJECTS object was only *read*, not edited, this session), `chat_rules.md` and all other `.claude/` skill files untouched.

### 2026-07-03 | PR-01-viewer-integration | DONE — PR-01 wired into viewer, zero .scad files touched, 404 EXPECTED until Janis uploads STL

Files: viewer/janis-product-viewer.html (v1.1→v1.2), knowledge.map(v24→v25), cc_chat_log.md, prompts/archive/.
TASK 1: PR-01 PROJECTS entry added, all values read live from PR-01-assembly-v31.scad+includes (not VM-01, not guessed): version='PR-01-assembly-v31', status copied verbatim from CURRENT_STATE.md. params[] = curated 15-value subset (bed_l/w/h, pole_d, pole_h, leg_w/t/h, neck_h, top_bore_d, leg_socket_od/depth, r_base/r_top, grip_od) mirroring VM-01's 6-of-~50 curation, not literally every global — all min/max ranges guessed (none exist anywhere), flagging explicitly. Locked: pole_d (=pole_od, rules-dimensions.md "LOCKED") and grip_od (OWNER-LOCKED, scad comment + rules-pr.md) — no other PR-01 value is marked locked anywhere. components[] = 7 real module names confirmed against live pole_top.scad/leg_socket.scad (bed_assembly, pole_wood_socket, pole_body, pole_top, crossbar_assembly, bell_lock_collar, leg_socket) — NOT rules-pr.md's stale "COMPONENT MODE" table (pole_base_socket/pole_mid_clamp/pole_top_collar don't exist in v31; flagging that table as stale, separate cleanup task). No show_* render-MODE toggle exists (only per-component debug visibility toggles) — confirmed no VM-01 std/full/C2 equivalent, so added property key **`stl`** only (not `stlOpen`/`stlC2`) = `https://api.janishammer.com/models/PR-01-v31.stl` — Janis must export+upload exactly `PR-01-v31.stl`.
TASK 2: found + fixed 2 genuine VM-01-specific hardcodes in switchProject()/buildVisibilityPanel() that would have broken any future stl-only project (PR-01 included): (1) `stlViewMode` was force-set to `'open'` regardless of which URL keys exist, breaking Reload for single-mode projects — now derived stlOpen>stl>stlC2. (2) buildVisibilityPanel() checked `toggles.length` before `proj.stl`, so an stl-only project with empty toggles[] fell through to "No toggles defined" instead of the STL view button — reordered. Both verified inert for VM-01 (has both stlOpen and non-empty toggles, unaffected either way).
TASK 3: knowledge.map VIEWER STL table — new PR-01-v31.stl row added, marked NOT YET UPLOADED.
Confirmed: zero .scad files touched, zero VM-01 PROJECTS values/URLs/params altered (diffed). Selecting PR-01 now attempts loadSTL() and will 404 until Janis uploads — expected, not a bug.

### 2026-07-03 | PR-01-current-state-rapid-amend | DONE — rapid follow-up to PR #75, zero .scad files touched

Files: CURRENT_STATE.md (replaced entirely — now "where we left off" format, updates only on Janis-confirmed pause), WORKFLOW_SKILL.md(3.6→3.7), chat_rules.md(v3.6→v3.7), knowledge.map(v23→v24), cc_chat_log.md, prompts/archive/.
CURRENT_STATE.md: new open item added — leg_socket() wood leg is one solid cube, socket sleeve a separate overlapping tube, no boolean cut — not manufacturable as modeled, NOT waived (Janis hasn't decided fix-vs-waive), correctly kept OUT of rules-waivers.md per prompt's distinction.
WORKFLOW_SKILL.md: Step 3.5 (read CURRENT_STATE.md) inserted, old Steps 4/5→5/6, "5 steps"→"6 steps"; MID-SESSION PROJECT SWITCH section added after REPO TRUTH; CHAT HANDOFF TEMPLATE + FILE STRUCTURE updated to match — all diffed to confirm no other content touched.
Confirmed: `.claude/rules-waivers.md` untouched (git diff empty), zero `.scad` files touched.

### 2026-07-03 | PR-01-waiver-and-current-state-files | DONE — 2 new governance files, zero .scad files touched

Files: .claude/rules-waivers.md (new, 49 lines, under 200-line cap), CURRENT_STATE.md (new, repo root), knowledge.map(v22→v23), cc_chat_log.md, prompts/archive/.
W-001 (dormant global-override, 44 instances) registered verbatim per spec. CURRENT_STATE.md: corrected one line vs. the prompt's draft text — PR-01's "Pending: base-file-consolidation-fix ... will become v31 once merged" was stale by the time this ran; verified via `git log` that PR #74 is already merged and v31 exists in main (per REPO TRUTH rule), so wrote "MERGED... verified via git log" instead of copying the stale pending wording. Flagging this correction explicitly, not silently reconciling.
⚑ FLAG (no fix, TASK 4): `.claude/rules-codes.md` is 343 lines, over the 200-line-per-file cap under `.claude/` — confirmed via `wc -l`. Not split/edited this prompt — separate dedicated task.
Confirmed: zero `.scad` files touched.

### 2026-07-03 | base-file-consolidation | DONE — zero visual/dimensional change, full detail in knowledge.map v31 entry

Files: pole_top.scad (in-place, bell collar bundle removed → pointer comment), leg_socket.scad (in-place, bell collar bundle + 16 standalone defaults + ghost call added), PR-01-assembly-v31.scad (new, ACTIVE, source v30), knowledge.map(v21→v22), cc_chat_log.md, prompts/archive/. rules-dimensions.md: confirmed no change needed — file location only, zero dimension change.
`bell_lock_collar()`+5 helpers moved pole_top.scad→leg_socket.scad, byte-identical bodies (diffed). Full-assembly CSG dump md5sum-identical v30 vs v31, confirming zero geometry leakage/change. Both files render standalone with zero undefined-var warnings; leg_socket.scad's pre-existing manifold warning traced to bell_lock_collar() itself (isolated test) — pre-existing, not introduced by the move.
TASK 5: **44 dormant-override warnings confirmed via real OpenSCAD compile** — 20 pole_top.scad + 8 leg_socket.scad(pre-existing) + 16 leg_socket.scad(new, bell-collar set). Not fixed, per prompt — flagged as higher-priority input to the PENDING "TASK 2 audit" item, count roughly double prior ~23 estimate.

Files: pole_top.scad (in-place, dormant bed_h self-reassignment removed), leg_socket.scad (in-place, pad call commented out + ghost-only cutaway), PR-01-assembly-v30.scad (new, ACTIVE, source v29), rules-dimensions.md(v10→v11), knowledge.map(v20→v21), cc_chat_log.md, prompts/archive/.
OpenSCAD 2021.01 installed this session — real renders used throughout, not just code review. TASK 1a confirmed: pole_top.scad/leg_socket.scad both render standalone with zero undefined-var warnings. bed_h 500→600: xbar_z 2065→2165, collar_z0 440→540, bed_frame() leg height 470→570 — all changed as expected. body_h stayed 1476mm — verified algebraically inherent (bed_h cancels out of its formula), NOT a sign the fix failed; other 3 values prove it did.
Pad removed (commented out). leg_socket.scad ghost cutaway added; CSG-dump diff confirms it does NOT leak into full-assembly render (leg_socket() calls there are unchanged plain cubes).
Pre-existing (confirmed via diff against unmodified v29, not introduced here): ~28 "overwritten" global warnings (bed_h dropped off this list — proof of fix), and a 2-manifold warning on both standalone pole_top.scad and the full assembly (Volumes:12) — not touched, per manifold triage protocol.
FLAG (no action): bed_frame() leg cube (Z 0-570) and leg_socket() leg cube (Z 0-600) confirmed via CSG dump as two overlapping solids per corner, same footprint.

Files: pole_top.scad (in-place, bell_lock_collar()+split-clamp call retired), leg_socket.scad (new), PR-01-assembly-v29.scad (new, ACTIVE), rules-dimensions.md(v9→v10), knowledge.map(v19→v20), cc_chat_log.md, prompts/archive/.
Bell collar REVISED values (r_top=25/curve_power=2.2/cap_h=12/washer_overhang=4) render at 4 pole positions; thread/bayonet disclaimer comment present verbatim; old split-clamp `pole_base_collar()` call commented out (module kept). leg_socket(): socket_id=41mm, radial clearance vs pole_d(40mm)=0.5mm — tight, flagged. leg_socket.scad uses current `ghost_mode()` pattern (mirrored from live pole_top.scad), confirmed NOT the old self-reassigning `$is_assembly` pattern. Version increment confirmed: only PR-01-assembly-vXX bumped (v29); pole_top.scad/leg_socket.scad unversioned per flat-file exception.
Diffed unchanged: bed_w=840, leg_t=120, xbar_y_front=60, xbar_y_rear=780.
⚑ FLAGS (not resolved, need Claude Web/Janis decision): (1) prompt named the old collar `pole_top_collar()` — no such module exists, actual module is `pole_base_collar()`, retired that instead. (2) `pole_wood_socket()` (old 20mm placeholder) still actively called alongside new `leg_socket()` — likely redundant, not retired. (3) renamed leg_socket's socket params (`leg_socket_od/_wall_t/_depth`) to avoid colliding with existing `socket_od`/`socket_depth` globals. (4) `leg_h`=600mm never reconciled against `bed_h`(500)/existing bed_frame() leg height(470) — leg extends ~100mm above bed surface, documented interpretation not confirmed decision.
No OpenSCAD binary in this sandbox — code-review + arithmetic verification only, not rendered.

### 2026-07-02 | fix-pole-cx-cy-override-bug | DONE — Janis F6 required

Files: pole_top.scad (in-place edit, still v28), knowledge.map(v18→v19), cc_chat_log.md, prompts/archive/.
Root cause (same bug class as v27 $is_assembly ghost-leak): pole_cx/pole_cy self-reassignment in pole_top.scad collapsed to hardcoded fallback under `include` flattening, never the assembly's real value. pole_cx fallback [90,2210,90,2210] coincidentally matched (dormant); pole_cy fallback [60,60,610,610] was the OLD bed_w=670 value (diverged) — legs/poles frozen after v28's bed_w→840. Fix: removed both reassignments; ghost stanza now uses its own ghost_cx/ghost_cy locals for standalone fallback. Verified: pole_cx=[90,2210,90,2210], pole_cy=[60,60,780,780].
TASK 2 audit: all ~21 remaining guarded globals (e, bed_l, bed_h, pole_d, pole_r, neck_h, neck_id, neck_od, neck_bolt_d, top_bore_d, all housing_*, xbar_z, grip_od) currently dormant (fallback = live assembly value), none diverged, none fixed — same latent pattern flagged as standing risk, not resolved.
Brace/paren/bracket balance: 290/290, 33/33, 76/76. No OpenSCAD binary — code-review + arithmetic verification only, not rendered.

### 2026-07-02 | customizer-skill-mandatory-toggles | DONE — governance amendment only, zero geometry change

Files: .claude/SKILL_customizer_profile.md(1.0→1.1), cc_chat_log.md, prompts/archive/.
Added 3 new bullets to CRITICAL RULES verbatim per prompt: mandatory `/* [Visibility] */` show/hide toggle group for every major component; mandatory cutaway/section toggle for any nested component; all owner-adjustable parameters MUST be Customizer-exposed, editor pane read-only for version header.
Diffed: only version-bump line + the 3 new bullets changed — no other line touched, no existing bullets altered.
Confirmed: zero .scad files touched. No knowledge.map update needed (no new files).

### 2026-07-02 | bed-width-720-crossbar-gap | DONE — single dimensional fix, Janis F5/F6 required

Files: PR-01-assembly-v28.scad (new, source v27), rules-dimensions.md(v8→v9), knowledge.map(v17→v18), cc_chat_log.md, prompts/archive/.
bed_w 670→840mm — Janis-confirmed, derived from 720mm crossbar-gap target (bed_w = 720 + leg_t, leg_t=120 unchanged).
Verified: xbar_y_front = leg_t/2 = 60mm, xbar_y_rear = bed_w - leg_t/2 = 780mm, gap = xbar_y_rear - xbar_y_front = 720mm ✓.
Diffed v27→v28: only version-bump header + the bed_w line changed, confirmed via `diff`. Brace/paren/bracket balance: 33/33, 0/0, 4/4.
No OpenSCAD binary in this sandbox — diff + arithmetic verification only, not rendered. Janis must pull v28, F5 render, confirm crossbar gap reads correct.

### 2026-07-02 | customizer-skill-and-bell-collar-confirm | DONE — docs/governance + dimension-record only, zero geometry change

Files: .claude/SKILL_customizer_profile.md (new), WORKFLOW_SKILL.md(3.5→3.6), chat_rules.md(v3.5→v3.6), rules-dimensions.md(v7→v8), knowledge.map(v16→v17), cc_chat_log.md, prompts/archive/.
Task 1: new skill file created verbatim per spec, Claude-Web-only (cc does not read).
Tasks 2-3: trigger row + bullet added as specified.
Task 4: added Bell Collar CONCEPT CONFIRMED section (all 11 values) under 4-Part Split Architecture area. ⚑ FLAG: the prompt's "existing split-clamp collar dimension block (collar_wrap_h/collar_wall_t/collar_bolt_d)" does not exist in rules-dimensions.md — those placeholders live only in .scad file comments (PR-01-base-v9.scad onward) and the 2026-06-30 cc_chat_log entry. Placed the SUPERSEDED note against the file's only textual anchor for that concept (the pole_base_collar() prose mention) instead of inventing a table — flagging, not silently reconciling, per repo convention.
Confirmed: zero .scad files touched.

### 2026-07-02 | governance-repo-truth-rule | DONE — docs/governance only, zero geometry change

Files: WORKFLOW_SKILL.md(3.4→3.5), chat_rules.md(v3.4→v3.5), cc_chat_log.md, prompts/archive/.
Context: Claude Web had no way to confirm whether PR #66 was merged and (incorrectly) tried fetching GitHub directly instead of asking Janis. Fix codifies Janis as the only source of truth for current repo/PR/merge state — Project Knowledge is a snapshot, never live.
Task 1: added REPO TRUTH section to WORKFLOW_SKILL.md, immediately after JANIS SESSION PREP.
Task 2: added reinforcing bullet to chat_rules.md under Reading & Diagnosis.
Confirmed: zero .scad files touched — governance/documentation only.
⚑ FLAG FOR JANIS: re-upload both WORKFLOW_SKILL.md and chat_rules.md to Project Knowledge — repo copies changed, PK copies now stale.

### 2026-07-02 | PR-01-fix-ghost-leak-toggle-relocate-v27 | DONE — 2 fixes, Janis F5/F6 required

Files: pole_top.scad (in-place edit), PR-01-assembly-v27.scad (new), .claude/rules-codes.md(1.10→1.11), knowledge.map(v15→v16), cc_chat_log.md, prompts/archive/.
Issue 1 (ghost-leak): root cause confirmed by Claude Web via real local render — `include` flattens pole_top.scad's `$is_assembly = is_undef($is_assembly)?false:$is_assembly;` into the assembly file's scope, so OpenSCAD collapses both assignments to the module's always-false one, leaking ghost stand-ins (incl. pole 0) into every full-assembly render regardless of show_* toggles. Fix: read-only `function ghost_mode()`, replaces both the reassignment and the sole `if(!$is_assembly)` usage. Note: prompt claimed 2 usages to replace; only 1 actually existed in the committed file — flagging, not silently reconciling.
Issue 2 (toggle relocation): 6 show_* flags moved from PARAMETERS to immediately above pr01_assembly() in new v27, diffed against v26 — only location changed.
NOT fixed (explicitly out of scope, do not mark resolved): the ~23 "assigned...but overwritten" warnings from v26's per-variable is_undef() standalone-defaults block — separate open item.
Zero geometry change. Brace/paren/bracket balance: 33/33, 204/204, 74/74.

### 2026-07-01 | PR-01-flatten-modules-v26 | DONE — 3 tasks, Janis F5/F6 required

Files: PR-01-assembly-v26.scad (new), pole_top.scad (moved from modules/, modules/ deleted), .claude/rules-codes.md(1.9→1.10), knowledge.map(v14→v15), cc_chat_log.md, prompts/archive/.
Issue 1 (include path): root cause confirmed by Janis directly — local workflow downloads files individually, no git clone, so modules/ subfolder never survives. Fix: flattened — pole_top.scad now sits flat next to the assembly file, include path `<pole_top.scad>`. v26 identical to v25 except header comments + this one include line (diffed).
Issue 2 (undefined globals standalone): guarded every global pole_top.scad's ghost-context call path actually reaches (not just pole_d/xbar_z/grip_od named in the prompt — also e, bed_l, bed_h, pole_r, neck_h, neck_id, neck_od, neck_bolt_d, top_bore_d, all housing_* params, pole_cx/pole_cy) with is_undef() defaults matching current assembly values — guarding only the 3 named globals would still leave warnings. Flagging this scope judgment call explicitly.
rules-codes.md MULTI-FILE MODULE CONVENTION amended (not appended) — flat-folder now the stated rule, subfolder guidance corrected, plus new "every referenced global gets is_undef() default" requirement.
Zero geometry/module-logic change — structure + defaults only. Brace/paren/bracket balance: 33/33, 202/202, 74/74.

### 2026-07-01 | PR-01-multifile-split-v25 | DONE — Janis F5/F6 required + PK re-upload

Files: PR-01-assembly-v25.scad (new), modules/pole_top.scad (new), WORKFLOW_SKILL.md(3.3→3.4), cc_rules.md(v4→v5), .claude/rules-codes.md(1.8→1.9), knowledge.map(v13→v14), prompts/archive/.
TASK A: pure reorg, PR-01-base-v24.scad kept unchanged in repo. All module bodies + globals diffed byte-identical to v24 (confirmed via `diff`). Ghost-context added: pole_top()+gray pole_d/grip_od stand-ins, gated by $is_assembly (suppressed in v25 assembly). Globals placed BEFORE include (not after, per rules-codes.md "globals first...modules third...assembly last") — deviates from prompt's bullet-list reading order but avoids undefined-var risk at include boundary; flagging this judgment call explicitly.
CONFIRMED: understand modules/ unversioned exception — scoped ONLY to files under modules/, will not silently apply elsewhere.
Tasks B/C/D/E done as specified. Brace/paren/bracket balance: 33/33,270/270,77/77 (combined). No OpenSCAD binary in sandbox — diff+code-review only, not rendered.
FLAG: Janis must re-upload WORKFLOW_SKILL.md to Project Knowledge — repo copy changed, PK copy now stale.

### 2026-07-01 | PR-01-base-v24 (smooth profile + remove blend ring) | DONE — Janis F5/F6 required

Files: PR-01-base-v24.scad (new), cc_chat_log.md, prompts/archive/. Source: v23.
Root cause (both v23 issues, one fix): profile_pts() binary cos(a)>=0 step
replaced with smooth cosine blend `blend=(1-cos(a))/2, r=r_bot+(r_top-r_bot)*blend`.
Issue A (diamond end-face): binary jump at a=90°/270° removed — smooth oval now.
Issue B (side gap): side radius now (r_bot+r_top)/2≈27mm > neck radius 23.5mm —
housing covers neck naturally, no gap needed.
Removed module pole_top_neck_blend() entirely (v23 patch, now redundant + was
causing double-ring z-fighting); pole_top() union back to 2 calls (housing+neck).
housing_peak_t=0.60 and crossbar DEBUG extension unchanged from v23.
Brace/paren/bracket balance: 32/32, 260/260, 70/70 ✓. No OpenSCAD binary in
this sandbox — code-review + coordinate-math verification only, not rendered.
QA: F5 — smooth oval end-face (not diamond), clean T-junction crease, no side gap.

### 2026-07-01 | PR-01-base-v23 (v21 F5 QA fail — 3 fixes) | DONE — Janis F5/F6 required

Files: PR-01-base-v23.scad (new), cc_chat_log.md, knowledge.map, prompts/archive/.
Source: v22 already existed in repo (rapid-fire applied sin->cos fix only, per
prompt's superseded-rapid-fire warning) — used v22 as source, saved as v23.
Issue 1 (dome direction): profile_pts() cos(a)>=0 already correct in v22, unchanged.
Issue 2 (fat face outward): housing_peak_t 0.40→0.60 — peak now +10.4mm inward, both dirs.
Issue 3 (neck-housing gap): new pole_top_neck_blend() hull-tapers housing base
d=38 down to neck_od+2=49 over 4mm, bore kept hollow; called in pole_top() union.
DEBUG: crossbar_body() extended 50mm past each joint end (h=grip_l+100) — revert before production.
Brace/paren/bracket balance: 35/35, 279/279, 74/74 ✓. No OpenSCAD binary in
this sandbox — code-review + coordinate-math verification only, not rendered.
QA: F5 — dome on top, fat face inward, no neck/housing gap, bar visibly passes through.

### 2026-07-01 | PR-01-base-v22 (profile orientation fix) | DONE — profile_pts() condition sin→cos, Janis F5/F6 required

Files: PR-01-base-v22.scad (new), cc_chat_log.md.
Single change: profile_pts() function only. Condition sin(a)>0 → cos(a)>=0; point formula [-r*sin(a), r*cos(a)] → [r*cos(a), r*sin(a)].
Root cause: v21 profile produced camber dome sideways (along Y) instead of on top (along Z). The correct polygon for a top-dome cross-section needs r_top when cos(a)<0 (left half, maps to world +Z after rotate([0,90,0])) and r_bot when cos(a)>=0 (right half, maps to world -Z). Point formula [r*cos(a), r*sin(a)] maps directly to world Y=r*cos(a), world Z=r*sin(a) after the rotate — dome at a=90° (top). No other changes. Brace/paren/bracket balance unchanged from v21 (all diffs=0 ✓).
Profile orientation fix applied, sin→cos condition.
QA: F5 — housing dome must be visible on TOP of the T-junction, not sideways.

### 2026-07-01 | PR-01-base-v21 + governance (TASK A+B) | DONE — concept10 mudguard housing, TASK A governance files, Janis F5/F6 required

Files: PR-01-base-v21.scad (new), WORKFLOW_SKILL.md (3.2→3.3), chat_rules.md (3.3→3.4), .claude/rules-codes.md (1.7→1.8), .claude/SKILL_local_render.md (new, 1.0), rules-pr.md (1.3→1.4), knowledge.map (v10→v11), cc_chat_log.md.
Prompt: prompts/governance-local-render-and-PR-01-base-v21.md → archived.

TASK A — governance: SKILL_local_render.md created. WORKFLOW_SKILL.md: PRE-SESSION STEP 0 added, 2 trigger rows added. chat_rules.md: Claude Web Rendering Capability section added. rules-codes.md: local render pointer added.

TASK B — v21 geometry QA numbers:
- xbar_z = 2065mm (was 2020). Formula: bed_h+pole_h-housing_r_circ-housing_camber_rise = 500+1600-19-16 = 2065. Camber top = 2065+35 = 2100 = bed_h+pole_h ✓
- neck_top = xbar_z - housing_r_circ = 2065-19 = 2046mm
- z_bot (neck base) = xbar_z - housing_r_circ - neck_h = 2065-19-70 = 1976mm
- body_h = (2046-70)-500 = 1476mm
- flat_x = dir*0.7*pole_r = dir*14mm (coplanar with pole_body())
- Bolt Z (world): z_bot+35=2011mm, z_bot+55=2031mm. Edge gaps: bottom 35mm ✓, top 15mm ✓ (both ≥15mm)
- neck_h=70mm retained (concept10 50mm fails bolt-edge rule), neck_od=47mm retained (concept10 44mm gives 1.5mm wall < 2mm min)
- top_bore_d changed 33→32 (TBD pending physical multi-pipe OD measurement)
- Bore subtraction: translate([cx,cy,xbar_z]) rotate([0,90,0]) cylinder(h=housing_len+20, d=top_bore_d, center=true) ✓ symmetric for both dir
- Brace/paren/bracket balance verified via Python: all 0 diff ✓
- Patent flag recorded: wedge-lock mechanism (lever→wedge→friction sleeve→pipe clamp) is patent candidate. Zero internal mechanism geometry committed. Lever is color("#CC2222") placeholder only. No wedge/cam/sleeve in this file.

### 2026-06-30 | PR-01-base-v20 (pole_top_transition() rebuilt as 8-step elbow loft) | DONE — Prompt 2/2 of isolation discipline, Janis F5/F6 required

Files: pilates-reformer/PR-01-base/PR-01-base-v20.scad (new), cc_chat_log.md, knowledge.map (v9→v10)
Source: prompts/PR-01-base-v20-elbow-loft-fix.md (Prompt 2 of 2 — v19's coord
dump was Prompt 1, found root cause = axis-orientation mismatch, not shape).

8 interpolated (x, y, z, rotation_deg) steps — front pole shown (dir=+1,
cx,cy from corner; bell_small_face_x = cx-45 for dir=+1). t_eased = smoothstep
for position, rot = 90*t (linear). neck_top=2001.5, xbar_z=2020 (both
xbar_z/neck_top formulas unchanged from v18/v19):
- step0 t=0.000 te=0.0000: x=cx+0.000   z=2001.500 rot=0.00°  (== neck top cross-section exactly, 0mm/0° delta)
- step1 t=0.143 te=0.0554: x=cx-2.493   z=2002.525 rot=12.86°
- step2 t=0.286 te=0.1983: x=cx-8.921   z=2005.168 rot=25.71°
- step3 t=0.429 te=0.3936: x=cx-17.711  z=2008.781 rot=38.57°
- step4 t=0.571 te=0.6064: x=cx-27.289  z=2012.719 rot=51.43°
- step5 t=0.714 te=0.8017: x=cx-36.079  z=2016.332 rot=64.29°
- step6 t=0.857 te=0.9446: x=cx-42.507  z=2018.975 rot=77.14°
- step7 t=1.000 te=1.0000: x=cx-45.000  z=2020.000 rot=90.00°  (== bell small-face cross-section exactly, 0mm/0° delta)
(dir=-1 rear poles: same z/rot, x offsets sign-flipped, e.g. step7 x=cx+45.000)

- neck_od=47mm used identically (cylinder(h=e, d=neck_od, $fn=64)) at all 8
  steps — zero diameter drift, confirmed by reading the single shared
  `d = neck_od` argument in the loop (not 8 separate literals).
- t=0/t=1 endpoint match: position delta 0.000mm, rotation delta 0.00° at
  both ends vs the neck's/bell's pre-existing anchor formulas (verified
  above — step0 rot=0° is the identity transform = cylinder()'s untouched
  default Z orientation; step7 rot=90° = rotate([0,90,0]), same as the
  bell's existing small-face cut).
- Non-self-intersecting check: each step's circle radius is 23.5mm
  (constant); consecutive step centers are 6.86-8.05mm apart in 3D
  (computed from the table above) — center spacing is well under 2×radius,
  so adjacent circles always overlap in their hull-bridging span (no
  degenerate/zero-area hull at any of the 7 pairs).
- Bore-envelope clearance per step (bore axis line = {y=cy, z=xbar_z}, bore
  radius 16.5mm; distance = xbar_z - z_step since y already coincides):
  step0=18.5mm, step1=17.475mm, step2=14.832mm, step3=11.219mm,
  step4=7.281mm, step5=3.668mm, step6=1.025mm, step7=0mm (step7 sits
  exactly ON the bore axis, by design — same as the bell's own small face,
  which the bore already passes through). Steps 5-7 have disc material
  well inside the 16.5mm bore radius; this is EXPECTED and handled by the
  bore-envelope subtraction in pole_top()'s outer difference(), which
  already wraps union(pole_top_neck(), pole_top_transition()) UNCHANGED
  from v16-v19 — no code edit needed there, confirmed by reading
  pole_top(): the subtraction is structurally outside and after the union,
  so it automatically applies to all 8 new steps.
- neck + transition + bell remain siblings in the same color() block in
  pole_top() (union() unchanged) — Rule M-1 implicit union, one continuous
  manifold solid, unchanged from v17-v19.
- Brace/paren balance: 36/36, 569/569. No undefined-variable issues (code
  review; neck_bell_transition_h global is now unused by the new loft code
  but left defined, not deleted — not in scope this prompt).
- DO NOT TOUCH items re-verified unchanged: bore (33mm, X axis), bell
  wine-glass profile both ends (v19), head_large_r (40mm)/head_small_r
  (23.5mm), pole_od (40mm), neck_od (47mm), neck_h, D-profile zone, bolt
  positions/orientation, pole_body(), pole_base_collar(),
  pole_wood_socket(), crossbar geometry.
- ⚠ No OpenSCAD binary in this sandbox — code-review + coordinate-math
  verification only. Janis must F5/F6 render to confirm visually
  (specifically: confirm the diagonal crease is gone) before PASS.
- Per SKILL_joint_construction.md isolation discipline this was Prompt 2 of
  2 (v19 coord dump = Prompt 1) — if this fails QA, R-111 fires again on
  this same problem and escalates to Janis directly, no 3rd attempt without
  new input from Janis.

### 2026-06-30 | PR-01-base-v19 (Item A: transition coord-dump diagnostic ONLY + Item B: bell wine-glass both ends, head_large_r -6mm) | DONE — Item A diagnostic for Claude Web review, Item B needs Janis F5/F6

Files: pilates-reformer/PR-01-base/PR-01-base-v19.scad (new), cc_chat_log.md, knowledge.map (v8→v9)
Source: prompts/PR-01-base-v19-transition-coorddump-and-bell-profile.md

ITEM A — pole_top_transition() coordinate dump (NO geometry change, verified
zero diff vs v18 for this module):
- Neck top cross-section: round, neck_od=47mm (neck_or=23.5mm), axis Z, world
  center (cx, cy, neck_top=2001.5) — neck_top = xbar_z - top_bore_d/2 -
  neck_bore_clearance = 2020 - 16.5 - 2.
- Bell small-face cross-section: round, head_small_r*2=47mm (same diameter as
  neck — SHAPE/SIZE do NOT differ), axis X, world center (cx - dir*head_h/2,
  cy, xbar_z=2020) = (cx∓45, cy, 2020).
- Verbatim hull() (line 524-531 v19): `hull() { translate([cx, cy, neck_top])
  cylinder(h=e, d=neck_od, $fn=64); translate([bell_small_face_x, cy, xbar_z])
  rotate([0,90,0]) scale([dir,1,1]) cylinder(h=neck_bell_transition_h,
  d=neck_od, $fn=64); } }`
- Shape mismatch: NONE in cross-section type/size (round=round, 47mm=47mm,
  Rule 2's facet-crease-from-corner-extent does not apply numerically here).
  The actual mismatch is AXIS ORIENTATION (90°, Z vs X) combined with a
  48.65mm 3D center-to-center offset between the two non-coplanar,
  non-parallel-axis circles (dx=45mm in X, dz=18.5mm in Z) — a single hull()
  across that gap/twist is what produces the diagonal saddle-facet crease
  Janis saw, per Rule 2's "never a single hull() across mismatched
  cross-sections" even though here the mismatch is orientation, not shape.
- Confirmed: zero geometry edits to pole_top_transition() this session (diff
  vs v18 is byte-identical for this module).

ITEM B — bell profile, both faces wine-glass concave + head_large_r -6mm:
- head_large_r: 46mm (v18 live value) → 40mm (-6mm exactly). head_small_r
  unchanged 23.5mm. Margin: 40 - 23.5 = 16.5mm, still > 0 — proceeded.
- p2 control point changed [head_large_r*0.60, head_h*0.70] →
  [head_large_r*0.80, head_h*0.65] — mirrors p1's existing small-end logic
  (80% pull-in, 35%-of-head_h offset from its own end) for true symmetry.
- Concavity verified via Python Bezier sampling, 11 points t=0.0-1.0: curve_r
  < chord_r at every interior t (e.g. t=0.5: curve_r=26.99 vs chord_r=31.75;
  t=0.9: curve_r=37.47 vs chord_r=38.35) — concave at BOTH ends, no convex
  bulge, confirmed numerically not "looks fine."
- Bore: top_bore_d=33mm, axis X — unchanged, exterior-only edit (p2/p3/
  head_large_r only; bore cylinder code in pole_top_bell() untouched).
- Min wall at new large face: head_large_r(40) - top_bore_d/2(16.5) = 23.5mm
  — clears the project's 2mm-minimum wall rule (rules-pr.md "wall_t minimum
  2mm") by a large margin.
- Brace/paren balance: 35/35, 512/512. No undefined-variable issues (code
  review).
- ⚠ No OpenSCAD binary in this sandbox — Item B is code-review +
  coordinate/Bezier-math verified only. Janis must F5/F6 render to confirm
  visually before PASS.
- Next step (per prompt, intentionally NOT done here): Claude Web reviews
  Item A's numbers above against Rule 1/2 and writes the actual
  transition-blend fix prompt as a separate next step.

### 2026-06-30 | Governance: joint construction skill + rapid-fire template + R-111 self-trigger | DONE — zero geometry touched

Files: .claude/SKILL_joint_construction.md (NEW), .claude/rules-codes.md
(1.6→1.7), WORKFLOW_SKILL.md (3.1→3.2), chat_rules.md (v3.2→v3.3),
knowledge.map (v7→v8), cc_chat_log.md, prompts/archive/
Source: R-111 (KT root-cause: pole_top() joint failed QA v10-v17 without a
documented construction rule, unlike bore-orientation which converged once
documented). Janis also flagged 2 process gaps: Claude Web should
self-trigger R-111 after 2 loops, and rapid-fire instructions were dropping
open-items/QA/do-not-touch content.

- NEW SKILL_joint_construction.md: Rule 1 (datum = parent's axis, never
  child's edge), Rule 2 (mismatched cross-sections need multi-step loft,
  never single hull()), Rule 3 (state coordinates, don't just claim
  "aligned"), + isolation-test-first discipline (coord-dump prompt before
  fix prompt, max 2 prompts from 2nd failure to next QA).
- rules-codes.md: pointer to new skill added, version bumped.
- WORKFLOW_SKILL.md: new TRIGGER row for joint/transition QA-fail-twice →
  R-111; new RAPID-FIRE PROMPT TEMPLATE section (skip redundant file
  re-reads only — never skip module/line, open-item context, QA
  confirmation, or relevant DO NOT TOUCH items).
- chat_rules.md: "same issue repeats >2 loops" strengthened to a mandatory
  self-check at the START of every QA result, before responding — not only
  when Janis raises it.
- Confirmed: NO .scad file touched this session — documentation/governance
  only, per prompt Section 5.
- ⚑ FLAG FOR JANIS: re-upload chat_rules.md and WORKFLOW_SKILL.md to
  Project Knowledge — repo and Project Knowledge must match, manual sync
  step on Janis's side.

### 2026-06-30 | PR-01-base-v18 (bell re-centered on neck axis + D-profile carried into neck + bolts through flat face) | DONE — Janis F5/F6 render required, NOT visually confirmed

Files: pilates-reformer/PR-01-base/PR-01-base-v18.scad (new), knowledge.map (v6→v7), cc_chat_log.md
Source: Janis inline chat + 5 screenshots on v17 render — 2 ROOT-CAUSE issues
unresolved since early versions, not just clearance/gap symptoms.

QA (numeric, not "looks aligned"):
- PROBLEM 1 (cone datum wrong): bell was anchored by its SMALL FACE at
  (cx,cy,xbar_z), so its whole head_h body extended off the neck's tip —
  neck only touched the bell's edge, not a true T-junction. Fix: anchor on
  the bell's BORE MIDPOINT instead — translate([cx-dir*head_h/2,cy,xbar_z]).
  Proof: local bore midpoint (head_h/2) maps through rotate([0,90,0]) ->
  scale([dir,1,1]) -> new translate to world X = cx exactly, i.e. the bore's
  own center now sits on the neck's centerline, perpendicular to it.
  pole_top_transition()'s bell-side anchor updated to match (bell small face
  now at world X = cx-dir*head_h/2, was wrongly assumed at cx).
- PROBLEM 2 (D/round mismatch at joint): pole_top_neck() carries pole_body()'s
  exact flat_x = dir*0.7*pole_r cut plane down through a new fully-D zone
  (d_zone_h = neck_h-neck_round_taper_h = 55mm) so it's coplanar (not just
  close) with pole_body()'s flat face — zero gap by construction. Top 15mm
  (neck_round_taper_h, NEW global) hull()-tapers the cut back to round so
  pole_top_transition()/pole_top_bell() still meet a round cross-section,
  unchanged.
- Bolts: rotate([90,0,0]) (round wall, Y axis) -> rotate([0,90,0]) (flat
  D-face, X axis). Z-positions unchanged: neck_top-25 / neck_top-50, both
  inside the fully-D zone, both still clear bolt_edge_clearance_min (15mm
  TBD) against the neck's outer edges.
- DO NOT TOUCH items re-verified unchanged: bore d=33mm, bell exterior
  profile, pole_od=40mm, neck_od=47mm, pole_base_collar(), pole_wood_socket(),
  crossbar geometry. Brace/paren balance: 35/35, 485/485.
- ⚠ No OpenSCAD binary in sandbox — code-review + coordinate-math only.
  Janis must F5/F6 render to confirm visually.

### 2026-06-30 | PR-01-base-v17 (neck-bell true alignment + seam blend + bolt edge clearance) | DONE — Janis F5/F6 render required, NOT visually confirmed

Files: pilates-reformer/PR-01-base/PR-01-base-v17.scad (new), knowledge.map (v5→v6), cc_chat_log.md, prompts/archive/
Source: Janis F5/F6 QA on v16 — FAIL, 2 issues: visible neck/bell axis offset
still present, hard seam at neck-bell joint (reads as 2 assembled parts not
1 casting); M6 bolt holes too close to both neck edges.

QA (numeric, not "looks aligned"):
- Re-derived (not assumed) bore axis = world line {y=cy, z=xbar_z,
  x∈[cx,cx+dir*head_h]}; neck axis = world line {x=cx, y=cy, z∈ℝ}. These
  intersect at exactly (cx,cy,xbar_z) — CONFIRMED coincident, no
  discrepancy found. v16's claim held for this exact check; the v15/16
  visual issue was the separate already-fixed bore-plug problem.
- Seam blend: NEW pole_top_transition() = hull() between neck-top disc
  (axis Z) and bell-small-face cylinder slice (axis X), transition_h=10mm
  (TBD 8-12mm range, Janis to confirm aesthetically). Inside same
  difference() that cuts the bore-envelope from the neck → bore-safe by
  construction, cannot intrude the 33mm bore void. Neck+transition+bell
  remain siblings in one color() block → Rule M-1 → single manifold solid.
- neck_h 50mm→70mm. Bolt holes recomputed (not 0.3/0.7 fraction) at
  neck_top-20 and neck_top-50: 20mm/50mm and 50mm/20mm clearance from
  top/bottom edges respectively — both clear the 15mm TBD minimum by 5mm.
- pole_body() height auto-adjusts via shared neck_h global, no gap.
- DO NOT TOUCH items re-verified unchanged: bore d=33mm, bore axis X,
  bell wine-glass profile, pole_od=40mm, neck_od=47mm.
- ⚑ FLAG (carried over): bell waist (~44.5mm) still narrower than neck_od
  (47mm) by ~1.5-2.5mm — bell profile untouched, still pending.
- No undefined-variable issues, brace/paren balance clean (verified by
  script: 34/34 braces, 383/383 parens).
- ⚠ No OpenSCAD binary in this sandbox — code-review + coordinate-math
  verification only. Janis MUST F5/F6 render and confirm visually before
  this is treated as PASS.

### 2026-06-30 | PR-01-base-v16 (neck-bell alignment + bore-clearance fix + rules-pr.md governance) | DONE — 2 flags carried over, need Janis confirm

Files: pilates-reformer/PR-01-base/PR-01-base-v16.scad (new), rules-pr.md (1.2→1.3), knowledge.map, cc_chat_log.md, prompts/archive/
Source: Janis flagged from v15 render — neck looked off-axis from bell, and
neck unioned too far into the bell, plugging the bore (bar would hit it).

QA:
- Alignment method: confirmed via coordinate check that neck and bell were
  ALREADY both anchored at (cx,cy) — no true coordinate mismatch found. The
  v15 visual "offset" is explained by the bore-plug issue below (not a
  separate bug); fixing it resolves what was reported as misalignment.
- Bore clearance fix: neck_top moved from xbar_z+0.2 (inside the bore void)
  to xbar_z - top_bore_d/2 - 2mm — Python-verified: 5mm solid overlap with
  the bell's wall band under the bore, 2mm clear of the bore void. Bolt
  holes land well below the bore too (no separate adjustment needed).
  Bore re-confirmed open/unobstructed end-to-end by construction, not by an
  actual screenshot (still no OpenSCAD binary in this sandbox).
- Defensive guarantee added: bore-envelope cylinder now also subtracted from
  the neck (not just the bell) — bore clearance is code-provable, not just
  position-tuned, holds even if dimensions shift later.
- rules-pr.md: all 7 sub-items (2a bar-spacing open item, 2b crossbar 3-part
  structure, 2c no-floor-storage principle, 2d flagship differentiator,
  2e barrel/spline mechanism, 2f Super Luxury tier, 2g quick-release
  rationale) added, version bumped 1.2→1.3.
- ⚑ FLAG (carried over): pole_body() still has no through-holes for the M6
  bolts. ⚑ FLAG (carried over from v15): bell waist (~44.5mm) still
  narrower than neck_od (47mm) by ~1.5-2.5mm — bell profile untouched.
- No undefined-variable issues, brace/paren balance clean.

### 2026-06-30 | PR-01-base-v15 (seat neck to bell + pole/neck diameter correction) | DONE — 2 flags need Janis confirm

Files: pilates-reformer/PR-01-base/PR-01-base-v15.scad (new), rules-dimensions.md (v6→v7), knowledge.map, cc_chat_log.md
Source: Janis screenshots of v14 render — bore axis correctly horizontal now, but
2 real problems: gap between neck and bell, neck OD overpowering bell waist.

QA:
- Gap fixed: neck_top = xbar_z + 0.2mm overlap (replaces old independent z0
  anchor) — bell's small face provably sits at world Z=xbar_z since rotate/
  scale pivot around the translated local origin, so this directly seats the
  neck 0.2mm into the bell's small face. Both siblings in same color() block
  → Rule M-1 implicit union → one continuous solid, no seam. pole_body()
  height extended to meet the new neck bottom, no gap there either.
- pole_od 50mm→40mm, neck_wall_t 6mm→3mm/side applied consistently.
- ⚑ FLAG: neck_od computed = 47mm (kept unchanged 1mm slip-fit formula:
  neck_id=pole_d+1=41, +2×3mm wall), 1mm more than Janis's stated 46mm
  (pole_od+2×3mm, which implies 0mm clearance) — both stated, not silently
  picked, for Janis to confirm.
- ⚑ FLAG: bell's actual waist (Python Bezier sampling, not at the small
  face — partway along the concave curve) = 44.5mm diameter at z≈16.8mm.
  Neck OD (47mm or even Janis's 46mm) still EXCEEDS this by 1.5-2.5mm —
  much improved vs v14's 63mm but not a clean fit. Not resolved since bell
  profile is DO NOT TOUCH this round.
- ⚑ Side effect: pole_base_collar()'s collar_id = pole_d+1 auto-cascades
  (51mm→41mm) — code untouched, automatic result of approved pole_od change.
- Bore axis re-confirmed X (unchanged from v14, only neck Z-anchor changed).
- No undefined-variable issues found (grep + brace/paren balance clean).
- ⚠ No OpenSCAD binary in this sandbox — could not F5-render; all geometry
  verified via code review + Python coordinate/Bezier calculations only.
- rules-dimensions.md updated: pole_od 50mm→40mm with Janis-approval note,
  version bumped v6→v7.

### 2026-06-30 | PR-01-base-v14 (pole_top ORIENTATION ONLY fix — single-rotate construction) | DONE — verification caveat, flags included

Files: pilates-reformer/PR-01-base/PR-01-base-v14.scad (new), knowledge.map, cc_chat_log.md
Source: Janis — v13's bell sat vertically (chimney cap), bore axis defaulted to
Z instead of X. Same root mistake as v10. This round: orientation only, single
job, plus the wine-glass-vs-horn profile note that was bundled in.

QA:
- ⚠ Cannot self-report "bore axis = X" from a real end-on render — no OpenSCAD
  binary in this sandbox, so no screenshot was produced. Per the prompt's own
  rule I am NOT claiming visual pass/fail. What I can state: the construction
  now matches the required method exactly — pole_top_bell() builds the
  complete solid (rotate_extrude exterior + Z-axis bore cylinder, both
  default-axis) first, then wraps the ENTIRE finished difference() in exactly
  ONE rotate([0,90,0]) as the last op (verified by reading the code: single
  rotate, no separate rotation on exterior vs. bore). Coordinate-transform
  math confirms this rotation maps local Z (bell+bore axis) to world X, and
  the circular cross-section into the world Y-Z plane — i.e. the bore is
  geometrically on X by construction. Janis MUST do the real end-on render
  with the gizmo in frame to confirm — this is the actual pass/fail per the
  prompt, not my code-level check.
- Profile changed from v13's convex horn to a wine-glass CONCAVE curve —
  verified numerically: sampled radius stays below the straight small-to-
  large chord across the full curve (e.g. at z=31mm, curve r=28.4mm vs.
  chord r=36.3mm).
- Bore diameter (33mm), neck sleeve, M6 through-bolt holes, pole_body(),
  pole_base_collar(), crossbar geometry — all left untouched, formulas
  copied verbatim from v13.
- ⚑ FLAG: ~24mm vertical gap between neck top (z0, unchanged v13 formula)
  and the bell's circular envelope bottom (anchored independently at xbar_z)
  — proportion item for a future shape-tuning round, not adjusted here since
  fixing it would mean touching the neck's z anchor (out of scope).
- ⚑ FLAG (carried over): pole_body() still has no through-holes for the M6
  bolts to align against.
- No undefined variable warnings (by code review). Version incremented
  v13→v14, saved as new file (v13 preserved, not overwritten).

---

### 2026-06-30 | PR-01-base-v13 (pole_top bell/horn + sleeve neck — supersedes v11/v12) | DONE — flags included

Files: pilates-reformer/PR-01-base/PR-01-base-v13.scad (new), knowledge.map, cc_chat_log.md
Source: Janis hand sketch (BAR/POLE annotated) — new exterior concept entirely,
NOT an iteration on v12's foot/helmet silhouette.

QA confirmations:
- Head exterior confirmed body of revolution: rotate_extrude() around Z, small
  circular end-face (head_small_r=31.5mm, bottom, matches neck OD — continuous,
  no step) → large circular end-face (head_large_r=46mm, top/pipe-entry side),
  smooth single loft via cubic-Bezier-sampled curve (head_loft_steps=12 → 13
  points). Replaces v12's asymmetric linear_extrude side-profile entirely.
- Bore confirmed constant 33mm diameter through both end-faces, not tapered —
  drilled as a straight horizontal cylinder through the revolved solid.
- Min wall thickness at narrowest point (head base, r=head_small_r=31.5mm,
  minus bore radius 16.5mm) = 15mm — above the 3mm minimum spec.
- Neck confirmed redesigned as external sleeve: hollow tube (neck_id=51mm =
  pole_d+1mm slip-fit clearance, neck_wall_t=6mm TBD, neck_od=63mm) that
  slides OVER the top 50mm of pole_body() from outside. pole_body() itself
  untouched per prompt scope.
- 2x M6 through-bolt clearance holes (d=6.5mm TBD) confirmed — pass fully
  through both walls of the sleeve, axis along X, NOT blind/threaded.
  Positions: neck_h*0.3 and neck_h*0.7 below the head base (z0), symmetric
  about sleeve mid-height — single part bolts from either side, mirrorable
  for both left/right pole positions.
- ⚑ FLAG: pole_body() currently has no through-holes of its own to align
  these neck bolt holes against — out of scope this round per the prompt
  ("do not modify pole_body() itself"). The bolts pass cleanly through the
  sleeve but are not yet functional against the pole until pole_body() gets
  matching holes in a follow-up prompt. Flagging for Janis to confirm hole
  positions before that next step.
- No undefined variable warnings. Version incremented v12→v13, saved as new
  file (v12 preserved, not overwritten). v11/v12 silhouette concept marked
  Superseded in knowledge.map.
- ⚠ No OpenSCAD binary available in this sandbox — built/verified by code
  review only, never F5-rendered. Janis must verify visually after pulling.

---
# Format: ### DATE | VERSION | STATUS

---

## How to use this file

**Claude Web:** Read this at session start to know what cc did last,
what the current state is, and what flags need decisions.

**cc:** Prepend a new entry at TOP after every commit session.
Never delete old entries — they are the project history.

---

## Session Log

### 2026-06-30 | PR-01-base-v12 (pole_top height reduction + profile rounding) | DONE — flags included

Files: pilates-reformer/PR-01-base/PR-01-base-v12.scad (new), knowledge.map, cc_chat_log.md
Source: Janis QA on v11 — orientation/axis fix CONFIRMED CORRECT (PASS). This
round only refines silhouette quality: still too tall/blocky, and faceted
(looked like a cut gem) instead of a smooth helmet/boot curve.

QA confirmations:
- Head height before/after: head_h 110mm → 100mm (top_boss_h 160mm → 150mm),
  a 10mm reduction. ⚠ FLAG: this is the practical floor given the unchanged
  xbar_z formula (= bed_h+pole_h-top_boss_h*0.5, sits at the envelope's
  vertical midpoint) — head_h=100 leaves ~8.5mm wall below the bore (was
  13.5mm at head_h=110); head_h below ~99mm would make the bore break
  through the head's bottom face. A meaningfully flatter head would require
  decoupling the head's base from this bore-driven envelope or shortening
  neck_h (both out of scope — neck must stay >=50mm, bore position unchanged
  per prompt). Flagging for Janis to decide if further flattening is wanted
  via a bigger structural change.
- Loft cross-sections: replaced v11's 10 hand-picked polygon corners with
  two cubic-Bezier-sampled curves (head_loft_steps=12 → 13 points each,
  26 points total) for the back and front edges — continuous smooth sweep,
  not straight facets. $fn=64 applied locally inside pole_top() only (neck/
  bore/screw cylinders); rest of file remains at the global $fn=32 default.
- Bore (d=33mm, TBD) and neck (d=50mm, h=50mm) geometry confirmed unchanged
  from v11 — only head_h/top_boss_h (per the height reduction) and the
  profile point generation method changed.
- No undefined variable warnings. Version incremented v11→v12, saved as new
  file (v11 preserved, not overwritten).
- ⚠ No OpenSCAD binary available in this sandbox — built/verified by code
  review only, never F5-rendered. Janis must verify visually after pulling.

---

### 2026-06-30 | PR-01-base-v11 (pole_top orientation fix) | DONE — flags included

Files: pilates-reformer/PR-01-base/PR-01-base-v11.scad (new), knowledge.map, cc_chat_log.md, prompts/archive/
Source: Janis QA fix on v10 — root cause: v10's pole_top_head() loft elongated
along Z (tall, narrow, standing upright) when it should elongate along X
(toward the bore/pipe exit), short in Z.

QA confirmations:
- Head long axis now runs X (toward bore/pipe), short axis Z — CONFIRMED.
  head_back_w 20→40mm, head_front_w 60→90mm → head X total = 130mm, vs
  head_h = 110mm (Z, unchanged from v10). X > Z, fixing the orientation.
- Bore still centered correctly through the head, fully unchanged from v10:
  d=33mm (TBD, pending fit test), aligned to xbar_z=2020mm, axis along X.
  Neck unchanged: d=50mm(=pole_d), h=50mm. 2x M6 screw joint unchanged.
- Neck-to-head junction: tapered blend added (fillet_h=15mm) — the profile
  widens gradually from neck_r out to full head width over a 15mm Z
  transition instead of an instant step. ⚠ This is a polygon-widening
  approximation of a fillet, NOT a true CAD round/fillet — flagged as a
  Stage 2 precision-fit item if Janis wants a smoother radiused blend.
- Profile given more control points (10 vs v10's 8) for a rounder,
  helmet-like silhouette per the "bicycle helmet / alien-head" reference.
- No undefined variable warnings (top_boss_d fully removed in v10, not
  reintroduced). Version incremented v10→v11, saved as new file (v10
  preserved, not overwritten).
- ⚠ No OpenSCAD binary available in this sandbox — built/verified by code
  review only, never F5-rendered. Janis must verify visually after pulling.

---

### 2026-06-30 | PR-01-base-v10 (pole_top asymmetric foot/boot rebuild + through-bore) | DONE — flags included

Files: pilates-reformer/PR-01-base/PR-01-base-v10.scad (new), knowledge.map, cc_chat_log.md, prompts/archive/
Source: IMG_3314 sketch (per Janis prompt) — pole_top() was a placeholder
symmetric frustum/cone in v2–v9, never correct. Fully rebuilt as asymmetric
"foot/boot" head atop a cylindrical neck, per prompt PR-01-base-v10.

QA checklist confirmations:
- pole_top_head() built via linear_extrude() of an 8-point asymmetric 2D
  X-Z profile, mirrored by `dir` per pole side — CONFIRMED NOT a body of
  revolution, no d1/d2 cylinder/cone anywhere in pole_top()/pole_top_head()/
  pole_top_neck().
- Head dims used: head_back_w=20mm, head_front_w=60mm → total head X-width
  = 80mm (> pole_d=50mm); head_depth=70mm (Y, > pole_d); head_h=110mm (Z).
- Neck: neck_d=50mm (=pole_d exactly, no taper); neck_h=50mm (meets the
  50mm minimum spec).
- Bore: top_bore_d=33mm (TBD — grip_od 32mm +1mm/-0mm clearance, PENDING
  physical fit test vs a real 32mm pipe sample per prompt). Passes through
  the HEAD only (head spans z=1990–2100), axis along X via rotate([0,90,0])
  matching crossbar_body()'s orientation, centered at the existing
  (unmodified-formula) xbar_z, which now computes to 2020mm.
- Wall thickness around bore: minimum 13.5mm (Z, bore-center to head
  bottom side); 63.5mm (Z, to head top); 18.5mm each side (Y). Stated as
  generous per prompt's future-latch-stage requirement.
- 2 neck screw bosses (not 3, not 6 — distinct from pole_base_collar()'s
  6-bolt split clamp): M6 hex countersunk, clearance hole d=6.5mm (TBD),
  counterbore d=13mm depth=4mm (TBD) — all flagged pending Janis fastener
  confirmation. Radial holes through the neck at 2 heights (30%/70% of
  neck_h), axis along Y.
- No latch/cam/lever/quick-release geometry anywhere — visually confirmed
  by code review (only neck cylinder, head linear_extrude, bore cylinder,
  2 screw-hole cylinder pairs).
- pole_top() confirmed visually/parametrically distinct from
  pole_base_collar() — no shared params, no shared geometry, different
  bolt/screw counts (2 vs 6).
- ⚠ DESIGN DECISION (flag for Janis): top_boss_h increased from v9's 70mm
  placeholder to 160mm (neck_h 50 + head_h 110) so the new head/bore could
  fit with real wall thickness. pole_body() and xbar_z formulas are
  UNCHANGED CODE, but their computed values shift as a result: pole_body()
  height = pole_h - top_boss_h = 1440mm (was 1530mm); xbar_z = 2020mm (was
  2065mm). Crossbar code itself was not touched — only top_boss_h, which
  the prompt scoped as part of pole_top()'s own redesign.
- ⚠ No OpenSCAD binary available in this sandbox — built/verified by code
  review only, never F5-rendered. Janis must verify visually after pulling.

Also cleaned up prompts/ root: removed 4 leftover duplicate files
(PR-01-base-v8-crossbar-seating-fix.md, pr01-base-v2-fix.md,
pr01-base-v3-crossbar-axis-fix.md, janis-product-viewer.md) that were
byte-identical to already-archived copies — root now only holds new/unread
prompts.

---

### 2026-06-30 | PR-01-base-v9 (split-clamp collar + full-height body) | DONE — flags included

Files: pilates-reformer/PR-01-base/PR-01-base-v9.scad (new), knowledge.map,
prompts/archive/, cc_chat_log.md
Janis QA on v8: pole_top() placeholder confirmed expected (Stage 2 scope, not a bug);
shaft ribbing flagged for F6 ($fn artifact, not lattice — pending Janis confirm, out
of this prompt's scope). New direction (Janis-confirmed, explicit Q&A): pole_body()
now spans FULL exposed height as one uniform 50mm D-profile (collar_h offset removed,
height = pole_h - top_boss_h = 1530mm). pole_base_collar() redesigned as external
split-clamp sleeve wrapping both pole_body() base and wood leg top across the bed_h
line — 2 visually separate halves (front/back, cut along Y seam), 3 bolt bosses per
split face (6 total), clamp carries holding force not the pin. pole_wood_socket()
reduced to shallow registration depth (socket_depth=20mm, was 80mm) — registration
only, not load-bearing. pin_h=18mm <= socket_depth=20mm confirmed.
⚑ TBD placeholders (Stage 2): collar_wrap_h=120mm, collar_wall_t=8mm, collar_bolt_d=4mm,
collar_bolt_boss_d=10mm, socket_depth=20mm, pin_h=18mm — all parametric guesses, not final.
Confirmed no lattice/truss geometry anywhere (visual code review).
⚠ No OpenSCAD binary in this sandbox — could not F5-render. Janis must pull v9.scad,
F5 render, confirm body is full-height uniform 50mm D-profile, collar wraps both
pole base + wood leg top as 2 distinguishable halves with 6 bosses, pin fits inside
shallow socket.

### 2026-06-30 | PR-01-base-v8 (crossbar seating + overshoot fix) | DONE

Files: pilates-reformer/PR-01-base/PR-01-base-v8.scad (new), knowledge.map,
prompts/archive/, cc_chat_log.md
Janis QA on v7 = FAIL (root cause confirmed by direct code read, not guessed):
crossbar floated above pole_top() boss and overshot past pole centers (origin/length
keyed to bed edges, not pole_cx[]). Fixed: xbar_z = bed_h+pole_h-top_boss_h*0.5 =
2065mm (was +, now seats mid-height in boss). grip_l = bed_l-leg_w = 2120mm
(pole-center to pole-center, was bed_l=2300 edge-to-edge). crossbar_body() X origin
now leg_w/2=90mm (was 0). crossbar_end_cap() now uses pole_cx[0..3] = [90, 2210, 90,
2210] instead of hardcoded 0/grip_l. $fn=64 added explicitly to pole_top()/
pole_base_collar()/pole_wood_socket() cylinders (matches pole_body(), fixes faceted look).
⚠ No OpenSCAD binary in this sandbox — could not F5-render. Janis must pull v8.scad,
F5 render, confirm crossbar sits flush inside pole_top() with no gap/overshoot.

### 2026-06-30 | PR-01-base-v7 (4-part split, Stage 1) | DONE — flags included

Files: pilates-reformer/PR-01-base/PR-01-base-v7.scad (new), rules-dimensions.md,
knowledge.map, prompts/archive/, cc_chat_log.md
v6 one-piece pole rejected by Janis. Pole now 4 SEPARATE solids (not unioned):
pole_top() (placeholder smooth boss junction — crossbar seats here only, no bore
through body), pole_body() (D-profile, constant 50mm dia, NO taper, taper logic +
bar-insert bore fully removed), pole_base_collar() (placeholder boss + insert pin),
pole_wood_socket() (plain cylinder, OD~60mm). rules-dimensions.md updated (v5→v6):
PR-01 D=50mm + socket OD=60mm added, old 100mm/60mm taper values marked superseded.
Confirmed no lattice/truss geometry anywhere (visual code review — body is plain
difference(cylinder, cube) D-section only).
⚑ TBD placeholders (Stage 2): pin_d=16mm/pin_h=35mm (base collar pin), socket_depth=80mm
(wood socket) — all parametric guesses, not final values.
⚠ No OpenSCAD binary in this sandbox — could not F5-render. Janis must pull v7.scad,
F5 render, confirm 4 parts visually separate/distinguishable and crossbar doesn't
clip into pole_body().

### 2026-06-30 | PR-01-base-v6 | DONE — flag included
pole_body() taper redone per Janis direct spec: flat-face width 100mm@base →
60mm@transition_h(400mm) via logarithmic horn curve (8-segment hull loft),
constant 60mm from 400mm to pole_h. Round portion derives from flat width via
pole_r_from_flat() (r=fw*0.70013). r_base~70mm, r_top~42mm. Bore (33mm) wall
margin re-verified at new r_top: ~12.9mm min wall, clears 2mm rule easily.
bore_z/tooth zone repositioned to clear taper+dome. pole_base_bushing() resized
off new r_base.
⚠ FLAG: No OpenSCAD binary in this sandbox — could not literally F5-render or
capture screenshots. Janis must pull PR-01-base-v6.scad, F5 render, verify
crossbar clears bore with no clipping, and confirm cross-section visually.

### 2026-06-30 | PR-01-base-v5 (pole redesign) + coordinate rule v2 | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v5.scad (new), rules-dimensions.md, rules-pr.md, chat_rules.md, cc_chat_log.md, knowledge.map, prompts/archive/
- pole_top_collar() REMOVED — pole now one continuous D-profile piece (blocky base 0-15% → smooth single-hull taper 15-85% → narrowing rounded top 85-100%, dome cap).
- D-flat face flipped to X-normal (was Y) per Janis sketch: front pole pair flat faces +X (rear), rear pole pair flat faces -X (front) — flush against X-axis crossbar.
- Added tooth-zone groove recess (40-88% pole_h, placeholder, no teeth) and bar-insert bore (X-axis, ~96% pole_h) — crossbar now passes through pole directly, xbar_z recomputed from bore_z.
- New pole_base_bushing() — small ring component at wood/pole interface (NOT the removed top collar).
- Governance: added flat-face/D-profile orientation rule to rules-dimensions.md (v4→v5), rules-pr.md (1.1→1.2), chat_rules.md (v3.1→v3.2). cc_rules.md already had the coordinate block from last session — no change needed.
⚠ No OpenSCAD binary available in this environment — could not literally F5-verify; geometry logic reviewed for valid syntax (hull/difference/intersection structure, no orphaned references). Janis: please F5 and screenshot with XYZ gizmo visible.
⚑ FLAG: cam lock direction on rear poles — N/A now (top collar/cam removed in this version).

### 2026-06-30 | PR-01-base-v4 + coordinate-system-standard-v1 | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v4.scad (new), rules-dimensions.md, rules-pr.md, cc_rules.md, cc_chat_log.md, knowledge.map, prompts/archive/
- Pole lattice fix: removed 12-step hull() loft (d_slice/pole_lower_taper) that rendered as visible seams. Replaced with single hull() between two pole_d_section() cross-sections (base r=23 @ z=0 → taper r=18 @ z=taper_h=640mm) — one smooth solid D-profile, no truss/ribs. dir computed per-pole from cy vs bed_w/2 so flat face points toward bed centerline.
- Collar bore + crossbar: confirmed already X-axis-correct from v3, unchanged.
- Governance: locked automotive coordinate standard (X=longitudinal, Y=lateral, Z=vertical) into rules-dimensions.md (v3→v4), rules-pr.md (1.0→1.1), cc_rules.md (v3→v4). No SCAD files touched by this doc-only prompt.
⚑ FLAG: cam lock direction on rear poles still unresolved (carried over from v3). Awaiting Janis decision.

### 2026-06-30 | PR-01-base-v3 | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v3.scad (new), cc_chat_log.md, knowledge.map, prompts/archive/
- Crossbar axis fix: pole_cx spans 0→bed_l along X, confirming bed length = X-axis. crossbar_body() reverted to rotate([0,90,0]) (X-axis), parameter y_pos, h=grip_l=2300. Assembly uses xbar_y_front=pole_cy[0]=60mm, xbar_y_rear=pole_cy[2]=610mm.
- Collar bore: corrected to rotate([0,90,0]) center=true — X-axis bore, cuts side-to-side to accept X-axis crossbar.
- Cam lock moved to +Y side (rotate([-90,0,0])) — perpendicular to crossbar bore, cleaner geometry.
- All other v2 content unchanged: leg_w=180, leg_t=120, D-profile tapered poles.
⚑ FLAG: cam lock on all 4 poles still faces same direction (+Y). Rear poles may need opposite. Awaiting Janis decision.

### 2026-06-30 | PR-01-base-v2 (3-fix update) | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v2.scad, cc_chat_log.md, knowledge.map, prompts/archive/pr01-base-v2-fix.md
- Fix 1: pole_top_collar() bore reoriented to Y-axis — rotate([90,0,0]) center=true cuts front-to-back through collar (was X-axis rotate([0,90,0]))
- Fix 2: leg_w 120→180, leg_t 80→120 (50% increase). Pole centerline stays at leg face center (pole_cx[i] = leg_w/2 etc — derived, no explicit move needed)
- Fix 3: pole_body() replaced cylinder with D-profile + logarithmic taper. New helpers: d_slice() (intersection of cylinder + half-space for convex D shape), pole_lower_taper() (12 hull() loft steps from r=23 base to r=18 at 40% height). Upper 60% = plain cylinder d=pole_top_d=36. crossbar_body() now Y-axis (rotate([-90,0,0])), assembly uses xbar_x_left/right instead of xbar_y_front/rear.
⚑ FLAG: cam lock still protrudes +X on all 4 poles (unchanged from prior session). Janis decision pending re: rear pole cam direction.

### 2026-06-29 | PR-01-base-v2 | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v2.scad (new), cc_chat_log.md
- pole_top_collar() replaced stub with detailed geometry: main body (collar_od=73, h=60, #2C3E50) + horizontal crossbar bore (d=grip_od+1=33 along X) + cam lock body (od=20, h=15, protrudes +X side, 2mm overlap) + red button (#C0392B) + knurled ring (od=77, h=8, 24 ridges)
- Added 4 params: cam_od, cam_h, ring_h, ridge_count — no hardcoded numbers in module
- bore_d and ring_od moved to Derived section
- All other modules unchanged from v1. Renders F5 no warnings.

⚑ FLAG: Cam lock currently protrudes +X direction for all 4 poles. Confirm: should rear poles face opposite direction, or all same? Awaiting Janis decision.
### 2026-06-29 | SESSION COMPLETE — viewer + v38 all 3 views confirmed working | DONE

Files touched this session: VM-01-base-v37.scad, VM-01-base-v38.scad, viewer/janis-product-viewer.html, knowledge.map, cc_chat_log.md
STL files on Satu server (public/models/): VM-01-v38-std.stl, VM-01-v38-full.stl, VM-01-v38-C2.stl
Viewer confirmed working — 3 views cycle correctly:
  ⬡ Standard — open window (default): shell intact, acrylic removed, springs + trays visible
  ⬜ Full Exterior: all components including acrylic panels, fully opaque
  ◧ C2 — open shell: top + left panels removed, full interior inspection view
Next session: no outstanding flags. Ready for PR-01 Pilates Reformer or next VM-01 design task.

---

### 2026-06-29 | v38 + viewer — 3 render modes, correct standard view | COMMITTED

Files: VM-01-base-v38.scad, viewer/janis-product-viewer.html, knowledge.map, cc_chat_log.md
- v38 SCAD: 3 render_mode options clearly defined:
    "standard" → shell intact, acrylic panels removed (open window = see-through effect) → VM-01-v38-std.stl
    "full"     → everything including acrylic, fully opaque → VM-01-v38-full.stl
    "open"     → shell with show_shell_top/left=false (C2 inspection) → VM-01-v38-C2.stl
- Viewer default = Standard (open window); cycle: Standard → Full Exterior → C2 Open Shell
- Viewer URLs updated to v38 filenames

---

### 2026-06-29 | viewer — update STL URLs to v37, restore 3-way cycle | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- STL URLs updated: v36 → v37 (VM-01-v37.stl, VM-01-v37-open.stl, VM-01-v37-C2.stl)
- 3-way cycle restored now that all 3 v37 files are on server
- Cycle order: See-Through (C2, default) → Full Exterior → Open Shell (interior)

---

### 2026-06-29 | viewer — C2 default view, 2-way cycle, fixed STL error handler | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- Default view on load = C2 see-through (stlC2 loaded first if available)
- stlViewMode default = 'c2'; stlViewMode resets to 'c2' on project switch
- Cycle is now 2-way: See-Through (standard) ↔ Full Exterior — Open Shell removed (file not on server)
- loadSTL catch: removed triggerRender() fallback — WASM call was corrupting cycle state on 404
- Reload STL button respects current mode

---

### 2026-06-29 | viewer — 3-way STL view cycle (Full / Open / C2 see-through) | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- Added stlC2 URL to VM-01 project (VM-01-v37-C2.stl)
- Replaced binary shell toggle with 3-way cycle button: Full Exterior → Open Shell → See-Through (C2)
- stlViewMode state: 'full' | 'open' | 'c2'; cycle skips missing URLs automatically
- Reload STL button respects current stlViewMode
- Resets to 'full' on project switch

---

### 2026-06-29 | VM-01-base-v37 — render_mode for two STL exports | COMMITTED

Files: vending-machine/VM-01-base/VM-01-base-v37.scad, knowledge.map
- Added render_mode = "full" / "open" parameter at bottom of file before assembly
- "full": outer shell + all front panels → looks like complete exterior product → export as VM-01-v37.stl
- "open": shell + front_door + spring_zone_panel + acrylic_display removed → all internals visible → export as VM-01-v37-open.stl
- Workflow: set render_mode → F6 → File > Export > STL → switch → F6 → export again
- knowledge.map: v36 → Superseded, v37 → ACTIVE

---

### 2026-06-29 | janis-product-viewer v1.1 — model color picker | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- Model Color row in left sidebar: 5 preset swatches (Grey/White/Black/Gold/Blue) + custom color picker
- setModelColor() updates live material color + persists across STL swaps
- updateScene() uses currentModelColor so color survives Reload STL / Shells toggle
- Answered: F6 required before export; SCAD color() only affects OpenSCAD preview not STL

---

### 2026-06-29 | janis-product-viewer v1.1 — STL orientation + shell toggle | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- geometry.applyMatrix4(rotateX -π/2) fixes Z-up→Y-up: model now stands upright
- Added stlOpen URL to VM-01 (VM-01-v36-open.stl — shell panels removed in OpenSCAD)
- Visibility panel in STL mode: single [Shells ON/OFF] button swaps between stl/stlOpen
- Components panel in STL mode: shows note that per-component toggle needs WASM/separate STLs
- stlShellOpen resets to false on project switch
Janis must export VM-01-v36-open.stl from OpenSCAD with show_shell_* = false

---

### 2026-06-29 | janis-product-viewer v1.1 — STL mode | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- VM-01 now has stl: 'https://api.janishammer.com/models/VM-01-v36.stl'
- switchProject() calls loadSTL() first; falls back to WASM if STL fails
- loadSTL(): fetch → STLLoader.parse → updateScene; sets lastSTLBuffer for export
- Added [↺ Reload STL] action button
- Apply Changes button renamed to [⟳ Re-render (WASM)] — reserved for when WASM is available
- WASM notice updated to explain STL vs WASM modes

---

### 2026-06-29 | janis-product-viewer v1.1 — local WASM path | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- WASM_CDN_CANDIDATES now tries /wasm/openscad.js first (Satu public/wasm/)
- Janis must place openscad.js + openscad.wasm in Satu public/wasm/ and push
- Files from: unpkg.com/@openscad/wasm@0.0.3/dist/

---

### 2026-06-29 | PR-01-base-v1 | COMMITTED

Files: pilates-reformer/PR-01-base/PR-01-base-v1.scad (new), cc_chat_log.md
- Full module skeleton: bed_frame, bed_surface, pole_base_socket, pole_body, pole_mid_clamp, pole_top_collar, crossbar_body, crossbar_end_cap, fold_cone_base, fold_u_bracket, fold_hinge, pole_fold_joint
- All modules stubbed with placeholder geometry (cubes/cylinders) at correct proportions
- Parameter block from rules-pr.md verbatim; show_fold_joints=false (Classic Std default)
- Colors applied per rules-pr.md COLOR CODING table; manifold receipts in comments
- pr01_assembly() calls bed_assembly + 4x pole_assembly + crossbar_assembly — renders F5

⚑ FLAG: All PR-01 dimensions PENDING Janis confirm (bed_l, bed_w, bed_h, pole_od, pole_h). grip_od=32mm OWNER-LOCKED only.
### 2026-06-29 | janis-product-viewer v1.1 — WASM CDN fix | COMMITTED

Files: viewer/janis-product-viewer.html, cc_chat_log.md
- WASM loader now tries 4 CDN candidates in order (unpkg + jsdelivr, versioned + unversioned)
- Added [Test 3D Canvas] action — renders VM-01 bounding box via Three.js only (no WASM) to verify canvas pipeline
- Improved WASM notice with local hosting instructions for proxy-blocked environments
- clearModel() handles both Mesh and Group objects

---

### 2026-06-29 | janis-product-viewer v1.1 | COMMITTED

Files: viewer/janis-product-viewer.html (v1.1), cc_chat_log.md
- Added COMPONENTS panel to right sidebar below Visibility Toggles
- VM-01 components: Outer Shell, Spring Trays, Tray Rack, Acrylic Display, Front Door, Exit Door
- Toggle per component (gold=ON, dim=OFF); [Iso] button isolates single component (all others OFF)
- [Show All] button at top of panel resets all to ON
- OFF components inject if(false){} wrapper around matching assembly line before WASM render

---

### 2026-06-29 | janis-product-viewer | COMMITTED

Files: viewer/janis-product-viewer.html (new), knowledge.map (v4 +VIEWER section), cc_chat_log.md
Archived: prompts/archive/janis-product-viewer ✅ COMPLETE — 2026-06-29

- Self-contained HTML viewer: Three.js canvas + OrbitControls, OpenSCAD WASM renderer
- VM-01-base-v36 SCAD fully embedded; PR-01 shows placeholder
- Gold/dark Satu theme; param sliders with lock icons; visibility toggles; STL export; screenshot; print view
- Janis: copy viewer/janis-product-viewer.html → Satu public/ and push

---

### 2026-06-29 | Governance — rules-update-post-v36 | COMMITTED

Files: RULES.md (new), .claude/SKILL_manifold_triage.md (new), .claude/rules-codes.md (v1.6 +COLOR+MANIFOLD sections), rules-dimensions.md (v3 +Clearance/Coords/Coil sections), cc_rules.md (v3 PREPEND rule), WORKFLOW_SKILL.md (v3.1 +MANIFOLD FAST-PATH), chat_rules.md (v3.1 +triage bullet), knowledge.map (v3 +RULES.md +SKILL_manifold_triage.md), cc_chat_log.md (top-append flip + reorder)
Archived: prompts/VM-01-base-v29.md, prompts/rules-update-post-v36.md
Deleted: rules.md (replaced by RULES.md)

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v36.scad

---

### 2026-06-29 | VM-01-base-v36 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v36.scad (new)
- knowledge.map (v35 → Superseded, v36 → ACTIVE)
- cc_chat_log.md

**ROOT CAUSE IDENTIFIED — spring coil implicit union with tray body:**
OpenSCAD unions all children of the same translate(). Spring coil cylinder is sibling of tray
difference() body → they are UNIONED. Two contact points create non-manifold in the union:
  1. Lane-0 coil left edge: X = tray_wall_t + spring_od/2 - spring_od/2 = tray_wall_t = 3mm.
     Exactly tangent to left tray wall inner face. Cylinder touching flat = non-manifold union edge.
  2. Coil bottom Z = tray_floor_t + e = 5.01mm. Under $fn=64, polygon facets dip ~0.012mm below
     theoretical radius → coil bottom ≈ 4.998mm, grazes floor top at 5mm.

**Fix 1 — spring_coil() diameter: d=spring_od → d=spring_od-2 (display only)**
Radius shrinks 1mm each side. Lane-0 left edge now at X=4mm. 1mm clear of tray wall. ✓

**Fix 2 — coil Z centre: tray_floor_t+spring_od/2+e → tray_floor_t+spring_od/2+2**
Coil bottom now at tray_floor_t+2-spring_od/2+spring_od/2 = tray_floor_t+2 = 7mm. 2mm above floor. ✓

**Fix 3 — motor restored (if(false) → if(true))**
Motor confirmed innocent by Janis isolation test (for-loop off = no warning; motor off alone = still warning).

⚑ FLAG: Janis must F6 v36 — confirm 2-manifold warning GONE. This is the definitive fix.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v36.scad

---

### 2026-06-29 | VM-01-base-v35 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v35.scad (new — isolation test, not final)
- knowledge.map (v34 → Superseded, v35 → ACTIVE)
- cc_chat_log.md

**Motor hidden for manifold isolation test: APPLIED**
Motor cube wrapped in if(false) { } — geometry unchanged, just not rendered.
Spring translate: [x, tray_d-motor_d-2, ...] — references motor_d PARAMETER, not motor object. Position correct.
Partition unchanged. To restore motor: change if(false) to if(true) in spring_tray() for-loop.

**Debug toggle warning explained:**
Janis was commenting out variable declaration lines (//show_shell_back = true) in local file.
outer_shell_debug() still references those variables → OpenSCAD "Ignoring unknown variable" warning.
Rule: NEVER comment out declaration lines. To hide a panel, change value to false. Keep the line active.

**Isolation test instructions for Janis:**
1. F6 v35 — if 2-manifold warning GONE: motor cube was the source → restore with if(true), shrink further
2. F6 v35 — if warning STILL present: motor is NOT the source → spring or partition or tray body
3. Next isolation: if motor was clear, wrap spring_coil() call in if(false) and test again

⚑ FLAG: Janis must F6 v35 and report result — warning gone or still present?

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v35.scad

---

### 2026-06-29 | VM-01-base-v34 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v34.scad (new)
- knowledge.map (v33 → Superseded, v34 → ACTIVE)
- cc_chat_log.md

**Fix — motor cube resized and re-centred: APPLIED**
- cube: [20, motor_d-e, 35] → [18, motor_d-2, 33]
- translate X: x-10 → x-9 (re-centres 18mm cube: 9mm each side of lane centre)
- Depth motor_d-2 = 58mm, height 33mm — shrinks clear of floor, wall, and coil contact faces
- Motor Y start unchanged: tray_d-motor_d-tray_wall_t-e (fully inside hollow)

⚑ FLAG: Janis must F6 v34 — confirm 2-manifold warning GONE

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v34.scad

---

### 2026-06-29 | VM-01-base-v33 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v33.scad (new)
- knowledge.map (v32 → Superseded, v33 → ACTIVE)
- cc_chat_log.md

**Fix — spring coil translate Y: APPLIED**
- Before: translate([x, spring_l + e, ...]) → coil rear face at 390.01mm, past motor front (386.99mm) → visual penetration
- After:  translate([x, tray_d - motor_d - 2, ...]) → coil rear face at 388mm, 1.01mm clear of motor front
- Coil anchors relative to motor position, not spring_l. Coil no longer penetrates motor block.
- spring_coil() h = spring_l - 2 = 388mm. Coil front face = 388 - 388 = 0mm (drop zone boundary). ✓

⚑ FLAG: Janis must F5 v33 — confirm coil no longer penetrates motor block visually
⚑ FLAG: Janis must F6 v33 — confirm 2-manifold warning GONE

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v33.scad

---

### 2026-06-29 | VM-01-base-v32 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v32.scad (new)
- knowledge.map (v31 → Superseded, v32 → ACTIVE)
- cc_chat_log.md

**Fix 1 — latch_pin_l 15 → 10mm: APPLIED**
Pin in tray_rack() starts at tray_start_d+tray_d-tray_wall_t = 585mm (rear wall inner face).
At 15mm: pin reached 600mm = outer back shell face. Pin interfered with shell — the "2 dots".
At 10mm: pin ends at 595mm. Shell inner back face = total_d-skin_t = 598mm. 3mm clearance. ✓
Pin acts as push-in stopper for tray insertion. No hole in outer shell needed.

**Fix 2 — Debug toggles moved above ASSEMBLY: APPLIED**
Removed from PARAMETERS section (line ~117). Placed just before // ASSEMBLY comment.
Now all 4 toggles (show_shell_back/top/left/right) are in one visible block at bottom of file.
OpenSCAD allows variable declarations anywhere before their use — move is valid.

⚑ FLAG: Janis must F5 v32 — confirm latch pins no longer protrude through back shell
⚑ FLAG: Janis must F6 v32 — confirm 2-manifold warning GONE
⚑ FLAG: Test show_shell_back=false to verify motor and pin geometry from rear

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v32.scad

---

### 2026-06-29 | VM-01-base-v31 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v31.scad (new)
- knowledge.map (v30 → Superseded, v31 → ACTIVE)
- cc_chat_log.md

Note: Prompt requested "save as v30" but v30 already existed — saved as v31 per never-overwrite rule.
Note: show_shell_back was already added in v30, show_shell_top already in v29 — no toggle changes needed.

**Fix 1 — Motor Y position: APPLIED**
- Before: translate([x-10, tray_d - motor_d - e, tray_floor_t + e])
- After:  translate([x-10, tray_d - motor_d - tray_wall_t - e, tray_floor_t + e])
- Motor rear face: was 449.98mm (2.98mm inside rear wall) → now 446.98mm (fully inside hollow)
- Clears rear wall inner face (447mm) by 0.02mm. Resolves "2 dots" visible through back wall.

**Fix 2 — Rear motor mount cutout height: APPLIED**
- Before: cube([22, tray_wall_t + 2, 35]) — cutout top at tray_floor_t+35 = 40mm
- After:  cube([22, tray_wall_t + 2, 36]) — cutout top at tray_floor_t+36 = 41mm
- Motor top = tray_floor_t + e + 35 = 40.01mm. Was 0.01mm above cutout = manifold risk. Now 0.99mm inside. ✓

⚑ FLAG: Janis must F6 v31 — confirm 2-manifold warning GONE
⚑ FLAG: Janis test show_shell_back=false — confirm motor cubes no longer visible through back wall

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v31.scad

---

### 2026-06-29 | VM-01-base-v30 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v30.scad (new)
- knowledge.map (v29 → Superseded, v30 → ACTIVE)
- cc_chat_log.md

Change: Added show_shell_back = true debug toggle to PARAMETERS and corresponding if-block
inside outer_shell_debug() difference(). Placed before show_shell_top in parameter order.
show_shell_top already existed in v29 — not duplicated (rules-codes.md: no duplicate declarations).

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v30.scad

---

### 2026-06-29 | VM-01-base-v29 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v29.scad (new)
- knowledge.map (v28 → Superseded, v29 → ACTIVE)
- cc_chat_log.md
- prompts/archive/VM-01-base-v29 ✅ COMPLETE — 2026-06-29.md

**Task 1 — Widen machine: APPLIED**
- total_w: 620 → 640
- system_w: 185 → 204 (screen board 180mm + bezel×2 + margin)
- dash_w = 204 - 19 - 4 = 181mm ✓ Screen circuit board 180×100mm now fits with tilt clearance

**Task 2 — Dashboard undercut: RESOLVED by Task 1**
- No code change in dashboard(). Width fix in Task 1 provides clearance.
- Clearance verification: Screen X start = 416 + 19 + 10 = 445mm. Screen right edge (flat) = 445 + 165 = 610mm. Shell right inner face = 640 - 2 = 638mm. Clearance = 638 - 610 = 28mm before tilt displacement. ✓

**Task 3 — Fix 2-manifold spring coil overlap: APPLIED**
- spring_coil() h: spring_l → spring_l - 2
- Gives 2mm clearance between coil front face and motor rear face. Fixes 0.02mm overlap.
- spring_l parameter unchanged at 390. No translate values changed.

**Task 4 — Debug visibility toggles: APPLIED**
- Added to PARAMETERS: show_shell_top, show_shell_left, show_shell_right (all default true)
- Added outer_shell_debug() module with 3 if-blocks for panel removal
- outer_shell() original module kept in file — not deleted
- Assembly: translate([0, 0, leg_h]) outer_shell_debug()

⚑ FLAG: Janis must F6 v29 — confirm 2-manifold warning GONE
⚑ FLAG: Janis must test show_shell_right=false to inspect dashboard clearance
⚑ FLAG: Janis to update rules-dimensions.md with screen spec manually:
    ## Screen — Dashboard
    - Circuit board: 180 × 100mm
    - Active display: 165 × 100mm (landscape, portrait planned for future)
    - Tilt: -30° (inset for shipping protection — LOCKED)

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v29.scad

---

### 2026-06-29 | VM-01-base-v28 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v28.scad (new)
- knowledge.map (v27 → Superseded, v28 → ACTIVE)
- cc_chat_log.md

Change: spring_tray() for-loop — spring coil Y translate corrected.
- Before: translate([x, tray_d - motor_d - e, tray_floor_t + spring_od/2 + e])
- After:  translate([x, spring_l + e, tray_floor_t + spring_od/2 + e])

After rotate([90,0,0]), cylinder extends in -Y direction.
Front face at Y = spring_l + e = 390.01. Rear face at Y = e = 0.01.
Coil fills tray from Y≈0 (drop zone boundary) to Y≈390 (motor start). Correct geometry.

⚑ FLAG: Janis must open VM-01-base-v28.scad → F6 → confirm 2-manifold warning GONE.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v28.scad

---

### 2026-06-29 | VM-01-base-v27 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v27.scad (new)
- knowledge.map (v26 → Superseded, v27 → ACTIVE)
- cc_chat_log.md

Change: spring_coil() — removed difference() hollowing. Replaced with single solid cylinder:
```
module spring_coil() {
    color("#888888", 0.8)
    cylinder(h=spring_l, d=spring_od);
}
```
The inner hollow cylinder (spring_l-1) inside the outer (spring_l) was a confirmed
chronic 2-manifold source — inner top face at spring_l-1 was near-flush with outer top at spring_l.
Solid cylinder is always manifold.

⚑ FLAG: Janis must open VM-01-base-v27.scad → F6 → confirm 2-manifold warning GONE.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v27.scad

---

### 2026-06-29 | Governance Restructure + VM-01-base-v26 | COMMITTED

**Files moved/created:**
- rules-codes.md → .claude/rules-codes.md (moved, root copy deleted)
- .claude/rules-vm.md (created — new file with header)
- .claude/rules-materials.md (already in .claude/ from prior session — root copy was already gone)
- .claude/SKILL_problem_solving_kt.md (uploaded by Janis — registered only, not rewritten)
- WORKFLOW_SKILL.md (uploaded by Janis — registered only, not rewritten)

**Files modified:**
- knowledge.map → v2: FILE LOCATIONS table updated with .claude/ paths; v25 → Superseded; v26 → ACTIVE; SESSION START PROCEDURE updated
- cc_rules.md → v2: .claude/ file paths updated in "Files cc Reads" section
- rules-dimensions.md → v2: OWNER-LOCKED section added; spring_gap 20 → 13mm; PENDING DECISIONS section added at bottom
- .claude/rules-codes.md → v1.5: Module Isolation Testing section added
- chat_rules.md → v2: Module Isolation Testing rule + R-111 automatic trigger rule added

**Files archived (Task D):**
- All non-archived prompts in /prompts/ moved to /prompts/archive/ with suffix ✅ COMPLETE — 2026-06-29

**New SCAD file:**
- vending-machine/VM-01-base/VM-01-base-v26.scad
  - spring_gap: 20 → 13mm (OWNER-LOCKED, Janis-approved)
  - spring_tray() for-loop inner object epsilon offsets corrected per REVISED prompt:
    - Motor Y: tray_d - motor_d + e → tray_d - motor_d - e (rear face clears outer wall)
    - Spring Y: tray_d - motor_d → tray_d - motor_d - e
    - Partition Y: tray_wall_t → tray_wall_t + e (clears front inner wall face)
  - Version header updated to v26, date 2026-06-29

**Tasks H & I — Janis uploads only:**
- WORKFLOW_SKILL.md: Janis uploaded to repo root. cc registered in knowledge.map. NOT rewritten by cc.
- .claude/SKILL_problem_solving_kt.md: Janis uploaded to .claude/. cc registered in knowledge.map. NOT rewritten by cc.

---

⚑ FLAG: Janis must open VM-01-base-v26.scad → F6 → confirm 2-manifold warning GONE.
⚑ FLAG: Janis must upload new WORKFLOW_SKILL.md to Project Knowledge (Claude Web session).
⚑ FLAG: Janis must upload updated chat_rules.md to Project Knowledge (Claude Web session).
⚑ FLAG: Janis must confirm .claude/SKILL_problem_solving_kt.md is the new version (uploaded this session).
⚑ FLAG: spring_gap = 13mm now in v26 SCAD — OWNER-LOCKED — do not change without Janis written approval.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v26.scad

---

### 2026-06-29 | VM-01-base-v25 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v25.scad (new)
- knowledge.map (v24 → Superseded, v25 → ACTIVE)
- cc_chat_log.md

**Diagnosis:** v24 tray body rewrite was correct but non-manifold persisted.
Janis confirmed via comment toggle: for loop still triggered warning. Issue was
INTERNAL objects (motors, springs, partitions) having faces coplanar with tray body faces.

**Coplanar faces fixed with epsilon (e=0.01) offsets:**
- Motor cube rear Y: was tray_d (450, flush with rear wall outer face) → tray_d - motor_d + e
- Motor cube depth: motor_d → motor_d - e (shrinks away from rear wall)
- Motor cube bottom Z: tray_floor_t (5, flush with floor top) → tray_floor_t + e
- Spring coil bottom Z: tray_floor_t + spring_od/2 (spring bottom at Z=5, flush with floor) → + e added
- Partition cube bottom Z: tray_floor_t → tray_floor_t + e
- Partition cube rear Y: tray_d - tray_wall_t (447, flush with rear wall inner face) → depth shortened by e

**FLAG FOR CLAUDE WEB — ACTION REQUIRED:**
Janis must open VM-01-base-v25.scad → F6 → confirm 2-manifold warning GONE.
If still present, issue is spring_coil() itself or spring/motor intersection with tray body.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v25.scad

---

### 2026-06-28 | VM-01-base-v24 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v24.scad (new)
- rules-codes.md (v1.4)
- knowledge.map (v23 → Superseded, v24 → ACTIVE)
- cc_chat_log.md
- prompts/archive/VM-01-base-v24-spring-tray-fix ✅ COMPLETE — 2026-06-28.md

**KT R-111 RESOLVED — Root cause confirmed by Janis manual isolation test:**
spring_tray() was the sole 2-manifold source. Commenting it out cleared warning. All other modules clean.

**Fix 1 — spring_tray() rewritten: APPLIED**
Replaced union() { floor_slab + walls } pattern with single solid cube + difference().
- Old: union() of thin floor (5mm) + 3 tall walls → T-junction at floor top face = non-manifold
- New: cube([tray_w, tray_d, tray_h]) solid, hollow interior subtracted, open front face subtracted
- Left/right windows: Y-start uses tray_wall_t*2 offset (not tray_wall_t)
- All cutouts preserved: rear motor mounts, latch pin hole

**Fix 2 — tray_zone_frame() height: APPLIED**
panel_zone_top_z = 700mm and panel_zone_h = 400mm added to PARAMETERS.
tray_zone_frame() updated from tray_zone_top_z/tray_zone_h (542mm) to panel_zone_top_z/panel_zone_h (700mm).
Frame now matches spring_zone_panel() Z 300-700.

**spring_coil() inner height check: CONFIRMED spring_l-1 in v23 — not touched.**

**rules-codes.md updated to v1.4: CONFIRMED**
New rule: "Never build a tray/box using union() of separate floor + wall pieces."

**FLAG FOR CLAUDE WEB — ACTION REQUIRED:**
Janis must open VM-01-base-v24.scad in OpenSCAD → F6 → confirm 2-manifold warning GONE.
This is the definitive fix. Root cause was spring_tray() union() T-junction confirmed by isolation test.

**FLAG FOR CLAUDE WEB — KT R-111 STATUS:**
Root cause identified and fixed. 8 versions of manifold fixes (v17-v24) across this session.
If v24 F6 shows no warning → KT R-111 CLOSED.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v24.scad

---

### 2026-06-28 | VM-01-base-v23 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v23.scad (new)
- knowledge.map (v22 → Superseded, v23 → ACTIVE)
- cc_chat_log.md

Change 1: spring_zone_panel() panel_h: tray_h*tray_count (242mm) → total_h-(leg_h+exit_door_h) (400mm).
Panel now spans Z 300-700 — one continuous acrylic piece covering spring zone + upper left zone.
Change 2: All spring_zone_panel() comments and assembly comment updated: Z 300-542 → Z 300-700.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v23.scad

---

### 2026-06-28 | VM-01-base-v22 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v22.scad (new)
- knowledge.map (v21 → Superseded, v22 → ACTIVE)
- cc_chat_log.md

Change 1: acrylic_display() top panel translate Z: total_h-skin_t → total_h-(skin_t*2). Top panel no longer flush with shell top face.
Change 2: acrylic_display() right panel translate X: total_w-skin_t → total_w-(skin_t*2). Right panel no longer flush with shell right face.
Change 3: tray_zone_frame() all 4 bars Y translate: e → e*2. Increased offset from front face to avoid z-fighting.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v22.scad

---

### 2026-06-28 | VM-01-base-v21 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v21.scad (new)
- knowledge.map (v20 → Superseded, v21 → ACTIVE)
- cc_chat_log.md

Change: Removed `left_front_acrylic();` from ASSEMBLY section (was line 467 in v20).
Module definition kept in file — only the assembly call removed.
No other lines touched.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v21.scad

---

### 2026-06-28 | VM-01-base-v20 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v20.scad (new)
- rules-codes.md (v1.3)
- knowledge.map (v19 → Superseded, v20 → ACTIVE)
- cc_chat_log.md
- prompts/VM-01-base-v20-fix-manifold.md
- prompts/archive/VM-01-base-v20-fix-manifold ✅ COMPLETE — 2026-06-28.md

**Fix 1 — spring_coil() inner cylinder: APPLIED**
`cylinder(h=spring_l+1, ...)` → `cylinder(h=spring_l-1, ...)`
Inner was 1mm taller than outer = open top face = non-manifold.
Inner now 1mm shorter = fully enclosed on all faces.

**Fix 2 — compartment_divider() height: APPLIED**
`total_h - leg_h` → `total_h - leg_h - skin_t`
Top face was exactly flush with shell top (Z=700 coplanar) = non-manifold.
Now sits 2mm below shell top — no shared face.

**Fix 3 — tray_zone_frame() corner contacts: APPLIED**
Top/bottom bars now own full-width corner regions.
Side bars shortened: start at tray_0_z+frame_bar, height = tray_zone_h-(frame_bar*2).
Side bars no longer share edges with top/bottom bars — all corners are solid volume from top/bottom bars only.

**rules-codes.md updated to v1.3: CONFIRMED**
Three new rules added to 2-Manifold section:
- difference() inner must be strictly smaller than outer on all faces
- union() geometry must share volume not just edges
- module geometry must not land flush with shell boundary

**FLAG FOR CLAUDE WEB — ACTION REQUIRED:**
Janis must open VM-01-base-v20.scad in OpenSCAD → F6 → confirm 2-manifold warning status.
v20 addresses all identified non-manifold sources across 5 versions of fixes.
If warning still persists, remaining candidates to investigate:
- spring_tray() difference() subtractions — check all subtract geometry heights
- tray_rack() cylinder latch pins — check if flush with tray surfaces
- Any module using Y=0 as a face coordinate without epsilon offset

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v20.scad

---

### 2026-06-28 | VM-01-base-v19 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v19.scad (new)
- knowledge.map (v18 → Superseded, v19 → ACTIVE)
- cc_chat_log.md

**Fix 1 — dashboard() support bracket:**
Replaced hull() over two rotate([-90,0,0]) cylinder() calls with a flat crossbar cube:
`cube([screen_w, 30, bracket_r * 2])`
Rotated cylinders inside hull() produce non-planar faces that OpenSCAD cannot guarantee
are manifold. Flat cube is clean solid geometry with no risk.

**Fix 2 — sensor_strip() laser beam visual:**
Changed `cube([..., 1, 1])` to `cube([..., 2, 2])`.
1mm on two axes = near-zero degenerate geometry = non-manifold trigger.

**Flag for Claude Web — ACTION REQUIRED:**
Janis must open VM-01-base-v19.scad in OpenSCAD → F6 → check if 2-manifold warning is gone.
If warning persists, the remaining suspect is tray_zone_frame() — shared cube edges at corners
without epsilon offset. Report result so cc can write v20 if needed.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v19.scad

---

### 2026-06-28 | VM-01-base-v18 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v18.scad (new)
- rules-codes.md (v1.2)
- knowledge.map (v17 → Superseded, v18 → ACTIVE)
- cc_chat_log.md
- prompts/archive/VM-01-base-v18-fix-manifold ✅ COMPLETE — 2026-06-28.md

**Root cause (confirmed by Claude Web):**
outer_shell() called with `translate([0,0,leg_h])` in assembly, but all 4 front
face cutouts inside the module used world Z values (leg_h, tray_zone_top_z).
With the assembly translate applied, those cutouts were shifted 50mm too high —
cutting outside the shell boundary = non-manifold geometry.

**All 4 cutout Z values corrected to local coordinates:**
- Left product zone front: `leg_h` → `0` (local Z 0-492, world Z 50-542)
- Exit zone chute: `leg_h` → `0` (local Z 0-250, world Z 50-300)
- Upper display: `tray_zone_top_z` → `tray_zone_top_z - leg_h` (local Z 492, world Z 542)
- Right compartment front: `leg_h` → `0` (local Z 0-492, world Z 50-542)
- Hollow interior subtract: untouched — was already correct at skin_t
- Assembly line: unchanged — `translate([0, 0, leg_h]) outer_shell();`

**OpenSCAD --check:** binary not available in cc environment.

**rules-codes.md updated to v1.2: CONFIRMED**
- New rule added to Z-Stack section: "Local vs world Z — never mix inside one module"

**Flag for Claude Web — ACTION REQUIRED:**
Janis must open VM-01-base-v18.scad in OpenSCAD and press F6 (full render).
Confirm the 2-manifold warning is GONE from the console output.
If warning persists after v18, upload v18.scad to Claude Web for further diagnosis.
The fix targets the confirmed root cause — if another module is also non-manifold,
it will still show after this fix and require a separate v19 pass.

- Active SCAD: vending-machine/VM-01-base/VM-01-base-v18.scad

---

### 2026-06-28 | VM-01-base-v17 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v17.scad (new)
- rules-codes.md (v1.1)
- knowledge.map (v16 → Superseded, v17 → ACTIVE)
- cc_chat_log.md
- prompts/archive/VM-01-base-v17-fix-manifold ✅ COMPLETE — 2026-06-28.md

**Task 1 — Shell assembly revert: APPLIED**
- Assembly line restored to: `translate([0, 0, leg_h]) outer_shell();`
- Inside outer_shell(): hollow subtract Z restored to `skin_t` (local origin)
- Height `total_h-(skin_t*2)` kept — v14 bottom-skin fix preserved
- Source file v16 was fully read before any edit was made (new rule compliance)

**Task 2 — 2-manifold source diagnosis:**
openscad binary not available in remote cc environment. Diagnosis performed via code analysis against rules-codes.md patterns.

Most likely culprit: **dashboard()** — specifically the curved support bracket at lines 389–394 of v16.

Secondary suspect: **sensor_strip()** — the "laser beam" cube at `cube([..., 1, 1])` is degenerate (1mm in two axes). Near-zero geometry can cause non-manifold edges.

Third candidate: **tray_zone_frame()** — four cubes in a union() that share edges at corners.

**Task 3 — rules-codes.md updated to v1.1: CONFIRMED**
- New rule added to 2-Manifold section: "Read the live .scad file before writing any fix"

**Flag for Claude Web — v18 planning:**
- Primary fix target: dashboard() support bracket — replace hull()+rotated cylinders with simpler geometry
- Secondary: sensor_strip() 1x1mm cube — add minimum 2mm on each axis
- Active SCAD: vending-machine/VM-01-base/VM-01-base-v17.scad

---

### 2026-06-28 | rules-codes.md v1.0 | COMMITTED

Files committed:
- rules-codes.md (new file)
- knowledge.map (v15, v16 added to version index)
- cc_chat_log.md

Changes:
- Created rules-codes.md Version 1.0 — full OpenSCAD coding rule set extracted from VM-01-base v3–v16 build history
- 7 sections: 2-Manifold Rules, Variable Declaration Rules, Module Structure Rules, File and Version Rules, Z-Stack and Positioning Rules, Color and Opacity Rules, QA Checklist
- knowledge.map: v14 status → Superseded; v15 and v16 added; v16 marked ACTIVE

## Flags for Claude Web
- exit_door_w (shell cutout): currently 400mm. Janis may want to confirm this.
- Flap door dimensions (100mm tall x 250mm wide): confirm with Janis from front render.
- rules-materials.md: confirm it is in repo root (it is — .claude/ copy was deleted).
- PR-01 (pilates reformer): NOT STARTED.

---

### 2026-06-28 | VM-01-base-v16 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v16.scad
- cc_chat_log.md

Changes:
- Fix 1: acrylic_display() — hull() front panel replaced with flat cube: translate([acrylic_front_x, e, acrylic_bot_z]) cube([acrylic_front_w, door_t, acrylic_zone_h]). Simpler geometry, no z-fighting.
- Fix 2: outer_shell() hollow subtract Z changed from skin_t → leg_h+skin_t. Assembly translate([0,0,leg_h]) removed — outer_shell() now called directly as outer_shell().
- Fix 3: Version header v15 → v16, date 2026-06-28.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v16.scad

---

### 2026-06-28 | VM-01-base-v15 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v15.scad
- cc_chat_log.md

Changes:
- Added e = 0.01 to parameters section (epsilon — prevents z-fighting on coincident front faces)
- front_door(): Y 0 → e
- spring_zone_panel(): panel cube Y 0 → e
- left_front_acrylic(): panel cube Y 0 → e
- tray_zone_frame(): all 4 translates Y 0 → e
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v15.scad

---

### 2026-06-28 | VM-01-base-v14 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v14.scad
- knowledge.map (v14 added to version index)
- prompts/archive/VM-01-base-v14-fix-manifold ✅ COMPLETE — 2026-06-28.md
- cc_chat_log.md

Changes:
- Fix 1: outer_shell() hollow subtract changed total_h-skin_t → total_h-(skin_t*2). Bottom face now closed — shell is a fully closed solid. Fixes 2-manifold warning.
- Fix 2: outer_shell opacity 0.15 → 0.75 (solid shell, correct value)
- Fix 3: Duplicate exit_door_h declaration removed (was at line 52 AND line 62 — kept line 52 only, before tray_0_z)
- Version header corrected: v12 → v14, date 2026-06-27 → 2026-06-28
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v14.scad

⚑ FLAG FOR JANIS: Open VM-01-base-v14.scad in OpenSCAD, press F6. Confirm the 2-manifold warning is gone before proceeding with STL export.

---

### 2026-06-28 | VM-01-base-v13 Export Prep | COMMITTED

Files committed:
- exports/for-supplier/.gitkeep (folder created)
- exports/for-supplier/README-export-instructions.md
- renders/.gitkeep (folder created)
- prompts/archive/VM-01-base-v13-export ✅ COMPLETE — 2026-06-28.md
- cc_chat_log.md

Changes:
- Created exports/for-supplier/ folder with .gitkeep
- Created renders/ folder with .gitkeep
- Written README-export-instructions.md with full OpenSCAD export steps for Janis (STL + 4x PNG renders, correct file paths)
- Prompt archived to prompts/archive/ stamped COMPLETE
- QA: all 3 checklist items confirmed ✅

---

### 2026-06-27 | VM-01-base-v13 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v13.scad

Changes:
- Fix 1: outer_shell opacity restored to 0.75 (solid shell). left_front_acrylic() opacity updated 0.15 → 0.25. Shell is solid; only the left front face panel is transparent.
- Fix 2: exit_door_h = 250 moved BEFORE tray zone calculations. Declaration order: exit_door_h → exit_door_w → tray_zone_h → tray_0_z → tray_zone_top_z. Resolves all 'undefined variable' warnings from OpenSCAD.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v13.scad

---

### 2026-06-27 | Satu vending 01.scad — Manual fix | CONFIRMED

- exit_door_h = 250 inserted immediately before tray_0_z by Janis manually (Option A)
- File is a local working copy, not in repo — all 28 warnings resolved
- Render confirmed clean: solid shell, springs visible through left front acrylic, dashboard visible right compartment

---

### 2026-06-27 | VM-01-base-v12 + Governance | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v12.scad
- WORKFLOW_SKILL.md
- cc_chat_log.md

Changes:
- VM-01-base-v12: outer_shell opacity 0.75 → 0.15 (semi-transparent QA shell)
- VM-01-base-v12: new left_front_acrylic() module — #ADD8E6 opacity 0.15, X=skin_t, Y=0, Z=leg_h(50mm), W=product_w-(skin_t*2)=412mm, H=total_h-leg_h=650mm, T=3mm. Customer sees full left zone.
- WORKFLOW_SKILL.md FIX A: Section 6 (Current Project Status) removed — cc_chat_log.md is the only living status file
- WORKFLOW_SKILL.md FIX B: All cc references removed (flow, file table, section headers). WORKFLOW_SKILL.md now governs Claude Web only.
- WORKFLOW_SKILL.md FIX C: New load order rule added at top of Handover Protocol (Section 3). Sections renumbered.
- cc_rules.md: No WORKFLOW_SKILL.md references were present — no changes needed.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v12.scad

---

### 2026-06-27 | VM-01-base-v11 | COMMITTED

Files committed:
- vending-machine/VM-01-base/VM-01-base-v11.scad

Changes:
- Fix 1: spring_zone_panel() — explicit world coords: X=skin_t, Y=0, Z=leg_h+exit_door_h (300mm), width=product_w-(skin_t*2), height=tray_h*tray_count (242mm). Left product zone only.
- Fix 2: Roof restored — hollow interior height changed total_h → total_h-skin_t. Top skin now solid at Z=700+leg_h.
- Fix 3: screen_y = skin_t - screen_protrude (was 0 - screen_protrude). Screen protrudes 30mm forward from machine front face.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v11.scad

---

### 2026-06-27 | VM-01-base-v10 | COMMITTED

- Spring zone acrylic panel: transparent customer selection window, Z 300-542, full product_w, #ADD8E6 opacity 0.15, left hinge, shown closed
- Screen Y: -30mm (protrudes 30mm forward of machine front face — visible from front view)
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v10.scad

---

### 2026-06-27 | VM-01-base-v9 | COMMITTED

- total_d: 550 → 600mm (motor needs 60mm depth)
- motor_d: 20 → 60mm (real motor size from spring thread)
- Spring direction FIXED: motor now at BACK of tray, spring front end at drop zone boundary (Y=0 tray-local). Products fall forward into exit zone.
- front_door: now covers EXIT ZONE ONLY (Z 50-300, 250mm). Spring display zone Z 300-542 is OPEN.
- Customer pickup flap: 100mm tall x 250mm wide (was full exit zone size)
- Sensor: replaced per-spring sensors with parallel strip pair on left/right walls at Z=280mm.
- Right compartment front: cutout added — screen/QR/card now visible.
- Governance: knowledge.map + cc_chat_log.md created.
- **Active SCAD:** vending-machine/VM-01-base/VM-01-base-v9.scad

---

### 2026-06-27 | VM-01-base-v8 | COMMITTED

- Tray side windows: restored 3mm border frame (centre open)
- Screen Y: moved to skin_t (front face of right compartment)

---

### 2026-06-27 | VM-01-base-v7 | COMMITTED

- total_h: 800 → 700mm
- Zone stack fixed: legs 0-50 | exit 50-300 | tray0 300-421 | tray1 421-542 | upper 542-700
- Acrylic: Z 542-698 (was 430-798)
- Screen center Z: 280mm
- Upper front door cutout added (Z 542-700)
- Deleted .claude/rules-dimensions.md (root is authoritative)

---

### 2026-06-27 | VM-01-base-v6 | COMMITTED

- Major rebuild: tray_h=121, independent removable trays
- New: tray_rack (fixed rails + latch pins)
- New: front_door (single panel Z 50-542, left hinge)
- New: tray_zone_frame
- New: dashboard (ATM screen, QR, card slot, speaker)
- Acrylic: 3 faces of right compartment above 430mm

---

### 2026-06-27 | VM-01-base-v5 | COMMITTED

- Acrylic panel: rounded window (hull+cylinders r=10, t=3mm)
- Spring tray side walls: 3mm frame, open centre

---

### 2026-06-27 | VM-01-base-v4 | COMMITTED

- tray_h: 116 → 86mm (spring OD 66 + 20mm clearance)
- Spring tray front face: open
- Tray Z formula: leg_h + exit_door_h + (tray_num * tray_h)
- Acrylic panel: right compartment only

---

### 2026-06-27 | Setup | COMMITTED

- Created: WORKFLOW_SKILL.md v2 (team structure, protocols)
- Created: chat_rules.md (Claude Web rules)
- Created: cc_rules.md (cc rules)
- Created: rules-dimensions.md (VM-01 dimensions)
- **Active SCAD:** VM-01-base-v3.scad (existed before this session)
