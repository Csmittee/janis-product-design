// BBQ Offset Smoker — Base Assembly
// Version: v12
// Date: 2026-07-30
// Source: BBQ-offset-smoker-base-v11.scad
//
// Current lid/rib/CB1 system, described once, here. Full round-by-round
// history of every prior rib/pivot/hinge/CB1 redesign this project went
// through to reach this state (superseded pivot formulas, a retired
// hinge_bracket()-on-the-ridge concept later replaced, an earlier
// CB1 "branch/prong" construction long since removed and rebuilt as the
// current Ua/Ub/Uc bracket, etc.) lives in cc_chat_log.md and
// docs/hinge-construction.md — not repeated here, so this header always
// matches the live code instead of drifting into a stale narrative.
//
// - Shared pivot: hinge point at [FC_Y, FC_Z], defined once in
//   BBQ-chambers-v26.scad and read live by both the visual lid() there
//   and this file's own rib assembly, so the lid shell and the 3 ribs
//   always rotate about the exact same center.
// - Rib profile (t1..t7u, T4U, t6be — full labeled diagram at
//   docs/rib-cb1-terminology.png): t1 handle bore -> t2/t3 up the A-B
//   wall -> t4 the B-C/C-D miter -> T4U (perpendicular from apex C, the
//   real top-line anchor) -> t5 -> t6be/t7/t7u (CB1 bracket neck) -> t6
//   pivot bore.
// - CB1: a welded stopper/bracket (Ua/Ub/Uc, one single polygon, wraps
//   half of a 101.6mm OD tube run along the fixed D-E wall) on all 3
//   ribs. Built as a genuine OPEN-frame (door_open_deg=90) target against
//   fixed D-E reference points, then converted into the native/closed
//   profile via freeze_from_open() — see docs/hinge-construction.md
//   Section 4 for why (its own rest state is only defined at OPEN).
// - 3 parametric knobs a future round can move without touching anything
//   else: CB1 position/size (CB1_EDGE_FRAC/CB1_STANDOFF/CB1_OD), the
//   shared pivot (FC_Y/FC_Z in BBQ-chambers-v26.scad), and the handle
//   (HANDLE_Y/HANDLE_Z).
//
// OPEN ITEM, CARRIED FORWARD, NOT FIXED: rib0 (RIB0_X=200) sits inside
// tray0's own X-span ([-2.5,455]) and rib2 (RIB2_X=715) sits inside
// tray1's own X-span ([460,917.5]) — only rib1 (X=457.5) lands in the
// ~5mm gap between the two trays. This is a real structural interference
// between the door-side rib arm's weld-flush run along the A-B wall and
// a STOWED (vertical) tray sharing that same wall real estate — confirmed
// by direct interval overlap, not conjecture, and unchanged across every
// rib/pivot rework so far since it depends only on rib X falling inside a
// tray's X-span. Not resolved: either an operating-sequence rule (don't
// stow/deploy tray0/tray1 while rib0/rib2 occupy the conflicting Z-band)
// or a follow-up round relocating the tray hinges or the rib X convention.

include <BBQ-understructure-v19.scad>

// TASK 3 kinetic driver (`door_open_deg`) and the TASK 2 tray angles are
// declared together in one consolidated KINETIC PARAMETERS block near
// the bottom of this file, just before ASSEMBLY — v6.1, relocated per
// Janis's own direct feedback (see this file's own header). All 3 real
// dials, plus the `lid_open_deg` reassignment, live there now, not here.

// ═══════════════════════════════════════════════════════════════════
// TASK 2 — PREP TRAY, relocated here from BBQ-understructure (removed
// there in v12, this round's own dependency, confirmed above). Real
// dimensions, Janis's own spec:
// ═══════════════════════════════════════════════════════════════════
TRAY_COUNT      = 2;                              // fixed, Janis's own spec
TRAY_L          = chamber_L / TRAY_COUNT;         // 457.5mm each, real live value (chamber_L=915, read live)
TRAY_D          = 300;                            // deployed depth, Y, projecting outward (toward -Y, the Standing Orientation Convention's own "toward the user" side)
TRAY_T          = 2;                              // 2mm plate, thin-shell representation — consistent with this project's existing sheet-metal parts (rules-bbq-fab.md Construction Method)
TRAY_GAP        = 5;                              // real assembly tolerance, ADDITIVE (confirmed below, not absorbed into TRAY_L)
TRAY_TOTAL_SPAN = TRAY_L * TRAY_COUNT + TRAY_GAP; // 920mm — real, ADDITIVE: 2x457.5 + 5, confirmed 5mm MORE than chamber_L(915), not shrunk to fit inside it
// Real span centered on chamber_L's own midpoint — a small, real, stated
// 2.5mm overshoot past BOTH DATUM_X_FRONT(0) and DATUM_X_REAR(chamber_L)
// results (symmetric, by construction, from the additive gap), confirmed
// harmless via the real CGAL checks below (chamber shell/firebox both
// real solids checked directly, not assumed clear from the small overshoot
// alone).
TRAY_X0         = (chamber_L - TRAY_TOTAL_SPAN) / 2;   // -2.5mm
TRAY0_X0        = TRAY_X0;                        // -2.5
TRAY1_X0        = TRAY_X0 + TRAY_L + TRAY_GAP;    // 460mm

