//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation
import HttpClientUtilities

public extension OAuth2ClientImplementation {

    // MARK: Obtain access token

    func accessToken<T: AccessToken>(
        code: String,
        additionalParameters: AdditionalParams
    ) async throws -> T {
        let request = AuthorizationCodeGrantRequest(code: code, clientId: clientID, redirectURI: callbackURL)
        return try await post(tokenEndpoint, parameters: request.join(with: additionalParameters))
    }

    func accessToken<T: AccessToken>(
        clientSecret: String?,
        additionalParameters: AdditionalParams
    ) async throws -> T {
        let request = ClientCredentialsGrantRequest(scope: scope)
            .joinIfPresent(value: clientSecret.map({ ClientCredentials(id: clientID, secret: $0) }))
            .join(with: additionalParameters)
        return try await post(tokenEndpoint, parameters: request)
    }

    func accessToken<T: AccessToken>(
        username: String,
        password: String,
        additionalParameters: AdditionalParams
    ) async throws -> T {
        let request = PasswordGrantRequest(username: username, password: password, scope: scope)
        return try await post(tokenEndpoint, parameters: request.join(with: additionalParameters))
    }

    // MARK: Refresh acces token

    func refreshToken<T: AccessToken>(
        _ refreshToken: String,
        additionalParameters: AdditionalParams
    ) async throws -> T {
        let request = RefreshTokenRequest(refreshToken: refreshToken, scope: scope)
        return try await post(tokenEndpoint, parameters: request.join(with: additionalParameters))
    }
}
