//
//  MemberClient.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/26/25.
//

import ComposableArchitecture

struct MemberClient {
    var memberList: @Sendable () async -> AsyncStream<MemberListEntity>
}

extension MemberClient {
    internal static var live : Self {
        let networkService = NetworkService.shared
        
        return Self(
            memberList: {
                return AsyncStream<MemberListEntity> { continuation in
                    networkService.create(method: .get,
                                          apiURL: MemberApi.memberList.rawValue,
                                          completion: { (response: MemberListEntity?) in
                        
                        if let response = response {
                            continuation.yield(response)
                            continuation.finish()
                        }
                    })
                }
            }
        )
    }
}

extension MemberClient: DependencyKey {
    internal static var liveValue: Self { .live }
}

extension DependencyValues {
    internal var memberClient: MemberClient {
        get { self[MemberClient.self] }
        set { self[MemberClient.self] = newValue }
    }
}
