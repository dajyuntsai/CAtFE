//
//  MessageModel.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/12.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

struct MessageModel: Codable {
    let data: [Message]
}

struct Message: Codable {
    let id: Int
    let content: String
    let cafe: Cafe
    let user: User
    let photos: [Photos]
    let createAt: String

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
    let id: Int
    let url: String
    let isPrimary: Bool
}
