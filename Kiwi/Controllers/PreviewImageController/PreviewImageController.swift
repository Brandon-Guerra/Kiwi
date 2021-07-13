//
//  PreviewImageController.swift
//  Kiwi
//
//  Created by Brandon Guerra on 2/28/20.
//  Copyright © 2020 Brandon Guerra. All rights reserved.
//
import CoreGraphics
import Foundation
import TensorFlowLiteC
import UIKit

class PreviewImageController: UIViewController {
    var image: UIImage?
    
    override func viewDidLoad() {
        
        func runSegmentation(_ image: UIImage) {
            DispatchQueue(label: "segmentation").async {
//                let outputTensor: TfLiteTensor
                
                do {
                    // look at rgbData stuff on line 201 from https://github.com/tensorflow/examples/blob/master/lite/examples/image_segmentation/ios/ImageSegmentation/ImageSegmentator.swift
                }
            }
        }
        
        self.navigationController?.navigationBar.isHidden = false
        super.viewDidLoad()
        let imageView = UIImageView(image: image!)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.addSubview(imageView)
        //Imageview on Top of View
        self.view.bringSubviewToFront(imageView)
        
    }
}

private enum Constant {
  static let jpegCompressionQuality: CGFloat = 0.8
  static let alphaComponent = (baseOffset: 4, moduloRemainder: 3)
  static let maxRGBValue: Float32 = 255.0
}

extension Data {
  init<T>(copyingBufferOf array: [T]) {
    self = array.withUnsafeBufferPointer(Data.init)
  }

  /// Convert a Data instance to Array representation.
  func toArray<T>(type: T.Type) -> [T] where T: ExpressibleByIntegerLiteral {
    var array = [T](repeating: 0, count: self.count/MemoryLayout<T>.stride)
    _ = array.withUnsafeMutableBytes { copyBytes(to: $0) }
    return array
  }
}

extension UIImage {
    func scaledData(with size: CGSize, byteCount: Int, isQuantized: Bool) -> Data? {
      guard let cgImage = self.cgImage, cgImage.width > 0, cgImage.height > 0 else { return nil }
      guard let imageData = imageData(from: cgImage, with: size) else { return nil }
      var scaledBytes = [UInt8](repeating: 0, count: byteCount)
      var index = 0
      for component in imageData.enumerated() {
        let offset = component.offset
        let isAlphaComponent = (offset % Constant.alphaComponent.baseOffset)
          == Constant.alphaComponent.moduloRemainder
        guard !isAlphaComponent else { continue }
        scaledBytes[index] = component.element
        index += 1
      }
      if isQuantized { return Data(scaledBytes) }
      let scaledFloats = scaledBytes.map { Float32($0) / Constant.maxRGBValue }
      return Data(copyingBufferOf: scaledFloats)
    }
    
    private func imageData(from cgImage: CGImage, with size: CGSize) -> Data? {
        let bitmapInfo = CGBitmapInfo(
          rawValue: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        )
        let width = Int(size.width)
        let scaledBytesPerRow = (cgImage.bytesPerRow / cgImage.width) * width
        guard
          let context = CGContext(
            data: nil,
            width: width,
            height: Int(size.height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: scaledBytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo.rawValue)
        else {
          return nil
        }
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        return context.makeImage()?.dataProvider?.data as Data?
    }
}