// HINGE_Z itself is defined further down this file (needs t1/R1/HANDLE_Z,
// the handle boss, which aren't known yet at this point in the file) --
// see "Tray relocation bracket" section below for the real, current
// value and why (2026-07-30: moved off the chamber wall entirely, the
// old NEW_SPLIT_Z-20 value collided with the handle boss).
HINGE_W         = 20;
HINGE_H         = 20;
HINGE_INTO_WALL = 10;                             // real Y depth, pushes past wall_t(3mm) with margin for genuine weld contact, not a coincident face
// HINGE_PIVOT_OFFSET -- REAL FIX FOUND VIA CGAL, not in the original
// prompt spec (flagged): a live sweep probe found the 2mm-thick plate's
// own near edge sweeping INTO the wall's real material (up to +1.4mm
// past Y=0, confirmed non-empty at intermediate angles) when the rotation
// axis was placed exactly at the wall face (Y=0) -- a flat panel of
// nonzero thickness, pivoting about a point ON one of its own faces, has
// its OTHER face's near edge trace an arc that dips past the pivot line
// during rotation (basic real hinge-knuckle geometry: real hinges offset
// the knuckle from the mounting face for exactly this reason). FIX: the
// real rotation axis is offset HINGE_PIVOT_OFFSET(5mm, real judgment
// call, flagged, must clear TRAY_T=2mm with margin -- confirmed
// sufficient via a live re-sweep, EMPTY at every angle after this fix)
// outward (Y<0) from the wall face, representing the hinge's own real
// knuckle standoff -- HINGE_OUT widened to match so the hinge block's own
// visible footprint still spans from the wall out to the real pivot line.
HINGE_PIVOT_OFFSET = 5;
HINGE_OUT       = HINGE_PIVOT_OFFSET + 1;          // 6mm -- real overlap OUTSIDE the wall face (Y<0), covers the real pivot line with margin
// HINGE_OFFSET -- REAL FIX FOUND VIA CGAL: an initial 60mm draft put
// TRAY1's own far hinge at real world X=857.5 (span [847.5,867.5]),
// overlapping the firebox's own real flange/tuck-under material (the
// Dual End-Cap Footprint Pattern's own union(square,true_octagon_profile)
// reaches real octagon wall material at Y=0 starting X<=~858, bisected
// live via CGAL, confirmed non-empty at X=860, empty at X<=858) --
// TRAY1's own far edge (X=917.5) sits close enough to firebox_x0(913.5)
// that a 60mm inset wasn't enough clearance. FIX: widened to 90mm (real
// judgment call, flagged, comfortably clears the real 858mm boundary with
// margin -- re-verified EMPTY below, not assumed from the wider number
// alone).
HINGE_OFFSET    = 90;

module tray_hinge(x_pos) {
    translate([x_pos - HINGE_W/2, -HINGE_OUT, HINGE_Z - HINGE_H/2])
        cube([HINGE_W, HINGE_INTO_WALL + HINGE_OUT, HINGE_H]);
}
module tray_hinges(x0) {
    tray_hinge(x0 + HINGE_OFFSET);
    tray_hinge(x0 + TRAY_L - HINGE_OFFSET);
    tray_bracket(x0 + HINGE_OFFSET);
    tray_bracket(x0 + TRAY_L - HINGE_OFFSET);
}
// tray() — welded steel frame + 2mm plate (thin-shell representation).
// Real rotation axis: Y=-HINGE_PIVOT_OFFSET (the hinge's own real
// knuckle standoff, see above), Z=HINGE_Z — angle_deg: -90 (stowed,
// vertical, folded UP) to 0 (deployed, horizontal, plate spans outward
// toward -Y per the Standing Orientation Convention's own "toward the
// user" side). TWO REAL BUGS FOUND+FIXED VIA LIVE CGAL SWEEP PROBES (not
// assumed clean from the code alone): (1) an earlier draft built the
// plate spanning positive Y, projecting INWARD toward the chamber's own
// DATUM_Y_CENTER territory (where the front bracket sits) instead of
// outward — confirmed via a real collision at angle=-30/-60 against
// front_wheel_support(). (2) with the sign fixed, a second live sweep
// found the plate's own near edge sweeping past Y=0 into the wall's real
// material at intermediate angles (a flat panel of nonzero thickness
// pivoting exactly at the wall face) — fixed by the real
// HINGE_PIVOT_OFFSET standoff above. Both re-verified EMPTY at every
// swept angle after these fixes, see cc_chat_log.md for the real angle
// list and results.
module tray(x0, angle_deg) {
    tray_hinges(x0);
    translate([x0, -HINGE_PIVOT_OFFSET, HINGE_Z]) rotate([angle_deg, 0, 0]) translate([0, -TRAY_D - e, 0])
        cube([TRAY_L, TRAY_D, TRAY_T]);
}
// TASK 2 kinetic parameter — each tray's OWN independent angle, real
// chosen names: tray0_angle_deg / tray1_angle_deg (not shared, per spec).
// Declared in the KINETIC PARAMETERS block near the bottom of this file
// (v6.1 — relocated, not duplicated; see this file's own header).

module trays() {
    tray(TRAY0_X0, tray0_angle_deg);
    tray(TRAY1_X0, tray1_angle_deg);
}
// Mounted ONLY on the Y=0 side, confirmed by construction: tray()/
// tray_hinges() never reference chamber_W or any Y=chamber_W-side
// position — no mirrored/second copy exists.

// ═══════════════════════════════════════════════════════════════════
// TASK 3 — LID HINGE / HANDLE / COUNTERBALANCE, THREE IDENTICAL RIBS.
// Real geometry, reused directly from the chamber's own real octagon
// vertices (A-E, BBQ-chambers-v26.scad, section "TRUE OCTAGON" — not
// redrawn).
// ═══════════════════════════════════════════════════════════════════

// ─── Octagon reference points (world Y,Z), reused live, not redrawn ───
RIB_REF_A = [0, APEX_A_Z];
RIB_REF_B = [0, chamber_floor_z + chamber_H - chamfer];
RIB_REF_C = [chamfer, DATUM_Z_RIDGE];
RIB_REF_D = [chamber_W - chamfer, DATUM_Z_RIDGE];
RIB_REF_E = [chamber_W, chamber_floor_z + chamber_H - chamfer];

// ─── Pivot (fulcrum) -- v9 REAL REBUILD, per Janis's own hands-on
// calculation (this file's own header). `FC_Y`/`FC_Z` now read LIVE from
// BBQ-chambers-v26.scad's own `HINGE_PIVOT_Y`/`HINGE_PIVOT_Z` -- the ONE
// real source of truth for this pivot, shared with `lid()`'s own
// rotation point there. No local offset/gap constants here anymore
// (`PIVOT_GAP`/`BRACKET_RISE` RETIRED, R-009 confirmed zero other
// consumers) -- the pivot's own real Y sits EXACTLY on `RIDGE_SPLIT_Y`
// (no gap), safe because the hinge bracket itself mounts in the "end
// margin zone" (X < LID_X0 or X > LID_X1), outside the door's own real
// operating length, where this Y-Z location is fixed material
// regardless of door position -- see BBQ-chambers-v26.scad's own header
// for the full real reasoning. ───
FC_Y = HINGE_PIVOT_Y;                     // 242.665mm -- live from BBQ-chambers-v26.scad, exactly on RIDGE_SPLIT_Y
FC_Z = HINGE_PIVOT_Z;                     // 1445.335mm -- live from BBQ-chambers-v26.scad, real UCP204-12 H0 rise above the ridge

