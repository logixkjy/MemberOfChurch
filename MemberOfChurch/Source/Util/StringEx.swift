//
//  StringEx.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/17/25.
//

import Foundation

extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
