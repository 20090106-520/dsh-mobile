# DSH 一键配置脚本
# 一键完成所有配置修改

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   DSH 一键配置工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[错误] 请以管理员身份运行此脚本！" -ForegroundColor Red
    Write-Host ""
    Write-Host "操作步骤:" -ForegroundColor Yellow
    Write-Host "  1. 右键点击 PowerShell" -ForegroundColor Gray
    Write-Host "  2. 选择'以管理员身份运行'" -ForegroundColor Gray
    Write-Host "  3. 执行: cd 'C:\Users\Administrator\Desktop\桌面端'; .\one-click-setup.ps1" -ForegroundColor Gray
    pause
    exit 1
}

Write-Host "[权限] 管理员权限: 已获取" -ForegroundColor Green
Write-Host ""

# 步骤 1: 修改 cordis.patch.yml
Write-Host "[步骤 1/3] 修改 cordis.patch.yml..." -ForegroundColor Yellow
$configPath = "C:\Users\Administrator\.dsh\profiles\web\cordis.patch.yml"
$backupPath = "$configPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Copy-Item $configPath $backupPath -Force
Write-Host "  备份已创建: $backupPath" -ForegroundColor Green

$currentContent = Get-Content $configPath -Raw
if ($currentContent -notmatch 'recall-settings') {
    $newConfig = @"

# 记忆通知设置
- insert:
    - id: recall-settings
      name: 'dsh-recall-settings'
      config:
        enabled: true
        notifyOnRecall: true
        notifyPosition: settings
        showInSidebar: false
"@
    $newContent = $currentContent.TrimEnd() + $newConfig
    Set-Content $configPath -Value $newContent -Encoding UTF8
    Write-Host "  记忆通知设置已添加" -ForegroundColor Green
} else {
    Write-Host "  记忆通知设置已存在，跳过" -ForegroundColor Yellow
}

# 步骤 2: 创建 UI 布局配置
Write-Host ""
Write-Host "[步骤 2/3] 创建 UI 布局配置..." -ForegroundColor Yellow
$uiConfigPath = "C:\Users\Administrator\.dsh\profiles\web\ui-layout.json"
$uiConfig = @{
    conversations = @{
        layout = "horizontal"
        position = "left"
        width = "280px"
    }
    projectList = @{
        position = "sidebar"
        expandable = $true
        defaultExpanded = $false
    }
    recallNotifications = @{
        position = "settings"
        enabled = $true
    }
}
$uiConfig | ConvertTo-Json -Depth 3 | Set-Content $uiConfigPath -Encoding UTF8
Write-Host "  UI 布局配置已创建: $uiConfigPath" -ForegroundColor Green

# 步骤 3: 验证配置
Write-Host ""
Write-Host "[步骤 3/3] 验证配置..." -ForegroundColor Yellow
$verifyContent = Get-Content $configPath -Raw
if ($verifyContent -match 'recall-settings') {
    Write-Host "  ✓ 记忆通知设置配置正确" -ForegroundColor Green
} else {
    Write-Host "  ✗ 配置验证失败，请手动检查" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作:" -ForegroundColor Yellow
Write-Host "  1. 重启 DSH Web GUI" -ForegroundColor Gray
Write-Host "  2. 打开设置面板" -ForegroundColor Gray
Write-Host "  3. 找到'记忆通知设置'" -ForegroundColor Gray
Write-Host "  4. 配置通知行为" -ForegroundColor Gray
Write-Host ""
Write-Host "配置位置:" -ForegroundColor Cyan
Write-Host "  • cordis.patch.yml: $configPath" -ForegroundColor Gray
Write-Host "  • ui-layout.json: $uiConfigPath" -ForegroundColor Gray
Write-Host "  • 备份文件: $backupPath" -ForegroundColor Gray
Write-Host ""
Write-Host "如需恢复:" -ForegroundColor Yellow
Write-Host "  Copy-Item '$backupPath' '$configPath' -Force" -ForegroundColor White
Write-Host ""
pause
