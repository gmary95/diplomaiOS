//
//  File.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 9/8/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class VideHelper {
    
    func generateThumnail(url : URL, fromTime:Float64) -> UIImage {
        let asset: AVAsset = AVAsset(url: url)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter = CMTime.zero
        assetImgGenerate.requestedTimeToleranceBefore = CMTime.zero
        let time: CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale: 600)
        let img: CGImage = try! assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        let frameImg: UIImage = UIImage(cgImage: img)
        return frameImg
    }
    
    
}
