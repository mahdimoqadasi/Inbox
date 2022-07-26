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
    private var vm = InboxVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupList()
    }
    
    private func setupList() {
        self.tableView.estimatedRowHeight = 233
        tableView.delegate = self
        tableView.dataSource = self
        addRefreshControl()
//        DispatchQueue.global(qos: .userInitiated).async {
        self.msgs = self.vm.localMsgs
//            DispatchQueue.main.async {
                self.tableView.reloadData()
//            }
//        }
        loadNewItems()
    }
    
    @objc private func loadNewItems() {
        DispatchQueue.global(qos: .userInitiated).async {
            let wasSuccessful = self.vm.updateList(localMsgs: self.msgs)
            DispatchQueue.main.async {
                self.tableView?.refreshControl?.endRefreshing()
                if wasSuccessful { self.updateRequestsTable() }
            }
        }
    }
    
    private func updateRequestsTable() {
        msgs = vm.localMsgs
        tableView.reloadData()
//        emptyListView.isHidden = !newRequests.isEmpty
    }

    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadNewItems), for: .valueChanged)
        tableView.refreshControl = refreshControl
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
        cell.setup(msgs[indexPath.row], vc: self) { state in
            self.vm.saveMsg(self.msgs[indexPath.row], saveState: state)
        }
        return cell
    }
}
