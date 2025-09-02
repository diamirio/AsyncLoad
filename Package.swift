// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "AsyncLoad",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
        .macOS(.v13),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "AsyncLoad",
            targets: ["AsyncLoad"]
        ),
    ],
    targets: [
        .target(
            name: "AsyncLoad"
        ),
        .testTarget(
            name: "AsyncLoadTests",
            dependencies: ["AsyncLoad"]
        ),
    ]
)
