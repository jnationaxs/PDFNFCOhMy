//
//  NFCShareController.swift
//  PDFNFCOhMy
//
//  Created by Andrii Maliarchuk on 29.1.21.
//

import UIKit

class NFCShareController: UIViewController {
    
    let nfcUtility = NFCUtility.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapShare(_ sender: Any) {
        nfcUtility.sendURL(URL(string: "https://google.com")!) { result in
            switch result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
}
