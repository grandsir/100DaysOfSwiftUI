//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Mehmet Atabey on 19.07.2021.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var observed : ObservableOrder
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var alertTitle = "Thank you"
    
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.observed.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(observed.order) else {
            print("failed to encode")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else {
                self.showError(title: "Woops, there is an error!", message: "No data in response: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(ObservableOrder.Order.self, from: data) {
                self.alertMessage = "Your order for \(decodedOrder.quantity)x \(ObservableOrder.Order.types[decodedOrder.type].lowercased()) cupcakes on the way!"
                self.showingAlert = true
            } else {
                print("Invalid response from server.")
            }
        }
        .resume()
        
    }
    
    func showError(title: String, message: String) {
        self.showingAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(observed: ObservableOrder())
    }
}
