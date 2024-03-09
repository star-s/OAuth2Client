//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

public protocol RefreshableCredential: CredentialProtocol, Refreshable {
    var isExpired: Bool { get }
    var isRefreshable: Bool { get }
}
