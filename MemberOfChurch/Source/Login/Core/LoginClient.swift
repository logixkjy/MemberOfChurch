//
//  LoginClient.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/22/25.
//``

import ComposableArchitecture

struct LoginClient {
    var userLogin: @Sendable (String, String) async -> AsyncStream<LoginEntity>
    var userLogout: () -> Void
}

extension LoginClient {
    internal static var live : Self {
        let networkService = NetworkService.shared
        
        return Self(
            userLogin: { id, pw in
                return AsyncStream<LoginEntity> { continuation in
                    let apiUrl = String.init(format: LoginAPI.login.rawValue, id, pw)
                    
                    networkService.create(method: .get,
                                          apiURL: apiUrl,
                                          completion: { (response: LoginEntity?) in
                        
                        if let response = response {
                            continuation.yield(response)
                            continuation.finish()
                        }
                    })
                }
            },
            userLogout: {
                UserEnvironment.logout()
            }
        )
    }
}

extension LoginClient: DependencyKey {
    internal static var liveValue: Self { .live }
}

extension DependencyValues {
    internal var loginClient: LoginClient {
        get { self[LoginClient.self] }
        set { self[LoginClient.self] = newValue }
    }
}

