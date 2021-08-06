//
//  PersonView.swift
//  Milestone-projects-13-15
//
//  Created by Mehmet Atabey on 4.08.2021.
//

import SwiftUI

struct PersonView: View {
    var person: Person
    @State private var selection = 1
    
    var body: some View {
        VStack {
            Picker("hello", selection: $selection) {
                Text("Placeholder").tag(1)
                Text("Location").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            if selection == 1 {
                HStack(alignment:.top) {
                    Text(person.name)
                        .font(.system(size: 45))
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .padding()
                }
                
                person.image?
                    .resizable()
                    .scaledToFit()
                Spacer()

            }
            else {
                if person.latitude != nil {
                    MapView(latiude: person.latitude!, longiude: person.longtiude!)
                        .edgesIgnoringSafeArea(.all)
                }
                else {
                    Spacer()
                    Text("There isn't any information about Location.")
                    Spacer()
                }
            }
            
        }
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(person: Person(id: UUID(), name: "test", longtiude: 124.0, latitude: 14.3))
        
    }
}
