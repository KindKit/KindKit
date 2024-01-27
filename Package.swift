// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

protocol KindModuleTrait {
    
    var descriptionProducts: [PackageDescription.Product] { get }
    var descriptionTargets: [PackageDescription.Target] { get }
    var descriptionTargetDependencies: [PackageDescription.Target.Dependency] { get }
    
}

enum KindDependency {
    
    case macro(KindMacro)
    case library(KindLibrary)
    case native(KindNative)
    
    var descriptionTargetDependencies: [PackageDescription.Target.Dependency]  {
        switch self {
        case .macro(let module): return module.descriptionTargetDependencies
        case .library(let module): return module.descriptionTargetDependencies
        case .native(let module): return module.descriptionTargetDependencies
        }
    }
    
}

struct KindMacro : KindModuleTrait {
    
    struct Options : OptionSet {
        
        var rawValue: UInt
        
        init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        static let unitTest = Options(rawValue: 1 << 0)
        
    }
    
    let options: Options
    let macroName: String
    let macroPath: String
    let macroDependencies: [KindDependency]
    let pluginName: String
    let pluginPath: String
    let pluginDependencies: [KindDependency]
    let testName: String
    let testPath: String
    let testDependencies: [KindDependency]
    
    var descriptionProducts: [PackageDescription.Product] {
        return [
            .library(
                name: self.macroName,
                targets: [ self.macroName ]
            )
        ]
    }
    
    var descriptionTargets: [PackageDescription.Target] {
        var targets: [PackageDescription.Target] = []
        do {
            let macroDependencies = self.macroDependencies.flatMap(\.descriptionTargetDependencies)
            let pluginDependencies = self.pluginDependencies.flatMap(\.descriptionTargetDependencies)
            targets.append(contentsOf: [
                .target(
                    name: self.macroName,
                    dependencies: [
                        .target(name: self.pluginName)
                    ] + macroDependencies,
                    path: self.macroPath
                ),
                .macro(
                    name: self.pluginName,
                    dependencies: [
                        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                        .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
                    ] + pluginDependencies,
                    path: self.pluginPath
                )
            ])
        }
        if self.options.contains(.unitTest) == true {
            let testDependencies = self.testDependencies.flatMap(\.descriptionTargetDependencies)
            targets.append(.testTarget(
                name: self.testName,
                dependencies: [
                    .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                    .target(name: self.macroName)
                ] + testDependencies,
                path: self.testPath
            ))
        }
        return targets
    }
    
    var descriptionTargetDependencies: [PackageDescription.Target.Dependency] {
        return [
            .target(name: self.macroName)
        ]
    }
    
    private init(
        name: String,
        options: Options = [],
        macroDependencies: [KindDependency] = [],
        pluginDependencies: [KindDependency] = [],
        testDependencies: [KindDependency] = []
    ) {
        self.macroName = "Kind\(name)Macro"
        self.macroPath = "Macro/\(name)"
        self.pluginName = "Kind\(name)MacroPlugin"
        self.pluginPath = "Macro/\(name)Plugin"
        self.testName = "Kind\(name)MacroTest"
        self.testPath = "Macro/\(name)Test"
        self.options = options
        self.macroDependencies = macroDependencies
        self.pluginDependencies = pluginDependencies
        self.testDependencies = testDependencies
    }
    
    static var json: Self {
        return self.init(
            name: "JSON",
            options: [ .unitTest ],
            macroDependencies: [
                .library(.jsonPath)
            ]
        )
    }
    
    static var monadic: Self {
        return self.init(
            name: "Monadic",
            options: [ .unitTest ]
        )
    }
    
}

struct KindLibrary : KindModuleTrait {
    
    struct Options : OptionSet {
        
        var rawValue: UInt
        
        init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        static let unitTest = Options(rawValue: 1 << 0)
        
    }
    
    let libraryName: String
    let libraryPath: String
    let testName: String
    let testPath: String
    let options: Options
    let dependencies: [KindDependency]
    let testDependencies: [KindDependency]
    
