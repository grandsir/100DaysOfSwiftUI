//
//  Card.swift
//  Flashzilla
//
//  Created by Mehmet Atabey on 8.08.2021.
//

import Foundation


struct Card : Codable {
    let prompt: String
    let answer: String
    
    static var example : Card {
        Card(prompt: "Sample Text", answer: "Answer")
    }
}
 
