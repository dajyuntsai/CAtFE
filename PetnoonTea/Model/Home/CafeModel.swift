//
//  CafeModel.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/5.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

class CafeModel: Codable {
    let data: [Cafe]
}

class Cafe: Codable {
    let id: Int
    let name: String
    let tel: String
    let address: String
    let petType: String
    let latitude: Double
    let longitude: Double
    let website: String
    let facebook: String
    let notes: String
}
