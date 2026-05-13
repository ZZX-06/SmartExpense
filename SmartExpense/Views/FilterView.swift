import SwiftUI

struct FilterView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("类型") {
                    Picker("收支类型", selection: $viewModel.selectedType) {
                        ForEach(ExpenseType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("时间范围") {
                    Picker("时间范围", selection: $viewModel.dateRange) {
                        ForEach(ExpenseViewModel.DateRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("分类") {
                    Button(action: { viewModel.selectedCategory = nil }) {
                        HStack {
                            Text("全部分类")
                                .foregroundColor(.primary)
                            Spacer()
                            if viewModel.selectedCategory == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }

                    ForEach(Category.getCategories(for: viewModel.selectedType)) { category in
                        Button(action: { viewModel.selectedCategory = category }) {
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                                Text(category.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                if viewModel.selectedCategory?.id == category.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("筛选")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("重置") {
                        viewModel.selectedCategory = nil
                        viewModel.dateRange = .all
                        viewModel.selectedType = .expense
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
