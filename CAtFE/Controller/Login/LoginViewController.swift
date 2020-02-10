//
//  LoginViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/23.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var shopBtn: UIButton!
    @IBOutlet weak var appleSignInView: UIView!
    @IBOutlet weak var facebookLoginView: UIView!

    let userProvider = UserProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        guestBtn.layer.cornerRadius = 10
        shopBtn.layer.cornerRadius = 10
        appleSignInBtn()
        facebookLoginBtn()
    }

    func appleSignInBtn() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(onAppleSignIn), for: .touchUpInside)
        authorizationButton.cornerRadius = 10
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        appleSignInView.addSubview(authorizationButton)
        NSLayoutConstraint.activate([
            authorizationButton.topAnchor.constraint(equalTo: appleSignInView.topAnchor, constant: 0),
            authorizationButton.bottomAnchor.constraint(equalTo: appleSignInView.bottomAnchor, constant: 0),
            authorizationButton.leadingAnchor.constraint(equalTo: appleSignInView.leadingAnchor, constant: 0),
            authorizationButton.trailingAnchor.constraint(equalTo: appleSignInView.trailingAnchor, constant: 0)
        ])
    }

    func facebookLoginBtn() {
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.layer.cornerRadius = 30
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginView.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: facebookLoginView.topAnchor, constant: 0),
            loginButton.bottomAnchor.constraint(equalTo: facebookLoginView.bottomAnchor, constant: 0),
            loginButton.leadingAnchor.constraint(equalTo: facebookLoginView.leadingAnchor, constant: 0),
            loginButton.trailingAnchor.constraint(equalTo: facebookLoginView.trailingAnchor, constant: 0)
        ])
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

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        userProvider.loginWithFaceBook(from: self) { (result) in
            switch result {
            case .success:
                self.fbLoginSuccess()
            case .failure( _):
                CustomProgressHUD.showSuccess(text: "Facebook 登入失敗")
            }
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
      // Do something when the user logout
      print("Logged out")
    }

    func fbLoginSuccess() {
        backToRoot()
        CustomProgressHUD.showSuccess(text: "Facebook 登入成功")
        let loginState = UserDefaults.standard
        loginState.set(true, forKey: "loginState")
        loginState.synchronize() // 資料即時存入，才不會有nil的問題
    }
}
