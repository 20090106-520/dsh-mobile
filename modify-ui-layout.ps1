# DSH Web GUI UI 布局修改脚本
# 将项目列表放到新对话旁边

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   DSH UI 布局修改工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[错误] 请以管理员身份运行此脚本！" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "[权限] 管理员权限: 已获取" -ForegroundColor Green
Write-Host ""

# UI 布局配置
$uiConfig = @{
    conversations = @{
        layout = "horizontal"  # horizontal | vertical
        position = "left"      # left | right
        width = "280px"
    }
    projectList = @{
        position = "sidebar"   # sidebar | panel | embedded
        expandable = $true
        defaultExpanded = $false
    }
    recallNotifications = @{
        position = "settings"  # settings | sidebar | modal
        enabled = $true
    }
}

# 保存配置
$configPath = "C:\Users\Administrator\.dsh\profiles\web\ui-layout.json"
$uiConfig | ConvertTo-Json -Depth 3 | Set-Content $configPath -Encoding UTF8
Write-Host "UI 布局配置已保存: $configPath" -ForegroundColor Green
Write-Host ""

# 创建配置说明
$说明 = @"
UI 布局配置说明:

1. 对话列表布局 (conversations):
   - layout: 布局方式 (horizontal 水平 | vertical 垂直)
   - position: 位置 (left 左侧 | right 右侧)
   - width: 宽度 (默认 280px)

2. 项目列表位置 (projectList):
   - position: 位置 (sidebar 侧边栏 | panel 面板 | embedded 嵌入)
   - expandable: 是否可折叠
   - defaultExpanded: 默认展开状态

3. 记忆通知位置 (recallNotifications):
   - position: 通知位置 (settings 设置面板 | sidebar 侧边栏 | modal 模态框)
   - enabled: 是否启用

使用方法:
  1. 编辑 C:\Users\Administrator\.dsh\profiles\web\ui-layout.json
  2. 修改配置值
  3. 重启 DSH Web GUI
"@

Set-Content (Join-Path $ws "UI_LAYOUT_README.md") -Value $说明 -Encoding UTF8
Write-Host "UI 布局说明已创建: UI_LAYOUT_README.md" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
