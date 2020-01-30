//
//  ShopSignUpViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/28.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ShopLoginContainView: BaseViewController {

    @IBOutlet var loginLabel: [UILabel]!
    @IBOutlet var loginTextField: [UITextField]!
    var database: Firestore?
    let loginList = ["登入帳號：", "登入密碼："]
    
    @IBAction func loginBtn(_ sender: Any) {
        checkLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
//        if loginLabel != nil {
//            for index in 0..<loginList.count {
//                loginLabel[index].text = loginList[index]
//            }
//        } else {
//            return
//        }
        
        for index in 0..<loginList.count {
            loginLabel[index].text = loginList[index]
        }
    }
    
    func checkLogin() {
        if loginTextField[0].text == "" || loginTextField[1].text == "" {
            alert(message: "請輸入登入信箱及密碼", title: "錯誤")
        } else {
            let account = loginTextField[0].text!
            let password = loginTextField[1].text!
            Auth.auth().signIn(withEmail: account, password: password) { (user, error) in
                if error == nil {
                    print("You have successfully login")
                    
                    let userID = Auth.auth().currentUser!.uid
                    let data = ["user_email": account, "user_password": password, "user_id": userID]
                    self.database?.collection("users").document(userID).setData(data) { error in
                        if let error = error {
                            print(error)
                        }
                    }
                    self.backToRoot()
                } else {
                    self.alert(message: error?.localizedDescription ?? "Unknown error", title: "Error")
                }
            }
        }
    }
}
