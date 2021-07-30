//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Mehmet Atabey on 17.07.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var observed = ObservableOrder()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $observed.order.type) {
                        ForEach (0..<ObservableOrder.Order.types.count) {
                            Text(ObservableOrder.Order.types[$0])
                        }
                    }
                    Stepper(value: $observed.order.quantity, in: 3...20) {
                        Text("number of cakes \(observed.order.quantity)")
                    }
                }
                Section {
                    Toggle(isOn: $observed.order.specialRequestEnabled.animation()) {
                        Text("Any Special Request?")
                    }
                    if observed.order.specialRequestEnabled {
                        Toggle(isOn: $observed.order.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $observed.order.addSprinkles) {
                            Text("Add sprinkles")
                        }
                    }
                        
                }
                Section {
                    NavigationLink(destination: AddressView(observed: observed)) {
                        Text("Delivery Details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
