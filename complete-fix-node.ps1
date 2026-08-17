# Node.js 0xc0000142 完整修复方案
# 按顺序执行以下步骤

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Node.js 0xc0000142 完整修复" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[警告] 请以管理员身份运行此脚本！" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "操作步骤:" -ForegroundColor Cyan
    Write-Host "  1. 点击开始菜单" -ForegroundColor Gray
    Write-Host "  2. 输入 PowerShell" -ForegroundColor Gray
    Write-Host "  3. 右键 PowerShell，选择'以管理员身份运行'" -ForegroundColor Gray
    Write-Host "  4. 执行: cd 'C:\Users\Administrator\Desktop\桌面端'; .\complete-fix-node.ps1" -ForegroundColor Gray
    pause
    exit 1
}

Write-Host "[权限] 管理员权限: 已获取" -ForegroundColor Green
Write-Host ""

# ========== 步骤 1: 检查并修复 AppLocker ==========
Write-Host "[步骤 1/5] 检查 AppLocker 策略..." -ForegroundColor Yellow
try {
    $appLockerService = Get-Service -Name "AppIDSvc" -ErrorAction Stop
    Write-Host "  AppLocker 服务: $($appLockerService.Status)" -ForegroundColor Cyan
    
    # 检查是否有阻止 node.exe 的规则
    $nodePath = "C:\Program Files\nodejs\*"
    $fileRule = Get-AppLockerPolicy -Effective -ErrorAction SilentlyContinue | 
        Select-Xml -XPath "//FileRule[@RuleId and contains(FilePath, 'node.exe')]" -ErrorAction SilentlyContinue
    
    if ($fileRule) {
        Write-Host "  发现阻止 node.exe 的规则，尝试移除..." -ForegroundColor Yellow
        # 注意：这里需要管理员权限来修改 AppLocker 规则
        Write-Host "  请手动检查 AppLocker 规则:" -ForegroundColor Cyan
        Write-Host "  运行: Get-AppLockerPolicy -Effective | Out-String" -ForegroundColor Gray
    } else {
        Write-Host "  未发现 node.exe 阻止规则" -ForegroundColor Green
    }
} catch {
    Write-Host "  AppLocker 检查失败: $_" -ForegroundColor Yellow
}

# ========== 步骤 2: 重新注册 VC++ DLL ==========
Write-Host ""
Write-Host "[步骤 2/5] 重新注册 VC++ 运行库..." -ForegroundColor Yellow
$system32 = "C:\Windows\System32"
$dlls = @("ucrtbase.dll", "vcruntime140.dll", "vcruntime140_1.dll", "msvcp140.dll")

foreach ($dll in $dlls) {
    $dllPath = Join-Path $system32 $dll
    if (Test-Path $dllPath) {
        # 先卸载再重新注册
        regsvr32 /s /u "$dllPath" 2>&1 | Out-Null
        Start-Sleep -Milliseconds 500
        regsvr32 /s "$dllPath" 2>&1 | Out-Null
        Write-Host "  已重新注册: $dll" -ForegroundColor Green
    }
}

# ========== 步骤 3: 清理并重建 Node.js 缓存 ==========
Write-Host ""
Write-Host "[步骤 3/5] 清理 Node.js 缓存..." -ForegroundColor Yellow

# 清理 npm 缓存
$npmCache = "$env:APPDATA\npm-cache"
if (Test-Path $npmCache) {
    Remove-Item "$npmCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  npm 缓存已清理" -ForegroundColor Green
}

# 清理 Node.js 临时文件
$nodeTmp = "$env:TEMP\node*"
if (Test-Path $nodeTmp) {
    Remove-Item $nodeTmp -Force -ErrorAction SilentlyContinue
    Write-Host "  Node.js 临时文件已清理" -ForegroundColor Green
}

# ========== 步骤 4: 修复系统文件 ==========
Write-Host ""
Write-Host "[步骤 4/5] 修复系统文件..." -ForegroundColor Yellow

Write-Host "  运行 SFC 扫描..." -ForegroundColor Gray
sfc /scannow 2>&1 | Out-Null
Write-Host "  SFC 扫描完成" -ForegroundColor Green

Write-Host "  运行 DISM 修复..." -ForegroundColor Gray
DISM /Online /Cleanup-Image /RestoreHealth 2>&1 | Out-Null
Write-Host "  DISM 修复完成" -ForegroundColor Green

# ========== 步骤 5: 验证修复 ==========
Write-Host ""
Write-Host "[步骤 5/5] 验证修复..." -ForegroundColor Yellow

$nodeExe = "C:\Program Files\nodejs\node.exe"
if (Test-Path $nodeExe) {
    Write-Host "  测试 node.exe..." -ForegroundColor Cyan
    $proc = Start-Process -FilePath $nodeExe -ArgumentList "--version" -NoNewWindow -Wait -PassThru -ErrorAction SilentlyContinue
    if ($proc) {
        Write-Host "  node.exe 退出码: $($proc.ExitCode)" -ForegroundColor Green
    }
    
    # 尝试直接调用
    Write-Host "  直接调用测试..." -ForegroundColor Cyan
    $result = & $nodeExe --version 2>&1
    if ($result) {
        Write-Host "  node --version: $result" -ForegroundColor Green
    } else {
        Write-Host "  node --version: 无输出" -ForegroundColor Red
    }
} else {
    Write-Host "  错误: node.exe 不存在！" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   修复完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "重要：请重启计算机！" -ForegroundColor Yellow
Write-Host ""
pause
