//
//  MemberDetailEntity.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/9/25.
//

struct MemberDetailInfoEntity: Decodable, Equatable {
    let member: MemberDetailEntity?
    let list: [FamilyMemberEntity]
    let visit: [UnknownVisit]   // 내용은 버림 (빈 구조체)

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        member = try c.decodeIfPresent(MemberDetailEntity.self, forKey: .member)
        list   = try c.decodeIfPresent([FamilyMemberEntity].self, forKey: .list) ?? []
        visit  = try c.decodeIfPresent([UnknownVisit].self, forKey: .visit) ?? []
    }

    private enum CodingKeys: String, CodingKey { case member, list, visit }
}

/// 어떤 키가 오든 무시하고 성공하도록 하는 빈 타입
struct UnknownVisit: Decodable, Equatable {}

struct MemberDetailEntity: Decodable, Equatable {
    let PSN_ID : String?
    let PSN_NM : String?
    let CHUR_CD : String?
    let GENDER_CD : String?
    let PARTY_CD : String?
    let PSN_TP : String?
    let DUTY_CD : String?
    let PART_DUTY_CD : String?
    let SECT_CD : Int
    let ADDRESS : String?
    let HOME_PHONE : String?
    let MB_PHONE : String?
    let EMAIL : String?
    let BIRTH_DT : String?
    let REBRN_DT : String?
    let SCHOOL_CAREER : String?
    let JOB_NM : String?
    let GRD_CD : String?
    let FAM_REP_NM : String?
    let FAM_REL_CD : String?
    let GNN__ID : String?
    let MARR_YN : String?
    let SV_YN : String?
    let CURR_YN : String?
    let CONNECTED_BY : String?
    let RMK : String?
    let REG_DT : String?
    let REG_USER_ID : String?
    let GNC_INFO : String?
    let USER_AGENT : String?
    let MOD_DT : String?
    let MOD_USER_ID : String?
    let WRK_ORG_CD : String?
    let PLBM_CD : String?
    let PLBM_DTL_CTNT : String?
    let VISIT_FG : String?
    let ATTND_STS : String?
    let AREA_CD : Int
    let GENDER_NM : String?
    let DUTY_CD_NM : String?
    let PARTY_NM : String?
    let PSN_TP_NM : String?
    let PART_DUTY_NM : String?
    let FAM_REL_NM : String?
    let PIC : String?
    let FAM_PSN_ID : String?
    
