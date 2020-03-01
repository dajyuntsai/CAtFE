//
//  CafeWebsiteViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import WebKit

class CafeWebsiteViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var cafeUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        webView.navigationDelegate = self
        guard let url = URL(string: cafeUrl!) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        indicatorView.stopAnimating()
//    }
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        indicatorView.stopAnimating()
//    }
}
