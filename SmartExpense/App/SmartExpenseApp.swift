import SwiftUI

@main
struct SmartExpenseApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var expenseViewModel = ExpenseViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(expenseViewModel)
        }
    }
}
