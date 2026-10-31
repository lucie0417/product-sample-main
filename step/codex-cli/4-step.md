## Step 4:Agentic Workflows — 把工作流程寫成劇本(Codex CLI 版)

前三關你都是**一次下一個指令**。但現實中,有些事你**每天都要做**,而且步驟永遠一樣。

最典型的就是:**寫日報**。看今天 commit 了什麼 → 看還有哪些改動沒提交 → 整理成「完成 / 進行中 / 卡關 / 明日計畫」→ 存檔。

這一關,我們把這套流程**寫成一份劇本**,以後只要一行 `$daily-report` 就能重複執行。而且它**只讀你本機的 git 紀錄**,不需要網路、不需要 GitHub、不會 push、也不會開 PR。

---

### 📖 觀念:什麼是 Agentic Workflow?

**Agentic Workflow = 把「多步驟、會重複做」的工作,寫成 AI 能照著執行的劇本。**

差別在這裡:

| | 一般提問 | Agentic Workflow |
| :--- | :--- | :--- |
| 形式 | 每次都重打一次提示詞 | 存成檔案,`$名稱` 就能叫出來 |
| 一致性 | 每個人問法不同,結果不同 | 全團隊跑同一套流程、同一種日報格式 |
| 範圍 | 通常一個動作 | 讀 git → 分類整理 → 產生報告 → 存檔,一路到底 |
| 可版控 | ❌ 在你的聊天記錄裡 | ✅ 在 repo 裡,可以 review、可以改進 |

Codex CLI 提供的「AI 資產」:

| 檔案 | 角色 | 什麼時候生效 |
| :--- | :--- | :--- |
| `AGENTS.md` | **規矩** — 這個專案的通則 | **每一次**對話啟動時自動帶入 |
| `.agents/skills/<名稱>/SKILL.md` | **劇本** — 一個具體任務的完整步驟(可附帶腳本) | 你輸入 `$名稱`、用 `/skills` 選取,或 Codex 依描述自動判斷時 |
| `.codex/config.toml` | **設定** — MCP server、模型、核准與沙盒等 | 自動套用(專案需受信任) |
| `.codex/agents/*.toml` | **角色** — 專屬的子代理(新版) | 被指派時 |

> 🔸 Codex 舊版有 `~/.codex/prompts/*.md` 的「自訂 slash 指令」,但它**只能放在個人資料夾、無法跟著 repo 走**,且已被 Skills 取代。要「可版控、全團隊共用」,請用 **Skills**。

(對照 Copilot:`copilot-instructions.md` → `AGENTS.md`、`prompts/*.prompt.md` → `skills/*/SKILL.md`。)

把它們和 MCP 組合起來,就是這場工作坊的完整公式:

> ### 🧩 規矩(AGENTS.md) + 劇本(Skill) + 手腳(MCP / 本機工具) = **Agentic Workflow**

這一關的「手腳」是**本機的 git 指令** —— 不是每個劇本都需要 MCP,離線也能很強。

---

### ⌨️ 動手做 A:先立規矩

`AGENTS.md` 會被**自動帶進每一次對話**,不用你每次重複交代「不要用 React」。

在專案根目錄啟動 `codex`,貼上:

> ```prompt
> 請建立專案根目錄的 AGENTS.md,用繁體中文寫,內容要包含以下規則:
>
> 【技術限制】
> - 這是純前端專案,只用 HTML、CSS、原生 JavaScript
> - 禁止引入任何框架或套件,不要建立 package.json,不要執行 npm install
> - 不要引用外部 CDN,必須能離線運作
> - 檔案結構固定為根目錄的 index.html、styles.css、app.js
>
> 【程式風格】
> - 註解一律用繁體中文,變數與函式命名用英文 camelCase
> - CSS 顏色一律使用 :root 定義的 CSS 變數,不要寫死色碼
> - 使用 const / let,不要用 var
> - 產生 DOM 內容時用 textContent 或 createElement,不要用 innerHTML 組字串
>
> 【協作方式】
> - 動手改之前,先條列說明打算改哪些檔案、做什麼變動,等我確認後才開始
> - 一次只處理一件事,不要順手做我沒要求的重構
> - 改完後說明要怎麼在瀏覽器中驗證
>
> 【日報規則】
> - 日報一律用繁體中文,存放在專案根目錄的 reports/ 資料夾,檔名為 YYYY-MM-DD.md
> - 產生日報時只讀取 git 紀錄,不要執行 git push、git commit、git reset 等會改動紀錄的指令
> - 日報內容只能根據實際的 git 紀錄與檔案變更,不可以憑空編造沒做過的事
> ```

