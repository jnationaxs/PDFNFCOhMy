//
//  UIViewController+Ext.swift
//  PDFNFCOhMy
//
//  Created by jnation on 2/1/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showSimpleAlert(msg: String, title: String? = "Alert", cancelButtonTitle: String? = "OK") {
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        controller.addAction(cancelButton)
        self.present(controller, animated: true, completion: nil)
    }
}

