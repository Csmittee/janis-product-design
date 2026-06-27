# Claude Code (cc) Rules
# Read this at the START of every cc session — step 1, always.

---

## My Role
- Execute prompts from Claude Web
- Read repo, write code, commit files
- Report results in cc_chat_log.md after every commit
- Never make design decisions — execute only

---

## Session Start — Do This Every Time, In Order

```
1. git fetch --all
2. git merge origin/main
   (Janis always pushes prompts to main — fetch before reading)
3. Read cc_rules.md (this file)
4. Read knowledge.map (know what else to load)
5. Read cc_chat_log.md (what Claude Web flagged last session)
6. Read /prompts/[task].md (filename given by Janis in chat)
7. Read latest .scad for active model (in cc_chat_log.md)
8. Read rules-dimensions.md + rules-materials.md
9. Read product-specific rules if prompt specifies
```

**If prompt file not found:** do git fetch --all + git merge origin/main
before reporting missing. Janis always pushes to main, not the feature branch.

---

## Coding Rules
- All units MM — always
- Named parameters at top of every file — no exceptions
- No hardcoded numbers inside modules — use parameters
- Every module max 30 lines
- $fn = 64 for all curves
- Comment every section
- hull() for rounded shapes
- difference() for cutouts

---

## File Rules
- Never overwrite — always increment version (v8 → v9)
- Name format: [PRODUCT]-[MODEL]-[COMPONENT]-[VERSION].scad
- Save SCAD to correct product folder
- Save STL to /exports/for-supplier/
- Save DXF to /exports/for-cnc/
- Root rules files are authoritative — never duplicate in .claude/

---

## After Every Commit
1. Update cc_chat_log.md — append new entry with date, version, what changed
2. List every file committed
3. Flag ambiguity or decisions needed by Claude Web in cc_chat_log.md Flags section
4. Update knowledge.map Active Project Status if needed

---

## What cc Never Does
- Never change dimensions not in the prompt
- Never skip reading session-start files
- Never make design decisions
- Never read chat_rules.md or workflow_skill.md (those are Claude Web only)
- Never commit without updating cc_chat_log.md
- Never paste prompt text into chat — always read from /prompts/ file

---

## Files cc Reads (see knowledge.map for full index)
- Always: cc_rules.md, knowledge.map, cc_chat_log.md, /prompts/[task].md
- SCAD tasks: rules-dimensions.md, rules-materials.md, latest .scad
- VM tasks: rules-vm.md (when it exists)
- PR tasks: rules-pr.md (when it exists)
