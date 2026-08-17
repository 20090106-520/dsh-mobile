@echo off
echo ========================================
echo   DSH Mobile Android 构建脚本
echo ========================================
echo.

:: 检查 Java
java -version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Java，请先安装 JDK 17+
    echo 下载地址: https://adoptium.net/
    pause
    exit /b 1
)

:: 进入 android 目录
cd /d "%~dp0android"

:: 检查 Gradle Wrapper
if not exist "gradlew.bat" (
    echo [提示] 正在下载 Gradle Wrapper...
    call gradle wrapper
)

:: 构建 Debug APK
echo.
echo [构建中] 请稍候...
echo.
call gradlew.bat assembleDebug

:: 检查构建结果
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo.
    echo ========================================
    echo   构建成功！
    echo ========================================
    echo.
    echo APK 位置: app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo 安装到手机:
    echo   adb install app\build\outputs\apk\debug\app-debug.apk
    echo.
    
    :: 询问是否安装
    set /p install="是否立即安装到手机？(Y/N): "
    if /i "%install%"=="Y" (
        echo.
        adb install -r "app\build\outputs\apk\debug\app-debug.apk"
    )
) else (
    echo.
    echo [错误] 构建失败，请检查错误信息
)

echo.
pause
