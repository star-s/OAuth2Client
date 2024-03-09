//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation
import HttpClientUtilities

public extension CredentialProtocol where Self: AccessToken {
    func authorizer(request: URLRequest) async throws -> URLRequest {
        var request = request
        switch tokenType {
        case .bearer:
            request.headers.add(.authorization(bearerToken: accessToken))
        case .mac:
            // TODO: Implement mac authorization
            let timestamp = String(Int64(Date().timeIntervalSince1970))
            let nonce = String(UUID().uuidString.prefix(8))
            assertionFailure("Not yet implemented")
            break
        default:
            throw OAuth2ClientError.unknownTokenType
        }
        return request
    }
}

public extension RefreshableCredential where Self: AccessToken {
    var isRefreshable: Bool {
        refreshToken != nil
    }

    func refresh<C: OAuth2Client>(with client: C) async throws -> Self {
        guard let refreshToken else {
            throw OAuth2ClientError.tokenIsNotRefreshable
        }
        return try await client.refreshToken(refreshToken, additionalParameters: .void)
    }
}
