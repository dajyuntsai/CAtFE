//
//  ShopSignUpContainView.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/28.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ShopSignUpContainView: BaseViewController {

    @IBOutlet var registerLabel: [UILabel]!
    @IBOutlet var registerTextField: [UITextField]!
    var database: Firestore?
    var isNeedNotification = false
    let signUpList = ["店家名稱：", "註冊帳號：", "登入密碼：", "再次輸入密碼：", "是否需要傳送推播功能："]
    
    @IBAction func switchBtn(_ sender: UISwitch) {
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
        Auth.auth().createUser(withEmail: account, password: password) { (user, error) in
            if error == nil {
                print("You have successfully signed up")
                let userID = Auth.auth().currentUser!.uid
                let data = ["user_email": account, "user_name": name, "user_id": userID, "notification:": self.isNeedNotification] as [String : Any]
                self.database?.collection("users").document(userID).setData(data) { error in
                    if let error = error {
                        print(error)
                    }
                }
                self.backToRoot()
            } else {
                print("Signed up failed")
                self.alert(message: error?.localizedDescription ?? "Unknown error", title: "Error")
            }
        }
    }
}
