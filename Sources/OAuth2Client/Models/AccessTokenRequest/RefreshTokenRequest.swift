//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation

public struct RefreshTokenRequest {
    private let grantType: GrantType = .refreshToken
    private let refreshToken: String
    private let scope: String?

    public init(refreshToken: String, scope: String? = nil) {
        self.refreshToken = refreshToken
        self.scope = scope
    }
}

extension RefreshTokenRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case refreshToken = "refresh_token"
        case scope
    }
}
