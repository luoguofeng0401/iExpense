import SwiftUI
import SwiftData

@main
struct TodoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TodoItem.self)  // ✅ 最簡單的寫法，SwiftData 自動處理其餘設定
    }
}
