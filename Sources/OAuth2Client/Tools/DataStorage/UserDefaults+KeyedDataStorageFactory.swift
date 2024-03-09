//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

extension UserDefaults {

    private struct StorageFactory: KeyedDataStorageFactory {
        let userDefaults: UserDefaults

        func storage<Key: StorageKey>(keyedBy type: Key.Type) -> KeyedDataStorage<Key> {
            .userDefaults(userDefaults)
        }
    }

    public var keyedDataStorageFactory: KeyedDataStorageFactory {
        StorageFactory(userDefaults: self)
    }
}