// ─── Grab handle -- v6.1 REAL FIX: HANDLE_Y -140 -> -110 (pulled back
// 30mm), Janis's own direct instruction after the real v6 render —
// overhung too far outward from the chamber. HANDLE_Z UNCHANGED,
// confirmed correct (near apex A in Z) — that is deliberate: the handle
// must sit below/outboard of the door so a hand pulling it down never
// touches the hot lid tip, and drops/reaches easily when open.
// HANDLE_BORE_D/HANDLE_WRAP_R RETIRED this round (R-009 confirmed zero
// remaining consumers) -- the new rib profile below bores the handle
// hole directly to HANDLE_ROD_OD, see t1/R1. ───
HANDLE_Y        = -110;            // v6.1: was -140 (prompt's own "corrected this session" value) -- pulled back 30mm per Janis's direct render feedback
HANDLE_Z        = RIB_REF_A[1] + 25;
HANDLE_ROD_OD   = 25.4;            // 1" hollow tube
HANDLE_ROD_WALL = 2;
R_HANDLE = norm([HANDLE_Y - FC_Y, HANDLE_Z - FC_Z]);   // v8: 548.4mm (was 543.0mm under v7.2's C-based pivot) -- REAL, FLAGGED CONSEQUENCE of the pivot's own real position, not a handle change (HANDLE_Y/Z themselves are UNCHANGED, Section 5 DO NOT TOUCH): docs/lid-hinge-counterbalance-calc.md's own swept force curve is stale YET AGAIN, not recomputed this round (Janis has deferred stopper/counterbalance review, item 5 this file's own header)

// ─── Axle -- UNCHANGED real sizes from prior sessions (rod/stub/bore) ───
AXLE_ROD_OD  = 25.4;               // 1" solid rod
AXLE_STUB_OD = 19.05;              // 3/4" machined stub, seats in the hinge bracket's own bore
AXLE_BORE_D  = 27;                 // reuses this project's own 27mm-bore-over-25.4mm-rod convention (Section 3.4 of the source prompt) -- R-009 note: the new rib profile's own axle bore below uses the literal 27 directly (Janis/Claude Web's own delivered code, kept as-given, not rewritten to reference this constant) -- same real value, stated not silently duplicated

// ─── Hinge bracket -- v9 REAL REBUILD, mounts in the "end margin zone"
// (X < LID_X0 or X > LID_X1 -- Janis's own confirmed real location,
// this file's own header), NOT on the ridge between the ribs (v8's own
// 4 earlier passes). Real UCP204-12 numbers, Janis's own hands-on
// calculation, verified via an isolated standalone render before being
// written here (per R-014): `FOOT_L`(127mm, the real "L" spec dimension)
// is the foot's own width in Y, CENTERED on the pivot's own Y (`FC_Y`,
// exactly `RIDGE_SPLIT_Y`) -- safe here because at this X location the
// whole CD face cross-section is fixed material regardless of Y, unlike
// every earlier attempt which tried to keep a Y-gap while still living
// inside the door's own real X-span. `FOOT_A`(38mm, the real "A" spec
// dimension) is the foot's own width in X; its near edge sits
// `GAP_FROM_DOOR`(25mm) from the real door boundary (`LID_X0`/`LID_X1`),
// extending AWAY from the door by that same 38mm. Simple bbox/cylinder/
// hull placeholder (rules-bbq-fab.md Construction Method) -- Janis's own
// explicit instruction: "dont make it fancy... as long as it contain the
// right key figure, foot width, foot length, center location, thickness
// it is accepted." ───
FOOT_L         = 127;                       // mm -- real UCP204-12 "L" spec dimension, foot width in Y
FOOT_A         = 38;                        // mm -- real UCP204-12 "A" spec dimension, foot width in X (also the boss/collar width)
FOOT_T         = 8;                         // mm -- foot plate thickness, placeholder (no real spec given for this one)
GAP_FROM_DOOR  = 25;                        // mm -- real gap from LID_X0/LID_X1 to the foot's own near edge, Janis's own explicit instruction
BOLT_D         = 10;                        // mm -- placeholder bolt size
HINGE_BOSS_R   = AXLE_STUB_OD/2 + 8;        // mm -- pivot boss radius, real short bracket, not a casting
FRONT_NEAR_EDGE = LID_X0 - GAP_FROM_DOOR;   // 75mm
FRONT_BOSS_X    = FRONT_NEAR_EDGE - FOOT_A/2; // 56mm
REAR_NEAR_EDGE  = LID_X1 + GAP_FROM_DOOR;   // 840mm
REAR_BOSS_X     = REAR_NEAR_EDGE + FOOT_A/2;  // 859mm

// ═══════════════════════════════════════════════════════════════
// RIB_DOORHANDLE_PROFILE_v1 — LOCKED, Janis-approved checkpoint.
// Delivered by Claude Web after 2 direct-cc/chat sessions, verified
// against a Python/Shapely reference (0.002% area difference,
// discretization noise only; single watertight body confirmed on
// export) BEFORE being handed to cc for integration. cc's own
// integration check: ran unmodified against the REAL LIVE
// BBQ-chambers-v26.scad (constants confirmed via echo, not assumed --
// see docs/hinge-construction.md Section 4.5), rendered both a labeled
// YZ cross-section diagram and the raw OpenSCAD profile, both sent to
// and confirmed by Janis before this file was written. CB1/
// counterbalance side REMOVED ENTIRELY this round, per Janis's own
// explicit instruction -- door/handle side only, awaiting new
// instruction before the counterbalance link is designed. Pivot Z uses
// the LIVE HINGE_PIVOT_Z (1345.34mm) -- not the 1445.335mm some
// earlier comments/docs stated before docs/hinge-construction.md's own
// Section 4.5 fix.
// ═══════════════════════════════════════════════════════════════

RIB_SPLIT_PT = [0, NEW_SPLIT_Z];

AB_NORM = [-1,0];
BC_LEN  = norm([RIB_REF_C[0]-RIB_REF_B[0], RIB_REF_C[1]-RIB_REF_B[1]]);
BC_DIR  = [(RIB_REF_C[0]-RIB_REF_B[0])/BC_LEN, (RIB_REF_C[1]-RIB_REF_B[1])/BC_LEN];
BC_NORM = [-BC_DIR[1], BC_DIR[0]];
CD_NORM = [0,1];

function miter_point(V,n1,n2,d) = let(dot=n1[0]*n2[0]+n1[1]*n2[1], k=d/(1+dot))
    [V[0]+k*(n1[0]+n2[0]), V[1]+k*(n1[1]+n2[1])];
