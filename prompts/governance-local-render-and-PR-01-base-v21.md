# CC PROMPT — Governance + PR-01-base v21
# TWO TASKS IN ONE SESSION: Task A = governance docs, Task B = geometry
# Date: 2026-07-01

## 1. CC INTRO

```
git fetch --all && git checkout main && git pull origin main
```

Read in order, state every file read before writing a single line:
1. cc_rules.md
2. knowledge.map
3. cc_chat_log.md (first 3 entries — newest at top)
4. .claude/SKILL_joint_construction.md
5. .claude/SKILL_problem_solving_kt.md
6. rules-pr.md
7. rules-dimensions.md
8. pilates-reformer/PR-01-base/PR-01-base-v20.scad (read full file)

---

## 2. CONTEXT

Two root changes happened this session that require governance first, then geometry.

### Why governance first (TASK A):
Claude Web discovered it can install OpenSCAD via apt in its bash sandbox
and render geometry locally. This was used to fully prototype and visually
confirm the new pole_top() design concept across 10 iterations (concept1
through concept10) before writing a single line of cc prompt — completely
eliminating the screenshot→guess→fix loop that burned v10 through v20.
This capability must be documented permanently so every future session
uses it automatically.

### Why geometry second (TASK B):
The pole_top() concept is now locked — confirmed visually by Janis across
multiple angles. The new design is a complete architectural replacement of
the current bell/horn/wine-glass shape. Key characteristics:

**APPROVED CONCEPT (concept10.scad — see attached / project knowledge):**
- Collar body: mudguard/airplane-camber profile — same circular OD at both
  front (pipe-entry) and rear (neck-side) faces; top surface rises
  asymmetrically (peak between neck centerline and front face); straight
  bottom side. NOT a taper/wine-glass. NOT symmetric.
- Bore: 32mm diameter, horizontal through the collar body center
- Neck: straight cylindrical sleeve, 44mm OD, 50mm height, D-profile inner
  bore to slip over the D-column pole_body() (same flat-cut convention as
  existing pole_body()). Neck blends organically into housing's own bottom
  (housing has a local bulge at the neck junction — no hard flat seam).
- Lever: RED placeholder only — exact shape TBD when lock mechanism is
  engineered. Pivot on the hump shell surface. DO NOT engineer the
  internal wedge/sleeve mechanism in this prompt — it is Stage 2 (patent-
  sensitive, separate prompt with IP consideration).

**PATENT FLAG — READ CAREFULLY:**
The wedge-lock quick-release mechanism (lever → wedge → friction sleeve →
pipe clamp) is a potential patent candidate for Janis's product line. It
must NOT be published, committed to a public branch, or described in commit
messages in detail. In this prompt: implement the lever placeholder only
(external red shape, correct pivot location, correct size/proportion) —
zero internal mechanism geometry. The mechanism itself will be handled in a
separate, carefully scoped prompt.

**MULTI-PIPE COMPATIBILITY — record in rules-pr.md:**
The bore must accommodate 3 pipe types Janis sells:
1. Composite (elastic, strong, good grip surface — grippy texture)
2. Wood (natural, smooth, natural grip — gentle surface)
3. Aluminum (rigid, strong, smooth — precision fit needed)
The bore diameter (32mm nominal) must be confirmed against actual OD of all
3 types before final production spec. Flag as TBD in dimensions — do not
hardcode as final.

---

## 3. NEW FILES (TASK A)

- `.claude/SKILL_local_render.md`
- Update: `WORKFLOW_SKILL.md` (new trigger row + new session-open step)
- Update: `chat_rules.md` (new capability note)
- Update: `.claude/rules-codes.md` (pointer to new skill)

## 4. NEW FILES (TASK B)

- `pilates-reformer/PR-01-base/PR-01-base-v21.scad`
- (Multi-file split deferred to the NEXT prompt — confirm with Janis before
  executing. This version is still single-file but structured so the split
  is easy: each physical component is a clearly named module with no cross-
  dependencies except shared globals.)

