#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

PROJECT_DIR="$TMP_DIR/project"
RUNTIME_DIR="$PROJECT_DIR/ralph"
BIN_DIR="$TMP_DIR/bin"

mkdir -p "$RUNTIME_DIR" "$BIN_DIR"
cp "$ROOT_DIR/skills/ralph-json/resources/ralph.sh" "$RUNTIME_DIR/ralph.sh"
cp "$ROOT_DIR/skills/ralph-json/resources/CODEX.md" "$RUNTIME_DIR/CODEX.md"
chmod +x "$RUNTIME_DIR/ralph.sh"

cat > "$RUNTIME_DIR/prd.json" <<'EOF'
{
  "branchName": "ralph/test-paths",
  "stories": []
}
EOF

cat > "$BIN_DIR/codex" <<EOF
#!/bin/bash
set -euo pipefail
pwd > "$TMP_DIR/codex_pwd.txt"
cat > /dev/null
printf '%s\n' '<promise>COMPLETE</promise>'
EOF
chmod +x "$BIN_DIR/codex"

(
  cd "$RUNTIME_DIR"
  PATH="$BIN_DIR:$PATH" ./ralph.sh 1 > "$TMP_DIR/run.log"
)

ACTUAL_PWD="$(cat "$TMP_DIR/codex_pwd.txt")"
EXPECTED_PWD="$PROJECT_DIR"

if [[ "$ACTUAL_PWD" != "$EXPECTED_PWD" ]]; then
  echo "Expected codex to run from project root: $EXPECTED_PWD"
  echo "Actual: $ACTUAL_PWD"
  exit 1
fi

if ! grep -Fq 'Read the PRD at `ralph/prd.json`' "$ROOT_DIR/skills/ralph-json/resources/CODEX.md"; then
  echo "Expected CODEX.md to read PRD from ralph/prd.json"
  exit 1
fi

if ! grep -Fq 'Read the progress log at `ralph/progress.txt`' "$ROOT_DIR/skills/ralph-json/resources/CODEX.md"; then
  echo "Expected CODEX.md to read progress from ralph/progress.txt"
  exit 1
fi

echo "PASS"
