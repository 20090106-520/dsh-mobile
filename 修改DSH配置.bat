# DSH 配置修改 - 简化版
# 双击运行此脚本

Write-Host "正在修改 DSH 配置..." -ForegroundColor Cyan

# 检查权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host ""
    Write-Host "[错误] 需要管理员权限！" -ForegroundColor Red
    Write-Host ""
    Write-Host "请按以下步骤操作:" -ForegroundColor Yellow
    Write-Host "  1. 右键点击此脚本" -ForegroundColor Gray
    Write-Host "  2. 选择'以管理员身份运行'" -ForegroundColor Gray
    Write-Host ""
    pause
    exit 1
}

# 配置文件路径
$configPath = "C:\Users\Administrator\.dsh\profiles\web\cordis.patch.yml"

# 备份
$backupPath = "$configPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Write-Host "[1] 备份配置..." -ForegroundColor Yellow
Copy-Item $configPath $backupPath -Force
Write-Host "  备份: $backupPath" -ForegroundColor Green

# 读取配置
Write-Host "[2] 读取配置..." -ForegroundColor Yellow
$content = Get-Content $configPath -Raw

# 检查是否已添加
if ($content -match 'recall-settings') {
    Write-Host "  记忆通知设置已存在，跳过" -ForegroundColor Yellow
} else {
    # 添加配置
    Write-Host "[3] 添加记忆通知设置..." -ForegroundColor Yellow
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
    $newContent = $content.TrimEnd() + $newConfig
    Set-Content $configPath -Value $newContent -Encoding UTF8
    Write-Host "  ✓ 已添加记忆通知设置" -ForegroundColor Green
}

# 创建 UI 配置
Write-Host "[4] 创建 UI 布局配置..." -ForegroundColor Yellow
$uiPath = "C:\Users\Administrator\.dsh\profiles\web\ui-layout.json"
$uiConfig = @{
    conversations = @{ layout = "horizontal"; position = "left"; width = "280px" }
    projectList = @{ position = "sidebar"; expandable = $true }
    recallNotifications = @{ position = "settings"; enabled = $true }
}
$uiConfig | ConvertTo-Json -Depth 3 | Set-Content $uiPath -Encoding UTF8
Write-Host "  ✓ 已创建 UI 布局配置" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "下一步:" -ForegroundColor Yellow
Write-Host "  1. 重启 DSH Web GUI" -ForegroundColor Gray
Write-Host "  2. 打开设置面板" -ForegroundColor Gray
Write-Host "  3. 找到'记忆通知设置'" -ForegroundColor Gray
Write-Host ""
Write-Host "备份位置: $backupPath" -ForegroundColor Gray
Write-Host ""
pause