function unit(v) = let(l=norm(v)) [v[0]/l, v[1]/l];
function ext_tangent(p1,r1,p2,r2,outward) =
    let(d=[p2[0]-p1[0],p2[1]-p1[1]], D=norm(d), u=[d[0]/D,d[1]/D],
        uperp=[-u[1],u[0]], k=(r1-r2)/D, s=sqrt(max(0,1-k*k)),
        nA=[k*u[0]+s*uperp[0], k*u[1]+s*uperp[1]],
        nB=[k*u[0]-s*uperp[0], k*u[1]-s*uperp[1]],
        scoreA=nA[0]*outward[0]+nA[1]*outward[1],
        scoreB=nB[0]*outward[0]+nB[1]*outward[1],
        n=(scoreA>scoreB)?nA:nB)
    [ [p1[0]+r1*n[0], p1[1]+r1*n[1]], [p2[0]+r2*n[0], p2[1]+r2*n[1]], n ];
function fillet_lines(P_in,dir_in,n_in,P_out,dir_out,n_out,R) =
    let(a11=dir_in[0], a12=-dir_out[0], a21=dir_in[1], a22=-dir_out[1],
        bx=(P_out[0]+R*n_out[0])-(P_in[0]+R*n_in[0]),
        by=(P_out[1]+R*n_out[1])-(P_in[1]+R*n_in[1]),
        det=a11*a22-a12*a21, t=(bx*a22-a12*by)/det,
        center=[P_in[0]+R*n_in[0]+t*dir_in[0], P_in[1]+R*n_in[1]+t*dir_in[1]],
        vI=[center[0]-P_in[0], center[1]-P_in[1]], tI=vI[0]*dir_in[0]+vI[1]*dir_in[1],
        trim_in=[P_in[0]+tI*dir_in[0], P_in[1]+tI*dir_in[1]],
        vO=[center[0]-P_out[0], center[1]-P_out[1]], tO=vO[0]*dir_out[0]+vO[1]*dir_out[1],
        trim_out=[P_out[0]+tO*dir_out[0], P_out[1]+tO*dir_out[1]])
    [center, trim_in, trim_out];
function arc_pts(center,r,pA,pB,n=24) =
    let(aA=atan2(pA[1]-center[1],pA[0]-center[0]), aB=atan2(pB[1]-center[1],pB[0]-center[0]),
        sweep=((aB-aA+540)%360)-180)
    [for(i=[0:n]) let(a=aA+sweep*i/n) [center[0]+r*cos(a), center[1]+r*sin(a)]];
function arc_pts_long(center,r,pA,pB,n=36) =
    let(aA=atan2(pA[1]-center[1],pA[0]-center[0]), aB=atan2(pB[1]-center[1],pB[0]-center[0]),
        short=((aB-aA+540)%360)-180, long=(short>0)?short-360:short+360)
    [for(i=[0:n]) let(a=aA+long*i/n) [center[0]+r*cos(a), center[1]+r*sin(a)]];

OUTWARD=[-0.6,0.5];
HANDLE_MEAT=12;

t1=[HANDLE_Y,HANDLE_Z];                                    R1=HANDLE_ROD_OD/2+HANDLE_MEAT;

// ─── Tray relocation bracket + new hinge Z -- 2026-07-30, per Janis's
// own 5-step construction (grab handle was colliding with the tray's
// old hinge -- t1's own boss spans Z=[825.6,899.7], the old HINGE_Z=880
// sat right inside it). Real, disclosed judgment call: "face HA" isn't
// an existing term in this project -- cc's own reading, geometrically
// forced by step 2's own wording ("horizontal line from face HA to
// connect with al" only makes sense if apex A does NOT itself sit on
// face HA) is that H is the existing octagon corner where the chamber
// floor meets the 45° chamfer wall below apex A, and face HA is that
// diagonal chamfer wall. Flagged for Janis to correct if wrong --
// everything below follows from this one reading.
TRAY_H_POINT   = [chamfer, chamber_floor_z];              // existing octagon corner (floor / chamfer-wall junction) below apex A
// step 1: straight line down from apex A, 200mm in Z
TRAY_AL        = [RIB_REF_A[0], RIB_REF_A[1] - 200];      // "al"
// step 2: face HA's own real line (apex A -> H), extended to al's own Z
TRAY_HAL_SLOPE = (TRAY_H_POINT[0]-RIB_REF_A[0]) / (TRAY_H_POINT[1]-RIB_REF_A[1]);   // dY/dZ along face HA
TRAY_HAL       = [RIB_REF_A[0] + TRAY_HAL_SLOPE*(TRAY_AL[1]-RIB_REF_A[1]), TRAY_AL[1]];   // "hal"
// step 3: triangle bracket outline (apex A - hal - al), one per hinge
TRAY_BRACKET_OUTLINE = [RIB_REF_A, TRAY_HAL, TRAY_AL];
TRAY_BRACKET_W = HINGE_W + 10;    // 30mm -- real judgment call, must be at least HINGE_W(20mm) wide to weld the hinge to, +5mm margin each side; no exact width given
// step 4: new tray/hinge Z -- lowest point of t1 (handle boss, incl.
// its own rib meat) minus 15mm real escape clearance. Re-defines
// HINGE_Z (was NEW_SPLIT_Z-20 -- that old value sat inside the handle
// boss, the actual collision Janis reported) -- same global name reused
// so tray_hinge()/tray() below need no other change, only their real
// mounting point moves down onto this new bracket instead of the old
// (non-existent, below apex A the wall doesn't reach this far out)
// wall material.
HINGE_Z        = (HANDLE_Z - R1) - 15;   // 835.3mm at current values -- REDEFINES the placeholder further up this file
module tray_bracket(x_center) {
    translate([x_center,0,0]) rotate([0,90,0]) translate([0,0,-TRAY_BRACKET_W/2])
        linear_extrude(height=TRAY_BRACKET_W, convexity=4)
            polygon(points=[for(p=TRAY_BRACKET_OUTLINE) pt2(p)]);
}

t2=[RIB_SPLIT_PT[0]+20*AB_NORM[0], RIB_SPLIT_PT[1]+20*AB_NORM[1]+10]; R2=20;
t3=miter_point(RIB_REF_B,AB_NORM,BC_NORM,20);               R3=20;
t4=miter_point(RIB_REF_C,BC_NORM,CD_NORM,20);                R4=20;
t5=[FC_Y,DATUM_Z_RIDGE+20];                                  R5=20;
t6=[FC_Y,FC_Z];                                              R6=28.5;

function pt2(p) = [-p[1],p[0]];

