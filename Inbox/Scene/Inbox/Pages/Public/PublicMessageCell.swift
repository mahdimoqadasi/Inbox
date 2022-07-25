//
//  PublicMessageCell.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit
import AlamofireImage

class PublicMessageCell: UITableViewCell {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var img: UIImageView!
    var currentItem: Message?
    private var vc: UIViewController?
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
    
    @IBAction func shareTap(_ sender: UIButton) {
        guard currentItem != nil else { return }
        let textToShare = [(currentItem!.title ?? "") + "\n" + (currentItem!.description ?? "")]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc?.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        vc?.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveTap(_ sender: UIButton) {
        guard currentItem != nil else { return }
        if currentItem!.isSaved != true { currentItem!.isSaved = true } else { currentItem!.isSaved = false }
        let newImage = currentItem!.isSaved! ? UIImage(named: "mark.filled")! : UIImage(named: "mark.outline")!
        sender.setImage(newImage, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ item: Message, vc: UIViewController, _ moreTap: @escaping (() -> Void)) {
        currentItem = item
        self.vc = vc
        seeMoreDidTapHandler = moreTap
        titleLabel.text = item.title
        bodyLabel.text = item.description
        if let url = item.url { img.af.setImage(withURL: url); img.isHidden = false }
        else { img.isHidden = true }
        self.isSeeLess = item.isExpanded ?? false
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
