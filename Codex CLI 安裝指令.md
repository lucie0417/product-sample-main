# Codex CLI 安裝指令速查表

> Codex CLI 安裝方式擇一即可；Git 與 Node.js 則依需求安裝，各工具不必重複使用多種安裝方式。更新時請沿用原本的安裝方式。

## 前置工具：安裝 Git

Git 用於專案版本控制、查看差異與提交變更。先檢查是否已安裝：

```bash
git --version
```

若能顯示版本，可略過 Git 安裝；否則依作業系統使用下方指令。

### macOS：使用 Homebrew

**第一步：安裝 Homebrew**

若已安裝 Homebrew，可略過此步驟。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

此指令會下載並執行 Homebrew 官方安裝腳本；請閱讀提示並依組織政策確認安裝。
若安裝程式提示需要系統開發工具，依其提示完成即可，不需另外選擇 Git 安裝方式。

**第二步：完成終端機環境設定**

安裝完成後，依畫面上的 **Next steps** 執行環境設定指令，將 Homebrew 加入 `PATH`，再重新開啟終端機。
Apple Silicon 與 Intel Mac 的安裝路徑不同，請以安裝程式顯示的指令為準。

**第三步：安裝 Git 並確認版本**

```bash
brew --version
brew install git
git --version
```

若找不到 `brew`，請先完成上一步的環境設定，再執行 Git 安裝。

### Windows：使用 WinGet

在 PowerShell 執行：

```powershell
winget --version
winget install --id Git.Git --exact --source winget
```

