# SKILL — Reference Point First (Local Datum Origin)
# Added: 2026-07-05, after VM-01 door redesign (v41→v42) tray/window desync bug

## What this fixes

VM-01-base-v41 had `tray_0_z` and the new door's `window_z0/z1` each
derived from independent formula chains anchored to different, arbitrary
starting points. When one part of the design changed (the exit flap
height), the other silently drifted out of sync — nobody had asked "what
is this actually measured FROM" before building it. The v42 fix (named
DATUMS block, see VM-01-base-v42.scad) treats the symptom. This skill is
the habit that prevents the class of bug from being introduced again.

## The rule

**Before building any new part or module's geometry, Claude Web asks
Janis one question: "What is the reference point for this — what is it
actually measured from?"**

Do not proceed to dimension anything until that's answered. Do not
assume world origin (0,0,0) is the right reference just because it's the
default. A part's natural reference point is often a real physical
feature — a mounting face, a hinge line, a datum surface the part is
built up from — and that's rarely the same as wherever the machine's
overall world origin happens to sit.

Once Janis names the reference point, that point becomes **local
(0,0,0) for that part's own geometry** — build the part's own internal
dimensions relative to its own local origin, THEN place it in the
assembly with a single `translate()` to the world-space datum (per the
DATUMS block convention already established). Never mix: a part's
internal geometry should not reference world-space datums for some
features and local offsets for others.

## Why local origin, not world origin

- Keeps the part's own dimensions readable and independent of where it
  sits in the final assembly — matches how Janis already thinks about it
  from CAD (draw the rectangle at a clear size, then place it).
- If the part moves in the assembly later, only the one `translate()`
  call changes — none of the part's internal formulas do.
- Makes it obvious, just by reading the module, what the part's
  dimensions are actually measured from — no need to trace a chain of
  other variables to find out.

## Relationship to the DATUMS block (v42 convention)

The DATUMS block (named DATUM_* constants, computed once from raw
numbers) is the WORLD-space side of this. This skill is the PART-space
side: every module should have its own clean local origin, tied to
exactly one DATUM_* via a single translate, never derived through a
chain of other modules' variables.

## Not in scope yet

Janis has offered a full GD&T (Geometric Dimensioning & Tolerancing)
system if this simpler reference-point habit stops being enough. Not
needed yet — current project scale doesn't require it. Revisit only if
the simple version starts failing to catch drift.
