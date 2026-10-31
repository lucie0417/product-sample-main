## Step 1:Hands-on Agent — 用一段話生出一個網頁 App(Codex CLI 版)

歡迎!接下來你會親手完成三件事:讓 AI **自己動手寫程式**、讓 AI **接上外部工具**、讓 AI **照著你寫的劇本自動辦事**。

這一關我們先從最有感的開始:**用一段提示詞,讓 Codex 從零建出一個能用的待辦清單網頁**。

---

### ✅ 開始前環境檢查

- [ ] 已經用 `git clone` 把**你自己的這個 repo** 抓到電腦上
- [ ] 已安裝 **Codex CLI**(終端機執行 `codex --version` 看得到版號)
- [ ] 有 ChatGPT 訂閱(Plus / Pro / Business 等)或 OpenAI API Key,可以登入
- [ ] 終端機已經 `cd` 進你的 repo 資料夾
- [ ] (選配,下方「接上瀏覽器工具」會用到)已安裝 **Node.js LTS**(終端機執行 `node --version` 與 `npx --version` 看得到版號)

> 💡 **安裝與登入**
> ```bash
> npm install -g @openai/codex
> # 或(macOS)brew install --cask codex
>
> codex --version
> codex        # 第一次執行會引導你用 ChatGPT 帳號登入
> ```

> 💡 **clone 指令長這樣**(把網址換成你自己的 repo):
> ```bash
> git clone https://github.com/{{full_repo_name}}.git
> cd <你的 repo 資料夾>
> ```

---

### 📖 觀念:Codex CLI 本身就是 Agent,差別在「核准 + 沙盒」

打開Codex 就能讀檔、改檔、跑指令。你控制的是**它能做多少事不用問你**,由兩個設定決定:

| 設定 | 意思 | 常見值 |
| :--- | :--- | :--- |
| **Approval(核准)** | 什麼時候要停下來問你 | `untrusted`(多數都問)、`on-request`(要越界才問)、`never`(不問) |
| **Sandbox(沙盒)** | 它實際能碰什麼 | `read-only`(只能讀)、`workspace-write`(可改工作資料夾)、`danger-full-access`(不設限) |

在 Codex 裡輸入 `/permissions`,會跳出 **Update Model Permissions** 選單,有四個現成組合:

| 組合 | 白話比喻 | 行為 |
| :--- | :--- | :--- |
| **1. Ask for approval**(預設,選單上標示 `(current)`) | **請一組工班來施工** | 可讀檔、改工作資料夾內的檔案、執行指令;**需要連網或修改工作資料夾以外的檔案時,才會問你** |
| **2. Approve for me** | 授權代理人自動放行 | 只有被判定為「可能不安全」的動作才會問你,其餘自動核准 |
| **3. Full Access** | 完全放手 | 可修改工作資料夾以外的檔案、不經核准就連網,**使用時務必小心,初學者不要用** |
| **4. Read Only** | 問路人 / 規劃 | 只能讀工作資料夾的檔案;**要修改檔案或連網都需要核准** |

> 💡 用 <kbd>↑</kbd><kbd>↓</kbd> 選擇、<kbd>Enter</kbd> 確認。

另外,Codex 有 `/plan`可以只做規劃;若你的版本沒有,直接在提示詞裡說「**先不要修改任何檔案,只給我計畫**」也能達到同樣效果。

**Agent 的關鍵差異**:你給的是**目標**,不是**步驟**。它會先排計畫,然後一項一項執行 —— 開檔案、寫程式、跑指令、看結果、發現不對再回頭改。你會在終端機**看到它一步一步做事**。

---

### ⌨️ 動手做:讓 Codex 建出你的 To-Do App

#### 1. 啟動 Codex

在 repo 根目錄執行:

```bash
codex
```

> ⚠️ Codex 偏好在 **git repo** 裡工作;若出現「不在受信任目錄 / 不是 git repo」的提示,確認是自己的 repo 後選擇信任。

#### 2. 確認權限

輸入 `/permissions`,**選 1. Ask for approval**(預設,標示 `(current)`)。這一關不需要 Approve for me 或 Full Access。

#### 3. 確認模型

**保持預設就好**。需要時輸入 `/model` 查看或切換 —— 這一關的任務預設模型完全做得來,而且比較省額度。

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

> 💡 多行貼上沒問題;想在輸入框內手動換行,用 <kbd>Shift</kbd>+<kbd>Enter</kbd>(或 <kbd>Ctrl</kbd>+<kbd>J</kbd>)。

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

- 它一邊思考、一邊用文字說明打算怎麼做
- 它執行的動作紀錄,例如建立 `index.html`、`styles.css`、`app.js`,或跑 `ls` 之類的指令
- 最後它會總結做了什麼,並告訴你怎麼在瀏覽器打開

這就是 Agent 和單純問答最大的差別 —— **它在替你動手,不是在給你答案。**

#### 6. 確認檔案都建好了

不論過程中有沒有跳出任何核准畫面(依你的權限設定而定,**沒有跳出也是正常的**),等它回覆完成後,到專案資料夾確認:

```bash
ls
```

應該看到 `index.html`、`styles.css`、`app.js` 三個檔案。若它真的跳出核准選項(例如要連網或改工作資料夾外的檔案),**先看清楚它要做的事再同意**。

#### 7. 打開來看看!

```bash
open index.html        # macOS
# Windows:start index.html   Linux:xdg-open index.html
```

> 💡 也可以直接說「幫我用瀏覽器打開 index.html」。想查它改了什麼,在 Codex 裡輸入 `/diff` 看 git diff(含新檔案)。

