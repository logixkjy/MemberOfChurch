//
//  PhoneCode.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/15/25.
//

enum PhoneCode: String, CaseIterable, Equatable, Identifiable, Hashable {
    case one = "02"
    case two = "031"
    case three = "032"
    case four = "033"
    case five = "041"
    case six = "042"
    case seven = "043"
    case eight = "044"
    case nine = "051"
    case ten = "052"
    case eleven = "053"
    case twelve = "054"
    case thirteen = "055"
    case fourteen = "061"
    case fifteen = "062"
    case sixteen = "066"
    case seventeen = "070"
    
    var id: String { rawValue }
    
    static func find(_ value: String) -> PhoneCode {
        switch value {
        case "031": return .two
        case "032": return .three
        case "033": return .four
        case "041": return .five
        case "042": return .six
        case "043": return .seven
        case "044": return .eight
        case "051": return .nine
        case "052": return .ten
        case "053": return .eleven
        case "054": return .twelve
        case "055": return .thirteen
        case "061": return .fourteen
        case "062": return .fifteen
        case "066": return .sixteen
        case "070": return .seventeen
            
        default:
            return .one
        }
    }
}

extension PhoneCode: DataPrefix {}
