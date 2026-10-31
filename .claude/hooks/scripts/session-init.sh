#!/bin/bash
# session-init.sh — Claude Code SessionStart hook

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/hooks/logs"
LOG_FILE="$LOG_DIR/session.log"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
GIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")

echo "[$TIMESTAMP] ✅ Claude Code session started | branch: $GIT_BRANCH | commit: $GIT_HASH" >> "$LOG_FILE"

# SessionStart 的 stdout 會成為 Claude 的工作上下文
echo "🚀 Claude Code initialized"
echo "   Branch : $GIT_BRANCH"
echo "   Commit : $GIT_HASH"
echo "   Time   : $TIMESTAMP"
exit 0
