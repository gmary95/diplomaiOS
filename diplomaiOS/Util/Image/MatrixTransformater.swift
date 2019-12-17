//
//  MatrixTransformater.swift
//  diplomaiOS
//
//  Created by GM on 17.12.2019.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

class MatrixTransformater {
    private var matrix: [[UInt8]]
    
    init(matrix: [[UInt8]]) {
        self.matrix = matrix
    }
    
    public func getCharacteristicsMatrix() -> [[Int]] {
        var newMatrix = [[Int]](repeating: [Int](repeating: 0, count: matrix[0].count - 2), count: matrix.count - 2)
        for i in 1 ..< matrix.count - 1 {
            for j in 1 ..< matrix[i].count - 1 {
                newMatrix[i - 1][j - 1] = createNewValue(i: i, j: j)
            }
        }
        return newMatrix
    }
    
    private func createNewValue(i: Int, j: Int) -> Int {
        let subMatrix = getSubmatrix(self.matrix, i0: i - 1, i1: i + 1, j0: j - 1, j1: j + 1)
        return LocalBinaryPatternsManager.shared.sratrProccess(matrix: subMatrix)
    }
    
    private func getSubmatrix(_ matrix: [[UInt8]], i0: Int, i1: Int, j0: Int, j1: Int) -> [[UInt8]] {
        var result = [[UInt8]]()

        for row in Array(matrix[i0...i1]) {
             result.append(Array(row[j0...j1]))
        }

        return result
    }
}
