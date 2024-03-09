//
//  CredentialsProtocol.swift
//  HttpClient
//
//  Created by Sergey Starukhin on 25.02.2024.
//

import Foundation
import HttpClientUtilities

public protocol CredentialProtocol: RequestAuthorizer {}

public protocol RefreshableCredential: CredentialProtocol, Refreshable {
    var isExpired: Bool { get }
    var isRefreshable: Bool { get }
}
