# ADDENDUM — SKILL_local_render.md
# New section: Independent Post-Fix Verification (R-111 escalation)
# Origin: bbq-chambers "reads solid, not hollow" — 3 real fix attempts
# (PR #119, v5's end-cap gap fix, PR #121) all failed the same human
# visual check despite each one's own CGAL/manifold checks passing.
# Resolved only once Claude Web stopped trusting cc_chat_log/PR text at
# face value and independently re-rendered the ACTUAL merged file.

## SCOPE — THIS IS A VERIFICATION RULE, NOT A DESIGN RULE

This addendum governs ONLY read-only fact-checking: fetching a file that
already exists on `main` and rendering it to confirm or deny a claim
about it. It does NOT authorize Claude Web to prototype fixes, iterate
on construction methods, or do any other sandbox design/coding work by
default — that remains governed by the standing rule at the top of this
file (sandbox design use only when Janis explicitly asks, or cc is
genuinely stuck — and even then, ask before proceeding rather than
deciding unilaterally that a case qualifies).

The two are easy to tell apart: verification never produces a new
`.scad` construction or a new instruction for cc — it only produces a
render of something that already exists, and a true/false answer about
whether it matches what was claimed. If Claude Web is writing new
OpenSCAD logic in the sandbox, that's design work and needs Janis's
go-ahead first, independent of whether R-111 has triggered.

## THE GAP THIS CLOSES

A cc PR can be entirely honest and entirely wrong at the same time: real
CGAL checks, real probes, `Simple: yes` — and still miss the actual
defect, because manifold validity and visual correctness are different
properties. A closed hollow ring with a spurious flat panel inside it is
perfectly manifold. Three real, good-faith fix attempts in this project
passed every check they ran and still didn't fix what Janis was seeing,
because each one tested the wrong thing (color/opacity, then a different
end-cap module, then a different module again) without anyone rendering
the actual result and looking at it independently.

## THE RULE

Once R-111 triggers (2+ failed loops on the same human-reported symptom):

1. **Before proposing a fix:** don't just re-read the code and reason
   about it. Fetch the actual live file
   (`raw.githubusercontent.com/.../main/<path>`, already an allowed
   domain) and render it locally (SKILL_local_render.md's existing
   procedure). Reproduce the symptom yourself, in a real render, before
   writing a diagnosis.
2. **After cc reports a fix:** the same independent check applies before
   telling Janis it's resolved. Fetch the newly merged file (not the
   prompt, not the PR description — the actual `.scad` file from `main`)
   and render it locally, at the same angle(s) that showed the original
   symptom. Only confirm resolution after seeing it fail to reproduce in
   an independent render Claude Web generated itself.
3. A clean cc_chat_log entry and passing CGAL checks are necessary but
   NOT sufficient to close an R-111 item. They confirm the geometry is
   valid. They do not confirm it looks like what the human is asking
   for. Only an independent render (or the human's own live check)
   confirms that.

## WHEN THIS APPLIES

Not every fix needs this — most single-loop fixes are fine with the
normal cc_chat_log review. This specifically applies once R-111 has
triggered, because that's the signal that the normal
report-check-trust loop has already failed at least twice, and
continuing to trust the same channel a third time without an
independent check is how it fails a third time.
