//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 14.03.2024.
//

import XCTest
@testable import OAuth2Client

final class MacBuilderTests: XCTestCase {

    // https://developers.paysera.com/ru/wallet/#wallet-api-authentication-mac
    func testPaysera() throws {
        let client_id = "wkVd93h2uS"
        let mac_key = "IrdTc8uQodU7PRpLzzLTW6wqZAO6tAMU"
        let mac_algorithm: MacToken.Algorithm = .hmacSha256

        let timestamp = Date(timeIntervalSince1970: 1343811600)
        let nonce = "nQnNaSNyubfPErjRO55yaaEYo9YZfKHN"

        let expextedMac = "/qxTA8FOgT0Dd0MHh9k/sUQ3Q38ckx8+S0PBxpIuttY="

        let request = URLRequest(url: "https://wallet.paysera.com/rest/v1/payment/10145")

        let builder = try MacBuilder(
            request: request,
            keyId: client_id,
            timestamp: timestamp,
            nonce: nonce,
            macFunction: XCTUnwrap(mac_algorithm.macFunction(key: mac_key))
        )
        let attributes = parse(builder.authorization)

        XCTAssertEqual(attributes.count, 4)
        try XCTAssertEqual(XCTUnwrap(attributes[.id]), client_id)
        try XCTAssertEqual(XCTUnwrap(attributes[.ts]), String(Int64(timestamp.timeIntervalSince1970)))
        try XCTAssertEqual(XCTUnwrap(attributes[.nonce]), nonce)
        try XCTAssertEqual(XCTUnwrap(attributes[.mac]), expextedMac)
    }
}

private extension MacBuilderTests {

    func parse(_ authorizationString: String) -> [MacBuilder.Attribute: String] {
        let scanner = Scanner(string: authorizationString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: ",").union(.whitespacesAndNewlines)
        if scanner.scanString("MAC") == nil {
            XCTFail("\(authorizationString) - is not MAC authorization")
        }
        var result: [MacBuilder.Attribute: String] = [:]

        while !scanner.isAtEnd {
            guard let str = scanner.scanUpToString(",") else {
                continue
            }
            guard let attribute = parseAttribute(from: str) else {
                continue
            }
            result[attribute.name] = attribute.value
        }
        return result
    }

    func parseAttribute(from string: String) -> (name: MacBuilder.Attribute, value: String)? {
        let attributeSkipedCharacters = CharacterSet(charactersIn: "\"")
        let limiter = "="
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = attributeSkipedCharacters
        guard let attr = scanner.scanUpToString(limiter) else {
            return nil
        }
        _ = scanner.scanString(limiter)
        guard let value = scanner.scanUpToCharacters(from: attributeSkipedCharacters) else {
            return nil
        }
        return (MacBuilder.Attribute(rawValue: attr), value)
    }
}
