import SwiftUI

// MARK: - List View（主畫面）
struct TodoListView: View {
    @State var vm: TodoViewModel
    @State private var showAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.todos) { todo in
                    // 點擊 Row → 進入詳細頁
                    NavigationLink(destination: TodoDetailView(todo: todo, vm: vm)) {
                        TodoRowView(todo: todo) {
                            vm.toggle(todo)
                        }
                    }
                }
                .onDelete(perform: vm.delete)  // ✅ swipe to delete
            }
            .navigationTitle("待辦清單")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddTodoView(vm: vm)
            }
        }
    }
}
