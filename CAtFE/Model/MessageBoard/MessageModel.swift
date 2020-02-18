//
//  MessageModel.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/12.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

struct Message: Codable {
    let id: Int
    let comment: String
//    let cafe: Cafe
//    let user: User
    let photos: [Photos]
    let createAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case comment
//        case cafe
//        case user
        case photos
        case createAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Photos: Codable {
    let id: Int
    let url: String
    let isPrimary: Bool
}

struct CafeComment {
    let cafeName: String
    let userName: String
    let userImage: String
    let timeAgo: String
    let postPhotos: [String]
    let content: String
}
