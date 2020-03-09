//
//  UserProvider.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/25.
//  Copyright © 2020 Ninn. All rights reserved.
//

import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

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
                self.fbLogin(token: token, view: from) { (result) in
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
    
    func fbLogin(token: String, view: UIViewController, completion: @escaping (Result<LoginResponse>) -> Void) {
        HTTPClient.shared.request(UserRequest.loginWithfb(token)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(LoginResponse.self, from: data)
                    KeyChainManager.shared.token = response.access
                    self.getUserDataFromFB(fbToken: token)
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
                                    parameters: ["fields": "name, email, id"])) { (_, result, error) in
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
            KeyChainManager.shared.name = name
            KeyChainManager.shared.email = email
            KeyChainManager.shared.avatar = userPictureUrl
        }
        connection.start()
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
                     role: String,
                     completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(UserRequest.register(email, password, name, role)) { (result) in
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
                        name: String?,
                        email: String?,
                        completion: @escaping (Result<Void>) -> Void) {
        HTTPClient.shared.request(UserRequest.updateUserInfo(token, name, email)) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserFollowing(token: String, completion: @escaping (Result<CafeList>) -> Void) {
        HTTPClient.shared.request(UserRequest.getFollowing(token)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let cafeList = try self.decoder.decode(CafeList.self, from: data)
                    completion(.success(cafeList))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
