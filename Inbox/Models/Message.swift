//
//  Message.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import Foundation

struct Message: Codable {
    var sentDate: String?
    var title: String?
    var body: String?
    var imageUrl: String?
    var expireDate: String?
    
    var isExpanded: Bool = false
}
