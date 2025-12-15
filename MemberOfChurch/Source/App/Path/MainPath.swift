//
//  MainPath.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/26/25.
//

import SwiftUI
import ComposableArchitecture

enum MainPath: Hashable {
    // Root -> MainView
    case memberDetailView // 성도 상세 정보
    case areaListView // 지역
    case sectListView // 구역
    case partyListView // 부서
    case wrkOrgListVIew // 기관
    case newMemberView // 새신자
    case fellowshipView // 심방
    case settingView // 설정
    case memberAddView // 성도 추가
}



class MainRouter: ObservableObject {
    @Environment(\.dismiss) private var dismiss
    
    @Published var mainPath: [MainPath] = []
    
    // ✅ 로그인 상태를 Router가 보유
    @Published var isLoggedIn: Bool = false
    
    @Published var loginStore: StoreOf<LoginCore> = Store(initialState: LoginCore.State()) { LoginCore() }
    
    @Published var memberStore: StoreOf<MemberCore> = Store(initialState: MemberCore.State()) { MemberCore() }
    
    @Published var areaStore: StoreOf<AreaCore> = Store(initialState: AreaCore.State()) { AreaCore() }
    
    @Published var partyStore: StoreOf<PartyCore> = Store(initialState: PartyCore.State()) { PartyCore() }
    
    @Published var wrkOrgStore: StoreOf<WrkOrgCore> = Store(initialState: WrkOrgCore.State()) { WrkOrgCore() }
    
    @Published var catechumenStore: StoreOf<CatechumenCore> = Store(initialState: CatechumenCore.State()) { CatechumenCore() }
    
    @Published var fellowshipStore: StoreOf<FellowshipCore> = Store(initialState: FellowshipCore.State()) { FellowshipCore() }
    
    @Published var memberDetailStore: StoreOf<MemberDetailCore> = Store(initialState: MemberDetailCore.State()) { MemberDetailCore() }
    
    @Published var memberRegisterStore: StoreOf<MemberRegisterCore> = Store(initialState: MemberRegisterCore.State()) { MemberRegisterCore() }
    
    @Published var settingsStore: StoreOf<SettingsCore> = Store(initialState: SettingsCore.State()) { SettingsCore() }
    
    @ViewBuilder func view(path: MainPath) -> some View {
        switch path {
        case .memberDetailView:
            MemberDetailView(memberDetailStore: memberDetailStore)
        case .areaListView:
            AreaView(areaStore: areaStore)
        case .sectListView:
            SectView(areaStore: areaStore)
        case .partyListView:
            PartyView(partyStore: partyStore)
        case .wrkOrgListVIew:
            WrkOrgView(wrkOrgStore: wrkOrgStore)
        case .newMemberView:
            CatechumenView(catechumenStore: catechumenStore)
        case .fellowshipView:
            FellowshipView(fellowshipStore: fellowshipStore)
        case .settingView:
            SettingsView(store: settingsStore)
        case .memberAddView:
            MemberRegisterView(store: memberRegisterStore)
        }
    }
    
    // 로그인 성공 시 호출
    func didLogin() {
        mainPath.removeAll()
        isLoggedIn = true
        
        memberStore            = .init(initialState: .init()) { MemberCore() }
        areaStore              = .init(initialState: .init()) { AreaCore() }
        partyStore             = .init(initialState: .init()) { PartyCore() }
        wrkOrgStore            = .init(initialState: .init()) { WrkOrgCore() }
        catechumenStore        = .init(initialState: .init()) { CatechumenCore() }
        fellowshipStore        = .init(initialState: .init()) { FellowshipCore() }
        memberDetailStore      = .init(initialState: .init()) { MemberDetailCore() }
        memberRegisterStore    = .init(initialState: .init()) { MemberRegisterCore() }
    }
    
    // ✅ 로그아웃 전체 리셋
    func logout() {
        isLoggedIn = false
        
        mainPath.removeAll()
        
        memberStore            = .init(initialState: .init()) { MemberCore() }
        areaStore              = .init(initialState: .init()) { AreaCore() }
        partyStore             = .init(initialState: .init()) { PartyCore() }
        wrkOrgStore            = .init(initialState: .init()) { WrkOrgCore() }
        catechumenStore        = .init(initialState: .init()) { CatechumenCore() }
        fellowshipStore        = .init(initialState: .init()) { FellowshipCore() }
        memberDetailStore      = .init(initialState: .init()) { MemberDetailCore() }
        memberRegisterStore    = .init(initialState: .init()) { MemberRegisterCore() }
//        settingsStore          = .init(initialState: .init()) { SettingsCore() }
    }
    
    func push(type: MainPath) {
        mainPath.append(type)
    }
    
    func pop(type: MainPath? = nil) {
        if self.mainPath.count > 0 {
            if let mainPath = type {
                if let startIndex = self.mainPath.lastIndex(of: mainPath) {
                    self.mainPath.removeSubrange((startIndex + 1)...)
                }
            } else {
                self.mainPath.removeLast()
            }
        } else {
            dismiss()
        }
    }
    
    func popAll() {
        self.mainPath.removeAll()
    }
}
