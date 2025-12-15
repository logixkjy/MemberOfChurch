//
//  DateFormatterEx.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/17/25.
//

import Foundation

enum DateDisplayFormat {
  case dash      // "yyyy-MM-dd"
  case korean    // "yyyy년 MM월 dd일"
}

extension DateFormatter {
  static let ymdDash: DateFormatter = {
    let f = DateFormatter()
    f.calendar = Calendar(identifier: .gregorian)
    f.locale = Locale(identifier: "ko_KR")
    f.timeZone = .current
    f.dateFormat = "yyyy-MM-dd"
    return f
  }()

  static let ymdKorean: DateFormatter = {
    let f = DateFormatter()
    f.calendar = Calendar(identifier: .gregorian)
    f.locale = Locale(identifier: "ko_KR")
    f.timeZone = .current
    f.dateFormat = "yyyy년 MM월 dd일"
    return f
  }()
}
