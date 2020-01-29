//
//  UIColor+Extension.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/27.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

private enum ThemeColor: String {
    case MainColor
    case TextColor
}

extension UIColor {
    static let MainColor = ThemeColor(.MainColor)
    static let TextColor = ThemeColor(.TextColor)
        
    private static func ThemeColor(_ color: ThemeColor) -> UIColor? {

        return UIColor(named: color.rawValue)
    }

    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
