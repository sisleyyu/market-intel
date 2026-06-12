#!/bin/bash
set -euo pipefail

CLAUDE="/Applications/cmux.app/Contents/Resources/bin/claude"
PYTHON="/opt/anaconda3/bin/python3"
REPO="/Users/sisley/ClaudeBase/market-intel"
DATE=$(date +%Y-%m-%d)
REPORT_FILE="$REPO/digital-twin/weekly-$DATE.md"

mkdir -p "$REPO/logs"
LOG="$REPO/logs/run-$DATE.log"
exec >> "$LOG" 2>&1

echo "======================================"
echo "Digital Twin 情報週報 — $DATE"
echo "開始時間: $(date)"
echo "======================================"

cd "$REPO"

# 1. 用 Claude 搜尋並產生報告
echo "[1/4] 正在搜尋並產生報告..."
cat "$REPO/prompt.md" | "$CLAUDE" -p \
  --allowedTools "WebSearch" > "$REPORT_FILE"

echo "      報告已儲存：$REPORT_FILE"

# 2. 更新 index.html
echo "[2/4] 正在更新 index.html..."
"$PYTHON" "$REPO/update-index.py" "$DATE" "$REPORT_FILE"

# 3. Git commit & push
echo "[3/4] 正在 commit 並推送至 GitHub..."
git add digital-twin/ index.html
git commit -m "weekly: digital twin intel $DATE"
git push origin main

# 4. 開啟 HTML（可選：若希望完成後自動開啟瀏覽器）
# open "$REPO/index.html"

echo "[4/4] 完成！"
echo "完成時間: $(date)"
echo ""
