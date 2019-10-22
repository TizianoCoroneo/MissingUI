// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MissingUI",
    products: [
        .library(
            name: "MissingUI",
            targets: ["MissingUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MissingUI",
            dependencies: []),
        .testTarget(
            name: "MissingUITests",
            dependencies: ["MissingUI"]),
    ]
)
