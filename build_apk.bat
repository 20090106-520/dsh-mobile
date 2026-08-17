@echo off
chcp 65001 >nul
echo ========================================
echo   DSH Mobile - 一键构建 APK
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

:: 检查 Java
java -version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Java
    echo 请先安装 JDK 17+: https://adoptium.net/
    pause
    exit /b 1
)

echo [提示] 检测到 Node.js 和 Java 已安装
echo.

:: 进入 app 目录
cd /d "%~dp0app"

:: 安装依赖
echo [1/5] 安装依赖...
call npm install
if errorlevel 1 (
    echo [错误] npm install 失败
    pause
    exit /b 1
)

:: 准备 www 目录
if not exist "www" mkdir www
echo [2/5] 准备资源...
copy /Y "index.html" "www\index.html" >nul

:: 初始化 Capacitor
echo [3/5] 初始化项目...
call npx @capacitor/cli init "DSH Mobile" "com.deepseek.harness.mobile" --web-dir www --android --config ./capacitor.config.json
if errorlevel 1 (
    echo [警告] 初始化失败，继续尝试...
)

:: 同步
echo [4/5] 同步到 Android...
call npx cap sync android
if errorlevel 1 (
    echo [警告] 同步失败
)

:: 打开 Android Studio 或提供手动步骤
echo [5/5] 完成！
echo.
echo ========================================
echo   构建步骤
echo ========================================
echo.
echo 方法一：使用 Android Studio
echo   1. 打开 Android Studio
echo   2. File -> Open
echo   3. 选择: %cd%\android
echo   4. 等待 Gradle 同步
echo   5. 点击 Run 按钮
echo.
echo 方法二：使用命令行
echo   cd %cd%\android
echo   .\gradlew.bat assembleDebug
echo.
echo APK 位置:
echo   %cd%\android\app\build\outputs\apk\debug\app-debug.apk
echo.
pause
