# DSH System Diagnostic Report
# Generated: 2025-01-24

## Executive Summary
This report identifies shortcomings, issues, and improvement opportunities across all DSH functions and tools.

---

## 1. Browser Bridge Tool (Critical短板)

### Current State
- **Status**: Plugin ENABLED but EXTENSION NOT CONNECTED
- **Bridge Token**: EXISTS at `~/.dsh/ext-bridge-token`
- **Available Tools**: browser_snapshot, browser_click, browser_type, browser_press, browser_scroll, browser_navigate, browser_back, browser_forward, browser_reload, browser_get_text, browser_wait

### Problem
All browser_* tools return "no browser extension is connected to the bridge" because the Chrome/Edge extension is not installed or not connected.

### Fix Required
1. Load the extension in browser:
   - Open Chrome/Edge → `chrome://extensions` or `edge://extensions`
   - Enable "Developer mode"
   - Click "Load unpacked"
   - Select: `C:\Users\Administrator\.dsh\browser-extension`
2. Get the bridge token from `~/.dsh/ext-bridge-token`
3. Paste token into extension settings panel
4. Extension will auto-connect to `ws://127.0.0.1:<port>/ext/bridge`

### Workaround (Immediate)
The extension can also be loaded from source at `C:\Users\Administrator\Desktop\buok\dsh-browser\packages\browser\` if a newer version is needed.

---

## 2. MCP Servers (Missing)

### Current State
- **agent-reach**: Configured in cordis.patch.yml but NOT installed
  - Required path: `C:\Users\Administrator\Desktop\桌面端\tools\agent-reach`
  - Requires: Python package `agent_reach`
  - Provides: Twitter/Reddit/B站/GitHub/小红书/V2EX integration
  
- **glm-vision**: Configured in cordis.patch.yml but NOT installed
  - Required path: `C:\Users\Administrator\Desktop\桌面端\tools\glm-vision\assets\glm-vision-mcp`
  - Requires: Node.js build + ZHIPU_API_KEY
  - Provides: Free image recognition (GLM-4.6V-Flash / MiMo V2.5 Free)

### Fix Required
```powershell
# Install agent-reach (requires Python)
pip install -e "C:\Users\Administrator\Desktop\桌面端\tools\agent-reach"

