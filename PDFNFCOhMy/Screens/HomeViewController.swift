//
//  ViewController.swift
//  PDFNFCOhMy
//
//  Created by jnation on 1/28/21.
//

import UIKit

extension SerialButtonOption {
    static let showingImage = SerialButtonOption(name: "photo")
    static let showingPDF = SerialButtonOption(name: "pdf", iconName: "doc.text.fill")
}

class HomeViewController: UIViewController {
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var viewModeButton: SerialButton!
    @IBAction func tappedGenerate(_ sender: Any) {
        viewModeButton.setSelectedOption(option: SerialButtonOption.showingImage)
    }

    private lazy var showBarcodeAction: SerialButtonOptionAction = {
        { showBarcodeOption in
            self.barcodeImageView.fillWithBarcode()
        }
    }()

    private lazy var convertToPDFAction: SerialButtonOptionAction = {
        { pdfOption in
            guard let barcodeImage = self.barcodeImageView.image, let generatedPDF = PDFGenerator.generate(image: barcodeImage) else {
                self.showSimpleAlert(msg: "Unable to generate PDF", title: "Error")
                return
            }
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.barcodeImageView.contentMode = .center
        viewModeButton.addOption(SerialButtonOption.showingImage, action: showBarcodeAction)
        viewModeButton.addOption(SerialButtonOption.showingPDF, action: convertToPDFAction)
        barcodeImageView.isUserInteractionEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModeButton.setOptionIndex(index: 0)
    }


}

extension UIImageView {
    func fillWithBarcode() {
        let scaleTransform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        self.image = BarcodeGenerator.generate(descriptor: .qr, size: self.bounds.size.applying(scaleTransform))
    }
}
