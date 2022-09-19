// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KindKit",
    platforms: [
        .iOS(.v10),
        .macOS(.v11)
    ],
    products: [
        .library(name: "KindKit", type: .static, targets: [ "KindKit" ]),
    ],
    targets: [
        .target(
            name: "KindKit",
            path: "Sources"
        ),
        .testTarget(
            name: "KindKit-Tests",
            dependencies: [ .target(name: "KindKit") ],
            path: "Tests"
        )
    ]
)
