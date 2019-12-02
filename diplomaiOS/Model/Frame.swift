//
//  Frame.swift
//  diplomaiOS
//
//  Created by GM on 02.12.2019.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

class Frame {
    let MFCC_SIZE = 12
    let MFCC_FREQ_MIN = 300
    let MFCC_FREQ_MAX = 4000
    
    var sourceNormalized: [Double]
    var start: Int
    var finish: Int
    var mfcc: [Double]? = nil
    
    init(sourceNormalized: [Double], start: Int, finish:Int) {
        self.sourceNormalized = sourceNormalized
        self.start = start
        self.finish = finish
    }
    
    func initMFCC(source: [Double], start: Int, finish: Int, freq: Int) -> [Double] {
        self.mfcc = MelCharacteristicsManager.shared.transform(source: source, start: start, finish: finish, mfccSize: MFCC_SIZE, frequency: freq, freqMin: UInt32(MFCC_FREQ_MIN), freqMax: UInt32(MFCC_FREQ_MAX))
        return self.mfcc!
    }
}
