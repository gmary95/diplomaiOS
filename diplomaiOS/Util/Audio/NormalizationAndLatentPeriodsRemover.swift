//
//  NormalizationAndLatentPeriodsRemover.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 10/1/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

struct NormalizationAndLatentPeriodsRemover {
    static public func removeLatentPeriods(sound: Sound) -> Sound {
        let sqrtVarience = sqrt(calcVariance(arr: sound.arr))
        let coef = 1.0 / 3.0
        var isFinish = false
        let soundWithoutLatentPeriod = Sound(header: sound.header, arr: [Int16]())
        for i in 0 ..< sound.arr.count{
            soundWithoutLatentPeriod.arr.append(sound.arr[i])
        }
        
        for _ in 0 ..< soundWithoutLatentPeriod.arr.count {
            if (!isFinish)
            {
                if (soundWithoutLatentPeriod.arr[0] >= Int(coef * sqrtVarience) || soundWithoutLatentPeriod.arr[0] <= Int(-coef * sqrtVarience))
                {
                    isFinish = true
                }
                else
                {
                    soundWithoutLatentPeriod.arr.remove(at: 0)
                }
            }
        }
        isFinish = false
        for _ in (0 ..< soundWithoutLatentPeriod.arr.count - 1).reversed()
        {
            if (!isFinish)
            {
                if (soundWithoutLatentPeriod.arr[soundWithoutLatentPeriod.arr.count - 1] >= Int(coef * sqrtVarience) || soundWithoutLatentPeriod.arr[soundWithoutLatentPeriod.arr.count - 1] <= Int(-coef * sqrtVarience))
                {
                    isFinish = true
                }
                else
                {
                    soundWithoutLatentPeriod.arr.remove(at: soundWithoutLatentPeriod.arr.count - 1)
                }
            }
        }
        return soundWithoutLatentPeriod
    }
    
    // Need sound without latent period
    static public func normalization(sound: Sound) -> [Double] {
        let soundArr: [Int16] = Array(sound.arr[3 ..< sound.arr.count])
        let newSound = removeLatentPeriods(sound: Sound(header: sound.header, arr: soundArr))
        let varience = calcVariance(arr: newSound.arr)
        var normalizationArr = [Double]()
        for item in newSound.arr
        {
            normalizationArr.append(Double(item) / sqrt(varience))
        }
        return normalizationArr
    }
    
    
    static public func calcVariance(arr: [Int16]) -> Double {
        var varience = 0.0
        for i in 0 ..< arr.count {
            varience += pow(Double(arr[i]), 2)
        }
        varience /= Double(arr.count)
        return varience
    }
}
