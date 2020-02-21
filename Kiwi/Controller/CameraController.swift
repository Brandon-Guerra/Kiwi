//
//  CameraController.swift
//  Kiwi
//
//  Created by Brandon Guerra on 1/28/20.
//  Copyright © 2020 Brandon Guerra. All rights reserved.
//

import AVFoundation
import UIKit

//protocol DepthDisplayDelegate {
//    func displayDepth(_ cameraController: CameraController)
//}

class CameraController: NSObject {
    
//    var delegate: DepthDisplayDelegate?
    
    var captureSession: AVCaptureSession?
    
    var currentCameraPosition: CameraPosition?
    
    var depthDataOutput: AVCaptureDepthDataOutput?
    var depthDataImage: UIImage?
    
    var flashMode = AVCaptureDevice.FlashMode.off
    
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
}

extension CameraController: AVCapturePhotoCaptureDelegate {
//    func normalize(input: CVPixelBuffer) -> CVPixelBuffer {
//
//        let width = CVPixelBufferGetWidth(input)
//        let height = CVPixelBufferGetHeight(input)
//
//        CVPixelBufferLockBaseAddress(input, CVPixelBufferLockFlags(rawValue: 0))
//        let floatBuffer = unsafeBitCast(CVPixelBufferGetBaseAddress(input), to: UnsafeMutablePointer<Float>.self)
//
//        var minPixel: Float = 1.0
//        var maxPixel: Float = 0.0
//
//        for y in 0 ..< height {
//            for x in 0 ..< width {
//                let pixel = floatBuffer[y * width + x]
//                minPixel = min(pixel, minPixel)
//                maxPixel = max(pixel, maxPixel)
//            }
//        }
//
//        let range = maxPixel - minPixel
//
//        for y in 0 ..< height {
//            for x in 0 ..< width {
//                let pixel = floatBuffer[y * width + x]
//                floatBuffer[y * width + x] = (pixel - minPixel) / range
//            }
//        }
//
//        CVPixelBufferUnlockBaseAddress(input, CVPixelBufferLockFlags(rawValue: 0))
//        return input
//    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Swift.Error?) {
//        var depthData: AVDepthData? = nil
//        if photo.depthData!.depthDataType != kCVPixelFormatType_DisparityFloat32 {
//            depthData = photo.depthData!.converting(toDepthDataType: kCVPixelFormatType_DisparityFloat32)
//        }
//        var pixelBuffer = depthData?.depthDataMap
//        let width = CVPixelBufferGetWidth(pixelBuffer!)
//        let height = CVPixelBufferGetHeight(pixelBuffer!)
//
//        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//        let depthPointer = unsafeBitCast(CVPixelBufferGetBaseAddress(pixelBuffer!), to: UnsafeMutablePointer<Float32>.self)
//
//        for y in 0 ..< width {
//            for x in 0 ..< width {
//                let pixel = y * width + x
//                print(depthPointer[pixel])
//            }
//        }
        
//        depthMap.map { print($0) }
//        let depthDataMap = normalize(input: depthData?.depthDataMap ?? photo.depthData!.depthDataMap)
//        let ciImage = CIImage(cvPixelBuffer: depthDataMap)
//        let scale: CGFloat = 1.0
//        let newImage = UIImage(ciImage: ciImage, scale: scale, orientation: .up)
//        let uiImage = UIImage(ciImage: ciImage)
//        self.depthDataImage = newImage
//        self.delegate?.displayDepth(self)
        
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
        else if let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data) {

            self.photoCaptureCompletionBlock?(image, nil)
        }

        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        settings.isDepthDataDeliveryEnabled = true
        settings.isPortraitEffectsMatteDeliveryEnabled = true
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
//        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
//
//        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//        settings.isDepthDataDeliveryEnabled = true
//        settings.flashMode = self.flashMode
//
//        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
//        func createCaptureSession() {
//            self.captureSession = AVCaptureSession()
//        }
//
//        func configureCaptureDevices() throws {
//            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .unspecified)
//            let cameras = (session.devices.compactMap { $0 })
//
//            for camera in cameras {
//                if camera.position == .front {
//                    self.frontCamera = camera
//                }
//
//                if camera.position == .back {
//                    self.rearCamera = camera
//
//                    try camera.lockForConfiguration()
//                    camera.focusMode = .continuousAutoFocus
//                    camera.unlockForConfiguration()
//                }
//            }
//        }
//
//        func configureDepthDataOutput() throws {
//            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
//            self.depthDataOutput = AVCaptureDepthDataOutput()
//
//            if let depthDataOutput = self.depthDataOutput {
//                if captureSession.canAddOutput(depthDataOutput) { captureSession.addOutput(depthDataOutput) }
//            }
//
//        }
//
//        func configureDeviceInputs() throws {
//            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
//
//            if let rearCamera = self.rearCamera {
//                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
//
//                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
//
//                self.currentCameraPosition = .rear
//            }
//
//            else if let frontCamera = self.frontCamera {
//                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
//
//                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
//                else { throw CameraControllerError.inputsAreInvalid }
//
//                self.currentCameraPosition = .front
//            }
//
//            else { throw CameraControllerError.noCamerasAvailable }
//        }
//
//        func configurePhotoOutput() throws {
//            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
//
//            self.photoOutput = AVCapturePhotoOutput()
//            print("Depth data is \(!photoOutput!.isDepthDataDeliverySupported ? "not " : "")supported")
//            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
//            captureSession.commitConfiguration()
//            self.photoOutput?.isDepthDataDeliveryEnabled = true
//        }
        
        DispatchQueue(label: "prepare").async {
            do {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { _ in })

                let rearCamera = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
                
                let rearCameraInput = try AVCaptureDeviceInput(device: rearCamera!)
                
                self.photoOutput = AVCapturePhotoOutput()
                
                self.captureSession = AVCaptureSession()
                self.captureSession?.beginConfiguration()
                self.captureSession?.sessionPreset = .photo
                self.captureSession?.addInput(rearCameraInput)

                self.captureSession?.addOutput(self.photoOutput!)
                self.captureSession?.commitConfiguration()
                self.photoOutput?.isDepthDataDeliveryEnabled = true
                self.photoOutput?.isPortraitEffectsMatteDeliveryEnabled = true
                self.captureSession?.startRunning()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
         
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
         
        func switchToFrontCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),
                   let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation }
            
               self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
               captureSession.removeInput(rearCameraInput)
            
               if captureSession.canAddInput(self.frontCameraInput!) {
                   captureSession.addInput(self.frontCameraInput!)
            
                   self.currentCameraPosition = .front
               }
            
               else { throw CameraControllerError.invalidOperation }
        }
        func switchToRearCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput),
                   let rearCamera = self.rearCamera else { throw CameraControllerError.invalidOperation }
            
               self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            
               captureSession.removeInput(frontCameraInput)
            
               if captureSession.canAddInput(self.rearCameraInput!) {
                   captureSession.addInput(self.rearCameraInput!)
            
                   self.currentCameraPosition = .rear
               }
            
               else { throw CameraControllerError.invalidOperation }
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
         
        case .rear:
            try switchToFrontCamera()
        }
         
        captureSession.commitConfiguration()
    }
    
}
