# cc Chat Log Archive — Viewer (cross-product) + Governance/Process
# Archived from root cc_chat_log.md on 2026-07-31 (governance cleanup round).
# Entries here are older than the 7-day recent window kept in root cc_chat_log.md.
# Newest entry FIRST, same convention as root. Full original text, unedited.
# 20 entries, date range: 2026-06-27 to 2026-07-09

### 2026-07-09 | viewer-cache-folder-listing + grid-floor-fix | DONE — viewer only, zero .scad touched

Files: viewer/janis-product-viewer.html, cc_chat_log.md, prompts/archive/.
T1-T3 (prompt): getModelFolder() wraps fetchModelFolder() with a 5-min in-memory cache (per project folder). buildModelFolderPicker() now uses it, shows "(cached)" when serving stale data. 403 AND 429 both now caught (GitHub uses either depending on which limit is hit) with a clear message; a "↻ Refresh models" button force-bypasses the cache. On a failed refresh, the last known-good list stays visible with a warning instead of clearing — never a blank list on transient rate-limiting.
Extra (direct chat request, same file, same session): grid was passing through the model body — root cause was loadSTL()'s `geometry.center()` re-centering the whole bounding box at Y=0. Replaced with X/Z-only centering + floor (bbox.min.y) pinned to Y=0, matching OpenSCAD's floor convention (object sits ON the grid). Added a "Show grid" toggle in the View panel (gridHelper.visible).
Verified via real headless Chromium (Playwright, THREE.js stubbed — CDN blocked in this sandbox only): cache reuses across project-switch within TTL (1 fetch, not repeated), Refresh button forces a 2nd fetch, simulated 429 preserves the cached dropdown + shows warning, grid toggle flips gridHelper.visible correctly, PR-01 legacy system fully unaffected. Geometry translate math reviewed by hand (stub can't do real vector math) — flagged for Janis's visual confirm post-deploy.

### 2026-07-09 | governance-verification-escalation-rules | DONE — docs only, zero .scad touched

Files: RULES.md(2.0→3.0), WORKFLOW_SKILL.md(3.13→3.14), chat_rules.md(v3.10→v3.11), cc_chat_log.md, prompts/archive/.
Added 4 new numbered rules (highest was R-007, confirmed from live file, not assumed): R-008 Verification Discipline (no CONFIRMED/RULED OUT without a real check + its SCOPE stated — refined the prompt's own v52/v53/v55 example: v53's finding WAS real CGAL, just narrowly-scoped and over-generalized, not "arithmetic-only" as drafted). R-009 Duplication Check (search all copies before fixing) — wired a mandatory line into WORKFLOW_SKILL's CC INTRO template. R-010 Repeat-Touch Escalation (3+ strikes → question the design) — corrected the hinge-rod touch history: v50/v52/v53/v55 (4 sessions, verified via cc_chat_log grep), NOT v56 as the prompt's draft claimed (v56 never touched it). R-011 Direct-CC Escalation Protocol — added to both RULES.md and a new chat_rules.md section.
No existing rule content removed/renumbered. Zero .scad files touched, confirmed via git status.
### 2026-07-07 | skeleton-skill-bom-tree-kinetic-convention | DONE — docs only, zero .scad/dimension files touched

Files: .claude/SKILL_product_design_skeleton.md(1.0→2.0), cc_rules.md(v8→v9), chat_rules.md(v3.8→v3.9), WORKFLOW_SKILL.md(3.11→3.12), knowledge.map(v44→v45), cc_chat_log.md, prompts/archive/.
Added "PROCEDURE — CLAUDE WEB (BOM Subassembly Tree)" and "PROCEDURE — CLAUDE WEB + CC (Kinetic Dual-View Convention)" sections to the skeleton skill, positioned alongside (not replacing) the Skeleton Worksheet — explicitly distinguished as a different artifact (parts hierarchy vs. coordinate reference). Kinetic convention cites VM-01's show_shell_top incident as the concrete rationale, per the prompt's own instruction, not an abstract justification.
Version bump reasoning stated explicitly: skeleton skill itself gets X.0 (1.0→2.0, genuinely NEW sections/structure); the 4 wiring files (cc_rules/chat_rules/WORKFLOW_SKILL/knowledge.map) get X.Y-equivalent detail bumps (one-line pointers/cross-references to an already-established concept, no new structure of their own).
SCOPE/grandfather clause confirmed to already cover both new sections without wording change (file-wide "new product lines only" statement, not tied to named procedures) — not touched. No .scad or rules-dimensions.md files touched, confirmed.

### 2026-07-07 | governance-cc-intro-knowledge-map-rules-refresh | DONE — docs only, zero .scad touched

Files: WORKFLOW_SKILL.md(3.10→3.11), knowledge.map(v42→v43, full rebuild), RULES.md(1.0→2.0), cc_chat_log.md, prompts/archive/.
T1: CC PROMPT TEMPLATE Section 1 replaced with continuation/fresh self-check + Claude Web override slot + named task-specific-reads slot (exact structure per prompt); knowledge.map restored to the mandatory 2nd read (had silently narrowed out, no recorded decision — real drift, not intentional).
T2: knowledge.map rebuilt — stripped the embedded VM-01/PR-01 SCAD version-index changelogs + this file's own header changelog + the stale (v42-era) viewer STL-upload-status table (all preserved in git history/cc_chat_log.md, not lost); added a complete, individually-confirmed /.claude/ file index (was partial); kept WHO READS WHAT, FILE SYSTEM MAP, GOVERNANCE, PROJECT FOLDERS as current-state-only. FLAG: README.md still points to "RULES.md section 4" for session protocol, which doesn't exist (real protocol lives in WORKFLOW_SKILL.md) — out of this prompt's scope, not fixed.
T3: 3/3 candidate rules confirmed against actual traced events (not forced) — R-005 render-mode/toggle compound-gating trap (v44 Finding B), R-006 shared-center/radius arc constraint (v50 left-vertical/door-flange), R-007 patch-vs-real-material pattern (this session's own v51 steel-bar fix). No additional confirmed candidates found beyond these 3 in the 2026-07-05-onward archive scan.

### 2026-07-06 | wire-design-scope-into-workflow | DONE — WORKFLOW_SKILL.md v3.9→v3.10, docs only

Files: WORKFLOW_SKILL.md, cc_chat_log.md, prompts/archive/. No .scad touched.
New **Step 4** added to the CLAUDE WEB SESSION OPENING — MANDATORY SEQUENCE (and its duplicate copy inside the CHAT HANDOFF TEMPLATE block): read the relevant project's `design_scope_of_work_rule.md` in full, same mandatory "not found → STOP" tier as Steps 2/3.5 — positioned right after Step 3.5 (CURRENT_STATE.md) and before Step 5/6, so it's read before any QA discussion or prompt drafting. If CURRENT_STATE.md doesn't disambiguate which project, both copies must be read, not one picked silently — stated explicitly, not left implicit. Closing line ("all 6 steps confirmed") updated to list all 7 labeled steps (1/2/3/3.5/4/5/6).
TASK 2 confirmed: cc_rules.md has ZERO existing automatic-read-list entry for design_scope_of_work_rule.md (grepped, not assumed) — this prompt did not add one; cc's read of that file stays prompt-triggered only, unchanged.

### 2026-07-05 | new-product-design-skeleton-skill | DONE — governance only, zero .scad files touched, direct Janis chat request (no /prompts/ file)

Files: .claude/SKILL_product_design_skeleton.md (new), .claude/SKILL_reference_point_first.md (marked superseded, kept), cc_rules.md(v6→v7), rules-codes.md(1.12→1.13), rules-dimensions.md(v14→v15), chat_rules.md(v3.7→v3.8), WORKFLOW_SKILL.md(3.8→3.9), knowledge.map(v31→v32), cc_chat_log.md.
Janis asked for a permanent Top-Down Skeleton/Datum Reference Frame design skill (Primary/Secondary/Tertiary datums, Parent-Child coordinate offsets, no Cousin/Stranger references — "football field" rule), extending the draft SKILL_reference_point_first.md from this same session. New skill is the FIRST file read for any NEW product line, includes a Claude Web "Skeleton Definition Worksheet" procedure (complete with Janis BEFORE any component sizing) and a cc procedure (SKELETON block + per-module Parent declaration comments).
Wired into every governance file: cc_rules.md session-start trigger, rules-codes.md "Datum Rules" pointer, chat_rules.md new section, WORKFLOW_SKILL.md new TRIGGER row + FILE STRUCTURE, knowledge.map FILE LOCATIONS + new "GOVERNANCE" section, rules-dimensions.md COORDINATE SYSTEM cross-reference.
**Grandfather clause, explicit per Janis's direct instruction: VM-01 and PR-01 are NOT retrofitted** — both continue under the existing DATUM_*/SKILL_reference_point_first.md convention. Applies to new/later products only.

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

### 2026-07-02 | customizer-skill-mandatory-toggles | DONE — governance amendment only, zero geometry change

Files: .claude/SKILL_customizer_profile.md(1.0→1.1), cc_chat_log.md, prompts/archive/.
Added 3 new bullets to CRITICAL RULES verbatim per prompt: mandatory `/* [Visibility] */` show/hide toggle group for every major component; mandatory cutaway/section toggle for any nested component; all owner-adjustable parameters MUST be Customizer-exposed, editor pane read-only for version header.
Diffed: only version-bump line + the 3 new bullets changed — no other line touched, no existing bullets altered.
Confirmed: zero .scad files touched. No knowledge.map update needed (no new files).

### 2026-07-02 | governance-repo-truth-rule | DONE — docs/governance only, zero geometry change

Files: WORKFLOW_SKILL.md(3.4→3.5), chat_rules.md(v3.4→v3.5), cc_chat_log.md, prompts/archive/.
Context: Claude Web had no way to confirm whether PR #66 was merged and (incorrectly) tried fetching GitHub directly instead of asking Janis. Fix codifies Janis as the only source of truth for current repo/PR/merge state — Project Knowledge is a snapshot, never live.
Task 1: added REPO TRUTH section to WORKFLOW_SKILL.md, immediately after JANIS SESSION PREP.
Task 2: added reinforcing bullet to chat_rules.md under Reading & Diagnosis.
Confirmed: zero .scad files touched — governance/documentation only.
⚑ FLAG FOR JANIS: re-upload both WORKFLOW_SKILL.md and chat_rules.md to Project Knowledge — repo copies changed, PK copies now stale.

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

### 2026-06-27 | Satu vending 01.scad — Manual fix | CONFIRMED

- exit_door_h = 250 inserted immediately before tray_0_z by Janis manually (Option A)
- File is a local working copy, not in repo — all 28 warnings resolved
- Render confirmed clean: solid shell, springs visible through left front acrylic, dashboard visible right compartment

---

