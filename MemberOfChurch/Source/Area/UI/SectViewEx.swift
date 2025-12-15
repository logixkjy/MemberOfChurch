//
//  SectViewEx.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/4/25.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

extension SectView {
    internal struct SectListSectionView: View {
        @Binding var sectItem: SectEntity
        
        @State private var showPopup = false
        
        @State private var name = ""
        @State private var phone = ""
        @State private var email = ""
        
        let sectList: SectListEntity?
        
        let onSelect: (String?) -> Void   // ✅ 추가
        
        init(sectList: SectListEntity?, sectItem: Binding<SectEntity>, onSelect: @escaping (String?) -> Void) {
            self.sectList = sectList
            self._sectItem = sectItem
            self.onSelect = onSelect
        }
        
        var body: some View {
            ZStack {
                List {
                    if let section = sectList, let sectList = section.list {
                        Section(header: sectionHeader(section: section)) {
                            let indexedSectList = Array(sectList.enumerated())
                            ForEach(indexedSectList, id: \.0) { (idx, sectMembers) in
                                HStack(alignment: .top) {
                                    MemberCardView(sectMemver: sectMembers[0],
                                                   name: $name,
                                                   phone: $phone,
                                                   email: $email,
                                                   isPresented: $showPopup
                                    )
                                    .onTapGesture {
                                        onSelect(sectMembers[0].PSN_ID)
                                    }
                                    .frame(maxWidth: sectMembers.count > 1 ? .infinity : nil, alignment: .leading)

                                    if sectMembers.count > 1 {
                                        MemberCardView(sectMemver: sectMembers[1],
                                                       name: $name,
                                                       phone: $phone,
                                                       email: $email,
                                                       isPresented: $showPopup
                                        )
                                        .onTapGesture {
                                            onSelect(sectMembers[1].PSN_ID)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                
                            }
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
        
        @ViewBuilder
        func sectionHeader(section: SectListEntity) -> some View {
            VStack(spacing: 0) {
                Text("장년 \(section.CNT1) 부인 \(section.CNT2) 실버 \(section.CNT3) 청년 \(section.CNT4) 그 외 \(section.CNT5)")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding(.vertical, 6)
                Spacer()

                Divider() // 🔥 구분선 추가
                    .background(Color.black)
                    .padding(.leading, 6) // 구분선 시작 위치 조절
            }
        }
    }
    
    struct MemberCardView: View {
        let sectMemver: SectEntity
        @Binding var name: String
        @Binding var phone: String
        @Binding var email: String

        @Binding var isPresented: Bool
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                HStack(alignment: .top, spacing: 8) {
                    KFImage(URL(string: sectMemver.PIC ?? ""))
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
                            Text(sectMemver.PSN_NM ?? "-") +
                            Text(" \(sectMemver.DUTY_NM ?? "")").font(.system(size: 17))
                        )
                        .font(.system(size: 20, weight: .bold))
                        
                        Text(sectMemver.MB_PHONE ?? "-")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        
                        Text(sectMemver.PSN_TP_NM ?? "-")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }
                
                // 세로 점 버튼 (오른쪽 상단에 위치)
                Button(action: {
                    isPresented = true
                    name = sectMemver.PSN_NM ?? ""
                    phone = sectMemver.MB_PHONE ?? ""
                    email = sectMemver.EMAIL ?? ""
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
        }
    }
}
