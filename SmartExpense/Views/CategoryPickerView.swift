import SwiftUI

struct CategoryPickerView: View {
    @Binding var selectedCategory: Category?
    let type: ExpenseType
    @Environment(\.dismiss) var dismiss

    var categories: [Category] {
        Category.getCategories(for: type)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    Button(action: {
                        selectedCategory = category
                        dismiss()
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(category.color.opacity(0.2))
                                    .frame(width: 40, height: 40)

                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                            }

                            Text(category.name)
                                .foregroundColor(.primary)

                            Spacer()

                            if selectedCategory?.id == category.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("选择分类")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
}
