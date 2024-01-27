//
//  KindKit
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
@_exported import KindGeometry
@_exported import KindSystem

#if os(iOS)
public typealias HandleColor = UIColor
public typealias HandleFont = UIFont
#elseif os(macOS)
public typealias HandleColor = NSColor
public typealias HandleFont = NSFont
#endif

public typealias Coordinate = KindGeometry.Coordinate
public typealias Alpha = Double
