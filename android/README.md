# DSH Mobile - Android 原生应用

DeepSeek Harness 的 Android 原生客户端。

## 功能

- 通过 WebSocket 连接电脑端 DSH
- 实时聊天界面
- 本地消息历史
- 暗色主题

## 构建 APK

### 方法一：Android Studio（推荐）

1. 打开 Android Studio
2. 点击 File -> Open
3. 选择目录: `C:\Users\Administrator\Desktop\桌面端\android`
4. 等待 Gradle 同步完成
5. 点击 Run 按钮（绿色三角形）

### 方法二：命令行

```bash
cd C:\Users\Administrator\Desktop\桌面端\android
.\gradlew.bat assembleDebug
```

APK 位置:
```
android\app\build\outputs\apk\debug\app-debug.apk
```

### 方法三：一键构建

双击运行 `build_android.bat`

## 安装到手机

```bash
adb install app/build/outputs/apk/debug/app-debug.apk
```

或通过微信/QQ 传输 APK 文件。

## 使用方法

1. 启动电脑端服务：
   ```bash
   cd mobile
   python server.py
   ```

2. 获取电脑 IP：
   ```bash
   ipconfig
   ```
   找到 `IPv4 地址`，例如 `192.168.1.100`

3. 打开手机 App：
   - 点击 ⚙️ 按钮
   - 输入 WebSocket 地址：`ws://192.168.1.100:3081`
   - 点击连接

## 文件结构

```
android/
├── app/
│   ├── src/main/
│   │   ├── java/com/deepseek/harness/mobile/
│   │   │   └── MainActivity.kt      # 主界面
│   │   ├── res/
│   │   │   ├── layout/              # 布局文件
│   │   │   ├── values/              # 字符串和主题
│   │   │   ├── mipmap-*/            # 应用图标
│   │   │   └── xml/                 # 备份配置
│   │   └── AndroidManifest.xml      # 应用清单
│   └── build.gradle                 # 构建配置
├── build.gradle                     # 项目构建
├── settings.gradle                  # 项目设置
├── gradle.properties               # Gradle 配置
├── gradlew.bat                     # Gradle Wrapper
└── README.md                       # 本文件
```

## 系统要求

- Android 7.0+ (API 24+)
- Java 17+
- Android Studio 2022.3+

## 端口

| 端口 | 协议 | 用途 |
|------|------|------|
| 3081 | WebSocket | 手机连接电脑 |

## 注意事项

- 手机和电脑需要在同一 WiFi 网络
- 确保防火墙允许 3081 端口
- 首次运行需要在 App 内配置服务器地址
