import SwiftUI

struct OCRResultView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                VStack(alignment: .leading, spacing: 16) {
                    if let result = viewModel.ocrResult {
                        recognitionResultSection(result: result)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .padding(.horizontal)

                if let result = viewModel.ocrResult, !result.amounts.isEmpty {
                    amountSelectionSection(amounts: result.amounts)
                }

                Spacer()

                confirmButton
            }
            .padding(.top)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("识别结果")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func recognitionResultSection(result: OCRService.OCRResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("识别结果")
                .font(.headline)

            if !result.amounts.isEmpty {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("检测到 \(result.amounts.count) 个金额")
                }
            }

            if let merchant = result.merchant {
                HStack {
                    Image(systemName: "storefront.fill")
                        .foregroundColor(.blue)
                    Text("商户：\(merchant)")
                }
            }

            Divider()

            Text("识别原文：")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(result.allText)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(5)
        }
    }

    private func amountSelectionSection(amounts: [Double]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("选择金额")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(amounts.enumerated()), id: \.offset) { index, amount in
                        Button(action: {
                            viewModel.amount = String(format: "%.2f", amount)
                        }) {
                            VStack(spacing: 4) {
                                Text("¥\(amount, specifier: "%.2f")")
                                    .font(.title3)
                                    .fontWeight(.semibold)

                                Text("选项 \(index + 1)")
                                    .font(.caption2)
                            }
                            .padding()
                            .background(viewModel.amount == String(format: "%.2f", amount) ? Color.blue : Color.white)
                            .foregroundColor(viewModel.amount == String(format: "%.2f", amount) ? .white : .primary)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var confirmButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("确认并继续")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
        .padding()
    }
}
