//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.12.2022.
//

import Foundation

/// https://www.rfc-editor.org/rfc/rfc6749#section-7.1
public struct AccessTokenType: RawRepresentable, ExpressibleByStringLiteral, Hashable, Codable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue.lowercased()
	}

	public init(stringLiteral value: String) {
		self.rawValue = value.lowercased()
	}

	public init(from decoder: Decoder) throws {
		self.rawValue = try decoder.singleValueContainer().decode(String.self).lowercased()
	}
}

public extension AccessTokenType {
    static let bearer: AccessTokenType  = "bearer"
    static let mac: AccessTokenType     = "mac"
}
