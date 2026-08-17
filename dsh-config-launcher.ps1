# DSH 配置修改启动器
# 此脚本会以管理员权限运行配置修改

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   DSH 配置修改启动器" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查当前权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin) {
    Write-Host "[权限] 已以管理员身份运行" -ForegroundColor Green
    Write-Host ""
    
    # 执行配置修改
    $configPath = "C:\Users\Administrator\.dsh\profiles\web\cordis.patch.yml"
    
    # 备份
    $backupPath = "$configPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $configPath $backupPath -Force
    Write-Host "[1] 备份已创建: $backupPath" -ForegroundColor Green
    
    # 读取当前配置
    $content = Get-Content $configPath -Raw
    
    # 检查是否已添加
    if ($content -match 'recall-settings') {
        Write-Host "[2] 记忆通知设置已存在，跳过" -ForegroundColor Yellow
    } else {
        # 添加配置
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
        $newContent = $content.TrimEnd() + $newConfig
        Set-Content $configPath -Value $newContent -Encoding UTF8
        Write-Host "[2] 记忆通知设置已添加" -ForegroundColor Green
    }
    
    # 创建 UI 布局配置
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
    Write-Host "[3] UI 布局配置已创建: $uiConfigPath" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "   配置完成！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "下一步: 重启 DSH Web GUI" -ForegroundColor Yellow
    Write-Host "备份位置: $backupPath" -ForegroundColor Gray
} else {
    Write-Host "[错误] 当前不是管理员权限" -ForegroundColor Red
    Write-Host ""
    Write-Host "请右键点击 PowerShell，选择'以管理员身份运行'" -ForegroundColor Yellow
    Write-Host "然后执行:" -ForegroundColor Gray
    Write-Host "  cd 'C:\Users\Administrator\Desktop\桌面端'" -ForegroundColor White
    Write-Host "  .\dsh-config-launcher.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "或者双击此脚本，系统会提示您提升权限" -ForegroundColor Gray
}

pause
