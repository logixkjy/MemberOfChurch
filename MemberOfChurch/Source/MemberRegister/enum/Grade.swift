//
//  Grade.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/15/25.
//

enum Grade: String, CaseIterable, Equatable, Identifiable, Hashable {
    case E1 = "초등1"
    case E2 = "초등2"
    case E3 = "초등3"
    case E4 = "초등4"
    case E5 = "초등5"
    case E6 = "초등6"
    case M1 = "중1"
    case M2 = "중2"
    case M3 = "중3"
    case H1 = "고1"
    case H2 = "고2"
    case H3 = "고3"
    case C1 = "대학1"
    case C2 = "대학2"
    case C3 = "대학3"
    case C4 = "대학4"
    case VC = "휴학중"
    case NONE = ""
    
    var id: String { rawValue }
    
    var tag: String {
        switch self {
        case .E1: return "E1"
        case .E2: return "E2"
        case .E3: return "E3"
        case .E4: return "E4"
        case .E5: return "E5"
        case .E6: return "E6"
        case .M1: return "M1"
        case .M2: return "M2"
        case .M3: return "M3"
        case .H1: return "H1"
        case .H2: return "H2"
        case .H3: return "H3"
        case .C1: return "C1"
        case .C2: return "C2"
        case .C3: return "C3"
        case .C4: return "C4"
        case .VC: return "VC"
        case .NONE: return ""
        }
    }
    
    static func find(_ tag: String) -> Grade {
        switch tag {
        case "E1": return .E1
        case "E2": return .E2
        case "E3": return .E3
        case "E4": return .E4
        case "E5": return .E5
        case "E6": return .E6
        case "M1": return .M1
        case "M2": return .M2
        case "M3": return .M3
        case "H1": return .H1
        case "H2": return .H2
        case "H3": return .H3
        case "C1": return .C1
        case "C2": return .C2
        case "C3": return .C3
        case "C4": return .C4
        case "VC": return .VC
        default: return .NONE
        }
    }
}

extension Grade: DataPrefix {}
