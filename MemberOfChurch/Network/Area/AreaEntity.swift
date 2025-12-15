//
//  AreaEntity.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/1/25.
//

struct AreaListEntity: Decodable, Equatable {
    let list: Array<AreaEntity>?
}

struct AreaEntity: Decodable, Equatable {
    let AREA_NM: String?
    let AREA_SECT_NM: String?
    let AREA_CD: Int
    let SECT_CD: Int
    let SECT_PSN_ID: String?
    let SECT_PSN_NM: String?
    let SECT_DUTY_NM: String?
    let SECT_PSN_EMAIL: String?
    let SECT_PSN_MB_PHONE: String?
    let SECT_PIC: String?
    let SECT_WIF_PSN_ID: String?
    let SECT_PSN_WIF_NM: String?
    let SECT_WIF_DUTY_NM: String?
    let SECT_PSN_WIF_EMAIL: String?
    let SECT_PSN_WIF_MB_PHONE: String?
    let SECT_WIF_PIC: String?
    let TOTAL_CNT: Int
    let CNT1: Int
    let CNT2: Int
    let CNT3: Int
    let CNT4: Int
    let CNT5: Int
    
    init(
        AREA_NM: String? = nil,
        AREA_SECT_NM: String? = nil,
        AREA_CD: Int = 0,
        SECT_CD: Int = 0,
        SECT_PSN_ID: String? = nil,
        SECT_PSN_NM: String? = nil,
        SECT_DUTY_NM: String? = nil,
        SECT_PSN_EMAIL: String? = nil,
        SECT_PSN_MB_PHONE: String? = nil,
        SECT_PIC: String? = nil,
        SECT_WIF_PSN_ID: String? = nil,
        SECT_PSN_WIF_NM: String? = nil,
        SECT_WIF_DUTY_NM: String? = nil,
        SECT_PSN_WIF_EMAIL: String? = nil,
        SECT_PSN_WIF_MB_PHONE: String? = nil,
        SECT_WIF_PIC: String? = nil,
        TOTAL_CNT: Int = 0,
        CNT1: Int = 0,
        CNT2: Int = 0,
        CNT3: Int = 0,
        CNT4: Int = 0,
        CNT5: Int = 0
    ) {
        self.AREA_NM = AREA_NM
        self.AREA_SECT_NM = AREA_SECT_NM
        self.AREA_CD = AREA_CD
        self.SECT_CD = SECT_CD
        self.SECT_PSN_ID = SECT_PSN_ID
        self.SECT_PSN_NM = SECT_PSN_NM
        self.SECT_DUTY_NM = SECT_DUTY_NM
        self.SECT_PSN_EMAIL = SECT_PSN_EMAIL
        self.SECT_PSN_MB_PHONE = SECT_PSN_MB_PHONE
        self.SECT_PIC = SECT_PIC
        self.SECT_WIF_PSN_ID = SECT_WIF_PSN_ID
        self.SECT_PSN_WIF_NM = SECT_PSN_WIF_NM
        self.SECT_WIF_DUTY_NM = SECT_WIF_DUTY_NM
        self.SECT_PSN_WIF_EMAIL = SECT_PSN_WIF_EMAIL
        self.SECT_PSN_WIF_MB_PHONE = SECT_PSN_WIF_MB_PHONE
        self.SECT_WIF_PIC = SECT_WIF_PIC
        self.TOTAL_CNT = TOTAL_CNT
        self.CNT1 = CNT1
        self.CNT2 = CNT2
        self.CNT3 = CNT3
        self.CNT4 = CNT4
        self.CNT5 = CNT5
    }
}

struct SectListEntity: Decodable, Equatable {
    let list: Array<Array<SectEntity>>?
    let TOTAL_CNT: Int
    let CNT1: Int
    let CNT2: Int
    let CNT3: Int
    let CNT4: Int
    let CNT5: Int
    
    init(
        list: Array<Array<SectEntity>>? = nil,
        TOTAL_CNT: Int = 0,
        CNT1: Int = 0,
        CNT2: Int = 0,
        CNT3: Int = 0,
        CNT4: Int = 0,
        CNT5: Int = 0
    ) {
        self.list = list
        self.TOTAL_CNT = TOTAL_CNT
        self.CNT1 = CNT1
        self.CNT2 = CNT2
        self.CNT3 = CNT3
        self.CNT4 = CNT4
        self.CNT5 = CNT5
    }
}

struct SectEntity: Decodable, Equatable {
    let SECT_CD: Int
    let AREA_CD: Int
    let PSN_ID: String?
    let PSN_NM: String?
    let DUTY_NM: String?
    let MB_PHONE: String?
    let EMAIL: String?
    let PSN_TP: String?
    let PSN_TP_NM: String?
    let FAM_REP_NM: String?
    let FAM_REL_CD: String?
    let FAM_REL_NM: String?
    let FAM_REL_SEQ: Int
    let PIC: String?
    let SORT_SEQ: Int
    
    init(
        SECT_CD: Int = 0,
        AREA_CD: Int = 0,
        PSN_ID: String? = nil,
        PSN_NM: String? = nil,
        DUTY_NM: String? = nil,
        MB_PHONE: String? = nil,
        EMAIL: String? = nil,
        PSN_TP: String? = nil,
        PSN_TP_NM: String? = nil,
        FAM_REP_NM: String? = nil,
        FAM_REL_CD: String? = nil,
        FAM_REL_NM: String? = nil,
        FAM_REL_SEQ: Int = 0,
        PIC: String? = nil,
        SORT_SEQ: Int = 0
    ) {
        self.SECT_CD = SECT_CD
        self.AREA_CD = AREA_CD
        self.PSN_ID = PSN_ID
        self.PSN_NM = PSN_NM
        self.DUTY_NM = DUTY_NM
        self.MB_PHONE = MB_PHONE
        self.EMAIL = EMAIL
        self.PSN_TP = PSN_TP
        self.PSN_TP_NM = PSN_TP_NM
        self.FAM_REP_NM = FAM_REP_NM
        self.FAM_REL_CD = FAM_REL_CD
        self.FAM_REL_NM = FAM_REL_NM
        self.FAM_REL_SEQ = FAM_REL_SEQ
        self.PIC = PIC
        self.SORT_SEQ = SORT_SEQ
    }
}

