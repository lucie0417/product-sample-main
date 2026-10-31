## Step 1:Hands-on Agent — 用一段話生出一個網頁 App(Claude Code 版)

歡迎!接下來你會親手完成三件事:讓 AI **自己動手寫程式**、讓 AI **接上外部工具**、讓 AI **照著你寫的劇本自動辦事**。

這一關我們先從最有感的開始:**用一段提示詞,讓 Claude Code 從零建出一個能用的待辦清單網頁**。

---

### ✅ 開始前環境檢查

- [ ] 已經用 `git clone` 把**你自己的這個 repo** 抓到電腦上
- [ ] 已安裝 **Claude Code**(終端機執行 `claude --version` 看得到版號)
- [ ] 有 Claude 訂閱(Pro / Max)或 Anthropic Console 帳號,可以登入
- [ ] 終端機已經 `cd` 進你的 repo 資料夾
- [ ] (選配,下方「接上瀏覽器工具」會用到)已安裝 **Node.js LTS**(終端機執行 `node --version` 與 `npx --version` 看得到版號)

> 💡 **安裝與登入**
> ```bash
> # macOS / Linux / WSL(官方安裝腳本)
> curl -fsSL https://claude.ai/install.sh | bash
> # 或用 npm(需 Node.js 18+)
> npm install -g @anthropic-ai/claude-code
>
> claude --version
> ```
> 第一次在專案資料夾執行 `claude` 會引導你登入;之後想換帳號可以在對話裡輸入 `/login`。

> 💡 **clone 指令長這樣**(把網址換成你自己的 repo):
> ```bash
> git clone https://github.com/{{full_repo_name}}.git
> cd <你的 repo 資料夾>
> ```

---

### 📖 觀念:Claude Code 「權限模式」

Claude Code 本身**就是 Agent** —— 你一打開它,它就能讀檔、改檔、執行終端機指令。差別只在於**每一次動手前要不要問你**,這由**權限模式**決定:

| 模式 | 白話比喻 | 行為 | 怎麼進入 |
| :--- | :--- | :--- | :--- |
| **default** | 每步都請示 | 讀檔免問;**改檔、跑指令前都會問你** | 預設 |
| **acceptEdits** | 改檔我放心,跑指令還是要問 | 自動同意檔案修改,指令仍會詢問 | <kbd>Shift</kbd>+<kbd>Tab</kbd> 切一次 |
| **plan** | 請人幫忙規劃 | **只讀、只規劃,不會動你的檔案**,方案確認後才開始做 | <kbd>Shift</kbd>+<kbd>Tab</kbd> 再切一次,或 `claude --permission-mode plan` |

(對照 Copilot:Ask ≈ 直接問問題、Plan ≈ plan 模式、Agent ≈ default / acceptEdits。)

**Agent 的關鍵差異**:你給的是**目標**,不是**步驟**。

它會先在腦中排一份工作清單(畫面上會出現 To-do),然後一項一項執行 —— 開檔案、寫程式、跑指令、看結果、發現不對再回頭改。你會在終端機**看到它一步一步做事**,這正是這一關要你親眼確認的事。

---

### ⌨️ 動手做:讓 Claude Code 建出你的 To-Do App

#### 1. 啟動 Claude Code

在 repo 根目錄執行:

```bash
claude
```

第一次進入某個資料夾,會問你「是否信任這個資料夾」,確認是自己的 repo 後選 **Yes**。

#### 2. 確認模式

輸入框下方會顯示目前的模式。這一關**保持預設就好**,不需要特地切換。

> ⚠️ 想看 AI 先出計畫再動手?按 <kbd>Shift</kbd>+<kbd>Tab</kbd> 切到 **plan mode** 再貼提示詞,它會先給你方案,同意後才實作。

#### 3. 確認模型

**保持預設就好**。需要時可輸入 `/model` 查看或切換 —— 這一關的任務預設模型完全做得來,而且比較省額度。

#### 4. 貼上提示詞,按 Enter

把下面整段複製貼上。**不要縮短它** —— 描述寫得越完整,AI 一次到位的機率越高,你就越不會浪費額度來回修正。

> ```prompt
> 請在這個專案的根目錄建立一個「待辦清單」網頁應用程式,規格如下:
>
> 【技術限制】
> - 只使用 HTML、CSS、原生 JavaScript
> - 不要使用任何框架或套件(不要 React / Vue / jQuery / Bootstrap / Tailwind)
> - 不要建立 package.json,不要執行 npm install
> - 不要引用任何外部 CDN,必須能離線開啟
>
> 【檔案結構】
> 根目錄下建立三個檔案:index.html、styles.css、app.js
>
> 【功能需求】
> 1. 輸入框 + 新增按鈕,可以新增待辦事項
> 2. 每一筆待辦左邊有勾選框,勾選後文字加上刪除線並淡化
> 3. 每一筆待辦右邊有刪除按鈕,可以刪除該筆
> 4. 底部顯示「未完成:N 項」
> 5. 清單為空時,顯示提示文字「還沒有任何待辦事項,新增一個吧!」
> 6. 資料存到 localStorage,重新整理頁面後資料還在
> 7. 輸入空白內容時不要新增
>
> 【介面需求】
> - 版面置中,最大寬度 520px,卡片式設計、圓角、淡淡的陰影
> - 支援手機螢幕(RWD)
> - 顏色使用 CSS 變數定義在 :root
>
> 【其他】
> - 程式碼註解請用繁體中文
> - 完成後告訴我要怎麼在瀏覽器打開來看
> ```

