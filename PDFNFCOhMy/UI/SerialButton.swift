//
//  ToggleButton.swift
//  PDFNFCOhMy
//
//  Created by jnation on 2/3/21.
//

import Foundation
import UIKit



struct SerialButtonOption: RawRepresentable, Equatable, Hashable, Comparable {
    init?(rawValue: String) {
        self.rawValue = rawValue
    }

    public typealias RawValue = String
    var rawValue: String
    private var _iconName: String = ""
    var iconName: String {
        _iconName.isEmpty ? rawValue : _iconName
    }

    init(name: String, iconName: String? = nil) {
        self.rawValue = name
        self._iconName = iconName ?? name
    }

    public static func < (lhs: SerialButtonOption, rhs: SerialButtonOption) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public var hashValue: Int {
        rawValue.hashValue
    }
}

typealias SerialButtonOptionAction = (SerialButtonOption) -> Void

class SerialButton: UIButton {
    private var _currentOptionIndex: Int = 0
    var currentOptionIndex: Int {
        return max(0, _currentOptionIndex % self.optionsActions.keys.count)
    }

    private var optionsActions = [SerialButtonOption: SerialButtonOptionAction]()
    private var optionsArrangement = [Int: SerialButtonOption]()

    private func findOptionAction(index: Int) -> SerialButtonOptionAction? {
        guard let option = optionsArrangement[index] else {
            return nil
        }
        return optionsActions[option]
    }

    private func commonInit() {
        addTarget(self, action: #selector(umbrellaClickAction), for: .touchUpInside)
    }

    @objc private func umbrellaClickAction() {
        setOptionIndex(index: currentOptionIndex + 1)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func addOption(_ option: SerialButtonOption, action: SerialButtonOptionAction?) {
        guard !self.optionsActions.keys.contains(option) else {
            return
        }

        self.optionsArrangement[self.optionsArrangement.keys.count] = option
        self.optionsActions[option] = action
    }

    func setSelectedOption(option: SerialButtonOption) {
        for (key, val) in self.optionsArrangement {
            if val == option {
                setOptionIndex(index: key)
            }
        }
    }

    func setOptionIndex(index: Int) {
        let roundedIndex = max(0, index % self.optionsActions.keys.count)
        guard let selectedOption = optionsArrangement[roundedIndex], let iconImage = UIImage(systemName: selectedOption.iconName, compatibleWith: nil) else {
            return
        }

        self._currentOptionIndex = roundedIndex
        self.setImage(iconImage, for: .normal)
        self.optionsActions[selectedOption]?(selectedOption)
    }
}
