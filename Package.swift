// swift-tools-version:5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Library : String, CaseIterable {
    
    case animation = "KindAnimation"
    case appTracking = "KindAppTracking"
    case camera = "KindCamera"
    case cameraUI = "KindCameraUI"
    case condition = "KindCondition"
    case core = "KindCore"
    case dataSource = "KindDataSource"
    case debug = "KindDebug"
    case email = "KindEmail"
    case event = "KindEvent"
    case filesLibrary = "KindFilesLibrary"
    case flow = "KindFlow"
    case form = "KindForm"
    case graphics = "KindGraphics"
    case json = "KindJSON"
    case keychain = "KindKeychain"
    case location = "KindLocation"
    case log = "KindLog"
    case logUI = "KindLogUI"
    case markdown = "KindMarkdown"
    case markdownUI = "KindMarkdownUI"
    case math = "KindMath"
    case microphone = "KindMicrophone"
    case module = "KindModule"
    case network = "KindNetwork"
    case notification = "KindNotification"
    case permission = "KindPermission"
    case photoLibrary = "KindPhotoLibrary"
    case player = "KindPlayer"
    case qrCode = "KindQRCode"
    case remoteImage = "KindRemoteImage"
    case remoteImageUI = "KindRemoteImageUI"
    case screenUI = "KindScreenUI"
    case shell = "KindShell"
    case sqlite = "KindSQLite"
    case suggestion = "KindSuggestion"
    case swiftUI = "KindSwiftUI"
    case system = "KindSystem"
    case testScreenUI = "KindTestScreenUI"
    case timer = "KindTimer"
    case ui = "KindUI"
    case uiClock = "KindUIClock"
    case undoRedo = "KindUndoRedo"
    case userDefaults = "KindUserDefaults"
    case videoPlayerUI = "KindVideoPlayerUI"
    case webUI = "KindWebUI"
    case xml = "KindXML"
    
    var hasUnitTest: Bool {
        switch self {
        case .core: return true
        case .event: return true
        case .json: return true
        case .markdown: return true
        case .math: return true
        case .network: return true
        case .remoteImage: return true
        case .sqlite: return true
        case .system: return true
        default: return false
        }
    }
    
    var dependencies: [Library] {
        switch self {
        case .animation: return [ .math ]
        case .appTracking: return [ .permission ]
        case .camera: return [ .permission, .graphics, .event ]
        case .cameraUI: return [ .camera, .ui ]
        case .condition: return [ .event ]
        case .core: return []
        case .dataSource: return [ .flow, .network, .event ]
        case .debug: return [ .core ]
        case .email: return [ .core ]
        case .event: return [ .core ]
        case .filesLibrary: return [ .core ]
        case .flow: return [ .log ]
        case .form: return [ .condition, .event ]
        case .graphics: return [ .math, .system ]
        case .json: return [ .debug ]
        case .keychain: return [ .json ]
        case .location: return [ .dataSource, .permission ]
        case .log: return [ .debug ]
        case .logUI: return [ .log, .screenUI ]
        case .markdown: return [ .core ]
        case .markdownUI: return [ .markdown, .ui ]
        case .math: return [ .core ]
        case .microphone: return [ .permission ]
        case .module: return [ .condition ]
        case .network: return [ .debug, .flow, .json, .log ]
        case .notification: return [ .permission ]
        case .permission: return [ .condition ]
        case .photoLibrary: return [ .flow, .graphics, .permission ]
        case .player: return [ .event ]
        case .qrCode: return [ .graphics ]
        case .remoteImage: return [ .graphics, .network, .system ]
        case .remoteImageUI: return [ .remoteImage, .ui ]
        case .screenUI: return [ .ui ]
        case .shell: return [ .core ]
        case .sqlite: return [ .json ]
        case .suggestion: return [ .dataSource, .timer ]
        case .swiftUI: return [ .ui ]
        case .system: return [ .event ]
        case .testScreenUI: return [ .screenUI ]
        case .timer: return [ .event ]
        case .ui: return [ .animation, .graphics, .suggestion, .timer ]
        case .uiClock: return [ .ui ]
        case .undoRedo: return [ .event ]
        case .userDefaults: return [ .json ]
        case .videoPlayerUI: return [ .player, .ui ]
        case .webUI: return [ .ui ]
        case .xml: return [ .debug ]
        }
    }
    
    static var descriptionProducts: [PackageDescription.Product] {
        let cases = Self.allCases
        var result: [PackageDescription.Product] = [
            .library(name: "KindKit", targets: [ "KindKit" ])
        ]
        for one in cases {
            result.append(.library(name: one.rawValue, targets: [ one.rawValue ]))
        }
        return result
    }
    
    static var descriptionTargets: [PackageDescription.Target] {
        let cases = Self.allCases
        var result: [PackageDescription.Target] = [
            .target(
                name: "KindKit",
                dependencies: cases.map({
                    .target(name: $0.rawValue)
                })
            )
        ]
        for one in cases {
            result.append(contentsOf: one.descriptionTargets)
        }
        return result
    }
    
    var descriptionTargets: [PackageDescription.Target] {
        var result: [PackageDescription.Target] = []
        if let target = self.descriptionSelfTarget {
            result.append(target)
        }
        if let target = self.descriptionTestTarget {
            result.append(target)
        }
        return result
    }
    
    var descriptionSelfTarget: PackageDescription.Target? {
        return .target(
            name: self.rawValue,
            dependencies: self.dependencies.map({ .target(name: $0.rawValue) })
        )
    }
    
    var descriptionTestTarget: PackageDescription.Target? {
        guard self.hasUnitTest == true else { return nil }
        return .testTarget(
            name: "\(self.rawValue)Test",
            dependencies: [ 
                .target(name: self.rawValue)
            ]
        )
    }
    
}

let package = Package(
    name: "KindKit",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13)
    ],
    products: Library.descriptionProducts,
    targets: Library.descriptionTargets
)