> 💡 多行貼上沒問題;想在輸入框內手動換行,用 <kbd>Shift</kbd>+<kbd>Enter</kbd>(或 <kbd>\\</kbd> 再 Enter)。

<details>
<summary>🇬🇧 English version of the prompt(點開)</summary>

```prompt
Create a "To-Do List" web application in the root of this project with the following specs:

[Technical constraints]
- Use only HTML, CSS, and vanilla JavaScript
- Do NOT use any framework or library (no React / Vue / jQuery / Bootstrap / Tailwind)
- Do NOT create package.json, do NOT run npm install
- Do NOT reference any external CDN; it must work fully offline

[File structure]
Create exactly three files in the root: index.html, styles.css, app.js

[Features]
1. A text input plus an "Add" button to create a to-do item
2. Each item has a checkbox on the left; when checked, the text gets a line-through and is dimmed
3. Each item has a delete button on the right
4. Show "Remaining: N" at the bottom
5. When the list is empty, show a friendly empty-state message
6. Persist data in localStorage so it survives a page refresh
7. Ignore submissions with empty/whitespace-only input

[UI]
- Centered layout, max-width 520px, card style with rounded corners and a subtle shadow
- Responsive on mobile
- Define colors as CSS variables in :root

[Other]
- Write code comments in Traditional Chinese
- When done, tell me how to open it in a browser
```

</details>

#### 5. 看著它工作 👀 —— 這是本關最重要的畫面

按下 Enter 之後**先不要動**,花 30 秒觀察終端機。畫面會隨版本與權限設定不同,但大致會看到:

- 它一邊思考、一邊用文字說明正在做什麼(要建哪些檔案、各自負責什麼)
- 工具呼叫的紀錄,例如建立 `index.html`、`styles.css`、`app.js`
- 最後它會總結做了什麼,並告訴你怎麼在瀏覽器打開

這就是 Agent 和單純問答最大的差別 —— **它在替你動手,不是在給你答案。**

#### 6. 確認檔案都建好了

不論過程中有沒有跳出任何確認畫面(依你的權限設定而定,**沒有跳出也是正常的**),等它回覆完成後,到專案資料夾確認:

```bash
ls
```

應該看到 `index.html`、`styles.css`、`app.js` 三個檔案。若它真的跳出確認選項,**先看清楚它要做的事再同意**。

#### 7. 打開來看看!

在終端機(新開一個分頁,或在 Claude Code 輸入框打 `!` 直接執行 shell 指令):

```bash
open index.html        # macOS
# Windows:start index.html   Linux:xdg-open index.html
```

> 💡 **更方便的做法**:直接跟 Claude Code 說「幫我用瀏覽器打開 index.html」,它會自己執行 `open`。

---

### 🌐 選配:接上瀏覽器工具,讓 Claude Code 自己開網頁驗證

剛剛你是**自己**打開瀏覽器檢查。其實可以讓 Claude Code 自己做這件事 —— 只要替它接上兩個「瀏覽器工具」(這類外掛工具稱為 **MCP**,**Step 3 會完整說明它是什麼**,這裡只要照著安裝就好):

| 工具 | 能做什麼 |
| :--- | :--- |
| **Playwright MCP** | 開網頁、點擊、填表、截圖 —— 像真人一樣操作畫面 |
| **Chrome DevTools MCP** | 看 console 錯誤、網路請求、DOM / CSS —— 除錯用 |

> ⚠️ 這一段是**選配**。安裝失敗不影響完成本關,可以跳過直接去「完成檢查」;之後再補也行。

> 💡 **「安裝」其實是什麼意思?** 這兩個 MCP 都是用 `npx` 啟動:你只要在設定裡告訴 Claude Code「用 `npx` 執行這個套件」,**第一次啟動時會自動下載**,不需要 `npm install -g`,也不會在你的 repo 裡留下 `node_modules`。

#### 1. 安裝兩個 MCP(在終端機,不是在 Claude Code 對話裡)

在 repo 根目錄執行:

```bash
claude mcp add playwright --scope project -- npx @playwright/mcp@latest
claude mcp add chrome-devtools --scope project -- npx chrome-devtools-mcp@latest
```

| 參數 | 意思 |
| :--- | :--- |
| `playwright` / `chrome-devtools` | 你幫這個 server 取的名字 |
| `--scope project` | 寫進**這個專案**的 `.mcp.json`(可 commit 共用);不加則預設只存在你個人、這個專案 |
| `--` | 分隔線,後面整段是「啟動 server 的指令」 |
| `npx @playwright/mcp@latest` | 實際啟動 MCP 的指令 |

