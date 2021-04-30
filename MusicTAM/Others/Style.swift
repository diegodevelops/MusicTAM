//
//  Style.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit

// Adding a little extra in case of darkmode

enum Style {
    enum Colors {
        static let headline: UIColor = {
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return .black
            }
        }()
        static let name: UIColor = {
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return .black
            }
        }()
        static let description: UIColor = {
            if #available(iOS 13.0, *) {
                return .secondaryLabel
            } else {
                return .lightGray
            }
        }()
        static let button: UIColor = .white
        static let toastBackground: UIColor = UIColor.black.withAlphaComponent(0.8)
        static let toastText: UIColor = .white
        static let imgBackground: UIColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    enum Fonts {
        static let defaultBold: UIFont = .boldSystemFont(ofSize: 17)
        static let defaultSmallBold: UIFont = .boldSystemFont(ofSize: 14)
        static let defaultDescription: UIFont = .systemFont(ofSize: 14)
        static let headline: UIFont = UIFont(name: "Menlo-Bold", size: 17) ?? defaultBold
        static let name: UIFont = UIFont(name: "Helvetica-Bold", size: 17) ?? defaultBold
        static let description: UIFont = UIFont(name: "Helvetica-Bold", size: 14) ?? defaultSmallBold
        static let button: UIFont = UIFont(name: "Helvetica-Bold", size: 14) ?? defaultSmallBold
    }
}
