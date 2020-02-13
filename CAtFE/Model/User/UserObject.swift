//
//  UserObject.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/8.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

struct UserObject: Codable {
    var data: [User]
}

struct User: Codable {
    var id: Int
    var registerType: String
    var name: String
    var email: String
    var avatar: String
    var active: Bool
    var roles: String
    var createAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case registerType
        case name
        case email
        case avatar
        case active
        case roles
        case createAt = "create_at"
    }
}

struct APIResponse: Codable {
    let status: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case token
    }
}
