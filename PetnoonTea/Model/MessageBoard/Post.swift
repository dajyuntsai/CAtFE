//
//  Post.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

struct Post {
    var createdBy: UserTest
    var timeAgo: String?
    var caption: String?
    var image: UIImage?
    var message: String?
    var numberOfComments: Int?

    static func fetchPosts() -> [Post] {
        var posts = [Post]()
        
        let duc = UserTest(username: "Duc Tran", profileImage: UIImage(named: "home"))
        let post1 = Post(createdBy: duc, timeAgo: "1 hr", caption: "這是一則測試留言", image: UIImage(named: "placeholder"), numberOfComments: 32)
        let post2 = Post(createdBy: duc, timeAgo: "3 hrs", caption: "這是第二則測試留言", image: UIImage(named: "BURU"), numberOfComments: 12)
        let post3 = Post(createdBy: duc, timeAgo: "5 hrs", caption: "很多測試留言", image: UIImage(named: "BURU"), numberOfComments: 92 )

        let brendon = UserTest(username: "Brendon Burchard", profileImage: UIImage(named: "rated"))
        let post4 = Post(createdBy: brendon, timeAgo: "2 hrs", caption: "內容太長swiftlint不給過", image: UIImage(named: "DOLA"), numberOfComments: 8)
        let post5 = Post(createdBy: brendon, timeAgo: "8 hrs", caption: "內容太長swiftlint不給過", image: UIImage(named: "placeholder"), numberOfComments: 83)
        let post6 = Post(createdBy: brendon, timeAgo: "Yesterday", caption: "內容太長swiftlint不給過", image: UIImage(named: "placeholder"), numberOfComments: 82)

        posts.append(post1)
        posts.append(post4)
        posts.append(post2)
        posts.append(post5)
        posts.append(post3)
        posts.append(post6)
        
        return posts
    }
}

struct UserTest {
    var username: String
    var profileImage: UIImage?
}
