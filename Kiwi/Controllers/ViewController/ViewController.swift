//
//  ViewController.swift
//  Kiwi
//
//  Created by Brandon Guerra on 1/28/20.
//  Copyright © 2020 Brandon Guerra. All rights reserved.
//

import Photos
import UIKit

class ViewController: UIViewController {
    
    let animalDetectorController = AnimalDetectorController()
    let cameraController = CameraController()
    var captureImage: UIImage?
    
    @IBOutlet weak var captureButton: UIButton!
    
    @IBOutlet weak var capturePreviewView: UIView!
    
    @IBOutlet weak var toggleCameraButton: UIButton!
    @IBOutlet weak var toggleFlashButton: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func captureImage(_ sender: UIButton) {
        startCaptureSession()
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            self.animalDetectorController.processImage(image)
            self.captureImage = image
            let previewImageView = PreviewImageController(nibName: "PreviewImageController", bundle: nil)
            previewImageView.image = image;
            self.navigationController!.pushViewController(previewImageView, animated: true)
            // this will try to save to camera roll
//            try? PHPhotoLibrary.shared().performChangesAndWait {
//                PHAssetChangeRequest.creationRequestForAsset(from: image)
//            }
        }
    }
    
    @IBAction func switchCameras(_ sender: UIButton) {
        do {
               try cameraController.switchCameras()
           }

           catch {
               print(error)
           }
    }
    
    @IBAction func toggleFlash(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(UIImage(systemName: "bolt.slash"), for: .normal)
        }

        else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(UIImage(systemName: "bolt"), for: .normal)
        }
    }
    
    func startCaptureSession() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.cameraController.captureImage {(image, error) in
                guard let image = image else {
                    print(error ?? "Image capture error")
                    return
                }
                self.animalDetectorController.processImage(image)
//                if (self.animalDetectorController.detectionString != "Neither cat nor dog") {
//                    try? PHPhotoLibrary.shared().performChangesAndWait {
//                        PHAssetChangeRequest.creationRequestForAsset(from: image)
//                    }
//                }
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool { return true }
}

extension ViewController {
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
         
                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }
        }
        configureCameraController()
        animalDetectorController.setupVision()
        super.viewDidLoad()
        animalDetectorController.delegate = self
        startCaptureSession()
    }
}

extension ViewController: AnimalDetectorControllerDelegate {
    func didDetect(_ animalDetectorController: AnimalDetectorController) {
        self.label.text = animalDetectorController.detectionString
    }
}
