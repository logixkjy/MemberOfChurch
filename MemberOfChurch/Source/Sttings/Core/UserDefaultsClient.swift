//
//  UserDefaultsClient.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/17/25.
//

import ComposableArchitecture
import Foundation
import UIKit

// 키 모음
enum UDKeys {
    static let isAutoLogin = "isAutoLogin"
    static let userID = "userID"
}

// 의존성 래퍼
struct UserDefaultsClient {
    var stringForKey: (String) -> String
    var boolForKey: (String) -> Bool
    var setBool: (Bool, String) -> Void
    var appVersion: () -> String
    var openURL: (URL) async -> Bool
}

extension UserDefaultsClient: DependencyKey {
    static var liveValue: UserDefaultsClient = .init(
        stringForKey: { key in
            UserDefaults.standard.string(forKey: key) ?? ""
        },
        boolForKey: { key in
            UserDefaults.standard.bool(forKey: key)
        },
        setBool: { value, key in
            UserDefaults.standard.set(value, forKey: key)
        },
        appVersion: {
          let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
          return "\(v)"
        },
        openURL: { @MainActor url in
          await UIApplication.shared.open(url)
        }
    )
    static var testValue: UserDefaultsClient = .init(
        stringForKey: { _ in "" },
        boolForKey: { _ in false },
        setBool: { _, _ in },
        appVersion: { "" },
        openURL: { _ in false }
    )
}

extension DependencyValues {
    var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
