# 智能记账 App - Windows 用户使用指南

## 🎯 概述

本项目是用 **SwiftUI** 开发的iOS原生记账应用。你不需要Mac电脑，只需要 **Windows PC + GitHub** 即可编译安装到你的iPhone上。

**工作原理**：
```
你在Windows上编写代码
    → 推送到 GitHub
    → GitHub 的云端Mac服务器自动编译
    → 生成 .ipa 文件
    → 下载后免费安装到iPhone
```

## 🚀 快速开始（5分钟上手）

### 第一步：准备工具

1. **安装Git**（如已安装跳过）
   - 下载地址：https://git-scm.com/download/win
   - 安装时全部默认选项即可

2. **注册GitHub账号**
   - 访问：https://github.com/signup
   - 免费注册一个账号

### 第二步：在GitHub创建仓库

1. 登录GitHub，点击右上角 **+** → **New repository**
2. 仓库名称填写：`SmartExpense`
3. 选择 **Public**（公开，免费）
4. 点击 **Create repository**
5. 复制页面上显示的仓库地址，如：`https://github.com/你的用户名/SmartExpense.git`

### 第三步：一键推送代码

**双击运行** `push_to_github.bat`，按提示操作即可。

> 如果提示输入GitHub账号密码，需要输入你的GitHub用户名和**Personal Access Token**（在GitHub设置中生成，不要用登录密码）

### 第四步：等待云编译

1. 推送成功后，打开浏览器访问你的GitHub仓库
2. 点击 **Actions** 标签页
3. 会看到一个正在运行的 `Build iOS App (IPA)` 工作流
4. 等待约5-10分钟，进度条变绿表示编译成功
5. 点击运行记录，在 **Artifacts** 部分下载 `SmartExpense-IPA.zip`
6. 解压得到 `SmartExpense.ipa`

### 第五步：安装到iPhone

在Windows上安装免费的侧载工具，将IPA安装到手机：

**推荐：AltStore（最稳定）**
1. 电脑下载 AltStore：https://altstore.io/
2. iPhone上安装 AltStore（会引导你操作）
3. 在Windows上打开 AltStore
4. 用数据线连接iPhone
5. 将 `SmartExpense.ipa` 拖入AltStore窗口
6. 输入Apple ID，自动安装

**备用：Sideloadly（更简单）**
1. 下载：https://sideloadly.io/
2. 连接iPhone，拖入IPA文件
3. 输入Apple ID，点击开始安装

> ⚠️ **免费账号限制**：每7天需要重新安装一次（AltStore会自动续签）

## 📦 项目文件说明

| 文件 | 说明 |
|------|------|
| `SmartExpense/` | iOS应用源代码 |
| `SmartExpense.xcodeproj/` | Xcode项目文件 |
| `.github/workflows/build.yml` | **GitHub云编译配置** |
| `push_to_github.bat` | **Windows一键推送脚本** |
| `.gitignore` | Git忽略配置 |

## 🔄 如何更新应用

修改代码后，再次双击 `push_to_github.bat`，GitHub会自动重新编译，下载新的IPA安装即可。

## 🛠 常见问题

### Q: 编译失败怎么办？
A: 去GitHub的Actions页面查看红色日志，截图发给我，我来修复。

### Q: 免费账号7天过期后数据会丢失吗？
A: **不会**！数据保存在手机本地，重新安装后数据还在。建议定期截图备份重要数据。

### Q: 能和其他人共享吗？
A: 可以，将IPA文件发给朋友，他们用AltStore也能安装。

### Q: 为什么需要Apple ID？
A: Apple要求所有iOS应用都需要签名才能安装，使用免费Apple ID即可，不会扣费。

## 📞 需要帮助？

如果遇到任何问题，随时告诉我，我可以：
1. 修复编译错误
2. 调整应用功能
3. 优化OCR识别效果