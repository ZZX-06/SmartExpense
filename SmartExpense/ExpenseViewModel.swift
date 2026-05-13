import Foundation
import SwiftUI
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var records: [ExpenseRecord] = []
    @Published var selectedType: ExpenseType = .expense
    @Published var selectedCategory: Category?
    @Published var selectedDate: Date = Date()
    @Published var amount: String = ""
    @Published var note: String = ""
    @Published var merchant: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showOCRResult: Bool = false
    @Published var ocrResult: OCRService.OCRResult?
    @Published var selectedImage: UIImage?
    @Published var dateRange: DateRange = .all

    private let persistence = PersistenceController.shared

    enum DateRange: String, CaseIterable {
        case today = "今天"
        case week = "本周"
        case month = "本月"
        case all = "全部"
    }

    init() {
        loadRecords()
    }

    func loadRecords() {
        records = persistence.fetchRecords()
    }

    var filteredRecords: [ExpenseRecord] {
        records.filter { record in
            let typeMatch = record.type == selectedType
            let categoryMatch = selectedCategory == nil || record.category == selectedCategory?.name
            let dateMatch = matchesDateRange(record.date)
            return typeMatch && categoryMatch && dateMatch
        }
    }

    private func matchesDateRange(_ date: Date) -> Bool {
        let calendar = Calendar.current

        switch dateRange {
        case .today:
            return calendar.isDateInToday(date)
        case .week:
            return calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
        case .month:
            return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
        case .all:
            return true
        }
    }

    var todayTotal: (income: Double, expense: Double) {
        let today = Calendar.current.startOfDay(for: Date())
        let todayRecords = records.filter { calendar.isDate($0.date, inSameDayAs: today) }
        let income = todayRecords.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let expense = todayRecords.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        return (income, expense)
    }

    var monthTotal: (income: Double, expense: Double) {
        let calendar = Calendar.current
        let monthRecords = records.filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .month) }
        let income = monthRecords.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let expense = monthRecords.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        return (income, expense)
    }

    func addRecord() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            errorMessage = "请输入有效金额"
            return
        }

        let categoryInfo = selectedCategory?.toRecordCategory() ?? ("其他", "ellipsis.circle.fill", "#007AFF")

        let record = ExpenseRecord(
            amount: amountValue,
            type: selectedType,
            category: categoryInfo.0,
            categoryIcon: categoryInfo.1,
            categoryColor: categoryInfo.2,
            merchant: merchant.isEmpty ? nil : merchant,
            note: note.isEmpty ? nil : note,
            date: selectedDate,
            imageData: selectedImage?.jpegData(compressionQuality: 0.8)
        )

        persistence.saveRecord(record)
        loadRecords()
        resetForm()
    }

    func updateRecord(_ record: ExpenseRecord) {
        let categoryInfo = selectedCategory?.toRecordCategory() ?? (record.category, record.categoryIcon, record.categoryColor)

        var updatedRecord = record
        updatedRecord.amount = Double(amount) ?? record.amount
        updatedRecord.type = selectedType
        updatedRecord.category = categoryInfo.0
        updatedRecord.categoryIcon = categoryInfo.1
        updatedRecord.categoryColor = categoryInfo.2
        updatedRecord.merchant = merchant.isEmpty ? nil : merchant
        updatedRecord.note = note.isEmpty ? nil : note
        updatedRecord.date = selectedDate
        updatedRecord.imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        updatedRecord.updatedAt = Date()

        persistence.updateRecord(updatedRecord)
        loadRecords()
    }

    func deleteRecord(_ record: ExpenseRecord) {
        persistence.deleteRecord(record)
        loadRecords()
    }

    func resetForm() {
        amount = ""
        note = ""
        merchant = ""
        selectedDate = Date()
        selectedCategory = nil
        selectedImage = nil
        ocrResult = nil
        errorMessage = nil
    }

    func processOCR(from image: UIImage) {
        isLoading = true
        selectedImage = image

        OCRService.shared.recognizeText(from: image) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let ocrResult):
                    self?.ocrResult = ocrResult
                    self?.showOCRResult = true

                    if let amount = ocrResult.amounts.first {
                        self?.amount = String(format: "%.2f", amount)
                    }

                    if let merchant = ocrResult.merchant {
                        self?.merchant = merchant
                    }

                case .failure(let error):
                    self?.errorMessage = "OCR识别失败：\(error.localizedDescription)"
                }
            }
        }
    }

    var groupedRecords: [(String, [ExpenseRecord])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"

        let grouped = Dictionary(grouping: filteredRecords) { record in
            formatter.string(from: record.date)
        }

        return grouped.sorted { $0.key > $1.key }
    }

    func getRecordsForDate(_ date: Date) -> [ExpenseRecord] {
        let calendar = Calendar.current
        return records.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func getCategoryStats(for type: ExpenseType) -> [(category: String, amount: Double, percentage: Double)] {
        let filtered = records.filter { $0.type == type }
        let total = filtered.reduce(0) { $0 + $1.amount }

        var categoryTotals: [String: Double] = [:]
        for record in filtered {
            categoryTotals[record.category, default: 0] += record.amount
        }

        return categoryTotals.map { (category: $0.key, amount: $0.value, percentage: total > 0 ? $0.value / total * 100 : 0) }
            .sorted { $0.amount > $1.amount }
    }
}
