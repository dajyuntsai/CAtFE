//
//  Bundle+Extension.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/5.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

extension Bundle {
    // swiftlint:disable force_cast
    static func valueForString(key: String) -> String {
        
        return Bundle.main.infoDictionary![key] as! String
    }

    static func valueForInt32(key: String) -> Int32 {

        return Bundle.main.infoDictionary![key] as! Int32
    }
    // swiftlint:enable force_cast
}
