// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RingoMenu",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "RingoMenu",
            targets: ["RingoMenu"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RingoMenu",
            dependencies: []),
        .testTarget(
            name: "RingoMenuTests",
            dependencies: ["RingoMenu"]),
    ]
)
