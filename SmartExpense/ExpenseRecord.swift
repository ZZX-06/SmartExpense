import Foundation

struct ExpenseRecord: Identifiable, Codable {
    var id: UUID
    var amount: Double
    var type: ExpenseType
    var category: String
    var categoryIcon: String
    var categoryColor: String
    var merchant: String?
    var note: String?
    var date: Date
    var imageData: Data?
    var createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(),
         amount: Double,
         type: ExpenseType,
         category: String,
         categoryIcon: String = "questionmark.circle",
         categoryColor: String = "#007AFF",
         merchant: String? = nil,
         note: String? = nil,
         date: Date = Date(),
         imageData: Data? = nil,
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.amount = amount
        self.type = type
        self.category = category
        self.categoryIcon = categoryIcon
        self.categoryColor = categoryColor
        self.merchant = merchant
        self.note = note
        self.date = date
        self.imageData = imageData
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum ExpenseType: String, CaseIterable, Codable {
    case income = "收入"
    case expense = "支出"

    var displayName: String {
        return rawValue
    }
}