// ── PART 1 (t1→t4): proven simple union of circles/hulls — this is the
// FIX. The earlier version fully explicit-traced this region and got
// the handle-bore closure wrong. Simple union here is verified correct. ──
tt12=ext_tangent(t1,R1,t2,R2,OUTWARD);
tt23=ext_tangent(t2,R2,t3,R3,OUTWARD);
F2 = fillet_lines(tt12[0],unit([tt12[1][0]-tt12[0][0],tt12[1][1]-tt12[0][1]]),tt12[2],
                   tt23[0],unit([tt23[1][0]-tt23[0][0],tt23[1][1]-tt23[0][1]]),tt23[2], 50);
F2_ARC = arc_pts(F2[0],50,F2[1],F2[2]);
F2_patch_2d = [for(p=concat([t2,F2[1]],F2_ARC,[F2[2]])) pt2(p)];

module part1_2d() {
    union() {
        hull(){ translate(pt2(t1)) circle(r=R1,$fn=64); translate(pt2(t2)) circle(r=R2,$fn=64); }
        hull(){ translate(pt2(t2)) circle(r=R2,$fn=64); translate(pt2(t3)) circle(r=R3,$fn=64); }
        hull(){ translate(pt2(t3)) circle(r=R3,$fn=64); translate(pt2(t4)) circle(r=R4,$fn=64); }
        polygon(points=F2_patch_2d);
    }
}

// ── PART 2 (t4→t6): fully explicit trace — this part was always correct ──
tt34=ext_tangent(t3,R3,t4,R4,OUTWARD);
tt45=ext_tangent(t4,R4,t5,R5,OUTWARD);
tt56=ext_tangent(t5,R5,t6,R6,OUTWARD);
F5 = fillet_lines(tt45[0],unit([tt45[1][0]-tt45[0][0],tt45[1][1]-tt45[0][1]]),tt45[2],
                   tt56[0],unit([tt56[1][0]-tt56[0][0],tt56[1][1]-tt56[0][1]]),tt56[2], 15);
true_ridge = [FC_Y, DATUM_Z_RIDGE];
B5 = [t6[0], t6[1]-R6];

PART2_OUTLINE = concat(
    [tt34[1]],
    arc_pts(t4,R4, tt34[1],tt45[0]), [F5[1]],
    arc_pts(F5[0],15, F5[1],F5[2]), [tt56[1]],
    arc_pts_long(t6,R6, tt56[1],B5),
    [B5, true_ridge, RIB_REF_C]
);
module part2_2d() { polygon(points=[for(p=PART2_OUTLINE) pt2(p)]); }

// ═══════════════════════════════════════════════════════════════
// CB1 LATERAL LINK -- per prompts/cc_prompt_cb1_link.md, refined
// through several rounds with Janis (full history: cc_chat_log.md's
// 2026-07-30 entries). Applied to ALL 3 ribs (RIB0/RIB1/RIB2 -- widened
// from the prompt's own original middle-rib-only scope, see
// lid_hinge_assembly() below). For the full labeled terminology of
// every point/term in this section, see docs/rib-cb1-terminology.png
// (the one authoritative reference -- read that before changing
// anything here) and PART_MANIFEST.md.
//
// THREE PARAMETRIC CONTROLS -- change any of these and the entire rest
// of this section (bracket, neck, t7/t7u, D-clearance) recomputes
// automatically. Nothing below needs manual re-editing when these move:
//   - CB1_EDGE_FRAC / CB1_STANDOFF -- CB1's own position along/off DE
//   - CB1_OD -- CB1's own tube size
//   - FC_Y/FC_Z (BBQ-chambers-v26.scad) -- the shared pivot; HANDLE_Y/
//     HANDLE_Z above -- the other 2 of this project's "3 adjustable
//     knobs" Janis names, both upstream of this section already.
//
// freeze_from_open(p): the native/closed-frame coordinate that, after
// lid_rib_assembly()'s own rotate([-door_open_deg,0,0]) about the
// shared pivot at door_open_deg=90, lands exactly at p (a point
// expressed in OPEN/world frame). Required for CB1 specifically
// because it's a stopper -- rests against the fixed D-E face only when
// OPEN, floats clear when CLOSED -- unlike t1-t6, whose own rest state
// is the CLOSED position (built directly, no freeze needed).
function freeze_from_open(p) = [FC_Y+FC_Z-p[1], FC_Z+p[0]-FC_Y];

DE_DIR  = unit([RIB_REF_E[0]-RIB_REF_D[0], RIB_REF_E[1]-RIB_REF_D[1]]);
DE_NORM = [-DE_DIR[1], DE_DIR[0]];
DE_LEN  = norm([RIB_REF_E[0]-RIB_REF_D[0], RIB_REF_E[1]-RIB_REF_D[1]]);
// tangential_pt(s,n): OPEN-frame (world) point, s = distance along DE
// from D, n = perpendicular distance off the DE face. Always valid
// (D/E are fixed, never rotate) -- but the result is an open-frame
// target and MUST go through freeze_from_open() before use below.
function tangential_pt(s,n) = [RIB_REF_D[0]+s*DE_DIR[0]+n*DE_NORM[0], RIB_REF_D[1]+s*DE_DIR[1]+n*DE_NORM[1]];

CB1_OD        = 101.6;    // 4" square tube
CB1_AIR_GAP   = 20;
CB1_STANDOFF  = CB1_AIR_GAP + CB1_OD/2;   // 70.8mm, DE face to tube centerline
CB1_EDGE_FRAC = 0.40;     // fraction of DE_LEN from D to CB1's own center -- gives real, verified 30.27mm D-clearance
UWALL         = 20;       // Ua/Ub/Uc wall thickness
UARM_REACH    = CB1_OD/2; // 50.8mm (2in) -- Ua/Uc's own reach along the pipe face, Ub to CB1's centerline; wraps HALF the tube only (enough for the weld, not meant to enclose CB1 entirely)
NECK_HALF_W   = 25;       // 50mm total neck width
NECK_LEN      = 25;       // rigid, fixed neck length

CB1_EDGE_DIST = CB1_EDGE_FRAC * DE_LEN;                  // s-position of CB1's own center
Ub_inner_s    = CB1_EDGE_DIST - UARM_REACH;              // Ub's own inner (tube-side) face
Ub_outer_s    = Ub_inner_s - UWALL;                       // Ub's own outer (D-side/back) face -- neck attaches here
Uarm_top_n    = CB1_STANDOFF + CB1_OD/2 + UWALL;         // Ua's own outer face
Ubbc          = tangential_pt(Ub_outer_s, CB1_STANDOFF); // Ub's centerline x back edge (QA/reporting reference point)

