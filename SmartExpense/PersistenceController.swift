import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SmartExpense")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("无法加载持久化存储：\(error.localizedDescription)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        for i in 0..<5 {
            let record = ExpenseEntity(context: context)
            record.id = UUID()
            record.amount = Double.random(in: 10...500)
            record.type = i % 2 == 0 ? "支出" : "收入"
            record.category = ["餐饮", "交通", "购物", "工资", "奖金"][i % 5]
            record.date = Date().addingTimeInterval(Double(-i * 86400))
            record.createdAt = Date()
            record.updatedAt = Date()
        }

        try? context.save()
        return controller
    }()

    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("保存数据失败：\(error.localizedDescription)")
            }
        }
    }

    func fetchRecords() -> [ExpenseRecord] {
        let request: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ExpenseEntity.date, ascending: false)]

        do {
            let entities = try container.viewContext.fetch(request)
            return entities.map { ExpenseRecord.from(entity: $0) }
        } catch {
            print("获取记录失败：\(error.localizedDescription)")
            return []
        }
    }

    func saveRecord(_ record: ExpenseRecord) {
        let context = container.viewContext
        let entity = ExpenseEntity(context: context)
        entity.id = record.id
        entity.amount = record.amount
        entity.type = record.type.rawValue
        entity.category = record.category
        entity.categoryIcon = record.categoryIcon
        entity.categoryColor = record.categoryColor
        entity.merchant = record.merchant
        entity.note = record.note
        entity.date = record.date
        entity.imageData = record.imageData
        entity.createdAt = record.createdAt
        entity.updatedAt = record.updatedAt

        save()
    }

    func updateRecord(_ record: ExpenseRecord) {
        let request: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", record.id as CVarArg)

        do {
            let results = try container.viewContext.fetch(request)
            if let entity = results.first {
                entity.amount = record.amount
                entity.type = record.type.rawValue
                entity.category = record.category
                entity.categoryIcon = record.categoryIcon
                entity.categoryColor = record.categoryColor
                entity.merchant = record.merchant
                entity.note = record.note
                entity.date = record.date
                entity.imageData = record.imageData
                entity.updatedAt = Date()
                save()
            }
        } catch {
            print("更新记录失败：\(error.localizedDescription)")
        }
    }

    func deleteRecord(_ record: ExpenseRecord) {
        let request: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", record.id as CVarArg)

        do {
            let results = try container.viewContext.fetch(request)
            if let entity = results.first {
                container.viewContext.delete(entity)
                save()
            }
        } catch {
            print("删除记录失败：\(error.localizedDescription)")
        }
    }
}
