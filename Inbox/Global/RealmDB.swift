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
        static func addAll(requests: [Message]) throws {
            let realm = try Realm()
            try realm.write { realm.add(requests, update: .all) }
        }
        
        static func getAll() throws -> Results<Message> {
            return try Realm().objects(Message.self)
        }
        
        static func getMsgs(withState state: Bool) throws -> Results<Message> {
                let predicate = NSPredicate(format: "isSaved == %@", NSNumber(value: state))
                return try Realm().objects(Message.self).filter(predicate)
            }
        
        static func update(obj: Message, saveState: Bool) throws {
            let realm = try Realm()
            try realm.write { obj.isSaved = saveState }
        }
        
        static func removeAll() throws {
            let realm = try Realm()
            let reqs = realm.objects(Message.self)
            try realm.write { realm.delete(reqs) }
        }
        
        static func remove(_ msg: Message) throws {
            let realm = try Realm()
            try realm.write { realm.delete(msg) }
        }
    }
}
