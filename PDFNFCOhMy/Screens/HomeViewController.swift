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
    @IBOutlet weak var generateBarcodeButton: SerialButton!
    @IBOutlet weak var generatePDFButton: UIButton!
    @IBOutlet weak var viewPDFButton: UIButton!
    @IBOutlet weak var beginSharingButton: UIButton!

    private lazy var showBarcodeAction: SerialButtonOptionAction = {
        { showBarcodeOption in
            self.barcodeImageView.image = BarcodeGenerator.generate(descriptor: .qr, size: self.barcodeImageView.bounds.size)

        }
    }()

    private lazy var convertToPDFAction: SerialButtonOptionAction = {
        // clicking on "img" icon calls this
        { pdfOption in
            guard let barcodeImage = self.barcodeImageView.image, let generatedPDF = PDFGenerator.generate(image: barcodeImage) else {
                self.showSimpleAlert(msg: "Unable to generate PDF", title: "Error")
                return
            }
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        generateBarcodeButton.addOption(SerialButtonOption.showingImage, action: showBarcodeAction)
        generateBarcodeButton.addOption(SerialButtonOption.showingImage, action: convertToPDFAction)
        generateBarcodeButton.setOptionIndex(index: 0)
    }



    @objc func didClickGenerateImage(sender: UIButton) {
        // generate Barcode
        self.barcodeImageView.image = BarcodeGenerator.generate(descriptor: .qr, size: self.barcodeImageView.bounds.size)
    }

}


