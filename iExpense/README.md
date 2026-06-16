# SwiftUI Todo App — MVVM + SwiftData 面試標準架構

## 專案結構

```
TodoApp/
├── TodoApp.swift              # App Entry Point + ModelContainer 設定
├── Models/
│   └── TodoItem.swift         # @Model SwiftData 資料模型
├── ViewModels/
│   └── TodoViewModel.swift    # @Observable ViewModel（CRUD + Filter + Sort）
└── Views/
    ├── ContentView.swift      # Root View，注入 ViewModel
    ├── TodoListView.swift     # 清單主畫面（List + Toolbar + Search）
    ├── TodoRowView.swift      # 單一列元件
    ├── AddTodoView.swift      # 新增 Sheet（Create）
    └── TodoDetailView.swift   # 詳細 + 編輯畫面（Read + Update）
```

---

## 架構重點

### SwiftData
| 項目 | 說明 |
|------|------|
| `@Model` | 標記 `TodoItem` 為 SwiftData 持久化模型 |
| `ModelContainer` | 在 App entry point 建立，注入整個 App |
| `@Environment(\.modelContext)` | 在 View 取得 context 傳給 ViewModel |
| `FetchDescriptor` | 在 ViewModel 中以程式碼方式 fetch |

### MVVM
| 層 | 職責 |
|----|------|
| **Model** (`TodoItem`) | 純資料定義，無 UI 邏輯 |
| **ViewModel** (`TodoViewModel`) | 所有業務邏輯：CRUD、Filter、Sort、Error |
| **View** | 只負責顯示，透過 binding 驅動 ViewModel |

### 關鍵 Swift 特性
- `@Observable` macro（iOS 17+）取代 `ObservableObject` + `@Published`
- `@Bindable` 讓 View 直接 bind Observable 的屬性
- `ContentUnavailableView` 處理空狀態（iOS 17+）
- `FocusState` 自動彈出鍵盤

---

## CRUD 對應

| 操作 | 方法 | 觸發 UI |
|------|------|---------|
| Create | `addTodo(title:notes:priority:)` | AddTodoView 的「新增」按鈕 |
| Read | `fetchTodos()` | onAppear / 每次 save 後自動更新 |
| Update | `updateTodo(_:title:notes:priority:)` | EditTodoView 的「儲存變更」|
| Update | `toggleCompletion(_:)` | Row 的圓形按鈕 / 詳細頁快捷 |
| Delete | `deleteTodo(_:)` | 詳細頁 Menu 刪除 |
| Delete | `deleteTodos(at:)` | List swipe-to-delete |
| Delete | `deleteCompletedTodos()` | Toolbar Menu 批次清除 |

---

## 面試常見追問

**Q: 為何不用 `@Query` 而是手動 fetch？**  
A: `@Query` 限制在 View 層，無法在 ViewModel 中使用。ViewModel 持有 `ModelContext` 並透過 `FetchDescriptor` fetch，讓業務邏輯保持在 ViewModel，符合 MVVM 分層原則。

**Q: `@Observable` vs `ObservableObject` 差別？**  
A: `@Observable`（iOS 17）使用 Swift macro，只追蹤 View 實際讀取的屬性，效能更好；舊版 `@Published` 任何屬性變動都會觸發整個 View 重繪。

**Q: SwiftData 如何處理 Relationship？**  
A: 可在 `@Model` class 中加入 `@Relationship` 屬性，SwiftData 自動處理 cascade delete 等行為。
