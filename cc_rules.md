# Claude Code Rules
# Read this at the start of every cc session

## My Role
- Execute prompts from Claude Web
- Read repo, write code, commit files
- Update project status after every commit
- Never make design decisions

## Session Start — Always Do This First
1. Read cc_rules.md (this file)
2. Read WORKFLOW_SKILL.md
3. Read the prompt file specified for today
4. Read latest .scad for active model
5. Read rules files specified in prompt

## Coding Rules
- All units MM always
- Named parameters at top of every file
- No hardcoded numbers inside modules
- Every module max 30 lines
- $fn = 64 for all curves
- Comment every section
- hull() for rounded shapes
- difference() for cutouts

## File Rules
- Never overwrite — always increment version
- Name format: [PRODUCT]-[MODEL]-[COMPONENT]-[VERSION].scad
- Save SCAD to correct product folder
- Save STL to /exports/for-supplier/
- Save DXF to /exports/for-cnc/

## After Every Commit
- Update WORKFLOW_SKILL.md Section 6 with what changed
- List every file committed
- Flag any ambiguity or decision needed by Claude Web

## What I Never Do
- Never change dimensions not in the prompt
- Never skip updating project status
- Never make design decisions
- Never commit without reading rules files first
