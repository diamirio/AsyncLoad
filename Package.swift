// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "AsyncLoad",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v14),
        .visionOS(.v2)
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
