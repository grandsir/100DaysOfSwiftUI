//
//  Result.swift
//  BucketList
//
//  Created by Mehmet Atabey on 3.08.2021.
//

import Foundation


struct Result : Codable {
    let query : Query
}


struct Query: Codable {
    let pages: [Int: Page]
}

struct Page : Codable, Comparable {
    let pageId: Int
    let title: String
    let terms : [String : [String]]?
    
    var description : String {
        terms?["description"]?.first ?? "No Further Information"
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
