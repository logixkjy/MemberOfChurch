//
//  AreaCore.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/1/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AreaCore {
    @ObservableState
    struct State: Equatable {
        var areaLists: [AreaEntity] = []   // nil 대신 빈 배열 권장 (UI 깜빡임 줄이기)
        var areaEntity: AreaEntity?
        var sectLists: SectListEntity?
        var isLoading: Bool = false
        var hasLoadedOnce: Bool = false        // 최초 로딩 여부
        var needsRefresh: Bool = false         // 추가/수정 후 갱신 플래그
        var lastLoadedAt: Date? = nil          // (선택) 최소 주기 제어용
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case onAppear                          // 화면이 보일 때마다 들어옴
        case getAreaList
        case setAreaList(Array<AreaEntity>)
        
        case getSectionMembers(AreaEntity)
        case setSectionMembers(SectListEntity?)
        case setLoading(Bool)
        
        case markNeedsRefresh                  // 외부(등록/수정 완료 후)에서 호출
    }
    
    @Dependency(\.areaClient) private var areaClient
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
                    return .send(.getAreaList)
                }
                // 2) 등록/수정 후 갱신 요청 있었으면
                if state.needsRefresh {
                    state.needsRefresh = false
                    return .send(.getAreaList)
                }
                // 3) (선택) 최소 주기: 30초 이내면 스킵
                if let last = state.lastLoadedAt, Date().timeIntervalSince(last) < 30 {
                    return .none
                }
                return .none
                
            case .getAreaList:
                state.isLoading = true
                return .run { send in
                    for await response in await areaClient.areaList() {
                        if let areaList = response.list, !areaList.isEmpty {
                            await send(.setAreaList(areaList))
                        }
                    }
                    await send(.setLoading(false))
                }
                
            case let .setAreaList(response):
                state.areaLists = response
                state.hasLoadedOnce = true
                state.lastLoadedAt = Date()
                return .none
                
            case let .getSectionMembers(area):
                state.areaEntity = area
                return .run { send in
                    await send(.setSectionMembers(nil))
                    for await response in await areaClient.sectList(area.SECT_CD) {
                        await send(.setSectionMembers(response))
                    }
                }
                
            case let .setSectionMembers(response):
                state.sectLists = response
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

