//
//  CafeModel.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/5.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

struct CafeModel: Codable {
    let results: [Cafe]
}

struct Cafe: Codable {
    let id: Int
    let petType: String
    let name: String
    let tel: String
    let address: String
    let latitude: Double
    let longitude: Double
    let fbUrl: String
    let notes: String
    let cafeComments: [CafeComments]
    let cafeScores: [CafeScores]
    let trafficAverage: Double
    let mealAverage: Double
    let loveOneAverage: Double
    let priceAverage: Double
    let surroundingAverage: Double

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
        case cafeComments = "cafe_comments"
        case cafeScores = "cafe_scores"
        case trafficAverage = "traffic_average"
        case mealAverage = "meal_average"
        case loveOneAverage = "love_one_average"
        case priceAverage = "price_average"
        case surroundingAverage = "surrounding_average"
    }
}
