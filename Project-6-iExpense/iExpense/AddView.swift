//
//  AddView.swift
//  iExpense
//
//  Created by GrandSir on 12.07.2021.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = ""
    @State private var amount = ""
    
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var isPresented = false
    static let types = ["Business", "Personal"]
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add new expense")
            .navigationBarItems(leading:
                                    Button("Save") {
                                        print(self.name)
                                        self.createNewItem()
                                    }
            )
            .alert(isPresented: $isPresented) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            
        }
    }
    func createNewItem() {
        guard (self.name != "") else {
            wordError(title: "This name is invalid", message: "Please enter a valid name.")
            return
        }
        
        guard (self.type != "") else {
            wordError(title: "This type is invalid.", message: "Please enter a valid type.")
            return
        }
        
        guard (self.amount != "") else {
            wordError(title: "Amount field can not be empty.", message: "Please enter an amount")
            return
        }
        
        guard let actualAmount = Int(self.amount) else {
            wordError(title: "\(self.amount) is not an integer.", message: "Please enter a valid integer.")
            return
        }
        
        let expense = ExpenseItem(name: name, type: type, amount: actualAmount)
        
        expenses.items.append(expense)
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func wordError(title: String, message: String) {
        self.errorTitle = title
        self.errorMessage = message
        self.isPresented = true
    }
    
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
