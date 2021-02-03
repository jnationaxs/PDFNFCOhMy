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
            self.barcodeImageView.fillWithBarcode(scale: CGSize(width: 0.6, height: 0.6))
        }
    }()

    private lazy var convertToPDFAction: SerialButtonOptionAction = {
        { pdfOption in
            guard let barcodeImage = self.barcodeImageView.image, let generatedPDF = PDFGenerator.generate(image: barcodeImage) else {
                self.showSimpleAlert(msg: "Unable to generate PDF", title: "Error")
                return
            }
            self.showSimpleAlert(msg: "PDF Generated", title: "Success!")
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.barcodeImageView.contentMode = .center
        viewModeButton.addOption(SerialButtonOption.showingImage, action: showBarcodeAction)
        viewModeButton.addOption(SerialButtonOption.showingPDF, action: convertToPDFAction)
        barcodeImageView.isUserInteractionEnabled = false
    }
}

