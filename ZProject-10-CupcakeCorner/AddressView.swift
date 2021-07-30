//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Mehmet Atabey on 19.07.2021.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var observed : ObservableOrder
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $observed.order.name)
                TextField("Street Adress", text: $observed.order.streetAdress)
                TextField("City", text: $observed.order.city)
                TextField("Zip", text: $observed.order.zip)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(observed: observed)) {
                    Text("Check out")
                }
            }
            .disabled(observed.order.hasValidAddress == false)

        }
        .navigationBarTitle("Delivery Details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(observed: ObservableOrder())
    }
}
