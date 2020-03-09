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
    case register(String, String, String, String) // email, name, password, role
    case login(String, String)
    case userInfo(String)
    case loginWithfb(String)
    case loginWithApple(String)
    case updateUserInfo(String, String?, String?) // token, user name, email
    case getFollowing(String)
    
    var headers: [String: String] {
        switch self {
        case .userList:
            return [:]
        case .register:
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue]
        case .login:
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue]
        case .userInfo(let accessToken):
            return [HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        case .loginWithfb:
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue]
        case .loginWithApple:
            return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue]
        case .updateUserInfo(let accessToken, _, _):
            return [HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)",
                HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue]
        case .getFollowing(let accessToken):
            return [HTTPHeaderField.auth.rawValue: "Bearer \(accessToken)"]
        }
    }
    
    var body: Data? {
        switch self {
        case .userList:
            return nil
        case .register(let email, let password, let name, let role):
            let dict = [
                "email": email,
                "name": name,
                "password": password,
                "role": role
//                "active": true,
//                "avatar": "https://ppt.cc/f5Rfex@.png",
//                "point": 0
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
        case .loginWithfb(let token):
            let dict = ["token": token]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .loginWithApple(let token):
            let dict = ["token": token]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .updateUserInfo(_, let name, let email):
            let dict = [
                "name": name,
                "email": email
                ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .getFollowing:
            return nil
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
        case .loginWithfb:
            return HTTPMethod.POST.rawValue
        case .loginWithApple:
            return HTTPMethod.POST.rawValue
        case .updateUserInfo:
            return HTTPMethod.PATCH.rawValue
        case .getFollowing:
            return HTTPMethod.GET.rawValue
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
        case .loginWithfb:
            return "/users/fbLogin/"
        case .loginWithApple:
            return "/users/appleLogin/"
        case .updateUserInfo:
            return "/users/me/"
        case .getFollowing:
            return "/users/followCafe/"
        }
    }
}
