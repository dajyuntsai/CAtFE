//
//  UITextField +Extension.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/13.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

extension UITextView {
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
