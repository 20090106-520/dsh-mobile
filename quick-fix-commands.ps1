# 快速启动修复（复制粘贴到管理员 PowerShell）
# 复制以下所有命令，粘贴到管理员 PowerShell 中执行

# 1. 清理 PATH
$machinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
$cleanMachinePaths = ($machinePath -split ";") | Where-Object { $_ -ne '' -and $_ -notmatch 'node' }
$cleanUserPaths = ($userPath -split ";") | Where-Object { $_ -ne '' -and $_ -notmatch 'node' }
$finalMachinePaths = @("C:\Program Files\nodejs") + $cleanMachinePaths | Select-Object -Unique
$finalUserPaths = $cleanUserPaths | Select-Object -Unique
[Environment]::SetEnvironmentVariable("PATH", ($finalMachinePaths -join ";"), "Machine")
[Environment]::SetEnvironmentVariable("PATH", ($finalUserPaths -join ";"), "User")

# 2. 清理 npm 缓存
Remove-Item "$env:APPDATA\npm-cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\npm-cache\*" -Recurse -Force -ErrorAction SilentlyContinue

# 3. 修复系统文件
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth

# 4. 重新注册 DLL
regsvr32 /s C:\Windows\System32\ucrtbase.dll
regsvr32 /s C:\Windows\System32\vcruntime140.dll
regsvr32 /s C:\Windows\System32\vcruntime140_1.dll

# 5. 验证
node --version
npm --version
pnpm --version

Write-Host "修复完成！请重启计算机。" -ForegroundColor Green
