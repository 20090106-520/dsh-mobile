# DSH Mobile - 使用说明

## ✅ 已完成

- [x] APK 已生成并复制到桌面
- [x] 内网穿透配置指南已创建
- [x] 手机端界面已优化

---

## 📱 安装 APK

**文件位置：** `C:\Users\Administrator\Desktop\DSH-Mobile.apk`

### 安装方法
1. 用 USB 连接手机到电脑
2. 复制 `DSH-Mobile.apk` 到手机
3. 在手机上点击安装
4. 如果提示"未知来源"，请允许安装

---

## 🌐 连接方式

### 方式一：同一 WiFi（局域网）

**优点：** 简单，无需额外配置

**步骤：**
1. 启动电脑端服务：
   ```bash
   cd C:\Users\Administrator\Desktop\桌面端\mobile
   python server.py
   ```

2. 获取电脑 IP：
   ```bash
   ipconfig
   ```
   找到 `IPv4 地址`，例如 `192.168.1.100`

3. 手机连接：
   - 打开 App
   - 点击 ⚙️ 按钮
   - WebSocket 地址：`ws://192.168.1.100:3081`
   - 点击连接

---

### 方式二：不同网络（内网穿透）

**优点：** 手机可以在任何网络下连接

**推荐使用 Cloudflare Tunnel（完全免费）：**

#### 1. 安装 cloudflared

```bash
# 使用 Chocolatey
choco install cloudflared

# 或手动下载
https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/
```

#### 2. 登录 Cloudflare

```bash
cloudflared tunnel login
```

浏览器打开，按提示登录。

#### 3. 创建隧道

```bash
cloudflared tunnel create dsh-mobile
```

记录输出的 Tunnel ID。

#### 4. 启动隧道

```bash
# 方式一：快速启动（临时地址）
cloudflared tunnel --url http://localhost:3081

# 方式二：持久化配置
cloudflared tunnel run dsh-mobile
```

#### 5. 获取公网地址

启动后，你会看到类似：
```
https://abc123-xyz.trycloudflare.com
```

或者访问 https://dash.cloudflare.com/one/tunnels 查看。

#### 6. 手机连接

在手机 App 中填写：
- WebSocket 地址：`wss://abc123-xyz.trycloudflare.com`
- HTTP 地址：`https://abc123-xyz.trycloudflare.com`

---

### 方式三：使用 ngrok（备用方案）

#### 1. 安装 ngrok

```bash
# 使用 Scoop
scoop install ngrok

# 或手动下载
https://ngrok.com/download
```

#### 2. 注册并登录

访问 https://dashboard.ngrok.com/signup 注册账号
```bash
ngrok config add-authtoken YOUR_TOKEN
```

#### 3. 启动隧道

```bash
ngrok http 3081
```

#### 4. 获取地址并连接

启动后显示：
```
Forwarding  https://abc123.ngrok-free.app -> http://localhost:3081
```

在手机 App 填写：
- WebSocket 地址：`wss://abc123.ngrok-free.app`

---

## 📂 文件说明

```
桌面端/
├── DSH-Mobile.apk          # 已安装到桌面
├── mobile/
│   ├── server.py           # 后端服务器
│   ├── index.html          # 手机端页面
│   ├── start.bat           # 一键启动
│   ├── setup-tunnel.bat    # 内网穿透配置
│   └── 内网穿透配置指南.md # 详细教程
└── README.md
```

---

## ⚠️ 注意事项

1. **防火墙设置**
   - 确保 3081 端口开放
   - 内网穿透工具需要保持运行

2. **安全性**
   - 公网地址请妥善保管
   - 建议设置访问密码

3. **性能**
   - Cloudflare Tunnel 速度较快
   - ngrok 免费版有带宽限制

---

## 🔧 故障排查

### 问题：连接失败
- 检查电脑端服务是否启动
- 检查防火墙设置
- 确认手机和电脑在同一网络（局域网方式）

### 问题：隧道地址变了
- Cloudflare Tunnel 地址固定
- ngrok 免费版每次重启会变化

### 问题：手机端无法访问
- 检查内网穿透工具是否运行
- 确认防火墙允许 inbound 连接
