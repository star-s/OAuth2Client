//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

struct MacAuthorizationBuilder {
    let request: URLRequest
    let keyId: String
    let messageDigestAlgorithm: MessageAuthenticationCodeToken.Algorithm
    let timestamp: Date
    let sequenceNumber: Int?
    let accessToken: String?
    let channelBinding: String?
    let h: String?

    private var inputString: String {
        ""
    }

    var authorizationString: String {
        assertionFailure("Not yet implemented")
        // !!!: Example
        let timestamp = String(Int64(timestamp.timeIntervalSince1970))
        let nonce = String(UUID().uuidString.prefix(8))
        let mac = "kDZvddkndxvhGRXZhvuDjEWhGeE="
        return "MAC id=\"\(keyId)\",nonce=\"\(nonce)\",mac=\"\(mac)\""
    }
}
