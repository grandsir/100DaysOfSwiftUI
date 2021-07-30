//
//  ContentView.swift
//  Moonshot
//
//  Created by Mehmet Atabey on 13.07.2021.
//

import SwiftUI

struct ContentView: View {
    static let astronauts: [Astronaut] = Bundle.main.decode(file: "astronauts.json")
    static let missions: [Mission] = Bundle.main.decode(file: "missions.json")

    let formattedMissions = Self.missions.map {
        $0.crew.map {
            $0.name
        }
    }
    
    @State private var showingCrew = false

    var body: some View {
        NavigationView {
            List(Self.missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: Self.astronauts)) {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                                .font(.headline)
                            
                            Text(showingCrew ? formattedMissions[Self.missions.firstIndex {$0.id == mission.id}!].joined(separator: ", ") : mission.formattedLaunchDate)
                    }
                }

            }
            .listStyle(PlainListStyle())
            .navigationBarItems(trailing:
                Button("\(showingCrew ? "Hide" : "Show") crew members") {
                    self.showingCrew.toggle()
                }

            )
            .navigationBarTitle("Moonshot")
          
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
