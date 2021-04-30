//
//  WebViewController.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import WebKit

class WebViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Properties
    private let convenience = Convenience.sharedInstance()
    
    /// through push or present
    var urlString = ""
    var navTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // updating nav bar here in case it was modified on other pushed view controllers
        convenience.updatenNavbarTitle(selfController: self, withTitle: navTitle, font: Style.Fonts.headline, fontColor: Style.Colors.headline)
    }
}
