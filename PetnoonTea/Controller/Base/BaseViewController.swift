//
//  STBaseViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/27.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension UIViewController {
    func backToRoot() {
        DispatchQueue.main.async {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        let tabBar = self.storyboard?.instantiateViewController(identifier: String(describing: TabbarController.self)) as? TabbarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBar
    }
}
