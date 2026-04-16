# Ralph Skills For Codex

Ralph is a Codex-focused skills project for interactive PRD planning and autonomous implementation loops.

## Prerequisites

- Codex CLI installed and authenticated
- `jq` installed
- A git repository for the target project

## Repository Layout

| Path | Purpose |
|------|---------|
| `skills/ralph-prd/` | Interactively clarify a feature and save `tasks/prd-[feature-name].md` |
| `skills/ralph-json/` | Convert a Ralph PRD markdown file into `./ralph/prd.json` |
| `skills/ralph-json/resources/` | Runtime template copied into target projects as `./ralph/` |
| `.agents/skills/` | Project-local links used for local Codex testing |

## Recommended Workflow

1. Use `ralph-prd` in your current Codex CLI session.
2. `ralph-prd` writes `tasks/prd-[feature-name].md`.
3. Use `ralph-json` in your current Codex CLI session.
4. `ralph-json` reads the selected `tasks/prd-[feature-name].md` and writes `./ralph/prd.json`.
5. Run Ralph manually from the target project root:

```bash
./ralph/ralph.sh 10
```

`./ralph.sh` accepts the same optional `max_iterations` argument as before. If omitted, it defaults to `10`.

## First Use In A Project

1. Bootstrap the Ralph runtime into the target project from `skills/ralph-json/resources/`:

```bash
mkdir -p ./ralph
cp /path/to/ralph/skills/ralph-json/resources/ralph.sh ./ralph/ralph.sh
cp /path/to/ralph/skills/ralph-json/resources/CODEX.md ./ralph/CODEX.md
chmod +x ./ralph/ralph.sh
```

2. In your Codex CLI session, run `ralph-prd` and generate `tasks/prd-[feature-name].md`.
3. In your Codex CLI session, run `ralph-json` and select that PRD file to generate `./ralph/prd.json`.
4. Start the loop manually:

```bash
./ralph/ralph.sh 10
```

Bootstrap only creates these runtime files:

- `./ralph/ralph.sh`
- `./ralph/CODEX.md`

The later files are created by later steps:

- `tasks/prd-[feature-name].md` from `ralph-prd`
- `./ralph/prd.json` from `ralph-json`
- `./ralph/progress.txt`, `./ralph/.last-branch`, and `./ralph/archive/` from `./ralph.sh`
- implementation output in the project root (one level above `./ralph/`)

## Minimal Example

From the target project root:

```bash
mkdir -p ./ralph
cp /path/to/ralph/skills/ralph-json/resources/ralph.sh ./ralph/ralph.sh
cp /path/to/ralph/skills/ralph-json/resources/CODEX.md ./ralph/CODEX.md
chmod +x ./ralph/ralph.sh
```

Then in Codex CLI:

1. Run `ralph-prd`
2. Save the result to `tasks/prd-my-feature.md`
3. Run `ralph-json`
4. Select `tasks/prd-my-feature.md`

Then back in the terminal:

```bash
./ralph/ralph.sh 10
```

## Install Skills Globally

If you only want the skills, install them into Codex's global skills directory:

```bash
mkdir -p ~/.agents/skills
cp -r skills/ralph-prd ~/.agents/skills/ralph-prd
cp -r skills/ralph-json ~/.agents/skills/ralph-json
```

Project-local `.agents/skills/` still takes precedence over global skills.

## Verification

The smoke test lives at:

- `tests/codex_wrapper_smoke.sh`

Run it with:

```bash
bash tests/codex_wrapper_smoke.sh
```
