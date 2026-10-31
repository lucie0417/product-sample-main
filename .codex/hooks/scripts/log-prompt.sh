#!/bin/bash
# log-prompt.sh — UserPromptSubmit hook：記錄每次 prompt 的稽核日誌

LOG_DIR="$(cd "$(dirname "$0")/.." && pwd)/logs"
LOG_FILE="$LOG_DIR/prompts.log"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 從 stdin 讀取 JSON input
INPUT=$(cat)

# 提取 prompt 內容（若 jq 可用則解析，否則原始記錄）
if command -v jq &>/dev/null; then
  PROMPT=$(echo "$INPUT" | jq -r '.prompt // "unknown"' 2>/dev/null)
else
  PROMPT="(raw) $INPUT"
fi

echo "[$TIMESTAMP] PROMPT: $PROMPT" >> "$LOG_FILE"
exit 0
