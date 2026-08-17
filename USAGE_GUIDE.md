# 记忆通知设置 - 安全安装指南

## 方案 1: 手动添加配置（推荐，最安全）

1. 打开配置文件：
   ```
   C:\Users\Administrator\.dsh\profiles\web\cordis.patch.yml
   ```

2. 在文件末尾添加以下配置：
   ```yaml
   # 记忆通知设置
   - insert:
       - id: recall-settings
         name: 'dsh-recall-settings'
         config:
           enabled: true
           notifyOnRecall: true
           notifyPosition: settings
           showInSidebar: false
   ```

3. 保存文件

4. 重启 DSH Web GUI

## 方案 2: 使用安装脚本

```powershell
# 以管理员身份运行 PowerShell
cd "C:\Users\Administrator\Desktop\桌面端"
.\install-recall-settings.ps1
```

## 方案 3: 创建独立插件

1. 复制插件目录：
   ```powershell
   Copy-Item -Path "C:\Users\Administrator\Desktop\桌面端\dsh-recall-settings" `
              -Destination "C:\Users\Administrator\.dsh\profiles\web\plugins\" `
              -Recurse -Force
   ```

2. 在 cordis.patch.yml 中添加：
   ```yaml
   - insert:
       - id: recall-settings
         name: 'dsh-recall-settings'
   ```

3. 重启 DSH

## 验证安装

重启后，打开 DSH Web GUI：
1. 点击设置图标
2. 找到"记忆通知设置"选项
3. 配置通知行为

## 卸载方法

如果遇到问题，可以：
1. 删除 cordis.patch.yml 中添加的配置
2. 或者恢复备份：
   ```powershell
   Copy-Item "C:\Users\Administrator\.dsh\profiles\web\cordis.patch.yml.backup" `
             "C:\Users\Administrator\.dsh\profiles\web\cordis.patch.yml" -Force
   ```
3. 重启 DSH

## 安全说明

- 此配置仅添加设置项，不修改现有功能
- 配置文件已自动备份
- 可随时恢复备份
- 不影响模型切换和其他功能
