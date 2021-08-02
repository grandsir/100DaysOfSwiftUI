//
//  Mission.swift
//  Moonshot
//
//  Created by Mehmet Atabey on 13.07.2021.
//

import Foundation


struct Mission : Codable, Identifiable {
    struct CrewRole: Codable {
        let name : String
        let role: String
    }

    let id : Int
    let launchDate: Date?
    let crew : [CrewRole]
    let description : String
    
    var displayName : String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        if let launchdate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchdate)
        }
        else {
            return "N/A"
        }
    }
}

