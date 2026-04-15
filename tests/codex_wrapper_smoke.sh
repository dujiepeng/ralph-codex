#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_exists() {
  local path="$1"

  if [[ ! -e "$path" ]]; then
    echo "Expected path to exist: $path"
    exit 1
  fi
}

assert_missing() {
  local path="$1"

  if [[ -e "$path" ]]; then
    echo "Expected path to be removed: $path"
    exit 1
  fi
}

assert_contains() {
  local file="$1"
  local needle="$2"

  if ! grep -Fq "$needle" "$file"; then
    echo "Expected to find: $needle"
    echo "--- file content ---"
    cat "$file"
    exit 1
  fi
}

assert_exists "$ROOT_DIR/ralph/ralph.sh"
assert_exists "$ROOT_DIR/ralph/CODEX.md"
assert_exists "$ROOT_DIR/skills/ralph-prd/SKILL.md"
assert_exists "$ROOT_DIR/skills/ralph-json/SKILL.md"

assert_missing "$ROOT_DIR/bin"
assert_missing "$ROOT_DIR/skills/prd"
assert_missing "$ROOT_DIR/skills/ralph"

assert_contains "$ROOT_DIR/README.md" 'Use `ralph-prd` in your current Codex CLI session'
assert_contains "$ROOT_DIR/README.md" 'Use `ralph-json` in your current Codex CLI session'
assert_contains "$ROOT_DIR/README.md" 'tasks/prd-[feature-name].md'
assert_contains "$ROOT_DIR/README.md" 'cd ralph'
assert_contains "$ROOT_DIR/README.md" './ralph.sh 10'
assert_contains "$ROOT_DIR/skills/ralph-prd/SKILL.md" 'name: ralph-prd'
assert_contains "$ROOT_DIR/skills/ralph-prd/SKILL.md" 'Save to `tasks/prd-[feature-name].md`'
assert_contains "$ROOT_DIR/skills/ralph-prd/SKILL.md" 'Filename:** `prd-[feature-name].md`'
assert_contains "$ROOT_DIR/skills/ralph-json/SKILL.md" 'name: ralph-json'
assert_contains "$ROOT_DIR/skills/ralph-json/SKILL.md" 'Take a PRD (markdown file or text) and convert it to `./ralph/prd.json`'
assert_contains "$ROOT_DIR/skills/ralph-json/SKILL.md" 'Before writing `./ralph/prd.json`, verify:'

echo "PASS"
