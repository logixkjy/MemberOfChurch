//
//  PartyEntity.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/5/25.
//

struct PartyListEntity: Decodable, Equatable {
    let list: Array<PartyEntity>?
}

struct PartyEntity: Decodable, Equatable {
    let SECT_CD: Int
    let AREA_CD: Int
    let PSN_ID: String?
    let PSN_NM: String?
    let DUTY_NM: String?
    let MB_PHONE: String?
    let EMAIL: String?
    let PIC: String?
    let PSN_ID2: String?
    let PSN_NM2: String?
    let DUTY_NM2: String?
    let MB_PHONE2: String?
    let EMAIL2: String?
    let PIC2: String?
    
    init(
        SECT_CD: Int = 0,
        AREA_CD: Int = 0,
        PSN_ID: String? = nil,
        PSN_NM: String? = nil,
        DUTY_NM: String? = nil,
        MB_PHONE: String? = nil,
        EMAIL: String? = nil,
        PIC: String? = nil,
        PSN_ID2: String? = nil,
        PSN_NM2: String? = nil,
        DUTY_NM2: String? = nil,
        MB_PHONE2: String? = nil,
        EMAIL2: String? = nil,
        PIC2: String? = nil
    ) {
        self.SECT_CD = SECT_CD
        self.AREA_CD = AREA_CD
        self.PSN_ID = PSN_ID
        self.PSN_NM = PSN_NM
        self.DUTY_NM = DUTY_NM
        self.MB_PHONE = MB_PHONE
        self.EMAIL = EMAIL
        self.PIC = PIC
        self.PSN_ID2 = PSN_ID2
        self.PSN_NM2 = PSN_NM2
        self.DUTY_NM2 = DUTY_NM2
        self.MB_PHONE2 = MB_PHONE2
        self.EMAIL2 = EMAIL2
        self.PIC2 = PIC2
    }
}
