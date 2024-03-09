//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation

public enum GrantType: String, Encodable {
    case authorizationCode = "authorization_code"
    case refreshToken = "refresh_token"
    case clientCredentials = "client_credentials"
    case password = "password"
}
