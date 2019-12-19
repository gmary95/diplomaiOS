//
//  FileHelper.swift
//  diplomaiOS
//
//  Created by GM on 19.12.2019.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

struct FileHelper {
    func writeToFile(array: [(key: Int, value: Int)], fileUrl: URL) {
        var text = ""
        for (key, value) in array {
            text += "\(key),\(value)\n"
        }
        do {
            try text.write(to: fileUrl, atomically: false, encoding: .utf8)
        }
        catch {
            print(error)
        }
    }
    
    func readImageModel(fileUrl: URL) -> [(key: Int, value: Int)]? {
        do {
            var result = [(key: Int, value: Int)]()
            let text = try String(contentsOf: fileUrl, encoding: .utf8)
            let array = text.split(separator: "\n")
            for item in array {
                let value = item.split(separator: ",").map { String($0) }
                if let firstValue = value.first, let lastValue = value.last {
                    result.append((key: Int(firstValue) ?? 0, value: Int(lastValue) ?? 0))
                }
            }
            return result
        }
        catch {
            print(error)
        }
        return nil
    }
}
