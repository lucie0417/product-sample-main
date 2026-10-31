#!/bin/bash
# session-init.sh — 對應 .gemini/hooks/init.js 的 Copilot CLI SessionStart hook

LOG_DIR=".github/hooks/logs"
LOG_FILE="$LOG_DIR/session.log"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
GIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")

echo "[$TIMESTAMP] ✅ Copilot CLI session started | branch: $GIT_BRANCH | commit: $GIT_HASH" >> "$LOG_FILE"

# 輸出工作上下文（顯示於終端機）
echo "🚀 Copilot CLI initialized"
echo "   Branch : $GIT_BRANCH"
echo "   Commit : $GIT_HASH"
echo "   Time   : $TIMESTAMP"
