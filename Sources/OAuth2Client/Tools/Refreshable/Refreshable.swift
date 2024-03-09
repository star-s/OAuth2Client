//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

public protocol Refreshable {
    func refresh<C: OAuth2Client>(with client: C) async throws -> Self
}
