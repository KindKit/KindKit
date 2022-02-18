//
//  KindKitView
//

#if os(macOS)

import AppKit

public struct Color {
    
    public var native: NSColor
    
    @inlinable
    public init(
        r: Float,
        g: Float,
        b: Float,
        a: Float = 1
    ) {
        self.native = NSColor(
            red: r,
            green: g,
            blue: b,
            alpha: a
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
            red: Float(r) / 255,
            green: Float(g) / 255,
            blue: Float(b) / 255,
            alpha: Float(a) / 255
        )
    }
    
    @inlinable
    public init(
        rgb: UInt32
    ) {
        self.native = NSColor(
            red: Float((rgb >> 16) & 0xff) / 255.0,
            green: Float((rgb >> 8) & 0xff) / 255.0,
            blue: Float(rgb & 0xff) / 255.0,
            alpha: 1
        )
    }
    
    @inlinable
    public init(
        rgba: UInt32
    ) {
        self.native = NSColor(
            red: Float((rgba >> 24) & 0xff) / 255.0,
            green: Float((rgba >> 16) & 0xff) / 255.0,
            blue: Float((rgba >> 8) & 0xff) / 255.0,
            alpha: Float(rgba & 0xff) / 255.0
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
    
}

#endif
