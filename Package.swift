// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserLevels",
    platforms: [
           .macOS(.v10_15),
           .iOS(.v13)
       ],
    products: [
        .library(
            name: "UserLevels",
            targets: ["UserLevels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.36.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.1.2"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.1")
    ],
    targets: [
        .target(
            name: "UserLevels",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver")
            ],
            swiftSettings: [
                // See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]),
        .testTarget(
            name: "UserLevelsTests",
            dependencies: [
                .target(name: "UserLevels"),
                .product(name: "XCTVapor", package: "vapor")]),
    ]
)
