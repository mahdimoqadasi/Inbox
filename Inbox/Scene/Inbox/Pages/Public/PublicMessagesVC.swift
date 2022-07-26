//
//  PublicMessagesVC.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit

class PublicMessagesVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var msgs: [Message] = []
    private var msgsToRemove: [Message] = []
    private var indexesToRemove: [IndexPath] = []
    private var vm = InboxVM()
    private var removeButtonShowed = false
    private var selectionEnabled = false {
        didSet {
            tableView.visibleCells.forEach { cell in
                UIView.animate(withDuration: 0.5, delay: 0) {
                    let c = (cell as! PublicMessageCell)
                    c.checkButton?.isHidden = !self.selectionEnabled
                    c.checkButton?.alpha = self.selectionEnabled ? 1 : 0
                    if !self.selectionEnabled { c.isChecked = false; c.updateCheckboxImage(isChecked: c.isSelected) }
                    if self.selectionEnabled { self.tableView.refreshControl = nil } else { self.addRefreshControl() }
                    if !self.selectionEnabled { self.msgsToRemove.removeAll(); self.indexesToRemove.removeAll() }
                    guard self.removeButtonShowed != self.selectionEnabled else { return }
                    self.removeButtonSection.transform = self.removeButtonSection.transform.translatedBy(x: 0, y: self.selectionEnabled ? -100 : 100)
                    self.removeButtonShowed = self.selectionEnabled
                }
            }
        }
    }
    @IBOutlet weak var removeButtonSection: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupMultiRemove()
        setupList()
    }
    
    @IBAction func removeTap(_ sender: UIButton) {
        vm.deleteMsgs(msgsToRemove)
        msgs = vm.localMsgs
        tableView.deleteRows(at: indexesToRemove, with: .automatic)
        indexesToRemove.removeAll()
        msgsToRemove.removeAll()
        selectionEnabled = false
    }
    
    @IBAction func cancelRemoveTap(_ sender: UIButton) {
        selectionEnabled = false
    }
    
    private func setupMultiRemove() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPress() {
        selectionEnabled = true
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
        selectionEnabled = false
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
        cell.setup(msgs[indexPath.row],
                   vc: self,
                   selectionEnabled: selectionEnabled,
                   checked: indexesToRemove.contains(indexPath),
                   checkBoxTap: { self.itemSelect($0, $1, tableView.indexPath(for: cell)!) }) {
            self.vm.saveMsg($1, saveState: $0)
        }
        return cell
    }
    
    func itemSelect(_ checked: Bool, _ msg: Message, _ index: IndexPath) {
        if checked {
            msgsToRemove.append(msg)
            indexesToRemove.append(index)
        } else {
            msgsToRemove.remove(at: msgsToRemove.firstIndex(of: msg)!)
            indexesToRemove.remove(at: indexesToRemove.firstIndex(of: index)!)
        }
    }
 }
