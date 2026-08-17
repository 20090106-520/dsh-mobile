#!/bin/bash
echo "========================================"
echo "   DSH Mobile - 一键构建 APK (Linux/Mac)"
echo "========================================"
echo ""

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "[错误] 未找到 Node.js"
    echo "请先安装: https://nodejs.org/"
    exit 1
fi

# 检查 Java
if ! command -v java &> /dev/null; then
    echo "[错误] 未找到 Java"
    echo "请先安装 JDK 17+: https://adoptium.net/"
    exit 1
fi

echo "[提示] Node.js 和 Java 已安装"
echo ""

# 进入 app 目录
cd "$(dirname "$0")/app"

# 安装依赖
echo "[1/5] 安装依赖..."
npm install

# 准备 www 目录
if [ ! -d "www" ]; then
    mkdir -p www
fi
echo "[2/5] 准备资源..."
cp index.html www/

# 初始化
echo "[3/5] 初始化项目..."
npx @capacitor/cli init "DSH Mobile" "com.deepseek.harness.mobile" --web-dir www --android

# 同步
echo "[4/5] 同步到 Android..."
npx cap sync android

# 完成
echo "[5/5] 完成！"
echo ""
echo "========================================"
echo "   构建步骤"
echo "========================================"
echo ""
echo "方法一：使用 Android Studio"
echo "  1. 打开 Android Studio"
echo "  2. File -> Open"
echo "  3. 选择: $(pwd)/android"
echo "  4. 等待 Gradle 同步"
echo "  5. 点击 Run 按钮"
echo ""
echo "方法二：使用命令行"
echo "  cd $(pwd)/android"
echo "  ./gradlew assembleDebug"
echo ""
echo "APK 位置:"
echo "  $(pwd)/android/app/build/outputs/apk/debug/app-debug.apk"
echo ""
read -p "按回车键继续..."