執行後,專案根目錄會出現 **`.mcp.json`**:

📄 **`.mcp.json`**

```json
{
  "mcpServers": {
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "env": {}
    },
    "chrome-devtools": {
      "type": "stdio",
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"],
      "env": {}
    }
  }
}
```

> 💡 **不想用指令也可以**:自己建立 `.mcp.json` 貼上上面內容即可(內容跟指令的結果一樣)。
>
> 💡 **Windows(非 WSL)**:`npx` 需要透過 `cmd` 包一層,指令改成 `claude mcp add playwright --scope project -- cmd /c npx @playwright/mcp@latest`(Chrome DevTools 同理)。

#### 2. 安裝瀏覽器(只需一次)

```bash
npx playwright install chromium
```

Chrome DevTools MCP 則需要電腦上已安裝 **Chrome**(Node.js 20.19 以上)。

#### 3. 啟動 Claude Code 並核准

```bash
claude
```

因為 `.mcp.json` 是專案層級,Claude Code 第一次會問你**是否信任並啟用這些 server** → 看清楚名稱與指令後選 **Use this and all future MCP servers in this project**,或逐一啟用。

#### 4. 確認工具已載入

在 Claude Code 裡輸入:

```
/mcp
```

應該看到 `playwright` 與 `chrome-devtools` 狀態為 **connected**。(也可以在終端機執行 `claude mcp list` 查看所有 server 的健康狀態。)

#### 5. 讓 Claude Code 幫你驗證 To-Do App

```prompt
使用 Playwright MCP 開啟專案根目錄的 index.html,依序:新增一筆「買牛奶」、勾選它、重新整理頁面確認資料還在,最後截圖給我看,並回報有沒有任何異常。
```

```prompt
使用 Chrome DevTools MCP 開啟 index.html,列出 console 訊息,告訴我有沒有錯誤。
```

> 🔸 Claude Code 呼叫這些工具時可能會問你要不要允許,**看清楚它要做什麼再同意**。不要讓它去開含個人敏感資料的網頁。
>
> 🔸 `npx` 第一次執行要下載套件,可能等個幾十秒,屬正常。顯示 failed 時,在 `/mcp` 選該 server 看錯誤訊息,並確認 `node --version` 有值。
>
> 🔸 想移除:`claude mcp remove playwright`(或 `chrome-devtools`)。

---

### ✅ 完成檢查

在瀏覽器裡實際玩一下,確認這些都可以:

- [ ] 輸入文字按「新增」,項目出現在清單裡
- [ ] 勾選項目,文字出現刪除線
- [ ] 按刪除按鈕,項目消失
- [ ] 底部的「未完成:N 項」數字會跟著變動
- [ ] **重新整理頁面(F5),資料還在** ← 這代表 localStorage 有正確運作
- [ ] 清空所有項目後,出現「還沒有任何待辦事項」的提示

> ❓ **有哪一項不對?** 不用自己動手改 —— 直接在同一個對話裡告訴它,例如:
> ```prompt
> 重新整理頁面後資料就不見了,請檢查 localStorage 的存取邏輯並修好。
> ```
> **讓 AI 修自己的 bug,這就是 Agent 的日常用法。**

---

### 🔄 做壞了怎麼辦?

| 狀況 | 怎麼救 |
| :--- | :--- |
| 它**還在執行中**,看起來方向不對 | 按一下 <kbd>Esc</kbd> **立刻中斷**,再用文字告訴它要改做什麼 |
| 它**已經做完**,但改得很糟,想整個取消 | 按兩下 <kbd>Esc</kbd> 或輸入 `/rewind`,選到**那次提問之前**的位置,再選**還原程式碼**(Restore code)。這一關新建的三個檔案也會一併被移除 |
| `/rewind` 救不回來(例如檔案是被 shell 指令改的) | 用 git:先 `git clean -n` 預覽會刪哪些**未追蹤的新檔案**,確認後執行 `git clean -fd`;已追蹤的檔案再加 `git restore .` |

> 🔸 這一關的 `index.html`、`styles.css`、`app.js` 都是**新建、還沒 commit** 的檔案,`git restore .` 對它們**沒有作用**,要用 `git clean -fd` 才刪得掉。**`git clean -fd` 會刪掉所有未追蹤檔案,執行前務必先用 `-n` 預覽。**

Step 2 我們會**專門練習**這些還原技巧,現在知道有這回事就好。完整說明在 [docs/rollback.md](https://github.com/{{full_repo_name}}/blob/main/docs/rollback.md)。

---

### 🚀 推進到下一關

在終端機(Claude Code 內可用 `!` 開頭執行,或另開終端機)執行:

```bash
git add .
git commit -m "step 1: 用 Claude Code 建立待辦清單 App"
git pull --rebase
git push
```

> 💡 也可以直接說:「幫我 commit 並 push,訊息用 `step 1: 用 Claude Code 建立待辦清單 App`」,它會自己跑這些指令(視權限設定,可能會先請你確認)。
