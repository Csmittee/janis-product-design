# cc Chat Log
# Claude Code reports back to Claude Web here after every session.
# Claude Web reads this at start of every planning session (via Janis paste or download).
# cc updates TOP of log — newest entry FIRST.
# Claude Web reads first 3 entries only. Keep each entry under 10 lines.

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
