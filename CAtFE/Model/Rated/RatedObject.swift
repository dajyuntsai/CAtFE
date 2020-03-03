//
//  RatedObject.swift
//  CAtFE
//
//  Created by Ninn on 2020/3/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class RatedObject: NSObject {
    
    static let shared = RatedObject()
    
    private override init() {}
    
    var followingCafes: [Cafe] = []
}
