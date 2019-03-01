//
//  UIImage+Mask.swift
//  HMD
//
//  Created by Yi JIANG on 01/03/19.
//  Copyright © 2019 RobertYiJiang. All rights reserved.
//

import UIKit

// MARK: - Barcode

extension UIImage {
  
  enum BarcodeDescriptor: String {
    case code128 = "CICode128BarcodeGenerator"
    case pdf417 = "CIPDF417BarcodeGenerator"
    case aztec = "CIAztecCodeGenerator"
    case qr = "CIQRCodeGenerator"
  }
  
  /// Generate a barcode image
  ///
  /// - Parameters:
  ///   - string: A string needs to be encode into barcode
  ///   - descriptor: BarcodeDescriptor is the coding standard
  ///   - size: Output image size
  /// - Returns: Optional barcode UIImage
  class func barcode(from string: String,
                     descriptor: BarcodeDescriptor,
                     size: CGSize) -> UIImage? {
    let filterName = descriptor.rawValue
    guard let data = string.data(using: .ascii),
      let filter = CIFilter(name: filterName) else {
        return nil
    }
    filter.setValue(0.1, forKey: "inputQuietSpace")
    filter.setValue(data, forKey: "inputMessage")
    guard let image = filter.outputImage else {
      return nil
    }
    let imageSize = image.extent.size
    let transform = CGAffineTransform(scaleX: size.width / imageSize.width,
                                      y: size.height / imageSize.height)
    let scaledImage = image.transformed(by: transform)
    return UIImage(ciImage: scaledImage)
  }
  
}
