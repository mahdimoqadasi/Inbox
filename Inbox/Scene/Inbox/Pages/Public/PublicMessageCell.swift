//
//  PublicMessageCell.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit

class PublicMessageCell: UITableViewCell {

    var currentItem: Message?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var toggleButton: UIImageView!
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
//        self.userNameLabel.text = review.title
//        self.memberSinceLabel.text = review.memberSince
//        self.descLabel.text = review.description
//        self.dateLabel.text = review.date
        
        self.isSeeLess = item.isExpanded
        self.bodyLabel.numberOfLines = self.isSeeLess ? 0 : 1
//        self.seeMoreButton.setTitle(self.isSeeLess ? "See less" : "See more", for: .normal)
    }
    
    @IBAction func expandTapped(_ sender: Any) {
        self.isSeeLess.toggle()
        self.bodyLabel.numberOfLines = self.isSeeLess ? 0 : 1
        self.bodyLabel.layoutIfNeeded()
//        self.seeMoreButton.setTitle(self.isSeeLess ? "See less" : "See more", for: .normal)
        self.seeMoreDidTapHandler?()
    }

    func onSeeMoreDidTap(_ handler: @escaping () -> Void) {
        
        self.seeMoreDidTapHandler = handler
    }

}
