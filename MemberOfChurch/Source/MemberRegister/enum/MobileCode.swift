//
//  MobileCode.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/15/25.
//

enum MobileCode: String, CaseIterable, Equatable, Identifiable, Hashable {
    case zero = "010"
    case one = "011"
    case six = "016"
    case seven = "017"
    case eight = "018"
    case nine = "019"
    
    var id: String { rawValue }
    
    static func find(_ value: String) -> MobileCode {
        switch value {
        case "011": return .one
        case "016": return .six
        case "017": return .seven
        case "018": return .eight
        case "019": return .nine
            
        default:
            return .zero
        }
    }
}

extension MobileCode: DataPrefix {}
