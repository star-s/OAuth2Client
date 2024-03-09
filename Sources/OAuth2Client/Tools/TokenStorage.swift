//
//  TokenStorage.swift
//  OAuth2Client
//
//  Created by Sergey Starukhin on 18.02.2024.
//

import Foundation
import Semaphore

public actor TokenStorage<Token: AccessToken>: CredentialStorageProtocol {

    private enum StorageKeys: String, StorageKey {
        case token
    }

    private let backedStore: KeyedDataStorage<StorageKeys>
    private let semaphore = AsyncSemaphore(value: 1)

    private lazy var _token: TokenWrapper<Token>? = fetchFromBackedStore() {
        willSet {
            saveToBackedStorage(newValue)
        }
    }

    public init(storageFactory: KeyedDataStorageFactory = UserDefaults.standard.keyedDataStorageFactory) {
        self.backedStore = storageFactory.storage(keyedBy: StorageKeys.self)
    }

    public func get() async -> TokenWrapper<Token>? {
        await semaphore.wait()
        defer {
            semaphore.signal()
        }
        return _token
    }

    public func modify<T>(_ closure: @escaping (inout TokenWrapper<Token>?) async throws -> T) async rethrows -> T {
        await semaphore.wait()
        var token = _token
        defer {
            _token = token
            semaphore.signal()
        }
        return try await closure(&token)
    }

    private func fetchFromBackedStore() -> TokenWrapper<Token>? {
        guard let data = backedStore.data(forKey: .token) else {
            return nil
        }
        let decoder = PropertyListDecoder()
        return try? decoder.decode(Credential.self, from: data)
    }

    private func saveToBackedStorage(_ token: TokenWrapper<Token>?) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let data = try? encoder.encode(token)
        backedStore.set(data, forKey: .token)
    }
}
