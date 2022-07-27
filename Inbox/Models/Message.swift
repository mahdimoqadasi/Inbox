//
//  Message.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import Foundation
import RealmSwift

class Message: Object, Decodable {
    @Persisted(primaryKey: true) var id: String?
    @Persisted var title: String?
    @Persisted var desc: String?
    @Persisted var image: String?
    @Persisted var unread: Bool?
    
    //local
    @Persisted var isSaved: Bool?
    var isExpanded: Bool = false
    var url: URL? { URL(string: image ?? "")}
}

extension Message {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case desc = "description"
        case image = "image"
        case unread = "unread"
    }
}
