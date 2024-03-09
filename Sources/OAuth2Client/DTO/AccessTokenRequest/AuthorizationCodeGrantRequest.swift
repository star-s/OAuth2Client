//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation

public struct AuthorizationCodeGrantRequest {
    private let grantType: GrantType = .authorizationCode
    private let code: String
    private let clientId: String?
    private let redirectURI: URL

    public init(code: String, clientId: String?, redirectURI: URL) {
        self.code = code
        self.clientId = clientId
        self.redirectURI = redirectURI
    }
}

extension AuthorizationCodeGrantRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case code
        case clientId = "client_id"
        case redirectURI = "redirect_uri"
    }
}
