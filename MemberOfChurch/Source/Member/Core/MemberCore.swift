//
//  MemberCore.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/26/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MemberCore {
    @ObservableState
    struct State: Equatable {
        var memberLists: [MemberEntity] = []   // nil 대신 빈 배열 권장 (UI 깜빡임 줄이기)
        var isLoading: Bool = false
        var hasLoadedOnce: Bool = false        // 최초 로딩 여부
        var needsRefresh: Bool = false         // 추가/수정 후 갱신 플래그
        var lastLoadedAt: Date? = nil          // (선택) 최소 주기 제어용
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case onAppear                          // 화면이 보일 때마다 들어옴
        case getMemberLists                    // 실제 네트워크 호출
        case setMemberLists([MemberEntity])
        case setLoading(Bool)
        
        case markNeedsRefresh                  // 외부(등록/수정 완료 후)에서 호출
    }
    
    @Dependency(\.memberClient) private var memberClient
    @Dependency(\.continuousClock) private var clock
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding(_):
                return .none
                
                // ✅ 보일 때 조건부 로딩
            case .onAppear:
                // 1) 한 번도 로딩 안 됐으면
                if !state.hasLoadedOnce {
                    return .send(.getMemberLists)
                }
                // 2) 등록/수정 후 갱신 요청 있었으면
                if state.needsRefresh {
                    state.needsRefresh = false
                    return .send(.getMemberLists)
                }
                // 3) (선택) 최소 주기: 30초 이내면 스킵
                if let last = state.lastLoadedAt, Date().timeIntervalSince(last) < 30 {
                    return .none
                }
                return .none
                
            case .getMemberLists:
                state.isLoading = true
                // 현재 목록 유지한 채로 로딩(깜빡임 방지). 필요하면 여기서 skeleton/overlay 사용.
                return .run { send in
                    // memberClient가 AsyncStream이면 첫 응답까지만 받고 종료
                    for await response in await memberClient.memberList() {
                        let list = response.list ?? []
                        await send(.setMemberLists(list))
                    }
                    await send(.setLoading(false))
                }
                
            case let .setMemberLists(list):
                state.memberLists = list
                state.hasLoadedOnce = true
                state.lastLoadedAt = Date()
                return .none
                
            case let .setLoading(loading):
                state.isLoading = loading
                return .none
                
                // ✅ 등록/수정 성공 시 외부에서 호출해 주면 다음 onAppear 때만 로딩
            case .markNeedsRefresh:
                state.needsRefresh = true
                return .none
                
            }
        }
    }
}

