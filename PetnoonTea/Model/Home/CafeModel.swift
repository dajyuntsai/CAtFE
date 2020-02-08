//
//  CafeModel.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/5.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation
import MapKit

struct CafeModel: Codable {
    var data: [Cafe]
}

struct Cafe: Codable {
    var id: Int
    var name: String
    var tel: String
    var address: String
    var petType: String
    var latitude: Double
    var longitude: Double
    var wifi: Bool
    var website: String
    var facebook: String
    var notes: String
}
