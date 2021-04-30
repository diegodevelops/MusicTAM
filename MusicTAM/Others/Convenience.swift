//
//  Convenience.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit

class Convenience: NSObject {
    
    
    // MARK: - navbar
    public func updatenNavbarTitle(selfController: UIViewController?, withTitle: String, font: UIFont, fontColor: UIColor) {
        selfController?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : fontColor, NSAttributedString.Key.font: font]
        selfController?.navigationItem.title = withTitle
    }
    public func updatenNavbarItems(selfController: UIViewController?, withTitle: String, font: UIFont, withColor: UIColor) {
        let attributes = [ NSAttributedString.Key.foregroundColor: withColor, NSAttributedString.Key.font: font] as [NSAttributedString.Key : Any]
        selfController?.navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        selfController!.navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
    }
    
    // MARK: - Toast
    func createToast(toast: UILabel, view: UIView, withBackgroundColor: UIColor, font: UIFont, fontColor: UIColor) {
        let x: CGFloat = (view.frame.width/2) - 50
        let y: CGFloat = view.frame.height*0.2
        toast.frame = CGRect(x: x, y: y, width: 100,  height : 40)
        toast.textColor = fontColor
        toast.font = font
        toast.textAlignment = .center
        toast.alpha = 0
        toast.clipsToBounds = true
        toast.layer.cornerRadius = 4;
        toast.backgroundColor = withBackgroundColor
        view.addSubview(toast)
    }
    func showToast(toast: UILabel, withMessage: String, view: UIView) {
        toast.text = withMessage
        toast.sizeToFit()
        toast.frame.size.width = toast.frame.width + 30.0
        toast.frame.size.height = 40
        toast.center.x = view.center.x
        view.bringSubviewToFront(toast)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            toast.alpha = 1.0
        })
    }
    func hideToast(toast: UILabel) {
        UIView.animate(withDuration: 2.0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            toast.alpha = 0
        })
    }
    
    // MARK: - sharedInstance
    class func sharedInstance() -> Convenience {
        struct Singleton {
            static var sharedInstance = Convenience()
        }
        return Singleton.sharedInstance
    }
}
