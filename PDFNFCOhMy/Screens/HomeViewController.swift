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
        resetAllButtons()
        barcodeValueTextField.placeholder = "value to encode"
    }



    @objc func didClickGenerateImage(sender: UIButton) {

    }

    @objc func didClickGeneratePDF(sender: UIButton) {

    }

    @objc func didClickViewPDF(sender: UIButton) {

    }

    @objc func didClickReset(sender: UIButton) {
        barcodeValueTextField.text = nil
        barcodeImageView.image = nil
    }

    @objc func didClickBeginSharing(sender: UIButton) {

    }

    func convertToResetButton(button: UIButton) {
        button.removeTarget(self, action: nil, for: .touchUpInside)
        button.setTitle("RESET", for: .normal)
        button.addTarget(self, action: #selector(didClickReset(sender:)), for: .touchUpInside)
    }

    func resetAllButtons() {
        

    }
}



extension UIButton {


    func matchState(isActive: Bool) -> Self {
        self.backgroundColor = isActive ? UIColor.black : .white
        self.setTitleColor(isActive ? UIColor.white : .systemBlue, for: .normal)
        self.isEnabled = isActive
        return self
    }
}
