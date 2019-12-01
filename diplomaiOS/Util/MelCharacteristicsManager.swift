
//
//  MelCharacteristicsManager.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 12/1/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

class MelCharacteristicsManager {
    func fourierTransform(frame: [Double], k: Int) -> Double {
        var result = 0.0
        for n in 0 ..< frame.count {
            result += frame[n] * pow(M_E, w(k: k, N: frame.count) * n)
        }
        return result
    }
    
    func hammingTransform(n: Double, frameSize: Double) -> Double {
        return 0.54 - 0.46 * cos((2 * Double.pi * n) / (frameSize - 1))
    }
    
    func transform(frame: [Double], index: Int) -> Double {
        return fourierTransform(frame: frame, k: index) * hammingTransform(n: Double(index), frameSize: Double(frame.count))
    }
}

extension MelCharacteristicsManager {
    /// <summary>
    /// Вычисление поворачивающего модуля e^(-i*2*PI*k/N)
    /// </summary>
    /// <param name="k"></param>
    /// <param name="N"></param>
    /// <returns></returns>
    func w(k: Int, N: Int) -> Complex {
        if (k % N == 0) {
            return 1.0
        }
        
        let arg = -2 * Double.pi * Double(k) / Double(N)
        return Complex(Math.Cos(arg), Math.Sin(arg))
    }
}
