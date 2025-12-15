//
//  SettingCore.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/17/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SettingsCore {
    @ObservableState
    struct State: Equatable {
        var autoLogin: Bool = false
        var loginId: String = ""
        var appVersion: String = ""
        var alert: AlertState<Action.Alert>?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case setAutoLogin(Bool)
        case openDeveloper
        enum Alert: Equatable {}
    }
    
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .onAppear:
                // ✅ 로드
                state.autoLogin = userDefaults.boolForKey(UDKeys.isAutoLogin)
                state.loginId = userDefaults.stringForKey(UDKeys.userID)
                state.appVersion = userDefaults.appVersion()
                return .none
                
            case .setAutoLogin(let value):
                // ✅ 저장
                userDefaults.setBool(value, UDKeys.isAutoLogin)
                state.autoLogin = userDefaults.boolForKey(UDKeys.isAutoLogin)
                return .none
                
            case .openDeveloper:
                if let url = URL(string: "http://volunteers.gnn.or.kr") {
                  return .run { _ in _ = await userDefaults.openURL(url) }
                }
                return .none
            }
        }
    }
}