    var descriptionProducts: [PackageDescription.Product] {
        return [
            .library(
                name: self.libraryName,
                targets: [ self.libraryName ]
            )
        ]
    }
    
    var descriptionTargets: [PackageDescription.Target] {
        var targets: [PackageDescription.Target] = [
            .target(
                name: self.libraryName,
                dependencies: self.dependencies.flatMap(\.descriptionTargetDependencies),
                path: self.libraryPath
            )
        ]
        if self.options.contains(.unitTest) == true {
            var testTargetDependencies: [PackageDescription.Target.Dependency] = [
                .target(name: self.libraryName)
            ]
            testTargetDependencies.append(
                contentsOf: self.testDependencies.flatMap(\.descriptionTargetDependencies)
            )
            targets.append(.testTarget(
                name: self.testName,
                dependencies: testTargetDependencies,
                path: self.testPath
            ))
        }
        return targets
    }
    
    var descriptionTargetDependencies: [PackageDescription.Target.Dependency] {
        return [
            .target(name: self.libraryName)
        ]
    }
    
    private init(
        name: String,
        options: Options = [],
        dependencies: [KindDependency] = [],
        testDependencies: [KindDependency] = []
    ) {
        self.libraryName = "Kind\(name)"
        self.libraryPath = "Library/\(name)"
        self.testName = "Kind\(name)Test"
        self.testPath = "Library/\(name)Test"
        self.options = options
        self.dependencies = dependencies
        self.testDependencies = testDependencies
    }
    
    static var animation: Self {
        return self.init(
            name: "Animation",
            options: [ .unitTest ],
            dependencies: [
                .library(.event),
                .library(.measure)
            ]
        )
    }
    
    static var appTracking: Self {
        return self.init(
            name: "AppTracking",
            dependencies: [
                .library(.permission)
            ]
        )
    }
    
    static var autoComplete: Self {
        return self.init(
            name: "AutoComplete",
            options: [ .unitTest ],
            dependencies: [
                .library(.core)
            ]
        )
    }
    
    static var camera: Self {
        return self.init(
            name: "Camera",
            dependencies: [
                .library(.permission),
                .library(.graphics),
                .library(.event)
            ]
        )
    }
    
    static var cameraUI: Self {
        return self.init(
            name: "CameraUI",
            dependencies: [
                .library(.camera),
                .library(.ui)
            ]
        )
    }
    
    static var codingOptions: Self {
        return self.init(
            name: "CodingOptions",
            dependencies: [
                .library(.core)
            ]
        )
    }
    
    static var core: Self {
        return self.init(
            name: "Core",
            options: [ .unitTest ],
            dependencies: [
                .library(.debugger),
                .macro(.monadic)
            ]
        )
    }
    
    static var dataSource: Self {
        return self.init(
            name: "DataSource",
            dependencies: [
                .library(.flow),
                .library(.network),
                .library(.event)
            ]
        )
    }
    
    static var debug: Self {
        return self.init(
            name: "Debug",
            dependencies: [
                .library(.string)
            ]
        )
    }
    
    static var debugger: Self {
        return self.init(
            name: "Debugger",
            dependencies: [
                .native(.debugger)
            ]
        )
    }
    
    static var email: Self {
        return self.init(
            name: "Email",
            dependencies: [
                .library(.event)
            ]
        )
    }
    
    static var event: Self {
        return self.init(
            name: "Event",
            options: [ .unitTest ],
            dependencies: [
                .library(.core)
            ]
        )
    }
    
    static var filesLibrary: Self {
        return self.init(
            name: "FilesLibrary",
            dependencies: [
                .library(.event)
            ]
        )
    }
    
    static var flow: Self {
        return self.init(
            name: "Flow",
            options: [ .unitTest ],
            dependencies: [
                .library(.event),
                .library(.log),
                .library(.measure),
                .library(.timer)
            ]
        )
    }
    
