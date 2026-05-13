import SwiftUI

struct AddRecordView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showCategoryPicker = false
    @State private var showDatePicker = false
    @State private var editRecord: ExpenseRecord?

    var body: some View {
        NavigationStack {
            Form {
                if let image = viewModel.selectedImage {
                    selectedImageSection(image: image)
                }

                amountSection
                typeSection
                categorySection
                dateSection
                merchantSection
                noteSection
                imagePickerSection

                if viewModel.errorMessage != nil {
                    Section {
                        Text(viewModel.errorMessage ?? "")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(editRecord != nil ? "编辑记录" : "添加记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        viewModel.resetForm()
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        if editRecord != nil {
                            viewModel.updateRecord(editRecord!)
                        } else {
                            viewModel.addRecord()
                        }
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                if let record = editRecord {
                    viewModel.amount = String(format: "%.2f", record.amount)
                    viewModel.selectedType = record.type
                    viewModel.selectedDate = record.date
                    viewModel.note = record.note ?? ""
                    viewModel.merchant = record.merchant ?? ""
                    viewModel.selectedCategory = Category.findCategory(byName: record.category, type: record.type)
                }
            }
            .sheet(isPresented: $showCategoryPicker) {
                CategoryPickerView(selectedCategory: $viewModel.selectedCategory, type: viewModel.selectedType)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: Binding(
                    get: { viewModel.selectedImage },
                    set: { newImage in
                        if let image = newImage {
                            viewModel.processOCR(from: image)
                        }
                    }
                ))
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker(image: Binding(
                    get: { viewModel.selectedImage },
                    set: { newImage in
                        if let image = newImage {
                            viewModel.processOCR(from: image)
                        }
                    }
                ))
            }
            .sheet(isPresented: $viewModel.showOCRResult) {
                OCRResultView()
            }
        }
    }

    private func selectedImageSection(image: UIImage) -> some View {
        Section {
            HStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)

                if let result = viewModel.ocrResult {
                    VStack(alignment: .leading, spacing: 8) {
                        if !result.amounts.isEmpty {
                            Label("检测到金额", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                        if result.merchant != nil {
                            Label("检测到商户", systemImage: "storefront.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .font(.caption)
                }
            }
        }
    }

    private var amountSection: some View {
        Section("金额") {
            HStack {
                Text("¥")
                    .font(.title)
                    .foregroundColor(.secondary)

                TextField("0.00", text: $viewModel.amount)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 32, weight: .bold))
            }
        }
    }

    private var typeSection: some View {
        Section("类型") {
            Picker("收支类型", selection: $viewModel.selectedType) {
                ForEach(ExpenseType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.selectedType) { _ in
                viewModel.selectedCategory = nil
            }
        }
    }

    private var categorySection: some View {
        Section("分类") {
            Button(action: { showCategoryPicker = true }) {
                HStack {
                    if let category = viewModel.selectedCategory {
                        Image(systemName: category.icon)
                            .foregroundColor(category.color)
                        Text(category.name)
                            .foregroundColor(.primary)
                    } else {
                        Image(systemName: "folder")
                            .foregroundColor(.gray)
                        Text("选择分类")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
        }
    }

    private var dateSection: some View {
        Section("日期") {
            DatePicker("选择日期", selection: $viewModel.selectedDate, displayedComponents: .date)
        }
    }

    private var merchantSection: some View {
        Section("商户（可选）") {
            TextField("输入商户名称", text: $viewModel.merchant)
        }
    }

    private var noteSection: some View {
        Section("备注（可选）") {
            TextField("添加备注", text: $viewModel.note)
        }
    }

    private var imagePickerSection: some View {
        Section("截图识别（可选）") {
            HStack(spacing: 20) {
                Button(action: { showCamera = true }) {
                    VStack {
                        Image(systemName: "camera.fill")
                            .font(.title)
                        Text("拍照")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)

                Button(action: { showImagePicker = true }) {
                    VStack {
                        Image(systemName: "photo.fill")
                            .font(.title)
                        Text("相册")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
