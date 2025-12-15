//
//  WrkOrgClient.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/7/25.
//

import ComposableArchitecture

struct WrkOrgClient {
    var wrkOrgList: @Sendable (String) async -> AsyncStream<WrkOrgListEntity>
}

extension WrkOrgClient {
    internal static var live : Self {
        let networkService = NetworkService.shared
        
        return Self(
            wrkOrgList: { wrkOrg in
                let apiUrl = String.init(format: WrkOrgApi.wrkOrgList.rawValue, "\(wrkOrg)")
                return AsyncStream<WrkOrgListEntity> { continuation in
                    networkService.create(method: .get,
                                          apiURL: apiUrl,
                                          completion: { (response: WrkOrgListEntity?) in
                        
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

extension WrkOrgClient: DependencyKey {
    internal static var liveValue: Self { .live }
}

extension DependencyValues {
    internal var wrkOrgClient: WrkOrgClient {
        get { self[WrkOrgClient.self] }
        set { self[WrkOrgClient.self] = newValue }
    }
}
