//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

public extension Refreshable where Self: AccessToken {
    func refresh<C: OAuth2Client>(with client: C) async throws -> Self {
        guard let refreshToken else {
            throw OAuth2ClientError.tokenIsNotRefreshable
        }
        return try await client.refreshToken(refreshToken, additionalParameters: .void)
    }
}

extension AccessToken: Refreshable {}
