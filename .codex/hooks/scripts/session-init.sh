#!/bin/bash
# session-init.sh — Codex SessionStart hook

LOG_DIR="$(cd "$(dirname "$0")/.." && pwd)/logs"
LOG_FILE="$LOG_DIR/session.log"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
GIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")

echo "[$TIMESTAMP] ✅ Codex session started | branch: $GIT_BRANCH | commit: $GIT_HASH" >> "$LOG_FILE"

# SessionStart 的 stdout 會成為 Codex 的工作上下文
echo "🚀 Codex initialized"
echo "   Branch : $GIT_BRANCH"
echo "   Commit : $GIT_HASH"
echo "   Time   : $TIMESTAMP"
exit 0
