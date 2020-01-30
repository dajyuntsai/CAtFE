//
//  ShopLoginViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/23.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class ShopLoginViewController: BaseViewController {
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginView.alpha = 1
            signUpView.alpha = 0
        } else {
            loginView.alpha = 0
            signUpView.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
