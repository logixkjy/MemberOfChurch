//
//  MemberRegisterCore.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/12/25.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

@Reducer
struct MemberRegisterCore {
    enum Gender: String, CaseIterable, Equatable, Identifiable {
        case male = "남"
        case female = "여"
        var id: String { rawValue }
    }
    
    enum YesNo: String, CaseIterable, Equatable, Identifiable {
        case yes = "YES"
        case no = "NO"
        var id: String { rawValue }
    }
    
    enum RegistMode: String, CaseIterable, Equatable, Identifiable {
        case write = "write"
        case modify = "modify"
        var id: String { rawValue }
    }
    
    
    
//    @ObservableState
    struct State: Equatable {
        var hasLoadedOnce: Bool = false
        
        var sectLists: Array<ChurSectEntity> = []
        var churchLists: Array<ChurchEntity> = []
        
        // 사진
        var localImageURL: URL? = nil
        var pickedImageData: Data? = nil
        
        // 기본 정보
        var name: String = ""
        var gender: Gender? = nil
        
        // 출생/중생
        var birthDate: Date = Date()
        var salvationDate: Date = Date()
        
        // 연락처
        var mobile1: MobileCode = .zero
        var mobile2: String = ""
        var mobile3: String = ""
        
        var phone1: PhoneCode = .one
        var phone2: String = ""
        var phone3: String = ""
        
        // 상태/소속
        var isSaved: YesNo? = nil
        var isAttend: YesNo? = nil
        var churchName: ChurchEntity? =
        ChurchEntity(
            CHUR_CD: "020302",
            CHUR_NM: "기쁜소식강남교회",
            ENG_CHUR_NM: "Good News Gangnam Church",
            ZIP_NO: "06762",
            ADDR: "서울특별시 서초구 남부순환로342길 100-15 (양재동)",
            NEW_ADDR: "서울 서초구 양재동 183",
            ENG_ADDR: "100-15, Nambusunhwan-ro 342-gil, Seocho-gu, Seoul",
            HM_PHONE_NO: "(02)539-0691",
            PHONE_NO2: "",
            FAX_NO: "(02) 574-0275",
            AREA_NO: 1,
            SECT_NO: 1,
            SEQ: 1,
            ETC: "구주소-Secho-Gu Yange-Dong 183, Seoul, South Korea, 서울 서초구 양재동 183\r\n2004.11.1 서울제일교회 통합.  ",
            LATITUDE: 37.476803,
            LONGITUDE: 127.027735,
            REGION_NM: "SEOUL",
            CHUR_TP: "I"
        )
        var CHUR_CD: String = ""
        
        
        // 지역/구역
        var area: String = ""
        var sect: ChurSectEntity? = nil
        
        // 구분/직분/임원직분/직업/학교/학년
        var category: PsnCategory = .NONE
        var duty: Duty = .NONE
        var officerDuty: OfficerDuty = .NONE
        var job: String = ""
        var school: String = ""
        var grade: Grade = .NONE
        
        // 가족
        var familyRep: String = ""
        var familyRepDisabled = false
        var relation: FamRelation = .NONE
        
        // 주소/이메일/기타
        var address: String = ""
        var email: String = ""
        var goodNewsCorps: String = ""
        var termWorker: TermWorker = .NONE
        var memo: String = ""
        
        var mode: RegistMode = .write
        
        // 진행 상태
        var isSubmitting: Bool = false
        var alert: String = ""
        var isSuccress = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case onAppear
        
        case getChurSectList
        case setChurSectList(Array<ChurSectEntity>?, Array<ChurchEntity>?)
        
        // 사진
        case setPickedImageData(Data?)
        case _didSaveImage(URL?)
        case _imageSaveFailed
        
        case setName(String)
        case setGender(Gender?)
        
        case setBirthDate(Date)
        case setSalvationDate(Date)
        
        case setMobile1(MobileCode)
        case setMobile2(String)
        case setMobile3(String)
        
        case setPhone1(PhoneCode)
        case setPhone2(String)
        case setPhone3(String)
        
        case setIsSaved(YesNo?)
        case setIsAttend(YesNo?)
        
        case setChurchName(ChurchEntity?)
        
        case setCategory(PsnCategory)
        case setDuty(Duty)
        case setOfficerDuty(OfficerDuty)
        case setSect(ChurSectEntity?)
        case setJob(String)
        
        case setSchool(String)
        case setGrade(Grade)
        
        case setFamilyRep(String)
        case setFamilyRepDisabled(Bool)
        case setRelation(FamRelation)
        
        case setAddress(String)
        case setEmail(String)
        case setGoodNewsCorps(String)
        case setTermWorker(TermWorker)
        case setMemo(String)
        
        case setMode(RegistMode)
        