    static var form: Self {
        return self.init(
            name: "Form",
            options: [ .unitTest ],
            dependencies: [
                .library(.property),
                .library(.event)
            ]
        )
    }
    
    static var geometry: Self {
        return self.init(
            name: "Geometry",
            options: [ .unitTest ],
            dependencies: [
                .library(.numeric)
            ]
        )
    }
    
    static var graphics: Self {
        return self.init(
            name: "Graphics",
            dependencies: [
                .library(.geometry),
                .library(.string),
                .library(.system)
            ]
        )
    }
    
    static var json: Self {
        return self.init(
            name: "JSON",
            options: [ .unitTest ],
            dependencies: [
                .library(.codingOptions),
                .library(.debug),
                .library(.numeric),
                .library(.jsonPath),
                .macro(.json)
            ]
        )
    }
    
    static var jsonPath: Self {
        return self.init(
            name: "JSONPath"
        )
    }
    
    static var keychain: Self {
        return self.init(
            name: "Keychain",
            dependencies: [
                .library(.json)
            ]
        )
    }
    
    static var layout: Self {
        return self.init(
            name: "Layout",
            options: [ .unitTest ],
            dependencies: [
                .library(.event),
                .library(.geometry)
            ]
        )
    }
    
    static var localize: Self {
        return self.init(
            name: "Localize",
            dependencies: [
                .library(.core)
            ]
        )
    }
    
    static var location: Self {
        return self.init(
            name: "Location",
            dependencies: [
                .library(.dataSource),
                .library(.permission)
            ]
        )
    }
    
    static var log: Self {
        return self.init(
            name: "Log",
            dependencies: [
                .library(.debug),
                .library(.system)
            ]
        )
    }
    
    static var logUI: Self {
        return self.init(
            name: "LogUI",
            dependencies: [
                .library(.log),
                .library(.screenUI)
            ]
        )
    }
    
    static var markdown: Self {
        return self.init(
            name: "Markdown",
            options: [ .unitTest ],
            dependencies: [
                .library(.core)
            ]
        )
    }
    
    static var markdownUI: Self {
        return self.init(
            name: "MarkdownUI",
            dependencies: [
                .library(.markdown),
                .library(.ui)
            ]
        )
    }
    
    static var measure: Self {
        return self.init(
            name: "Measure",
            options: [ .unitTest ],
            dependencies: [
                .library(.numeric),
                .library(.localize),
                .library(.string)
            ]
        )
    }
    
    static var microphone: Self {
        return self.init(
            name: "Microphone",
            dependencies: [
                .library(.permission)
            ]
        )
    }
    
    static var network: Self {
        return self.init(
            name: "Network",
            options: [ .unitTest ],
            dependencies: [
                .library(.debug),
                .library(.flow),
                .library(.json),
                .library(.log)
            ]
        )
    }
    
    static var notification: Self {
        return self.init(
            name: "Notification",
            dependencies: [
                .library(.permission)
            ]
        )
    }
    
    static var numeric: Self {
        return self.init(
            name: "Numeric",
            dependencies: [
                .library(.core)
            ]
        )
    }
    
    static var permission: Self {
        return self.init(
            name: "Permission",
            dependencies: [
                .library(.property),
                .library(.system)
            ]
        )
    }
    
    static var photoLibrary: Self {
        return self.init(
            name: "PhotoLibrary",
            dependencies: [
                .library(.flow),
                .library(.graphics),
                .library(.permission)
            ]
        )
    }
    
    static var player: Self {
        return self.init(
            name: "Player",
            dependencies: [
                .library(.event),
                .library(.measure)
            ]
        )
    }
    
    static var property: Self {
        return self.init(
            name: "Property",
            options: [ .unitTest ],
            dependencies: [
                .library(.event)
            ]
        )
    }
    
    static var qrCode: Self {
        return self.init(
            name: "QRCode",
            dependencies: [
                .library(.graphics)
            ]
        )
    }
    
