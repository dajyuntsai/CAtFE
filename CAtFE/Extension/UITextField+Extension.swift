//
//  UITextField+Extension.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/16.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

extension UITextField {
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