---

### 🌐 選配:接上瀏覽器工具,讓 Codex 自己開網頁驗證

剛剛你是**自己**打開瀏覽器檢查。其實可以讓 Codex 自己做這件事 —— 只要替它接上兩個「瀏覽器工具」(這類外掛工具稱為 **MCP**,**Step 3 會完整說明它是什麼**,這裡只要照著設定就好):

| 工具 | 能做什麼 |
| :--- | :--- |
| **Playwright MCP** | 開網頁、點擊、填表、截圖 —— 像真人一樣操作畫面 |
| **Chrome DevTools MCP** | 看 console 錯誤、網路請求、DOM / CSS —— 除錯用 |

> ⚠️ 這一段是**選配**。設定失敗不影響完成本關,可以跳過直接去「完成檢查」;之後再補也行。

> 💡 **「安裝」其實是什麼意思?** 這兩個 MCP 都是用 `npx` 啟動:你只要在設定檔裡告訴 Codex「用 `npx` 執行這個套件」,**第一次啟動時會自動下載**,不需要 `npm install -g`,也不會在你的 repo 裡留下 `node_modules`。

#### 1. 安裝兩個 MCP(寫入專案設定檔)

在專案根目錄建立資料夾 `.codex`,並在裡面建立 `config.toml`,貼上:

📄 **`.codex/config.toml`**

```toml
[mcp_servers.playwright]
command = "npx"
args = ["@playwright/mcp@latest"]

[mcp_servers.chrome-devtools]
command = "npx"
args = ["chrome-devtools-mcp@latest"]
```

> 💡 這是**專案層級**設定,只在這個專案生效。Codex 只會載入「已信任專案」的 `.codex/config.toml`,重新啟動 `codex` 看到「是否信任此目錄」時選信任。
>
> 💡 Windows 若無法直接執行 `npx`,可把 `command` 改成 `"cmd"`、`args` 改成 `["/c", "npx", "@playwright/mcp@latest"]`(Chrome DevTools 同理)。
>
> 💡 **也可以用指令安裝**:`codex mcp add playwright -- npx @playwright/mcp@latest`、`codex mcp add chrome-devtools -- npx chrome-devtools-mcp@latest`。但這會寫進**個人**的 `~/.codex/config.toml`(所有專案共用),不是這個 repo;本課程建議用上面的**專案設定檔**,Step 3 才能沿用。

#### 2. 安裝瀏覽器(只需一次)

在**另一個終端機**執行:

```bash
npx playwright install chromium
```

Chrome DevTools MCP 則需要電腦上已安裝 **Chrome**(Node.js 20.19 以上)。

#### 3. 重啟 Codex 並確認連線

結束 Codex(<kbd>Ctrl</kbd>+<kbd>C</kbd> 兩次),在專案根目錄重新執行 `codex`,然後輸入:

```text
/mcp
```

應該看到 `playwright` 與 `chrome-devtools` 兩個 server 及它們的工具清單。(也可以在另一個終端機執行 `codex mcp list` 確認有被載入。)

#### 4. 讓 Codex 幫你驗證 To-Do App

```prompt
使用 Playwright MCP 開啟專案根目錄的 index.html,依序:新增一筆「買牛奶」、勾選它、重新整理頁面確認資料還在,最後截圖給我看,並回報有沒有任何異常。
```

```prompt
使用 Chrome DevTools MCP 開啟 index.html,列出 console 訊息,告訴我有沒有錯誤。
```

> 🔸 Codex 呼叫這些工具時可能會問你要不要允許,**看清楚它要做什麼再同意**。不要讓它去開含個人敏感資料的網頁。
>
> 🔸 `npx` 第一次執行要下載套件,可能等個幾十秒,屬正常。連不上時先看 `/mcp` 的狀態,再確認 `node --version` 有值、設定檔沒有 TOML 格式錯誤。

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

Codex CLI **沒有內建的「還原檢查點」按鈕**,所以**養成 git commit 的習慣就是你的保險**:

| 狀況 | 怎麼救 |
| :--- | :--- |
| 它**還在執行中**,看起來方向不對 | 按一下 <kbd>Esc</kbd> **中斷**這一輪,再用文字告訴它要改做什麼 |
| 想先看它到底改了什麼 | Codex 裡輸入 `/diff`,或終端機 `git diff` |
| 它**已經做完**,但改得很糟,想整個取消 | 在**另一個終端機**用 git:先 `git clean -n` 預覽會刪哪些**未追蹤的新檔案**,確認後執行 `git clean -fd`;已追蹤的檔案再加 `git restore .` |

> 🔸 這一關的 `index.html`、`styles.css`、`app.js` 都是**新建、還沒 commit** 的檔案,`git restore .` 對它們**沒有作用**,要用 `git clean -fd` 才刪得掉。**`git clean -fd` 會刪掉所有未追蹤檔案,執行前務必先用 `-n` 預覽。**
>
> 🔸 對話本身想退回去重問,可以直接開新對話(`/new`);但**檔案的還原只能靠 git**。

Step 2 我們會**專門練習**這些還原技巧,現在知道有這回事就好。完整說明在 [docs/rollback.md](https://github.com/{{full_repo_name}}/blob/main/docs/rollback.md)。

---

### 🚀 推進到下一關

在終端機(另開一個分頁)執行:

```bash
git add .
git commit -m "step 1: 用 Codex CLI 建立待辦清單 App"
git pull --rebase
git push
```
