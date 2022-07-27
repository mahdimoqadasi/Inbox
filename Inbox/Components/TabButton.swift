//
//  TabButton.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit

@IBDesignable
class TabButton: UIButton {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var badge: UILabel!
    
    @IBOutlet private weak var contentView: UIView!
    private let kCONTENT_XIB_NAME = "TabButton"
    
    @IBInspectable var titleEnabled: Bool = true {
        didSet {
            let titleFont = titleEnabled ? AppTheme.Font.normal.bold : AppTheme.Font.normal
            let titleColor = titleEnabled ? AppTheme.Color.blackText : AppTheme.Color.blackText50
            let badgeBackColor = titleEnabled ? AppTheme.Color.red : AppTheme.Color.blackText50
            title.font = titleFont
            title.textColor = titleColor
            badge.backgroundColor = badgeBackColor
        }
    }
    
    @IBInspectable var titleText: String {
        get { return title!.text! }
        set { title!.text = newValue }
    }
    
    @IBInspectable var badgeText: String {
        get { return badge!.text! }
        set { badge!.text = newValue; updateBadgeVisibility() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        updateBadgeVisibility()
    }
    
    private func updateBadgeVisibility() {
        badge.isHidden = badgeText.isEmpty || (badgeText == "۰")
    }

}
