//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

public struct KeyedDataStorage<Key: StorageKey> : KeyedDataStorageProtocol {

    private let gettter: (Key) -> Data?
    private let setter: (Data?, Key) -> Void

    init(
        gettter: @escaping (Key) -> Data?,
        setter: @escaping (Data?, Key) -> Void
    ) {
        self.gettter = gettter
        self.setter = setter
    }

    public init<Storage: KeyedDataStorageProtocol>(_ storage: Storage) where Key == Storage.Key {
        gettter = {
            storage.data(forKey: $0)
        }
        setter = {
            storage.set($0, forKey: $1)
        }
    }

    public func data(forKey key: Key) -> Data? {
        gettter(key)
    }

    public func set(_ data: Data?, forKey key: Key) {
        setter(data, key)
    }
}

public extension KeyedDataStorage {

    static func userDefaults(_ userDefaults: UserDefaults = .standard) -> KeyedDataStorage<Key> {
        KeyedDataStorage { key in
            userDefaults.data(forKey: key.stringValue)
        } setter: { data, key in
            userDefaults.set(data, forKey: key.stringValue)
        }
    }
}
