//
//  StatefulButton.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit

@IBDesignable
class StatefulButton: UIButton {
    
    @IBInspectable var style: Int = 1 {
        didSet { setStyle(style == 1 ? .enabled : .disabled) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
    }
    
    func setStyle(_ newStyle: Style) {
        if newStyle == .enabled {
            configuration!.attributedTitle = AttributedString(titleLabel!.text!, attributes: AttributeContainer([NSAttributedString.Key.font: AppTheme.Font.normal.bold]))
            configuration?.baseForegroundColor = AppTheme.Color.blackText
        } else {
            configuration!.attributedTitle = AttributedString(titleLabel!.text!, attributes: AttributeContainer([NSAttributedString.Key.font: AppTheme.Font.normal]))
            configuration?.baseForegroundColor = AppTheme.Color.blackText50
        }
    }
}


enum Style {
    case enabled
    case disabled
}
