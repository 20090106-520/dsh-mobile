# Node.js 0xc0000142 错误修复指南

## 错误说明
0xc0000142 错误表示应用程序无法正确初始化，通常与 DLL 注册问题或系统文件损坏有关。

## 快速修复步骤

### 方法 1: 运行修复脚本（推荐）
```powershell
# 以管理员身份运行 PowerShell
# 右键点击 PowerShell，选择"以管理员身份运行"
# 然后执行:
Set-ExecutionPolicy Bypass -Scope Process -Force
cd "C:\Users\Administrator\Desktop\桌面端"
.\fix-node-0xc0000142.ps1
```

### 方法 2: 手动修复系统文件
```powershell
# 以管理员身份运行以下命令
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
```

### 方法 3: 重新注册 DLL
```powershell
# 以管理员身份运行
regsvr32 /s C:\Windows\System32\ucrtbase.dll
regsvr32 /s C:\Windows\System32\vcruntime140.dll
regsvr32 /s C:\Windows\System32\vcruntime140_1.dll
```

### 方法 4: 重新安装 Node.js
1. 卸载当前 Node.js:
   - 控制面板 -> 程序和功能 -> 卸载 Node.js
2. 删除残留文件夹:
   - C:\Program Files\nodejs
   - C:\tools\node22
   - %APPDATA%\npm
   - %APPDATA%\npm-cache
3. 重启计算机
4. 下载最新 LTS 版本: https://nodejs.org/dist/v22.15.0/node-v22.15.0-x64.msi
5. 运行安装程序

### 方法 5: 检查杀毒软件
某些杀毒软件可能拦截 node.exe。尝试:
1. 暂时禁用杀毒软件
2. 将 Node.js 目录添加到白名单
3. 重新运行 node.exe

## 验证修复
修复后，打开新的 PowerShell 窗口运行:
```powershell
node --version
npm --version
pnpm --version
```

如果都返回版本号，说明修复成功。
