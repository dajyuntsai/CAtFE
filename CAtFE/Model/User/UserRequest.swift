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
    case register(String, String, String, String)
    case signIn(String, String, String)
    case loginWithAppleAndFB(String, String, String, String, String)
    
    var headers: [String: String] {
        switch self {
        case .userList:
            return [:]
        case .register:
            return ["Content-Type": "application/json"]
        case .signIn:
            return ["Content-Type": "application/json"]
        case .loginWithAppleAndFB:
            return ["Content-Type": "application/json"]
        }
    }
    
    var body: Data? {
        switch self {
        case .userList:
            return nil
        case .register(let email, let password, let name, let registerType):
            let dict = [
                "email": email,
                "password": password,
                "name": name,
                "registerType": registerType
            ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .signIn(let email, let password, let registerType):
            let dict = [
                "email": email,
                "password": password,
                "registerType": registerType
            ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
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
        case .signIn:
            return HTTPMethod.POST.rawValue
        case .loginWithAppleAndFB:
            return HTTPMethod.PATCH.rawValue
        }
    }
    
    var endPoint: String {
        switch self {
        case .userList:
            return "/users/list?page=1&size=30"
        case .register:
            return "/users/"
        case .signIn:
            return "/users/sessions"
        case .loginWithAppleAndFB:
            return "/users/"
        }
    }
}
