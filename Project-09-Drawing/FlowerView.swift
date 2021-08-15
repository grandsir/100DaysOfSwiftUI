//
//  FlowerView.swift
//  Drawing
//
//  Created by Mehmet Atabey on 12.08.2021.
//

import SwiftUI

struct FlowerView: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    var body: some View {
        VStack {
            FlowerShape(petalOffset: petalOffset, petalWidth: petalWidth)
                .fill(Color.red, style: FillStyle(eoFill: true))
            Text("Offset")
            
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])
            
            Text("Width")
            
            Slider(value: $petalWidth, in: 0...100)
                .padding([.horizontal, .bottom])

            
        }
    }
}

struct FlowerView_Previews: PreviewProvider {
    static var previews: some View {
        FlowerView()
    }
}
