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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLocally()
    }
    
    private func setupList() {
        self.tableView.estimatedRowHeight = 233
        tableView.delegate = self
        tableView.dataSource = self
        addRefreshControl()
        updateLocally()
        loadNewItems()
    }
    
    private func updateLocally() {
        self.msgs = self.vm.localMsgs
        self.tableView.reloadData()
    }
    
    @objc private func loadNewItems() {
        DispatchQueue.global(qos: .userInitiated).async {
            let wasSuccessful = self.vm.updateList(localMsgs: self.msgs)
            DispatchQueue.main.async {
                self.tableView?.refreshControl?.endRefreshing()
                if wasSuccessful { self.updateMsgsTable() }
            }
        }
    }
    
    private func updateMsgsTable() {
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
        cell.setup(msgs[indexPath.row], vc: self) { state, msg in
            self.vm.saveMsg(msg, saveState: state)
        }
        return cell
    }
}
