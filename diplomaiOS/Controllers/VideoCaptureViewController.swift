//
//  VideoCaptureViewController.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 9/8/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit

class VideoCaptureViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var startButton: UIButton?
    
    var controller = UIImagePickerController()
    let videoFileName = "/video.mp4"
    let audioFileName = "/sample_audio.m4a"
    let audioWAVFileName = "/sample_audio.wav"
    let maxVideoTimeInSeconds: TimeInterval = 3
    
    var urlVideo: URL? = nil
    
    let audioManager = AudioManager.shared
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        let url = PathHelper.createPathInDocument(fileName: audioFileName)
        let urlWAV = PathHelper.createPathInDocument(fileName: audioWAVFileName)
        
        audioManager.convertAudio(url, outputURL: urlWAV)
        
        guard let file = audioManager.bytesFromFile(filePath: urlWAV.path) else {
            return
        }

        let intArray = audioManager.convertAudioBytesToAmplitude(data: file)
        let originalSound = Sound(header: Header(sampleRate: Int(audioManager.sampleRate)), arr: intArray)
        
        let soundWithoutLatentPeriod = NormalizationAndLatentPeriodsRemover.removeLatentPeriods(sound: originalSound)
        let soundNorm = NormalizationAndLatentPeriodsRemover.normalization(sound: soundWithoutLatentPeriod)
        
        let start = 0
        let finish = soundNorm.count - 1
        let mfcc = Frame(sourceNormalized: soundNorm, start: start, finish: finish).initMFCC(source: soundNorm, start: start, finish: finish, freq: Int(audioManager.sampleRate))
        
        print(mfcc)
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
        var videoAsset: AVAsset!
        let newAudioAsset = AVMutableComposition()
        let dstCompositionTrack = newAudioAsset.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        // 1 - Get media type
        let mediaType = info[.mediaType] as? String
        
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! NSURL
        let videoData = NSData(contentsOf: videoURL as URL)
        let dataPath = PathHelper.createPathInDocument(fileName: videoFileName)

        videoData?.write(to: dataPath, atomically: false)
        
        // 2 - Dismiss image picker
        dismiss(animated: true)
        
        // 3 - Handle video selection
        if CFStringCompare(mediaType as CFString?, kUTTypeMovie, []) == .compareEqualTo {
            if let object = info[.mediaURL] as? URL {
                videoAsset = AVAsset(url: object)
            }
            //  NSLog(@"track = %@",[videoAsset tracksWithMediaType:AVMediaTypeAudio]);
            
            let trackArray = videoAsset.tracks(withMediaType: .audio)
            if trackArray.count == 0 {
                print("Track returns empty array for mediatype AVMediaTypeAudio")
                return
            }
            
            let srcAssetTrack = trackArray[0]
            
            //Extract time range
            let timeRange = srcAssetTrack.timeRange
            var err: Error? = nil
            do {
                if try dstCompositionTrack?.insertTimeRange(timeRange, of: srcAssetTrack, at: .zero) == nil {
                    print("Failed to insert audio from the video to mutable avcomposition track")
                    return
                }
            } catch let err {
            }
            //Export the avcompostion track to destination path
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let dstPath = documentsDirectory + (audioFileName)
            let dstURL = URL(fileURLWithPath: dstPath)
            
            
            //Remove if any file already exists
            do {
                try FileManager.default.removeItem(at: dstURL)
            } catch {
            }
            
            let exportSession = AVAssetExportSession(asset: newAudioAsset, presetName: AVAssetExportPresetPassthrough)
            if let supported = exportSession?.supportedFileTypes {
                print("support file types= \(supported)")
            }
            exportSession?.outputFileType = .m4a
            exportSession?.outputURL = dstURL
            
            exportSession?.exportAsynchronously(completionHandler: {
                let status = exportSession?.status
                
                if .completed != status {
                    if let description = exportSession?.error {
                        print("Export status not yet completed. Error: \(description)")
                    }
                }
                
                
            })
        }
    }
    
    
}

extension VideoCaptureViewController: UINavigationControllerDelegate {
}
