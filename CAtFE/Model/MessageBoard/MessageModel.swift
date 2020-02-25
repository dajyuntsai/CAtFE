//
//  MessageModel.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/12.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

struct CafeCommentModel: Codable {
    let results: [CafeComments]
}

struct CafeComments: Codable {
    let id: Int
    let comment: String
    let photos: [Photo]
    let createAt: String
    let updatedAt: String
    let user: UserDetail?
    let cafeCommentReplies: [CafeCommentReplies]

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case photos
        case createAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case cafeCommentReplies = "cafe_comment_replies"
    }
}

struct Photo: Codable {
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

struct UserDetail: Codable {
    let id: Int
    let email: String
    let name: String
    let avatar: String
    let point: Int
}

struct CafeCommentReplies: Codable {
    let id: Int
    let text: String
    let user: UserDetail
    let likeCount: Int
    let createAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case user
        case likeCount = "like_count"
        case createAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Comments {
    let messageId: Int
    let cafeName: String
    let userName: String
    let userImage: String
    let timeAgo: String
    let updateTime: Double
    let postPhotos: [String]
    let content: String
    let commentReplies: [CafeCommentReplies]
}
