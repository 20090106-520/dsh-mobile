@echo off
chcp 65001 >nul
echo ========================================
echo   DSH Mobile - 内网穿透配置
echo ========================================
echo.

:: 检查 cloudflared
echo [检查] Cloudflare Tunnel...
cloudflared --version >nul 2>&1
if errorlevel 1 (
    echo [提示] 未检测到 Cloudflare Tunnel
    echo 下载地址: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/download/
    echo.
) else (
    echo [OK] Cloudflare Tunnel 已安装
)

:: 检查 ngrok
echo.
echo [检查] ngrok...
ngrok --version >nul 2>&1
if errorlevel 1 (
    echo [提示] 未检测到 ngrok
    echo 下载地址: https://ngrok.com/download
    echo.
) else (
    echo [OK] ngrok 已安装
)

echo ========================================
echo   内网穿透配置
echo ========================================
echo.
echo 方案一: Cloudflare Tunnel (推荐，完全免费)
echo ----------------------------------------
echo 1. 注册账号: https://dash.cloudflare.com/sign-up
echo 2. 安装 cloudflared
echo 3. 登录: cloudflared tunnel login
echo 4. 创建隧道: cloudflared tunnel create dsh-mobile
echo 5. 启动隧道: cloudflared tunnel --url http://localhost:3081
echo.
echo 方案二: ngrok (免费，有带宽限制)
echo ----------------------------------------
echo 1. 注册账号: https://dashboard.ngrok.com/signup
echo 2. 安装 ngrok
echo 3. 登录: ngrok config add-authtoken TOKEN
echo 4. 启动隧道: ngrok http 3081
echo.
pause
