//
//  MemberView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/26/25.
//

import SwiftUI
import ComposableArchitecture

struct MemberView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var mainRouter: MainRouter
    
    @State private var searchText: String = ""
    @State private var showMenu: Bool = false  // 메뉴 표시 여부 관리
    @State private var menuItem: MenuItem = MenuItem(title: "", expandableContent: .none, viewType: nil, subType: nil)
    
    
    @State private var showPopup = false
    
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    
    var body: some View {
        NavigationStack(path: $mainRouter.mainPath) {
            ZStack {
                WithViewStore(mainRouter.memberStore, observe: { $0 }) { viewStore in
                    WithViewStore(mainRouter.loginStore, observe: { $0 }) { viewLoginStore in
                        WithViewStore(mainRouter.memberRegisterStore, observe: { $0 }) { viewRegStore in
                            GeometryReader { geo in
                                VStack {
                                    ChurchInfoView(loginEntity: viewLoginStore.loginEntity)
                                        .frame(height: 115)
                                    
                                    // 👉 검색창을 직접 추가
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                        TextField("이름 또는 초성 검색", text: $searchText)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .background(.white.opacity(0.5))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.black.opacity(0.2))
                                    
                                    MemberListSectionView(
                                        members: viewStore.memberLists,
                                        searchText: $searchText,
                                        name: $name,
                                        phone: $phone,
                                        email: $email,
                                        isPresented: $showPopup,
                                        onSelect: { psnId in
                                            if let id = psnId {
                                                mainRouter.memberDetailStore.send(.setPsnId(id))
                                                mainRouter.push(type: .memberDetailView)
                                            }
                                        }
                                    )
                                }
                                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                                .background(.green04)
                                // 기존 .task { viewStore.send(.getMemberLists) } 제거
                                .onAppear() {
                                  viewStore.send(.onAppear)      // 조건부 로딩
                                }
                            }
                        }
                    }
                    .toolbar {
                        // 우측 상단 메뉴 버튼 추가
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                withAnimation {
                                    showMenu.toggle()
                                }
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .imageScale(.large)
                                    .foregroundStyle(Color.green07)
                            }
                        }
                    }
                }
                // 메뉴 버튼 누르면 나타나는 사이드 메뉴 (왼쪽에서 슬라이드)
                if showMenu {
                    WithViewStore(mainRouter.loginStore, observe: { $0 }) { viewLoginStore in
                        SideMenuView(showMenu: $showMenu, menuItem: $menuItem, loginEntity: viewLoginStore.loginEntity)
                            .transition(.move(edge: .trailing))
                            .zIndex(1)
                    }
                }
                
                if showPopup {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ContactPopupView(
                        name: $name,
                        phone: $phone,
                        email: $email,
                        isPresented: $showPopup
                    )
                    .transition(.scale)
                    .zIndex(1)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                WithViewStore(mainRouter.loginStore, observe: { $0 }) { viewLoginStore in
                    WithViewStore(mainRouter.memberRegisterStore, observe: { $0 }) { viewRegStore in
                        FloatingPlusButton {
                            viewRegStore.send(.onAppear)
                            viewRegStore.send(.setChurchCode(viewLoginStore.loginEntity?.CHUR_CD ?? ""))
                            mainRouter.push(type: .memberAddView)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 24)            // 홈 인디케이터 피해서
                        .opacity(showMenu || showPopup ? 0 : 1) // 메뉴/팝업 때는 숨김(선택)
                        .zIndex(2)
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom) // 키보드 떠도 FAB 고정
            .navigationDestination(for: MainPath.self) { type in
                mainRouter.view(path: type)
            }
        }
        .onChange(of: menuItem) { newValue in
            mainRouter.pop()
            if let viewType = newValue.viewType {
                switch viewType {
                case .memberList:
                    mainRouter.popAll()
                case .memberDetail:
                    mainRouter.push(type: .memberDetailView)
                case .areaList:
                    mainRouter.push(type: .areaListView)
                case .sectList:
                    mainRouter.push(type: .sectListView)
                case .partyList:
                    if let subType = menuItem.subType {
                        mainRouter.partyStore.send(.setPartyInfo(subType.tag, menuItem.title))
                        mainRouter.partyStore.send(.getPartyList)
                    }
                    mainRouter.push(type: .partyListView)
                case .wrkOrgList:
                    if let subType = menuItem.subType {
                        mainRouter.wrkOrgStore.send(.setWrkOrgInfo(subType.tag, menuItem.title))
                        mainRouter.wrkOrgStore.send(.getWrkOrgList)
                    }
                    mainRouter.push(type: .wrkOrgListVIew)
                case .newMember:
                    mainRouter.push(type: .newMemberView)
                case .fellowship:
                    mainRouter.push(type: .fellowshipView)
                case .setting:
                    mainRouter.push(type: .settingView)
                case .memberAdd:
                    mainRouter.push(type: .memberAddView)
                }
            }
            
        }
    }
}
