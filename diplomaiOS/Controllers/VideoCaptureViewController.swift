//
//  VideoCaptureViewController.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 9/8/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import UIKit
import MobileCoreServices

class VideoCaptureViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton?
    
    var controller = UIImagePickerController()
    let videoFileName = "/video.mp4"
    let maxVideoTimeInSeconds: TimeInterval = 60 * 3
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func startRecordVideo(_ sender: UIButton) {
        // 1 Check if project runs on a device with camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // 2 Present UIImagePickerController to take video
            controller.sourceType = .camera
            controller.mediaTypes = [kUTTypeMovie as String]
            controller.videoMaximumDuration = maxVideoTimeInSeconds
            controller.delegate = self
            
            present(controller, animated: true, completion: nil)
        }
        else {
            print("Camera is not available")
        }
    }
    
    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
            })
        }
    }
}

extension VideoCaptureViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            // Save video to the main photo album
            let selectorToCall = #selector(VideoCaptureViewController.videoSaved(_:didFinishSavingWithError:context:))
            
            // 2
            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
            // Save the video to the app directory
            let videoData = try? Data(contentsOf: selectedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
            try! videoData?.write(to: dataPath, options: [])
        }
        // 3
        picker.dismiss(animated: true)
    }
}

extension VideoCaptureViewController: UINavigationControllerDelegate {
}