> 💡 Codex 也有 `/init`,會**掃描專案自動產生** `AGENTS.md`。這一關我們要的是**你指定的規則**,所以用上面的提示詞。

> 💡 **如果你的團隊同時用 Claude Code**:規矩只寫一份 `AGENTS.md`,Claude Code 那邊的 `CLAUDE.md` 只放一行 `@AGENTS.md` 即可共用。

建好之後打開檔案看一眼 —— **從現在起,每次啟動 Codex 都會先讀這份規矩。**

---

### ⌨️ 動手做 B:寫劇本

Codex 的 Skill 是一個**資料夾**,裡面有一個 `SKILL.md`。建立 `.agents/skills/daily-report/SKILL.md`。

這個檔案**請直接手動建立並貼上內容**(而不是叫 agent 做),因為 agent 很容易「好心」改掉裡面的格式與步驟。

> 💡 資料夾不存在就先建:`mkdir -p .agents/skills/daily-report`

📄 **`.agents/skills/daily-report/SKILL.md`**

````markdown
---
name: daily-report
description: 讀取本機 git 紀錄,產生一份繁體中文工作日報並存成 reports/YYYY-MM-DD.md。當使用者要求寫日報、進度總結,或呼叫 $daily-report 時使用。
---

# 任務:產生工作日報

報告日期取自使用者呼叫此 skill 時附帶的內容(例如 `$daily-report 2026-05-01`)。
**如果使用者沒有提供日期,就用今天**(以 `date +%Y-%m-%d` 取得)。以下用 `DATE` 代表這個日期。

這是一個**唯讀**的劇本:只能讀 git 紀錄,**不可以** commit、push、reset 或修改任何程式檔案。**唯一允許寫入的是 `reports/DATE.md`。**
請**嚴格依照下列順序**執行,不要跳步:

## 1. 蒐集資料

依序執行,並把結果記住:

```
git branch --show-current
git log --since="DATE 00:00:00" --until="DATE 23:59:59" --pretty=format:"%h %s" --stat
git status --short
git diff --stat
```

## 2. 判斷有沒有資料

- 如果 `DATE` 當天**沒有任何 commit**,而且 `git status` 也是乾淨的:告訴使用者「這天沒有紀錄」,**停止**,不要編造內容。
- 否則繼續。

## 3. 分類整理

把資料歸類:

- **完成(Done)**:當天的 commit。每一項前面標上 commit hash,用一句人話說明做了什麼(不要只複製 commit 訊息)
- **進行中(Doing)**:`git status` / `git diff` 看到、尚未 commit 的修改,說明改了哪些檔案、推測在做什麼
- **卡關(Blockers)**:只有當 commit 訊息或程式註解**明確出現**問題、TODO、FIXME 時才列;否則寫「無」
- **明日計畫(Next)**:根據「進行中」與 TODO 提出 1~3 項建議,標明這是**建議**

## 4. 輸出報告

格式如下,用繁體中文:

```
# 工作日報 DATE

## 📅 今日完成
- [hash] 說明

## 🚧 進行中
- 說明(涉及檔案)

## 🛑 卡關
- 無

## ⏭️ 明日計畫(建議)
- 說明

## 📊 統計
- commit 數:N
- 異動檔案數:N
```

## 5. 存檔

先確認 `reports/` 資料夾存在(不存在就 `mkdir -p reports`),再把報告存成 `reports/DATE.md`。
最後告訴使用者:檔案路徑,以及這份報告裡有沒有任何你「不確定」的推測。
````

