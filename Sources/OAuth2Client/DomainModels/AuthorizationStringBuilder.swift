//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.03.2024.
//

import Foundation

public protocol AuthorizationStringBuilder {
    var authorizationString: String { get }
}

extension MacAuthorizationBuilder: AuthorizationStringBuilder {}
