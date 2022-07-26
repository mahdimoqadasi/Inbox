//
//  String+Extensions.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/4/1401 AP.
//

import Foundation

extension String {
    
    var toEnglishNumber: String {
        var copy = self
        let persianFormatter = NumberFormatter()
        persianFormatter.locale = Locale(identifier: "fa")
        let arabicFormatter = NumberFormatter()
        arabicFormatter.locale = Locale(identifier: "ar")
        for  index in 0..<10 {
            let number : NSNumber = NSNumber(value : index)
            copy = copy.replacingOccurrences(of: persianFormatter.string(from: number) ?? "", with:  number.stringValue)
            copy = copy.replacingOccurrences(of: arabicFormatter.string(from: number) ?? "", with: number.stringValue )
        }
        return copy
    }
    
    var toPersianNumber:String {
        var copy = self
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "fa-IR")
        for  index in 0..<10 {
            let number : NSNumber = NSNumber(value : index)
            copy = copy.replacingOccurrences(of: number.stringValue, with: formatter.string(from: number) ?? "")
        }
        return copy
    }
    
}