> 🔸 **為什麼是資料夾?** Skill 資料夾裡還可以放腳本、範本(例如固定日報格式的 `template.md`),SKILL.md 再去引用它。
> 🔸 `description` 很重要:Codex 靠它判斷「什麼時候該自動啟用這個 skill」,所以要寫清楚**做什麼、什麼時候用**。
> 🔸 Codex 沒有 `allowed-tools` 欄位;護欄來自**核准模式與沙盒**,以及劇本裡明確寫的「**只能讀、只能寫 reports/**」。讀取類的 git 指令通常不會被擋;若跳出核准選單,**看清楚是不是只有 `git log` / `status` / `diff`**,有 `push` / `commit` 就拒絕。
> 🔸 如果你的 repo 裡已經有同名的 `daily-report` skill,請把資料夾改名成 `my-daily-report`(frontmatter 的 `name` 也一起改),指令變成 `$my-daily-report`,避免互相蓋過。

---

### ⌨️ 動手做 C:執行你的劇本 🎬

1. 先確認**今天有一些 git 紀錄**(前面幾關的 commit 就算數)。想要內容更豐富,可以故意留一個**還沒 commit 的小修改**(例如隨手改 `styles.css` 一個顏色),它會出現在「進行中」
2. 在 Codex 輸入:

   > ```prompt
   > $daily-report
   > ```
   >
   > (輸入 `$` 時會跳出可選的 skill 清單。想看指定日期:`$daily-report 2026-05-01`。也可以直接說:「請用 daily-report skill 幫我寫今天的日報」)

3. 然後**放手讓它跑**。你會看到它依序執行 `git branch`、`git log`、`git status`、`git diff`
4. 最後寫檔時,Codex 可能跳出核准選單 → 確認路徑是 `reports/今天日期.md` → 同意
5. **打開 `reports/今天日期.md`**,對照 `git log` 檢查:
   - 每個 hash 都真的存在嗎?
   - 「進行中」有沒有對應你還沒 commit 的修改?
   - 有沒有編造你沒做過的事?



> ### 🏆 停下來想一下你剛剛做了什麼
> 你寫了**一份 Markdown 檔**,然後打了**一行指令**。
> AI 就自己讀了 git 紀錄、分類整理、產生一份格式固定的日報並存檔 —— **而且全程只用到唯讀指令。**
>
> **這就是 Agentic Workflow。** 而它是可以版控、可以 code review、可以整個團隊共用的。想換日報格式?改這一份 Markdown 就好。

---

### ✅ 完成檢查

- [ ] `AGENTS.md` 已建立(含【日報規則】)
- [ ] `.agents/skills/daily-report/SKILL.md` 已建立
- [ ] 在 Codex 輸入 `/skills`(或打 `$`)時,清單裡看得到 `daily-report`
- [ ] 成功跑完一次,並且產生了 `reports/YYYY-MM-DD.md`
- [ ] 日報內容和 `git log` 吻合,沒有編造

---

### 🔄 出問題怎麼辦?

| 狀況 | 解法 |
| :--- | :--- |
| `$daily-report` 叫不出來 | 路徑要正好是 `.agents/skills/daily-report/SKILL.md`,且 frontmatter 有 `name` 與 `description`;`/exit` 後重新 `codex` |
| 日期是空的、或日報標題出現 `DATE` 字樣 | 不填日期時它應該自己用 `date` 取得今天;仍有問題就明確打 `$daily-report 2026-05-01` |
| 回覆「這天沒有紀錄」 | 正常 —— 這天沒 commit 也沒修改。先 commit 一次,或指定有紀錄的日期 |
| 日報漏掉今天的 commit | 可能是時區或日期不同:用 `git log --since="midnight" --oneline` 自己看一下,再指定日期重跑 |
| 日報裡有你沒做過的事 | 在對話中指出,要求「只能根據 git 紀錄重新產生」;並檢查 `AGENTS.md` 的【日報規則】有沒有存在 |
| 寫入 `reports/` 被沙盒擋下 | 在核准選單選同意;或確認 Codex 是在專案目錄下啟動 |
| AI 改到不該改的地方 | `git restore .` 還原未 commit 的變更 |
| 想重做一份 | 直接重跑 `$daily-report`,會覆蓋同一天的檔案 |

> 🔸 這個劇本**不呼叫任何外部服務**,所以不會有登入、授權、Proxy 的問題。

---

### 🚀 完成最後一關

```bash
git add AGENTS.md .agents/skills/daily-report/SKILL.md reports/
git commit -m "step 4: 建立 AGENTS.md 與 daily-report 劇本"
git pull --rebase
git push
```

> 💡 `reports/` 想不想一起 commit 都可以 —— 推關只檢查 `AGENTS.md` 和 `.agents/skills/daily-report/SKILL.md` 是否存在。不想 commit 日報,就把 `reports/` 從 `git add` 那行拿掉。