    init(
        PSN_ID: String? = nil,
        PSN_NM: String? = nil,
        CHUR_CD: String? = nil,
        GENDER_CD: String? = nil,
        PARTY_CD: String? = nil,
        PSN_TP: String? = nil,
        DUTY_CD: String? = nil,
        PART_DUTY_CD: String? = nil,
        SECT_CD: Int = 0,
        ADDRESS: String? = nil,
        HOME_PHONE: String? = nil,
        MB_PHONE: String? = nil,
        EMAIL: String? = nil,
        BIRTH_DT: String? = nil,
        REBRN_DT: String? = nil,
        SCHOOL_CAREER: String? = nil,
        JOB_NM: String? = nil,
        GRD_CD: String? = nil,
        FAM_REP_NM: String? = nil,
        FAM_REL_CD: String? = nil,
        GNN__ID: String? = nil,
        MARR_YN: String? = nil,
        SV_YN: String? = nil,
        CURR_YN: String? = nil,
        CONNECTED_BY: String? = nil,
        RMK: String? = nil,
        REG_DT: String? = nil,
        REG_USER_ID: String? = nil,
        GNC_INFO: String? = nil,
        USER_AGENT: String? = nil,
        MOD_DT: String? = nil,
        MOD_USER_ID: String? = nil,
        WRK_ORG_CD: String? = nil,
        PLBM_CD: String? = nil,
        PLBM_DTL_CTNT: String? = nil,
        VISIT_FG: String? = nil,
        ATTND_STS: String? = nil,
        AREA_CD: Int = 0,
        GENDER_NM: String? = nil,
        DUTY_CD_NM: String? = nil,
        PARTY_NM: String? = nil,
        PSN_TP_NM: String? = nil,
        PART_DUTY_NM: String? = nil,
        FAM_REL_NM: String? = nil,
        PIC: String? = nil,
        FAM_PSN_ID: String? = nil
     ) {
        self.PSN_ID = PSN_ID
        self.PSN_NM = PSN_NM
        self.CHUR_CD = CHUR_CD
        self.GENDER_CD = GENDER_CD
        self.PARTY_CD = PARTY_CD
        self.PSN_TP = PSN_TP
        self.DUTY_CD = DUTY_CD
        self.PART_DUTY_CD = PART_DUTY_CD
        self.SECT_CD = SECT_CD
        self.ADDRESS = ADDRESS
        self.HOME_PHONE = HOME_PHONE
        self.MB_PHONE = MB_PHONE
        self.EMAIL = EMAIL
        self.BIRTH_DT = BIRTH_DT
        self.REBRN_DT = REBRN_DT
        self.SCHOOL_CAREER = SCHOOL_CAREER
        self.JOB_NM = JOB_NM
        self.GRD_CD = GRD_CD
        self.FAM_REP_NM = FAM_REP_NM
        self.FAM_REL_CD = FAM_REL_CD
        self.GNN__ID = GNN__ID
        self.MARR_YN = MARR_YN
        self.SV_YN = SV_YN
        self.CURR_YN = CURR_YN
        self.CONNECTED_BY = CONNECTED_BY
        self.RMK = RMK
        self.REG_DT = REG_DT
        self.REG_USER_ID = REG_USER_ID
        self.GNC_INFO = GNC_INFO
        self.USER_AGENT = USER_AGENT
        self.MOD_DT = MOD_DT
        self.MOD_USER_ID = MOD_USER_ID
        self.WRK_ORG_CD = WRK_ORG_CD
        self.PLBM_CD = PLBM_CD
        self.PLBM_DTL_CTNT = PLBM_DTL_CTNT
        self.VISIT_FG = VISIT_FG
        self.ATTND_STS = ATTND_STS
        self.AREA_CD = AREA_CD
        self.GENDER_NM = GENDER_NM
        self.DUTY_CD_NM = DUTY_CD_NM
        self.PARTY_NM = PARTY_NM
        self.PSN_TP_NM = PSN_TP_NM
        self.PART_DUTY_NM = PART_DUTY_NM
        self.FAM_REL_NM = FAM_REL_NM
        self.PIC = PIC
        self.FAM_PSN_ID = FAM_PSN_ID
    }
}

struct FamilyMemberEntity: Decodable, Equatable {
    let PSN_ID: String?
    let PSN_NM: String?
    let CHUR_CD: String?
    let GENDER_CD: String?
    let PARTY_CD: String?
    let PSN_TP: String?
    let DUTY_CD: String?
    let PART_DUTY_CD: String?
    let SECT_CD: Int
    let ADDRESS: String?
    let HOME_PHONE: String?
    let MB_PHONE: String?
    let EMAIL: String?
    let BIRTH_DT: String?
    let REBRN_DT: String?
    let SCHOOL_CAREER: String?
    let JOB_NM: String?
    let GRD_CD: String?
    let FAM_REP_NM: String?
    let FAM_REL_CD: String?
    let GNN__ID: String?
    let MARR_YN: String?
    let SV_YN: String?
    let CURR_YN: String?
    let CONNECTED_BY: String?
    let RMK: String?
    let REG_DT: String?
    let REG_USER_ID: String?
    let GNC_INFO: String?
    let USER_AGENT: String?
    let MOD_DT: String?
    let MOD_USER_ID: String?
    let WRK_ORG_CD: String?
    let PLBM_CD: String?
    let PLBM_DTL_CTNT: String?
    let VISIT_FG: String?
    let ATTND_STS: String?
    let AREA_CD: Int
    let GENDER_NM: String?
    let DUTY_CD_NM: String?
    let PARTY_NM: String?
    let PSN_TP_NM: String?
    let PART_DUTY_NM: String?
    let FAM_REL_NM: String?
    let FAM_REL_SEQ: Int
    let PIC: String?
    
