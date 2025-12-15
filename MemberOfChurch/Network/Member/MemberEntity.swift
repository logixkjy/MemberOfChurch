//
//  MemberEntity.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/26/25.
//

struct MemberListEntity: Decodable, Equatable {
    let list: Array<MemberEntity>?
}

struct MemberEntity: Decodable, Equatable {
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
    let DUTY_NM: String?
    let PARTY_NM: String?
    let PSN_TP_NM: String?
    let PART_DUTY_NM: String?
    let FAM_REL_NM: String?
    let PIC: String?
}
