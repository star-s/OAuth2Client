//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 08.03.2024.
//

import Foundation
import HttpClient

public protocol OAuth2ClientImplementation: OAuth2Client, HttpClient {

    associatedtype Encoder: RequestEncoder = URLEncodedFormRequestEncoder
    associatedtype Decoder: ResponseDecoder = OAuth2ResponseDecoder

    var clientID: String { get }

    var authorizationEndpoint: Path { get }
    var tokenEndpoint: Path { get }

    var scope: String { get }
}
