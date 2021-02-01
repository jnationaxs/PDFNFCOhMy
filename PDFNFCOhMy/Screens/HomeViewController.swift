//
//  ViewController.swift
//  PDFNFCOhMy
//
//  Created by jnation on 1/28/21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var barcodeValueTextField: UITextField!
    @IBOutlet weak var generateBarcodeButton: UIButton!
    @IBOutlet weak var generatePDFButton: UIButton!
    @IBOutlet weak var viewPDFButton: UIButton!
    @IBOutlet weak var beginSharingButton: UIButton!



    override func viewDidLoad() {
        super.viewDidLoad()
        resetFlow()

    }



    @objc func didClickGenerateImage(sender: UIButton) {
        // generate Barcode
        guard let rawString = barcodeValueTextField.text, let barcodeCIImg = BarcodeGenerator.generate(from: rawString, descriptor: .code128, size: self.barcodeImageView.bounds.size.applying(CGAffineTransform(scaleX: 0.8, y: 0.8))) else {
            self.showSimpleAlert(msg: "Unable to generate image", title: "Error")
            return
        }

        let barcodeImage = UIImage(ciImage: barcodeCIImg)
        barcodeImageView.image = barcodeImage
        barcodeValueTextField.placeholder = rawString
        barcodeValueTextField.text = nil
        barcodeValueTextField.isEnabled = false
        convertToResetButton(button: self.generateBarcodeButton)
        generatePDFButton.matchState(isActive: true)
        
        
    }

    @objc func didClickGeneratePDF(sender: UIButton) {
        guard let barcodeImage = barcodeImageView.image, let generatedPDF = PDFGenerator.generate(image: barcodeImage) else {
            self.showSimpleAlert(msg: "Unable to generate PDF", title: "Error")
            return
        }

        generatePDFButton.matchState(isActive: false)
        beginSharingButton.matchState(isActive: true)
        viewPDFButton.matchState(isActive: true)
    }

    @objc func didClickViewPDF(sender: UIButton) {

    }

    @objc func didClickReset(sender: UIButton) {
        resetFlow()
    }

    @objc func didClickBeginSharing(sender: UIButton) {

    }

    func convertToResetButton(button: UIButton) {
        button.removeTarget(self, action: nil, for: .touchUpInside)
        button.setTitle("Reset", for: .normal)
        button.addTarget(self, action: #selector(didClickReset(sender:)), for: .touchUpInside)
    }

    func resetFlow() {
        barcodeValueTextField.text = nil
        barcodeValueTextField.placeholder = "value to encode"
        barcodeValueTextField.isEnabled = true
        barcodeImageView.image = nil
        barcodeImageView.backgroundColor = .black
        resetAllButtons()
    }

    func resetAllButtons() {
        generateBarcodeButton
            .withTitle("Generate Image")
            .withClickAction(#selector(didClickGenerateImage(sender:)), target: self)
            .matchState(isActive: true)

        generatePDFButton
            .withTitle("Generate PDF")
            .withClickAction(#selector(didClickGeneratePDF(sender:)), target: self)
            .matchState(isActive: false)

        viewPDFButton
            .withTitle("View PDF")
            .withClickAction(#selector(didClickViewPDF(sender:)), target: self)
            .matchState(isActive: false)

        beginSharingButton
            .withTitle("Begin Sharing")
            .withClickAction(#selector(didClickBeginSharing(sender:)), target: self)
            .matchState(isActive: false)
    }
}


