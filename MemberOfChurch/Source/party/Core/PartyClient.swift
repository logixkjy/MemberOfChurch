//
//  PartyClient.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/5/25.
//

import ComposableArchitecture

struct PartyClient {
    var partyList: @Sendable (String) async -> AsyncStream<PartyListEntity>
}

extension PartyClient {
    internal static var live : Self {
        let networkService = NetworkService.shared
        
        return Self(
            partyList: { party in
                let apiUrl = String.init(format: PartyApi.partyList.rawValue, "\(party)")
                return AsyncStream<PartyListEntity> { continuation in
                    networkService.create(method: .get,
                                          apiURL: apiUrl,
                                          completion: { (response: PartyListEntity?) in
                        
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

extension PartyClient: DependencyKey {
    internal static var liveValue: Self { .live }
}

extension DependencyValues {
    internal var partyClient: PartyClient {
        get { self[PartyClient.self] }
        set { self[PartyClient.self] = newValue }
    }
}
