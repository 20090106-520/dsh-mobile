# Node.js 临时 workaround 脚本
# 绕过权限问题直接运行 Node.js

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Node.js 临时运行脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$nodeExe = "C:\Program Files\nodejs\node.exe"

if (-not (Test-Path $nodeExe)) {
    Write-Host "错误: node.exe 不存在！" -ForegroundColor Red
    Write-Host "请重新安装 Node.js: https://nodejs.org" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "Node.js 路径: $nodeExe" -ForegroundColor Cyan
Write-Host "文件大小: $([math]::Round((Get-Item $nodeExe).Length/1MB, 2)) MB" -ForegroundColor Cyan
Write-Host ""

# 尝试不同的运行方式
Write-Host "尝试运行方式..." -ForegroundColor Yellow

# 方式 1: 直接运行
Write-Host "[方式 1] 直接运行 node --version" -ForegroundColor Cyan
try {
    $result = & $nodeExe --version
    if ($result) {
        Write-Host "  成功: $result" -ForegroundColor Green
    }
} catch {
    Write-Host "  失败: $_" -ForegroundColor Red
}

# 方式 2: 通过 cmd
Write-Host ""
Write-Host "[方式 2] 通过 cmd 运行" -ForegroundColor Cyan
$cmdResult = cmd /c "`"$nodeExe`" --version" 2>&1
Write-Host "  输出: $cmdResult"

# 方式 3: 创建快捷方式运行
Write-Host ""
Write-Host "[方式 3] 创建桌面快捷方式" -ForegroundColor Cyan
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Node.js.lnk")
$Shortcut.TargetPath = $nodeExe
$Shortcut.WorkingDirectory = "C:\Program Files\nodejs"
$Shortcut.Description = "Node.js Command Prompt"
$Shortcut.Save()
Write-Host "  快捷方式已创建到桌面" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   说明" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "如果以上方式都失败，请尝试:" -ForegroundColor Yellow
Write-Host "  1. 以管理员身份运行 PowerShell" -ForegroundColor Gray
Write-Host "  2. 执行: .\complete-fix-node.ps1" -ForegroundColor White
Write-Host "  3. 重启计算机" -ForegroundColor Gray
Write-Host ""
Write-Host "或者手动修复:" -ForegroundColor Yellow
Write-Host "  1. 打开 '此电脑' 右键 -> 属性 -> 高级系统设置" -ForegroundColor Gray
Write-Host "  2. 点击 '环境变量'" -ForegroundColor Gray
Write-Host "  3. 在 '系统变量' 中找到 'Path'，点击编辑" -ForegroundColor Gray
Write-Host "  4. 确保只有以下路径（删除其他重复的）:" -ForegroundColor Gray
Write-Host "     C:\Program Files\nodejs" -ForegroundColor White
Write-Host "  5. 点击确定保存" -ForegroundColor Gray
Write-Host "  6. 重启计算机" -ForegroundColor Gray
Write-Host ""
pause
