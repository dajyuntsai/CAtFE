//
//  UIStoryboard+Extension.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/30.
//  Copyright © 2020 Ninn. All rights reserved.
//

import Foundation

import UIKit

private struct StoryboardCategory {
    static let main = "Main"
    static let tabBar = "TabBar"
    static let fbLogin = "FBLogin"
    static let shopLogin = "ShopLogin"
    static let shopEvent = "ShopEvent"
    static let rated = "Rated"
    static let home = "Home"
    static let messageBoard = "MessageBoard"
    static let member = "Member"
    static let popup = "Popup"
    static let createCafe = "CreateCafe"
}

extension UIStoryboard {
    static var main: UIStoryboard { return ptStoryboard(name: StoryboardCategory.main) }
    static var tabBar: UIStoryboard { return ptStoryboard(name: StoryboardCategory.tabBar) }
    static var fbLogin: UIStoryboard { return ptStoryboard(name: StoryboardCategory.fbLogin) }
    static var shopLogin: UIStoryboard { return ptStoryboard(name: StoryboardCategory.shopLogin) }
    static var shopEvent: UIStoryboard { return ptStoryboard(name: StoryboardCategory.shopEvent) }
    static var rated: UIStoryboard { return ptStoryboard(name: StoryboardCategory.rated) }
    static var home: UIStoryboard { return ptStoryboard(name: StoryboardCategory.home) }
    static var messageBoard: UIStoryboard { return ptStoryboard(name: StoryboardCategory.messageBoard) }
    static var member: UIStoryboard { return ptStoryboard(name: StoryboardCategory.member) }
    static var popup: UIStoryboard { return ptStoryboard(name: StoryboardCategory.popup) }
    static var createCafe: UIStoryboard { return ptStoryboard(name: StoryboardCategory.createCafe) }
    private static func ptStoryboard(name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
}
