//
//  PublicMessageCell.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit
import AlamofireImage

class PublicMessageCell: UITableViewCell {

    private var currentItem: Message?
    private var vc: UIViewController?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var bodyStack: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    private var isSeeLess = true
    private var saveTap: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func shareTap(_ sender: UIButton) {
        guard currentItem != nil else { return }
        let textToShare = [(currentItem!.title ?? "") + "\n" + (currentItem!.desc ?? "")]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc?.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        vc?.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveTap(_ sender: UIButton) {
        guard currentItem != nil else { return }
        let newState = !(currentItem!.isSaved == true)
//        if currentItem!.isSaved != true { currentItem!.isSaved = true } else { currentItem!.isSaved = false }
        let newImage = newState ? UIImage(named: "mark.filled")! : UIImage(named: "mark.outline")!
        sender.setImage(newImage, for: .normal)
        saveTap?(newState)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ item: Message,
               vc: UIViewController,
               _ saveTap: @escaping ((Bool) -> Void)) {
        currentItem = item
        titleLabel.text = item.title
        bodyLabel.text = item.desc
        self.saveTap = saveTap
        if let url = item.url { img.af.setImage(withURL: url); img.isHidden = false }
        else { img.isHidden = true }
        self.isSeeLess = item.isExpanded ?? false
        self.bodyLabel.numberOfLines = self.isSeeLess ? 0 : 1
    }
    
    @IBAction func expandTapped(_ sender: Any) {
        self.isSeeLess.toggle()
        self.bodyLabel.numberOfLines = self.isSeeLess ? 0 : 1
        
        if bodyStack.axis == .vertical {
            let img = bodyStack.arrangedSubviews[0]
            bodyStack.removeArrangedSubview(img)
            bodyStack.insertArrangedSubview(img, at: 1)
            bodyStack.axis = .horizontal
        } else if bodyStack.axis == .horizontal {
            let img = bodyStack.arrangedSubviews[1]
            bodyStack.removeArrangedSubview(img)
            bodyStack.insertArrangedSubview(img, at: 0)
            bodyStack.axis = .vertical
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.layoutIfNeeded()
            self.bodyLabel.layoutIfNeeded()
            self.toggleButton.transform = self.toggleButton.transform.rotated(by: (180.0 * .pi) / 180.0)
            self.currentItem?.isExpanded?.toggle()
            
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }

    }    
}

extension UITableViewCell {
    var tableView: UITableView? {
        var currentView: UIView = self
        while let superView = currentView.superview {
            if superView is UITableView {
                return (superView as! UITableView)
            }
            currentView = superView
        }
        return nil
    }
}
