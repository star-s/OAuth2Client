//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

public protocol KeyedDataStorageProtocol {
    associatedtype Key : StorageKey

    func data(forKey key: Key) -> Data?
    func set(_ data: Data?, forKey key: Key)
}

public extension KeyedDataStorageProtocol where Key: CaseIterable {
    func clearStorage() {
        Key.allCases.forEach {
            set(nil, forKey: $0)
        }
    }
}
