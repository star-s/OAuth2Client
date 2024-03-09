//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation

public struct ClientCredentialsGrantRequest {
    private let grantType: GrantType = .clientCredentials
    private let scope: String?

    public init(scope: String? = nil) {
        self.scope = scope
    }
}

extension ClientCredentialsGrantRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case scope
    }
}
