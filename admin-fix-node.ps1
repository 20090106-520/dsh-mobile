# Node.js 0xc0000142 管理员修复脚本
# 必须右键"以管理员身份运行"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Node.js 0xc0000142 管理员修复" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 验证管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[错误] 必须以管理员身份运行此脚本！" -ForegroundColor Red
    Write-Host ""
    Write-Host "操作步骤:" -ForegroundColor Yellow
    Write-Host "  1. 点击开始菜单" -ForegroundColor Gray
    Write-Host "  2. 输入 PowerShell" -ForegroundColor Gray
    Write-Host "  3. 右键点击 PowerShell，选择'以管理员身份运行'" -ForegroundColor Gray
    Write-Host "  4. 执行: cd 'C:\Users\Administrator\Desktop\桌面端'; .\admin-fix-node.ps1" -ForegroundColor Gray
    pause
    exit 1
}

Write-Host "[权限检查] 管理员权限: 已获取" -ForegroundColor Green
Write-Host ""

# 步骤 1: 清理 PATH 环境变量
Write-Host "[1/6] 清理 PATH 环境变量..." -ForegroundColor Yellow
$machinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")

# 清理所有 Node.js 路径
$cleanMachinePaths = ($machinePath -split ";") | Where-Object { $_ -ne '' -and $_ -notmatch 'node' }
$cleanUserPaths = ($userPath -split ";") | Where-Object { $_ -ne '' -and $_ -notmatch 'node' }

# 只添加一个 Node.js 路径
$finalMachinePaths = @("C:\Program Files\nodejs") + $cleanMachinePaths | Select-Object -Unique
$finalUserPaths = $cleanUserPaths | Select-Object -Unique

$newMachinePath = $finalMachinePaths -join ";"
$newUserPath = $finalUserPaths -join ";"

[Environment]::SetEnvironmentVariable("PATH", $newMachinePath, "Machine")
[Environment]::SetEnvironmentVariable("PATH", $newUserPath, "User")

Write-Host "  PATH 已清理，只保留: C:\Program Files\nodejs" -ForegroundColor Green

# 步骤 2: 清理 npm 缓存
Write-Host ""
Write-Host "[2/6] 清理 npm 缓存..." -ForegroundColor Yellow
$npmPaths = @(
    "$env:APPDATA\npm-cache",
    "$env:APPDATA\npm",
    "$env:LOCALAPPDATA\npm-cache",
    "$env:LOCALAPPDATA\npm"
)
foreach ($p in $npmPaths) {
    if (Test-Path $p) {
        Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  已清理: $p" -ForegroundColor Green
    }
}

# 步骤 3: 修复系统文件
Write-Host ""
Write-Host "[3/6] 修复系统文件..." -ForegroundColor Yellow
Write-Host "  运行 SFC 扫描..." -ForegroundColor Gray
sfc /scannow 2>&1 | Out-Null
Write-Host "  SFC 扫描完成" -ForegroundColor Green

Write-Host "  运行 DISM 修复..." -ForegroundColor Gray
DISM /Online /Cleanup-Image /RestoreHealth 2>&1 | Out-Null
Write-Host "  DISM 修复完成" -ForegroundColor Green

# 步骤 4: 重新注册 DLL
Write-Host ""
Write-Host "[4/6] 重新注册 VC++ 运行库..." -ForegroundColor Yellow
$system32 = "C:\Windows\System32"
$dlls = @("ucrtbase.dll", "vcruntime140.dll", "vcruntime140_1.dll", "msvcp140.dll")
foreach ($dll in $dlls) {
    $dllPath = Join-Path $system32 $dll
    if (Test-Path $dllPath) {
        regsvr32 /s "$dllPath" 2>&1 | Out-Null
        Write-Host "  已注册: $dll" -ForegroundColor Green
    }
}

# 步骤 5: 检查 Node.js 安装
Write-Host ""
Write-Host "[5/6] 检查 Node.js 安装..." -ForegroundColor Yellow
$nodeExe = "C:\Program Files\nodejs\node.exe"
if (Test-Path $nodeExe) {
    $file = Get-Item $nodeExe
    Write-Host "  找到: $nodeExe ($([math]::Round($file.Length/1MB, 2)) MB)" -ForegroundColor Green
} else {
    Write-Host "  错误: node.exe 不存在！" -ForegroundColor Red
    Write-Host "  需要重新安装 Node.js" -ForegroundColor Yellow
}

# 步骤 6: 验证
Write-Host ""
Write-Host "[6/6] 验证 Node.js..." -ForegroundColor Yellow
$env:PATH = [Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [Environment]::GetEnvironmentVariable("PATH", "User")

$nodeVer = node --version 2>&1
if ($nodeVer) {
    Write-Host "  node --version: $nodeVer" -ForegroundColor Green
} else {
    Write-Host "  node --version: 失败" -ForegroundColor Red
}

$npmVer = npm --version 2>&1
if ($npmVer) {
    Write-Host "  npm --version: $npmVer" -ForegroundColor Green
} else {
    Write-Host "  npm --version: 失败" -ForegroundColor Red
}

$pnpmVer = pnpm --version 2>&1
if ($pnpmVer) {
    Write-Host "  pnpm --version: $pnpmVer" -ForegroundColor Green
} else {
    Write-Host "  pnpm --version: 失败" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   修复完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "重要：请重启计算机以使更改生效！" -ForegroundColor Yellow
Write-Host ""
pause
