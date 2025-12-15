//
//  AreaView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/2/25.
//

import SwiftUI
import ComposableArchitecture

struct AreaView: View {
    
    @EnvironmentObject var mainRouter: MainRouter
    
    @State private var searchText: String = ""
    @State private var showMenu: Bool = false  // 메뉴 표시 여부 관리
    @State private var menuItem: MenuItem = MenuItem(title: "", expandableContent: .none, viewType: nil, subType: nil)
    @State private var areaItem: AreaEntity = AreaEntity()
    
    let areaStore: StoreOf<AreaCore>
    
    init(areaStore: StoreOf<AreaCore>) {
        self.areaStore = areaStore
    }
    
    var body: some View {
        WithViewStore(self.areaStore, observe: { $0 }) { viewStore in
            ZStack {
                GeometryReader { geo in
                    VStack {
                        Text("지역 / 구역")
                            .foregroundStyle(.white)
                            .font(.system(size: 25, weight: .bold))
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
                        
                        AreaListSectionView(
                            areaList: viewStore.areaLists,
                            searchText: $searchText,
                            areaItem: $areaItem
                        )
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                    .background(.green04)
                    .task {
                        viewStore.send(.onAppear)
                    }
                    .onAppear() {
                        // 지역으로 오면 선택 초기화
                        self.areaItem = AreaEntity()
                    }
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    // 🔹 왼쪽: 이전 버튼
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            if !mainRouter.mainPath.isEmpty {
                                mainRouter.mainPath.removeLast()
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(Color.green07)
                                Text("이전")
                                    .foregroundStyle(Color.green07)
                            }
                        }
                    }
                    
                    // 🔹 오른쪽: 메뉴 버튼
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
                
                
                // 메뉴 버튼 누르면 나타나는 사이드 메뉴 (왼쪽에서 슬라이드)
                if showMenu {
                    WithViewStore(mainRouter.loginStore, observe: { $0 }) { viewLoginStore in
                        SideMenuView(showMenu: $showMenu, menuItem: $menuItem, loginEntity: viewLoginStore.loginEntity)
                            .transition(.move(edge: .trailing))
                            .zIndex(1)
                    }
                }
            }
            .onChange(of: areaItem) { newValue in
                if let _ = newValue.AREA_NM {
                    viewStore.send(.getSectionMembers(areaItem))
                    mainRouter.push(type: .sectListView)
                }
            }
            .onChange(of: menuItem) { newValue in
                mainRouter.pop()
                if let viewType = menuItem.viewType {
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
}
