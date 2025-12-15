//
//  FamRelation.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/15/25.
//

enum FamRelation: String, CaseIterable, Equatable, Identifiable, Hashable {
    case SELF = "본인"
    case FA = "부"
    case MO = "모"
    case HUS = "남편"
    case WIF = "처"
    case SON = "자"
    case DTR = "녀"
    case ETC = "기타(동거인)"
    case NONE = ""
    
    var id: String { rawValue }
    
    var tag: String {
        switch self {
        case .SELF: return "SELF"
        case .FA: return "FA"
        case .MO: return "MO"
        case .HUS: return "HUS"
        case .WIF: return "WIF"
        case .SON: return "SON"
        case .DTR: return "DTR"
        case .ETC: return "ETC"
        case .NONE: return ""
        }
    }
    
    static func find(_ tag: String) -> FamRelation {
        switch tag {
        case "SELF": return .SELF
        case "FA": return .FA
        case "MO": return .MO
        case "HUS": return .HUS
        case "WIF": return .WIF
        case "SON": return .SON
        case "DTR": return .DTR
        case "ETC": return .ETC
        default: return .NONE
        }
    }
}

extension FamRelation: DataPrefix {}
