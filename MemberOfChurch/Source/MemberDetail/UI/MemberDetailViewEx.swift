//
//  MemberDetailViewEx.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/9/25.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

// MARK: - Theme
extension Color {
    static let brandGreen = Color(red: 132/255, green: 200/255, blue: 17/255)
    static let familyHeader = Color(red: 30/255, green: 80/255, blue: 20/255) // 진한 그린
}
extension MemberDetailView {
    internal struct MemberDetailInfoView: View {
        
        @EnvironmentObject var mainRouter: MainRouter
        
        var memberDetail: MemberDetailEntity?
        var familyMemberList: Array<FamilyMemberEntity>?
        
        @State private var showFull = false
        
        let onSelect: (String?) -> Void
        
        init(memberDetail: MemberDetailEntity?, familyMemberList: Array<FamilyMemberEntity>?, onSelect: @escaping (String?) -> Void) {
            self.memberDetail = memberDetail
            self.familyMemberList = familyMemberList
            self.onSelect = onSelect
        }
        
        var body: some View {
            WithViewStore(mainRouter.memberRegisterStore, observe: { $0 }) { (viewStore: ViewStoreOf<MemberRegisterCore>) in
                WithViewStore(mainRouter.loginStore, observe: { $0 }) { (viewLoginStore: ViewStoreOf<LoginCore>) in
                    VStack(spacing: 18) {
                        // 프로필
                        KFImage(URL(string: memberDetail?.PIC ?? ""))
                            .placeholder {
                                Image(systemName: "person.circle.fill")
                                    .resizable().scaledToFill()
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 116, height: 116)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                            .padding(.top, 8)
                            .onTapGesture { showFull = true }
                            .fullScreenCover(isPresented: $showFull) {
                                ImageFullScreenView(
                                    url: URL(string: memberDetail?.PIC ?? ""),
                                    onClose: { showFull = false }
                                )
                                .ignoresSafeArea()
                            }
                        
                        // 이름/직분/지역 라인
                        VStack(spacing: 6) {
                            HStack(spacing: 6) {
                                Text(memberDetail?.PSN_NM ?? "").font(.title2).bold()
                                Text(memberDetail?.DUTY_CD_NM ?? "").foregroundColor(.secondary)
                            }
                            if let AREA_CD = memberDetail?.AREA_CD, AREA_CD > 0 {
                                Text("\(AREA_CD)지역 \(memberDetail?.SECT_CD ?? 0)구역 \(memberDetail?.PSN_TP_NM ?? "") / \(getInfo())")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("\(memberDetail?.SECT_CD ?? 0)구역 \(memberDetail?.PSN_TP_NM ?? "") / \(getInfo())")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // 액션 4개
                        HStack(spacing: 26) {
                            RoundActionButton(systemName: "phone.fill", title: "전화걸기") {
                                if let MB_PHONE = memberDetail?.MB_PHONE,
                                   let url = URL(string: "tel://\(MB_PHONE)") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            RoundActionButton(systemName: "message.fill", title: "문자메시지") {
                                if let MB_PHONE = memberDetail?.MB_PHONE,
                                   let url = URL(string: "sms:\(MB_PHONE)") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            RoundActionButton(systemName: "envelope.fill", title: "이메일") {
                                if let EMAIL = memberDetail?.EMAIL,
                                   let url = URL(string: "mailto:\(EMAIL)") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            RoundActionButton(systemName: "doc.on.doc.fill", title: "전화번호 복사") {
                                if let MB_PHONE = memberDetail?.MB_PHONE {
                                    UIPasteboard.general.string = MB_PHONE
                                }
                            }
                        }
                        
                        // 정보 표 (주소는 자동 줄바꿈)
                        VStack(spacing: 0) {
                            InfoRow(label: "구원여부", value: memberDetail?.SV_YN ?? "N")
                            InfoRow(label: "출석여부", value: memberDetail?.CURR_YN ?? "N")
                            InfoRow(label: "생년월일", value: (memberDetail?.BIRTH_DT ?? "").toDate()?.toString() ?? "-")
                            InfoRow(label: "거듭난날", value: (memberDetail?.REBRN_DT ?? "").toDate()?.toString() ?? "-")
                            InfoRow(label: "휴대전화", value: memberDetail?.MB_PHONE ?? "-")
                            InfoRow(label: "집 전화", value: memberDetail?.HOME_PHONE ?? "-")
                            InfoRowMultiline(label: "주  소", value: memberDetail?.ADDRESS ?? "")   // 🔸 멀티라인
                            InfoRow(label: "E-mail", value: memberDetail?.EMAIL ?? "")
                            InfoRow(label: "굿뉴스코", value: memberDetail?.GNC_INFO ?? "-")
                            InfoRow(label: "기관근무자", value: changeWRK_ORG_CDToString(code: memberDetail?.WRK_ORG_CD ?? "-"))
                            InfoRowMultiline(label: "기타사항", value: memberDetail?.RMK ?? "")   // 🔸 멀티라인
                        }
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        // 정보 수정하기 버튼
                        Button {
                            viewStore.send(.onAppear)
                            viewStore.send(.setMemberDetailEntity(memberDetail))
                            mainRouter.push(type: .memberAddView)
                        } label: {
                            HStack(spacing: 6) {
                                Text("정보 수정하기")
                                Image(systemName: "square.and.pencil")
                            }
                            .font(.body.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        
                        // 가족 정보 섹션
                        VStack(spacing: 0) {
                            HStack {
                                Text("가족 정보").font(.subheadline).foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 32)
                            .background(Color.familyHeader)
                            // 목록
                            LazyVStack(spacing: 0) {
                                ForEach(familyMemberList ?? [], id: \.PSN_ID) { f in
                                    FamilyRow(
                                        member: f,
                                        onSelect: onSelect
                                    )
                                    Divider()
                                }
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        // 가족 추가하기
                        Button {
                            viewStore.send(.setFamilyRep(memberDetail?.FAM_REP_NM ?? ""))
                            viewStore.send(.setFamilyRepDisabled(true))
                            viewStore.send(.setChurchCode(viewLoginStore.loginEntity?.CHUR_CD ?? ""))
                            mainRouter.push(type: .memberAddView)
                        } label: {
                            Text("가족 추가하기  +")
                                .font(.body.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        
        func changeWRK_ORG_CDToString(code: String) -> String {
            switch code {
            case "190122":
                return "국제청소년연합"
            case "190162":
                return "굿뉴스 의료봉사회"
            case "190105":
                return "기쁜소식사"
            case "190127":
                return "드래곤플라이"
            case "190163":
                return "마하나임바이블트레이닝센터"
            case "190133":
                return "선교회총회"
            case "190114":
                return "영상선교부"
            case "190115":
                return "음향선교부"
            case "190120":
                return "인터넷선교부"
            case "190107":
                return "임마누엘"
            case "190135":
                return "주간기쁜소식"
            case "190125":
                return "투머로우"
            default:
                return "-"
            }
        }
        
        func changeGRD_CDToString(code: String) -> String {
            switch code {
            case "E1":
                return "초등1"
            case "E2":
                return "초등2"
            case "E3":
                return "초등3"
            case "E4":
                return "초등4"
            case "E5":
                return "초등5"
            case "E6":
                return "초등6"
            case "M1":
                return "중1"
            case "M2":
                return "중2"
            case "M3":
                return "중3"
            case "H1":
                return "고1"
            case "H2":
                return "고2"
            case "H3":
                return "고3"
            case "C1":
                return "대학1"
            case "C2":
                return "대학2"
            case "C3":
                return "대학3"
            case "C4":
                return "대학4"
            case "VC":
                return "휴학중"
            default:
                return ""
            }
        }
        
        func getInfo() -> String {
            var info = memberDetail?.PART_DUTY_NM ?? ""
            if let JOB_NM = memberDetail?.JOB_NM, JOB_NM != "-" {
                info += " / \(JOB_NM)"
            } else if let GRD_CD = memberDetail?.GRD_CD, GRD_CD != "-" {
                info += " / \(changeGRD_CDToString(code: GRD_CD))"
            } else {
                info += " / \(memberDetail?.JOB_NM ?? "-")"
            }
            return info
        }
    }
    
    struct RoundActionButton: View {
        let systemName: String
        let title: String
        let action: () -> Void
        
        var body: some View {
            VStack(spacing: 8) {
                Button(action: action) {
                    ZStack {
                        Circle().fill(Color.brandGreen)
                            .frame(width: 56, height: 56)
                        Image(systemName: systemName)
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                }
                .buttonStyle(.plain)
                Text(title).font(.caption).foregroundColor(.secondary)
            }
        }
    }
    
    // 기본 1줄 행
    struct InfoRow: View {
        let label: String
        let value: String
        var body: some View {
            VStack(spacing: 0) {
                HStack(alignment: .firstTextBaseline) {
                    Text(label)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(value)
                        .foregroundColor(.primary)
                }
                .font(.body)
                .padding(.vertical, 10)
                Divider()
                    .background(Color(.systemGray5))
            }
            .padding(.horizontal, 12)
        }
    }
    
    // 여러 줄 값 자동 확장 행 (주소 등)
    struct InfoRowMultiline: View {
        let label: String
        let value: String
        var body: some View {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 8) {
                    Text(label)
                        .foregroundColor(.secondary)
                    Spacer(minLength: 12)
                    Text(value)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.trailing)
                        .fixedSize(horizontal: false, vertical: true) // 🔸 줄바꿈에 맞춰 높이 확장
                        .lineLimit(nil)
                }
                .font(.body)
                .padding(.vertical, 10)
                Divider()
                    .background(Color(.systemGray5))
            }
            .padding(.horizontal, 12)
        }
    }
    
    struct FamilyRow: View {
        let member: FamilyMemberEntity
        
        let onSelect: (String?) -> Void
        
        var body: some View {
            HStack(spacing: 12) {
                KFImage(URL(string: member.PIC ?? ""))
                    .placeholder { Image(systemName: "person.circle.fill")
                            .resizable().scaledToFill()
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(member.PSN_NM ?? "").font(.headline)
                        Text(member.DUTY_CD_NM ?? "").foregroundColor(.secondary)
                    }
                    Text(member.MB_PHONE ?? "-")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(changeFAM_REL_CDToString(code: member.FAM_REL_CD ?? "-")) // 가족대표 / 처 / 자 …
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .contentShape(Rectangle())      // ✅ 셀 전체 탭 가능
            .onTapGesture {                 // ✅ 상세로 이동 콜백
                onSelect(member.PSN_ID)
            }
        }
        
        func changeFAM_REL_CDToString(code: String) -> String {
            switch code {
            case "SELF":
                return "가족 대표"
            case "FA":
                return "부"
            case "MO":
                return "모"
            case "HUS":
                return "남편"
            case "WIF":
                return "처"
            case "SON":
                return "자"
            case "DTR":
                return "녀"
            case "ETC":
                return "기타(동거인)"
            default:
                return "-"
            }
        }
    }
    
    struct ImageFullScreenView: View {
        let url: URL?
        var onClose: () -> Void
        
        @State private var scale: CGFloat = 1
        @State private var lastScale: CGFloat = 1
        @State private var offset: CGSize = .zero
        @State private var lastOffset: CGSize = .zero
        
        var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if let url {
                    KFImage(url)
                        .placeholder { ProgressView().tint(.white) }
                        .onFailureImage(UIImage(systemName: "exclamationmark.triangle"))                        .resizable()            // ← 제스처를 위해 꼭 필요
                        .scaledToFit()
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = min(max(1, lastScale * value), 4)
                                }
                                .onEnded { _ in lastScale = scale }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = CGSize(width: lastOffset.width + value.translation.width,
                                                    height: lastOffset.height + value.translation.height)
                                }
                                .onEnded { _ in lastOffset = offset }
                        )
                        .onTapGesture(count: 2) {
                            withAnimation(.easeInOut) {
                                if scale > 1 { scale = 1; lastScale = 1; offset = .zero; lastOffset = .zero }
                                else { scale = 2; lastScale = 2 }
                            }
                        }
                } else {
                    Text("이미지가 없습니다").foregroundColor(.white.opacity(0.7))
                }
                
                HStack {
                    Button { onClose() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .padding(10)
                            .background(Circle().fill(.black.opacity(0.5)))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 64)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}
