//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation
import HttpClientUtilities
import URLEncodedForm

public extension OAuth2ClientImplementation {

    // MARK: Prepare URL

    func prepareAuthorizationURL(flow: OAuth2Flow, state: String?) throws -> URL {
        let request = AuthorizationRequest(
            type: flow.responseType,
            clientID: clientID,
            redirectURL: callbackURL,
            scope: scope
        )
        let encoder = URLQueryEncoder(arrayEncoding: .noBrackets)

        let query: String
        if let state {
            query = try encoder.encode(StateWrapper(request, state: state))
        } else {
            query = try encoder.encode(request)
        }
        return try makeURL(from: authorizationEndpoint).appendingQuery(query)
    }

    // MARK: Decode redirect URL

    /// https://www.rfc-editor.org/rfc/rfc6749#section-4.1
    /// 4.1.  Authorization Code Grant
    func decodeAuthorizationCode(redirect: URL, state: String?) throws -> AuthorizationCode {
        guard let query = redirect.query else {
            throw OAuth2ClientError.wrongRedirectURL
        }
        let decoder = URLEncodedFormDecoder()

        guard let state else {
            return try decoder.decode(OAuth2Response<AuthorizationCode>.self, from: query).result.get()
        }
        let response = try decoder.decode(StateWrapper<OAuth2Response<AuthorizationCode>>.self, from: query)
        guard response.state == state else {
            throw OAuth2ClientError.stateMismatch
        }
        return try response.value.result.get()
    }

    /// https://www.rfc-editor.org/rfc/rfc6749#section-4.2
    /// 4.2.  Implicit Grant
    func decodeAccessToken<T: AccessToken>(redirect: URL, state: String?) throws -> T {
        guard let fragment = redirect.fragment else {
            throw OAuth2ClientError.wrongRedirectURL
        }
        let decoder = URLEncodedFormDecoder()
        guard let state else {
            return try decoder.decode(OAuth2Response<T>.self, from: fragment).result.get()
        }
        let response = try decoder.decode(StateWrapper<OAuth2Response<T>>.self, from: fragment)
        guard response.state == state else {
            throw OAuth2ClientError.stateMismatch
        }
        return try response.value.result.get()
    }
}

private extension OAuth2Flow {
    var responseType: AuthorizationRequest.ResponseType {
        switch self {
            case .implicit:
                return .token
            case .authorizationCode:
                return .code
        }
    }
}
