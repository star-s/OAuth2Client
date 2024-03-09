//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.02.2024.
//

import Foundation

struct StateWrapper<T> {
    public let value: T
    public let state: String

    public init(_ value: T, state: String) {
        self.value = value
        self.state = state
    }
}

private enum CodingKeys: String, CodingKey {
    case state
}

extension StateWrapper: Decodable where T: Decodable {
    init(from decoder: Decoder) throws {
        value = try T.init(from: decoder)
        state = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .state)
    }
}

extension StateWrapper: Encodable where T: Encodable {
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(state, forKey: .state)
    }
}
