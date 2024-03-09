//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.12.2022.
//

import Foundation
import Combine
import HttpClient
import HttpClientUtilities

public struct OAuth2ResponseDecoder: ResponseDecoder {
    private let decoder: JSONDecoder

    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    public func validate(response: (data: Data, response: URLResponse)) async throws {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return
        }
        switch httpResponse.httpStatusCode.class {
        case .successful:
            return
        case .clientError, .serverError:
            throw try decoder.decode(AccessTokenError.self, from: response.data)
        default:
            throw httpResponse.httpStatusCode
        }
    }

    public func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
        try decoder.decode(OAuth2Response<T>.self, from: response.data).result.get()
    }
}
