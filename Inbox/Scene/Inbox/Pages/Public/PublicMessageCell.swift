//
//  PublicMessageCell.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit
import AlamofireImage

class PublicMessageCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    var currentItem: Message?
    @IBOutlet weak var bodyStack: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    private var isSeeLess = true
    private var seeMoreDidTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ item: Message, _ moreTap: @escaping (() -> Void)) {
        currentItem = item
        seeMoreDidTapHandler = moreTap

        titleLabel.text = item.title
        bodyLabel.text = item.description
        if let url = item.url { img.af.setImage(withURL: url) }
        self.isSeeLess = item.isExpanded
        self.bodyLabel.numberOfLines = self.isSeeLess ? 0 : 1
    }
    
    @IBAction func expandTapped(_ sender: Any) {
        self.isSeeLess.toggle()
        self.bodyLabel.numberOfLines = self.isSeeLess ? 0 : 1
        self.bodyLabel.layoutIfNeeded()
        self.seeMoreDidTapHandler?()
    }

    func onSeeMoreDidTap(_ handler: @escaping () -> Void) {
        self.seeMoreDidTapHandler = handler
    }
}
