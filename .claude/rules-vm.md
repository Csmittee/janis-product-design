# Janis Product Design — VM-01 Rules
# Version: v1
# Date: 2026-06-29
# Read for all VM tasks.

---

## VM-01 Base — Active File
See knowledge.map for current active .scad filename.

## Key Rules
- Motor at BACK of tray (Y = tray_d - motor_d) — LOCKED
- Spring front end at Y=0 — LOCKED
- Tray construction: difference() single box — never union() floor+walls
- spring_gap = 13mm — OWNER-LOCKED
