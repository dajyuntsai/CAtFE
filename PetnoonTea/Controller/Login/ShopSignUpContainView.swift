//
//  ShopSignUpContainView.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/28.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class ShopSignUpContainView: UIViewController {

    @IBOutlet var registerLabel: [UILabel]!
    @IBOutlet var registerTextField: [UITextField]!
    let signUpList = ["店家名稱：", "註冊帳號：", "登入密碼：", "再次輸入密碼：", "是否需要傳送推播功能："]
    
    @IBAction func signUpBtn(_ sender: Any) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        initView()
    }
    
    func initView() {
        if registerLabel != nil {
            for index in 0..<signUpList.count {
                registerLabel[index].text = signUpList[index]
            }
        } else {
            return
        }
    }
}
