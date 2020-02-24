//
//  RatedModel.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

struct CafeScores: Codable {
    let traffic: Double
    let meal: Double
    let loveOne: Double
    let price: Double
    let surroundin: Double
    
    enum CodingKeys: String, CodingKey {
    case traffic
    case meal
    case loveOne = "love_one"
    case price
    case surroundin
    }
}
