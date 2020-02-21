//
//  UserManager.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/8.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

enum UserRequest: CAtFERequest {
    case userList
    case register(String, String, String)
    case login(String, String)
    case userInfo(String)
    case loginWithAppleAndFB(String, String, String, String, String)
    
    var headers: [String: String] {
        switch self {
        case .userList:
            return [:]
        case .register:
            return [HTTPHeaderField.contentType.rawValue: "application/json"]
        case .login:
            return [HTTPHeaderField.contentType.rawValue: "application/json"]
        case .userInfo(let accessToken):
            return [HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        case .loginWithAppleAndFB:
            return [HTTPHeaderField.contentType.rawValue: "application/json"]
        }
    }
    
    var body: Data? {
        switch self {
        case .userList:
            return nil
        case .register(let email, let password, let name):
            let dict = [
                "email": email,
                "password": password,
                "name": name,
                "active": true,
                "avatar": "https://ppt.cc/f5Rfex@.png",
                "point": 0
                ] as [String: Any]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .login(let email, let password):
            let dict = [
                "email": email,
                "password": password
            ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .userInfo:
            return nil
        case .loginWithAppleAndFB(let token, let email, let name, let registerType, let avatar):
            let dict = [
                "email": email,
                "name": name,
                "registerType": registerType,
                "avatar": avatar,
                "token": token
            ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }
    }
        
    var method: String {
        switch self {
        case .userList:
            return HTTPMethod.GET.rawValue
        case .register:
            return HTTPMethod.POST.rawValue
        case .login:
            return HTTPMethod.POST.rawValue
        case .userInfo:
            return HTTPMethod.GET.rawValue
        case .loginWithAppleAndFB:
            return HTTPMethod.PATCH.rawValue
        }
    }
    
    var endPoint: String {
        switch self {
        case .userList:
            return "/users/"
        case .register:
            return "/users/"
        case .login:
            return "/users/login/"
        case .userInfo:
            return "/users/me/"
        case .loginWithAppleAndFB:
            return "/users/"
        }
    }
}
