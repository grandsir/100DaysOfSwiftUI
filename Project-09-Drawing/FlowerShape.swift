//
//  FlowerShape.swift
//  Drawing
//
//  Created by Mehmet Atabey on 12.08.2021.
//

import SwiftUI

struct FlowerShape: Shape {
    var petalOffset : Double = -20
    var petalWidth: Double = 100

    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number + 90)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y:  0, width: CGFloat(petalWidth), height: rect.width / 2))
            
            let rotatedPetal = originalPetal.applying(position)
            
            path.addPath(rotatedPetal)
        }
        
        return path
    }
}


struct FlowerShape_Previews : PreviewProvider {
    static var previews: some View {
        FlowerView()
    }
}
