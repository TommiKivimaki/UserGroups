// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "UserLevels",
  products: [
    .library(
      name: "UserLevels",
      targets: ["UserLevels"]),
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "3.3.3"),
    .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
    .package(url: "https://github.com/vapor/auth.git", from: "2.0.4"),
    .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "UserLevels",
      dependencies: ["Vapor", "FluentSQLite", "Authentication"]),
    .testTarget(
      name: "UserLevelsTests",
      dependencies: ["UserLevels", "FluentPostgreSQL"]),
  ]
)
