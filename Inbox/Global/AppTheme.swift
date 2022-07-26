//
//  AppTheme.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import Foundation
import UIKit

struct AppTheme {
    
    struct Color {
        static let blackText = UIColor(named: "blackText")
        static let blackText50 = UIColor(named: "blackText50")
        static let darkBlue = UIColor(named: "darkBlue")
        static let lightBlue = UIColor(named: "lightBlue")
        static let red = UIColor(named: "red")
        static let whiteBack = UIColor(named: "whiteBack")
        static let unreadBack = UIColor(named: "unreadBack")
        static let white = UIColor.white
    }
    
    struct Dimention {
        static let normalRadius: CGFloat = 8
        static let smallFontSize: CGFloat = 12
        static let normalFontSize: CGFloat = 16
        static let titleFontSize: CGFloat = 20
        static let largetitleFontSize: CGFloat = 24
    }
    
    struct Font {
        private static let yekanBakh = "Yekan Bakh"
        
        static var small: UIFont {
            get { UIFont(name: yekanBakh, size: Dimention.smallFontSize) ?? UIFont.systemFont(ofSize: Dimention.smallFontSize) }
        }
        
        static var normal: UIFont {
            get { UIFont(name: yekanBakh, size: Dimention.normalFontSize) ?? UIFont.systemFont(ofSize: Dimention.normalFontSize) }
        }
        
        static var title: UIFont {
            get { UIFont(name: yekanBakh, size: Dimention.titleFontSize) ?? UIFont.systemFont(ofSize: Dimention.titleFontSize) }
        }
        
        static var largeTitle: UIFont {
            get { UIFont(name: yekanBakh, size: Dimention.largetitleFontSize) ?? UIFont.systemFont(ofSize: Dimention.largetitleFontSize) }
        }
    }
    
}
