//
//  UIImageView+ext.swift
//  PDFNFCOhMy
//
//  Created by jnation on 2/3/21.
//

import Foundation
import UIKit

extension UIImageView {
    func fillWithBarcode(scale: CGSize = CGSize(width: 1, height: 1)) {
        let scaleTransform = CGAffineTransform(scaleX: scale.width, y: scale.height)
        var scaleSize = self.bounds.size.applying(scaleTransform)
        scaleSize.height = min(scaleSize.width, scaleSize.height)
        scaleSize.width = min(scaleSize.width, scaleSize.height)
        self.image = BarcodeGenerator.generate(descriptor: .qr, size: scaleSize)
    }
}
