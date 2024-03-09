//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 08.03.2024.
//

import Foundation
import HttpClientUtilities

public protocol CredentialStorageProtocol {
    associatedtype Credential: CredentialProtocol

    func get() async -> Credential?
    func modify<T>(_ closure: @escaping (inout Credential?) async throws -> T) async rethrows -> T
}

extension RequestAuthorizer where Self: CredentialStorageProtocol {
    func authorizer(request: URLRequest) async throws -> URLRequest {
        try await get()?.authorizer(request: request) ?? request
    }
}
