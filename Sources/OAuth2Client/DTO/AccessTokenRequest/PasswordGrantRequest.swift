//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation

public struct PasswordGrantRequest {
    private let grantType: GrantType = .password
    private let username: String
    private let password: String
    private let scope: String?

    public init(username: String, password: String, scope: String? = nil) {
        self.username = username
        self.password = password
        self.scope = scope
    }
}

extension PasswordGrantRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case username
        case password
        case scope
    }
}
