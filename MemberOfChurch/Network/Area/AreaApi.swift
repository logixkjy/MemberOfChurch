//
//  AreaApi.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/1/25.
//

enum AreaApi: String {
    case areaList = "/sect_list_json"
    case sectList = "/sect_list_json/SECT/%@"
    case churSectList = "/SECT_LIST"
}
// http://www.goodnews.or.kr/chMember/mApi/process?mode=login&GNN_ID=onse7282&PASSWD=wert1234
// http://www.goodnews.or.kr/chMember/mApi/sect_list_json
// http://www.goodnews.or.kr/chMember/mApi/sect_list_json/SECT/1
// http://www.goodnews.or.kr/chMember/mApi/SECT_LIST


