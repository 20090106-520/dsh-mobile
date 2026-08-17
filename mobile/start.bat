@echo off
chcp 65001 >nul
echo ========================================
echo   DSH Mobile - 启动服务器
echo ========================================
echo.

:: 检查 Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Python
    pause
    exit /b 1
)

:: 进入目录
cd /d "%~dp0"

:: 检查依赖
echo [1/3] 检查依赖...
pip show websockets aiohttp >nul 2>&1
if errorlevel 1 (
    echo 安装依赖...
    pip install -q -r requirements.txt
)

:: 启动服务器
echo [2/3] 启动服务器...
echo.
python server.py

echo.
pause
