// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KindKit",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "KindKitApi", type: .static, targets: [ "KindKitApi" ]),
        .library(name: "KindKitCore",type: .static, targets: [ "KindKitCore" ]),
        .library(name: "KindKitDatabase", type: .static, targets: [ "KindKitDatabase" ]),
        .library(name: "KindKitDataSource", type: .static, targets: [ "KindKitDataSource" ]),
        .library(name: "KindKitGraphics", type: .static, targets: [ "KindKitGraphics" ]),
        .library(name: "KindKitJson", type: .static, targets: [ "KindKitJson" ]),
        .library(name: "KindKitKeychain", type: .static, targets: [ "KindKitKeychain" ]),
        .library(name: "KindKitLog", type: .static, targets: [ "KindKitLog" ]),
        .library(name: "KindKitLogUI", type: .static, targets: [ "KindKitLogUI" ]),
        .library(name: "KindKitMath", type: .static, targets: [ "KindKitMath" ]),
        .library(name: "KindKitModule", type: .static, targets: [ "KindKitModule" ]),
        .library(name: "KindKitObserver", type: .static, targets: [ "KindKitObserver" ]),
        .library(name: "KindKitPermission", type: .static, targets: [ "KindKitPermission" ]),
        .library(name: "KindKitQrCode", type: .static, targets: [ "KindKitQrCode" ]),
        .library(name: "KindKitRemoteImageView", type: .static, targets: [ "KindKitRemoteImageView" ]),
        .library(name: "KindKitShell", type: .static, targets: [ "KindKitShell" ]),
        .library(name: "KindKitView", type: .static, targets: [ "KindKitView" ]),
        .library(name: "KindKitXml", type: .static, targets: [ "KindKitXml" ])
    ],
    targets: [
        .target(
            name: "KindKitApi",
            dependencies: [ .target(name: "KindKitCore") ],
            path: "Sources/Api"
        ),
        .target(
            name: "KindKitCore",
            path: "Sources/Core"
        ),
        .target(
            name: "KindKitDatabase",
            dependencies: [ .target(name: "KindKitCore") ],
            path: "Sources/Database"
        ),
        .target(
            name: "KindKitDataSource",
            dependencies: [ .target(name: "KindKitCore") ],
            path: "Sources/DataSource"
        ),
        .target(
            name: "KindKitGraphics",
            dependencies: [ .target(name: "KindKitView") ],
            path: "Sources/Graphics"
        ),
        .target(
            name: "KindKitJson",
            dependencies: [ .target(name: "KindKitCore") ],
            path: "Sources/Json"
        ),
        .target(
            name: "KindKitKeychain",
            dependencies: [ .target(name: "KindKitCore") ],
            path: "Sources/Keychain"
        ),
        .target(
            name: "KindKitLog",
            dependencies: [ .target(name: "KindKitCore") ],
            path: "Sources/Log"
        ),
        .target(
            name: "KindKitLogUI",
            dependencies: [ .target(name: "KindKitLog"), .target(name: "KindKitObserver"), .target(name: "KindKitView") ],
            path: "Sources/LogUI"
        ),
        .target(
            name: "KindKitMath",
            dependencies: [ .target(name: "KindKitCore") ],
            path: "Sources/Math"
        ),
        .testTarget(
            name: "KindKitMath-Tests",
            dependencies: [ .target(name: "KindKitMath") ],
            path: "Sources/Math-Tests"
        ),
        .target(
            name: "KindKitModule",
            dependencies: [ .target(name: "KindKitPermission"), .target(name: "KindKitView") ],
            path: "Sources/Module"
        ),
        .target(
            name: "KindKitObserver",
            dependencies: [ .target(name: "KindKitCore") ],
            path: "Sources/Observer"
        ),
        .target(
            name: "KindKitPermission",
            dependencies: [ .target(name: "KindKitCore"), .target(name: "KindKitObserver") ],
            path: "Sources/Permission"
        ),
        .target(
            name: "KindKitQrCode",
            dependencies: [ .target(name: "KindKitView") ],
            path: "Sources/QrCode"
        ),
        .target(
            name: "KindKitRemoteImageView",
            dependencies: [ .target(name: "KindKitApi"), .target(name: "KindKitView") ],
            path: "Sources/RemoteImageView"
        ),
        .target(
            name: "KindKitShell",
            dependencies: [ .target(name: "KindKitCore") ],
            path: "Sources/Shell"
        ),
        .target(
            name: "KindKitView",
            dependencies: [ .target(name: "KindKitCore"), .target(name: "KindKitMath"), .target(name: "KindKitObserver") ],
            path: "Sources/View"
        ),
        .target(
            name: "KindKitXml",
            dependencies: [ .target(name: "KindKitCore") ],
            path: "Sources/Xml"
        )
    ]
)
