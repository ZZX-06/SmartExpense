import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    @State private var selectedPeriod: StatsPeriod = .month

    enum StatsPeriod: String, CaseIterable {
        case week = "本周"
        case month = "本月"
        case year = "本年"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    periodPicker
                    overviewCard
                    categoryBreakdownSection
                    trendChartSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("统计")
        }
    }

    private var periodPicker: some View {
        Picker("时间段", selection: $selectedPeriod) {
            ForEach(StatsPeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }

    private var overviewCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("收支概况")
                    .font(.headline)
                Spacer()
            }

            HStack(spacing: 30) {
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.green)
                        Text("收入")
                            .font(.subheadline)
                    }
                    Text("¥\(monthTotal.income, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }

                Divider()
                    .frame(height: 40)

                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.red)
                        Text("支出")
                            .font(.subheadline)
                    }
                    Text("¥\(monthTotal.expense, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }

                Divider()
                    .frame(height: 40)

                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "equal.circle.fill")
                            .foregroundColor(.blue)
                        Text("结余")
                            .font(.subheadline)
                    }
                    Text("¥\(monthTotal.income - monthTotal.expense, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }

    private var monthTotal: (income: Double, expense: Double) {
        viewModel.monthTotal
    }

    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("支出分布")
                .font(.headline)

            let expenseStats = viewModel.getCategoryStats(for: .expense)

            if expenseStats.isEmpty {
                emptyCategoryView
            } else {
                VStack(spacing: 12) {
                    ForEach(expenseStats.prefix(5), id: \.category) { stat in
                        CategoryStatRow(stat: stat)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
            }
        }
    }

    private var emptyCategoryView: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.pie")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("暂无数据")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color.white)
        .cornerRadius(16)
    }

    private var trendChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("趋势图")
                .font(.headline)

            VStack(spacing: 8) {
                HStack {
                    Text("本周支出趋势")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }

                SimpleBarChart(data: getWeeklyData())
                    .frame(height: 150)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
            }
        }
    }

    private func getWeeklyData() -> [Double] {
        let calendar = Calendar.current
        let today = Date()
        var weekData: [Double] = []

        for i in (0..<7).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let dayRecords = viewModel.getRecordsForDate(date)
                let dayExpense = dayRecords.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
                weekData.append(dayExpense)
            }
        }

        return weekData
    }
}

struct CategoryStatRow: View {
    let stat: (category: String, amount: Double, percentage: Double)

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(stat.category)
                    .font(.body)

                Spacer()

                Text("¥\(stat.amount, specifier: "%.2f")")
                    .font(.body)
                    .fontWeight(.medium)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)

                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * CGFloat(stat.percentage / 100), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)

            HStack {
                Text("\(stat.percentage, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
}

struct SimpleBarChart: View {
    let data: [Double]

    private var maxValue: Double {
        data.max() ?? 1
    }

    private let weekDays = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                VStack(spacing: 4) {
                    Spacer()

                    RoundedRectangle(cornerRadius: 4)
                        .fill(value == maxValue ? Color.blue : Color.blue.opacity(0.6))
                        .frame(height: maxValue > 0 ? CGFloat(value / maxValue) * 100 : 0)

                    Text(weekDays[index])
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
