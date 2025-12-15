//
//  Environment.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/22/25.
//

import Foundation

struct UserEnvironment {
    static var userID: String {
        get {
            return UserDefaults.standard.string(forKey: "userID") ?? ""
        }
        set(newVal) {
            return UserDefaults.standard.setValue(newVal, forKey: "userID")
        }
    }
    
    static var userPW: String {
        get {
            return UserDefaults.standard.string(forKey: "userPW") ?? ""
        }
        set(newVal) {
            return UserDefaults.standard.setValue(newVal, forKey: "userPW")
        }
    }
    
    static var isAutoLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isAutoLogin")
        }
        set(newVal) {
            return UserDefaults.standard.setValue(newVal, forKey: "isAutoLogin")
        }
    }
    
    static var isLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
        set(newVal) {
            return UserDefaults.standard.setValue(newVal, forKey: "isLogin")
        }
    }
    
    static func logout() {
        UserEnvironment.userID = ""
        UserEnvironment.userPW = ""
        UserEnvironment.isLogin = false
//        UserEnvironment.isAutoLogin = false
    }
}
