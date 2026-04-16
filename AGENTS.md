# Ralph Skills

## Overview

This repository is a coding-agent skills project. It provides:

- `skills/ralph-prd/` for interactively generating `tasks/prd-[feature-name].md`
- `skills/ralph-json/` for converting a markdown PRD into `./ralph/prd.json`
- `skills/ralph-json/resources/` for the runtime files copied into `./ralph/` in a target project

## Bootstrapping Ralph Into Another Project

When the user says "使用 ralph" (or "use ralph" / "set up ralph"), copy these files from `/Users/dujiepeng/project/AI/ralph/` into the target project:

- `skills/ralph-json/resources/ralph.sh` -> `ralph/ralph.sh`
- `skills/ralph-json/resources/RALPH.md` -> `ralph/RALPH.md`
- `skills/ralph-prd/` -> `.agents/skills/ralph-prd/`
- `skills/ralph-json/` -> `.agents/skills/ralph-json/`

Create parent directories as needed.

Do not overwrite existing files or directories with the same name without asking the user first.

After copying, make this file executable:

```bash
chmod +x ralph/ralph.sh
```

## Patterns

- Favor project-local skills in `.agents/skills/` so the current repo's Ralph skills take precedence over global skills.
- Keep `ralph-prd` focused on PRD generation. It should write `tasks/prd-[feature-name].md` and avoid changing the conversion rules.
- Runtime files that are copied into target projects belong under `skills/ralph-json/resources/`.
- Business logic belongs in `skills/` or the runtime files under `skills/ralph-json/resources/`, not in shell wrappers.
- `ralph.sh` supports `--tool codex` and `--tool kimi`, and both tools read the same `RALPH.md` prompt.