依提示確認安裝與可能出現的系統授權，完成後關閉並重新開啟終端機。
若找不到 `winget`，請安裝或更新 [App Installer](https://learn.microsoft.com/windows/package-manager/winget/)，或改用 [Git for Windows 官方下載頁](https://git-scm.com/install/windows) 的安裝程式。

> WinGet 的 `Git.Git` 套件並非由 Git for Windows 專案維護，版本可能與官方最新版本不同。

### Linux／WSL：使用發行版套件管理器

依發行版選擇一組指令；WSL 請在 Linux 終端機內執行，而不是 PowerShell。

**Ubuntu／Debian**

```bash
sudo apt-get update
sudo apt-get install git
```

**Fedora**

```bash
sudo dnf install git
```

套件安裝可能要求管理員密碼及確認；受管理的環境請依組織政策處理。

### 確認 Git 安裝成功

```bash
git --version
```

若仍找不到命令，請重新開啟終端機並檢查 `PATH`。
若後續需要提交變更，請另外依專案規範設定 Git 提交者名稱與電子郵件；安裝 Git 不等於已完成 GitHub 登入或遠端儲存庫授權。

## 1. macOS／Linux：官方安裝腳本

在終端機執行：

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

此方式不需先安裝 Node.js 或 npm。

> 此指令會下載並立即執行遠端腳本，請先確認網址與來源可信，並遵循組織的安裝政策。

## 2. Windows：官方安裝腳本

在 PowerShell 執行：

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://chatgpt.com/codex/install.ps1 | iex"
```

此方式不需先安裝 Node.js 或 npm。

> 此命令會在啟動的 PowerShell 程序中略過執行原則，並下載、執行官方腳本；若組織政策禁止，請勿自行繞過。

## 3. 跨平台：使用 npm 安裝

適用於已安裝 Node.js 與 npm 的 macOS、Linux 或 Windows 環境。

### 檢查前置工具

```bash
node --version
npm --version
```

若兩個命令都能顯示版本，且 Node.js 是目前受支援的 LTS 版本，可直接跳到「安裝 Codex CLI」。否則依作業系統選擇下列方式；Node.js 會一併安裝 npm，不需另外安裝 npm。

### macOS／Linux：使用 nvm 安裝 Node.js LTS

適用於 Bash 或 Zsh 終端機，也可用於 Windows 的 WSL；不適用於原生 PowerShell。
若已安裝 nvm，可略過第一步。

**第一步：安裝 nvm**

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
```

> 此命令會下載並執行 nvm 官方腳本，且可能更新 Shell 啟動設定；執行前請確認來源與組織政策。此處固定 nvm 版本，日後更新請參考官方 README。

**第二步：關閉並重新開啟終端機，再安裝 LTS**

```bash
command -v nvm
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'
```

`command -v nvm` 應顯示 `nvm`；若無輸出，先依 [nvm 官方安裝說明](https://github.com/nvm-sh/nvm#installing-and-updating) 檢查 Shell 啟動設定，不要繼續執行後續命令。
`nvm alias default 'lts/*'` 會讓新終端機使用已安裝的 LTS；若已有專案指定 Node.js 版本，請先確認相容性。

**第三步：確認 Node.js 與 npm**

```bash
node --version
npm --version
```

> nvm 的全域 npm 套件依 Node.js 版本分開安裝；日後切換版本，可能需要在新版本下重新安裝 Codex CLI。

### Windows：使用 WinGet 安裝 Node.js LTS

在原生 PowerShell 執行：

```powershell
winget --version
winget install --id OpenJS.NodeJS.LTS --exact --source winget
```

依提示確認安裝與可能出現的系統授權。完成後關閉並重新開啟 PowerShell，再確認：

```powershell
node --version
npm --version
```

若找不到 `winget`，請透過 Microsoft Store 安裝或更新 [App Installer](https://learn.microsoft.com/windows/package-manager/winget/)，或直接使用 [Node.js 官方下載頁](https://nodejs.org/en/download) 的 Windows LTS 安裝程式。

> 若 PowerShell 回報禁止執行 `npm.ps1`，可改用 `npm.cmd --version`，並以 `npm.cmd install -g @openai/codex` 安裝，不必為此放寬系統執行原則。

### 安裝 Codex CLI

```bash
npm install -g @openai/codex
```

## 4. macOS：使用 Homebrew 安裝

適用於已安裝 Homebrew 的環境。

```bash
brew --version
brew install --cask codex
```

若尚未安裝 Homebrew，請參考 [Homebrew 官方網站](https://brew.sh/)，或直接使用前面的官方安裝腳本。

## 5. 確認安裝成功

上述任一安裝方式完成後，執行：

```bash
codex --version
codex --help
```

能顯示版本與說明，代表終端機已能找到並執行 Codex CLI；帳號登入與模型存取仍需另外確認。

## 6. 首次啟動與登入

```bash
codex
```

依畫面提示選擇 **Sign in with ChatGPT**，並在瀏覽器完成登入。
可用功能與額度依帳號方案及組織政策而異。

也可以先執行登入命令：

```bash
codex login
```

查詢其他登入方式：

```bash
codex login --help
```

> API key 是另一種驗證方式，可能產生獨立的 API 費用；不要把金鑰寫入教學文件、程式碼或版本控制。

## 7. 在專案資料夾啟動

先切換到實際專案，再開啟 Codex：

```bash
cd /path/to/your-project
codex
```

請將 `/path/to/your-project` 替換為實際路徑；路徑含空白時需加引號。
啟動後先確認目前目錄及權限，再授權修改檔案或執行命令。

## 8. 更新版本

### 原本使用官方腳本安裝

重新執行對應平台的官方安裝指令，完成後確認版本。

### 原本使用 npm 安裝

```bash
npm install -g @openai/codex@latest
codex --version
```

### 原本使用 Homebrew 安裝

```bash
brew update
brew upgrade --cask codex
codex --version
```

## 9. 常見安裝問題

| 問題 | 建議處理方式 |
| --- | --- |
| `codex: command not found`，或 Windows 無法辨識 `codex` | 重新開啟終端機，確認安裝成功，並檢查安裝目錄是否已加入 `PATH`。 |
| 找不到 `node` 或 `npm` | 先安裝 Node.js LTS，或改用不依賴 npm 的官方安裝腳本。 |
| 找不到 `git` | 依前置工具章節安裝 Git，重新開啟終端機，再執行 `git --version`。 |
| npm 出現 `EACCES` 權限錯誤 | 檢查 npm 全域安裝目錄的權限；優先使用 Node.js 版本管理工具或官方安裝腳本，不要直接以 `sudo` 掩蓋問題。 |
| 安裝後仍顯示舊版本 | 檢查是否同時透過多種方式安裝，確認 `PATH` 實際選中的執行檔。 |
| 安裝成功但登入失敗 | 執行 `codex login --help` 檢查支援方式，並確認網路、帳號及組織政策。 |

查詢目前使用的執行檔位置：

```bash
# macOS／Linux
command -v codex
```

```powershell
# Windows PowerShell
Get-Command codex
```

## 官方參考資料

- [OpenAI Codex 官方儲存庫與安裝說明](https://github.com/openai/codex#installing-and-running-codex-cli)
- [Codex CLI 官方文件](https://developers.openai.com/codex/cli)
- [CLI 指令參考](https://developers.openai.com/codex/cli/reference)
- [帳號與 API key 驗證說明](https://developers.openai.com/codex/auth)
- [Node.js 官方下載與 LTS 版本](https://nodejs.org/en/download)
- [nvm 官方安裝說明](https://github.com/nvm-sh/nvm#installing-and-updating)
- [Microsoft WinGet 安裝說明](https://learn.microsoft.com/windows/package-manager/winget/)
- [WinGet 的 Node.js LTS 套件資訊](https://github.com/microsoft/winget-pkgs/tree/master/manifests/o/OpenJS/NodeJS/LTS)
- [Git：macOS 安裝說明](https://git-scm.com/install/mac)
- [Git：Windows 安裝說明](https://git-scm.com/install/windows)
- [Git：Linux 安裝說明](https://git-scm.com/install/linux)

## 10. 設定 Playwright MCP（專案層級）

[Playwright MCP](https://github.com/microsoft/playwright-mcp) 讓 Codex 能操作瀏覽器：開啟網頁、點擊、填表、取得頁面快照與截圖，適合前端驗證與 E2E 測試。

前置條件：已安裝 Node.js LTS（需要 `npx`）。

### 建立專案設定檔

在專案根目錄建立 `.codex` 資料夾，再建立或編輯 `.codex/config.toml`。macOS、Linux 與 Windows 都使用這個專案內的相對路徑。

```text
your-project/
└── .codex/
    └── config.toml
```

> 這是專案層級設定，不是使用者層級的 `~/.codex/config.toml`。請直接編輯專案設定檔，不要使用預設的 `codex mcp add` 寫入使用者設定。Codex 只會載入已信任專案的 `.codex/config.toml`；請在確認專案內容安全後，依啟動畫面的提示信任專案。

### 加入 Playwright MCP

在專案的 `.codex/config.toml` 加入以下內容；若已有其他設定，保留它們，且不要重複宣告相同的 TOML 區段：

```toml
[mcp_servers.playwright]
command = "npx"
args = ["@playwright/mcp@latest"]
```

若要使用無頭模式（不顯示瀏覽器視窗），在 `args` 加上 `"--headless"`：

```toml
[mcp_servers.playwright]
command = "npx"
args = ["@playwright/mcp@latest", "--headless"]
```

> Windows 若無法直接執行 `npx`，可改用 `command = "cmd"`、`args = ["/c", "npx", "@playwright/mcp@latest"]`。

首次使用若提示缺少瀏覽器，可先安裝：

```bash
npx playwright install chromium
```

## 11. 設定 Chrome DevTools MCP（專案層級）

[Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp) 讓 Codex 連上 Chrome DevTools，可檢查 console、網路請求、效能追蹤與 DOM／CSS，適合除錯與效能分析。

前置條件：

- Node.js 20.19 以上（建議使用最新 LTS）。
- 已安裝 Chrome 穩定版或更新版本。

### 加入同一份專案設定檔

在上一節建立的專案 `.codex/config.toml` 中，接著加入：

```toml
[mcp_servers.chrome-devtools]
command = "npx"
args = ["chrome-devtools-mcp@latest"]
```

常用選項（加在 `args` 內）：

| 選項 | 說明 |
| --- | --- |
| `--headless` | 以無頭模式啟動 Chrome。 |
| `--isolated` | 使用暫時的使用者資料目錄，結束後自動清除。 |
| `--browser-url=http://127.0.0.1:9222` | 連接到已開啟遠端除錯埠的 Chrome。 |

連接既有 Chrome 時，需先以遠端除錯模式啟動：

```bash
# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-debug-profile
```

> 請使用獨立的 `--user-data-dir`，避免把日常登入中的瀏覽器工作階段暴露給 MCP。Chrome DevTools MCP 可讀取並操作瀏覽器內容，不要用它開啟含敏感資料的頁面。

## 12. 確認專案 MCP 設定成功

先切換到專案根目錄，再檢查設定：

```bash
cd /path/to/your-project
codex mcp list
codex
```

請將 `/path/to/your-project` 替換為實際路徑；路徑含空白時需加引號。專案已受信任並載入設定後，清單應能看到 `playwright` 與 `chrome-devtools`。啟動 Codex 後，在對話中輸入 `/mcp` 確認 MCP 連線狀態與可用工具；出現在設定清單中不代表已成功連線。

> 專案設定不會修改使用者層級設定，但使用者層級的其他 MCP 仍可能一併載入；若之前已在全域設定加入這兩個 MCP，切換專案不會自動移除全域設定。

測試提示詞範例：

```text
使用 Playwright MCP 開啟 https://example.com，並告訴我頁面標題。
```

```text
使用 Chrome DevTools MCP 開啟 https://example.com，列出 console 訊息與網路請求。
```

移除專案設定：在專案的 `.codex/config.toml` 刪除 `[mcp_servers.playwright]` 或 `[mcp_servers.chrome-devtools]` 區段及其所屬設定，保留其他區段。不要用預設的 `codex mcp remove` 代替編輯專案設定檔。

> 修改專案的 `.codex/config.toml` 後，請在該專案中重新啟動 Codex，讓設定生效。

### MCP 參考資料

- [Codex MCP 官方文件](https://developers.openai.com/codex/mcp)
- [Playwright MCP 官方儲存庫](https://github.com/microsoft/playwright-mcp)
- [Chrome DevTools MCP 官方儲存庫](https://github.com/ChromeDevTools/chrome-devtools-mcp)
