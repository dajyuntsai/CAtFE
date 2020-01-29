//
//  ShopSignUpViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/28.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class ShopLoginContainView: UIViewController {

    @IBOutlet var loginLabel: [UILabel]!
    @IBOutlet var loginTextField: [UITextField]!
    
    let loginList = ["登入帳號：", "登入密碼："]
    
    @IBAction func loginBtn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        if loginLabel != nil {
            for index in 0..<loginList.count {
                loginLabel[index].text = loginList[index]
            }
        } else {
            return
        }
    }
}