---

## 5. TASK A — Governance: Local Render Skill

### TASK A-1: Create `.claude/SKILL_local_render.md`

```markdown
# SKILL_local_render.md
# Local OpenSCAD Render Verification — Janis Product Design
# Version: 1.0 — 2026-07-01
# Location: .claude/SKILL_local_render.md
# Read when: any geometry design or fix session is starting, or any time
# a new module shape is being designed before sending to cc.

---

## WHAT THIS IS

Claude Web has access to a bash sandbox where it can install and run
OpenSCAD headlessly (no display needed — xvfb-run provides a virtual
framebuffer). This allows Claude Web to prototype geometry, render PNG
screenshots at multiple angles, and visually verify shape before writing
a single cc prompt.

This eliminates the screenshot→guess→fix loop (which burned v10–v20 on
PR-01-base, 11 versions and 5+ chat sessions for one part). Use it every
time a new module shape is designed.

---

## HOW TO USE

### Step 1 — Install OpenSCAD (first time only per session)
```bash
rm -f /etc/apt/sources.list.d/nodesource.sources
apt-get update -qq
apt-get install -y -qq openscad xvfb
```

Verify: `xvfb-run -a openscad --version`

### Step 2 — Write a prototype .scad file
Build only the module being designed — use real project dimensions from
rules-dimensions.md (not guessed numbers). Keep it isolated: one module,
correct global params, nothing else.

Save to `/home/claude/proto/concept.scad` (working dir, not output).

### Step 3 — Render multiple angles
Always render at minimum: iso, side (ortho), front (ortho).
For complex shapes also render: top, bottom, rear.

```bash
mkdir -p /home/claude/proto
xvfb-run -a openscad -o iso.png \
  --imgsize=1200,900 --projection=ortho \
  --camera=300,260,160,52,0,5 \
  --colorscheme=Tomorrow concept.scad

xvfb-run -a openscad -o side.png \
  --imgsize=1200,900 --projection=ortho \
  --camera=52,350,10,52,0,5 \
  --colorscheme=Tomorrow concept.scad

xvfb-run -a openscad -o front.png \
  --imgsize=1200,900 --projection=ortho \
  --camera=350,0,5,52,0,5 \
  --colorscheme=Tomorrow concept.scad
```

### Step 4 — View and iterate
Use `view` tool to inspect each PNG. Identify issues visually. Fix the
.scad file. Re-render. Repeat until shape is confirmed correct across
all angles BEFORE writing any cc prompt.

### Step 5 — Only then write the cc prompt
Once shape is visually confirmed: save the approved .scad as a reference
file, then write the cc prompt using the confirmed geometry as the spec
(not a description of intent — actual coordinates, module names, and
construction method verified locally).

---

## CRITICAL RULES

- ALWAYS use real project dimensions — read rules-dimensions.md first.
  Never use placeholder numbers that differ from the project's locked values.
- ALWAYS render at least 3 angles before calling a shape "confirmed."
- NEVER write a cc geometry prompt for a new module shape without local
  render verification first. The whole point is to catch misunderstandings
  BEFORE cc burns a version on them.
- Use `--projection=ortho` for diagnostic views (true shape without
  perspective distortion). Use perspective (omit flag) for presentation/
  aesthetic views only.
- If OpenSCAD reports errors in stderr, fix them before rendering further.
  A render with geometry errors is not a valid verification.
- Multi-component assemblies: color each component separately so individual
  parts are identifiable in renders. Red for levers/actuators, brass for
  mechanical components, dark blue for structural housing.

---

## KNOWN GOOD CAMERA ANGLES (for this project's scale ~100mm parts)

```
Iso:   --camera=300,260,160,52,0,5
Side:  --camera=52,350,10,52,0,5
Front: --camera=350,0,5,52,0,5
Top:   --camera=52,0.01,280,52,0,5
Back:  --camera=-250,0,5,52,0,5
Bottom:--camera=52,0.001,-150,52,0,5
```

Adjust distance (first 3 values) based on part size.
`--imgsize=1200,900` is the standard resolution.

---

## ISOLATION-TEST DISCIPLINE (same as manifold triage)

If a joint/transition has failed QA once on real renders:
1. Local-render first: prototype the fix in the sandbox.
2. Only if local render confirms the fix visually: write the cc prompt.
3. Never write a cc fix prompt for a joint/seam/blend issue without
   first verifying it locally. This is how v17–v20 wasted 4 versions —
   the hull() orientation mismatch would have been caught immediately in
   local render.
```

