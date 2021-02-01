//
//  PDFGenerator.swift
//  PDFNFCOhMy
//
//  Created by jnation on 1/28/21.
//

import Foundation
import UIKit
import PDFKit


class PDFGenerator {
    static func generate(image: UIImage) -> PDFDocument? {
        guard let page = PDFPage(image: image) else {
            return nil
        }
        let document = PDFDocument()
        document.insert(page, at: 0)
        return document
    }

    static func generate(view: UIView) -> PDFDocument? {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return generate(image: image)
    }
}
