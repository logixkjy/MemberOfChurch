//
//  DataPrefix.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/15/25.
//

protocol DataPrefix: CaseIterable & Identifiable & Equatable & Hashable {
  var rawValue: String { get }
}
