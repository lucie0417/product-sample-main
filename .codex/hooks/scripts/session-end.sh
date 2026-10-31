#!/bin/bash
# session-end.sh — Codex SessionEnd hook（預設僅有 1 秒、最多 3 秒，需保持輕量）

LOG_DIR="$(cd "$(dirname "$0")/.." && pwd)/logs"
LOG_FILE="$LOG_DIR/session.log"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 讀取 stdin 的 JSON input（SessionEnd 事件提供的資料）
INPUT=$(cat)

echo "[$TIMESTAMP] 🔴 Codex session ended" >> "$LOG_FILE"

# 輸出今日 commit 摘要（輔助 daily-report skill）
TODAY=$(date '+%Y-%m-%d')
COMMITS=$(git log --since="$TODAY 00:00:00" --pretty=format:"  [%h] %s" 2>/dev/null)

echo ""
echo "🔴 Codex session ended — $TIMESTAMP"
if [ -n "$COMMITS" ]; then
  echo ""
  echo "📋 今日 Git commits:"
  echo "$COMMITS"
fi
echo ""
echo "💡 提示：執行 'git diff --staged' 後請 Codex 生成提交訊息"
exit 0
