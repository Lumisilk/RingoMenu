// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "RingoMenu",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "RingoMenu",
            targets: ["RingoMenu"]),
    ],
    targets: [
        .target(name: "RingoMenu")
    ]
)
