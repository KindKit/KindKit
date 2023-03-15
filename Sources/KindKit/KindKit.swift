//
//  KindKit
//

@_exported import Foundation
#if os(macOS)
@_exported import AppKit
#elseif os(iOS)
@_exported import UIKit
#endif
#if canImport(CoreGraphics)
import CoreGraphics
#endif
#if canImport(CoreLocation)
import CoreLocation
#endif
#if canImport(CoreServices)
import CoreServices
#endif
#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif
