#!/bin/bash
# security-check.sh — preToolUse hook：阻擋危險指令

# 從 stdin 讀取 JSON input
INPUT=$(cat)

if command -v jq &>/dev/null; then
  TOOL=$(echo "$INPUT" | jq -r '.toolName // ""')
  ARGS=$(echo "$INPUT" | jq -r '.toolArgs // ""')
else
  TOOL=""
  ARGS="$INPUT"
fi

# 檢查危險指令（僅針對 bash 工具）
if [ "$TOOL" = "bash" ]; then
  DANGEROUS_PATTERNS="rm -rf|DROP TABLE|DROP DATABASE|git push --force|chmod 777|curl.*\| bash|wget.*\| sh"

  if echo "$ARGS" | grep -qiE "$DANGEROUS_PATTERNS"; then
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    LOG_DIR=".github/hooks/logs"
    mkdir -p "$LOG_DIR"
    echo "[$TIMESTAMP] ⚠️  BLOCKED dangerous command: $ARGS" >> "$LOG_DIR/security.log"

    # 輸出 JSON 以拒絕工具呼叫（exit code 非 0 表示拒絕）
    echo "⚠️  Security hook: 偵測到潛在危險指令，請確認後再執行" >&2
    exit 2
  fi
fi

# 允許繼續執行
exit 0
