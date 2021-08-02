//
//  MissionView.swift
//  Moonshot
//
//  Created by Mehmet Atabey on 14.07.2021.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role : String
        let astronaut : Astronaut
    }
    
    let allMissions: [Mission] = Bundle.main.decode(file: "missions.json")
    let mission : Mission
    let astronauts: [CrewMember]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.65)
                        .padding(.top)
                    
                    Text("Launch date: \(self.mission.formattedLaunchDate)")
                        .multilineTextAlignment(.leading)
                        .font(.headline)
                    
                    Text(self.mission.description)
                        .layoutPriority(1)
                        .padding()
                    
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination:AstronautView(astronaut: crewMember.astronaut, missions: allMissions)){
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                            }
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundColor(Color.primary)
                                    .font(.headline)
                                
                                Text(crewMember.role)
                                    .foregroundColor(Color.secondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        
        for member in mission.crew {
            if let match = astronauts.first(where: {$0.id == member.name}) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            }
            else {
                fatalError("Can not find \(member)")
            }
        }
        self.astronauts = matches
    }
}


struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode(file: "missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode(file: "astronauts.json")
    static var previews: some View {
        MissionView(mission: missions[4], astronauts: astronauts)
    }
}
