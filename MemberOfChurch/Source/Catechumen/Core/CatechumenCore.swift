//
//  CatechumenCore.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/8/25.
//

import ComposableArchitecture

@Reducer
struct CatechumenCore {
    @ObservableState
    struct State: Equatable {
        var catechumenLists: Array<CatechumenEntity>?
        
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case getCatechumenLists
        case setCatechumenLists([CatechumenEntity]?)
    }
    
    @Dependency(\.catechumenClient) private var catechumenClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding(_):
                return .none
                
            case .getCatechumenLists:
                return .run { send in
                    await send(.setCatechumenLists(nil))
                    
                    for await response in await catechumenClient.catechumenList() {
                        if let catechumenLists = response.list, !catechumenLists.isEmpty {
                            await send(.setCatechumenLists(catechumenLists))
                        }
                    }
                }
                
            case let .setCatechumenLists(response):
                state.catechumenLists = response
                return .none
                
            }
        }
    }
}

