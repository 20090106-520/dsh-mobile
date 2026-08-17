# DSH 配置修改脚本
# 此脚本会安全地修改 cordis.patch.yml
# 使用前请确保以管理员身份运行

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   DSH 配置安全修改工具" -ForegroundColor Cyan
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
    Write-Host "  3. 右键 PowerShell，选择'以管理员身份运行'" -ForegroundColor Gray
    Write-Host "  4. 执行: cd 'C:\Users\Administrator\Desktop\桌面端'; .\modify-dsh-config.ps1" -ForegroundColor Gray
    pause
    exit 1
}

Write-Host "[权限] 管理员权限: 已获取" -ForegroundColor Green
Write-Host ""

# 配置文件路径
$configPath = "C:\Users\Administrator\.dsh\profiles\web\cordis.patch.yml"

# 检查配置文件是否存在
if (-not (Test-Path $configPath)) {
    Write-Host "[错误] 配置文件不存在: $configPath" -ForegroundColor Red
    pause
    exit 1
}

# 备份配置文件
$backupPath = "$configPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Write-Host "[1/4] 备份配置文件..." -ForegroundColor Yellow
Copy-Item $configPath $backupPath -Force
Write-Host "  备份已创建: $backupPath" -ForegroundColor Green

# 读取当前配置
Write-Host ""
Write-Host "[2/4] 读取当前配置..." -ForegroundColor Yellow
$currentContent = Get-Content $configPath -Raw
Write-Host "  当前配置大小: $([math]::Round($currentContent.Length/1KB, 2)) KB" -ForegroundColor Green

# 检查是否已经添加了记忆通知设置
if ($currentContent -match 'recall-settings') {
    Write-Host ""
    Write-Host "[警告] 记忆通知设置已存在，跳过添加" -ForegroundColor Yellow
} else {
    # 添加记忆通知配置
    Write-Host ""
    Write-Host "[3/4] 添加记忆通知设置..." -ForegroundColor Yellow
    
    $newConfig = @"

# 记忆通知设置 - 添加到设置面板
- insert:
    - id: recall-settings
      name: 'dsh-recall-settings'
      config:
        enabled: true
        notifyOnRecall: true
        notifyPosition: settings
        showInSidebar: false
        notifySound: true
        notifyDuration: 5000
"@
    
    # 将新配置添加到文件末尾
    $newContent = $currentContent.TrimEnd() + $newConfig
    
    # 保存修改
    Set-Content $configPath -Value $newContent -Encoding UTF8
    Write-Host "  记忆通知设置已添加" -ForegroundColor Green
}

# 验证修改
Write-Host ""
Write-Host "[4/4] 验证修改..." -ForegroundColor Yellow
$verifyContent = Get-Content $configPath -Raw
if ($verifyContent -match 'recall-settings') {
    Write-Host "  验证成功: 记忆通知设置已添加" -ForegroundColor Green
} else {
    Write-Host "  验证失败: 请手动检查配置文件" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   修改完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作:" -ForegroundColor Yellow
Write-Host "  1. 重启 DSH Web GUI" -ForegroundColor Gray
Write-Host "  2. 打开设置面板，找到'记忆通知设置'" -ForegroundColor Gray
Write-Host "  3. 配置通知行为" -ForegroundColor Gray
Write-Host ""
Write-Host "如果需要恢复:" -ForegroundColor Yellow
Write-Host "  运行: Copy-Item '$backupPath' '$configPath' -Force" -ForegroundColor White
Write-Host ""
pause
