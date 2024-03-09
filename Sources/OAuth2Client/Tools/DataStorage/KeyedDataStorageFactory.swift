//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

public protocol KeyedDataStorageFactory {
    func storage<Key: StorageKey>(keyedBy type: Key.Type) -> KeyedDataStorage<Key>
}
