//
//  CatechumenClient.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/8/25.
//

import ComposableArchitecture

struct CatechumenClient {
    var catechumenList: @Sendable () async -> AsyncStream<CatechumenListEntity>
}

extension CatechumenClient {
    internal static var live : Self {
        let networkService = NetworkService.shared
        
        return Self(
            catechumenList: {
                return AsyncStream<CatechumenListEntity> { continuation in
                    networkService.create(method: .get,
                                          apiURL: CatechumenApi.catechumenList.rawValue,
                                          completion: { (response: CatechumenListEntity?) in
                        
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

extension CatechumenClient: DependencyKey {
    internal static var liveValue: Self { .live }
}

extension DependencyValues {
    internal var catechumenClient: CatechumenClient {
        get { self[CatechumenClient.self] }
        set { self[CatechumenClient.self] = newValue }
    }
}
