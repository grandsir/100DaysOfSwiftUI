//
//  Person.swift
//  Milestone-projects-13-15
//
//  Created by Mehmet Atabey on 2.08.2021.
//

import Foundation
import SwiftUI

struct Person : Codable, Identifiable, Comparable {
    var id : UUID
    var name: String
    var longtiude : Double?
    var latitude : Double?

    
    static func < (lhs: Person, rhs: Person) -> Bool {
        return lhs.name < rhs.name
    }

    
    var image : Image? {
        let path = FileManager.default.getDocumentsDirectory.appendingPathComponent(id.uuidString + ".jpg").path
        if let uiImage = UIImage(contentsOfFile: path) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}


