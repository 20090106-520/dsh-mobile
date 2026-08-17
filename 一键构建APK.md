# DSH Mobile - 一键构建 APK

## 🚀 最简方法：一键上传 GitHub 自动构建

### 使用方法

**双击运行：** `一键上传GitHub.bat`

脚本会自动：
1. 初始化 Git 仓库
2. 添加所有文件
3. 提交代码
4. 提示输入 GitHub 仓库地址
5. 推送到 GitHub
6. **自动开始构建 APK！**

### 构建完成后

1. 访问你的 GitHub 仓库
2. 点击 "Actions" 标签
3. 点击最新的 workflow run
4. 在 Artifacts 部分下载 APK
5. 传输到手机安装

---

## 📱 安装到手机

### 方法一：USB 传输
```bash
adb install app-debug.apk
```

### 方法二：微信/QQ 传输
将 APK 文件发送到手机，直接安装。

---

## ⚠️ 注意事项

- 需要 GitHub 账号
- 仓库可以是公开的也可以是私有的
- 构建需要 5-10 分钟
- 首次使用需要安装 Git

---

## 🔧 手动步骤

如果脚本失败，可以手动执行：

```bash
# 1. 初始化 Git
git init
git add .
git commit -m "DSH Mobile app"

# 2. 创建远程仓库（在 GitHub 网页上）
# https://github.com/new

# 3. 推送
git remote add origin https://github.com/YOUR_USERNAME/dsh-mobile.git
git push -u origin main

# 4. 等待构建完成，下载 APK
```
