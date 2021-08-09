//
//  ImageTab.swift
//  Moonshot
//
//  Created by Mehmet Atabey on 14.07.2021.
//

import SwiftUI

struct ImageTab: View {
    let crewMember : MissionView.CrewMember
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Text(crewMember.astronaut.name)
                    .font(.headline)
                
                Text(crewMember.role)
                    .foregroundColor(Color.secondary)
            }
            
            Image(crewMember.astronaut.id)
            
        }
    }
}
