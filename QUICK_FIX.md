# Node.js 0xc0000142 快速修复指南

## 问题症状
- 运行 node.exe 时报错: 应用程序无法正常启动 (0xc0000142)
- 错误代码: 0xc0000142

## 根本原因
1. DLL 注册问题
2. Windows 系统文件损坏
3. Node.js 安装冲突（多个安装位置）
4. PATH 环境变量重复

## 快速修复（推荐）

### 方法 1: 运行修复脚本（一键修复）
```powershell
# 1. 以管理员身份打开 PowerShell
# 右键点击 PowerShell -> 以管理员身份运行

# 2. 执行修复脚本
cd "C:\Users\Administrator\Desktop\桌面端"
.\fix-node-0xc0000142.ps1

# 3. 重启计算机
```

### 方法 2: 手动修复步骤

#### 步骤 1: 清理 PATH 环境变量
1. 右键"此电脑" -> 属性 -> 高级系统设置
2. 点击"环境变量"
3. 在"系统变量"中找到 `Path`
4. 删除重复的 Node.js 路径（保留一个即可）
5. 点击确定保存

#### 步骤 2: 清理 npm 缓存
```powershell
npm cache clean --force
```

#### 步骤 3: 修复系统文件
```powershell
# 以管理员身份运行
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
```

#### 步骤 4: 重新注册 DLL
```powershell
# 以管理员身份运行
regsvr32 /s C:\Windows\System32\ucrtbase.dll
regsvr32 /s C:\Windows\System32\vcruntime140.dll
regsvr32 /s C:\Windows\System32\vcruntime140_1.dll
```

### 方法 3: 重新安装 Node.js（最终方案）

#### 1. 卸载现有安装
- 控制面板 -> 程序和功能
- 卸载所有 Node.js 相关项目
- 卸载 Microsoft Visual C++ Redistributable (所有版本)

#### 2. 清理残留文件
```powershell
# 删除以下文件夹（如果存在）
Remove-Item "C:\Program Files\nodejs" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\tools\node22" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\npm" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\npm-cache" -Recurse -Force -ErrorAction SilentlyContinue
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

## 验证修复成功
修复后，打开**新的** PowerShell 窗口运行:
```powershell
node --version
npm --version
pnpm --version
```

如果都返回版本号，说明修复成功。

## 常见问题

### Q: 修复后仍然报错怎么办？
A: 尝试方法 3（重新安装），这是最彻底的解决方案。

### Q: 是否需要备份现有项目？
A: 重新安装 Node.js 不会影响你的项目代码，但建议备份 `.npmrc` 和全局安装的包列表:
```powershell
npm list -g --depth=0 > ~/npm-packages.txt
```

### Q: 为什么会有多个 Node.js 安装？
A: 可能是通过不同方式安装的（官方安装包、nvm、手动下载等）。建议只保留一个安装。

## 相关文件
- 修复脚本: `fix-node-0xc0000142.ps1`
- 详细指南: `FIX_GUIDE.md`
- 诊断报告: `DIAGNOSTIC_REPORT.md`
