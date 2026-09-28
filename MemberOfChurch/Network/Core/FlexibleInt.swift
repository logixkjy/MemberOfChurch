//
//  FlexibleInt.swift
//  MemberOfChurch
//
//  Created by Codex on 9/28/26.
//

import Foundation

@propertyWrapper
struct FlexibleInt: Decodable, Equatable, Hashable {
    var wrappedValue: Int

    init(wrappedValue: Int = 0) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            wrappedValue = 0
            return
        }

        if let intValue = try? container.decode(Int.self) {
            wrappedValue = intValue
            return
        }

        if let stringValue = try? container.decode(String.self) {
            let trimmedValue = stringValue.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmedValue.isEmpty {
                wrappedValue = 0
                return
            }

            if let intValue = Int(trimmedValue) {
                wrappedValue = intValue
                return
            }
        }

        throw DecodingError.typeMismatch(
            Int.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected to decode Int or numeric String."
            )
        )
    }
}
