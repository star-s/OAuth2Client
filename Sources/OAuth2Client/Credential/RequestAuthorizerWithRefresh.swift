//
//  Refresher.swift
//  SwiftSample
//
//  Created by Sergey Starukhin on 24.02.2024.
//

import Foundation
import HttpClientUtilities

public actor RequestAuthorizerWithRefresh<S: CredentialStorageProtocol, C: OAuth2Client> where S.Credential: RefreshableCredential {
    private let credentialsStorage: S
    private let oauthClient: C

    private var task: Task<S.Credential?, Error>?

    public init(storage: S, client: C) {
        self.credentialsStorage = storage
        self.oauthClient = client
    }

    private func getCredentials() async throws -> S.Credential? {
        if let task {
            return try await task.value
        }
        let task = Task<S.Credential?, Error> {
            try await credentialsStorage.modify { credentials in
                guard let token = credentials else {
                    return nil
                }
                guard token.isExpired else {
                    return token
                }
                guard token.isRefreshable else {
                    return nil
                }
                let newToken = try await token.refresh(with: self.oauthClient)
                credentials = newToken
                return newToken
            }
        }
        self.task = task
        defer {
            self.task = nil
        }
        return try await task.value
    }
}

extension RequestAuthorizerWithRefresh: RequestAuthorizer {
    public func authorizer(request: URLRequest) async throws -> URLRequest {
        try await getCredentials()?.authorizer(request: request) ?? request
    }
}
