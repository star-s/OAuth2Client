//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.12.2022.
//

import Foundation

/// https://www.rfc-editor.org/rfc/rfc6749#section-5.2
/// 5.2.  Error Response
///
/// The authorization server responds with an HTTP 400 (Bad Request)
/// status code (unless specified otherwise) and includes the following
/// parameters with the response:
public struct AccessTokenError: LocalizedError, Decodable {
	public enum ErrorType: String, Decodable {
		case invalidRequest = "invalid_request"
		case invalidClient = "invalid_client"
		case invalidGrant = "invalid_grant"
		case unauthorizedClient = "unauthorized_client"
		case unsupportedGrantType = "unsupported_grant_type"
		case invalidScope = "invalid_scope"

        // https://www.rfc-editor.org/rfc/rfc6749#section-4.2.2.1
        case accessDenied = "access_denied"
        case unsupportedResponseType = "unsupported_response_type"
        case serverError = "server_error"
        case temporarilyUnavailable = "temporarily_unavailable"
	}

	private enum CodingKeys: String, CodingKey {
		case error
		case errorDescription = "error_description"
		case errorURI = "error_uri"
	}
	public let error: ErrorType
	public let errorDescription: String?
	public let errorURI: URL?
}