        // 제출
        case submitTapped
        case _submitFinished(Bool)
        
        case setChurchCode(String)
        
        case setMemberDetailEntity(MemberDetailEntity?)
        
        case clear
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.memberRegisterClient) var memberRegisterClient
    @Dependency(\.userDefaults) var userDefaults
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding(_):
                return .none
                
            case .onAppear:
                // 1) 한 번도 로딩 안 됐으면
                if !state.hasLoadedOnce {
                    return .send(.getChurSectList)
                }
                return .none
                
            case .getChurSectList:
                return .run { send in
                    for await response in await memberRegisterClient.churSectList() {
                        if let sectLists = response.SECT_LIST,
                           !sectLists.isEmpty,
                           let churchLists = response.CHUR_LIST,
                           !churchLists.isEmpty {
                            await send(.setChurSectList(sectLists, churchLists))
                        }
                    }
                }
                
            case let .setChurSectList(sectLists, churchLists):
                state.sectLists = sectLists ?? []
                state.churchLists = churchLists ?? []
                
                if !state.CHUR_CD.isEmpty {
                    let cade = state.CHUR_CD
                    return .run { send in
                        await send(.setChurchCode(cade))
                    }
                }
                return .none
                
            case let .setPickedImageData(data):
                guard let data = data else { return .none }
                return .run { send in
                    do {
                        let url = try await ImageSaver.saveImageDataAsync(data)
                        await send(._didSaveImage(url))
                    } catch {
                        await send(._imageSaveFailed)
                    }
                }
                
            case let ._didSaveImage(url):
                guard let url = url else { return .none }
                state.localImageURL = url             // 업로드 시 이 경로 사용 가능
                state.pickedImageData = try? Data(contentsOf: url) // 미리보기 필요 시
                return .none
                
            case ._imageSaveFailed:
                state.localImageURL = nil
                state.pickedImageData = nil
                return .none
                
//            case let .setPickedImageData(data):
//                state.pickedImageData = data
//                return .none
                
            case let .setName(name):
                state.name = name
                return .none
                
            case let .setGender(gender):
                state.gender = gender
                return .none
                
            case let .setBirthDate(date):
                state.birthDate = date
                return .none
                
            case let .setSalvationDate(date):
                state.salvationDate = date
                return .none
                
            case .setMobile1(let p1):
                state.mobile1 = p1
                return .none
            case .setMobile2(let p2):
                state.mobile2 = p2
                return .none
            case .setMobile3(let p3):
                state.mobile3 = p3
                return .none
                
            case .setPhone1(let p1):
                state.phone1 = p1
                return .none
            case .setPhone2(let p2):
                state.phone2 = p2
                return .none
            case .setPhone3(let p3):
                state.phone3 = p3
                return .none
                
            case .setIsSaved(let yesNo):
                state.isSaved = yesNo
                return .none
            case .setIsAttend(let yesNo):
                state.isAttend = yesNo
                return .none
            case .setChurchName(let name):
                state.churchName = name
                return .none
                
            case .setCategory(let value):
                state.category = value
                return .none
            case .setDuty(let value):
                state.duty = value
                return .none
            case .setOfficerDuty(let value):
                state.officerDuty = value
                return .none
            case .setSect(let value):
                state.sect = value
                return .none
            case .setJob(let value):
                state.job = value
                return .none
                
            case .setSchool(let value):
                state.school = value
                return .none
            case .setGrade(let value):
                state.grade = value
                return .none
            case .setFamilyRep(let value):
                state.familyRep = value
                return .none
            case .setFamilyRepDisabled(let value):
                state.familyRepDisabled = value
                return .none
            case .setRelation(let value):
                state.relation = value
                return .none
                
            case .setAddress(let value):
                state.address = value
                return .none
            case .setEmail(let value):
                state.email = value
                return .none
            case .setGoodNewsCorps(let value):
                state.goodNewsCorps = value
                return .none
            case .setTermWorker(let value):
                state.termWorker = value
                return .none
            case .setMemo(let value):
                state.memo = value
                return .none
                
            case .setMode(let value):
                state.mode = value
                return .none
                
            case .setChurchCode(let code):
                guard !state.churchLists.isEmpty else {
                    state.CHUR_CD = code
                    return .none
                }
                let result = state.churchLists.filter { ($0.CHUR_CD ?? "") == code }
                if !result.isEmpty {
                    state.churchName = result[0]
                }
                return .none
                
