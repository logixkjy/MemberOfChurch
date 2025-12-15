//
//  TermWorker.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/15/25.
//

enum TermWorker: String, CaseIterable, Equatable, Identifiable, Hashable {
    case one = "국제청소년연합"
    case two = "굿뉴스 의료봉사회"
    case three = "기쁜소식사"
    case four = "드래곤플라이"
    case five = "마하나임바이블트레이닝센터"
    case six = "선교회총회"
    case seven = "영상선교부"
    case eight = "음향선교부"
    case nine = "인터넷선교부"
    case ten = "임마누엘"
    case eleven = "주간기쁜소식"
    case twoelve = "투머로우"
    case NONE = ""
    
    var id: String { rawValue }
    
    var tag: String {
        switch self {
        case .one: return "190122"
        case .two: return "190162"
        case .three: return "190105"
        case .four: return "190127"
        case .five: return "190163"
        case .six: return "190133"
        case .seven: return "190114"
        case .eight: return "190115"
        case .nine: return "190120"
        case .ten: return "190107"
        case .eleven: return "190135"
        case .twoelve: return "190125"
        case .NONE: return ""
        }
    }
    
    static func find(_ tag: String) -> TermWorker {
        switch tag {
        case "190122": return .one
        case "190162": return .two
        case "190105": return .three
        case "190127": return .four
        case "190163": return .five
        case "190133": return .six
        case "190114": return .seven
        case "190115": return .eight
        case "190120": return .nine
        case "190107": return .ten
        case "190135": return .eleven
        case "190125": return .twoelve
        default: return .NONE
        }
    }
}

extension TermWorker: DataPrefix {}
