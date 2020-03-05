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
    private let fbTokenKey: String = "fbToken"
    private let cafeTokenKey: String = "CAtFEToken"
    private let userName: String = "userName"
    private let userEmail: String = "userEmail"
    private let userAvatar: String = "userAvatar"
    private let userId: String = "userId"
    private let appleIdentifier: String = "appleIdentifier"
    
    private init() {
        service = Keychain(service: Bundle.main.bundleIdentifier!)
    }
    
    var fbToken: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: fbTokenKey)
        }

        get {
            guard let fbToken = UserDefaults.standard.string(forKey: fbTokenKey) else {
                return nil
            }
            return fbToken
        }
    }

    var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: cafeTokenKey)
        }

        get {
            guard let cafeToken = UserDefaults.standard.string(forKey: cafeTokenKey) else {
                return nil
            }
            return cafeToken
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
    
    var id: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: userId)
        }
        
        get {
            return UserDefaults.standard.integer(forKey: userId)
        }
    }
    
    var identifier: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: appleIdentifier)
        }

        get {
            guard let identifier = UserDefaults.standard.string(forKey: appleIdentifier) else {
                return nil
            }
            return identifier
        }
    }
}
