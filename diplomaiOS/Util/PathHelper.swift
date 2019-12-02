//
//  PathHelper.swift
//  diplomaiOS
//
//  Created by GM on 02.12.2019.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

struct PathHelper {
    
    static func createPathInDocument(fileName: String) -> URL {
        let fileMngr = FileManager.default
        let documentsURL = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(try? fileMngr.contentsOfDirectory(atPath:documentsURL.path))
        
        return documentsURL.appendingPathComponent(fileName)
    }
}
