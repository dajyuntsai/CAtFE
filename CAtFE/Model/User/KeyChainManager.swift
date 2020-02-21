//
//  KeyChainManager.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/8.
//  Copyright © 2020 Ninn. All rights reserved.
//

import KeychainAccess

class KeyChainManager {

    static let shared = KeyChainManager()
    private let service: Keychain
    private let serverTokenKey: String = "CAtFEToken"
    private let userName: String = "userName"
    private let userEmail: String = "userEmail"
    private let userAvatar: String = "userAvatar"
    private let userPoint: String = "userPoint"
    
    private init() {
        service = Keychain(service: Bundle.main.bundleIdentifier!)
    }

    var token: String? {
        set {
            guard let uuid = UserDefaults.standard.value(forKey: serverTokenKey) as? String else {

                let uuid = UUID().uuidString
                UserDefaults.standard.set(uuid, forKey: serverTokenKey)
                service[uuid] = newValue
                return
            }
            service[uuid] = newValue
        }

        get {
            guard let serverKey = UserDefaults.standard.string(forKey: serverTokenKey) else {
                return nil
            }
            for item in service.allItems() {
                if let key = item["key"] as? String,
                   key == serverKey {
                    return item["value"] as? String
                }
            }
            return nil
        }
    }
    
    var name: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userName)
        }

        get {
            guard let userName = UserDefaults.standard.string(forKey: userName) else {
                return nil
            }
            return userName
        }
    }
    
    var email: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userEmail)
        }

        get {
            guard let userEmail = UserDefaults.standard.string(forKey: userEmail) else {
                return nil
            }
            return userEmail
        }
    }
    
    var avatar: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userAvatar)
        }

        get {
            guard let avatar = UserDefaults.standard.string(forKey: userAvatar) else {
                return nil
            }
            return avatar
        }
    }
    
//    var point: Int? {
//        set {
//            UserDefaults.standard.set(newValue, forKey: userPoint)
//        }
//
//        get {
//            guard let point = UserDefaults.standard.integer(forKey: userPoint) else {
//                return nil
//            }
//            return point
//        }
//    }
}
