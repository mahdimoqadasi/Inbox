//
//  PublicMessagesVC.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit

class PublicMessagesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var msgs: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...5 {
            self.msgs.append(Message())
        }
        
        self.tableView.estimatedRowHeight = 233
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension PublicMessagesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PublicMessageCell
        cell.selectionStyle = .none
        
        cell.setup(msgs[indexPath.row]) { [weak self] in
            if cell.bodyStack.axis == .vertical {
                let img = cell.bodyStack.arrangedSubviews[0]
                cell.bodyStack.removeArrangedSubview(img)
                cell.bodyStack.insertArrangedSubview(img, at: 1)
                cell.bodyStack.axis = .horizontal
            } else if cell.bodyStack.axis == .horizontal {
                let img = cell.bodyStack.arrangedSubviews[1]
                cell.bodyStack.removeArrangedSubview(img)
                cell.bodyStack.insertArrangedSubview(img, at: 0)
                cell.bodyStack.axis = .vertical
            }
            UIView.animate(withDuration: 0.3, delay: 0) {
                cell.layoutIfNeeded()
                cell.toggleButton.transform = cell.toggleButton.transform.rotated(by: (180.0 * .pi) / 180.0)
                self?.msgs[indexPath.row].isExpanded.toggle()
                tableView.beginUpdates()
                tableView.endUpdates()
            }
                        
        }
        return cell
    }
}
