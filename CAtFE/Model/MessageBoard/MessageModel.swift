//
//  MessageModel.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/12.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

class CafeCommentModel: Codable {
    let results: [CafeComments]
}

class CafeComments: Codable {
    let id: Int
    let comment: String
    let photos: [Photo]
    let createAt: String
    let updatedAt: String
    let user: UserDetail?
    let cafe: TinyCafe
    let cafeCommentReplies: [CafeCommentReplies]
//    let likeCount: Int
    var isLike: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case photos
        case createAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case cafe
        case cafeCommentReplies = "cafe_comment_replies"
//        case likeCount
        case isLike
    }
}

class TinyCafe: Codable {
    let id: Int
    let petType: String
    let name: String
    let tel: String
    let address: String
    let latitude: Double
    let longitude: Double
    let fbUrl: String
    let notes: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case petType = "pet_type"
        case name
        case tel
        case address
        case latitude
        case longitude
        case fbUrl = "fb_url"
        case notes
    }
}

class Photo: Codable {
    let id: Int
    let url: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

class UserDetail: Codable {
    let id: Int
    let email: String
    let name: String
    let avatar: String
    let point: Int
}

class CafeCommentReplies: Codable {
    let id: Int
    let text: String
    let user: UserDetail
    let createAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case user
        case createAt = "created_at"
        case updatedAt = "updated_at"
    }
}

class LikeComments: Codable {
    let data: [Int]
}
