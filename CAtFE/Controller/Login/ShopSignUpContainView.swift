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
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cafeInfoBgView: UIView!
    var infoVC: CreateCafeViewController?
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let userProvider = UserProvider()
    var isCafeManager = false
    var isNeedNotification = false

    let signUpList = ["我是店家：", "顯示名稱：", "註冊帳號：", "登入密碼：", "再次輸入密碼：", "是否需要傳送推播功能："]
    
    @IBAction func roleBtn(_ sender: UISwitch) {
        if sender.isOn {
            isCafeManager = true
            setUpCafeInfoView(show: true)
        } else {
            isCafeManager = false
            setUpCafeInfoView(show: false)
//            notificationBtn.setOn(!sender.isOn, animated: false)
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
    
    func setUpCafeInfoView(show: Bool) {
        if show && self.infoVC == nil {
            guard let infoVC = UIStoryboard.createCafe.instantiateViewController(identifier: CreateCafeViewController.identifier) as? CreateCafeViewController else {
                return
            }
//            scrollView.contentSize = CGSize(width: width, height: height)
            self.infoVC = infoVC
//            cafeInfoBgView.addChild(infoVC)
            cafeInfoBgView.addSubview(infoVC.view)
//            infoVC.view.frame = CGRect(x: 0, y: height / 2, width: width, height: height)
            infoVC.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                infoVC.view.topAnchor.constraint(equalTo: registerLabel[4].bottomAnchor, constant: 16),
                infoVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                infoVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                infoVC.view.bottomAnchor.constraint(equalTo: sendBtn.topAnchor, constant: 16)
            ])
        } else {
//            scrollView.contentSize = CGSize(width: width, height: height / 2)
            self.infoVC?.removeFromParent()
            cafeInfoBgView.removeFromSuperview()
            self.infoVC = nil
            self.view.layoutIfNeeded()
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
            if isCafeManager {
                onCAtFESignUp(email: account, name: name, password: password, role: "SHOP")
            } else {
                onCAtFESignUp(email: account, name: name, password: password, role: "NORMAL")
            }
        }
    }

    func onCAtFESignUp(email: String, name: String, password: String, role: String) {
        if isCafeManager {
            userProvider.emailSignUp(email: email, name: name, password: password, role: role) { (result) in
                switch result {
                case .success:
                    CustomProgressHUD.showSuccess(text: "CAtFE 註冊成功")
                    self.backToRoot()
                case .failure(let error):
                    CustomProgressHUD.showSuccess(text: "CAtFE 註冊失敗")
                    print(error.localizedDescription)
                }
            }
        } else {
            userProvider.emailSignUp(email: email, name: name, password: password, role: role) { (result) in
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
}
