//
//  MemberDetailCore.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/9/25.
//

import ComposableArchitecture

@Reducer
struct MemberDetailCore {
    @ObservableState
    struct State: Equatable {
        var memberDetail: MemberDetailEntity?
        var familyMemberList: Array<FamilyMemberEntity>?
        var psn_id: String?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case getMemberDetailInfo
        case setMemberDetailInfo(MemberDetailEntity?, Array<FamilyMemberEntity>?)
        
        case setPsnId(String?)
    }
    
    @Dependency(\.memberDetailClient) private var memberDetailClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding(_):
                return .none
                
            case .getMemberDetailInfo:
                guard let psn_id = state.psn_id else { return .none }
                return .run { send in
                    await send(.setMemberDetailInfo(nil, nil))
                    
                    for await response in await memberDetailClient.memberDetailInfo(psn_id) {
                        if let memberDetail = response.member,
                           !response.list.isEmpty {
                            await send(.setMemberDetailInfo(memberDetail, response.list))
                        }
                    }
                }
                
            case let .setMemberDetailInfo(member, list):
                state.memberDetail = member
                state.familyMemberList = list
                return .none
                
            case let .setPsnId(id):
                state.psn_id = id
                return .none
            }
        }
    }
}



