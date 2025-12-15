//
//  SectView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/4/25.
//

import SwiftUI
import ComposableArchitecture

struct SectView: View {
    
    @EnvironmentObject var mainRouter: MainRouter
    
    @State private var showMenu: Bool = false  // 메뉴 표시 여부 관리
    @State private var menuItem: MenuItem = MenuItem(title: "", expandableContent: .none, viewType: nil, subType: nil)
    @State private var sectItem: SectEntity = SectEntity()
    
    let areaStore: StoreOf<AreaCore>
    
    init(areaStore: StoreOf<AreaCore>) {
        self.areaStore = areaStore
    }
    
    var body: some View {
        WithViewStore(self.areaStore, observe: { $0 }) { viewStore in
            ZStack {
                GeometryReader { geo in
                    VStack {
                        if let AREA_SECT_NM = viewStore.areaEntity?.AREA_SECT_NM {
                            Text("\(AREA_SECT_NM) (\(viewStore.sectLists?.TOTAL_CNT ?? 0)명)")
                                .foregroundStyle(.white)
                                .font(.system(size: 25, weight: .bold))
                        } else if viewStore.areaEntity?.AREA_CD ?? 0 > 0 {
                            Text("\(viewStore.areaEntity?.AREA_CD ?? 0)지역 \(viewStore.areaEntity?.SECT_CD ?? 0)구역  (\(viewStore.sectLists?.TOTAL_CNT ?? 0)명)")
                                .foregroundStyle(.white)
                                .font(.system(size: 25, weight: .bold))
                        } else {
                            Text("\(viewStore.areaEntity?.SECT_CD ?? 0)구역  (\(viewStore.sectLists?.TOTAL_CNT ?? 0)명)")
                                .foregroundStyle(.white)
                                .font(.system(size: 25, weight: .bold))
                        }
                        
                        
                        SectListSectionView(
                            sectList: viewStore.sectLists,
                            sectItem: $sectItem,
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
                    .task {
                        //                            viewStore.send(.getAreaList)
                    }
//                    .onDisappear() {
//                        viewStore.send(.setAreaList(nil))
//                    }
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
            //                .onChange(of: areaItem) { newValue in
            //                    viewStore.send(.getSectionMembers(areaItem.SECT_CD))
            //                    mainRouter.push(type: .sectListView)
            //                }
            .onChange(of: menuItem) { newValue in
                mainRouter.pop()
                if let viewType = menuItem.viewType {
                    switch viewType {
                    case .memberList:
                        mainRouter.popAll()
                    case .memberDetail:
                        mainRouter.popAll()
                        mainRouter.push(type: .memberDetailView)
                    case .areaList:
                        mainRouter.popAll()
                        mainRouter.push(type: .areaListView)
                    case .sectList:
                        mainRouter.push(type: .sectListView)
                    case .partyList:
                        mainRouter.popAll()
                        if let subType = menuItem.subType {
                            mainRouter.partyStore.send(.setPartyInfo(subType.tag, menuItem.title))
                            mainRouter.partyStore.send(.getPartyList)
                        }
                        mainRouter.push(type: .partyListView)
                    case .wrkOrgList:
                        mainRouter.popAll()
                        if let subType = menuItem.subType {
                            mainRouter.wrkOrgStore.send(.setWrkOrgInfo(subType.tag, menuItem.title))
                            mainRouter.wrkOrgStore.send(.getWrkOrgList)
                        }
                        mainRouter.push(type: .partyListView)
                    case .newMember:
                        mainRouter.popAll()
                        mainRouter.push(type: .newMemberView)
                    case .fellowship:
                        mainRouter.popAll()
                        mainRouter.push(type: .fellowshipView)
                    case .setting:
                        mainRouter.popAll()
                        mainRouter.push(type: .settingView)
                    case .memberAdd:
                        mainRouter.popAll()
                        mainRouter.push(type: .memberAddView)
                    }
                }
                
            }
            
        }
    }
}
