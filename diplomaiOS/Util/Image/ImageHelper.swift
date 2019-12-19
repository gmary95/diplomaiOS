//
//  ImageHelper.swift
//  diplomaiOS
//
//  Created by GM on 19.12.2019.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

struct ImageHelper {
    let times = 8
    
    func preprocessing(fileName: String, time: Int) -> [(key: Int, value: Int)]? {
        let imageFromVideo = VideoConverter.imageFromVideo(url: PathHelper.createPathInDocument(fileName: fileName), at: TimeInterval(time))
        if let detectedImage = detect(image: imageFromVideo){
            var histogram = [(key: Int, value: Int)]()
            let imageTitles = self.divide(image: detectedImage)
            
            for i in 0 ..< imageTitles.count {
                for j in 0 ..< imageTitles[i].count {
                    if let h = startProcess(image: imageTitles[i][j]) {
                        histogram.append(contentsOf: h)
                    }
                }
            }
            
            return histogram
        }
        return nil
    }
    
    func startProcess(image: UIImage) -> [(key: Int, value: Int)]? {
        guard let grayImage = ImageTransformater(image: image).convertToGrayscaleNoir() else { return nil}
        guard let pixels = ImageTransformater(image: grayImage).convertImageToPixelsArray() else { return nil}
        let intensityArr: [[UInt8]] = pixels.map{ $0.map{ return $0.r } }
        let characteristicsMatrix = MatrixTransformater(matrix: intensityArr).getCharacteristicsMatrix()
        
        let histogram = Histogram().calculate(matrix: characteristicsMatrix)
        return histogram
    }
    
    private func detect(image: UIImage?) -> UIImage? {
        let imageOptions =  NSDictionary(object: NSNumber(value: 5) as NSNumber, forKey: CIDetectorImageOrientation as NSString)
        let personciImage = CIImage(cgImage: image!.cgImage!)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector!.features(in: personciImage, options: imageOptions as? [String : AnyObject])
        
        if let face = faces.first as? CIFaceFeature {
            print("found bounds are \(face.bounds)")
            
            let croppedImage = personciImage.cropped(to: face.bounds)
            
            if face.hasSmile {
                print("face is smiling")
            }
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
            
            
            return convert(cmage: croppedImage)
            
            
        } else {
             print("not found face")
//            let alert = UIAlertController(title: "No Face!", message: "No face was detected", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
        return nil
    }
    
    private func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    private func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
    private func printMatrix(matrix: [[Int]]) {
        var str = ""
        for i in 0 ..< matrix.count {
            for j in 0 ..< matrix[i].count {
                str += matrix[i][j].description + ", "
            }
            str += "$\n"
        }
        print(str)
    }
    
    private func getSubmatrix(_ matrix: [[Int]], i0: Int, i1: Int, j0: Int, j1: Int) -> [[Int]] {
        var result = [[Int]]()

        for row in Array(matrix[i0...i1]) {
             result.append(Array(row[j0...j1]))
        }

        return result
    }
    
    private func divide(image: UIImage) -> [[UIImage]] {
        let height =  (image.size.height) /  CGFloat (times) //height of each image tile
        let width =  (image.size.width)  / CGFloat (times)  //width of each image tile
        
        let scale = (image.scale) //scale conversion factor is needed as UIImage make use of "points" whereas CGImage use pixels.
        
        var imageArr = [[UIImage]]() // will contain small pieces of image
        for y in 0 ..< times {
            var yArr = [UIImage]()
            for x in 0 ..< times {
                
                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width:width, height:height),
                    false, 0)
                let i =  image.cgImage?.cropping(to:  CGRect.init(x: CGFloat(x) * width * scale, y:  CGFloat(y) * height * scale  , width: (width * scale) , height: (height * scale)) )
                
                let newImg = UIImage.init(cgImage: i!)
                
                yArr.append(newImg)
                
                UIGraphicsEndImageContext()
            }
            imageArr.append(yArr)
        }
        return imageArr
    }
}
