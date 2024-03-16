//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.03.2024.
//

import Foundation

extension MacBuilder {

    public struct Attribute: RawRepresentable, ExpressibleByStringLiteral, Hashable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public static let id:          Attribute = "id"
        public static let ts:          Attribute = "ts"
        public static let nonce:       Attribute = "nonce"
        public static let ext:         Attribute = "ext"
        public static let mac:         Attribute = "mac"

        public static let kid:         Attribute = "kid"
        public static let seqNr:       Attribute = "seq-nr"
        public static let accessToken: Attribute = "access_token"
        public static let h:           Attribute = "h"
        public static let cb:          Attribute = "cb"
    }
}
