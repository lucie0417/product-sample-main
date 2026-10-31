---
name: daily-report
description: 進度日報總結生成器。用於總結當日工作進度、Git commit 紀錄與檔案變更狀況，並產生結構化的 Markdown 報告。當用戶輸入「日報」、「進度總結」、「寫日報」或「生成今日報告」時觸發。
---

# 進度日報總結 Skill

此 Skill 協助用戶快速產生當日的工作進度日報，透過自動化分析 Git 紀錄與檔案變更，確保進度報告的準確性與專業性。

## 觸發條件

- 用戶輸入包含：「日報」、「進度總結」、「寫日報」、「生成今日報告」等關鍵字
- 需要進行工作匯報的場景

## 工作流程

### 1. 蒐集上下文

使用以下指令取得原始資料（透過 `run_in_terminal` 執行）：

```bash
# 今日 Git commit 紀錄
git log --since="$(date +%Y-%m-%d) 00:00:00" --pretty=format:"[%h] %s"

# 未提交的變更概覽
git diff --stat

# 暫存區變更
git diff --cached --stat
```

亦可直接執行輔助腳本：

```bash
node .github/skills/daily-report/scripts/get_daily_summary.cjs
```

- **對話歷史**：回顧當前對話中討論過的任務、Bug 修復或新功能開發

### 2. 結構化總結

產生的日報應包含以下區塊：

#### 📅 今日進度（Done）

- 列出今日已完成的主要任務
- 每個項目前方標註對應的 Git commit hash（如有）
- 範例：`[a1b2c3d] 實作購物車數量加減功能`

#### 🚧 進行中（Doing）

- 列出已開始但尚未完成的任務
- 說明目前的進度百分比或當前狀態

#### 🛑 遇到困難（Blockers）

- 記錄目前卡住的問題、技術難點或需要他人協助的事項
- 若無，則標註「無」

#### ⏭️ 明日計畫（Next Steps）

- 根據今日進度與未完成事項，列出明天的優先處理任務

## 輸出格式規範

```markdown
# 📋 每日工作日報 — YYYY-MM-DD

## 📅 今日完成（Done）
- [a1b2c3d] 實作功能 A
- [d4e5f6g] 修復 Bug B

## 🚧 進行中（Doing）
- 功能 C 開發中（預計完成度 60%）

## 🛑 遇到困難（Blockers）
- 無

## ⏭️ 明日計畫（Next Steps）
- 完成功能 C 並撰寫單元測試
- Code Review PR #42
```

- 使用標準 Markdown 格式
- 語言：繁體中文（或依用戶專案習慣）
- 保持精簡，避免冗長描述，優先使用條列式（Bullet points）

## 3. 存檔

先確認 `reports/` 資料夾存在(不存在就 `mkdir -p reports`),再把報告存成 `reports/DATE.md`。
最後告訴使用者:檔案路徑,以及這份報告裡有沒有任何你「不確定」的推測。

## 輔助腳本

呼叫 `scripts/get_daily_summary.cjs` 獲取自動化 Git 資料。
