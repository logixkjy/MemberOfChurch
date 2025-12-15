//
//  SideMenuView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/2/25.
//

import SwiftUI
import ComposableArchitecture

internal struct SideMenuView: View {
    @Binding var showMenu: Bool
    let loginEntity: LoginEntity?
    @Binding var menuItem: MenuItem
    
    private let menuList: [MenuItem] = [
        MenuItem(title: "전체 성도", expandableContent: .none, viewType: .memberList, subType: nil),
        MenuItem(title: "지역 / 구역", expandableContent: .none, viewType: .areaList, subType: nil),
        MenuItem(title: "부서", expandableContent: .grid([
            MenuItem(title: "장년회", expandableContent: .none, viewType: .partyList, subType: .PARTY_01),
            MenuItem(title: "부인회", expandableContent: .none, viewType: .partyList, subType: .PARTY_02),
            MenuItem(title: "청년회", expandableContent: .none, viewType: .partyList, subType: .PARTY_03),
            MenuItem(title: "대학부", expandableContent: .none, viewType: .partyList, subType: .PARTY_04),
            MenuItem(title: "학생회", expandableContent: .none, viewType: .partyList, subType: .PARTY_05),
            MenuItem(title: "실버회", expandableContent: .none, viewType: .partyList, subType: .PARTY_06),
            MenuItem(title: "주일학교", expandableContent: .none, viewType: .partyList, subType: .PARTY_07),
            MenuItem(title: "유치부", expandableContent: .none, viewType: .partyList, subType: .PARTY_08)
        ]), viewType: nil, subType: nil),
        MenuItem(title: "기관", expandableContent: .list([
            MenuItem(title: "국제청소년연합", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_01),
            MenuItem(title: "굿뉴스 의료봉사회", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_02),
            MenuItem(title: "기쁜소식사", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_03),
            MenuItem(title: "드래곤플라이", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_04),
            MenuItem(title: "마하나임바이블트레이닝센터", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_05),
            MenuItem(title: "선교회총회", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_06),
            MenuItem(title: "영상선교부", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_07),
            MenuItem(title: "음향선교부", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_08),
            MenuItem(title: "인터넷선교부", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_09),
            MenuItem(title: "임마누엘", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_10),
            MenuItem(title: "주간기쁜소식", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_11),
            MenuItem(title: "투머로우", expandableContent: .none, viewType: .wrkOrgList, subType: .WRK_ORG_12)
        ]), viewType: nil, subType: nil),
        MenuItem(title: "새신자", expandableContent: .none, viewType: .newMember, subType: nil),
        MenuItem(title: "심방", expandableContent: .none, viewType: .fellowship, subType: nil),
        MenuItem(title: "환경설정", expandableContent: .none, viewType: .setting, subType: nil),
    ]
    
    init(showMenu: Binding<Bool>, menuItem: Binding<MenuItem>, loginEntity: LoginEntity?) {
        self._showMenu = showMenu
        self._menuItem = menuItem
        self.loginEntity = loginEntity
    }
    var body: some View {
        ZStack(alignment: .trailing) { // 👉 오른쪽 정렬
            // 반투명 배경 (터치하면 닫힘)
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showMenu = false
                    }
                }
            
            // 오른쪽에서 나오는 메뉴
            VStack(alignment: .center, spacing: 0) {
                Image(.icSheep)
                    .resizable()
                    .frame(width: 80, height: 59, alignment: .center)
                    .padding(.top, 100)
                if let loginEntity = loginEntity {
                    Text(loginEntity.CHUR_NM ?? "")
                        .font(.system(size: 30, weight: .black))
                        .foregroundStyle(.green06)
                        .padding([.top, .bottom], 10)
                }
                
                ExpandableListView(showMenu: $showMenu, items: menuList, menuItem: $menuItem)
            }
            .frame(width: 320)
            .background(Color.white)
        }
        .ignoresSafeArea()
    }
}

internal struct ExpandableListView: View {
    @Binding var showMenu: Bool
    @State private var expandedItemID: UUID? = nil
    @Binding var menuItem: MenuItem
    
    let items: [MenuItem]
    
