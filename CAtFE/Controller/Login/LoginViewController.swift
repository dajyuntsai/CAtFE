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
import Alamofire

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var shopBtn: UIButton!
    @IBOutlet weak var appleSignInView: UIView!
    @IBOutlet weak var facebookLoginView: UIView!
    @IBAction func privacyPolicyBtn(_ sender: Any) {
        let prsentVC = CafeWebsiteViewController()
        prsentVC.cafeUrl = "https://github.com/ninnnnn/PrivacyPolicy/blob/master/README.md"
        self.show(prsentVC, sender: nil)
    }
    
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
        let presentVC = UIStoryboard.shopLogin
            .instantiateViewController(identifier: ShopLoginViewController.identifier)
            as? ShopLoginViewController
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
    
    func getUserInfo(token: String) {
        userProvider.getUserInfo(token: token) { (result) in
            switch result {
            case .success(let data):
                KeyChainManager.shared.name = data.user.name
                KeyChainManager.shared.email = data.user.email
                KeyChainManager.shared.avatar = data.user.avatar
                self.loginSuccess()
            case .failure:
                CustomProgressHUD.showFailure(text: "登入失敗")
            }
        }
    }
    
    func updateUserInfo(token: String, name: String, email: String) {
        userProvider.updateUserInfo(token: token, name: name, email: email) { (result) in
            switch result {
            case .success:
                self.loginSuccess()
            case .failure(let error):
                CustomProgressHUD.showFailure(text: "更新使用者資料失敗： \(error.localizedDescription)")
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let idToken = appleIDCredential.identityToken else { return }
        let givenName = appleIDCredential.fullName?.givenName ?? ""
        let familyName = appleIDCredential.fullName?.familyName ?? ""
        let fullName = givenName +  " " + familyName
        let email = appleIDCredential.email ?? ""
        let appleToken = String(data: idToken, encoding: .utf8) ?? "Apple Sign in: No ID Token Returned"

        let url = URL(string: "https://catfe.herokuapp.com/users/appleLogin/")!
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(appleToken.data(using: .utf8)!, withName: "token")
        }, to: url,
           method: .post).response { (response) in
            if let statusCode = response.response?.statusCode {
                NSLog("statusCode: \(statusCode)")
            }
            switch response.result {
            case .success(let data):
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) ,
                    let jsonDict = json as? [String: Any] {
                    NSLog("jsonDict : \(jsonDict)")
                    guard let access = jsonDict["access"] as? String else { return }
                    KeyChainManager.shared.token = access
                    if fullName == " " || email == "" {
                        self.getUserInfo(token: access)
                    } else {
                        self.updateUserInfo(token: access, name: fullName, email: email)
                    }
                } else {
                    CustomProgressHUD.showFailure(text: "登入失敗")
                }
            case .failure(let error):
                NSLog("error: \(error.localizedDescription)")
                self.dismiss(animated: true, completion: nil)
                CustomProgressHUD.showFailure(text: "登入失敗")
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
        guard let token = result!.token?.tokenString else {
            let fbError = FacebookError.noToken
            CustomProgressHUD.showFailure(text: fbError.rawValue)
            return 
        }
        
        let url = URL(string: "https://catfe.herokuapp.com/users/fbLogin/")!
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(token.data(using: .utf8)!, withName: "token")
        }, to: url,
           method: .post).response { (response) in
            if let statusCode = response.response?.statusCode {
                NSLog("statusCode: \(statusCode)")
            }
            switch response.result {
            case .success(let data):
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) ,
                    let jsonDict = json as? [String: Any] {
                    NSLog("jsonDict : \(jsonDict)")
                    guard let access = jsonDict["access"] as? String else { return }
                    KeyChainManager.shared.token = access
//                    self.userProvider.getUserDataFromFB(fbToken: token)
                    self.getUserInfo(token: access)
                }
            case .failure(let error):
                NSLog("error: \(error.localizedDescription)")
                self.dismiss(animated: true, completion: nil)
                CustomProgressHUD.showFailure(text: "登入失敗")
            }
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
      // Do something when the user logout
      print("Logged out")
    }

    func loginSuccess() {
        CustomProgressHUD.showSuccess(text: "登入成功")
        setLoginState(state: true)
        backToRoot()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public func setLoginState(state: Bool) {
        let loginState = UserDefaults.standard
        loginState.set(state, forKey: "loginState")
        loginState.synchronize() // 資料即時存入，才不會有nil的問題
    }
}
