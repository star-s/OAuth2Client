//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.03.2024.
//

import Foundation

extension MacBuilder {

    public enum Strategy {
        /// https://datatracker.ietf.org/doc/draft-ietf-oauth-v2-http-mac/01
        case v1
        /// https://datatracker.ietf.org/doc/draft-ietf-oauth-v2-http-mac/03
        case v3
        case custom([Attribute], (URLRequest, [Attribute: String]) -> String)
    }
}