    init(
        PSN_ID: String?,
        PSN_NM: String?,
        CHUR_CD: String?,
        GENDER_CD: String?,
        PARTY_CD: String?,
        PSN_TP: String?,
        DUTY_CD: String?,
        PART_DUTY_CD: String?,
        SECT_CD: Int,
        ADDRESS: String?,
        HOME_PHONE: String?,
        MB_PHONE: String?,
        EMAIL: String?,
        BIRTH_DT: String?,
        REBRN_DT: String?,
        SCHOOL_CAREER: String?,
        JOB_NM: String?,
        GRD_CD: String?,
        FAM_REP_NM: String?,
        FAM_REL_CD: String?,
        GNN__ID: String?,
        MARR_YN: String?,
        SV_YN: String?,
        CURR_YN: String?,
        CONNECTED_BY: String?,
        RMK: String?,
        REG_DT: String?,
        REG_USER_ID: String?,
        GNC_INFO: String?,
        USER_AGENT: String?,
        MOD_DT: String?,
        MOD_USER_ID: String?,
        WRK_ORG_CD: String?,
        PLBM_CD: String?,
        PLBM_DTL_CTNT: String?,
        VISIT_FG: String?,
        ATTND_STS: String?,
        AREA_CD: Int,
        GENDER_NM: String?,
        DUTY_CD_NM: String?,
        PARTY_NM: String?,
        PSN_TP_NM: String?,
        PART_DUTY_NM: String?,
        FAM_REL_NM: String?,
        FAM_REL_SEQ: Int,
        PIC: String?
    ) {
        self.PSN_ID = PSN_ID
        self.PSN_NM = PSN_NM
        self.CHUR_CD = CHUR_CD
        self.GENDER_CD = GENDER_CD
        self.PARTY_CD = PARTY_CD
        self.PSN_TP = PSN_TP
        self.DUTY_CD = DUTY_CD
        self.PART_DUTY_CD = PART_DUTY_CD
        self.SECT_CD = SECT_CD
        self.ADDRESS = ADDRESS
        self.HOME_PHONE = HOME_PHONE
        self.MB_PHONE = MB_PHONE
        self.EMAIL = EMAIL
        self.BIRTH_DT = BIRTH_DT
        self.REBRN_DT = REBRN_DT
        self.SCHOOL_CAREER = SCHOOL_CAREER
        self.JOB_NM = JOB_NM
        self.GRD_CD = GRD_CD
        self.FAM_REP_NM = FAM_REP_NM
        self.FAM_REL_CD = FAM_REL_CD
        self.GNN__ID = GNN__ID
        self.MARR_YN = MARR_YN
        self.SV_YN = SV_YN
        self.CURR_YN = CURR_YN
        self.CONNECTED_BY = CONNECTED_BY
        self.RMK = RMK
        self.REG_DT = REG_DT
        self.REG_USER_ID = REG_USER_ID
        self.GNC_INFO = GNC_INFO
        self.USER_AGENT = USER_AGENT
        self.MOD_DT = MOD_DT
        self.MOD_USER_ID = MOD_USER_ID
        self.WRK_ORG_CD = WRK_ORG_CD
        self.PLBM_CD = PLBM_CD
        self.PLBM_DTL_CTNT = PLBM_DTL_CTNT
        self.VISIT_FG = VISIT_FG
        self.ATTND_STS = ATTND_STS
        self.AREA_CD = AREA_CD
        self.GENDER_NM = GENDER_NM
        self.DUTY_CD_NM = DUTY_CD_NM
        self.PARTY_NM = PARTY_NM
        self.PSN_TP_NM = PSN_TP_NM
        self.PART_DUTY_NM = PART_DUTY_NM
        self.FAM_REL_NM = FAM_REL_NM
        self.FAM_REL_SEQ = FAM_REL_SEQ
        self.PIC = PIC
    }
}
