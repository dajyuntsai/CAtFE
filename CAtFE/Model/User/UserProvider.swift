//
//  UserProvider.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/25.
//  Copyright © 2020 Ninn. All rights reserved.
//

import FBSDKLoginKit
import FBSDKCoreKit

typealias FacebookResponse = (Result<String>) -> Void

enum FacebookError: String, Error {
    case noToken = "讀取 Facebook 資料發生錯誤！"
    case userCancel
    case denineEmailPermission = "請允許存取 Facebook email！"
}

class UserProvider {
    let decoder = JSONDecoder()
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
                self.getUserDataFromFB(fbToken: token)
                self.fbLogin(token: token) { (result) in
                    switch result {
                    case .success:
                        print("FB登入成功")
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                completion(Result.success(token))
            }
        })
    }
    
    func fbLogin(token: String, completion: @escaping (Result<LoginResponse>) -> Void) {
        HTTPClient.shared.request(UserRequest.loginWithfb(token)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(LoginResponse.self, from: data)
                    KeyChainManager.shared.token = response.access
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getUserDataFromFB(fbToken: String) {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me",
                                    parameters: ["fields": "email, name, id"])) { (_, result, error) in
            if error != nil {
                NSLog(error.debugDescription)
                return
            }
            guard let result = result as? [String: String] else {
                return
            }
            let email: String = result["email"]!
            let name: String = result["name"]!
            let id: String = result["id"]!
            let userPictureUrl = "http://graph.facebook.com/\(id)/picture?type=large"
            self.uploadUserData(token: fbToken,
                                email: email,
                                name: name,
                                registerType: "facebook",
                                avator: userPictureUrl) { (response) in
                switch response {
                case .success:
                    KeyChainManager.shared.name = name
                    KeyChainManager.shared.email = email
                    KeyChainManager.shared.avatar = userPictureUrl
                case .failure(let error):
                    print("======= getUserDataFromFB error: \(error)")
                }
            }
        }
        connection.start()
    }

    func uploadUserData(token: String,
                        email: String,
                        name: String,
                        registerType: String,
                        avator: String,
                        completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(UserRequest.loginWithfb(token)) { (result) in
            switch result {
            case .success:
                completion(Result.success(()))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }

    func loginWithApple(token: String, completion: @escaping (Result<LoginResponse>) -> Void) {
        HTTPClient.shared.request(UserRequest.loginWithApple(token)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(LoginResponse.self, from: data)
                    KeyChainManager.shared.token = response.access
                    completion(Result.success(response))
                } catch {
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(Result.failure(error))
                print(error)
            }
        }
    }

    func emailSignUp(email: String,
                     name: String,
                     password: String,
//                     avatar: String,
                     completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(UserRequest.register(email, password, name)) { (result) in
            switch result {
            case .success:
                completion(Result.success(()))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func emailLogin(email: String,
                    password: String,
                    completion: @escaping (Result<LoginResponse>) -> Void) {
        HTTPClient.shared.request(UserRequest.login(email, password)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(LoginResponse.self, from: data)
                    KeyChainManager.shared.token = response.access
                    completion(Result.success(response))
                } catch {
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func getUserInfo(token: String, completion: @escaping (Result<UserInfo>) -> Void) {
        HTTPClient.shared.request(UserRequest.userInfo(token)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(UserInfo.self, from: data)
                    completion(Result.success(response))
                } catch {
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func updateUserInfo(token: String,
                        name: String,
                        avatar: String,
                        password: String,
                        completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(UserRequest.updateUserInfo(token, name, avatar, password)) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateUserName(token: String,
                        name: String,
                        completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(UserRequest.updateUserName(token, name)) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
