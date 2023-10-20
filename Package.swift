// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "RingoMenu",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "RingoMenu",
            targets: ["RingoMenu"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Lumisilk/SwiftUIPresent.git", branch: "main")
    ],
    targets: [
        .target(name: "RingoMenu", dependencies: ["SwiftUIPresent"])
    ]
)
