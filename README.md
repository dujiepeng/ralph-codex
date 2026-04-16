[中文说明](./README.zh-CN.md)

# Ralph Skills For Codex

Ralph is a Codex-focused workflow for turning a feature idea into a PRD, converting that PRD into `ralph/prd.json`, and then running an autonomous implementation loop from the target project.

## Prerequisites

- Codex CLI installed and authenticated
- `jq` installed
- A git repository for the target project

## Repository Layout

| Path | Purpose |
|------|---------|
| `skills/ralph-prd/` | Interactively clarify a feature and save `tasks/prd-[feature-name].md` |
| `skills/ralph-json/` | Convert a Ralph PRD markdown file into `./ralph/prd.json` |
| `skills/ralph-json/resources/` | Runtime files copied into target projects as `./ralph/` |
| `.agents/skills/` | Project-local skills for local Codex testing |

## Complete Workflow

The intended flow is:

1. Install `ralph-prd` and `ralph-json` into the target project or global Codex skills directory.
2. In Codex, run `ralph-prd` to generate `tasks/prd-[feature-name].md`.
3. In Codex, run `ralph-json` to convert that PRD into `./ralph/prd.json`.
4. In the target project root, run `./ralph/ralph.sh` to execute the implementation loop.

`ralph-json` is also responsible for ensuring these runtime files exist before it writes `./ralph/prd.json`:

- `./ralph/ralph.sh`
- `./ralph/CODEX.md`

If either file is missing, `ralph-json` should copy it from `skills/ralph-json/resources/` and run:

```bash
chmod +x ./ralph/ralph.sh
```

## Step 1: Install The Two Skills

### Project-local install

Use this when you want the target project to carry its own Ralph skills:

```bash
mkdir -p .agents/skills
cp -r /path/to/ralph-codex/skills/ralph-prd .agents/skills/ralph-prd
cp -r /path/to/ralph-codex/skills/ralph-json .agents/skills/ralph-json
```

Project-local `.agents/skills/` takes precedence over global skills.

### Global install

Use this when you want the skills available to all projects:

```bash
mkdir -p ~/.agents/skills
cp -r /path/to/ralph-codex/skills/ralph-prd ~/.agents/skills/ralph-prd
cp -r /path/to/ralph-codex/skills/ralph-json ~/.agents/skills/ralph-json
```

## Step 2: Run `ralph-prd`

In the target project's Codex session, invoke `ralph-prd`.

Expected output:

- `tasks/prd-[feature-name].md`

What `ralph-prd` does:

- asks clarifying questions
- writes a structured PRD
- stops at planning only and does not implement anything

## Step 3: Run `ralph-json`

In the same target project's Codex session, invoke `ralph-json` and point it at the PRD from the previous step.

Expected output:

- `./ralph/prd.json`

What `ralph-json` does:

- reads `tasks/prd-[feature-name].md`
- converts user stories into ordered JSON stories
- ensures `./ralph/ralph.sh` and `./ralph/CODEX.md` exist
- makes `./ralph/ralph.sh` executable if it was copied in

After this step, the project usually contains:

- `tasks/prd-[feature-name].md`
- `./ralph/prd.json`
- `./ralph/ralph.sh`
- `./ralph/CODEX.md`

## Step 4: Run `./ralph/ralph.sh`

From the target project root:

```bash
./ralph/ralph.sh
```

Or with an explicit iteration limit:

```bash
./ralph/ralph.sh 10
```

### Script Parameters

`./ralph/ralph.sh [max_iterations]`

- `max_iterations`: optional positive integer
- default: `10`

Behavior:

- if omitted, Ralph runs with `10` iterations
- if provided, it must be a numeric value such as `5`, `10`, or `20`
- if more than one argument is provided, the script exits with usage information
- if the argument is not numeric, the script exits with usage information

### Files Produced By `ralph.sh`

During execution, the script may create or update:

- `./ralph/progress.txt`
- `./ralph/.last-branch`
- `./ralph/archive/`

Implementation changes are made in the project root, not inside `./ralph/`.

## Minimal Example

In the target project:

1. Install `ralph-prd` and `ralph-json`
2. Run `ralph-prd`
3. Save the result to `tasks/prd-my-feature.md`
4. Run `ralph-json`
5. Generate `./ralph/prd.json`
6. Run `./ralph/ralph.sh 10`

## Verification

The smoke test lives at `tests/codex_wrapper_smoke.sh`.

Run it with:

```bash
bash tests/codex_wrapper_smoke.sh
```
