import Foundation
import SwiftData

// MARK: - Model（資料長什麼樣子）
@Model
final class TodoItem {
    var title: String
    var isCompleted: Bool
    var createdAt: Date

    init(title: String) {
        self.title = title
        self.isCompleted = false
        self.createdAt = Date()
    }
}
