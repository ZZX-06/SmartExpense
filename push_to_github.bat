@echo off
chcp 65001 >nul
title 智能记账 - 一键推送至GitHub云编译
color 0B

echo ============================================
echo    智能记账 App - 一键推送至GitHub
echo    使用云端Mac服务器自动编译iOS应用
echo ============================================
echo.

REM Check if git is installed
where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 未检测到Git，请先安装Git
    echo 下载地址: https://git-scm.com/download/win
    pause
    exit /b 1
)

REM Check git config
git config user.name >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [提示] 请先配置Git用户信息
    set /p GIT_NAME=请输入Git用户名: 
    set /p GIT_EMAIL=请输入Git邮箱: 
    git config --global user.name "%GIT_NAME%"
    git config --global user.email "%GIT_EMAIL%"
)

echo [1/5] 初始化Git仓库...
if not exist .git (
    git init
    echo   ✓ Git仓库已初始化
) else (
    echo   ✓ Git仓库已存在
)

echo [2/5] 添加所有文件到暂存区...
git add .
echo   ✓ 文件已添加

echo [3/5] 创建提交...
set COMMIT_MSG=更新智能记账App - %DATE% %TIME%
git commit -m "%COMMIT_MSG%"
echo   ✓ 提交成功

echo [4/5] 检查远程仓库...
git remote -v | findstr "origin" >nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [!!!] 需要设置GitHub远程仓库地址
    echo.
    set /p REPO_URL=请输入GitHub仓库地址 (例如: https://github.com/你的用户名/SmartExpense.git): 
    git remote add origin "%REPO_URL%"
    echo   ✓ 远程仓库已添加
) else (
    echo   ✓ 远程仓库已存在
)

echo [5/5] 推送到GitHub...
git push -u origin main
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [!!!] 推送失败，尝试推送到 master 分支...
    git push -u origin master
)

echo.
echo ============================================
echo  🎉 推送完成！
echo.
echo  接下来请按以下步骤操作：
echo.
echo  1. 打开浏览器访问你的GitHub仓库
echo  2. 点击 Actions 标签页
echo  3. 等待 "Build iOS App (IPA)" 工作流完成
echo  4. 点击运行记录，下载 SmartExpense-IPA 工件
echo  5. 解压得到 SmartExpense.ipa
echo.
echo  安装到iPhone的方法（任选一种）：
echo  📱 AltStore (推荐): https://altstore.io/
echo  📱 SideStore: https://sidestore.io/
echo  📱 Sideloadly: https://sideloadly.io/
echo.
echo  更多详细说明请查看 README.md
echo ============================================
echo.
pause