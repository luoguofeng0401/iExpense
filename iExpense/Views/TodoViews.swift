import SwiftUI

// MARK: - Row View（清單裡的每一列）
struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void

    var body: some View {
        HStack {
            // 切換完成狀態按鈕
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(todo.isCompleted ? .green : .secondary)
                    .font(.title2)
            }
            .buttonStyle(.plain)

            // 標題
            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .secondary : .primary)
        }
    }
}

// MARK: - Add View（新增 Sheet）
struct AddTodoView: View {
    let vm: TodoViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("輸入標題", text: $title)
            }
            .navigationTitle("新增待辦")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("新增") {
                        vm.add(title: title)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

// MARK: - Detail View（詳細 + 編輯）
struct TodoDetailView: View {
    let todo: TodoItem
    let vm: TodoViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var editTitle = ""
    @State private var isEditing = false

    var body: some View {
        Form {
            Section("標題") {
                if isEditing {
                    TextField("標題", text: $editTitle)
                } else {
                    Text(todo.title)
                }
            }

            Section("狀態") {
                Toggle("已完成", isOn: Binding(
                    get: { todo.isCompleted },
                    set: { _ in vm.toggle(todo) }
                ))
            }

            Section("建立時間") {
                Text(todo.createdAt.formatted())
                    .foregroundStyle(.secondary)
            }

            // 刪除按鈕
            Section {
                Button("刪除", role: .destructive) {
                    vm.delete(todo)
                    dismiss()
                }
            }
        }
        .navigationTitle("詳細資訊")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "儲存" : "編輯") {
                    if isEditing {
                        vm.update(todo, newTitle: editTitle)
                    } else {
                        editTitle = todo.title  // 帶入目前值
                    }
                    isEditing.toggle()
                }
            }
        }
    }
}
