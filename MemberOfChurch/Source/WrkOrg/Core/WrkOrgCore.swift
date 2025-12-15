//
//  WrkOrgCore.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/7/25.
//

import ComposableArchitecture

@Reducer
struct WrkOrgCore {
    @ObservableState
    struct State: Equatable {
        var wrkOrgLists: Array<WrkOrgEntity>?
        var wrkOrgId: String?
        var wrkOrgName: String?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case getWrkOrgList
        case setWrkOrgList(Array<WrkOrgEntity>?)
        
        case setWrkOrgInfo(String?, String?)
    }
    
    @Dependency(\.wrkOrgClient) private var wrkOrgClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding(_):
                return .none
                
            case .getWrkOrgList:
                guard let wrkOrgId = state.wrkOrgId else { return .none }
                return .run { send in
                    await send(.setWrkOrgList(nil))
                    
                    for await response in await wrkOrgClient.wrkOrgList(wrkOrgId) {
                        if let wrkOrgList = response.list, !wrkOrgList.isEmpty {
                            await send(.setWrkOrgList(wrkOrgList))
                        }
                    }
                }
                
            case let .setWrkOrgList(response):
                state.wrkOrgLists = response
                return .none
                
            case let .setWrkOrgInfo(id, name):
                state.wrkOrgId = id
                state.wrkOrgName = name
                return .none
            }
        }
    }
}


