//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 31.12.2022.
//

import Foundation

public protocol OAuth2Client {

    var callbackURL: URL { get }

    func prepareAuthorizationURL(flow: OAuth2Flow, state: String?) throws -> URL
    func decodeAuthorizationCode(redirect: URL, state: String?) throws -> AuthorizationCode
    func decodeAccessToken<T: AccessToken>(redirect: URL, state: String?) throws -> T

    func accessToken<T: AccessToken>(code: String, additionalParameters: AdditionalParams) async throws -> T
    func accessToken<T: AccessToken>(clientSecret: String?, additionalParameters: AdditionalParams) async throws -> T
    func accessToken<T: AccessToken>(username: String, password: String, additionalParameters: AdditionalParams) async throws -> T

    func refreshToken<T: AccessToken>(_ refreshToken: String, additionalParameters: AdditionalParams) async throws -> T
}
