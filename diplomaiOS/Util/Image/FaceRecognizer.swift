//
//  FaceRecognizer.swift
//  diplomaiOS
//
//  Created by GM on 19.12.2019.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

struct FaceRecognizer {
    let eps = 50.0
    
    var modelHistogram: [(key: Int, value: Int)]
    var recognisionHistogram: [(key: Int, value: Int)]
    
    init(modelHistogram: [(key: Int, value: Int)], recognisionHistogram: [(key: Int, value: Int)]) {
        self.modelHistogram = modelHistogram
        self.recognisionHistogram = recognisionHistogram
    }
    
    func calculateDistance() -> Bool{
        if modelHistogram.count != recognisionHistogram.count {
            print("different size")
            return false
        }
        
        var sum = 0.0
        for i in 0 ..< modelHistogram.count {
                sum += pow(Double(modelHistogram[i].value - recognisionHistogram[i].value), 2.0)
        }
        sum = sqrt(sum)
        
        if sum >= eps {
            return true
        }
        return false
    }
}
