//
//  ContentView.swift
//  Day-24-Challange
//
//  Created by GrandSir on 20.02.2021.
//

import SwiftUI

struct TitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
            .scaleEffect(1.2)

    }
}

extension View {
    func blueTitle() -> some View {
        self.modifier(TitleText())
    }
}


struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .blueTitle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
