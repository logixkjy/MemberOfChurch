//
//  LoginEntity.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/22/25.
//

struct LoginEntity: Decodable, Equatable {
    let state: String?
    let role: String?
    let MB_PHONE: String?
    let CHUR_CD: String?
    let CHUR_NM: String?
    @FlexibleInt var AREA_CD: Int
    @FlexibleInt var SECT_CD: Int
    @FlexibleInt var MemberCnt: Int
    let REG_USER_ID: String?
    let MOD_USER_ID: String?
}
