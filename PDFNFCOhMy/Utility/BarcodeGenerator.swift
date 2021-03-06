//
//  BarcodeGenerator.swift
//  PDFNFCOhMy
//
//  Created by jnation on 1/28/21.
//

import Foundation
import UIKit
import CoreImage

/**
taken from stack overflow.  we'll undoubtedly have our own method for generating barcodes, but that isn't
 relevant to this POC
 */

class BarcodeGenerator {
    enum Descriptor: String {
        case code128 = "CICode128BarcodeGenerator"
        case pdf417 = "CIPDF417BarcodeGenerator"
        case aztec = "CIAztecCodeGenerator"
        case qr = "CIQRCodeGenerator"
    }


    class func generate(unencryptedString: String? = nil,
                         descriptor: Descriptor,
                               size: CGSize) -> UIImage? {
        let filterName = descriptor.rawValue
        let stringToEncrypt = unencryptedString ?? UUID().uuidString


        guard let data = stringToEncrypt.data(using: .ascii),
            let filter = CIFilter(name: filterName) else {
                return nil
        }

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
