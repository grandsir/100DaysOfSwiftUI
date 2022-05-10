//
//  Prospect.swift
//  HotProspects
//
//  Created by Mehmet Atabey on 6.08.2021.
//

import SwiftUI


class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "anonymous"
    var emailAdress = ""
    fileprivate(set) var isContacted = false
}


class Prospects: ObservableObject {
    @Published private(set) var people : [Prospect]
    static let saveKey = "savedData"
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        
        self.people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.setValue(encoded, forKey: Self.saveKey)
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add(_ prospect: Prospect) {
        self.people.append(prospect)
        save()
    }
}
