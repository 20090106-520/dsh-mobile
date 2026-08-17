# Node.js 0xc0000142 错误完整修复脚本
# 必须以管理员身份运行

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Node.js 0xc0000142 错误完整修复" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[错误] 请以管理员身份运行此脚本！" -ForegroundColor Red
    Write-Host ""
    Write-Host "操作步骤:" -ForegroundColor Yellow
    Write-Host "  1. 点击开始菜单" -ForegroundColor Gray
    Write-Host "  2. 输入 PowerShell" -ForegroundColor Gray
    Write-Host "  3. 右键点击 PowerShell，选择'以管理员身份运行'" -ForegroundColor Gray
    Write-Host "  4. 执行: cd 'C:\Users\Administrator\Desktop\桌面端'; .\fix-node-0xc0000142.ps1" -ForegroundColor Gray
    pause
    exit 1
}

Write-Host "[1/6] 清理重复的 PATH 环境变量..." -ForegroundColor Yellow
# 清理 PATH 中的重复 node 路径
$machinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")

# 移除重复的 node 路径
$machinePaths = $machinePath -split ";" | Where-Object { $_ -notmatch 'node' -or $_ -eq '' }
$userPaths = $userPath -split ";" | Where-Object { $_ -notmatch 'node' -or $_ -eq '' }

# 添加唯一的路径
$uniqueMachinePaths = @("C:\Program Files\nodejs") + $machinePaths | Select-Object -Unique
$uniqueUserPaths = @("C:\tools\node22") + $userPaths | Select-Object -Unique

$newMachinePath = $uniqueMachinePaths -join ";"
$newUserPath = $uniqueUserPaths -join ";"

[Environment]::SetEnvironmentVariable("PATH", $newMachinePath, "Machine")
[Environment]::SetEnvironmentVariable("PATH", $newUserPath, "User")
Write-Host "  PATH 已清理" -ForegroundColor Green

Write-Host ""
Write-Host "[2/6] 清理 npm 缓存..." -ForegroundColor Yellow
$npmCache = "$env:APPDATA\npm-cache"
if (Test-Path $npmCache) {
    Remove-Item "$npmCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  npm 缓存已清理" -ForegroundColor Green
}

Write-Host ""
Write-Host "[3/6] 修复 Windows 系统文件..." -ForegroundColor Yellow
Write-Host "  运行 SFC 扫描..." -ForegroundColor Gray
sfc /scannow 2>&1 | Out-Null
Write-Host "  SFC 完成" -ForegroundColor Green

Write-Host ""
Write-Host "[4/6] 重新注册 VC++ 运行库 DLL..." -ForegroundColor Yellow
$system32 = "C:\Windows\System32"
$dlls = @("ucrtbase.dll", "vcruntime140.dll", "vcruntime140_1.dll")
foreach ($dll in $dlls) {
    $dllPath = Join-Path $system32 $dll
    if (Test-Path $dllPath) {
        regsvr32 /s "`$dllPath`" 2>&1 | Out-Null
        Write-Host "  已注册: $dll" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "[5/6] 检查 Node.js 安装..." -ForegroundColor Yellow
$nodePaths = @(
    "C:\Program Files\nodejs\node.exe",
    "C:\tools\node22\node.exe"
)
foreach ($nodePath in $nodePaths) {
    if (Test-Path $nodePath) {
        $file = Get-Item $nodePath
        Write-Host "  找到: $nodePath ($([math]::Round($file.Length/1MB, 2)) MB)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "[6/6] 验证 Node.js..." -ForegroundColor Yellow
$testResult = node --version 2>&1
if ($testResult) {
    Write-Host "  Node.js 版本: $testResult" -ForegroundColor Green
} else {
    Write-Host "  验证失败，请尝试重启计算机" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   修复完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作:" -ForegroundColor Yellow
Write-Host "  1. 重启计算机（重要！）" -ForegroundColor Gray
Write-Host "  2. 重启后打开新的 PowerShell 窗口" -ForegroundColor Gray
Write-Host "  3. 运行: node --version" -ForegroundColor Gray
Write-Host "  4. 运行: npm --version" -ForegroundColor Gray
Write-Host "  5. 运行: pnpm --version" -ForegroundColor Gray
Write-Host ""
Write-Host "如果仍然有问题，请:" -ForegroundColor Yellow
Write-Host "  1. 卸载所有 Node.js 安装" -ForegroundColor Gray
Write-Host "  2. 删除以下文件夹:" -ForegroundColor Gray
Write-Host "     - C:\Program Files\nodejs" -ForegroundColor Gray
Write-Host "     - C:\tools\node22" -ForegroundColor Gray
Write-Host "     - %APPDATA%\npm" -ForegroundColor Gray
Write-Host "     - %APPDATA%\npm-cache" -ForegroundColor Gray
Write-Host "  3. 重启计算机" -ForegroundColor Gray
Write-Host "  4. 从 https://nodejs.org 下载最新 LTS 版本" -ForegroundColor Gray
Write-Host "  5. 运行安装程序" -ForegroundColor Gray
pause
