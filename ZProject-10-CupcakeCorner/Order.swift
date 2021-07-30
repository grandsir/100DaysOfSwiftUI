//
//  Order.swift
//  CupcakeCorner
//
//  Created by Mehmet Atabey on 18.07.2021.
//

import Foundation



class ObservableOrder : ObservableObject {
    struct Order : Codable {
        static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
        
        var type = 0
        var quantity = 3
        
        var specialRequestEnabled = false  {
            didSet {
                extraFrosting = false
                addSprinkles = false
            }
        }
        var extraFrosting = false
        var addSprinkles = false

        var name = ""
        var streetAdress = ""
        var city = ""
        var zip = ""
        
        var hasValidAddress : Bool {
            return !(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAdress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        
        var cost: Double {
            var cost = Double(quantity) * 2
            cost += Double(type) / 2
            
            if extraFrosting {
                cost += Double(quantity)
            }
            
            if addSprinkles {
                cost += Double(quantity) / 2
            }
            
            return cost
            
        }
    }
    @Published var order = Order()
}
