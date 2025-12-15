//
//  Duty.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/15/25.
//

enum Duty: String, CaseIterable, Equatable, Identifiable, Hashable {
    case SNT = "평신도"
    case DCN = "집사"
    case ELD = "장로"
    case PST = "사역자"
    case NONE = ""
    
    var id: String { rawValue }
    
    var tag: String {
        switch self {
        case .SNT: return "SNT"
        case .DCN: return "DCN"
        case .ELD: return "ELD"
        case .PST: return "PST"
        case .NONE: return ""
        }
    }
    
    static func find(_ tag: String) -> Duty {
        switch tag {
        case "SNT": return .SNT
        case "DCN": return .DCN
        case "ELD": return .ELD
        case "PST": return .PST
        default: return .NONE
        }
    }
}

extension Duty: DataPrefix {}