    init(showMenu: Binding<Bool>, items: [MenuItem], menuItem: Binding<MenuItem>) {
        self._showMenu = showMenu
        self.items = items
        self._menuItem = menuItem
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(items) { item in
                    // ✅ 각 아이템 뷰
                    itemView(for: item)
                    
                    Divider()
                        .background(Color.white)
                        .padding(.horizontal, 0)
                }
            }
        }
        .background(Color.green06) // ✅ 전체 배경
        .ignoresSafeArea()
    }
    
    private func itemView(for item: MenuItem) -> some View {
        let isExpanded = expandedItemID == item.id
        let isExpandable = item.expandableContent != .none
        
        return VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(item.title)
                    .font(.system(size: 23, weight: .black))
                    .foregroundColor(.white)
                Spacer()
                if isExpandable {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(isExpanded ? Color.green07 : Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    toggleExpand(for: item)
                }
            }
            
            if isExpanded {
                switch item.expandableContent {
                case .grid(let items):
                    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
                    
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(items.indices, id: \.self) { index in
                            let item = items[index]
                            
                            ZStack {
                                Rectangle()
                                    .fill(Color.green07)
                                Text(item.title)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .onTapGesture {
                                        withAnimation {
                                            if self.menuItem.id != item.id {
                                                self.menuItem = item
                                                showMenu = false
                                            }
                                        }
                                    }
                            }
                            .frame(height: 70)
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.white),
                                alignment: .bottom
                            )
                            .overlay(
                                Rectangle()
                                    .frame(width: 1)
                                    .foregroundColor(.white),
                                alignment: .trailing
                            )
                        }
                    }
                    
                case .list(let subs):
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(subs, id: \.id) { sub in
                            Text("• \(sub.title)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .onTapGesture {
                                    withAnimation {
                                        if self.menuItem.id != sub.id {
                                            self.menuItem = sub
                                            showMenu = false
                                        }
                                    }
                                }
                            Divider().background(Color.white.opacity(0.5))
                        }
                    }
                    .background(Color.green07)
                    
                case .none:
                    EmptyView()
                }
            }
        }
    }
    
    private func toggleExpand(for item: MenuItem) {
        expandedItemID = (expandedItemID == item.id) ? nil : item.id
        if item.expandableContent == .none {
            self.menuItem = item
            showMenu = false
        }
    }
}

enum ExpandableContent: Equatable {
    
    case none
    case grid([MenuItem])       // 버튼 텍스트
    case list([MenuItem])       // 일반 텍스트 리스트
}

enum ViewType {
    // Root -> MainView
    case memberList
    case memberDetail // 성도 상세 정보
    case areaList // 지역
    case sectList // 구역
    case partyList // 부서
    case wrkOrgList // 기관
    case newMember // 새신자
    case fellowship // 심방
    case setting // 설정
    case memberAdd // 성도 추가
}
enum SubType {
    case PARTY_01
    case PARTY_02
    case PARTY_03
    case PARTY_04
    case PARTY_05
    case PARTY_06
    case PARTY_07
    case PARTY_08
    case WRK_ORG_01
    case WRK_ORG_02
    case WRK_ORG_03
    case WRK_ORG_04
    case WRK_ORG_05
    case WRK_ORG_06
    case WRK_ORG_07
    case WRK_ORG_08
    case WRK_ORG_09
    case WRK_ORG_10
    case WRK_ORG_11
    case WRK_ORG_12
    
    var tag: String {
        switch self {
        case .PARTY_01: return "PSN_TP/1" // 장년회
        case .PARTY_02: return "PSN_TP/2" // 부인회
        case .PARTY_03: return "PSN_TP/3" // 청년회
        case .PARTY_04: return "PSN_TP/T" // 대학부
        case .PARTY_05: return "PSN_TP/5" // 학생회
        case .PARTY_06: return "PSN_TP/A" // 실버회
        case .PARTY_07: return "PSN_TP/7" // 주일학교
        case .PARTY_08: return "PSN_TP/8" // 유치부
        case .WRK_ORG_01: return "190122" // 국제청소년연합
        case .WRK_ORG_02: return "190162" // 굿뉴스 의료봉사회
        case .WRK_ORG_03: return "190105" // 기쁜소식사
        case .WRK_ORG_04: return "190127" // 드래곤플라이
        case .WRK_ORG_05: return "190163" // 마하나임바이블트레이닝센터
        case .WRK_ORG_06: return "190133" // 선교회총회
        case .WRK_ORG_07: return "190114" // 영상선교부
        case .WRK_ORG_08: return "190115" // 음향선교부
        case .WRK_ORG_09: return "190120" // 인터넷선교부
        case .WRK_ORG_10: return "190107" // 임마누엘
        case .WRK_ORG_11: return "190135" // 주간기쁜소식
        case .WRK_ORG_12: return "190125" // 투머로우
        }
    }
}

struct MenuItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let expandableContent: ExpandableContent
    let viewType: ViewType?
    let subType: SubType?
}
