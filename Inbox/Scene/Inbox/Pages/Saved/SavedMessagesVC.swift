//
//  SavedMessagesVC.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit

class SavedMessagesVC: UIViewController {

    @IBOutlet weak var emptyView: UIView!
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
        updateMsgsTable()
    }

    private func setupList() {
        self.tableView.estimatedRowHeight = 233
        tableView.delegate = self
        tableView.dataSource = self
        addRefreshControl()
        updateMsgsTable()
    }
    
    @objc private func updateMsgsTable() {
        msgs = vm.localSavedMsgs
        emptyView.isHidden = !msgs.isEmpty
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateMsgsTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

}

extension SavedMessagesVC: UITableViewDelegate, UITableViewDataSource {
    
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
            if state == false {
                self.msgs = self.vm.localSavedMsgs
                tableView.deleteRows(at: [tableView.indexPath(for: cell)!], with: .automatic)
                self.emptyView.isHidden = !self.msgs.isEmpty
            }
        }
        return cell
    }
}

