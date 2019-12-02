
//
//  MelCharacteristicsManager.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 12/1/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

class MelCharacteristicsManager {
    static var shared: MelCharacteristicsManager = {
        let instance = MelCharacteristicsManager()
        return instance
    }()
    
    func transform(source: [Double], start: Int, finish: Int, mfccSize: Int, frequency: Int, freqMin: UInt32, freqMax: UInt32) -> [Double] {
        let sampleLength = finish - start + 1
        
        let fourierRaw = fourierTransformation(source: source, length: start, start: sampleLength)
        let melFilters = getMelFilters(freqMin: freqMin, freqMax: freqMax, mfccSize: mfccSize, frequency: UInt32(frequency), filterLength: UInt32(sampleLength))
        let logPower = calcPower(mfccCount: mfccSize, fourierLength: sampleLength, melFilters: melFilters, fourierRaw: fourierRaw)
        let dctRaw = dctTransform(length: mfccSize, data: logPower)
        
        return dctRaw
    }
}

extension MelCharacteristicsManager {
    func getMelFilters(freqMin: UInt32, freqMax: UInt32, mfccSize: Int, frequency: UInt32, filterLength: UInt32) -> [[Double]] {
        var fb = [Double](repeating: 0.0, count: mfccSize + 2)
        fb[0] = convertToMel(f: Double(freqMin))
        fb[mfccSize + 1] = convertToMel(f: Double(freqMax))
        
        for m in 1 ..< mfccSize + 1 {
            let tmp: Double = (fb[mfccSize + 1] - fb[0])
            fb[m] = fb[0] + Double(m) * tmp / Double(mfccSize + 1)
        }
        
        for m in 0 ..< mfccSize + 2 {
            fb[m] = convertFromMel(m: fb[m])
            fb[m] = floor(Double(filterLength + 1) * fb[m] / Double(frequency))
        }
        
        var filterBanks: [[Double]] = [[Double]](repeating: [Double](repeating: 0.0, count: Int(filterLength)), count: mfccSize)
        
        for m in 1 ..< mfccSize + 1 {
            for k in 0 ..< Int(filterLength) {
                if (fb[m - 1] <= Double(k) && Double(k) <= fb[m]) {
                    filterBanks[m - 1][k] = (Double(k) - fb[m - 1]) / (fb[m] - fb[m - 1])
                    
                } else if (fb[m] < Double(k) && Double(k) <= fb[m + 1]) {
                    filterBanks[m - 1][k] = (fb[m + 1] - Double(k)) / (fb[m + 1] - fb[m])
                    
                } else {
                    filterBanks[m - 1][k] = 0.0
                }
            }
        }
        
        return filterBanks
    }
    
    func calcPower(mfccCount: Int, fourierLength: Int, melFilters: [[Double]], fourierRaw: [Double]) -> [Double] {
        var logPower = [Double](repeating: 0.0, count: mfccCount)
        for m in 0 ..< mfccCount {
            for k in 0 ..< fourierLength {
                logPower[m] += melFilters[m][k] * pow(fourierRaw[k], 2)
            }
            
            logPower[m] = log(logPower[m])
        }
        
        return logPower
    }
    
    func dctTransform(length: Int, data: [Double]) -> [Double] {
        var dctTransform = [Double](repeating: 0.0, count: length)
        
        for n in 0 ..< length {
            for m in 0 ..< length {
                let tmp = Double.pi * Double(n) * (Double(m) + 1.0 / 2.0) / Double(length)
                dctTransform[n] += data[m] * cos(tmp)
            }
        }
        
        return dctTransform
    }
    
    
    // Mel convertors
    func convertToMel(f: Double) -> Double {
        return 1127.0 * log(1.0 + f/700.0)
    }
    
    func convertFromMel(m: Double) -> Double {
        return 700.0 * (exp(m/1127.0) - 1.0)
    }
}

extension MelCharacteristicsManager {
    func fourierTransformation(source: [Double], length: Int, start: Int, useWindow: Bool = true) -> [Double] {
        var fourierCmplxRaw = [Complex<Double>]()
        var fourierRaw = [Double](repeating: 0.0, count: length)
        
        for k in 0 ..< length {
            fourierCmplxRaw.append(Complex(0, 0))
            for n in 0 ..< length {
                let sample = source[start + n]
                
                let tmp = -2.0 * Double.pi * Double(k) * Double(n)
                let x = tmp / Double(length)
                let f = sample * Complex(cos(x), sin(x))
                
                var w = 1.0
                if (useWindow) {
                    let tmp = 2 * Double.pi * Double(n)
                    w = 0.54 - 0.46 * cos(tmp / Double(length - 1))
                }
                
                fourierCmplxRaw[k] += f * w
            }
            
            fourierRaw[k] = sqrt(fourierCmplxRaw[k].norm)
        }
        
        return fourierRaw
    }
}
