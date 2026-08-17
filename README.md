# DSH Mobile - 手机端解决方案

## 📱 方案一：PWA 网页应用（立即可用）

**无需安装，打开浏览器就能用**

### 步骤：

1. **启动服务**
   ```bash
   cd mobile
   python server.py
   ```

2. **获取电脑 IP**
   ```bash
   ipconfig
   ```
   找到 `IPv4 地址`，例如 `192.168.1.100`

3. **手机浏览器打开**
   ```
   http://192.168.1.100:8080
   ```

4. **添加到主屏幕**
   - Chrome: 菜单 → 添加到主屏幕
   - 小米浏览器: 菜单 → 添加到桌面
   - 华为浏览器: 菜单 → 安装到桌面

5. **像 App 一样使用**
   - 点击主屏幕图标打开
   - 全屏显示，无浏览器地址栏

---

## 📱 方案二：在线构建 APK

1. **访问在线构建服务**
   - https://www.appilane.com/
   - https://www.nativehtml.com/

2. **上传文件**
   - 上传：`app\index.html`
   - 应用名称：`DSH Mobile`
   - 包名：`com.deepseek.harness.mobile`

3. **下载 APK**
   - 等待构建完成
   - 下载 APK 文件
   - 传输到手机安装

---

## 📱 方案三：本地构建 APK

### 需要的软件：
- Node.js 18+
- JDK 17+
- Android Studio

### 步骤：
```bash
双击 build_apk.bat
```

然后在 Android Studio 中点击 Run 按钮。

---

## 📂 文件结构

```
桌面端/
├── app/                    # PWA 应用
│   ├── index.html          # 主页面
│   ├── build.html          # 构建指南
│   ├── package.json
│   └── capacitor.config.json
├── mobile/                 # 后端服务 + PWA
│   ├── server.py           # Python 服务器
│   ├── index.html          # PWA 页面
│   ├── start.bat           # 一键启动
│   └── README.md
├── android/                # Android 原生项目
│   ├── app/
│   └── README.md
├── build_apk.bat          # APK 构建脚本
├── build_apk.sh           # Linux/Mac 构建脚本
└── README.md
```

---

## 🚀 推荐使用方法

### 最快方案：PWA 网页应用

1. 启动服务：
   ```bash
   cd mobile
   python server.py
   ```

2. 手机浏览器打开：
   ```
   http://<电脑IP>:8080
   ```

3. 添加到主屏幕即可使用

---

## ⚠️ 注意事项

- 手机和电脑需要在**同一 WiFi 网络**
- 确保防火墙允许 **8080** 和 **3081** 端口
- 首次使用需要在浏览器中添加至主屏幕

---

## 端口说明

| 端口 | 协议 | 用途 |
|------|------|------|
| 8080 | HTTP | 手机访问 Web 界面 |
| 3081 | WebSocket | 双向通信 |
