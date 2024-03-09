//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation

struct AuthorizationRequest: Encodable {
    enum ResponseType: String, Encodable {
        case code
        case token
    }

	private enum CodingKeys: String, CodingKey {
		case type = "response_type"
		case clientID = "client_id"
        case redirectURL = "redirect_uri"
		case scope
	}

	let type: ResponseType
	let clientID: String
    let redirectURL: URL?
	let scope: String?
}
