import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)

            RecordsListView()
                .tabItem {
                    Label("账单", systemImage: "list.bullet.rectangle")
                }
                .tag(1)

            StatisticsView()
                .tabItem {
                    Label("统计", systemImage: "chart.bar.fill")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(.blue)
    }
}
