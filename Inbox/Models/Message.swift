//
//  Message.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import Foundation

struct Message: Decodable {
    var title: String?
    var description: String?
    var image: String?
    var id: String?
    var unread: Bool?
    
    //local
    var isExpanded: Bool? = false
    var url: URL? { URL(string: image ?? "")}
}