// CB1 bracket -- Ua (top arm) / Ub (back wall) / Uc (bottom arm, the
// DE-contact stopper) wrapping CB1 on 3 sides, traced as ONE single
// polygon (not 3 separately-unioned rectangles -- avoids the OpenSCAD
// 2D boolean coincident-edge gap trap, see rules-bbq-fab.md).
BRACKET_OUTLINE = [
    tangential_pt(Ub_outer_s-NECK_LEN, CB1_STANDOFF-NECK_HALF_W),  // t7 -- neck_l tip
    tangential_pt(Ub_outer_s, CB1_STANDOFF-NECK_HALF_W),            // neck root, bottom, on Ub's own back face
    tangential_pt(Ub_outer_s, 0),                                    // Ub back-bottom corner
    tangential_pt(CB1_EDGE_DIST, 0),                                 // Uc outer-bottom corner -- DE-contact stopper, on the DE line itself
    tangential_pt(CB1_EDGE_DIST, CB1_STANDOFF-CB1_OD/2),             // Uc inner-top corner (at CB1's own centerline)
    tangential_pt(Ub_inner_s, CB1_STANDOFF-CB1_OD/2),                // U-mouth, bottom (Ub/Uc inner corner)
    tangential_pt(Ub_inner_s, CB1_STANDOFF+CB1_OD/2),                // U-mouth, top (Ub/Ua inner corner)
    tangential_pt(CB1_EDGE_DIST, CB1_STANDOFF+CB1_OD/2),             // Ua inner-bottom corner (at CB1's own centerline)
    tangential_pt(CB1_EDGE_DIST, Uarm_top_n),                        // Ua outer-top corner
    tangential_pt(Ub_outer_s, Uarm_top_n),                           // Ub back-top corner
    tangential_pt(Ub_outer_s, CB1_STANDOFF+NECK_HALF_W),             // neck root, top, on Ub's own back face
    tangential_pt(Ub_outer_s-NECK_LEN, CB1_STANDOFF+NECK_HALF_W),   // t7u -- neck_r tip
];
t7_native  = freeze_from_open(BRACKET_OUTLINE[0]);   // t7 -- EDGE point, no radius of its own (matches t2-t4)
t7u_native = freeze_from_open(BRACKET_OUTLINE[11]);  // t7u -- EDGE point, no radius of its own (matches t2-t4)

// t6be -- a POINT (no boss radius of its own), built AT THE OPEN door
// position: a vertical line through t6/FC, 20mm Z-drop, frozen to
// native. Disclosed, Janis-confirmed finding: at this exact point the
// pivot bore's own material margin is negative for any half-width
// above ~6.5mm (this file's usual convention is 20mm) -- accepted:
// not-colliding matters more than the full margin here.
T6BE_OPEN   = [FC_Y, FC_Z - 20];
t6be_native = freeze_from_open(T6BE_OPEN);

// T4U -- the top rib line's own anchor (NOT the existing t4, the
// mitered turning point at apex C). Found by drawing a line
// PERPENDICULAR to the BC wall (along BC_NORM) from apex C
// (RIB_REF_C) until it intersects the ridge (the rib's own flat top
// boundary, same Z as t4/t5). Sits 11.7mm from t4, inside t4's own R4
// fillet circle -- real material overlap for the union, not a gap.
function line_hits_z(P,dir,z) = let(t=(z-P[1])/dir[1]) [P[0]+t*dir[0], P[1]+t*dir[1]];
T4U = line_hits_z(RIB_REF_C, BC_NORM, t5[1]);

// Top rib line (T4U -> t7u): a gentle circular arc, real radius picked
// for a visibly gentle bulge (not derived from a tangency constraint --
// forcing tangency to t4-t5 over-constrains the circle into an
// excessive sweep, see rules-bbq-fab.md). Bulge direction picked via
// the SHORT arc on the OUTWARD side, same convention as ext_tangent().
TOP_ARC_R = 1500;
function circle_center_2pt(P,Q,R,outward) = let(
    d = norm([Q[0]-P[0], Q[1]-P[1]]),
    mid = [(P[0]+Q[0])/2, (P[1]+Q[1])/2],
    h = sqrt(max(0,R*R - (d/2)*(d/2))),
    dirpq = unit([Q[0]-P[0], Q[1]-P[1]]),
    perp = [-dirpq[1], dirpq[0]],
    c1 = [mid[0]+h*perp[0], mid[1]+h*perp[1]],
    c2 = [mid[0]-h*perp[0], mid[1]-h*perp[1]],
    s1 = (c1[0]-mid[0])*outward[0]+(c1[1]-mid[1])*outward[1],
    s2 = (c2[0]-mid[0])*outward[0]+(c2[1]-mid[1])*outward[1]
) (s1>s2) ? c1 : c2;
TOP_ARC_CENTER = circle_center_2pt(T4U, t7u_native, TOP_ARC_R, OUTWARD);

// Bottom rib line (t5 -> t6be -> t7) and top rib line (T4U -> arc ->
// t7u) are BOUNDARY EDGES of one SOLID FILLED region connecting the
// existing rib body to the CB1 bracket -- not two separate thin arms
// with hollow space between them. t6be/t7/t7u are EDGE points (no
// separate expanding radius/boss), matching t2-t4's own convention.
// T4U (not t4) is the top-side anchor; the T4U->t5 edge is a flat line
// at the SAME Z as the existing t4-t5 edge, passing directly over t4
// (exact-coincident overlap with the existing rib material).
RIB1_WEB_OUTLINE = concat(
    [T4U, t5, t6be_native, t7_native, t7u_native],
    arc_pts(TOP_ARC_CENTER, TOP_ARC_R, t7u_native, T4U)
);

module cb1_link_2d() {
    union() {
        polygon(points=[for(p=BRACKET_OUTLINE) pt2(freeze_from_open(p))]);
        polygon(points=[for(p=RIB1_WEB_OUTLINE) pt2(p)]);
    }
}

module rib_profile_2d_native(with_cb1=false) {
    difference() {
        union() {
            part1_2d();
            part2_2d();
            if (with_cb1) cb1_link_2d();
        }
        translate(pt2(t1)) circle(d=HANDLE_ROD_OD, $fn=64);
        translate(pt2(t6)) circle(d=27, $fn=64);
    }
}

