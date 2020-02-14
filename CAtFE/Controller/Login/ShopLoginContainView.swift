//
//  ShopSignUpViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/28.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class ShopLoginContainView: BaseViewController {

    @IBOutlet var loginLabel: [UILabel]!
    @IBOutlet var loginTextField: [UITextField]!
    let userProvider = UserProvider()
    let loginList = ["登入帳號：", "登入密碼："]
    
    @IBAction func loginBtn(_ sender: Any) {
        checkLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        for index in 0..<loginList.count {
            loginLabel[index].text = loginList[index]
        }
    }
    
    func checkLogin() {
        if loginTextField[0].text == "" || loginTextField[1].text == "" {
            alert(message: "請輸入登入信箱及密碼", title: "錯誤")
        } else if !isValidEmail(loginTextField[0].text!) {
            alert(message: "請輸入正確信箱", title: "錯誤")
        } else {
            let account = loginTextField[0].text!
            let password = loginTextField[1].text!
            onCAtFESignIn(email: account, password: password, registerType: "email")
        }
    }

    func onCAtFESignIn(email: String, password: String, registerType: String) {
        userProvider.emailSignIn(email: email, password: password, registerType: registerType) { (result) in
            switch result {
            case .success:
                UserDefaults.standard.set(true, forKey: "loginState")
                CustomProgressHUD.showSuccess(text: "CAtFE 登入成功")
                self.backToRoot()
            case .failure:
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    CustomProgressHUD.showFailure(text: "CAtFE 登入失敗")
                }
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
