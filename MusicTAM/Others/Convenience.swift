//
//  Convenience.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit

class Convenience: NSObject {
    
    
    // navbar
    public func updatenNavbarTitle(selfController: UIViewController, withTitle: String, fontName: String, fontSize: CGFloat, withColor: UIColor) {
        selfController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : withColor, NSAttributedString.Key.font: UIFont(name: fontName, size: fontSize) ?? UIFont.boldSystemFont(ofSize: 17)]
        selfController.navigationItem.title = withTitle
    }
    
    
    // MARK: - sharedInstance
    class func sharedInstance() -> Convenience {
        struct Singleton {
            static var sharedInstance = Convenience()
        }
        return Singleton.sharedInstance
    }
}
