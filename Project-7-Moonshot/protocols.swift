//
//  protocols.swift
//  Moonshot
//
//  Created by Mehmet Atabey on 13.07.2021.
//

import Foundation


protocol Decodablee : Identifiable, Codable {
    var id: UUID { get }
}
