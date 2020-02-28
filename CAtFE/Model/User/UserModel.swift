//
//  UserObject.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/8.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

class UserModel: Codable {
    var results: [User]
}

class User: Codable {
    var id: Int
    var email: String
    var password: String
    var name: String
    var active: Bool
    var avatar: String?
    var point: Int
}

class LoginResponse: Codable {
    var access: String
    var refresh: String
}

class UserInfo: Codable {
    var user: User
}
