//
//  AppDelegate.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/19.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let loginState = UserDefaults.standard.bool(forKey: "loginState")
        let rootViewController: UIViewController?
        if loginState {
            rootViewController = UIStoryboard.tabBar.instantiateViewController(identifier: "TabbarController")
        } else {
            rootViewController = UIStoryboard.main.instantiateViewController(identifier: LoginViewController.identifier)
        }
        window?.rootViewController = rootViewController

        IQKeyboardManager.shared.enable = true
        
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        let handled: Bool = ApplicationDelegate.shared.application(app,
                                                                   open: url,
                                                                   sourceApplication: options[.sourceApplication] as? String,
                                                                   annotation: options[.annotation])
        
        return handled
    }
}
