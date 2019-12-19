//
//  Histogram.swift
//  diplomaiOS
//
//  Created by GM on 18.12.2019.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

class Histogram {
    private var data: Dictionary<Int,Int>
    private var sortedData: [(key: Int, value: Int)]
    
    init() {
        data = Dictionary<Int,Int>()
        sortedData = [(key: Int, value: Int)]()
    }
    
    func calculate(matrix: [[Int]]) -> [(key: Int, value: Int)] {
        let keys = createArray(from: 0, delta: 1, count: 256)
        let values = createArray(from: 0, delta: 0, count: 256)
        self.data = Dictionary(uniqueKeysWithValues: zip(keys, values))
        
        for i in 0 ..< matrix.count {
            for j in 0 ..< matrix[i].count {
                let item = matrix[i][j]
                let arrayOfKeys = data.keys
                if arrayOfKeys.contains(item) {
                    data[item]! += 1
                } else {
                    data[item] = 1
                }
            }
        }
        
        sortedData = data.sorted(by: { $0.0 < $1.0 })
        return sortedData
    }
    
    private func createArray(from: Int, delta: Int, count: Int) -> [Int] {
        var arr = [Int](repeating: 0, count: count)
        for i in 1 ..< count {
            arr[i] = arr[i - 1] + delta
        }
        return arr
    }
}
