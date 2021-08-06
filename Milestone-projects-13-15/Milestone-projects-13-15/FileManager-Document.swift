//
//  FileManager-Document.swift
//  Milestone-projects-13-15
//
//  Created by Mehmet Atabey on 4.08.2021.
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
