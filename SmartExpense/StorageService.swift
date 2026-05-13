import Foundation

class StorageService {
    static let shared = StorageService()

    private let fileURL: URL

    private init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDirectory.appendingPathComponent("expenses.json")
    }

    func saveRecords(_ records: [ExpenseRecord]) {
        do {
            let data = try JSONEncoder().encode(records)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("保存数据失败：\(error.localizedDescription)")
        }
    }

    func loadRecords() -> [ExpenseRecord] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([ExpenseRecord].self, from: data)
        } catch {
            print("加载数据失败：\(error.localizedDescription)")
            return []
        }
    }
}