//
//  LoginCore.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/22/25.
//

import ComposableArchitecture

@Reducer
struct LoginCore {
    struct State: Equatable {
        var isLogin: Bool = false
        
        var loginEntity: LoginEntity?
        
        var loginMessage: String = ""
        var loginError: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case userLogin(String, String, Bool)
        case userLogout
        
        case isLogin(Bool)
        case setLoginEntity(LoginEntity?)
        
        case setLoginMsg(String)
        case setLoginError(Bool)
    }
    
    @Dependency(\.loginClient) private var loginClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding(_):
                return .none
                
            case let .userLogin(id, password, isAutoLogin):
                return .run { send in
                    await send(.setLoginEntity(nil))
                    
                    for await response in await loginClient.userLogin(id, password) {
                        switch response.state ?? "0" {
                        case "1":
                            await send(.setLoginMsg("등록되지 않은 아이디입니다."))
                            await send(.setLoginError(true))
                            await send(.isLogin(false))
                        case "2":
                            await send(.setLoginMsg("승인이 되지 않은 아이디입니다."))
                            await send(.setLoginError(true))
                            await send(.isLogin(false))
                        case "3":
                            await send(.setLoginMsg("아이디와 비밀번호를 확인해 주세요."))
                            await send(.setLoginError(true))
                            await send(.isLogin(false))
                        case "4":
                            UserEnvironment.userID = id
                            UserEnvironment.userPW = password
                            UserEnvironment.isAutoLogin = isAutoLogin
                            
                            await send(.isLogin(true))
                            await send(.setLoginEntity(response))
                        default:
                            await send(.setLoginMsg("Error"))
                            await send(.setLoginError(true))
                            await send(.isLogin(false))
                        }
                    }
                }
                
            case .userLogout:
                return .run { send in
                    loginClient.userLogout()
                    
                    await send(.isLogin(false))
                    await send(.setLoginEntity(nil))
                }
                
            case let .isLogin(result):
                state.isLogin = result
                return .none
                
            case let .setLoginEntity(response):
                state.loginEntity = response
                return .none
            
            case let .setLoginMsg(result):
                state.loginMessage = result
                return .none
                
            case let .setLoginError(result):
                state.loginError = result
                return .none
            }
        }
    }
}