    static var remoteImage: Self {
        return self.init(
            name: "RemoteImage",
            options: [ .unitTest ],
            dependencies: [
                .library(.graphics),
                .library(.network),
                .library(.system)
            ]
        )
    }
    
    static var remoteImageUI: Self {
        return self.init(
            name: "RemoteImageUI",
            dependencies: [
                .library(.remoteImage),
                .library(.ui)
            ]
        )
    }
    
    static var resources: Self {
        return self.init(
            name: "Resources",
            dependencies: [
                .library(.system)
            ]
        )
    }
    
    static var screenUI: Self {
        return self.init(
            name: "ScreenUI",
            dependencies: [
                .library(.ui)
            ],
            testDependencies: [
                .library(.system),
                .library(.testScreenUI)
            ]
        )
    }
    
    static var sqlite: Self {
        return self.init(
            name: "SQLite",
            options: [ .unitTest ],
            dependencies: [
                .library(.json),
                .library(.string),
                .library(.system)
            ]
        )
    }
    
    static var string: Self {
        return self.init(
            name: "String",
            dependencies: [
                .library(.localize)
            ]
        )
    }
    
    static var stringFormat: Self {
        return self.init(
            name: "StringFormat",
            options: [ .unitTest ],
            dependencies: [
                .library(.stringPattern)
            ]
        )
    }
    
    static var stringPattern: Self {
        return self.init(
            name: "StringPattern",
            options: [ .unitTest ],
            dependencies: [
                .library(.stringScanner)
            ]
        )
    }
    
    static var stringScanner: Self {
        return self.init(
            name: "StringScanner",
            options: [ .unitTest ],
            dependencies: [
                .library(.string)
            ]
        )
    }
    
    static var styleSheet: Self {
        return self.init(
            name: "StyleSheet",
            dependencies: [
                .macro(.monadic)
            ]
        )
    }
    
    static var suggestion: Self {
        return self.init(
            name: "Suggestion",
            dependencies: [
                .library(.dataSource),
                .library(.timer)
            ]
        )
    }
    
    static var system: Self {
        return self.init(
            name: "System",
            options: [ .unitTest ],
            dependencies: [
                .library(.event),
                .library(.measure)
            ]
        )
    }
    
    static var testScreenUI: Self {
        return self.init(
            name: "TestScreenUI",
            dependencies: [
                .library(.screenUI)
            ]
        )
    }
    
    static var testUI: Self {
        return self.init(
            name: "TestUI",
            dependencies: [
                .library(.ui)
            ]
        )
    }
    
    static var text: Self {
        return self.init(
            name: "Text",
            options: [ .unitTest ],
            dependencies: [
                .library(.stringFormat),
                .library(.graphics)
            ]
        )
    }
    
    static var timer: Self {
        return self.init(
            name: "Timer",
            dependencies: [
                .library(.event),
                .library(.measure)
            ]
        )
    }
    
    static var ui: Self {
        return self.init(
            name: "UI",
            options: [ .unitTest ],
            dependencies: [
                .library(.animation),
                .library(.autoComplete),
                .library(.debug),
                .library(.graphics),
                .library(.layout),
                .library(.styleSheet),
                .library(.suggestion),
                .library(.text),
                .library(.timer)
            ],
            testDependencies: [
                .library(.system),
                .library(.testUI)
            ]
        )
    }
    
    static var uiInput: Self {
        return self.init(
            name: "UIInput",
            dependencies: [
                .library(.ui),
                .library(.suggestion)
            ]
        )
    }
    
    static var uiInputMeasurement: Self {
        return self.init(
            name: "UIInputMeasurement",
            dependencies: [
                .library(.uiInput)
            ]
        )
    }
    
    static var uiPainter: Self {
        return self.init(
            name: "UIPainter",
            dependencies: [
                .library(.ui)
            ]
        )
    }
    
    static var uiSystem: Self {
        return self.init(
            name: "UISystem",
            dependencies: [
                .library(.ui)
            ]
        )
    }
    
