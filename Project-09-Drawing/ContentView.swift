//
//  ContentView.swift
//  Drawing
//
//  Created by Mehmet Atabey on 15.07.2021.
//

import SwiftUI


struct ContentView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]

    }
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink("Flower", destination: FlowerView())
                }
                
                Section {
                    NavigationLink("Circle", destination: ColorCyclingCircleView())
                }
                
                Section {
                    NavigationLink("Spirograph", destination: SpirographView())
                }
            }
            .navigationBarTitle("Drawing")
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.dark)
    }
}
