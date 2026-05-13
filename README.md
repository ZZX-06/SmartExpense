# 智能记账 App

> 🏠 **只有Windows电脑？** 详细教程请看 [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md) —— 用GitHub云编译，无需Mac也能在手机上运行！

## 📱 项目介绍

智能记账是一款专为iOS平台设计的记账应用，支持：
- ✅ 手动记账（添加、编辑、删除收支记录）
- ✅ **截图自动识别记账**（使用iOS Vision框架OCR识别）
- ✅ 收支分类统计
- ✅ 数据本地持久化存储

## 🛠 技术栈

| 技术 | 说明 |
|------|------|
| SwiftUI | iOS原生UI框架 |
| MVVM | 架构模式 |
| Core Data | 本地数据持久化 |
| Vision Framework | OCR文字识别 |
| iOS 15.0+ | 最低支持系统版本 |

## 📁 项目结构

```
SmartExpense/
├── App/
│   └── SmartExpenseApp.swift          # 应用入口
├── Models/
│   ├── ExpenseRecord.swift             # 记账记录模型
│   ├── ExpenseEntity.swift             # Core Data实体
│   ├── Category.swift                  # 分类模型
│   └── SmartExpense.xcdatamodeld/     # Core Data模型
├── ViewModels/
│   └── ExpenseViewModel.swift          # 业务逻辑层
├── Views/
│   ├── ContentView.swift               # 主Tab视图
│   ├── HomeView.swift                  # 首页
│   ├── AddRecordView.swift             # 添加记录页
│   ├── RecordsListView.swift           # 账单列表
│   ├── StatisticsView.swift            # 统计页面
│   ├── ProfileView.swift               # 个人中心
│   ├── CategoryPickerView.swift        # 分类选择器
│   ├── FilterView.swift                # 筛选页面
│   ├── OCRResultView.swift             # OCR识别结果
│   └── ImagePicker.swift               # 图片选择器
├── Services/
│   ├── OCRService.swift                # OCR识别服务
│   └── PersistenceController.swift     # 数据持久化
└── Extensions/
    └── Extensions.swift                # 扩展工具
```

## 🚀 运行应用

### 方法一：使用 Xcode（推荐）

1. **打开项目**
   ```bash
   open SmartExpense.xcodeproj
   ```

2. **选择模拟器**
   - 打开Xcode
   - 选择目标设备（iPhone 14 Pro、iPhone 15等）
   - 或选择通用iOS设备

3. **运行应用**
   - 按 `Cmd + R` 或点击运行按钮 ▶️

### 方法二：使用命令行构建

```bash
# 检查可用的模拟器
xcrun simctl list devices available

# 构建项目
xcodebuild -project SmartExpense.xcodeproj \
  -scheme SmartExpense \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build
```

## 📸 使用截图识别功能

### OCR识别工作原理

应用使用iOS Vision框架进行文字识别：

1. **图片选择**
   - 拍照：从相机拍摄账单截图
   - 相册：从相册选择已有的截图

2. **文字识别**
   - 使用 `VNRecognizeTextRequest` 识别图片中的文字
   - 支持中文和英文混合识别

3. **智能提取**
   - 使用正则表达式匹配金额格式：`¥123.45`、`123.45`、`金额: 99.99`
   - 识别商户名称（星巴克、美团、饿了么等常见商户）
   - 支持多种账单格式

4. **结果确认**
   - 展示识别出的金额供选择
   - 自动填充商户名称
   - 用户确认后保存记录

### 支持识别的账单类型

- 🍔 餐饮：小票、发票
- 🛒 购物：电商订单截图
- ☕ 咖啡：星巴克、瑞幸小票
- 🚗 交通：打车订单
- 📱 通讯：话费等

## 🎯 主要功能

### 1. 首页
- 今日收支概览
- 快速记账入口
- 最近记录展示

### 2. 添加记录
- 输入金额
- 选择收支类型（收入/支出）
- 选择分类
- 设置日期
- 填写商户和备注
- **拍照/相册识别**

### 3. 账单列表
- 按月份分组展示
- 支持筛选（时间、类型、分类）
- 下拉刷新
- 左滑删除

### 4. 统计页面
- 月度收支汇总
- 支出分类占比图
- 周趋势柱状图

### 5. 我的
- 总记录数统计
- 总收入/总支出
- 数据导出
- 应用信息

## 📊 预设分类

### 支出分类
- 🍔 餐饮
- 🚗 交通
- 🛒 购物
- 🏠 居住
- 💊 医疗
- 🎮 娱乐
- 📚 教育
- 📱 通讯
- ☕ 咖啡
- 其他

### 收入分类
- 💰 工资
- 💵 奖金
- 📈 投资
- 🎁 礼物
- 其他

## 🔧 自定义配置

### 添加新分类

在 `Category.swift` 中添加：

```swift
static let expenseCategories: [Category] = [
    // ... 现有分类
    Category(name: "新分类", icon: "star.fill", color: .yellow, type: .expense)
]
```

### 修改主题颜色

在 `Assets.xcassets/AccentColor.colorset/Contents.json` 中修改：

```json
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "1.000",
          "green" : "0.478",
          "red" : "0.000"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

## ⚠️ 注意事项

1. **相机权限**
   - 首次使用拍照功能会请求相机权限
   - 需要在系统设置中允许"智能记账"访问相机

2. **相册权限**
   - 使用相册识别需要相册访问权限

3. **OCR识别准确性**
   - 识别准确度取决于图片质量
   - 建议使用清晰、正向拍摄的账单图片
   - 复杂背景可能影响识别效果

## 🐛 常见问题

### Q: OCR识别失败怎么办？
A: 确保图片清晰、文字可读，避免过曝或过暗

### Q: 数据会丢失吗？
A: 数据保存在本地Core Data，重装应用会丢失，建议定期导出

### Q: 如何在真机上运行？
A: 需要Apple开发者账号，并配置证书和描述文件

## 📝 后续优化建议

1. **数据备份**
   - 支持iCloud同步
   - 本地数据导出（CSV、Excel）

2. **OCR增强**
   - 优化金额提取算法
   - 支持更多账单格式

3. **统计分析**
   - 添加饼图、折线图
   - 预算管理功能
   - 周期性报告

4. **用户体验**
   - Widget支持
   - Siri快捷指令
   - Apple Watch应用

## 📄 许可证

本项目仅供学习参考，可自由使用和修改。

---

**版本**: 1.0.0
**更新日期**: 2026-05-13
