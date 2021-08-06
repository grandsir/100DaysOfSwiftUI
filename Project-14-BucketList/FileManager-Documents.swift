//
//  FileManager-Documents.swift
//  BucketList
//
//  Created by Mehmet Atabey on 2.08.2021.
//
import SwiftUI

extension FileManager {
    var getDocumentsDirectory : URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func fileNameInDocumentsDirectory(_ file: String) -> URL {
        return self.getDocumentsDirectory.appendingPathComponent(file)
    }
}
