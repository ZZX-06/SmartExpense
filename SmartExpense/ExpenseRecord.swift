import Foundation
import CoreData

struct ExpenseRecord: Identifiable {
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

enum ExpenseType: String, CaseIterable {
    case income = "收入"
    case expense = "支出"

    var displayName: String {
        return rawValue
    }
}

extension ExpenseRecord {
    func toEntity(context: NSManagedObjectContext) -> ExpenseEntity {
        let entity = ExpenseEntity(context: context)
        entity.id = id
        entity.amount = amount
        entity.type = type.rawValue
        entity.category = category
        entity.categoryIcon = categoryIcon
        entity.categoryColor = categoryColor
        entity.merchant = merchant
        entity.note = note
        entity.date = date
        entity.imageData = imageData
        entity.createdAt = createdAt
        entity.updatedAt = updatedAt
        return entity
    }

    static func from(entity: ExpenseEntity) -> ExpenseRecord {
        ExpenseRecord(
            id: entity.id ?? UUID(),
            amount: entity.amount,
            type: ExpenseType(rawValue: entity.type ?? "支出") ?? .expense,
            category: entity.category ?? "其他",
            categoryIcon: entity.categoryIcon ?? "questionmark.circle",
            categoryColor: entity.categoryColor ?? "#007AFF",
            merchant: entity.merchant,
            note: entity.note,
            date: entity.date ?? Date(),
            imageData: entity.imageData,
            createdAt: entity.createdAt ?? Date(),
            updatedAt: entity.updatedAt ?? Date()
        )
    }
}
