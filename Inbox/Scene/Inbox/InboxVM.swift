//
//  InboxVM.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import Foundation

struct InboxVM {
    
    var unreadCount: Int {
        let msgsDao = RealmDB.MsgsDao()
        do { return try msgsDao.unreadCount() }
        catch { return 0 }
    }
        
    var localMsgs: [Message] {
        let msgsDao = RealmDB.MsgsDao()
        do {
            var finalList: [Message] = []
            let msgs = try Array(msgsDao.getAll())
            msgs.forEach { if $0.unread == true { finalList.append($0) } }
            msgs.forEach { if $0.unread != true { finalList.append($0) } }
            return finalList
        }
        catch { return [] }
    }
    
    var localSavedMsgs: [Message] {
        let msgsDao = RealmDB.MsgsDao()
        do {
            var finalList: [Message] = []
            let msgs = try Array(msgsDao.getMsgs(withState: true))
            msgs.forEach { if $0.unread == true { finalList.append($0) } }
            msgs.forEach { if $0.unread != true { finalList.append($0) } }
            return finalList
        }
        catch { return [] }
    }

    func updateList(localMsgs: [Message]) -> Bool {
        let res = ApiProvider.shared.load()
        guard let newMsgs = res?.messages else { return false }
        DispatchQueue.main.async {
            saveNewMsgs(oldItems: localMsgs, newMsgs)
        }
        return true
    }
    
    func saveNewMsgs(oldItems: [Message] ,_ receivedMsgs: [Message]) {
        let msgsDao = RealmDB.MsgsDao()
        let oldIds = oldItems.map { $0.id }
        let listToAdd = receivedMsgs.filter{ oldIds.firstIndex(of: $0.id) == nil }
        try? msgsDao.addAll(listToAdd)
    }
    
    func saveMsg(_ msg: Message, saveState: Bool) {
        let msgsDao = RealmDB.MsgsDao()
        try? msgsDao.update(obj: msg, saveState: saveState)
    }
    
    func deleteMsgs(_ msgs: [Message]) {
        let msgsDao = RealmDB.MsgsDao()
        try? msgsDao.remove(msgs)
    }
}
