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
            self?.msgs[indexPath.row].isExpanded.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        return cell
    }
}