### TASK A-2: Update `WORKFLOW_SKILL.md`

**Add to SESSION-OPEN SEQUENCE** (before Step 1 of the current list):

```
## PRE-SESSION STEP 0 — Local Render Environment (geometry sessions only)
If this session involves any new module shape design or any joint/seam fix:
Claude Web installs OpenSCAD locally (apt-get) and verifies geometry with
local renders BEFORE writing any cc prompt. Read .claude/SKILL_local_render.md.
Skip this step only for: documentation-only sessions, governance-only sessions,
or sessions where Janis explicitly says no new geometry is being attempted.
```

**Add to TRIGGER TABLE:**

```
| New module shape being designed from scratch | Claude Web installs OpenSCAD, prototypes locally, renders all angles, confirms with Janis BEFORE writing cc prompt | Janis sees renders in this chat and gives explicit PASS before any cc prompt is written |
| Joint/seam/blend issue fails QA once | Claude Web prototypes the fix locally, renders it, confirms fix works visually BEFORE writing next cc prompt | Local render confirms fix before cc burns a version |
```

Bump WORKFLOW_SKILL.md version 3.2 → 3.3, date today.

### TASK A-3: Update `chat_rules.md`

Add under `## Capabilities`:
```
## Claude Web Rendering Capability (added 2026-07-01)
Claude Web can install OpenSCAD via apt in its bash sandbox and render
geometry locally. This is now a MANDATORY first step for any new module
shape design. See .claude/SKILL_local_render.md for the full protocol.
This capability replaced the screenshot→cc→screenshot loop that previously
burned 11+ versions per design iteration.
```

Bump chat_rules.md version 3.3 → 3.4.

### TASK A-4: Update `.claude/rules-codes.md`
Add pointer:
```
**New module geometry design or joint/seam fix:** read
`.claude/SKILL_local_render.md` before writing any cc prompt.
```
Bump rules-codes.md 1.7 → 1.8.

---

## 6. TASK B — PR-01-base v21 Geometry

### OVERVIEW
Complete replacement of pole_top() and all sub-modules. The new design is
fully specified by the locally-rendered and Janis-confirmed concept10.scad
(attached to project knowledge). Read it before writing any geometry.

Do not attempt to patch v20's modules. Start the pole_top() family fresh
using concept10 as the spec. All other modules (pole_body, pole_base_collar,
pole_wood_socket, crossbar) are UNTOUCHED.

### MODULE STRUCTURE (clean split — no cross-dependencies)

```
pole_top(cx, cy)              // assembly wrapper only — calls sub-modules
pole_top_housing(cx, cy)      // the mudguard collar body (replaces pole_top_bell)
pole_top_neck(cx, cy)         // straight D-profile sleeve (updated from v20)
pole_top_lever_placeholder(cx, cy)  // RED shape only, no mechanism geometry
```

Remove entirely: `pole_top_bell()`, `pole_top_transition()` — these are the
wine-glass/horn modules that are now replaced.

### TASK B-1: `pole_top_housing(cx, cy)`

Build the mudguard-camber housing body per concept10.scad:

