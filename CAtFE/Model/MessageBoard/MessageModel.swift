//
//  MessageModel.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/12.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

struct MessageModel: Codable {
    var data: [Message]
}

struct Message: Codable {
    var id: Int
    var content: String
    var cafe: Cafe
    var user: User
    var photos: [Photos]
    var createAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case cafe
        case user
        case photos
        case createAt = "create_at"
    }
}

struct Photos: Codable {
    var id: Int
    var url: String
    var isPrimary: Bool
}
