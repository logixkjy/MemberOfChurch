//
//  AreaViewEx.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/2/25.
//


import SwiftUI
import ComposableArchitecture
import Kingfisher

extension AreaView {
    internal struct AreaListSectionView: View {
        @Binding var searchText: String
        @Binding var areaItem: AreaEntity
        
        @State private var showPopup = false
        
        @State private var name = ""
        @State private var phone = ""
        @State private var email = ""
        
        let areaList: Array<AreaEntity>?
        
        init(areaList: Array<AreaEntity>?, searchText: Binding<String>, areaItem: Binding<AreaEntity>) {
            self.areaList = areaList
            self._searchText = searchText
            self._areaItem = areaItem
        }
        
        var body: some View {
            ZStack {
                List {
                    if searchText.isEmpty {
                        // ✅ 검색이 비어있을 때는 섹션별로 분류
                        ForEach(groupedMembers.keys.sorted(), id: \.self) { key in
                            if let membersInSection = groupedMembers[key] {
                                Section(header: sectionHeader(area: membersInSection[0])) {
                                    ForEach(membersInSection.indices, id: \.self) { idx in
                                        MemberCardView(area: membersInSection[idx],
                                                       name: $name,
                                                       phone: $phone,
                                                       email: $email,
                                                       isPresented: $showPopup)
                                        .onTapGesture {
                                            self.areaItem = membersInSection[idx]
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        // ✅ 검색 중에는 섹션 없이 평면 리스트
                        ForEach(filteredMembers.indices, id: \.self) { idx in
                            MemberCardView(area: filteredMembers[idx],
                                           name: $name,
                                           phone: $phone,
                                           email: $email,
                                           isPresented: $showPopup)
                        }
                    }
                }
                .listStyle(.plain)
                .background(.white)
                
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
        }
        
        private var groupedMembers: [Int: [AreaEntity]] {
            guard let areaList = areaList  else {
                return [:]
            }
            return Dictionary(grouping: areaList) { area in
                area.AREA_CD
            }
        }

        // 🔍 검색 필터
        private var filteredMembers: [AreaEntity] {
            guard let areaList = areaList  else {
                return []
            }
            return areaList.filter { area in
                return (area.SECT_PSN_NM ?? "").contains(searchText) ||
                getInitials(of: (area.SECT_PSN_NM ?? "")).contains(searchText) ||
                (area.SECT_PSN_WIF_NM ?? "").contains(searchText) ||
                getInitials(of: (area.SECT_PSN_WIF_NM ?? "")).contains(searchText)
            }
        }
        
        func getInitials(of name: String) -> String {
            let initials = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ",
                            "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ",
                            "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
            return name.compactMap { char -> String? in
                guard let scalar = char.unicodeScalars.first else { return nil }
                if scalar.value >= 0xAC00 && scalar.value <= 0xD7A3 {
                    let index = Int((scalar.value - 0xAC00) / 28 / 21)
                    return initials[index]
                } else if char.isLetter {
                    return String(char).uppercased()
                } else {
                    return nil
                }
            }.joined()
        }
        
        @ViewBuilder
        func sectionHeader(area: AreaEntity) -> some View {
            VStack(spacing: 0) {
                HStack {
                    Text("\(area.AREA_CD)지역")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding(.vertical, 6)
                    Text(" (총 \(area.TOTAL_CNT)명) 장년 \(area.CNT1) 부인 \(area.CNT2) 실버 \(area.CNT3) 청년 \(area.CNT4) 그 외 \(area.CNT5)")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .padding(.vertical, 6)
                    Spacer()
                }

                Divider() // 🔥 구분선 추가
                    .background(Color.black)
                    .padding(.leading, 6) // 구분선 시작 위치 조절
            }
        }
    }
    
    struct MemberCardView: View {
        let area: AreaEntity
        @Binding var name: String
        @Binding var phone: String
        @Binding var email: String

        @Binding var isPresented: Bool
        
        var body: some View {
            HStack(alignment: .top) {
                ZStack(alignment: .topTrailing) {
                    HStack(alignment: .top, spacing: 8) {
                        KFImage(URL(string: area.SECT_PIC ?? ""))
                            .placeholder {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.gray)
                                    .opacity(0.3)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            (
                                Text(area.SECT_PSN_NM ?? "-") +
                                Text(" \(area.SECT_DUTY_NM ?? "")").font(.system(size: 17))
                            )
                            .font(.system(size: 20, weight: .bold))
                            
                            Text(area.SECT_PSN_MB_PHONE ?? "-")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: (area.SECT_PSN_WIF_NM ?? "").count > 1 ? .infinity : nil, alignment: .leading)
                    
                    // 세로 점 버튼 (오른쪽 상단에 위치)
                    Button(action: {
                        isPresented = true
                        name = area.SECT_PSN_NM ?? ""
                        phone = area.SECT_PSN_MB_PHONE ?? ""
                        email = area.SECT_PSN_EMAIL ?? ""
                    }) {
                        // 터치 영역 전용 컨테이너
                        Color.clear
                            .frame(width: 60, height: 44)        // ← 원하는 터치 폭
                            .contentShape(Rectangle())
                            .overlay(alignment: .topTrailing) {   // ← 아이콘만 오른쪽 위 정렬
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90))
                                    .foregroundColor(.gray)
                                    .padding(.trailing, -8)
                                    .padding(.top, 8)
                            }
                    }
                    .buttonStyle(.plain)
                    .zIndex(999)
                }
                
                // 👩 부인 정보 (optional)
                if let wife = area.SECT_PSN_WIF_NM, !wife.isEmpty {
                    ZStack(alignment: .topTrailing) {
                        HStack(alignment: .top, spacing: 8) {
                            KFImage(URL(string: area.SECT_WIF_PIC ?? ""))
                                .placeholder {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(.gray)
                                        .opacity(0.3)
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .shadow(radius: 1)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                (
                                    Text(wife) +
                                    Text(" \(area.SECT_WIF_DUTY_NM ?? "")").font(.system(size: 17))
                                )
                                .font(.system(size: 20, weight: .bold))
                                
                                Text(area.SECT_PSN_WIF_MB_PHONE ?? "-")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // 세로 점 버튼 (오른쪽 상단에 위치)
                        Button(action: {
                            isPresented = true
                            name = area.SECT_PSN_WIF_NM ?? ""
                            phone = area.SECT_PSN_WIF_MB_PHONE ?? ""
                            email = area.SECT_PSN_WIF_EMAIL ?? ""
                        }) {
                            // 터치 영역 전용 컨테이너
                            Color.clear
                                .frame(width: 60, height: 44)        // ← 원하는 터치 폭
                                .contentShape(Rectangle())
                                .overlay(alignment: .topTrailing) {   // ← 아이콘만 오른쪽 위 정렬
                                    Image(systemName: "ellipsis")
                                        .rotationEffect(.degrees(90))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, -8)
                                        .padding(.top, 8)
                                }
                        }
                        .buttonStyle(.plain)
                        .zIndex(999)
                    }
                } else {
                    Spacer()
                }
            }
            .padding(.vertical, 8)
        }
        
    }
}
