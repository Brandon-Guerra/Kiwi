//
//  AnimalDetectorController.swift
//  Kiwi
//
//  Created by Brandon Guerra on 1/29/20.
//  Copyright © 2020 Brandon Guerra. All rights reserved.
//

import UIKit
import Vision

protocol AnimalDetectorControllerDelegate {
    func didDetect(_ animalDetectorController: AnimalDetectorController)
}

class AnimalDetectorController {
    var animalRecognitionRequest = VNRecognizeAnimalsRequest(completionHandler: nil)
    
    var detectionString: String?
    
    var delegate: AnimalDetectorControllerDelegate?
    
    private let animalRecognitionWorkQueue = DispatchQueue(label: "PetClassifierRequest", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    func setupVision() {
        animalRecognitionRequest = VNRecognizeAnimalsRequest { (request, error) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    var detectionString = ""
                    var animalCount = 0
                    for result in results
                    {
                        let animals = result.labels

                        for animal in animals {
                            
                            animalCount = animalCount + 1
                            var animalLabel = ""
                            
                            if animal.identifier == "Cat"{
                                animalLabel = "😸"
                            }
                            else{
                                animalLabel = "🐶"
                            }
                            
                            let string = "#\(animalCount) \(animal.identifier) \(animalLabel)"
//                            confidence is \(animal.confidence)\n
                            detectionString = detectionString + string
                        }
                    }
                    
                    if detectionString.isEmpty{
                        detectionString = "Neither cat nor dog"
                    }
                    self.detectionString = detectionString
                    self.delegate?.didDetect(self)
                }
            }
        }
    }
    
    func processImage(_ image: UIImage) {
        animalClassifier(image)
    }
    
    private func animalClassifier(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        animalRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.animalRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
    
}
