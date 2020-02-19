//
//  CreateCafeModel.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/19.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

enum CellType {
    case text
    case checkBox
    case bool
    case star
    case openTime
}

struct CellContent {
    var type: CellType
    var title: String
    var value: Any?
}

struct Categorys {
    var title: String
    var cellContent: [CellContent]
}
