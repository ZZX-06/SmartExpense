import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    @State private var showAddRecord = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    todayOverviewCard
                    quickActionsSection
                    recentRecordsSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("智能记账")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddRecord = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddRecord) {
                AddRecordView()
            }
        }
    }

    private var todayOverviewCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("今日概览")
                    .font(.headline)
                Spacer()
                Text(Date(), format: .dateTime.month().day().weekday(.wide))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 40) {
                VStack(spacing: 4) {
                    Text("收入")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("¥\(viewModel.todayTotal.income, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }

                VStack(spacing: 4) {
                    Text("支出")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("¥\(viewModel.todayTotal.expense, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }

                VStack(spacing: 4) {
                    Text("结余")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("¥\(viewModel.todayTotal.income - viewModel.todayTotal.expense, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor((viewModel.todayTotal.income - viewModel.todayTotal.expense) >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("快捷记账")
                .font(.headline)

            HStack(spacing: 12) {
                quickActionButton(icon: "camera.fill", title: "拍照识别", color: .blue) {
                    showAddRecord = true
                }

                quickActionButton(icon: "photo.fill", title: "相册识别", color: .purple) {
                    showAddRecord = true
                }

                quickActionButton(icon: "pencil", title: "手动记账", color: .orange) {
                    showAddRecord = true
                }
            }
        }
    }

    private func quickActionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)

                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
    }

    private var recentRecordsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("最近记录")
                    .font(.headline)
                Spacer()
                NavigationLink(destination: RecordsListView()) {
                    Text("查看全部")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }

            if viewModel.records.isEmpty {
                emptyStateView
            } else {
                VStack(spacing: 0) {
                    ForEach(viewModel.records.prefix(5)) { record in
                        RecordRowView(record: record)
                        if record.id != viewModel.records.prefix(5).last?.id {
                            Divider()
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundColor(.gray)

            Text("暂无记录")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("点击右上角添加您的第一笔账单")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(16)
    }
}
