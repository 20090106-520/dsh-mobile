#!/usr/bin/env python3
"""
DSH Mobile Bridge - 支持内网穿透的服务器
使用 Cloudflare Tunnel 或 ngrok 实现公网访问
"""

import asyncio
import websockets
import json
import aiohttp
from aiohttp import web
from datetime import datetime
import os
import subprocess
import sys

# 配置
PORT = 3081
WS_PORT = 3081
DSH_API_URL = os.environ.get("DSH_API_URL", "http://127.0.0.1:3080")

# 存储客户端连接
clients = {}

async def forward_to_dsh(message):
    """将消息转发到 DSH 桌面端 API"""
    try:
        async with aiohttp.ClientSession() as session:
            payload = {"message": message, "source": "mobile"}
            async with session.post(
                f"{DSH_API_URL}/api/message",
                json=payload,
                timeout=aiohttp.ClientTimeout(total=30)
            ) as resp:
                if resp.status == 200:
                    data = await resp.json()
                    return data.get("response", "收到消息")
                else:
                    return f"DSH API 错误: {resp.status}"
    except Exception as e:
        return f"连接 DSH 失败: {str(e)[:100]}"

async def handle_client(websocket):
    """处理单个客户端连接"""
    client_id = datetime.now().strftime("%H:%M:%S")
    clients[client_id] = websocket
    
    await websocket.send(json.dumps({
        "type": "connected",
        "id": client_id,
        "message": "已连接到 DSH 桌面端"
    }))
    
    print(f"[{client_id}] 客户端已连接，当前连接数: {len(clients)}")
    
    try:
        async for raw_message in websocket:
            try:
                data = json.loads(raw_message)
                
                if data.get("type") == "message":
                    content = data.get("content", "").strip()
                    if not content:
                        continue
                    
                    await broadcast({"type": "typing", "from": client_id})
                    
                    response = await forward_to_dsh(content)
                    
                    await broadcast({
                        "type": "response",
                        "content": response,
                        "from": client_id
                    })
                    
            except json.JSONDecodeError:
                await websocket.send(json.dumps({
                    "type": "error",
                    "message": "消息格式错误"
                }))
                
    except websockets.exceptions.ConnectionClosed:
        print(f"[{client_id}] 客户端已断开")
    finally:
        if client_id in clients:
            del clients[client_id]
        print(f"当前连接数: {len(clients)}")

async def broadcast(message):
    """向所有客户端广播消息"""
    if not clients:
        return
    
    data = json.dumps(message)
    disconnected = []
    
    for cid, ws in clients.items():
        try:
            await ws.send(data)
        except:
            disconnected.append(cid)
    
    for cid in disconnected:
        if cid in clients:
            del clients[cid]

async def index_handler(request):
    """提供手机端页面"""
    return web.FileResponse(os.path.join(os.path.dirname(__file__), "index.html"))

async def health_handler(request):
    """健康检查"""
    return web.json_response({
        "status": "ok",
        "clients": len(clients),
        "dsh_url": DSH_API_URL
    })

def setup_tunnel():
    """设置内网穿透"""
    print("=" * 50)
    print("  DSH Mobile Bridge - 内网穿透配置")
    print("=" * 50)
    print()
    
    # 检查是否有 cloudflared
    try:
        result = subprocess.run(["cloudflared", "--version"], capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ 检测到 Cloudflare Tunnel")
            print()
            print("请运行以下命令启动隧道:")
            print(f"  cloudflared tunnel --url http://localhost:{PORT}")
            print()
            print("或者使用 ngrok:")
            print(f"  ngrok http {PORT}")
            return
    except:
        pass
    
    # 检查 ngrok
    try:
        result = subprocess.run(["ngrok", "version"], capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ 检测到 ngrok")
            print()
            print("请运行以下命令启动隧道:")
            print(f"  ngrok http {PORT}")
            return
    except:
        pass
    
    print("⚠️ 未检测到内网穿透工具")
    print()
    print("推荐安装 (二选一):")
    print()
    print("方案一: Cloudflare Tunnel (免费，无需注册)")
    print("  安装: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/download/")
    print(f"  启动: cloudflared tunnel --url http://localhost:{PORT}")
    print()
    print("方案二: ngrok (免费，需要注册)")
    print("  安装: https://ngrok.com/download")
    print(f"  启动: ngrok http {PORT}")
    print()

async def main():
    # 设置内网穿透
    setup_tunnel()
    
    print()
    print("=" * 50)
    print("  DSH Mobile Bridge")
    print("=" * 50)
    print()
    print(f"  本地 HTTP:    http://localhost:{PORT}")
    print(f"  本地 WebSocket: ws://localhost:{WS_PORT}")
    print()
    print("  请按 Ctrl+C 停止服务器")
    print("=" * 50)
    print()
    
    # 启动 WebSocket 服务器
    ws_server = websockets.serve(handle_client, "0.0.0.0", WS_PORT)
    
    # 启动 HTTP 服务器
    app = web.Application()
    app.router.add_get("/", index_handler)
    app.router.add_get("/index.html", index_handler)
    app.router.add_get("/health", health_handler)
    
    runner = web.AppRunner(app)
    
    async def start_servers():
        await runner.setup()
        site = web.TCPSite(runner, "0.0.0.0", PORT)
        await site.start()
        
        # 获取本机 IP
        import socket
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            s.connect(('8.8.8.8', 1))
            local_ip = s.getsockname()[0]
        except:
            local_ip = "127.0.0.1"
        finally:
            s.close()
        
        print(f"HTTP 服务器已启动: http://0.0.0.0:{PORT}")
        print(f"WebSocket 服务器已启动: ws://0.0.0.0:{WS_PORT}")
        print(f"局域网访问: http://{local_ip}:{PORT}")
        print()
        print("内网穿透地址 (启动隧道后显示):")
        print("  请访问 https://dashboard.ngrok.com/status/tunnels (ngrok)")
        print("  或 https://dash.cloudflare.com/one/tunnels (Cloudflare)")
        print()
        
        await asyncio.Future()
    
    loop = asyncio.get_event_loop()
    loop.run_until_complete(ws_server)
    loop.run_until_complete(start_servers())
    try:
        loop.run_forever()
    except KeyboardInterrupt:
        print("\n服务器已停止")
        loop.stop()

if __name__ == "__main__":
    main()
