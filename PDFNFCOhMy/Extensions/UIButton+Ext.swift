//
//  UIButton+Ext.swift
//  PDFNFCOhMy
//
//  Created by jnation on 2/1/21.
//

import Foundation
import UIKit

extension UIButton {

    @discardableResult func withTitle(_ title: String) -> Self {
        setTitle(title, for: .normal)
        return self
    }

    @discardableResult func withClickAction(_ selector: Selector, target: Any?) -> Self {
        removeTarget(target, action: nil, for: .touchUpInside)
        addTarget(target, action: selector, for: .touchUpInside)
        return self
    }

    @discardableResult func matchState(isActive: Bool) -> Self {
        self.backgroundColor = isActive ? UIColor.black : .darkGray
        self.setTitleColor(isActive ? UIColor.systemBlue : .white, for: .normal)
        self.isEnabled = isActive
        return self
    }
}
