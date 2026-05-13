import SwiftUI

struct RecordsListView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    @State private var showAddRecord = false
    @State private var showFilter = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar

                if viewModel.filteredRecords.isEmpty {
                    emptyState
                } else {
                    recordsList
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("账单")
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
            .sheet(isPresented: $showFilter) {
                FilterView()
            }
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Button(action: { showFilter = true }) {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("筛选")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(20)
                }

                ForEach(ExpenseViewModel.DateRange.allCases, id: \.self) { range in
                    Button(action: { viewModel.dateRange = range }) {
                        Text(range.rawValue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(viewModel.dateRange == range ? Color.blue : Color.white)
                            .foregroundColor(viewModel.dateRange == range ? .white : .primary)
                            .cornerRadius(20)
                    }
                }

                Picker("类型", selection: $viewModel.selectedType) {
                    Text("全部").tag(ExpenseType?.none)
                    ForEach(ExpenseType.allCases, id: \.self) { type in
                        Text(type.displayName).tag(type as ExpenseType?)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white)
                .cornerRadius(20)
            }
            .padding()
        }
        .background(Color.white)
    }

    private var recordsList: some View {
        List {
            ForEach(viewModel.groupedRecords, id: \.0) { section in
                Section(header: Text(section.0)) {
                    ForEach(section.1) { record in
                        RecordRowView(record: record)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.deleteRecord(section.1[index])
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("暂无记录")
                .font(.title2)
                .fontWeight(.semibold)

            Text("尝试调整筛选条件或添加新记录")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button(action: { showAddRecord = true }) {
                Text("添加记录")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(25)
            }

            Spacer()
        }
    }
}

struct RecordRowView: View {
    let record: ExpenseRecord

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: record.categoryColor).opacity(0.2))
                    .frame(width: 44, height: 44)

                Image(systemName: record.categoryIcon)
                    .font(.title3)
                    .foregroundColor(Color(hex: record.categoryColor))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(record.category)
                    .font(.body)
                    .fontWeight(.medium)

                HStack(spacing: 8) {
                    if let merchant = record.merchant {
                        Text(merchant)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Text(record.date, format: .dateTime.hour().minute())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text("\(record.type == .income ? "+" : "-")¥\(record.amount, specifier: "%.2f")")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(record.type == .income ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}
