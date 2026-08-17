# Node.js 0xc0000142 用户级修复脚本
# 无需管理员权限即可运行部分修复

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Node.js 用户级修复" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Node.js 安装
Write-Host "[1] 检查 Node.js 安装..." -ForegroundColor Yellow
$nodeExe = "C:\Program Files\nodejs\node.exe"
if (Test-Path $nodeExe) {
    $file = Get-Item $nodeExe
    Write-Host "  路径: $nodeExe" -ForegroundColor Green
    Write-Host "  大小: $([math]::Round($file.Length/1MB, 2)) MB" -ForegroundColor Green
    Write-Host "  修改时间: $($file.LastWriteTime)" -ForegroundColor Green
} else {
    Write-Host "  错误: node.exe 不存在！" -ForegroundColor Red
    Write-Host "  请重新安装 Node.js: https://nodejs.org" -ForegroundColor Yellow
    pause
    exit 1
}

# 清理用户级缓存
Write-Host ""
Write-Host "[2] 清理用户缓存..." -ForegroundColor Yellow

$paths = @(
    "$env:APPDATA\npm-cache",
    "$env:APPDATA\npm",
    "$env:LOCALAPPDATA\npm-cache",
    "$env:TEMP\node*"
)

foreach ($p in $paths) {
    if (Test-Path $p) {
        $size = (Get-ChildItem $p -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        Write-Host "  清理: $p ($([math]::Round($size/1MB, 2)) MB)" -ForegroundColor Cyan
        Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
    }
}
Write-Host "  缓存清理完成" -ForegroundColor Green

# 测试 Node.js
Write-Host ""
Write-Host "[3] 测试 Node.js..." -ForegroundColor Yellow

# 方法 1: 直接调用
Write-Host "  直接调用..." -ForegroundColor Gray
$direct = & $nodeExe --version 2>&1
if ($direct) {
    Write-Host "  node --version: $direct" -ForegroundColor Green
} else {
    Write-Host "  node --version: 无输出" -ForegroundColor Red
}

# 方法 2: 通过 cmd
Write-Host "  通过 cmd..." -ForegroundColor Gray
$cmd = cmd /c "`"$nodeExe`" --version" 2>&1
if ($cmd) {
    Write-Host "  cmd 输出: $cmd" -ForegroundColor Green
}

# 方法 3: 创建批处理文件运行
Write-Host ""
Write-Host "[4] 创建启动脚本..." -ForegroundColor Yellow
$batContent = "@echo off`r`n$nodeExe %*"
$batPath = "$ws\run-node.bat"
Set-Content -Path $batPath -Value $batContent -Encoding ASCII
Write-Host "  已创建: $batPath" -ForegroundColor Green
Write-Host "  使用方法: .\run-node.bat --version" -ForegroundColor Gray

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   修复完成" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "如果仍然无法运行，请尝试:" -ForegroundColor Yellow
Write-Host "  1. 重启计算机" -ForegroundColor Gray
Write-Host "  2. 以管理员身份运行: .\complete-fix-node.ps1" -ForegroundColor Gray
Write-Host "  3. 重新安装 Node.js" -ForegroundColor Gray
Write-Host ""
pause
