//
//  KindKitView
//

#if os(macOS)

import AppKit

public struct Color : Equatable {
    
    public var native: NSColor
    
    @inlinable
    public init(
        r: Float,
        g: Float,
        b: Float,
        a: Float = 1
    ) {
        self.native = NSColor(
            red: CGFloat(r),
            green: CGFloat(g),
            blue: CGFloat(b),
            alpha: CGFloat(a)
        )
    }
    
    @inlinable
    public init(
        r: UInt8,
        g: UInt8,
        b: UInt8,
        a: UInt8 = 255
    ) {
        self.native = NSColor(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
    @inlinable
    public init(
        rgb: UInt32
    ) {
        self.native = NSColor(
            red: CGFloat((rgb >> 16) & 0xff) / 255.0,
            green: CGFloat((rgb >> 8) & 0xff) / 255.0,
            blue: CGFloat(rgb & 0xff) / 255.0,
            alpha: 1
        )
    }
    
    @inlinable
    public init(
        rgba: UInt32
    ) {
        self.native = NSColor(
            red: CGFloat((rgba >> 24) & 0xff) / 255.0,
            green: CGFloat((rgba >> 16) & 0xff) / 255.0,
            blue: CGFloat((rgba >> 8) & 0xff) / 255.0,
            alpha: CGFloat(rgba & 0xff) / 255.0
        )
    }
    
    @inlinable
    public init(_ native: NSColor) {
        self.native = native
    }
    
    @inlinable
    public init(_ cgColor: CGColor) {
        self.init(NSColor(cgColor: cgColor) ?? NSColor.black)
    }
    
}

public extension Color {
    
    @inlinable
    var cgColor: CGColor {
        return self.native.cgColor
    }
    
    @inlinable
    var isOpaque: Bool {
        return self.native.isOpaque
    }
    
}

#endif
