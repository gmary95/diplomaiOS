//
//  ImageTransformater.swift
//  diplomaiOS
//
//  Created by GM on 16.12.2019.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

public struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

class ImageTransformater {
    private var image: UIImage
    private var context = CIContext(options: nil)
    
    init(image: UIImage) {
        self.image = image
    }
    
    public func convertToGrayscaleNoir() -> UIImage? {
        if let currentFilter = CIFilter(name: "CIPhotoEffectNoir") {
            currentFilter.setValue(CIImage(image: self.image), forKey: kCIInputImageKey)
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output,from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    return processedImage
                }
            }
        }
        return nil
    }
    
    public func convertImageToPixelsArray() -> [[PixelData]]? {
        guard let pixelsArr = self.image.pixelData() else { return nil }
        let width: Int = Int(self.image.size.width)
        let height: Int = Int(self.image.size.height)
        
        var newArr = [[PixelData]](repeating: [PixelData](repeating: PixelData(a: 0, r: 0, g: 0, b: 0), count: width + 2), count: height + 2)
        
        for i in 1 ..< height {
            for j in 1 ..< width {
                let index = (i * 4) + (j * 4)
                newArr[i][j] = PixelData(a: pixelsArr[index + 3], r: pixelsArr[index], g: pixelsArr[index + 1], b: pixelsArr[index + 2])
            }
        }
        return newArr
    }
}
