//
//  FellowshipClient.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/8/25.
//

import ComposableArchitecture

struct FellowshipClient {
    var fellowshipList: @Sendable () async -> AsyncStream<FellowshipListEntity>
}

extension FellowshipClient {
    internal static var live : Self {
        let networkService = NetworkService.shared
        
        return Self(
            fellowshipList: {
                return AsyncStream<FellowshipListEntity> { continuation in
                    networkService.create(method: .get,
                                          apiURL: FellowshipApi.fellowshipList.rawValue,
                                          completion: { (response: FellowshipListEntity?) in
                        
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

extension FellowshipClient: DependencyKey {
    internal static var liveValue: Self { .live }
}

extension DependencyValues {
    internal var fellowshipClient: FellowshipClient {
        get { self[FellowshipClient.self] }
        set { self[FellowshipClient.self] = newValue }
    }
}
