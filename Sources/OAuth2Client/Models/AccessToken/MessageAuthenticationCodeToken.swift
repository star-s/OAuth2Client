//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

/// Message Authentication Code (MAC) Token
/// https://datatracker.ietf.org/doc/draft-ietf-oauth-v2-http-mac
open class MessageAuthenticationCodeToken: AccessToken {

    // ???: Associated Builder?
    
    public enum Algorithm: String, Codable {
        case hmacSha1 = "hmac-sha-1"
        case hmacSha256 = "hmac-sha-256"
    }

    private enum CodingKeys: String, CodingKey {
        case kid = "kid"
        case macKey = "mac_key"
        case macAlgorithm = "mac_algorithm"
    }

    public let kid: String
    public let macKey: String
    public let macAlgorithm: Algorithm

    public init(
        accessToken: String,
        tokenType: AccessTokenType,
        refreshToken: String? = nil,
        expiresIn: TimeInterval? = nil,
        scope: String? = nil,
        kid: String,
        macKey: String,
        macAlgorithm: Algorithm
    ) {
        self.kid = kid
        self.macKey = macKey
        self.macAlgorithm = macAlgorithm
        super.init(
            accessToken: accessToken,
            tokenType: tokenType,
            refreshToken: refreshToken,
            expiresIn: expiresIn,
            scope: scope
        )
    }
    
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        kid = try container.decode(String.self, forKey: .kid)
        macKey = try container.decode(String.self, forKey: .macKey)
        macAlgorithm = try container.decode(Algorithm.self, forKey: .macAlgorithm)
        try super.init(from: decoder)
    }

    open override func encode(to encoder: any Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kid, forKey: .kid)
        try container.encode(macKey, forKey: .macKey)
        try container.encode(macAlgorithm, forKey: .macAlgorithm)
    }
}