            case .setMemberDetailEntity(let entity):
                if let entity = entity {
                    state.name = entity.PSN_NM ?? ""
                    let result = state.churchLists.filter { ($0.CHUR_CD ?? "") == entity.CHUR_CD }
                    if !result.isEmpty {
                        state.churchName = result[0]
                    }
                    state.gender = (entity.GENDER_CD ?? "M") == "M" ? Gender.male : Gender.female
                    
                    state.isSaved = (entity.SV_YN ?? "N") == "Y" ? YesNo.yes : YesNo.no
                    state.isAttend = (entity.CURR_YN ?? "N") == "Y" ? YesNo.yes : YesNo.no
                    
                    state.birthDate = (entity.BIRTH_DT ?? "").toDate() ?? Date()
                    state.salvationDate = (entity.REBRN_DT ?? "").toDate() ?? Date()
                    
                    if let mobile = entity.MB_PHONE, !mobile.isEmpty {
                        let mobileParts = mobile.components(separatedBy: "-")
                        if mobileParts.count == 3 {
                            state.mobile1 = MobileCode.find(mobileParts[0])
                            state.mobile2 = mobileParts[1]
                            state.mobile3 = mobileParts[2]
                        }
                    }
                    
                    if let phone = entity.HOME_PHONE, !phone.isEmpty {
                        let phoneParts = phone.components(separatedBy: "-")
                        if phoneParts.count == 3 {
                            state.phone1 = PhoneCode.find(phoneParts[0])
                            state.phone2 = phoneParts[1]
                            state.phone3 = phoneParts[2]
                        }
                    }
                    
                    state.area = "\(entity.AREA_CD)"
                    if entity.AREA_CD > 0 {
                        let result = state.sectLists.filter { $0.AREA_CD == entity.AREA_CD }
                        if !result.isEmpty {
                            state.sect = result[0]
                        }
                    }
                    // 구분/직분/임원직분/직업/학교/학년
                    state.category = PsnCategory.find(entity.PSN_TP ?? "")
                    state.duty = Duty.find(entity.DUTY_CD ?? "")
                    state.officerDuty = OfficerDuty.find(entity.PART_DUTY_CD ?? "")
                    state.job = entity.JOB_NM ?? ""
                    state.school = entity.SCHOOL_CAREER ?? ""
                    state.grade = Grade.find(entity.GRD_CD ?? "")
                    
                    // 가족
                    state.familyRep = entity.FAM_REP_NM ?? ""
                    state.relation = FamRelation.find(entity.FAM_REL_CD ?? "")
                    
                    // 주소/이메일/기타
                    state.address = entity.ADDRESS ?? ""
                    state.email = entity.EMAIL ?? ""
                    state.goodNewsCorps = entity.GNC_INFO ?? ""
                    state.termWorker = TermWorker.find(entity.WRK_ORG_CD ?? "")
                    state.memo = entity.RMK ?? ""
                    
                    state.mode = .modify
                    
                    return .run { send in
                        let data = await dataFromURLString(entity.PIC ?? "")
                        await send(.setPickedImageData(data))
                    }
                }
                return .none
                
            case .clear:
                // 사진
                state.localImageURL = nil
                state.pickedImageData = nil
                
                // 기본 정보
                state.name = ""
                state.gender = nil
                
                // 출생/중생
                state.birthDate = Date()
                state.salvationDate = Date()
                
                // 연락처
                state.mobile1 = .zero
                state.mobile2 = ""
                state.mobile3 = ""
                
                state.phone1 = .one
                state.phone2 = ""
                state.phone3 = ""
                
                // 상태/소속
                state.isSaved = nil
                state.isAttend = nil
                state.churchName =
                ChurchEntity(
                    CHUR_CD: "020302",
                    CHUR_NM: "기쁜소식강남교회",
                    ENG_CHUR_NM: "Good News Gangnam Church",
                    ZIP_NO: "06762",
                    ADDR: "서울특별시 서초구 남부순환로342길 100-15 (양재동)",
                    NEW_ADDR: "서울 서초구 양재동 183",
                    ENG_ADDR: "100-15, Nambusunhwan-ro 342-gil, Seocho-gu, Seoul",
                    HM_PHONE_NO: "(02)539-0691",
                    PHONE_NO2: "",
                    FAX_NO: "(02) 574-0275",
                    AREA_NO: 1,
                    SECT_NO: 1,
                    SEQ: 1,
                    ETC: "구주소-Secho-Gu Yange-Dong 183, Seoul, South Korea, 서울 서초구 양재동 183\r\n2004.11.1 서울제일교회 통합.  ",
                    LATITUDE: 37.476803,
                    LONGITUDE: 127.027735,
                    REGION_NM: "SEOUL",
                    CHUR_TP: "I"
                )
                
                // 지역/구역
                state.area = ""
                state.sect = nil
                
                // 구분/직분/임원직분/직업/학교/학년
                state.category = .NONE
                state.duty = .NONE
                state.officerDuty = .NONE
                state.job = ""
                state.school = ""
                state.grade = .NONE
                
