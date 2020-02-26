//
//  CafeWebsiteViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import WebKit

class CafeWebsiteViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var cafeUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: cafeUrl!) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
}
