//
//  AreaClient.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/1/25.
//

import ComposableArchitecture

struct AreaClient {
    var areaList: @Sendable () async -> AsyncStream<AreaListEntity>
    var sectList: @Sendable (Int) async -> AsyncStream<SectListEntity>
}

extension AreaClient {
    internal static var live : Self {
        let networkService = NetworkService.shared
        
        return Self(
            areaList: {
                return AsyncStream<AreaListEntity> { continuation in
                    networkService.create(method: .get,
                                          apiURL: AreaApi.areaList.rawValue,
                                          completion: { (response: AreaListEntity?) in
                        
                        if let response = response {
                            continuation.yield(response)
                            continuation.finish()
                        }
                    })
                }
            },
            sectList: { sect_cd in
                let apiUrl = String.init(format: AreaApi.sectList.rawValue, "\(sect_cd)")
                return AsyncStream<SectListEntity> { continuation in
                    networkService.create(method: .get,
                                          apiURL: apiUrl,
                                          completion: { (response: SectListEntity?) in
                        
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

extension AreaClient: DependencyKey {
    internal static var liveValue: Self { .live }
}

extension DependencyValues {
    internal var areaClient: AreaClient {
        get { self[AreaClient.self] }
        set { self[AreaClient.self] = newValue }
    }
}
