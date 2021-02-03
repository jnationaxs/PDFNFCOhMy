//
//  QRCodeController.swift
//  PDFNFCOhMy
//
//  Created by Andrii Maliarchuk on 3.2.21.
//

import UIKit
import CoreImage

class QRCodeController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urlTextField: UITextField!
    private lazy var qrFilter = CIFilter(name: "CIQRCodeGenerator")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invalidateQR()
    }
    
    @IBAction func urlDidChange(_ sender: Any) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(autoInvalidateQR), with: nil, afterDelay: 0.5)
    }
    
    @objc private func autoInvalidateQR() {
        DispatchQueue.main.async { [unowned self] in
            self.invalidateQR()
        }
    }
    
    @objc private func invalidateQR() {
        imageView.image = makeQR()
    }
    
    private func makeQR() -> UIImage? {
        guard let data = urlTextField.text?.data(using: .ascii), !data.isEmpty else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        return qrFilter.outputImage.map { UIImage(ciImage: $0, scale: 1, orientation: .up) }
    }
}
