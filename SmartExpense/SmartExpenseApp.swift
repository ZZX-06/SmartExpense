import SwiftUI

@main
struct SmartExpenseApp: App {
    @StateObject private var expenseViewModel = ExpenseViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(expenseViewModel)
        }
    }
}