# DSH Mobile - Android APK

一键构建可直接安装的 Android APK。

## 使用方法

### 方式一：双击运行（推荐）

双击 `build_apk.bat`，会自动：
1. 安装 Node.js 依赖
2. 创建 Android 项目
3. 打开 Android Studio

然后在 Android Studio 中点击 Run 按钮构建 APK。

### 方式二：手动构建

```bash
# 1. 进入 app 目录
cd app

# 2. 安装依赖
npm install

# 3. 初始化项目
npx cap init "DSH Mobile" "com.deepseek.harness.mobile" --web-dir www --android

# 4. 同步
npx cap sync android

# 5. 打开 Android Studio
npx cap open android
```

### 方式三：使用 Android Studio

1. 打开 Android Studio
2. File -> Open -> 选择 `app\android` 目录
3. 等待 Gradle 同步
4. 点击 Run 按钮

## 输出位置

APK 生成位置：
```
app\android\app\build\outputs\apk\debug\app-debug.apk
```

## 安装到手机

```bash
adb install app\android\app\build\outputs\apk\debug\app-debug.apk
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

3. 打开手机 App：
   - 点击 ⚙️ 按钮
   - 输入：`ws://<电脑IP>:3081`
   - 点击连接

## 系统要求

- Node.js 18+
- Java 17+
- Android Studio 2022.3+
- Android 7.0+ (API 24+)
