#!/bin/bash
# security-check.sh — PreToolUse hook（matcher: Bash）：阻擋危險指令

# 從 stdin 讀取 JSON input
INPUT=$(cat)

if command -v jq &>/dev/null; then
  ARGS=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
else
  ARGS="$INPUT"
fi

DANGEROUS_PATTERNS="rm -rf|DROP TABLE|DROP DATABASE|git push --force|chmod 777|curl.*\| bash|wget.*\| sh"

if echo "$ARGS" | grep -qiE "$DANGEROUS_PATTERNS"; then
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
  LOG_DIR="$(cd "$(dirname "$0")/.." && pwd)/logs"
  mkdir -p "$LOG_DIR"
  echo "[$TIMESTAMP] ⚠️  BLOCKED dangerous command: $ARGS" >> "$LOG_DIR/security.log"

  # exit code 2 會阻擋工具呼叫，stderr 內容會回饋給 Codex
  echo "⚠️  Security hook: 偵測到潛在危險指令，請確認後再執行" >&2
  exit 2
fi

# 允許繼續執行
exit 0
