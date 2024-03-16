//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation
import HttpClientUtilities

/// https://datatracker.ietf.org/doc/draft-ietf-oauth-v2-http-mac
public struct MacBuilder: AuthorizationBuilder {
    private let strategy: Strategy
    private let request: URLRequest
    private let attributes: [Attribute: String]
    private let mac: (_ message: String) -> String

    public init(
        strategy: Strategy,
        request: URLRequest,
        attributes: [Attribute: String],
        macFunction: @escaping (_ message: String) -> String
    ) {
        self.strategy = strategy
        self.request = request
        self.attributes = attributes
        self.mac = macFunction
    }

    // MARK: - AuthorizationStringBuilder

    public var authorization: String {
        "MAC " + strategy.requiredAttributes.map {
            switch $0 {
            case .mac:
                let inputString = strategy.inputString(request, attributes: self.attributes)
                return .makeAttribute(.mac, value: mac(inputString))
            default:
                if let value = attributes[$0] {
                    return .makeAttribute($0, value: value)
                }
                return nil
            }
        }.compactMap { $0 }.joined(separator: ", ")
    }
}

private extension MacBuilder.Strategy {
    var requiredAttributes: [MacBuilder.Attribute] {
        switch self {
        case .v1:
            return [
                .id,
                .ts,
                .nonce,
                .ext,
                .mac,
            ]
        case .v3:
            return [
                .kid,
                .ts,
                .seqNr,
                .accessToken,
                .mac,
                .h,
                .cb,
            ]
        case .custom(let attributes, _):
            return attributes
        }
    }

    func inputString(_ request: URLRequest, attributes: [MacBuilder.Attribute: String]) -> String {
        switch self {
        case .v1:
            return [
                attributes[.ts],
                attributes[.nonce],
                request.httpMethod,
                request.url?.relativeURI,
                request.url?.host,
                request.url.flatMap { $0.port ?? $0.defaultPort }.map(String.init),
                attributes[.ext],
                "",
            ].compactMap { $0 ?? "" }.joined(separator: "\n")
        case .v3:
            return [
                request.requestLine,
                attributes[.ts],
                attributes[.h],
                attributes[.seqNr],
            ].compactMap { $0 ?? "" }.joined(separator: "\n")
        case .custom(_, let inputStringProvider):
            return inputStringProvider(request, attributes)
        }
    }
}

private extension URLRequest {
    var requestLine: String {
        [
            httpMethod,
            url?.relativeURI,
            "HTTP/1.1",
        ].compactMap { $0 }.joined(separator: " ")
    }
}

private extension String {
    static func makeAttribute<T>(_ name: MacBuilder.Attribute, value: T) -> String {
        "\(name.rawValue)=\"\(value)\""
    }
}

private extension URL {
    var defaultPort: Int? {
        switch scheme {
        case "http":
            return 80
        case "https":
            return 443
        default:
            return nil
        }
    }

    var relativeURI: String? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        components.scheme = nil
        components.user = nil
        components.password = nil
        components.host = nil
        components.port = nil
        return components.url?.absoluteString
    }
}
