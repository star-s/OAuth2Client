//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 08.03.2024.
//

import Foundation

// ExtraOptions
public enum AdditionalParams: Encodable {
    case void
    case params(any Encodable)

    public func encode(to encoder: any Encoder) throws {
        guard case .params(let value) = self else {
            return
        }
        try value.encode(to: encoder)
    }
}
