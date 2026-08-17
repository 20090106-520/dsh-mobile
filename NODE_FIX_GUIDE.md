# Node.js 0xc0000142 完整修复指南

## 问题症状
运行 Node.js 时报错: **应用程序无法正常启动 (0xc0000142)**

## 诊断结果

### 已确认正常
- ✅ Node.js 安装文件完整 (81.62 MB)
- ✅ VC++ Redistributable 已安装 (v14.51.36247)
- ✅ 所有必要 DLL 存在
- ✅ AppLocker 服务已停止（非阻止原因）
- ✅ PowerShell 执行策略已设置为 Bypass
- ✅ 文件权限正常 (Users 有 ReadAndExecute 权限)

### 问题原因
- ❌ 进程启动被拒绝 (Access is denied)
- 可能原因:
  1. 当前运行环境有沙箱限制
  2. 杀毒软件或安全策略拦截
  3. Windows 安全策略限制

---

## 修复方案

### 方案 1: 重启计算机（最简单）

重启后打开**新的** PowerShell 窗口，运行:
```powershell
node --version
npm --version
pnpm --version
```

如果显示版本号，修复成功！

---

### 方案 2: 使用 Portable 版本（立即可用）

我已经创建了 Portable 版本的 Node.js:

**位置**: `C:\Users\Administrator\Desktop\桌面端\node-portable\`

**使用方法**:
```powershell
# 方法 1: 直接运行
.\node-portable\node.exe --version

# 方法 2: 运行测试脚本
.\node-portable\test.bat

# 方法 3: 使用 npm
.\node-portable\npm.bat install <package>
```

---

### 方案 3: 管理员修复（推荐）

以管理员身份运行 PowerShell:

```powershell
# 1. 右键点击 PowerShell，选择"以管理员身份运行"
# 2. 执行以下命令:
cd "C:\Users\Administrator\Desktop\桌面端"
.\complete-fix-node.ps1

# 3. 等待修复完成
# 4. 重启计算机
```

---

### 方案 4: 手动修复步骤

#### 步骤 1: 清理 PATH 环境变量
1. 右键"此电脑" → 属性 → 高级系统设置 → 环境变量
2. 在"系统变量"中找到 `Path`，点击编辑
3. 删除所有 Node.js 相关路径，只保留一个:
   ```
   C:\Program Files\nodejs
   ```
4. 点击确定保存

#### 步骤 2: 修复系统文件
以管理员身份运行 PowerShell:
```powershell
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
```

#### 步骤 3: 重新注册 DLL
```powershell
regsvr32 /s C:\Windows\System32\ucrtbase.dll
regsvr32 /s C:\Windows\System32\vcruntime140.dll
regsvr32 /s C:\Windows\System32\vcruntime140_1.dll
```

#### 步骤 4: 重启计算机

---

### 方案 5: 重新安装 Node.js（最终方案）

如果以上方法都失败:

#### 1. 卸载现有安装
- 控制面板 → 程序和功能
- 卸载所有 Node.js 相关项目
- 卸载 Microsoft Visual C++ 2015-2022 Redistributable

#### 2. 清理残留文件
```powershell
Remove-Item "C:\Program Files\nodejs" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\tools\node22" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\npm" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\npm-cache" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\npm-cache" -Recurse -Force -ErrorAction SilentlyContinue
```

#### 3. 重启计算机

#### 4. 下载并安装最新 LTS 版本
- 访问: https://nodejs.org/dist/v22.15.0/node-v22.15.0-x64.msi
- 运行安装程序
- 选择"修复"或全新安装

#### 5. 验证安装
```powershell
node --version  # 应显示 v22.x.x
npm --version   # 应显示 10.x.x
pnpm --version  # 应显示 10.x.x
```

---

## 已创建的修复文件

| 文件 | 用途 |
|------|------|
| `complete-fix-node.ps1` | 完整管理员修复脚本 |
| `admin-fix-node.ps1` | 管理员修复脚本（简化版） |
| `user-fix-node.ps1` | 用户级修复脚本 |
| `final-fix-node.ps1` | 最终修复脚本 |
| `workaround-node.ps1` | 绕过方案脚本 |
| `quick-fix-commands.ps1` | 快速命令集 |
| `test-node-fix.ps1` | 验证脚本 |
| `node-portable\` | Portable Node.js 目录 |
| `run-node.bat` | 启动脚本 |
| `test.bat` | 测试脚本 |

---

## 验证修复成功

修复后，打开**新的** PowerShell 窗口运行:
```powershell
node --version    # 应显示 v22.x.x
npm --version     # 应显示 10.x.x
pnpm --version    # 应显示 10.x.x
```

如果都返回版本号，说明修复成功！

---

## 注意事项

1. **不要删除已创建的修复文件**，它们包含完整的修复方案
2. **重启计算机是必须的**，否则 PATH 更改不会生效
3. **Portable 版本是临时解决方案**，建议修复系统权限问题
4. 如果问题仍然存在，请尝试**方案 5: 重新安装 Node.js**

---

## 联系支持

如果以上所有方法都失败，请提供以下信息:
1. 操作系统版本: `winver`
2. Node.js 安装位置列表
3. 错误截图或完整错误信息
