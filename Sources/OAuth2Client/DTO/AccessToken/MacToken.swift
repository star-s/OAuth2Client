//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation
import CryptoKit

/// Message Authentication Code (MAC) Token
/// https://datatracker.ietf.org/doc/draft-ietf-oauth-v2-http-mac
open class MacToken: AccessToken {

    public enum Error: Swift.Error {
        case unknownAlgorithm
    }

    private enum CodingKeys: String, CodingKey {
        case kid = "kid"
        case macKey = "mac_key"
        case macAlgorithm = "mac_algorithm"
    }

    public let kid: String?
    public let macKey: String
    public let macAlgorithm: Algorithm

    public init(
        accessToken: String,
        tokenType: TokenType,
        refreshToken: String? = nil,
        expiresIn: TimeInterval? = nil,
        scope: String? = nil,
        kid: String? = nil,
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

    // MARK: - CredentialProtocol

    open override func authorizer(request: URLRequest) async throws -> URLRequest {
        guard tokenType == .mac else {
            return try await super.authorizer(request: request)
        }
        var request = request
        let builder = try Self.makeAuthorizationBuilder(for: request, token: self)
        request.headers.add(.authorization(builder.authorization))
        return request
    }

    open class func makeAuthorizationBuilder(for request: URLRequest, token: MacToken) throws -> AuthorizationBuilder {
        guard let macFunction = token.macAlgorithm.macFunction(key: token.macKey) else {
            throw Error.unknownAlgorithm
        }
        return MacBuilder(
            request: request,
            keyId: token.kid ?? token.accessToken,
            nonce: Data(AES.GCM.Nonce()).base64EncodedString(),
            macFunction: macFunction
        )
    }
}

extension MacToken {
    public struct Algorithm: RawRepresentable, ExpressibleByStringLiteral, Hashable, Codable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue.lowercased()
        }

        public init(stringLiteral value: StaticString) {
            rawValue = String(describing: value).lowercased()
        }

        public init(from decoder: Decoder) throws {
            rawValue = try decoder.singleValueContainer().decode(String.self).lowercased()
        }

        public static let hmacSha1: Algorithm   = "hmac-sha-1"
        public static let hmacSha256: Algorithm = "hmac-sha-256"
    }
}

extension MacToken.Algorithm {

    public static func mac<T: HashFunction>(_ type: T.Type, key: String, message: String) -> String {
        let secret = Data(key.utf8)
        let data = Data(message.utf8)
        var hmac = HMAC<T>(key: SymmetricKey(data: secret))
        hmac.update(data: data)
        let mac = Data(hmac.finalize())
        return mac.base64EncodedString()
    }

    public func macFunction(key: String) -> ((_ message: String) -> String)? {
        switch self {
        case .hmacSha1:
            return {
                Self.mac(Insecure.SHA1.self, key: key, message: $0)
            }
        case .hmacSha256:
            return {
                Self.mac(SHA256.self, key: key, message: $0)
            }
        default:
            return nil
        }
    }
}
