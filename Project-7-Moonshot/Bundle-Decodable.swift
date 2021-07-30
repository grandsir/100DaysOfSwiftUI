//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Mehmet Atabey on 13.07.2021.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(file : String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Can not locate \(file) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to find \(file) from bundle")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle")
        }
        
       return loaded
    }
}
