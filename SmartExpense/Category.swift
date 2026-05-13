import Foundation
import SwiftUI

struct Category: Identifiable, Hashable {
    let id: UUID
    let name: String
    let icon: String
    let color: Color
    let type: ExpenseType

    init(id: UUID = UUID(),
         name: String,
         icon: String,
         color: Color,
         type: ExpenseType) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.type = type
    }

    static let expenseCategories: [Category] = [
        Category(name: "餐饮", icon: "fork.knife", color: .orange, type: .expense),
        Category(name: "交通", icon: "car.fill", color: .blue, type: .expense),
        Category(name: "购物", icon: "bag.fill", color: .pink, type: .expense),
        Category(name: "居住", icon: "house.fill", color: .purple, type: .expense),
        Category(name: "医疗", icon: "cross.case.fill", color: .red, type: .expense),
        Category(name: "娱乐", icon: "gamecontroller.fill", color: .green, type: .expense),
        Category(name: "教育", icon: "book.fill", color: .indigo, type: .expense),
        Category(name: "通讯", icon: "phone.fill", color: .cyan, type: .expense),
        Category(name: "咖啡", icon: "cup.and.saucer.fill", color: .brown, type: .expense),
        Category(name: "其他", icon: "ellipsis.circle.fill", color: .gray, type: .expense)
    ]

    static let incomeCategories: [Category] = [
        Category(name: "工资", icon: "banknote.fill", color: .green, type: .income),
        Category(name: "奖金", icon: "gift.fill", color: .orange, type: .income),
        Category(name: "投资", icon: "chart.line.uptrend.xyaxis", color: .blue, type: .income),
        Category(name: "礼物", icon: "heart.fill", color: .pink, type: .income),
        Category(name: "其他", icon: "ellipsis.circle.fill", color: .gray, type: .income)
    ]

    static func getCategories(for type: ExpenseType) -> [Category] {
        return type == .expense ? expenseCategories : incomeCategories
    }

    static func findCategory(byName name: String, type: ExpenseType) -> Category {
        let categories = getCategories(for: type)
        return categories.first { $0.name == name } ?? categories.last!
    }

    func toRecordCategory() -> (name: String, icon: String, color: String) {
        return (name, icon, colorToHex())
    }

    func colorToHex() -> String {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}