struct ChurchListEntity: Decodable, Equatable {
    let SECT_LIST: Array<ChurSectEntity>?
    let CHUR_LIST: Array<ChurchEntity>?
}

struct ChurSectEntity: Decodable, Equatable, Hashable {
    let CHUR_CD: String?
    let AREA_CD: Int
    let SECT_CD: Int
    let SECT_PSN_NM: String?
    let SECT_SUB_NM: String?
    let RMK: String?
    let SECT_PSN_WIF_NM: String?
    let SECT_SUB_WIF_NM: String?
    
    init(
        CHUR_CD: String? = nil,
        AREA_CD: Int = 0,
        SECT_CD: Int = 0,
        SECT_PSN_NM: String? = nil,
        SECT_SUB_NM: String? = nil,
        RMK: String? = nil,
        SECT_PSN_WIF_NM: String? = nil,
        SECT_SUB_WIF_NM: String? = nil
    ) {
        self.CHUR_CD = CHUR_CD
        self.AREA_CD = AREA_CD
        self.SECT_CD = SECT_CD
        self.SECT_PSN_NM = SECT_PSN_NM
        self.SECT_SUB_NM = SECT_SUB_NM
        self.RMK = RMK
        self.SECT_PSN_WIF_NM = SECT_PSN_WIF_NM
        self.SECT_SUB_WIF_NM = SECT_SUB_WIF_NM
    }
}

struct ChurchEntity: Decodable, Equatable, Hashable {
    let CHUR_CD: String?
    let CHUR_NM: String?
    let ENG_CHUR_NM: String?
    let ZIP_NO: String?
    let ADDR: String?
    let NEW_ADDR: String?
    let ENG_ADDR: String?
    let HM_PHONE_NO: String?
    let PHONE_NO: String?
    let PHONE_NO2: String?
    let FAX_NO: String?
    let AREA_NO: Int
    let SECT_NO: Int
    let SEQ: Int
    let EST_DT: String?
    let CLS_DT: String?
    let ETC: String?
    let NATION_CD: String?
    let IYF_AREA_CD: String?
    let ORG_TP: String?
    let TIME_DIFF: String?
    let REG_DT: String?
    let REG_ID: String?
    let UPDT_DT: String?
    let UPDT_ID: String?
    let LATITUDE: Double?
    let LONGITUDE: Double?
    let WEB_MEMO: String?
    let REGION_NM: String?
    let CHUR_TP: String?
    
    init(
        CHUR_CD: String? = nil,
        CHUR_NM: String? = nil,
        ENG_CHUR_NM: String? = nil,
        ZIP_NO: String? = nil,
        ADDR: String? = nil,
        NEW_ADDR: String? = nil,
        ENG_ADDR: String? = nil,
        HM_PHONE_NO: String? = nil,
        PHONE_NO: String? = nil,
        PHONE_NO2: String? = nil,
        FAX_NO: String? = nil,
        AREA_NO: Int = 0,
        SECT_NO: Int = 0,
        SEQ: Int = 0,
        EST_DT: String? = nil,
        CLS_DT: String? = nil,
        ETC: String? = nil,
        NATION_CD: String? = nil,
        IYF_AREA_CD: String? = nil,
        ORG_TP: String? = nil,
        TIME_DIFF: String? = nil,
        REG_DT: String? = nil,
        REG_ID: String? = nil,
        UPDT_DT: String? = nil,
        UPDT_ID: String? = nil,
        LATITUDE: Double? = nil,
        LONGITUDE: Double? = nil,
        WEB_MEMO: String? = nil,
        REGION_NM: String? = nil,
        CHUR_TP: String? = nil
    ) {
        self.CHUR_CD = CHUR_CD
        self.CHUR_NM = CHUR_NM
        self.ENG_CHUR_NM = ENG_CHUR_NM
        self.ZIP_NO = ZIP_NO
        self.ADDR = ADDR
        self.NEW_ADDR = NEW_ADDR
        self.ENG_ADDR = ENG_ADDR
        self.HM_PHONE_NO = HM_PHONE_NO
        self.PHONE_NO = PHONE_NO
        self.PHONE_NO2 = PHONE_NO2
        self.FAX_NO = FAX_NO
        self.AREA_NO = AREA_NO
        self.SECT_NO = SECT_NO
        self.SEQ = SEQ
        self.EST_DT = EST_DT
        self.CLS_DT = CLS_DT
        self.ETC = ETC
        self.NATION_CD = NATION_CD
        self.IYF_AREA_CD = IYF_AREA_CD
        self.ORG_TP = ORG_TP
        self.TIME_DIFF = TIME_DIFF
        self.REG_DT = REG_DT
        self.REG_ID = REG_ID
        self.UPDT_DT = UPDT_DT
        self.UPDT_ID = UPDT_ID
        self.LATITUDE = LATITUDE
        self.LONGITUDE = LONGITUDE
        self.WEB_MEMO = WEB_MEMO
        self.REGION_NM = REGION_NM
        self.CHUR_TP = CHUR_TP
    }
}