RIB_T=3;
// rib_solid(RIB_X) -- as delivered, bakes its own X-placement translate
// internally (unlike the old parameterless rib_solid(), which relied on
// the wrapping lid_rib_assembly()'s own translate) -- lid_rib_assembly()
// below adjusted accordingly, R-009 checked (only one X-translate now
// applied, not two).
module rib_solid(RIB_X, with_cb1=false) {
    translate([RIB_X,0,0]) rotate([0,90,0]) translate([0,0,-RIB_T/2])
        linear_extrude(height=RIB_T, convexity=8) rib_profile_2d_native(with_cb1);
}

// lid_rib_assembly() -- RIB_X now passed straight through to rib_solid()
// (which places it internally); this module applies ONLY the pivot
// rotation about FC_Y/FC_Z. A pure-X translate commutes freely with a
// rotation confined to the Y-Z plane, so this reordering doesn't change
// the net transform -- confirmed via a fresh render, not assumed from
// the algebra alone. `with_cb1` -- new this round, RIB1 (middle rib)
// ONLY per the CB1 prompt's own title ("Middle Rib (RIB1)"); RIB0/RIB2
// stay plain, no lateral link.
module lid_rib_assembly(RIB_X, door_open_deg=0, with_cb1=false) {
    translate([0, FC_Y, FC_Z])
        rotate([-door_open_deg, 0, 0])
        translate([0, -FC_Y, -FC_Z])
        rib_solid(RIB_X, with_cb1);
}
// lid_rib_rotate() -- the SAME transform, for the parts that span the
// FULL width across all 3 ribs (handle rod, CB1 pipe) and rotate as one
// rigid unit WITH the ribs (Section 4 Step 5 -- one consistent frame).
module lid_rib_rotate(door_open_deg) {
    translate([0, FC_Y, FC_Z])
        rotate([-door_open_deg, 0, 0])
        translate([0, -FC_Y, -FC_Z])
        children();
}

// ─── RIB X-positions -- ALL 3 RIBS IDENTICAL (Section 6). v7 TASK 3:
// inset reduced 150mm -> 100mm, Janis's own direct instruction. RIB1_X
// formula UNCHANGED (stays the midpoint). Re-ran the rib-vs-tray sweep
// fresh at these new X values (this file's own header) -- both still
// fall inside their respective tray's real X-span, same real FAIL as
// before, not re-litigated. ───
RIB0_X = LID_X0 + 100;                  // 200mm
RIB2_X = LID_X1 - 100;                  // 715mm
RIB1_X = (RIB0_X + RIB2_X) / 2;         // 457.5mm, unchanged

// ─── Handle rod -- hollow tube, rotates with the ribs, spans all 3 ───
HANDLE_SPAN_MARGIN = 15;
handle_x0 = RIB0_X - HANDLE_SPAN_MARGIN;
handle_x1 = RIB2_X + RIB_T + HANDLE_SPAN_MARGIN;
module handle_rod() {
    len = handle_x1 - handle_x0;
    translate([handle_x0, HANDLE_Y, HANDLE_Z]) rotate([0,90,0]) difference() {
        cylinder(h=len, r=HANDLE_ROD_OD/2, $fn=64);
        translate([0,0,-e]) cylinder(h=len+2*e, r=HANDLE_ROD_OD/2 - HANDLE_ROD_WALL, $fn=64);
    }
    // end caps -- close both ends of the hollow tube
    translate([handle_x0, HANDLE_Y, HANDLE_Z]) rotate([0,90,0])
        cylinder(h=HANDLE_ROD_WALL, r=HANDLE_ROD_OD/2, $fn=64);
    translate([handle_x1-HANDLE_ROD_WALL, HANDLE_Y, HANDLE_Z]) rotate([0,90,0])
        cylinder(h=HANDLE_ROD_WALL, r=HANDLE_ROD_OD/2, $fn=64);
}

// ─── CB1 pipe -- REAL COUNTERWEIGHT MASS, restored 2026-07-30 per
// Janis's own explicit correction ("cb1 consist of the bracket cb1
// which is locked and cb1 4 inch pipe weight with both end close with
// end cap... put this pipe back in place"). This is a SEPARATE part
// from the bracket (Ua/Ub/Uc, in cb1_link_2d() above, still locked,
// untouched) -- the bracket wraps/cradles this pipe on 3 sides and
// welds to it; the pipe itself is the real counterbalance mass. Same
// 4"-square-tube size the bracket was always built to wrap
// (`CB1_OD`=101.6mm, already the wrap-clearance constant above), same
// real span/wall/position convention as the original v6-v9 design
// (`archive/BBQ-offset-smoker-base-v9.scad`, `CB1_WALL`=3,
// `CB1_LEN`=chamber_L-100=815mm, `CB1_MASS_KG`=8.06 real/locked there --
// NOT reused as a given here, this file computes its own real mass from
// the actual solid below, see docs/lid-hinge-moment-analysis.md).
// Position: same OPEN-frame centerline the bracket already wraps
// (`tangential_pt(CB1_EDGE_DIST, CB1_STANDOFF)`), converted to native
// frame the same way as every other CB1 point (`freeze_from_open()`) --
// one single native-frame point since the pipe's own Y-Z position does
// not vary with X, exactly like the handle rod. ───
CB1_WALL = 3;                                    // mm, real wall thickness, matches the original v9 design
CB1_LEN  = chamber_L - 100;                      // 815mm, centered on chamber_L, spans well past all 3 ribs (matches original v9 formula)
cb1_x0   = (chamber_L - CB1_LEN) / 2;            // 50mm
cb1_x1   = cb1_x0 + CB1_LEN;                     // 865mm
CB1_OPEN_CENTER   = tangential_pt(CB1_EDGE_DIST, CB1_STANDOFF);   // open-frame centerline, same point the bracket wraps
CB1_CENTER_NATIVE = freeze_from_open(CB1_OPEN_CENTER);            // native/closed frame, per this project's own construction convention
module cb1_pipe() {
    cy = CB1_CENTER_NATIVE[0];
    cz = CB1_CENTER_NATIVE[1];
    difference() {
        translate([cb1_x0, cy-CB1_OD/2, cz-CB1_OD/2]) cube([CB1_LEN, CB1_OD, CB1_OD]);
        translate([cb1_x0-e, cy-CB1_OD/2+CB1_WALL, cz-CB1_OD/2+CB1_WALL])
            cube([CB1_LEN+2*e, CB1_OD-2*CB1_WALL, CB1_OD-2*CB1_WALL]);
    }
    // end caps -- close both ends of the hollow tube
    translate([cb1_x0, cy-CB1_OD/2, cz-CB1_OD/2]) cube([CB1_WALL, CB1_OD, CB1_OD]);
    translate([cb1_x1-CB1_WALL, cy-CB1_OD/2, cz-CB1_OD/2]) cube([CB1_WALL, CB1_OD, CB1_OD]);
}