**Key parameters (add to global params block):**
```openscad
housing_len      = 104;  // collar length along bore axis (X)
housing_r_circ   = 19;   // circular face radius (= collar_od/2 = 38/2)
housing_camber_rise = 16; // extra radius added at camber peak (top only)
housing_peak_t   = 0.40; // peak position along length (0=neck side, 1=front)
housing_bump_w   = 0.55; // bump width factor
housing_steps    = 60;   // loft steps — keep high for smooth surface
housing_neck_t   = 0.50; // neck junction position (center of housing length)
housing_bulge_rise = 5;  // bottom local bulge at neck junction for organic blend
housing_bulge_w  = 0.18; // bulge width factor (narrow — local boss only)
```

**Construction method** (from concept10.scad — do NOT deviate):
- Multi-step loft: `steps` hull() pairs, each hull between adjacent cross-
  section slices along the X axis.
- Each slice: `rotate([0,90,0]) linear_extrude() polygon()` — a 2D profile
  in the Y-Z plane extruded as a thin slab.
- Profile function `profile_pts(r_top, r_bot, n=48)`: for each angle a
  around the circle, if sin(a) <= 0 (bottom half) use r_bot, if sin(a) > 0
  (top half) use r_top. This keeps the bottom tangent at a constant radius
  (straight bottom side per Janis) while the top grows at the camber peak.
- r_top at each step t = housing_r_circ + housing_camber_rise *
  smooth_bump(t, housing_peak_t, housing_bump_w)
- r_bot at each step t = housing_r_circ + housing_bulge_rise *
  smooth_bump(t, housing_neck_t, housing_bulge_w)
- smooth_bump(t, peak, w): let d = abs(t-peak)/w; d>=1 ? 0 : pow(1-d*d, 2)
- Translate the whole housing so the flat bottom sits at global z = r_bottom
  (= housing_r_circ): `translate([0,0,housing_r_circ])`
- Position: housing starts at cx - dir*housing_len/2, so its center is at cx

**Bore cut:** subtract a cylinder(h=housing_len+10, d=top_bore_d) along X
axis through the housing center, centered at (cx, cy, housing_r_circ) in
world coords (bore center = housing's horizontal mid-height).

State the actual bore center world coordinates in cc_chat_log.

### TASK B-2: `pole_top_neck(cx, cy)`

Per concept10.scad — straight sleeve, D-profile ID to slip over pole_body():

```
- Outer: cylinder(h=neck_h, d=neck_od) — straight, no flare, no taper
- Inner bore: D-profile cut (same flat_x = dir*0.7*pole_r convention as
  pole_body()) — neck fits OVER the D-column one way only, correct orientation
- Neck centered under housing: translate x = cx (housing center), not at
  housing edge
- Bottom of neck: z = housing_r_circ - neck_h (hangs below housing base)
- Top of neck: enters housing's organic bottom bulge — no separate transition
  module needed, the housing bulge already provides the blend (verified locally)
- 2x M6 bolt holes through the D-face flat (rotate([0,90,0])), same flat-
  face convention from v18/v19/v20. Z positions: neck center ±15mm from
  the neck's midpoint, both inside the straight D-zone, both > 15mm from
  any edge.
```

### TASK B-3: `pole_top_lever_placeholder(cx, cy)`

RED placeholder only — no wedge, no sleeve, no internal mechanism:
```
- Pivot barrel: cylinder on the hump shell surface at the camber peak X
  position, axis along Y
- Arm: sweeps flat and low over the hump toward the large/front side,
  length ~62mm, width ~14mm, thickness ~7mm
- Thumb pad at the end: slightly wider/thicker
- color("#CC2222") — red, clearly a placeholder
- comment: "// PLACEHOLDER ONLY — internal mechanism is Stage 2 (patent-
  sensitive). Do not add wedge, cam, friction sleeve, or any internal
  mechanism geometry until explicitly instructed."
```

### TASK B-4: `pole_top(cx, cy)` — assembly wrapper

```openscad
module pole_top(cx, cy) {
    $fn = 64;
    dir = (cx < bed_l/2) ? 1 : -1;
    color("#2C3E50") {
        difference() {
            union() {
                pole_top_housing(cx, cy, dir);
                pole_top_neck(cx, cy, dir);
            }
            // bore
            translate([cx - dir*housing_len/2 - 5, cy, housing_r_circ])
                rotate([0,90,0])
                    cylinder(h=housing_len+10, d=top_bore_d, $fn=48);
            // D-face bolts
            // (inside pole_top_neck via its own difference — see B-2)
        }
    }
    color("#CC2222") pole_top_lever_placeholder(cx, cy, dir);
}
```

### TASK B-5: Update global params block

Add/update in the globals section:
```openscad
// ── Pipe compatibility (TBD — pending physical measurement of all 3 types) ──
// 3 pipe variants sold by Janis:
//   1. Composite — elastic, strong, grippy surface (most common)
//   2. Wood — natural, smooth, natural grip
//   3. Aluminum — rigid, strong, smooth (tightest fit tolerance needed)
// top_bore_d = 32mm is NOMINAL — confirm against actual OD of all 3 types
// before production. The wedge-lock system (Stage 2) must accommodate all 3.
top_bore_d   = 32;   // TBD — nominal, pending multi-pipe OD confirmation
housing_r_circ = 19; // = collar_od/2 = 38/2
```

### TASK B-6: Update `pole_body()` height

`pole_body()` top must reach the housing's bottom (housing_r_circ - neck_h
above bed_h) with no gap — update the body_h formula to match the new
neck/housing positioning. State the actual computed body_h value in
cc_chat_log.