    static var undoRedo: Self {
        return self.init(
            name: "UndoRedo",
            dependencies: [
                .library(.event)
            ]
        )
    }
    
    static var userDefaults: Self {
        return self.init(
            name: "UserDefaults",
            dependencies: [
                .library(.json)
            ]
        )
    }
    
    static var videoPlayerUI: Self {
        return self.init(
            name: "VideoPlayerUI",
            dependencies: [
                .library(.player)
            ]
        )
    }
    
    static var webUI: Self {
        return self.init(
            name: "WebUI",
            dependencies: [
                .library(.ui)
            ]
        )
    }
    
    static var xml: Self {
        return self.init(
            name: "XML",
            dependencies: [
                .library(.debug)
            ]
        )
    }
    
}

struct KindNative : KindModuleTrait {
    
    let libraryName: String
    let libraryPath: String
    let dependencies: [KindDependency]
    
    var descriptionProducts: [PackageDescription.Product] {
        return [
            .library(
                name: self.libraryName,
                targets: [ self.libraryName ]
            )
        ]
    }
    
    var descriptionTargets: [PackageDescription.Target] {
        var targets: [PackageDescription.Target] = [
            .target(
                name: self.libraryName,
                dependencies: self.dependencies.flatMap(\.descriptionTargetDependencies),
                path: self.libraryPath,
                sources: [ "src" ],
                publicHeadersPath: "inc"
            )
        ]
        return targets
    }
    
    var descriptionTargetDependencies: [PackageDescription.Target.Dependency] {
        return [
            .target(name: self.libraryName)
        ]
    }
    
    private init(
        name: String,
        dependencies: [KindDependency] = [],
        testDependencies: [KindDependency] = []
    ) {
        self.libraryName = "Kind\(name)Native"
        self.libraryPath = "Native/\(name)"
        self.dependencies = dependencies
    }
    
    static var debugger: Self {
        return self.init(
            name: "Debugger"
        )
    }
    
}

extension PackageDescription.Package {
    
    convenience init(macro: [KindMacro], library: [KindLibrary], native: [KindNative]) {
        self.init(modules: macro + library + native)
    }
    
    convenience init(modules: [KindModuleTrait]) {
        self.init(
            name: "KindKit",
            platforms: [
                .iOS(.v13),
                .macOS(.v10_15)
            ],
            products: modules.flatMap(\.descriptionProducts),
            dependencies: [
                .package(url: "https://github.com/apple/swift-syntax", from: "600.0.0-latest")
            ],
            targets: modules.flatMap(\.descriptionTargets)
        )
    }
    
}

let package = Package(
    macro: [
        .json,
        .monadic
    ],
    library: [
        .animation,
        .appTracking,
        .autoComplete,
        .camera,
//        .cameraUI,
        .codingOptions,
        .core,
        .dataSource,
        .debug,
        .debugger,
        .email,
        .event,
        .filesLibrary,
        .flow,
        .form,
        .geometry,
        .graphics,
        .json,
        .jsonPath,
        .keychain,
        .layout,
        .localize,
        .location,
        .log,
//        .logUI,
        .markdown,
//        .markdownUI,
        .measure,
        .microphone,
        .network,
        .notification,
        .numeric,
        .permission,
        .photoLibrary,
        .player,
        .property,
        .qrCode,
        .remoteImage,
//        .remoteImageUI,
//        .resources,
//        .screenUI,
//        .sqlite,
        .string,
        .stringFormat,
        .stringPattern,
        .stringScanner,
        .styleSheet,
        .suggestion,
        .system,
//        .testScreenUI,
//        .testUI,
        .text,
        .timer,
//        .ui,
//        .uiInput,
//        .uiInputMeasurement,
//        .uiPainter,
//        .uiSystem,
        .undoRedo,
        .userDefaults,
//        .videoPlayerUI,
//        .webUI,
        .xml
    ],
    native: [
        .debugger
    ]
)
