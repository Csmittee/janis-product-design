# CC BUILD PROMPT — PR-01-base v9 — Split-Clamp Base Collar + Full-Height Uniform Body

## 1. CC INTRO
git fetch --all && git checkout main && git pull origin main
Read in order: cc_rules.md → cc_chat_log.md (first 3 entries) → rules-dimensions.md → pilates-reformer/PR-01-base/PR-01-base-v8.scad
State every file read before writing a single line.

## 2. CONTEXT
Janis QA on v8: pole_top() correctly identified as placeholder (no directional feature yet — confirmed by Claude Web as expected, not a bug, Stage 2 scope). Vertical ribbing on shaft flagged for F6 verification (likely $fn=64 preview-facet artifact, not lattice regression — pending Janis F6 confirmation, not part of this prompt's scope).

NEW DESIGN DIRECTION (Janis-confirmed this session, explicit Q&A):
- pole_body() must now run the FULL exposed pole height as one uniform constant-50mm D-profile — no separate base-zone diameter change. This makes the pole itself a single uniform-profile extrusion, easy to manufacture at any length.
- pole_base_collar() is redesigned as an external split-clamp sleeve: wraps around BOTH the lower pole_body() and the top of the wood leg (spans across the bed_h surface line), split into 2 halves joined by 3 screws each side (like a pipe clamp).
- The collar ALSO has a registration pin protruding from its underside into a SHALLOW wood socket (not a deep structural socket like before — registration/alignment only, the clamp itself carries the holding force, not the pin).
- pole_wood_socket() depth reduced accordingly — shallow registration socket, not deep insert.

## 3. NEW FILES
NONE — new version of existing PR-01-base file.

## 4. TASKS

1. **pole_body()** — remove the `collar_h` height offset. Body now spans the full exposed height: `translate([cx, cy, bed_h])`, height = `pole_h - top_boss_h` (uniform 50mm D-profile, unchanged cross-section logic, unchanged D-flat orientation rule — do not touch that logic).

2. **pole_wood_socket()** — reduce `socket_depth` to a shallow registration depth (placeholder ~20mm — TBD, flag in cc_chat_log, this is registration-only, not load-bearing). Keep `socket_od = 60mm` (Janis-confirmed, unchanged).

3. **pole_base_collar() — full redesign as split-clamp sleeve:**
   - New parametric values needed (all placeholders — flag each as TBD in cc_chat_log, do not treat any as final):
     - `collar_wrap_h` — total wrap height, spanning some distance above bed_h (onto pole_body) and some distance below bed_h (onto the wood leg) — placeholder ~120mm, split roughly evenly above/below the bed_h line
     - `collar_wall_t` — wrap wall thickness — placeholder ~8mm
     - `collar_bolt_d` — screw clearance hole diameter — placeholder ~4mm
     - `collar_bolt_boss_d` — boss diameter around each screw hole — placeholder ~10mm
     - `pin_h` — reduce to match new shallow socket depth (must equal or be slightly less than the new `socket_depth`, never exceed it)
   - Geometry: a tube/sleeve (annular shell, inner radius clears `pole_r` + clearance, outer radius = inner + `collar_wall_t`) split into 2 halves along a vertical cut plane through the pole's Y centerline (front half / back half, using `difference()`/`intersection()` with a cutting half-space).
   - 3 bolt bosses per split face (6 total) at evenly spaced heights along `collar_wrap_h`, each with a through-hole of `collar_bolt_d` for a screw joining the two halves.
   - Registration pin protrudes from the collar's underside into `pole_wood_socket()` — diameter unchanged (`pin_d`), height now matches the new shallow `socket_depth`.
   - Render the 2 halves as visually distinguishable separate solids (not unioned into one mesh) — consistent with how the other pole components are kept logically separate.

5. Update file header comment block: version v8→v9, note the full-height body + split-clamp collar change, date.

## 5. DO NOT TOUCH
- rules-dimensions.md — read only, no locked-value changes this prompt (pole_d=50mm, socket_od=60mm unchanged, only socket_depth/pin_h are new placeholders, not locked values)
- VM-01-base — not in scope
- pole_top() — placeholder unchanged, Stage 2 scope, not part of this prompt
- pole_body() D-flat orientation logic (front/rear flat-facing rule) — unchanged, do not re-derive
- Crossbar geometry (xbar_z, grip_l, end caps) — unchanged, already fixed in v8, do not touch
- bed_frame(), bed_surface() — unchanged

## 6. QA VERIFICATION
- [ ] No undefined variable warnings in SCAD
- [ ] Version incremented — save as PR-01-base-v9.scad, never overwrite v8
- [ ] Confirm pole_body() now spans full exposed height with constant 50mm D-profile, no base-zone diameter change (state actual height value used)
- [ ] Confirm pole_base_collar() visually wraps BOTH the wood leg top and the pole bottom, spanning the bed_h line
- [ ] Confirm collar renders as 2 visually distinguishable halves with 3 bolt bosses per split face (6 total)
- [ ] Confirm registration pin height does not exceed new shallow socket_depth (state both values, confirm pin_h <= socket_depth)
- [ ] Confirm NO lattice/truss geometry present anywhere (explicit visual code check, state confirmation)
- [ ] State every placeholder TBD value used (collar_wrap_h, collar_wall_t, collar_bolt_d, collar_bolt_boss_d, socket_depth, pin_h) explicitly in cc_chat_log

## 7. MANDATORY CLOSING
1. Prepend cc_chat_log.md — newest entry at TOP
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map if new files created
4. Bump version on all changed files (PR-01-base v8→v9)
5. Commit all → merge to main
