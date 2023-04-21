// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KindKit",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "KindKit", targets: [ "KindKit" ]),
        .library(name: "KindKitTest", targets: [ "KindKitTest" ])
    ],
    targets: [
        .target(
            name: "KindKit"
        ),
        .target(
            name: "KindKitTest",
            dependencies: [ .target(name: "KindKit") ]
        ),
        .testTarget(
            name: "KindKit-Tests",
            dependencies: [
                .target(name: "KindKit"),
                .target(name: "KindKitTest")
            ]
        )
    ]
)
