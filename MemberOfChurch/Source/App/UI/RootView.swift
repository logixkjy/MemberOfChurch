//
//  RootView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/23/25.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    @State private var isSplash: Bool = true
    @State private var isLogin: Bool = false
    @State private var count: Int = 0
    
    @StateObject private var mainRouter: MainRouter = MainRouter()
    
    var body: some View {
        ZStack {
            if isSplash {
                // 스플래쉬
                SplashView(isSplash: $isSplash, onLoggedIn: {
                    mainRouter.didLogin() }
                )
                    .preferredColorScheme(.dark)
                    .environmentObject(mainRouter)
            }
            else {
                if mainRouter.isLoggedIn {
                    // 로그인 후
                    MemberView()
                        .preferredColorScheme(.light)
                        .environmentObject(mainRouter)
                } else {
                    // 로그인 전
                    LoginView(
                        // 로그인 성공 시 Router에 알리기
                        onLoggedIn: { mainRouter.didLogin() }
                    )
                        .preferredColorScheme(.light)
                        .environmentObject(mainRouter)
                }
            }
        }
        .background(.white)
    }
}
