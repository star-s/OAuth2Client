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
    let sequenceNumber: Int64?
    let accessToken: String?
    let channelBinding: String?
    let h: String?

    private var inputString: String {
        ""
    }

    var authorizationString: String {
        var attributes: [String] = []

        attributes.append("id=\"\(keyId)\"")

        let timestamp = String(Int64(timestamp.timeIntervalSince1970))
        attributes.append("ts=\"\(timestamp)\"")

        if let sequenceNumber {
            attributes.append("seq-nr=\"\(sequenceNumber)\"")
        }
        if let accessToken {
            attributes.append("access_token=\"\(accessToken)\"")
        }
        // !!!: Example
        let mac = "kDZvddkndxvhGRXZhvuDjEWhGeE="
        attributes.append("mac=\"\(mac)\"")

        if let h {
            attributes.append("h=\"\(h)\"")
        }
        if let channelBinding {
            attributes.append("cb=\"\(channelBinding)\"")
        }
        //let nonce = String(UUID().uuidString.prefix(8))
        //return "MAC id=\"\(keyId)\",nonce=\"\(nonce)\",mac=\"\(mac)\""
        return "MAC " + attributes.joined(separator: ",")
    }
}
