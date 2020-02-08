//
//  UserObject.swift
//  PetnoonTea
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
    var active: String
    var roles: Int
    var createAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case registerType
        case name
        case email
        case active
        case roles
        case createAt = "create_at"
    }
}
