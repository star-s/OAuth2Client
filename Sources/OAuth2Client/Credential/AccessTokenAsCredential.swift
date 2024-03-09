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
            guard let macToken = self as? MessageAuthenticationCodeToken else {
                throw OAuth2ClientError.unsupportedTokenType
            }
            let builder = MacAuthorizationBuilder(
                request: request,
                keyId: macToken.kid,
                messageDigestAlgorithm: macToken.macAlgorithm,
                timestamp: Date(),
                sequenceNumber: nil,
                accessToken: macToken.accessToken,
                channelBinding: nil,
                h: request.url?.host
            )
            request.headers.add(.authorization(builder.authorizationString))
        default:
            throw OAuth2ClientError.unsupportedTokenType
        }
        return request
    }
}
