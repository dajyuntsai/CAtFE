//
//  LoginViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/23.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var shopBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        guestBtn.layer.cornerRadius = guestBtn.frame.width / 2
        shopBtn.layer.cornerRadius = shopBtn.frame.width / 2
    }

    @IBAction func fbLogin(_ sender: Any) {
        let presentVC = UIStoryboard.fbLogin.instantiateViewController(withIdentifier: FBLoginViewController.identifier) as? FBLoginViewController
        presentVC?.modalPresentationStyle = .overFullScreen
        self.present(presentVC!, animated: false, completion: nil)
    }
    
    @IBAction func appleSignIn(_ sender: Any) {
    }
    
    @IBAction func guestLogin(_ sender: Any) {
        backToRoot() // 直接進首頁
    }
    
    @IBAction func shopLogin(_ sender: Any) {
        let presentVC = UIStoryboard.shopLogin.instantiateViewController(identifier: ShopLoginViewController.identifier) as? ShopLoginViewController
        presentVC?.modalPresentationStyle = .formSheet
        self.present(presentVC!, animated: true, completion: nil)
    }
}
