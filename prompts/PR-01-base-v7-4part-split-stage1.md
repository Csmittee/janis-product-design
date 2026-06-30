# CC PROMPT — PR-01-base v7 — 4-Part Split Architecture (Stage 1 of 2)

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → rules-dimensions.md → rules-pr.md → pilates-reformer/PR-01-base/PR-01-base-v6.scad
State every file read before writing a single line.

## 2. CONTEXT
v6 rejected by Janis (owner). Root cause: one-piece continuous pole concept is wrong direction.
New direction (Janis hand sketch, fixed version only — foldable deferred to later):
pole splits into 4 separate physical components for self-assembly:
- TOP: crossbar lock/latch interface (vintage car side-mirror smooth form). Bar attaches HERE, not through the body. Detailed latch geometry is OUT OF SCOPE for this prompt — build a simple placeholder junction only (e.g. plain socket boss, no functional latch yet).
- BODY: constant-diameter D-profile shaft. NO TAPER (taper concept is dropped entirely this version).
- BASE COLLAR: connects body to wood socket via insert pin. Detailed pin/socket fit is OUT OF SCOPE for this prompt — placeholder pin boss only.
- WOOD SOCKET: simple cylindrical insert, OD ~60mm, pushed through a drilled hole in the wood leg.

This is Stage 1 of 2 — architecture and resizing only. Teeth-gear adjustment mechanism, detailed top latch, and detailed base collar/pin fit are Stage 2 (separate future prompt) — do NOT attempt to build these in detail here, placeholders only.

⚠ EXPLICIT REGRESSION WARNING: v4 removed the lattice/truss pole structure; v6 reintroduced it by mistake. DO NOT reintroduce any lattice, truss, or wireframe geometry anywhere in the pole. The body is a solid/shelled D-profile only.

## 3. NEW FILES
NONE — this is a new version of the existing PR-01-base file (save-as v7, see below). No new filenames.

## 4. TASKS

1. **rules-dimensions.md** — UPDATE (Janis-confirmed this session, written approval given in chat):
   - Add/update: PR-01 body D-section = constant 50mm diameter, no taper. Remove/deprecate the prior 100mm base / 60mm top taper values (these were never locked — mark as superseded, do not delete history, note superseded-by-v7).
   - Add: wood socket OD = ~60mm (fixed version).
   - Bump version per DOCUMENT VERSIONING RULE.

2. **PR-01-base SCAD file** — restructure into 4 distinct modules (separate solids, NOT unioned into one continuous pole):
   - `pole_top()` — placeholder smooth boss/junction where crossbar will eventually lock in (no functional latch geometry yet — Stage 2). Crossbar (grip_od=32mm, OWNER-LOCKED, read from rules-dimensions.md) should visually pass through or seat against this part only, not through the body.
   - `pole_body()` — D-profile shaft, constant 50mm diameter top to bottom (read D-flat orientation rule from rules-dimensions.md / rules-pr.md — coordinate convention is PERMANENT, do not re-derive). Remove ALL taper logic from prior versions. Remove the bar-insert bore entirely (bar no longer passes through body — that's now TOP's job).
   - `pole_base_collar()` — placeholder boss with a simple insert pin protruding from its underside (exact pin diameter/length: use a reasonable parametric placeholder, flag as TBD in cc_chat_log — do not guess a "final" value).
   - `pole_wood_socket()` — plain cylinder, OD ~60mm, length parametric (use a placeholder depth, flag as TBD in cc_chat_log).
   - All 4 modules should align/stack visually for a combined preview render, but remain logically separate (not unioned into one mesh) — assembly is mechanical (pin/socket), not a single printed part.

3. Re-verify crossbar (grip_od=32mm) and bar spacing (720-740mm target) values are read from rules-dimensions.md, not hardcoded.

## 5. DO NOT TOUCH
- rules-dimensions.md — read only EXCEPT for the specific D=50mm and wood-socket-OD=60mm additions in Task 1 above. Do not alter any other locked value (grip_od=32mm, bar spacing target).
- VM-01-base — not in scope, do not touch any vending machine files.
- Foldable hinge geometry — explicitly deferred, do not build anything foldable-related.
- Top latch mechanism detail, teeth-gear mechanism, base collar pin/socket precision fit — all Stage 2, placeholders only here.
- All .scad files not named in TASKS.

## 6. QA VERIFICATION
- [ ] No undefined variable warnings in SCAD
- [ ] Version incremented in filename (save as PR-01-base-v7.scad — never overwrite v6)
- [ ] Confirm NO lattice/truss geometry present anywhere (explicit visual check, state confirmation in cc_chat_log)
- [ ] Confirm body D-section is constant 50mm, no taper (state actual measured value in cc_chat_log)
- [ ] Confirm crossbar does NOT pass through/bore into pole_body() — junction is at pole_top() only
- [ ] Confirm 4 modules render as visually separate/distinguishable components, not fused into one mesh
- [ ] State any placeholder dimension used (latch boss, pin boss, socket depth) explicitly in cc_chat_log as TBD pending Stage 2

## 7. MANDATORY CLOSING
1. Append cc_chat_log.md — newest entry at BOTTOM
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map if new files created
4. Bump version on all changed files (PR-01-base v6→v7, rules-dimensions.md, rules-pr.md if touched)
5. Commit all → merge to main
