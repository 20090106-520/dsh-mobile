@echo off
chcp 65001 >nul
echo ========================================
echo   DSH Mobile - 快速安装脚本
echo ========================================
echo.

:: 检查 Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Node.js
    echo 请先安装: https://nodejs.org/
    pause
    exit /b 1
)

:: 进入 app 目录
cd /d "%~dp0app"

:: 安装依赖
echo [1/3] 安装依赖...
call npm install

:: 复制文件
if not exist "www" mkdir www
echo [2/3] 准备资源...
copy /Y "index.html" "www\index.html" >nul

:: 初始化项目
echo [3/3] 初始化 Android 项目...
call npx cap init "DSH Mobile" "com.deepseek.harness.mobile" --web-dir www --android
call npx cap sync android

echo.
echo ========================================
echo   完成！
echo ========================================
echo.
echo 下一步:
echo   1. 打开 Android Studio
echo   2. 打开项目: %cd%
echo   3. 点击 Run 按钮
echo.
echo APK 位置:
echo   app\build\outputs\apk\debug\app-debug.apk
echo.
pause
