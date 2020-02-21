//
//  UserObject.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/8.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

class UserObject: Codable {
    var results: [User]
}

class User: Codable {
    var email: String
    var password: String
    var name: String
    var active: Bool
    var avatar: String
    var point: Int

    enum CodingKeys: String, CodingKey {
        case email
        case password
        case name
        case active
        case avatar
        case point
    }
}

class LoginResponse: Codable {
    var access: String
    var refresh: String
}

class UserInfo: Codable {
    var user: User
}
