//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation

/// https://www.rfc-editor.org/rfc/rfc6749#section-5.1
open class AccessToken: Codable {
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope
    }

	public let accessToken: String
	public let tokenType: AccessTokenType
	public let refreshToken: String?
	public let expiresIn: TimeInterval?
	public let scope: String?

    public init(
        accessToken: String,
        tokenType: AccessTokenType,
        refreshToken: String? = nil,
        expiresIn: TimeInterval? = nil,
        scope: String? = nil
    ) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.scope = scope
    }

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(tokenType, forKey: .tokenType)
        try container.encodeIfPresent(refreshToken, forKey: .refreshToken)
        try container.encodeIfPresent(expiresIn, forKey: .expiresIn)
        try container.encodeIfPresent(scope, forKey: .scope)
    }

    // MARK: - Refreshable

    open func refresh<C: OAuth2Client>(with client: C) async throws -> Self {
        guard let refreshToken else {
            throw OAuth2ClientError.tokenIsNotRefreshable
        }
        return try await client.refreshToken(refreshToken, additionalParameters: .void)
    }

    // MARK: - CredentialProtocol

    open func authorizer(request: URLRequest) async throws -> URLRequest {
        guard tokenType == .bearer else {
            throw OAuth2ClientError.unsupportedTokenType
        }
        var request = request
        request.headers.add(.authorization(bearerToken: accessToken))
        return request
    }
}

extension AccessToken: Refreshable {}
extension AccessToken: CredentialProtocol {}
