//
//  ContentView.swift
//  WeSplit
//
//  Created by GrandSir on 17.02.2021.
//

import SwiftUI

struct ModifiedSection : ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowBackground(LinearGradient(gradient: Gradient(colors: [Color(red: 240/255, green: 240/255, blue: 240/255), Color(red: 50/255, green: 0/255, blue: 30/255, opacity: 0.7)]), startPoint: .leading, endPoint: .trailing))
    }
}
extension View {
    func coloredSection() -> some View {
        self.modifier(ModifiedSection())
    }
}
struct ContentView: View {
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(red: 240, green: 240, blue: 240, alpha: 0.7)
    }
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentageIndex = 2
    let tipPercentages = [0,5,10,15,25]
    
    var grandTotal: Double {
        let tipSelection = Double(tipPercentages[tipPercentageIndex])
        let orderAmount = Double(checkAmount) ?? 0
        let tipValue = orderAmount / 100 * tipSelection
        return orderAmount + tipValue
    }
    
    var peopleCount: Double {
        return Double(Int(numberOfPeople) ?? 1)
    }
    
    var totalPerPerson: Double {
        return grandTotal / peopleCount
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter check amount", text: $checkAmount)
                        .keyboardType(.numberPad)
                }
                .coloredSection()
                
        
                Section {
                    TextField("Enter Number of people", text: $numberOfPeople)
                        .keyboardType(.numberPad)
                }
                .coloredSection()

                Section(header: Text("How much tip you want to leave")
                            .foregroundColor(.green)
                            .bold()
                    ) {
                    Picker("Percentage", selection: $tipPercentageIndex) {
                        ForEach (0..<tipPercentages.count) {
                            Text("\(tipPercentages[$0])%")
                        }
                        
                    }
                }
                .coloredSection()
                .textCase(nil) // This is for uppercase problem
                
                .pickerStyle(SegmentedPickerStyle())
                
                
                
                
                Section(header: Text("Total Amount")
                            .foregroundColor(tipPercentages[tipPercentageIndex] == 0 ? .red : tipPercentages[tipPercentageIndex] == 25 ? .green : .black))  { // Day 23 challange
                    Text("$\(grandTotal, specifier: "%.2f")")
                }
                .coloredSection()
                .textCase(nil)
                .foregroundColor(tipPercentages[tipPercentageIndex] == 0 ? .red : tipPercentages[tipPercentageIndex] == 25 ? .green : .black)
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                .coloredSection()
                .textCase(nil)

                
            }

    
            .navigationBarTitle(Text("WeSplit")
                                    .foregroundColor(.purple ))
            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
