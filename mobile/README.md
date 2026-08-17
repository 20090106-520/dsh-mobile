# DSH Mobile - 原生手机客户端

通过 PWA 技术，让 DSH 桌面端在手机上拥有原生 App 体验。

## 功能

- 添加到手机主屏幕，像原生 App 一样打开
- 全屏运行，无浏览器地址栏
- 支持离线缓存
- 消息推送（可选）

## 使用方法

### 1. 启动服务器

**方式一：双击启动（Windows）**
```
双击 start.bat
```

**方式二：命令行**
```bash
cd mobile
pip install -r requirements.txt
python server.py
```

### 2. 手机安装

1. 确保手机和电脑在同一 WiFi
2. 手机浏览器打开：`http://<电脑IP>:8080`
3. 点击浏览器菜单 → "添加到主屏幕"
4. 在桌面找到 DSH Mobile 图标，点击打开

### 3. 配置连接

首次打开后：
1. 点击 ⚙️ 按钮
2. WebSocket 地址：`ws://<电脑IP>:3081`
3. 点击连接

## 文件结构

```
mobile/
├── index.html      # PWA 主页面
├── manifest.json   # PWA 配置
├── sw.js           # Service Worker
├── server.py       # 后端服务器
├── start.bat       # Windows 启动脚本
├── make_icons.py   # 图标生成
└── icons/          # PWA 图标
```

## 端口

| 端口 | 用途 |
|------|------|
| 8080 | HTTP（手机访问） |
| 3081 | WebSocket（双向通信） |

## 获取电脑 IP

```bash
ipconfig
```

找到 `IPv4 地址`，例如 `192.168.1.100`

## 注意事项

- 确保防火墙允许 8080 和 3081 端口
- 手机和电脑必须在同一网络
- 首次使用需要在浏览器中添加至主屏幕
