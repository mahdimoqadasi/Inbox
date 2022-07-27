//
//  RealmDB.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/4/1401 AP.
//

import Foundation
import RealmSwift

class RealmDB {
    struct MsgsDao {
        private let realm = try! Realm()
        
        func addAll(_ msgs: [Message]) throws {
            print(">>>Thread is Main:(addAll) \(Thread.isMainThread)")
            try realm.write { realm.add(msgs, update: .error) }
        }
        
        func getAll() throws -> Results<Message> {
            print(">>>Thread is Main:(getAll) \(Thread.isMainThread)")
            print(">>>Count: \(realm.objects(Message.self).count)")
            return realm.objects(Message.self).sorted(byKeyPath: "id", ascending: false)
        }
        
        func getMsgs(withState state: Bool) throws -> Results<Message> {
            print(">>>Thread is Main:(getMsgs) \(Thread.isMainThread)")
            let predicate = NSPredicate(format: "isSaved == %@", NSNumber(value: state))
            return realm.objects(Message.self).filter(predicate).sorted(byKeyPath: "id", ascending: false)
        }
        
        func update(obj: Message, saveState: Bool) throws {
            print(">>>Thread is Main:(update) \(Thread.isMainThread)")
            try realm.write { obj.isSaved = saveState }
        }
        
        func read(obj: Message) throws {
            print(">>>Thread is Main:(read) \(Thread.isMainThread)")
            try realm.write { obj.unread = false }
        }

        func removeAll() throws {
            print(">>>Thread is Main:(removeAll) \(Thread.isMainThread)")
            let reqs = realm.objects(Message.self)
            try realm.write { realm.delete(reqs) }
        }
        
        func remove(_ msgs: [Message]) throws {
            print(">>>Thread is Main:(remove) \(Thread.isMainThread)")
            try realm.write { realm.delete(msgs) }
        }
        
        func unreadCount() throws -> Int {
            let predicate = NSPredicate(format: "unread == %@", NSNumber(value: true))
            return realm.objects(Message.self).filter(predicate).count
        }
    }
}