### TASK B-7: Update `rules-pr.md`

Add to COMPONENT SPECIFICATIONS:
```
pole_top() — CONCEPT LOCKED 2026-07-01 (local render verified):
  Mudguard/airplane-camber collar body (not wine-glass/horn), same circular
  OD front and rear, asymmetric camber top, straight bottom, straight D-
  profile neck sleeve. Wedge-lock quick-release lever = Stage 2, patent-
  candidate — DO NOT implement mechanism without explicit Janis approval.
  Multi-pipe bore compatibility (composite/wood/aluminum) = TBD, pending
  physical OD measurement of all 3 types.
```

---

## 7. DO NOT TOUCH

- pole_body(), pole_base_collar(), pole_wood_socket(), crossbar geometry
- VM-01-base
- Any internal lock/wedge/friction-sleeve mechanism — Stage 2, patent-
  sensitive, explicitly out of scope
- rules-dimensions.md locked values — add new params only, don't change
  existing locked dims

---

## 8. QA VERIFICATION

- [ ] TASK A: All 4 governance files created/updated, version bumped on each
- [ ] TASK A: SKILL_local_render.md has all 5 sections, camera angles table
      present, isolation-test discipline section present
- [ ] TASK B: pole_top_bell() and pole_top_transition() completely removed
- [ ] TASK B: State bore center world coordinates explicitly
- [ ] TASK B: State body_h computed value for updated pole_body()
- [ ] TASK B: Confirm lever is color("#CC2222"), has "PLACEHOLDER ONLY"
      comment, zero internal mechanism geometry
- [ ] TASK B: Confirm D-profile cut in neck uses same flat_x convention as
      pole_body() — state the actual flat_x value used
- [ ] TASK B: Bolt hole Z positions stated, confirm both > 15mm from any
      neck edge
- [ ] No undefined variable warnings, brace/paren balance (state counts)
- [ ] Version: PR-01-base-v21.scad, v20 not overwritten
- [ ] Patent flag noted in both cc_chat_log and rules-pr.md — no internal
      mechanism detail in any committed file

---

## 9. MANDATORY CLOSING

1. Prepend cc_chat_log.md — newest entry at TOP, include all QA numbers,
   patent flag explicitly stated
2. Archive this prompt → /prompts/archive/ ✅ COMPLETE — [date]
3. Update knowledge.map — v20 → Superseded, v21 → ACTIVE, new skill files
   added
4. Bump version on every changed file
5. Commit all → merge to main

Confirm what you changed. State clearly: "Patent flag recorded — no internal
wedge/sleeve mechanism geometry committed."
