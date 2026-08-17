# Node.js 修复验证脚本
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Node.js 修复验证" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 测试 node
Write-Host "[1] 测试 node..." -ForegroundColor Yellow
$nodeExe = "C:\Program Files\nodejs\node.exe"
if (Test-Path $nodeExe) {
    Write-Host "  文件存在: $nodeExe" -ForegroundColor Green
    try {
        $ver = & $nodeExe --version 2>&1
        if ($ver) {
            Write-Host "  版本: $ver" -ForegroundColor Green
        } else {
            Write-Host "  版本: 无法获取" -ForegroundColor Red
        }
    } catch {
        Write-Host "  错误: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  错误: node.exe 不存在" -ForegroundColor Red
}

# 测试 npm
Write-Host ""
Write-Host "[2] 测试 npm..." -ForegroundColor Yellow
$npmCmd = "C:\Program Files\nodejs\npm.cmd"
if (Test-Path $npmCmd) {
    Write-Host "  文件存在: $npmCmd" -ForegroundColor Green
    try {
        $ver = & $npmCmd --version 2>&1
        if ($ver) {
            Write-Host "  版本: $ver" -ForegroundColor Green
        } else {
            Write-Host "  版本: 无法获取" -ForegroundColor Red
        }
    } catch {
        Write-Host "  错误: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  错误: npm.cmd 不存在" -ForegroundColor Red
}

# 测试 pnpm
Write-Host ""
Write-Host "[3] 测试 pnpm..." -ForegroundColor Yellow
$pnpmCmd = "C:\Program Files\nodejs\pnpm.CMD"
if (Test-Path $pnpmCmd) {
    Write-Host "  文件存在: $pnpmCmd" -ForegroundColor Green
    try {
        $ver = & $pnpmCmd --version 2>&1
        if ($ver) {
            Write-Host "  版本: $ver" -ForegroundColor Green
        } else {
            Write-Host "  版本: 无法获取" -ForegroundColor Red
        }
    } catch {
        Write-Host "  错误: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  错误: pnpm.CMD 不存在" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   验证完成" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
