//
//  STBaseViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/27.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    static var identifier: String {
        return String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension UIViewController {
    func backToRoot() {
        DispatchQueue.main.async {
            let tabBar = UIStoryboard.tabBar.instantiateViewController(identifier: "TabbarController") as? TabbarController
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.window?.rootViewController = tabBar
                    tabBar?.selectedIndex = 2
                }
            })
        }
    }
}
