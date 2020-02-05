//
//  UserProvider.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/25.
//  Copyright © 2020 Ninn. All rights reserved.
//

import FBSDKLoginKit
import Firebase

typealias FacebookResponse = (Result<String>) -> Void

enum FacebookError: String, Error {
    case noToken = "讀取 Facebook 資料發生錯誤！"
    case userCancel
    case denineEmailPermission = "請允許存取 Facebook email！"
}

class UserProvider {
    func loginWithFaceBook(from: UIViewController, completion: @escaping FacebookResponse) {
        LoginManager().logIn(permissions: ["email"], from: from, handler: { (result, error) in
            guard error == nil else { return completion(Result.failure(error!)) }
            guard let result = result else {
                let fbError = FacebookError.noToken
                CustomProgressHUD.showFailure(text: fbError.rawValue)
                return completion(Result.failure(fbError))
            }
            switch result.isCancelled {
            case true: break
            case false:
                guard result.declinedPermissions.contains("email") == false else {
                    let fbError = FacebookError.denineEmailPermission
                    CustomProgressHUD.showFailure(text: fbError.rawValue)
                    return completion(Result.failure(fbError))
                }

                guard let token = result.token?.tokenString else {
                    let fbError = FacebookError.noToken
                    CustomProgressHUD.showFailure(text: fbError.rawValue)
                    return completion(Result.failure(fbError))
                }
                
                UserDefaults.standard.set(token, forKey: "FBtoken")
                completion(Result.success(token))
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token)

                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        return
                    }
                })
            }
        })
    }
    
    func signUpWithShop() {
        
    }
    
    func loginWithApple() {
        
    }
}
