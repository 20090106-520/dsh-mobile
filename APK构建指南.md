# DSH Mobile - Android APK 构建指南

## 快速开始

### 最简单的方法：在线构建

1. **打开在线构建服务**
   - 访问：https://www.appilane.com/
   - 或使用：https://www.nativehtml.com/

2. **上传 Web 应用**
   - 上传 `app/index.html` 文件
   - 配置应用名称：`DSH Mobile`
   - 配置包名：`com.deepseek.harness.mobile`

3. **下载 APK**
   - 构建完成后下载 APK
   - 传输到手机安装

---

## 方法二：本地构建（需要软件）

### 需要的软件
- Node.js 18+
- JDK 17+
- Android Studio

### 步骤

1. **安装 Node.js**
   ```
   https://nodejs.org/
   ```

2. **安装 JDK**
   ```
   https://adoptium.net/
   ```

3. **安装 Android Studio**
   ```
   https://developer.android.com/studio
   ```

4. **运行构建脚本**
   ```bash
   双击 build_apk.bat
   ```

5. **在 Android Studio 中构建**
   - 等待 Gradle 同步
   - 点击 Run 按钮

---

## 文件位置

构建完成后，APK 位置：
```
app/android/app/build/outputs/apk/debug/app-debug.apk
```

---

## 安装到手机

### 方法一：USB 传输
```bash
adb install app/android/app/build/outputs/apk/debug/app-debug.apk
```

### 方法二：微信/QQ 传输
将 APK 文件发送到手机，直接安装。

---

## 使用方法

1. **启动电脑端服务**
   ```bash
   cd mobile
   python server.py
   ```

2. **获取电脑 IP**
   ```bash
   ipconfig
   ```
   找到 `IPv4 地址`，例如 `192.168.1.100`

3. **打开手机 App**
   - 点击 ⚙️ 按钮
   - 输入：`ws://192.168.1.100:3081`
   - 点击连接

---

## 常见问题

**Q: 为什么无法构建？**
A: 检查是否安装了 Node.js 和 JDK

**Q: Android Studio 打不开？**
A: 手动打开 `app/android` 目录

**Q: 如何测试？**
A: 使用 Android Studio 的模拟器

---

## 在线构建推荐

| 服务 | 网址 | 特点 |
|------|------|------|
| Appilane | https://www.appilane.com/ | 免费，简单 |
| NativeHTML | https://www.nativehtml.com/ | 免费，快速 |
| Capacitor Cloud | https://capacitorjs.com/cloud-build | 专业，稳定 |
