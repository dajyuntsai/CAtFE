//
//  LoginViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/23.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var shopBtn: UIButton!
    @IBOutlet weak var appleSignInView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        guestBtn.layer.cornerRadius = guestBtn.frame.width / 2
        shopBtn.layer.cornerRadius = shopBtn.frame.width / 2
        shopBtn.setImage(UIImage(named: "DOLA"), for: .normal)

        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(onAppleSignIn), for: .touchUpInside)
        authorizationButton.cornerRadius = 10
        appleSignInView.addSubview(authorizationButton)
    }

    @IBAction func fbLogin(_ sender: Any) {
        let presentVC = UIStoryboard.fbLogin.instantiateViewController(identifier: FBLoginViewController.identifier) as? FBLoginViewController
        presentVC?.modalPresentationStyle = .overFullScreen
        self.present(presentVC!, animated: false, completion: nil)
    }
    
    @IBAction func guestLogin(_ sender: Any) {
        backToRoot() // 直接進首頁
    }
    
    @IBAction func shopLogin(_ sender: Any) {
        let presentVC = UIStoryboard.shopLogin.instantiateViewController(identifier: ShopLoginViewController.identifier) as? ShopLoginViewController
        presentVC?.modalPresentationStyle = .formSheet
        self.present(presentVC!, animated: true, completion: nil)
    }

    @objc func onAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email
            let token = appleIDCredential.identityToken
        print("User id is \(userIdentifier) \n token is \(String(describing: token)) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
        backToRoot()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("=======Apple Sign In Error: \(error)")
    }
}
