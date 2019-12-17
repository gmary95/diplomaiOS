//
//  LocalBinaryPatterns.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 12/15/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

class LocalBinaryPatternsManager {
    static var shared: LocalBinaryPatternsManager = {
        let instance = LocalBinaryPatternsManager()
        return instance
    }()
    
    public func sratrProccess(matrix: [[UInt8]]) -> Int {
        let arr = transform(matrix: matrix)
        let binaryArr = transform(array: arr)
        let num = binaryToInt(binaryArr: binaryArr)
        return num
    }
    
    private func transform(matrix: [[UInt8]]) -> [UInt8] {
        return matrix.flatMap { $0 }
    }
    
    private func transform(array: [UInt8]) -> [UInt8] {
        var newMatrix = [UInt8]()
        let middleIndex = array.count == 0 ? 0 : (array.count / 2) - 1
        let threshold = array[middleIndex]
        for i in 0 ..< array.count {
            if i != middleIndex {
                newMatrix.append(returnBinaryCode(threshold: threshold, value: array[i]))
            }
        }
        return newMatrix
    }
    
    private func returnBinaryCode(threshold: UInt8, value: UInt8) -> UInt8 {
        if value >= threshold {
            return 1
        } else {
            return 0
        }
    }
    
    private func binaryToInt(binaryArr: [UInt8]) -> Int {
        let binary: String = (binaryArr.map { String($0) }).joined(separator: "")
        if let number = Int(binary, radix: 2) {
           return number
        }
        return 0
    }
}
