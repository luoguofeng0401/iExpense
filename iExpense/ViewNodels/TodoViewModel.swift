import Foundation
import SwiftData

// MARK: - ViewModel（資料怎麼操作）
@Observable
final class TodoViewModel {

    private var context: ModelContext
    var todos: [TodoItem] = []

    init(context: ModelContext) {
        self.context = context
        fetch()  // 初始化時讀取資料
    }
    
    // ── Create ──────────────────────────────
    func add(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let item = TodoItem(title: title)
        context.insert(item)
        save()
    }

    // ── Read ────────────────────────────────
    func fetch() {
        let descriptor = FetchDescriptor<TodoItem>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        todos = (try? context.fetch(descriptor)) ?? []
    }

    // ── Update ──────────────────────────────
    func toggle(_ item: TodoItem) {
        item.isCompleted.toggle()
        save()
    }

    func update(_ item: TodoItem, newTitle: String) {
        item.title = newTitle
        save()
    }

    // ── Delete ──────────────────────────────
    func delete(_ item: TodoItem) {
        context.delete(item)
        save()
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { context.delete(todos[$0]) }
        save()
    }

    // ── Private ─────────────────────────────
    private func save() {
        try? context.save()
        fetch()  // 存完重新讀取，讓 UI 保持同步
    }
}
