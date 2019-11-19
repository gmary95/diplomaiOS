//
//  Sound.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 10/1/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

public struct Header
{
    public var length: Int
}

class Sound
{
    public var header: Header
    public var arr: [Int]
    public var arrWhithoutLatentPeriods: [Int]?
    public var normalizationArr: [Double]?
    public var melRepresentation: [[Double]]?
    public var countOfLines: Int?
    
    init(header: Header, arr: [Int]) {
        self.header = header
        self.arr = arr
    }
}
