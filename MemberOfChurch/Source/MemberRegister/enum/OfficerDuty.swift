//
//  OfficerDuty.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/15/25.
//

enum OfficerDuty: String, CaseIterable, Equatable, Identifiable, Hashable {
    case eleven = "장년회장"
    case twelve = "장년회 부회장"
    case thirteen = "장년회 회계"
    case twentyOne = "부인회장"
    case twentyTwo = "부인회 부회장"
    case twentyThree = "부인회 회계"
    case twentyFour = "부인회 전도부"
    case twentyFive = "부인회 봉사부"
    case NONE = ""
    
    var id: String { rawValue }
    
    var tag: String {
        switch self {
        case .eleven: return "11"
        case .twelve: return "12"
        case .thirteen: return "13"
        case .twentyOne: return "21"
        case .twentyTwo: return "22"
        case .twentyThree: return "23"
        case .twentyFour: return "24"
        case .twentyFive: return "25"
        case .NONE: return ""
        }
    }
    
    static func find(_ tag: String) -> OfficerDuty {
        switch tag {
        case "11": return .eleven
        case "12": return .twelve
        case "13": return .thirteen
        case "21": return .twentyOne
        case "22": return .twentyTwo
        case "23": return .twentyThree
        case "24": return .twentyFour
        case "25": return .twentyFive
        default: return .NONE
        }
    }
}

extension OfficerDuty: DataPrefix {}
