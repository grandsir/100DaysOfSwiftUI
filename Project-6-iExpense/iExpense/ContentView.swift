//
//  ContentView.swift
//  iExpense
//
//  Created by GrandSir on 11.07.2021.
//

import SwiftUI


protocol Encodable: Identifiable, Codable {
    var id: UUID { get }
}

struct ExpenseItem: Encodable {
    var id = UUID()
    let name : String
    let type: String
    let amount : Int
}



class Expenses : ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}


struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) {item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .foregroundColor(item.amount < 10 ? .red : .primary)
                                .font(.headline)
                                .bold()
                            Text(item.type)
                                .foregroundColor(item.amount < 10 ? .red : .primary)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                            .foregroundColor(item.amount < 10 ? .red : item.amount < 100 ? .blue : .green )
                    }
                }
                .onDelete(perform: { indexSet in
                    self.removeItems(at: indexSet)
                })
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    showingAddExpense = true
                })  {
                    Image(systemName: "plus")
                })
            
        }
        .sheet(isPresented: $showingAddExpense, content: {
            AddView(expenses: self.expenses)
            
        })
    }
    
    func removeItems(at offsets: IndexSet) {
        self.expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
