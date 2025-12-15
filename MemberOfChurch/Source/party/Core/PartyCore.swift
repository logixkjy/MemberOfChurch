//
//  PartyCore.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/5/25.
//

import ComposableArchitecture

@Reducer
struct PartyCore {
    @ObservableState
    struct State: Equatable {
        var partyLists: Array<PartyEntity>?
        var partyId: String?
        var partyName: String?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case getPartyList
        case setPartyList(Array<PartyEntity>?)
        
        case setPartyInfo(String?, String?)
    }
    
    @Dependency(\.partyClient) private var partyClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding(_):
                return .none
                
            case .getPartyList:
                guard let partyId = state.partyId else { return .none }
                return .run { send in
                    await send(.setPartyList(nil))
                    
                    for await response in await partyClient.partyList(partyId) {
                        if let partyList = response.list, !partyList.isEmpty {
                            await send(.setPartyList(partyList))
                        }
                    }
                }
                
            case let .setPartyList(response):
                state.partyLists = response
                return .none
                
            case let .setPartyInfo(id, name):
                state.partyId = id
                state.partyName = name
                return .none
            }
        }
    }
}

