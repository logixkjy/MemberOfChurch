//
//  MemberDetailClient.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/9/25.
//

import ComposableArchitecture

struct MemberDetailClient {
    var memberDetailInfo: @Sendable (String) async -> AsyncStream<MemberDetailInfoEntity>
}

extension MemberDetailClient {
    internal static var live : Self {
        let networkService = NetworkService.shared
        
        return Self(
            memberDetailInfo: { psn_id in
                let apiUrl = String.init(format: MemberDetailApi.MemberDetailInfo.rawValue, "\(psn_id)")
                return AsyncStream<MemberDetailInfoEntity> { continuation in
                    networkService.create(method: .get,
                                          apiURL: apiUrl,
                                          completion: { (response: MemberDetailInfoEntity?) in
                        
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

extension MemberDetailClient: DependencyKey {
    internal static var liveValue: Self { .live }
}

extension DependencyValues {
    internal var memberDetailClient: MemberDetailClient {
        get { self[MemberDetailClient.self] }
        set { self[MemberDetailClient.self] = newValue }
    }
}
