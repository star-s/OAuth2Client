//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.02.2024.
//

import Foundation

public enum OAuth2ClientError: Error {
    case wrongRedirectURL
    case stateMismatch
    case tokenIsNotRefreshable
    case unknownTokenType
}
