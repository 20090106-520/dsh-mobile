@echo off
echo ========================================
echo   DSH Mobile - Android 启动指南
echo ========================================
echo.
echo 【方式一：使用 Android Studio（推荐）】
echo   1. 打开 Android Studio
echo   2. 点击 File -> Open
echo   3. 选择目录: %cd%\android
echo   4. 等待 Gradle 同步完成
echo   5. 点击 Run 按钮（绿色三角形）
echo.
echo 【方式二：命令行构建】
echo   双击运行: build_android.bat
echo.
echo 【安装到手机】
echo   方法1: USB 连接手机，运行 build_android.bat
echo   方法2: 生成 APK 后通过微信/QQ 传输
echo.
echo 【配置连接】
echo   1. 启动电脑端 DSH Mobile 服务:
echo      cd mobile
echo      python server.py
echo.
echo   2. 获取电脑 IP:
echo      ipconfig
echo.
echo   3. 打开手机 App，配置 WebSocket 地址:
echo      ws://<电脑IP>:3081
echo.
pause
