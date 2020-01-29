//
//  FBLoginViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/27.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class FBLoginViewController: BaseViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let provider = UserProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @IBAction func fbLogin(_ sender: Any) {
        provider.loginWithFaceBook(from: self) { (result) in
            switch result{
            case .success(let token):
                print("=======", token)
                self.fbLoginSuccess()
            case .failure(let error):
                print("=======", error)
                CustomProgressHUD.showSuccess(text: "Facebook 登入失敗")
            }
        }
    }
    
    @IBAction func loginCancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func fbLoginSuccess() {
        backToRoot()
        CustomProgressHUD.showSuccess(text: "Facebook 登入成功")
        let loginState = UserDefaults.standard
        loginState.set(true, forKey: "loginState")
        loginState.synchronize() // 資料即時存入，才不會有nil的問題
    }
}
