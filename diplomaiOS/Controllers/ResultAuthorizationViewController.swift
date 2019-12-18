//
//  ResultAuthorizationViewController.swift
//  diplomaiOS
//
//  Created by GM on 10/1/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import UIKit

class ResultAuthorizationViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultMessageLabel: UILabel!
    
    var isSuccess = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isSuccess {
            let imageFromVideo = VideoConverter.imageFromVideo(url: PathHelper.createPathInDocument(fileName: "/video.mp4"), at: 2)
            imageView.image = UIImage(named: "ic_failed")
            resultMessageLabel.text = "Your authorization is failed!"
            resultMessageLabel.textColor = .red
            
            if let detectedImage = detect(image: imageFromVideo){
                guard let grayImage = ImageTransformater(image: detectedImage).convertToGrayscaleNoir() else { return }
                guard let pixels = ImageTransformater(image: grayImage).convertImageToPixelsArray() else { return }
                let intensityArr: [[UInt8]] = pixels.map{ $0.map{ return $0.r } }
                let characteristicsMatrix = MatrixTransformater(matrix: intensityArr).getCharacteristicsMatrix()
                let submatrix = getSubmatrix(characteristicsMatrix, i0: 0, i1: 9, j0: 0, j1: 9)
                let histogram = Histogram().calculate(matrix: submatrix)
                
                let imageView = UIImageView(image: grayImage)
                imageView.contentMode = .scaleAspectFit
                imageView.frame = self.view.bounds
                imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.view.addSubview(imageView)
            }
            
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: UIImage?) -> UIImage? {
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
            let alert = UIAlertController(title: "No Face!", message: "No face was detected", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return nil
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
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
    
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
    func printMatrix(matrix: [[Int]]) {
        var str = ""
        for i in 0 ..< matrix.count {
            for j in 0 ..< matrix[i].count {
                str += matrix[i][j].description + ", "
            }
            str += "$\n"
        }
        print(str)
    }
    
    func getSubmatrix(_ matrix: [[Int]], i0: Int, i1: Int, j0: Int, j1: Int) -> [[Int]] {
        var result = [[Int]]()

        for row in Array(matrix[i0...i1]) {
             result.append(Array(row[j0...j1]))
        }

        return result
    }
}
