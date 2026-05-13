import CoreData

@objc(ExpenseEntity)
public class ExpenseEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseEntity> {
        return NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var amount: Double
    @NSManaged public var type: String?
    @NSManaged public var category: String?
    @NSManaged public var categoryIcon: String?
    @NSManaged public var categoryColor: String?
    @NSManaged public var merchant: String?
    @NSManaged public var note: String?
    @NSManaged public var date: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
}

extension ExpenseEntity: Identifiable {}
