//
//  ColorCyclingCircleView.swift
//  Drawing
//
//  Created by Mehmet Atabey on 13.08.2021.
//

import SwiftUI

struct ColorCyclingCircleView: View {
    @State private var colorCycle = 0.0
    var body: some View {
        VStack {
            ColorCyclingCircle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            
            Slider(value: $colorCycle)
                .padding()
        }
    }
}

struct ColorCyclingCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCyclingCircleView()
    }
}
