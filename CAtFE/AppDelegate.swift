//
//  AppDelegate.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/19.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)

        let handled: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        
        return handled
    }
}
