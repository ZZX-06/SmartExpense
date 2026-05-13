# 智能记账 App - 产品规格说明

## 1. 项目概述

**项目名称**: SmartExpense (智能记账)
**应用平台**: iOS 15.0+
**核心功能**: 支持手动记账和截图自动识别记账的智能财务管理应用
**目标用户**: 需要便捷管理日常开支的个人用户

## 2. 技术栈

- **前端框架**: SwiftUI
- **后端架构**: MVVM
- **OCR识别**: iOS Vision框架
- **本地存储**: Core Data
- **图片处理**: PhotosUI, CoreImage
- **部署目标**: iOS 15.0

## 3. 功能模块

### 3.1 核心功能
- ✅ 手动添加收支记录（金额、类别、备注、日期）
- ✅ 截图自动识别记账（OCR文字识别）
- ✅ 收支记录列表和详情查看
- ✅ 分类统计（按类别、按时间）
- ✅ 月度财务报表

### 3.2 记录管理
- ✅ 添加新记录
- ✅ 编辑现有记录
- ✅ 删除记录
- ✅ 按日期范围筛选
- ✅ 按类别筛选

### 3.3 截图识别功能
- ✅ 从相册选择图片
- ✅ 相机拍照
- ✅ Vision框架OCR识别
- ✅ 智能提取金额和商户信息
- ✅ 预览识别结果并确认

### 3.4 数据统计
- ✅ 本月支出/收入汇总
- ✅ 各类别支出占比
- ✅ 日/周/月视图切换
- ✅ 环比增长率

## 4. 数据模型

### 4.1 ExpenseRecord
```
- id: UUID
- amount: Double
- type: ExpenseType (income/expense)
- category: String
- merchant: String?
- note: String?
- date: Date
- imageData: Data? (关联截图)
- createdAt: Date
- updatedAt: Date
```

### 4.2 Category
```
- id: UUID
- name: String
- icon: String (SF Symbol)
- color: String (Hex)
- type: ExpenseType
```

## 5. 预设类别

### 支出类别
- 🍔 餐饮 (food)
- 🚗 交通 (transport)
- 🛒 购物 (shopping)
- 🏠 居住 (housing)
- 💊 医疗 (medical)
- 🎮 娱乐 (entertainment)
- 📚 教育 (education)
- 📱 通讯 (communication)
- ☕ 其他 (other)

### 收入类别
- 💰 工资 (salary)
- 💵 奖金 (bonus)
- 📈 投资 (investment)
- 🎁 礼物 (gift)
- 💵 其他 (other)

## 6. UI/UX 设计

### 6.1 页面结构
1. **首页** - 今日账单概览 + 快速记账入口
2. **账单列表** - 所有记录的时间线视图
3. **统计** - 可视化图表展示
4. **我的** - 设置和个人中心

### 6.2 颜色方案
- **主题色**: #007AFF (iOS蓝)
- **支出**: #FF3B30 (红色)
- **收入**: #34C759 (绿色)
- **背景**: #F2F2F7 (浅灰)
- **卡片**: #FFFFFF (白色)

### 6.3 导航
- TabView (4个标签页)
  - 首页 (house.fill)
  - 账单 (list.bullet.rectangle)
  - 统计 (chart.bar.fill)
  - 我的 (person.fill)

## 7. 关键实现

### 7.1 OCR识别流程
1. 用户选择/拍摄图片
2. 使用 VNRecognizeTextRequest 进行文字识别
3. 使用正则表达式提取金额格式 (¥XXX.XX 或 XXX.XX)
4. 尝试识别商户名称（查找常见关键词）
5. 展示识别结果供用户确认
6. 用户确认后保存为新记录

### 7.2 数据持久化
- 使用 Core Data 进行本地存储
- 自动备份到 iCloud (可选)

## 8. 验收标准

1. ✅ 可以成功添加、编辑、删除收支记录
2. ✅ 可以从相册或相机选择图片进行OCR识别
3. ✅ OCR能准确识别中文金额
4. ✅ 统计数据正确显示
5. ✅ 数据在应用重启后持久保存
6. ✅ 界面流畅，交互友好
