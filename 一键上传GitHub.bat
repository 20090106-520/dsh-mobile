@echo off
chcp 65001 >nul
echo ========================================
echo   DSH Mobile - 一键上传 GitHub 构建
echo ========================================
echo.

:: 检查 Git
git --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Git
    echo 请先安装: https://git-scm.com/download/win
    pause
    exit /b 1
)

:: 进入桌面端目录
cd /d "%~dp0"

:: 检查是否已有 Git 仓库
if not exist ".git" (
    echo [初始化] 创建 Git 仓库...
    git init
    git checkout -b main
)

:: 添加文件
echo [添加文件] ...
git add .

:: 提交
echo [提交] ...
git commit -m "DSH Mobile app build"

:: 检查是否已有远程仓库
git remote -v | findstr "origin" >nul
if errorlevel 1 (
    echo.
    echo ========================================
    echo   创建 GitHub 仓库
    echo ========================================
    echo.
    echo 1. 访问: https://github.com/new
    echo 2. 创建新仓库（名称: dsh-mobile）
    echo 3. 复制仓库地址
    echo.
    set /p REPO_URL="请输入仓库地址 (例如: https://github.com/user/dsh-mobile.git): "
    
    if "%REPO_URL%"=="" (
        echo [错误] 未输入仓库地址
        pause
        exit /b 1
    )
    
    git remote add origin %REPO_URL%
)

:: 推送
echo.
echo [推送] 上传到 GitHub...
echo.
git push -u origin main

echo.
echo ========================================
echo   完成！
echo ========================================
echo.
echo 下一步:
echo   1. 访问你的 GitHub 仓库
echo   2. 点击 "Actions" 标签
echo   3. 等待自动构建（约 5-10 分钟）
echo   4. 下载 APK 文件
echo.
pause
