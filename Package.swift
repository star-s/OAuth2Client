// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OAuth2Client",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OAuth2Client",
            targets: ["OAuth2Client"]),
    ],
    dependencies: [
        .package(url: "https://github.com/star-s/HttpClient.git", from: "0.2.0"),
        .package(url: "https://github.com/groue/Semaphore.git", .upToNextMajor(from: "0.0.8")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OAuth2Client",
            dependencies: [
                .product(name: "HttpClient", package: "HttpClient"),
                .product(name: "HttpClientUtilities", package: "HttpClient"),
                .product(name: "Semaphore", package: "Semaphore"),
            ]),
        .testTarget(
            name: "OAuth2ClientTests",
            dependencies: ["OAuth2Client"]),
    ]
)
