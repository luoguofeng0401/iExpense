import SwiftUI

// MARK: - Root View（負責建立 ViewModel 並往下傳）
struct ContentView: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        TodoListView(vm: TodoViewModel(context: context))
    }
}
