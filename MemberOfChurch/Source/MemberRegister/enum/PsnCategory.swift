//
//  PsnCategory.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/15/25.
//

enum PsnCategory: String, CaseIterable, Equatable, Identifiable, Hashable {
    case zero = "사역자"
    case nine = "사모"
    case one = "장년"
    case two = "부인"
    case three = "청년남"
    case four = "청년여"
    case five = "학생남"
    case six = "학생여"
    case seven = "초등생"
    case eight = "유치부"
    case AA = "노인남"
    case BB = "노인여"
    case TT = "대학남/청년1"
    case UU = "대학녀/청년2"
    case NONE = ""
    
    var id: String { rawValue }
    
    var tag: String {
        switch self {
        case .zero: return "0"
        case .nine: return "9"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .AA: return "A"
        case .BB: return "B"
        case .TT: return "T"
        case .UU: return "U"
        case .NONE: return ""
        }
    }
    
    static func find(_ tag: String) -> PsnCategory {
        switch tag {
        case "0": return .zero
        case "9": return .nine
        case "1": return .one
        case "2": return .two
        case "3": return .three
        case "4": return .four
        case "5": return .five
        case "6": return .six
        case "7": return .seven
        case "8": return .eight
        case "A": return .AA
        case "B": return .BB
        case "T": return .TT
        case "U": return .UU
        default: return .NONE
        }
    }
}

extension PsnCategory: DataPrefix {}