# Install glm-vision (requires ZHIPU_API_KEY from bigmodel.cn)
cd "C:\Users\Administrator\Desktop\桌面端\tools\glm-vision\assets\glm-vision-mcp"
npm install && npm run build
# Set environment variable: $env:ZHIPU_API_KEY = "your-key"
```

### Current MCP Count: 0 (should be 2 after fix)

---

## 3. DSH Web GUI (Not Running)

### Current State
- **Expected URL**: http://127.0.0.1:3080
- **Actual Status**: NO LISTENING PORT FOUND
- **Node Processes**: 2 running (PID 39176, 43544) but not serving port 3080

### Problem
The DSH web server is not running on the expected port. This means the GUI is inaccessible.

### Fix Required
```powershell
# From DSH checkout directory
cd "C:\Users\Administrator\Desktop\buok\deepseek-harness"
pnpm run dev:web
# Or start the web server via dshpm
pnpm exec dsh start --profile web --port 3080
```

---

## 4. Web Search (modsearch) - Partially Working

### Current State
- **modsearch version**: 5.4.2
- **Search provider**: firecrawl (READY, keyless)
- **Fetch provider**: local (READY)
- **Social search (X)**: NOT AVAILABLE (no grok-cli installed)

### Capabilities
- ✅ Web search: Works via firecrawl (1,000 free credits/month)
- ✅ Page fetching: Works via local provider
- ❌ X/Twitter search: Requires grok-cli (`grok` binary not found)
- ❌ Antigravity search: Requires `agy` binary
- ❌ Tavily/Exa: Require API keys

### Fix for X Search
```powershell
# Install grok CLI
curl -fsSL https://x.ai/cli/install.sh | bash
# Then login
grok auth
```

---

## 5. Disabled Tools (功能短板)

### Disabled but Available
| Tool | Status | Reason | Fix to Enable |
|------|--------|--------|---------------|
| tool-bash | DISABLED | Bash sandbox disabled | Set `bash-sandbox` to enabled |
| bash-sandbox | DISABLED | Windows environment | Enable if needed |
| tool-subagent | DISABLED | Not needed | `dshpm enable tool-subagent` |
| tool-subagent-control | DISABLED | Not needed | `dshpm enable tool-subagent-control` |
| tool-subagent-list-agents | DISABLED | Not needed | `dshpm enable tool-subagent-list-agents` |
| tool-workflow | DISABLED | Not needed | `dshpm enable tool-workflow` |
| tool-ralph | DISABLED | Not needed | `dshpm enable tool-ralph` |
| tool-str-replace-editor | DISABLED | Not needed | `dshpm enable tool-str-replace-editor` |
| tool-todo | DISABLED | Not needed | `dshpm enable tool-todo` |
| tool-goal | DISABLED | Not needed | `dshpm enable tool-goal` |
| skill-badge | DISABLED | Not needed | `dshpm enable skill-badge` |
| plan-mode | DISABLED | Not needed | `dshpm enable plan-mode` |
| compaction-basic | DISABLED | Not needed | `dshpm enable compaction-basic` |
| command-compact | DISABLED | Not needed | `dshpm enable command-compact` |
| agent-instructions | DISABLED | Not needed | `dshpm enable agent-instructions` |
| ui-settings-plugin-inventory | DISABLED | Not needed | `dshpm enable ui-settings-plugin-inventory` |
| hmr entry | DISABLED | Hot reload | `dshpm enable hmr entry` |

---

## 6. Workspace (Empty)

### Current State
- **Path**: `C:\Users\Administrator\Desktop\桌面端`
- **Files**: 0 (empty)
- **Issue**: No project files to work with

### Recommendation
Create a project structure or clone a repository to have a meaningful workspace.

---

## 7. dsh-recall Plugin

### Current State
- **Status**: ENABLED
- **Database**: `~/.dsh/storages/session-search.db` (NOT CREATED YET)
- **Functionality**: Full-text session search (opt-in)

### Fix Required
The database will be created on first search. No action needed unless you want to pre-create it:
```powershell
New-Item -ItemType Directory -Force -Path "C:\Users\Administrator\.dsh\storages"
```

---

## 8. Temporary Files Cleanup

### Current State
- **Tmp packages in node_modules**: 6 directories (commander_tmp_1404, dsh-myrules_tmp_41252, etc.)
- **Tmp files in profile root**: 6 empty files (_tmp_*)

### Note
These are recreated by the DSH system during operation. They do not affect functionality but clutter the directory.

---

## 9. dsh-capabilities Plugin

### Current State
- **Status**: ENABLED
- **Canvas**: Empty (html: "", title: "")
- **Debt**: Empty (items: [])
- **Notifications**: Empty (items: [])

### Functionality
Provides project-structure overview and notes knowledge base to the web browser.

---

## 10. Skills Available

### Current Skills (2)
1. **cordis-plugin-development** - Create, modify, debug Cordis plugins
2. **editing-cordis-compositions** - Validate Cordis compositions

### Missing Skills
- Filesystem operations skill (not registered)
- Browser automation skill (depends on extension connection)

---

## Priority Fix List

### High Priority
1. [ ] Install browser extension and connect to bridge
2. [ ] Start DSH web GUI on port 3080
3. [ ] Install MCP servers (agent-reach, glm-vision)

### Medium Priority
4. [ ] Enable useful disabled tools (tool-todo, tool-goal, tool-str-replace-editor)
5. [ ] Install grok-cli for X search
6. [ ] Create workspace project structure

### Low Priority
7. [ ] Clean up temporary files
8. [ ] Enable HMR for development
9. [ ] Pre-create session search database

---

## Quick Fix Commands

```powershell
# 1. Install browser extension (manual - see above)
# 2. Start web GUI
cd "C:\Users\Administrator\Desktop\buok\deepseek-harness"
pnpm run dev:web

# 3. Enable useful tools
cd "C:\Users\Administrator\.dsh\profiles\web"
dshpm enable tool-todo
dshpm enable tool-goal
dshpm enable tool-str-replace-editor
dshpm enable hmr entry

# 4. Create workspace structure
mkdir "C:\Users\Administrator\Desktop\桌面端\src"
mkdir "C:\Users\Administrator\Desktop\桌面端\tools"
```
