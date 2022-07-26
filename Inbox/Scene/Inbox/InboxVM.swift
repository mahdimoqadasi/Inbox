//
//  InboxVM.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import Foundation

struct InboxVM {
        
    var localMsgs: [Message] {
        let msgsDao = RealmDB.MsgsDao()
        do { return try Array(msgsDao.getAll()) }
        catch { return [] }
    }
    
    var localSavedMsgs: [Message] {
        let msgsDao = RealmDB.MsgsDao()
        do { return try Array(msgsDao.getMsgs(withState: true)) }
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

}
