import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    @State private var showAbout = false
    @State private var showExport = false

    var body: some View {
        NavigationStack {
            List {
                Section("账户统计") {
                    StatisticRow(icon: "creditcard.fill", title: "总记录数", value: "\(viewModel.records.count)")
                    StatisticRow(icon: "arrow.down.circle.fill", title: "总收入", value: "¥\(totalIncome, specifier: "%.2f")", color: .green)
                    StatisticRow(icon: "arrow.up.circle.fill", title: "总支出", value: "¥\(totalExpense, specifier: "%.2f")", color: .red)
                }

                Section("数据管理") {
                    Button(action: { showExport = true }) {
                        Label("导出数据", systemImage: "square.and.arrow.up")
                    }

                    Button(role: .destructive, action: {}) {
                        Label("清除所有数据", systemImage: "trash")
                    }
                }

                Section("其他") {
                    Button(action: { showAbout = true }) {
                        Label("关于应用", systemImage: "info.circle")
                    }

                    Link(destination: URL(string: "https://github.com")!) {
                        Label("给我们评分", systemImage: "star")
                    }
                }
            }
            .navigationTitle("我的")
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }

    private var totalIncome: Double {
        viewModel.records.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    private var totalExpense: Double {
        viewModel.records.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
}

struct StatisticRow: View {
    let icon: String
    let title: String
    let value: String
    var color: Color = .blue

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)

            Text(title)

            Spacer()

            Text(value)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "yensign.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                VStack(spacing: 8) {
                    Text("智能记账")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("版本 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text("一款支持截图自动识别的智能记账应用，帮助您轻松管理日常收支。")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                Text("Made with ❤️")
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle("关于")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}
