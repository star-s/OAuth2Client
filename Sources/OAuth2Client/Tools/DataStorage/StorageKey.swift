//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

public protocol StorageKey : CustomStringConvertible, Sendable {
    var stringValue: String { get }
    init?(stringValue: String)
}

public extension StorageKey {
    var description: String { stringValue }
}

public extension StorageKey where Self: RawRepresentable, RawValue == String {
    var stringValue: String { rawValue }
    init?(stringValue: String) {
        self.init(rawValue: stringValue)
    }
}