                // 가족
                state.familyRep = ""
                state.familyRepDisabled = false
                state.relation = .NONE
                
                // 주소/이메일/기타
                state.address = ""
                state.email = ""
                state.goodNewsCorps = ""
                state.termWorker = .NONE
                state.memo = ""
                
                state.mode = .write
                
                // 진행 상태
                state.isSubmitting = false
                state.alert = ""
                state.isSuccress = false
                
                return .none
                
            case .submitTapped:
                guard !state.name.trimmingCharacters(in: .whitespaces).isEmpty else {
                    state.alert = "이름이 입력되지 않았습니다."
                    return .none
                }
                guard !state.mobile2.trimmingCharacters(in: .whitespaces).isEmpty,
                      !state.mobile3.trimmingCharacters(in: .whitespaces).isEmpty else {
                    state.alert = "휴대전화 번호가 입력되지 않았습니다."
                    return .none
                }
                guard state.category != .NONE else {
                    state.alert = "구분이 선택되지 않았습니다."
                    return .none
                }
                guard let sect = state.sect, sect.AREA_CD != 0 else {
                    state.alert = "구역이 선택되지 않았습니다."
                    return .none
                }
                guard !state.familyRep.trimmingCharacters(in: .whitespaces).isEmpty else {
                    state.alert = "가족대표가 입력되지 않았습니다."
                    return .none
                }
                guard state.relation != .NONE else {
                    state.alert = "관계가 선택되지 않았습니다."
                    return .none
                }
                
                state.isSubmitting = true
                
                // ✅ 파라미터 구성 (Obj‑C와 동일 키)
                let params: [String: String] = {
                    var d: [String: String] = [:]
                    d["PSN_NM"] = state.name
                    d["MB_PHONE"] = "\(state.mobile1.rawValue)-\(state.mobile2)-\(state.mobile3)" // 010-xxxx-xxxx
                    if !state.phone2.isEmpty, !state.phone3.isEmpty {
                        d["HOME_PHONE"] = "\(state.phone1.rawValue)-\(state.phone2)-\(state.phone3)"
                    }
                    d["BIRTH_DT"] = state.birthDate.toString(format: "yyyy-MM-dd")
                    d["REBRN_DT"] = state.salvationDate.toString(format: "yyyy-MM-dd")
                    d["CHUR_CD"] = state.churchName?.CHUR_CD ?? ""
                    d["DUTY_CD"] = state.duty.tag
                    d["PSN_TP"]  = state.category.tag
                    d["GENDER_CD"] = (state.gender ?? .male) == .male ? "M" : "F"
                    d["SECT_CD"] = String(sect.SECT_CD)
                    d["ADDRESS"] = state.address
                    d["EMAIL"] = state.email
                    d["JOB_NM"] = state.job
                    d["SCHOOL_CAREER"] = state.school
                    d["GRD_CD"] = state.grade != .NONE ? state.grade.tag : ""
                    d["FAM_REP_NM"] = state.familyRep
                    d["FAM_REL_CD"] = state.relation.tag
                    d["SV_YN"] = state.isSaved == .yes ? "Y" : "N"
                    d["CURR_YN"] = state.isAttend == .yes ? "Y" : "N"
                    d["PART_DUTY_CD"] = state.officerDuty != .NONE ? state.officerDuty.tag : ""
                    d["WRK_ORG_CD"] = state.termWorker != .NONE ? state.termWorker.tag : ""
                    d["GNC_INFO"] = state.goodNewsCorps
                    d["RMK"] = state.memo
                    d["mode"] = state.mode.rawValue
                    d["REG_USER_ID"] = userDefaults.stringForKey(UDKeys.userID)
                    return d
                }()
                
//                let imageData = state.pickedImageData // Data? (없으면 nil 그대로 보냄)
                let imageData = {
                    if let localImageURL = state.localImageURL{
                        return try? Data(contentsOf: localImageURL)
                    }
                    return nil
                }()
                return .run { send in
                    do {
                        _ = try await memberRegisterClient.register(params, imageData)
                        await send(._submitFinished(true))
                    } catch {
                        await send(._submitFinished(false))
                    }
                }
                
            case let ._submitFinished(ok):
                state.isSubmitting = false
                state.alert = (ok ? (state.mode == .write ? "등록 되었습니다." : "수정 되었습니다.") : (state.mode == .write ? "등록 실패하였씁니다." : "수정되지 않았습니다."))
                state.isSuccress = ok
                return .none
                
                
            }
        }
    }
    
    func dataFromURLString(_ s: String) async -> Data? {
        guard let url = URL(string: s) else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else { return nil }
            return data
        } catch {
            return nil
        }
    }
}
