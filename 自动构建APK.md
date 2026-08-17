# DSH Mobile - 自动构建 APK

## 方法：使用 GitHub Actions 自动构建

### 步骤 1：创建 GitHub 仓库

1. 访问 https://github.com/new
2. 创建新仓库（公开或私有）
3. 复制仓库地址

### 步骤 2：推送代码到 GitHub

```bash
cd "C:\Users\Administrator\Desktop\桌面端"
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/你的用户名/dsh-mobile.git
git push -u origin main
```

### 步骤 3：等待自动构建

推送后，GitHub Actions 会自动开始构建：
1. 访问你的仓库
2. 点击 "Actions" 标签
3. 等待构建完成（约 5-10 分钟）

### 步骤 4：下载 APK

构建完成后：
1. 在 Actions 页面点击最新的 workflow run
2. 在 Artifacts 部分下载 APK
3. 传输到手机安装

---

## 文件说明

| 文件 | 用途 |
|------|------|
| `.github/workflows/build-android.yml` | GitHub Actions 配置 |
| `app/index.html` | Web 应用主页面 |
| `app/capacitor.config.json` | Capacitor 配置 |
| `app/package.json` | Node.js 依赖 |

---

## 快速开始

```bash
# 1. 初始化 Git
cd "C:\Users\Administrator\Desktop\桌面端"
git init

# 2. 添加所有文件
git add .

# 3. 提交
git commit -m "DSH Mobile app"

# 4. 创建远程仓库（在 GitHub 网页上）
# 然后关联
git remote add origin https://github.com/YOUR_USERNAME/dsh-mobile.git

# 5. 推送
git push -u origin main
```

推送后，GitHub 会自动构建 APK！

---

## 构建输出

APK 文件位置（在 GitHub Actions 中）：
```
app/android/app/build/outputs/apk/debug/app-debug.apk
```

下载链接会在 Actions 页面的 Artifacts 中显示。
