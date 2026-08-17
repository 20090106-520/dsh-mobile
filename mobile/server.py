#!/usr/bin/env python3
"""
DSH Mobile Bridge - 手机端连接电脑端 DSH
PWA 方案：添加到手机主屏幕，像原生 App 一样使用
"""

import asyncio
import websockets
import json
import aiohttp
from aiohttp import web
from datetime import datetime
import os

# 存储客户端连接
clients = {}
DSH_API_URL = os.environ.get("DSH_API_URL", "http://127.0.0.1:3080")
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

async def forward_to_dsh(message):
    """将消息转发到 DSH 桌面端 API"""
    try:
        async with aiohttp.ClientSession() as session:
            payload = {"message": message, "source": "mobile"}
            
            # 尝试 DSH API
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
    """提供 PWA 页面"""
    return web.FileResponse(os.path.join(BASE_DIR, "index.html"))

async def manifest_handler(request):
    """PWA manifest"""
    return web.FileResponse(os.path.join(BASE_DIR, "manifest.json"), 
                           content_type="application/manifest+json")

async def sw_handler(request):
    """Service Worker"""
    return web.FileResponse(os.path.join(BASE_DIR, "sw.js"),
                           content_type="application/javascript")

async def icon_handler(request):
    """图标"""
    size = request.match_info.get('size', '192')
    path = os.path.join(BASE_DIR, "icons", f"icon-{size}.png")
    if os.path.exists(path):
        return web.FileResponse(path)
    return web.Response(status=404)

async def health_handler(request):
    """健康检查"""
    return web.json_response({
        "status": "ok",
        "clients": len(clients),
        "dsh_url": DSH_API_URL
    })

def main():
    http_port = int(os.environ.get("MOBILE_HTTP_PORT", "8080"))
    ws_port = int(os.environ.get("MOBILE_WS_PORT", "3081"))
    
    print("=" * 50)
    print("  DSH Mobile Bridge (PWA)")
    print("=" * 50)
    print()
    print(f"  HTTP:    http://0.0.0.0:{http_port}")
    print(f"  WS:      ws://0.0.0.0:{ws_port}")
    print()
    print("  手机浏览器打开 HTTP 地址")
    print("  添加至主屏幕即可安装")
    print()
    print("  按 Ctrl+C 停止")
    print("=" * 50)
    print()
    
    # 启动 WebSocket 服务器
    ws_server = websockets.serve(handle_client, "0.0.0.0", ws_port)
    
    # 启动 HTTP 服务器
    app = web.Application()
    app.router.add_get("/", index_handler)
    app.router.add_get("/index.html", index_handler)
    app.router.add_get("/manifest.json", manifest_handler)
    app.router.add_get("/sw.js", sw_handler)
    app.router.add_get("/icon-{size}.png", icon_handler)
    app.router.add_get("/health", health_handler)
    
    runner = web.AppRunner(app)
    
    async def start_servers():
        await runner.setup()
        site = web.TCPSite(runner, "0.0.0.0", http_port)
        await site.start()
        
        print(f"HTTP 服务器已启动: http://0.0.0.0:{http_port}")
        print(f"WebSocket 服务器已启动: ws://0.0.0.0:{ws_port}")
        print()
        
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
        
        print(f"局域网访问: http://{local_ip}:{http_port}")
        print(f"手机端打开此地址后添加到主屏幕")
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
