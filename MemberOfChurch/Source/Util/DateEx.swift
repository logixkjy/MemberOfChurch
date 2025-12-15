//
//  DateEx.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/17/25.
//

import Foundation

extension Date {
    func toString(format: String = "yyyy년 MM월 dd일") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
