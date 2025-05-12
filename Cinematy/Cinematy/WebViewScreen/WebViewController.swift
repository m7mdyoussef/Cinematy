//
//  WebViewController.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 12/05/2025.
//

import Foundation
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    let url: URL

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
}
