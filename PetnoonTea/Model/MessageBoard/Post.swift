//
//  Post.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

struct Post {
    var createdBy: User
    var timeAgo: String?
    var caption: String?
    var image: UIImage?
    var message: String?
    var numberOfComments: Int?
    
    static func fetchPosts() -> [Post] {
        var posts = [Post]()
        
        let duc = User(username: "Duc Tran", profileImage: UIImage(named: "home"))
        let post1 = Post(createdBy: duc, timeAgo: "1 hr", caption: "Wise words from Will Smith: The only thing that I see that is distinctly different from me is: I'm not afraid to die on a treadmill. I will not be outworked, period. You might have more talent than me, you might be smarter than me, you might be sexier than me. You might be all of those things. You got it on me in nine categories. But if we get on the treadmill together, there's two things. You're getting off first, or I'm going to die. It's really that simple. Love that. I wish that you'll embrace this mindset in everything that you do. Tonight, when you think about 2017, don't set resolutions but set goals. Trust in your abilities to figure things out. No matter how small you start, start something that matters. With enough time, focus, effort, even resources and mentorship, you will develop new skills and achieve your goals.", image: UIImage(named: "placeholder"), numberOfComments: 32)
        let post2 = Post(createdBy: duc, timeAgo: "3 hrs", caption: "When you work on any thing that matters, it's ok to worry, fear, and be uncomfortable. Just never give up!", image: UIImage(named: "BURU"), numberOfComments: 12)
        let post3 = Post(createdBy: duc, timeAgo: "5 hrs", caption: "New iOS tutorial is up for developers out in the world: JoinDuc.com/iosapp-fb", image: UIImage(named: "BURU"), numberOfComments: 92 )
        
        let brendon = User(username: "Brendon Burchard", profileImage: UIImage(named: "rated"))
        let post4 = Post(createdBy: brendon, timeAgo: "2 hrs", caption: "You are not selfish for desiring a better life. If you appreciate what you have but feel called to the next level, that's something to listen to.", image: UIImage(named: "DOLA"), numberOfComments: 8)
        let post5 = Post(createdBy: brendon, timeAgo: "8 hrs", caption: "No matter how small you start, start something that matters. Believe in your dreams and begin.", image: UIImage(named: "placeholder"), numberOfComments: 83)
        let post6 = Post(createdBy: brendon, timeAgo: "Yesterday", caption: "Congratulations to the graduating class of high performance academy 2017! Thank you for your engagement, joy and confidence. Now go serve the world!", image: UIImage(named: "placeholder"), numberOfComments: 82)
        
        posts.append(post1)
        posts.append(post4)
        posts.append(post2)
        posts.append(post5)
        posts.append(post3)
        posts.append(post6)
        
        return posts
    }
}

struct User {
    var username: String
    var profileImage: UIImage?
}

//{
//    "Status": "Ok",
//    "data": [
//        {
//            "name": "穿越九千公里交給你",
//            "tel": "0972-299822",
//            "address": "台北市松山區民權東路三段160巷19弄16號",
//            "petType": "浣熊",
//            "latitude": 121.548081,
//            "longitude": 25.060198,
//            "website": "",
//            "fb_url": "https://www.facebook.com/travelled9000km/",
//            "notes": ""
//        },
//        {
//            "name": "WAKE n' BAKE",
//            "tel": "02-2765-3225",
//            "address": "台北市信義區永吉路30巷158弄18號",
//            "petType": "貓",
//            "latitude": 121.568043,
//            "longitude": 25.042515,
//            "website": "",
//            "fb_url": "https://www.facebook.com/WakenBake.taipei/",
//            "notes": ""
//        },
//        {
//            "name": "貓欸Camulet貓咪主題餐廳",
//            "tel": "02-8258-1127",
//            "address": "新北市板橋區文化路一段270巷3弄6號",
//            "petType": "貓",
//            "latitude": 121.467761,
//            "longitude": 25.021088,
//            "website": "",
//            "fb_url": "",
//            "notes": ""
//        }
//    ]
//}

//GET http://domain/api/v1/restaurants/2/rating
//{
//    "Status": "Ok",
//    "data": {
//        "pet_friendly": 4,
//        "price": 3,
//        "env": 4,
//        "delicious": 3,
//        "traffic": 5
//    }
//}
