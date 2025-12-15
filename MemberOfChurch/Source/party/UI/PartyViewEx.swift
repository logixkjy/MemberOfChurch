//
//  PartyViewEx.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/7/25.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

extension PartyView {
    internal struct PartyListSectionView: View {
        let members: Array<PartyEntity>?
        @Binding var searchText: String
        
        @Binding var name: String
        @Binding var phone: String
        @Binding var email: String
        
        @Binding var isPresented: Bool
        
        let onSelect: (String?) -> Void   // ✅ 추가
        
        
        private let initialsOrder: [String] = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"] + Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map { String($0) } + ["#"]
        
        var body: some View {
            let grouped = groupMembersByInitial(filteredMembers)
            let sortedKeys = initialsOrder.filter { grouped.keys.contains($0) }
            
            ScrollViewReader { proxy in
                HStack(alignment: .top, spacing: 0) {
                    List {
                        ForEach(sortedKeys, id: \.self) { key in
                            Section(
                                header:
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text(key)
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                            Spacer()
                                        }
                                        
                                        Divider() // 🔥 구분선 추가
                                            .background(Color.black)
                                            .padding(.leading, 6) // 구분선 시작 위치 조절
                                    }
                            ) {
                                ForEach((grouped[key] ?? []).indices, id: \.self) { index in
                                    if let PSN_NM2 = (grouped[key] ?? [])[index].PSN_NM2, PSN_NM2.count > 0 {
                                        MemberCardView(party: (grouped[key] ?? [])[index],
                                                       name: $name,
                                                       phone: $phone,
                                                       email: $email,
                                                       isPresented: $isPresented,
                                                       onSelect: onSelect
                                        )
                                    } else {
                                        MemberRowView(member: (grouped[key] ?? [])[index],
                                                      name: $name,
                                                      phone: $phone,
                                                      email: $email,
                                                      isPresented: $isPresented,
                                                      onSelect: onSelect
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    
                    // 인덱스 바
                    VStack {
                        ForEach(sortedKeys, id: \.self) { key in
                            Button {
                                withAnimation {
                                    proxy.scrollTo(key, anchor: .top)
                                }
                            } label: {
                                Text(key)
                                    .font(.caption2)
                                    .padding(.vertical, 2)
                            }
                        }
                    }
                    .padding(.trailing, 6)
                }
                .background(.white)
            }
        }
        
        var filteredMembers: [PartyEntity] {
            guard let members = members else { return [] }
            if searchText.isEmpty { return members}
            return members.filter {
                ($0.PSN_NM ?? "").contains(searchText) || getInitials(of: ($0.PSN_NM ?? "")).contains(searchText) ||
                ($0.PSN_NM2 ?? "").contains(searchText) ||
                getInitials(of: ($0.PSN_NM2 ?? "")).contains(searchText)
            }
        }
        
        func groupMembersByInitial(_ list: [PartyEntity]) -> [String: [PartyEntity]] {
            Dictionary(grouping: list) { member in
                getInitialConsonant(of: member.PSN_NM ?? "")
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
        
        func getInitialConsonant(of name: String) -> String {
            guard let first = name.first else { return "#" }
            let scalar = first.unicodeScalars.first!.value
            let initials = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ",
                            "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ",
                            "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
            if scalar >= 0xAC00 && scalar <= 0xD7A3 {
                let index = Int((scalar - 0xAC00) / 28 / 21)
                return initials[index]
            } else if first.isLetter {
                return String(first).uppercased()
            } else {
                return "#"
            }
        }
    }
    
    struct MemberCardView: View {
        let party: PartyEntity
        @Binding var name: String
        @Binding var phone: String
        @Binding var email: String

        @Binding var isPresented: Bool
        
        let onSelect: (String?) -> Void   // ✅ 추가
        
        var body: some View {
            HStack(alignment: .top) {
                ZStack(alignment: .topTrailing) {
                    HStack(alignment: .top, spacing: 8) {
                        KFImage(URL(string: party.PIC ?? ""))
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
                                Text(party.PSN_NM ?? "-") +
                                Text(" \(party.DUTY_NM ?? "")").font(.system(size: 17))
                            )
                            .font(.system(size: 20, weight: .bold))
                            
                            Text(party.MB_PHONE ?? "-")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: (party.PSN_NM2 ?? "").count > 1 ? .infinity : nil, alignment: .leading)
                    .contentShape(Rectangle())      // ✅ 셀 전체 탭 가능
                    .onTapGesture {                 // ✅ 상세로 이동 콜백
                        onSelect(party.PSN_ID)
                    }
                    
                    // 세로 점 버튼 (오른쪽 상단에 위치)
                    Button(action: {
                        isPresented = true
                        name = party.PSN_NM ?? ""
                        phone = party.MB_PHONE ?? ""
                        email = party.EMAIL ?? ""
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
                if let psn2 = party.PSN_NM2, !psn2.isEmpty {
                    ZStack(alignment: .topTrailing) {
                        HStack(alignment: .top, spacing: 8) {
                            KFImage(URL(string: party.PIC2 ?? ""))
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
                                    Text(psn2) +
                                    Text(" \(party.DUTY_NM2 ?? "")").font(.system(size: 17))
                                )
                                .font(.system(size: 20, weight: .bold))
                                
                                Text(party.MB_PHONE2 ?? "-")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())      // ✅ 셀 전체 탭 가능
                        .onTapGesture {                 // ✅ 상세로 이동 콜백
                            onSelect(party.PSN_ID2)
                        }
                        
                        // 세로 점 버튼 (오른쪽 상단에 위치)
                        Button(action: {
                            isPresented = true
                            name = party.PSN_NM2 ?? ""
                            phone = party.MB_PHONE2 ?? ""
                            email = party.EMAIL2 ?? ""
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
    
    internal struct MemberRowView: View {
        let member: PartyEntity
        @Binding var name: String
        @Binding var phone: String
        @Binding var email: String
        
        @Binding var isPresented: Bool
        
        let onSelect: (String?) -> Void   // ✅ 추가
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                HStack(spacing: 12) {
                    KFImage(URL(string: member.PIC ?? ""))
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
                            Text(member.PSN_NM ?? "-") +
                            Text(" \(member.DUTY_NM ?? "")").font(.system(size: 20))
                        )
                        .font(.system(size: 25, weight: .bold))
                        
                        Text(member.MB_PHONE ?? "-")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())      // ✅ 셀 전체 탭 가능
                .onTapGesture {                 // ✅ 상세로 이동 콜백
                    onSelect(member.PSN_ID)
                }
                
                // 세로 점 버튼 (오른쪽 상단에 위치)
                Button(action: {
                    isPresented = true
                    name = member.PSN_NM ?? ""
                    phone = member.MB_PHONE ?? ""
                    email = member.EMAIL ?? ""
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
