//
//  LoginView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/23/25.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    
    @EnvironmentObject var mainRouter: MainRouter
    
    @AppStorage("userID") var userId: String = UserDefaults.standard.string(forKey: "userID") ?? ""
    @AppStorage("userPW") var userPw: String = UserDefaults.standard.string(forKey: "userPW") ?? ""
    @AppStorage("isAutoLogin") var isAutoLogin: Bool = UserDefaults.standard.bool(forKey: "isAutoLogin")
    
//    @Binding var isLogin: Bool
    
    var onLoggedIn: () -> Void
    
    var body: some View {
        WithViewStore(mainRouter.loginStore, observe: { $0 }) { (viewStore: ViewStoreOf<LoginCore>) in
            GeometryReader { geo in
                
                VStack(spacing: 0) {
                    Image(.icSheep)
                        .resizable()
                        .frame(width: 80, height: 59, alignment: .center)
                        .padding(.top, 10)
                    
                    Image(.icLogo)
                        .resizable()
                        .frame(width: 310, height: 35, alignment: .center)
                        .padding(.top, 10)
                    
                    Text("\("기쁜소식선교회 산하 교회의 성도 정보를\n 관리하는 어플리케이션입니다.\n관리자 승인을 받은 아이디로 로그인 하세요!")")
                        .font(.system(size: 17))
                        .foregroundStyle(Color("green01"))
                        .multilineTextAlignment(.center)
                        .padding([.top, .bottom], 20)
                    
                    TextFieldView(store: mainRouter.loginStore,
                                  id: $userId,
                                  password: $userPw,
                                  isAutoLogin: $isAutoLogin)
                    .padding(.top, 15)
                    .padding([.leading, .trailing], 20)
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                .background(Color("green02"))
            }
            
            VStack {
                Spacer()
                Text("로그인 문의 T.02)577-5538\nwebmaster@goodnews.or.kr")
                    .font(.system(size: 16))
                    .foregroundStyle(.green03)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 70)
                    .padding(.horizontal, 16)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            // ✅ 키보드가 올라와도 레이아웃을 줄이지 않음
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
            .onChange(of: viewStore.isLogin) { newValue in
                loginSucceeded()
            }
        }
    }
    
    // ...
    private func loginSucceeded() {
        onLoggedIn()
    }
}
