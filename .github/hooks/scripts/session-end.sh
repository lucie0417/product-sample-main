#!/bin/bash
# session-end.sh — 對應 .gemini/hooks/end.js 的 Copilot CLI SessionEnd hook

LOG_DIR=".github/hooks/logs"
LOG_FILE="$LOG_DIR/session.log"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 讀取 stdin 的 JSON input（sessionEnd 事件提供的資料）
INPUT=$(cat)

echo "[$TIMESTAMP] 🔴 Copilot CLI session ended" >> "$LOG_FILE"

# 輸出今日 commit 摘要（輔助 daily-report skill）
TODAY=$(date '+%Y-%m-%d')
COMMITS=$(git log --since="$TODAY 00:00:00" --pretty=format:"  [%h] %s" 2>/dev/null)

echo ""
echo "🔴 Copilot CLI session ended — $TIMESTAMP"
if [ -n "$COMMITS" ]; then
  echo ""
  echo "📋 今日 Git commits:"
  echo "$COMMITS"
fi
echo ""
echo "💡 提示：執行 'git diff --staged' 後使用 commit-message prompt 生成提交訊息"
