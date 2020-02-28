//
//  MessageBoardSingleton.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/28.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MessageBoardObject: NSObject {
    
    static let shared = MessageBoardObject()
    
    private override init() {}
    
    var likeList: [Int] = []
}
