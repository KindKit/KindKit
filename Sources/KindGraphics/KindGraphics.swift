//
//  KindKit
//

#if os(macOS)
@_exported import AppKit
#elseif os(iOS)
@_exported import UIKit
#endif
@_exported import KindMath
@_exported import KindSystem

#if os(macOS)
public typealias NativeColor = NSColor
public typealias NativeFont = NSFont
public typealias NativeImage = NSImage
#elseif os(iOS)
public typealias NativeColor = UIColor
public typealias NativeFont = UIFont
public typealias NativeImage = UIImage
#endif
