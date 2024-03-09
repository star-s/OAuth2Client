//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation
import HttpClient

public struct TokenWrapper<T: AccessToken>: Codable {

    public var expiresAt: Date {
        guard let expiresIn = token.expiresIn else {
            return .distantFuture
        }
        return createdAt.addingTimeInterval(expiresIn)
    }

    private let token: T
    private let createdAt: Date

    public init(token: T, createdAt: Date) {
        self.token = token
        self.createdAt = createdAt
    }
}

extension TokenWrapper: RefreshableCredential {
    public var isExpired: Bool {
        expiresAt <= Date()
    }

    public var isRefreshable: Bool {
        token.refreshToken != nil
    }

    public func refresh<C: OAuth2Client>(with client: C) async throws -> TokenWrapper<T> {
        guard let refreshToken = token.refreshToken else {
            throw OAuth2ClientError.tokenIsNotRefreshable
        }
        let newToken: T = try await client.refreshToken(refreshToken, additionalParameters: .void)
        return TokenWrapper(token: newToken, createdAt: Date())
    }

    public func authorizer(request: URLRequest) async throws -> URLRequest {
        try await token.authorizer(request: request)
    }
}
/*
public protocol _AccessTokenCredentialRepersentable {}

public extension _AccessTokenCredentialRepersentable  where Self: AccessToken {
    func asCredential(createdAt: Date = Date()) -> AccessTokenCredential<Self> {
        AccessTokenCredential(token: self, createdAt: createdAt)
    }
}

extension AccessToken: _AccessTokenCredentialRepersentable {}
*/