// ─── Axle + hinge brackets -- v9 REAL REBUILD, mounted in the end
// margin zone (this file's own header). The axle is ONE continuous shaft
// (unchanged concept since v6 -- Janis's own "pass a shaft to all 3
// ribs") now spanning between the two real hinge brackets themselves
// (`FRONT_BOSS_X`..`REAR_BOSS_X`), which sit OUTSIDE the door's own
// length entirely, comfortably past all 3 ribs on both ends. ───
ARM_R = 8;   // mm -- slender riser half-thickness, placeholder
module axle_rod() {
    translate([FRONT_BOSS_X, FC_Y, FC_Z]) rotate([0,90,0])
        cylinder(h=REAR_BOSS_X-FRONT_BOSS_X, r=AXLE_ROD_OD/2, $fn=64);
}
// hinge_bracket(boss_x, near_edge_x, dir) -- real foot flush on the
// ridge surface (Z=DATUM_Z_RIDGE), fully inside the end margin zone,
// its own near edge `GAP_FROM_DOOR`(25mm) from the door's own real
// boundary (`LID_X0`/`LID_X1`), extending AWAY from the door
// (dir=+1: front, extends toward -X; dir=-1: rear, extends toward +X).
// Connected to the pivot boss via a real hull-based riser (hull of two
// small spheres) -- since the bearing eye's own Y is EXACTLY the foot's
// own center Y (this file's own header), this riser comes out as a
// plain vertical post, not a diagonal arm -- confirmed via an isolated
// standalone render before being written here (per R-014), and per
// Janis's own explicit instruction ("dont make it fancy... as long as
// it contain the right key figure... it is accepted"). Simple bbox/
// cylinder/hull placeholder, no supplier casting detail (rules-bbq-fab.md
// Construction Method).
module hinge_bracket(boss_x, near_edge_x, dir) {
    foot_x0 = dir > 0 ? near_edge_x - FOOT_A : near_edge_x;
    foot_top = [foot_x0 + FOOT_A/2, FC_Y, DATUM_Z_RIDGE + FOOT_T];
    boss_pt  = [boss_x, FC_Y, FC_Z];
    difference() {
        union() {
            translate([foot_x0, FC_Y - FOOT_L/2, DATUM_Z_RIDGE])
                cube([FOOT_A, FOOT_L, FOOT_T]);
            hull() {
                translate(foot_top) sphere(r=ARM_R, $fn=24);
                translate(boss_pt)  sphere(r=ARM_R, $fn=24);
            }
            translate([boss_x-FOOT_A/2, FC_Y, FC_Z]) rotate([0,90,0])
                cylinder(h=FOOT_A, r=HINGE_BOSS_R, $fn=32);
        }
        translate([boss_x-FOOT_A/2-e, FC_Y, FC_Z]) rotate([0,90,0])
            cylinder(h=FOOT_A+2*e, r=AXLE_STUB_OD/2+0.5, $fn=32);
        translate([foot_x0+FOOT_A/2, FC_Y-FOOT_L/2+15, DATUM_Z_RIDGE-e]) cylinder(h=FOOT_T+2*e, r=BOLT_D/2, $fn=16);
        translate([foot_x0+FOOT_A/2, FC_Y+FOOT_L/2-15, DATUM_Z_RIDGE-e]) cylinder(h=FOOT_T+2*e, r=BOLT_D/2, $fn=16);
    }
}

// ─── Full lid-hinge assembly ───
module lid_hinge_assembly(door_open_deg=0) {
    axle_rod();
    hinge_bracket(FRONT_BOSS_X, FRONT_NEAR_EDGE, 1);
    hinge_bracket(REAR_BOSS_X, REAR_NEAR_EDGE, -1);
    lid_rib_assembly(RIB0_X, door_open_deg, true);   // CB1 lateral link -- ALL 3 ribs, per Janis's own explicit instruction 2026-07-30 (originally middle-rib-only per prompts/cc_prompt_cb1_link.md's own title; scope widened)
    lid_rib_assembly(RIB1_X, door_open_deg, true);
    lid_rib_assembly(RIB2_X, door_open_deg, true);
    lid_rib_rotate(door_open_deg) handle_rod();
    lid_rib_rotate(door_open_deg) cb1_pipe();
}

// ───────────────────────────────
// KINETIC PARAMETERS — all 3 real dials together, just before ASSEMBLY.
// `door_open_deg` drives the visual lid() call and the rib/CB1/handle
// assembly directly (both explicit module arguments below) — there is
// no shared/reassigned global variable in this path.
// ───────────────────────────────
/* [Kinetic Parameters] */
door_open_deg   = 0;      // 0=closed .. 90=open
tray0_angle_deg = 0;      // -90=stowed(vertical) .. 0=deployed(horizontal)
tray1_angle_deg = 0;      // -90=stowed(vertical) .. 0=deployed(horizontal), independent from tray0_angle_deg

// BBQ-chambers-v26.scad's own internal lid() draw is suppressed
// (show_lid=false) — this file draws the visual lid directly below with
// an explicit door_open_deg argument, so the lid shell and the 3 ribs
// always move together as one unit.
show_lid = false;

// ───────────────────────────────
// DEBUG TOGGLES
// ───────────────────────────────
show_trays      = true;
show_lid_hinge  = true;
show_visual_lid = true;

// ───────────────────────────────
// ASSEMBLY — each line standalone/commentable per Module Isolation
// Testing (rules-codes.md). The chamber's own ASSEMBLY (chamber_shell/
// firebox/exhaust_room/chimney_pipe/grate/drains) already executed above
// at include time, per BBQ-chambers-v26.scad's own DEBUG TOGGLES/
// ASSEMBLY section — `lid()` itself is suppressed there (`show_lid =
// false` above) and drawn here instead. This file adds the tray, the
// visual lid, and the lid-hinge assembly.
// ───────────────────────────────
if (show_trays) color("#AAAAAA", 1.0) trays();
if (show_visual_lid) color("#C8C8C8", 0.75) lid(door_open_deg);
if (show_lid_hinge) color("#8C8C8C", 1.0) lid_hinge_assembly(door_open_deg);
