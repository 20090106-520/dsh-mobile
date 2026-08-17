# Node.js 0xc0000142 最终修复脚本
# 此脚本尝试多种方法修复问题

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Node.js 0xc0000142 最终修复" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdmin) {
    Write-Host "[权限] 管理员权限: 已获取" -ForegroundColor Green
} else {
    Write-Host "[权限] 管理员权限: 未获取（部分操作将跳过）" -ForegroundColor Yellow
}
Write-Host ""

# ========== 方法 1: 重新注册 VC++ 运行库 ==========
Write-Host "[方法 1] 重新安装 VC++ Redistributable..." -ForegroundColor Yellow
$vcUrls = @(
    "https://aka.ms/vs/17/release/vc_redist.x64.exe",
    "https://aka.ms/vs/17/release/vc_redist.x86.exe"
)
$vcInstaller = "$env:TEMP\vc_redist_install.exe"

Write-Host "  下载 VC++ 安装程序..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri $vcUrls[0] -OutFile $vcInstaller -UseBasicParsing -ErrorAction Stop
    Write-Host "  下载完成，正在安装 VC++ x64..." -ForegroundColor Gray
    Start-Process -FilePath $vcInstaller -ArgumentList "/install", "/quiet", "/norestart" -Wait -ErrorAction SilentlyContinue
    Write-Host "  VC++ x64 安装完成" -ForegroundColor Green
} catch {
    Write-Host "  下载或安装失败: $_" -ForegroundColor Yellow
}

# ========== 方法 2: 清理 Node.js 缓存 ==========
Write-Host ""
Write-Host "[方法 2] 清理 Node.js 缓存..." -ForegroundColor Yellow
$npmCache = "$env:APPDATA\npm-cache"
if (Test-Path $npmCache) {
    Remove-Item "$npmCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  npm 缓存已清理" -ForegroundColor Green
}

# ========== 方法 3: 检查并修复 DLL 注册 ==========
Write-Host ""
Write-Host "[方法 3] 检查 DLL 注册..." -ForegroundColor Yellow
$system32 = "C:\Windows\System32"
$dlls = @("ucrtbase.dll", "vcruntime140.dll", "vcruntime140_1.dll", "msvcp140.dll")

foreach ($dll in $dlls) {
    $dllPath = Join-Path $system32 $dll
    if (Test-Path $dllPath) {
        # 检查 DLL 是否可加载
        try {
            Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class DllLoader {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr LoadLibrary(string lpFileName);
}
"@
            $handle = [DllLoader]::LoadLibrary($dllPath)
            if ($handle -ne [IntPtr]::Zero) {
                Write-Host "  ✓ $dll 可正常加载" -ForegroundColor Green
            } else {
                Write-Host "  ✗ $dll 加载失败" -ForegroundColor Red
            }
        } catch {
            Write-Host "  ⚠ $dll 检查失败: $_" -ForegroundColor Yellow
        }
    }
}

# ========== 方法 4: 验证 Node.js ==========
Write-Host ""
Write-Host "[方法 4] 验证 Node.js..." -ForegroundColor Yellow
$nodeExe = "C:\Program Files\nodejs\node.exe"

if (Test-Path $nodeExe) {
    $file = Get-Item $nodeExe
    Write-Host "  文件: $nodeExe" -ForegroundColor Cyan
    Write-Host "  大小: $([math]::Round($file.Length/1MB, 2)) MB" -ForegroundColor Cyan
    Write-Host "  修改时间: $($file.LastWriteTime)" -ForegroundColor Cyan
    
    # 尝试运行
    Write-Host "  运行测试..." -ForegroundColor Gray
    try {
        $result = & $nodeExe --version 2>&1
        if ($result) {
            Write-Host "  node --version: $result" -ForegroundColor Green
        } else {
            Write-Host "  node --version: 无输出" -ForegroundColor Red
        }
    } catch {
        Write-Host "  运行失败: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  错误: node.exe 不存在！" -ForegroundColor Red
    Write-Host "  需要重新安装 Node.js" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   修复完成" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "重要：请重启计算机以使所有更改生效！" -ForegroundColor Yellow
Write-Host ""
pause
