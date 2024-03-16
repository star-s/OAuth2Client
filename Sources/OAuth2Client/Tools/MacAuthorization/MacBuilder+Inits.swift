//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.03.2024.
//

import Foundation

extension MacBuilder {

    public enum RequestPosition {
        case first(accessToken: String)
        case subsequent
    }

    public init(
        request: URLRequest,
        keyId: String,
        timestamp: Date = Date(),
        nonce: String,
        ext: String? = nil,
        macFunction: @escaping (_ message: String) -> String
    ) {
        var attributes: [Attribute: String] = [:]

        attributes[.id] = keyId
        attributes[.ts] = String(Int64(timestamp.timeIntervalSince1970))
        attributes[.nonce] = nonce
        attributes[.ext] = ext

        self.init(
            strategy: .v1,
            request: request,
            attributes: attributes,
            macFunction: macFunction
        )
    }

    public init(
        request: URLRequest,
        keyId: String,
        timestamp: Date = Date(),
        requestPosition: RequestPosition,
        sequenceNumber: Int64? = nil,
        channelBinding: String? = nil,
        h: String? = nil,
        macFunction: @escaping (_ message: String) -> String
    ) {
        var attributes: [Attribute: String] = [:]

        attributes[.kid] = keyId
        attributes[.ts] = String(Int64(timestamp.timeIntervalSince1970))
        if case .first(let accessToken) = requestPosition {
            attributes[.accessToken] = accessToken
        }
        attributes[.seqNr] = sequenceNumber.map(String.init)
        attributes[.cb] = channelBinding
        attributes[.h] = h

        self.init(
            strategy: .v3,
            request: request,
            attributes: attributes,
            macFunction: macFunction
        )
    }
}
