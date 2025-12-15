//
//  FellowshipCore.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/8/25.
//

import ComposableArchitecture

@Reducer
struct FellowshipCore {
    @ObservableState
    struct State: Equatable {
        var fellowshipLists: Array<FellowshipEntity>?
        
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case getFellowshipLists
        case setFellowshipLists([FellowshipEntity]?)
    }
    
    @Dependency(\.fellowshipClient) private var fellowshipClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding(_):
                return .none
                
            case .getFellowshipLists:
                return .run { send in
                    await send(.setFellowshipLists(nil))
                    
                    for await response in await fellowshipClient.fellowshipList() {
                        if let fellowshipLists = response.list, !fellowshipLists.isEmpty {
                            await send(.setFellowshipLists(fellowshipLists))
                        }
                    }
                }
                
            case let .setFellowshipLists(response):
                state.fellowshipLists = response
                return .none
                
            }
        }
    }
}

