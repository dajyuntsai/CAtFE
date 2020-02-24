//
//  ShopSignUpContainView.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/28.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class ShopSignUpContainView: BaseViewController {

    @IBOutlet var registerLabel: [UILabel]!
    @IBOutlet var registerTextField: [UITextField]!
    @IBOutlet weak var notificationBtn: UISwitch!

    let userProvider = UserProvider()
    var isAdmin = false
    var isNeedNotification = false

    let signUpList = ["顯示名稱：", "註冊帳號：", "登入密碼：", "再次輸入密碼：", "是否需要傳送推播功能：", "我是店家："]
    
    @IBAction func roleBtn(_ sender: UISwitch) {
        if sender.isOn {
            isAdmin = true
        } else {
            isAdmin = false
            notificationBtn.setOn(!sender.isOn, animated: false)
        }
    }

    @IBAction func notificationBtn(_ sender: UISwitch) {
        if sender.isOn {
            isNeedNotification = true
        } else {
            isNeedNotification = false
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        signUpCheck()
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
    
    func signUpCheck() {
        let name = registerTextField[0].text!
        let account = registerTextField[1].text!
        let password = registerTextField[2].text!
        let checkPsd = registerTextField[3].text!
        if name == "" {
            alert(message: "請輸入顯示名稱", title: "錯誤", handler: nil)
        } else if password != checkPsd {
            alert(message: "請再次確認密碼", title: "錯誤", handler: nil)
        } else {
            onCAtFESignUp(email: account, name: name, password: password)
        }
    }

    func onCAtFESignUp(email: String, name: String, password: String) {
        userProvider.emailSignUp(email: email, name: name, password: password) { (result) in
            switch result {
            case .success:
                CustomProgressHUD.showSuccess(text: "CAtFE 註冊成功")
                self.backToRoot()
            case .failure(let error):
                CustomProgressHUD.showSuccess(text: "CAtFE 註冊失敗")
                print(error.localizedDescription)
            }
        }
    }
}
