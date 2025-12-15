//
//  SplashView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/23/25.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
    @EnvironmentObject var mainRouter: MainRouter
    
    @State private var timerQueue = DispatchQueue.main
    @State private var timer: DispatchSourceTimer?
    
    @Binding var isSplash: Bool
    var onLoggedIn: () -> Void
    
    init(isSplash: Binding<Bool>, onLoggedIn: @escaping () -> Void) {
        self._isSplash = isSplash
        self.onLoggedIn = onLoggedIn
    }
    
    var body: some View {
        WithViewStore(mainRouter.loginStore, observe: { $0 }) {
            (viewStore: ViewStoreOf<LoginCore>) in
            WithViewStore(mainRouter.memberRegisterStore, observe: { $0 }) {
                (viewRegStore: ViewStoreOf<MemberRegisterCore>) in
                GeometryReader { geometry in
                    ZStack(alignment: .top) {
                        Color("green02")
                            .edgesIgnoringSafeArea(.all)
                        
                        Image(.launchImage2)
                            .resizable()
                            .scaledToFit() // 또는 scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .task {
                    if UserEnvironment.isAutoLogin, !UserEnvironment.userID.isEmpty, !UserEnvironment.userPW.isEmpty {
                        viewStore.send(.userLogin(UserEnvironment.userID, UserEnvironment.userPW, UserEnvironment.isAutoLogin))
                    } else {
                        startTimer()
                    }
                }
                .onChange(of: viewStore.isLogin) { newValue in
                    isSplash = false
                    loginSucceeded()
                }
            }
        }
    }
    
    private func startTimer() {
        timer = DispatchSource.makeTimerSource(queue: timerQueue)
        timer?.schedule(deadline: .now() + 3)
        timer?.setEventHandler {
            isSplash = false
        }
        timer?.activate()
    }
    
    // ...
    private func loginSucceeded() {
        onLoggedIn()
    }
}
