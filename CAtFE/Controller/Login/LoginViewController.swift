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
        facebookLoginView.layer.cornerRadius = 10
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginView.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: facebookLoginView.topAnchor, constant: 0),
            loginButton.bottomAnchor.constraint(equalTo: facebookLoginView.bottomAnchor, constant: 0),
            loginButton.leadingAnchor.constraint(equalTo: facebookLoginView.leadingAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: facebookLoginView.trailingAnchor, constant: -10)
        ])
    }
    
    @IBAction func guestLogin(_ sender: Any) {
        setLoginState(state: false)
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
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let idToken = appleIDCredential.identityToken else { return }
        let userIdentifier = appleIDCredential.user
        let givenName = appleIDCredential.fullName?.givenName ?? "Apple Sign in: No givenName"
        let familyName = appleIDCredential.fullName?.familyName ?? "Apple Sign in: No familyName"
        let fullName = givenName +  " " + familyName
        let email = appleIDCredential.email ?? "Apple Sign in: No Email Provided"
        let appleToken = String(data: idToken, encoding: .utf8) ?? "Apple Sign in: No ID Token Returned"

        userProvider.loginWithApple(token: appleToken,
                                    email: email,
                                    name: fullName,
                                    registerType: "apple",
                                    avator: "") { (result) in
            switch result {
            case .success:
                self.appleLoginSuccess()
                self.backToRoot()
            case .failure(let error):
                CustomProgressHUD.showFailure(text: "Apple Sign In 登入失敗")
                print(error)
            }
        }
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
        setLoginState(state: true)
        backToRoot()
        CustomProgressHUD.showSuccess(text: "Facebook 登入成功")
    }

    func appleLoginSuccess() {
        setLoginState(state: true)
        backToRoot()
        CustomProgressHUD.showSuccess(text: "Apple Sign In 登入成功")
    }
    
    public func setLoginState(state: Bool) {
        let loginState = UserDefaults.standard
        loginState.set(state, forKey: "loginState")
        loginState.synchronize() // 資料即時存入，才不會有nil的問題
    }
}
