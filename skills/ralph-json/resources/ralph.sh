#!/bin/bash
# Ralph execution loop for supported coding CLIs.
# Usage: ./ralph.sh [--tool <codex|kimi>] [max_iterations]

set -euo pipefail

MAX_ITERATIONS=10
TOOL="codex"

usage() {
  echo "Usage: ./ralph.sh [--tool <codex|kimi>] [max_iterations]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)
      if [[ $# -lt 2 ]]; then
        usage
        exit 1
      fi
      TOOL="$2"
      shift 2
      ;;
    *)
      if [[ "$1" =~ ^[0-9]+$ ]] && [[ "$MAX_ITERATIONS" == "10" ]]; then
        MAX_ITERATIONS="$1"
        shift
      else
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ "$TOOL" != "codex" && "$TOOL" != "kimi" ]]; then
  usage
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PRD_FILE="$SCRIPT_DIR/prd.json"
PROGRESS_FILE="$SCRIPT_DIR/progress.txt"
ARCHIVE_DIR="$SCRIPT_DIR/archive"
LAST_BRANCH_FILE="$SCRIPT_DIR/.last-branch"
PROMPT_FILE="$SCRIPT_DIR/RALPH.md"

archive_previous_run() {
  local current_branch last_branch date folder_name archive_folder

  if [[ ! -f "$PRD_FILE" || ! -f "$LAST_BRANCH_FILE" ]]; then
    return
  fi

  current_branch="$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null || echo "")"
  last_branch="$(cat "$LAST_BRANCH_FILE" 2>/dev/null || echo "")"

  if [[ -z "$current_branch" || -z "$last_branch" || "$current_branch" == "$last_branch" ]]; then
    return
  fi

  date="$(date +%Y-%m-%d)"
  folder_name="$(echo "$last_branch" | sed 's|^ralph/||')"
  archive_folder="$ARCHIVE_DIR/$date-$folder_name"

  echo "Archiving previous run: $last_branch"
  mkdir -p "$archive_folder"
  [[ -f "$PRD_FILE" ]] && cp "$PRD_FILE" "$archive_folder/"
  [[ -f "$PROGRESS_FILE" ]] && cp "$PROGRESS_FILE" "$archive_folder/"
  echo "Archived to: $archive_folder"

  {
    echo "# Ralph Progress Log"
    echo "Started: $(date)"
    echo "---"
  } > "$PROGRESS_FILE"
}

track_current_branch() {
  local current_branch

  if [[ ! -f "$PRD_FILE" ]]; then
    return
  fi

  current_branch="$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null || echo "")"
  if [[ -n "$current_branch" ]]; then
    echo "$current_branch" > "$LAST_BRANCH_FILE"
  fi
}

ensure_progress_file() {
  if [[ -f "$PROGRESS_FILE" ]]; then
    return
  fi

  {
    echo "# Ralph Progress Log"
    echo "Started: $(date)"
    echo "---"
  } > "$PROGRESS_FILE"
}

archive_previous_run
track_current_branch
ensure_progress_file

run_iteration() {
  if [[ "$TOOL" == "codex" ]]; then
    codex exec --full-auto < "$PROMPT_FILE"
    return
  fi

  kimi --yolo --print --final-message-only --prompt "$(cat "$PROMPT_FILE")"
}

echo "Starting Ralph - Tool: $TOOL - Max iterations: $MAX_ITERATIONS"

for i in $(seq 1 "$MAX_ITERATIONS"); do
  echo
  echo "==============================================================="
  echo "  Ralph Iteration $i of $MAX_ITERATIONS ($TOOL)"
  echo "==============================================================="

  OUTPUT="$(
    cd "$PROJECT_DIR"
    run_iteration 2>&1
  )" || true
  printf '%s\n' "$OUTPUT"

  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
    echo
    echo "Ralph completed all tasks."
    echo "Completed at iteration $i of $MAX_ITERATIONS"
    exit 0
  fi

  echo "Iteration $i complete. Continuing..."
  sleep 2
done

echo
echo "Ralph reached max iterations ($MAX_ITERATIONS) without completing all tasks."
echo "Check $PROGRESS_FILE for status."
exit 1
