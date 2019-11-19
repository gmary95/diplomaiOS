//
//  NormalizationAndLatentPeriodsRemover.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 10/1/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

struct NormalizationAndLatentPeriodsRemover {
    static public func removeLatentPeriods(sound: Sound) {
        let sqrtVarience = sqrt(CalcVariance(arr: sound.arr))
        let coef = 1.0 / 3.0
        var isFinish = false
        sound.arrWhithoutLatentPeriods = [Int]()
        for i in 0 ..< sound.arr.count{
            sound.arrWhithoutLatentPeriods!.append(sound.arr[i])
        }
        
        for _ in 0 ..< sound.arrWhithoutLatentPeriods!.count {
            if (!isFinish)
            {
                if (sound.arrWhithoutLatentPeriods![0] >= Int(coef * sqrtVarience) || sound.arrWhithoutLatentPeriods![0] <= Int(-coef * sqrtVarience))
                {
                    isFinish = true
                }
                else
                {
                    sound.arrWhithoutLatentPeriods!.remove(at: 0)
                }
            }
        }
        isFinish = false
        for _ in (0 ..< sound.arrWhithoutLatentPeriods!.count - 1).reversed()
        {
            if (!isFinish)
            {
                if (sound.arrWhithoutLatentPeriods![sound.arrWhithoutLatentPeriods!.count - 1] >= Int(coef * sqrtVarience) || sound.arrWhithoutLatentPeriods![sound.arrWhithoutLatentPeriods!.count - 1] <= Int(-coef * sqrtVarience))
                {
                    isFinish = true
                }
                else
                {
                    sound.arrWhithoutLatentPeriods!.remove(at: sound.arrWhithoutLatentPeriods!.count - 1)
                }
            }
        }
    }
    
    static public func normalization(sound: Sound){
        let varience = CalcVariance(arr: sound.arrWhithoutLatentPeriods!)
        sound.normalizationArr = [Double]()
        for item in sound.arrWhithoutLatentPeriods!
        {
            sound.normalizationArr!.append(Double(item) / sqrt(varience))
        }
    }
    
    
    static public func CalcVariance(arr: [Int]) -> Double {
        var varience = 0.0
        for i in 0 ..< arr.count {
            varience += pow(Double(arr[i]), 2) //arr.Count;
        }
        varience /= Double(arr.count)
        return varience
    }
}
