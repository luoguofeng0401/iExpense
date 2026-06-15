//
//  ContentView.swift
//  iExpense
//
//  Created by Guofeng Luo on 2026-06-14.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let saveItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: saveItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    @State private var editingItem: ExpenseItem?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingItem = item
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
            .sheet(item: $editingItem) { item in
                EditView(expenses: expenses, item: item)
            }
        }
    }
    
    func removeItems(at offset: IndexSet) {
        expenses.items.remove(atOffsets: offset)
    }
}

struct AddView: View {
    var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Business"
    @State private var amount = 0.0
    
    let types = ["Business", "Personal"]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) { Text($0) }
                }
                
                TextField("Amount", value: $amount, format: .number)
            }
            .navigationTitle("Add Expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(
                        id: UUID(),
                        name: name,
                        type: type,
                        amount: amount
                    )
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}

struct EditView: View {
    var expenses: Expenses
    var item: ExpenseItem
    
    @State private var name: String
    @State private var type: String
    @State private var amount: Double
    
    let types = ["Business", "Personal"]
    
    @Environment(\.dismiss) var dismiss
    
    init(expenses: Expenses, item: ExpenseItem) {
        self.expenses = expenses
        self.item = item
        _name = State(initialValue: item.name)
        _type = State(initialValue: item.type)
        _amount = State(initialValue: item.amount)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .number)
            }
            .navigationTitle("Edit Expense")
            .toolbar {
                Button("Save") {
                    if let index = expenses.items.firstIndex(where: { $0.id == item.id }) {
                        
                        let newItem = ExpenseItem(
                            id: item.id,
                            name: name,
                            type: type,
                            amount: amount
                        )
                        expenses.items[index] = newItem
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
