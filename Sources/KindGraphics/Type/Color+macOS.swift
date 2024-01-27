//
//  KindKit
//

#if os(macOS)

import AppKit

public typealias NativeColor = NSColor

public extension Color {
    
    init(
        r: Double,
        g: Double,
        b: Double,
        a: Double = 1
    ) {
        self.native = NSColor(
            red: CGFloat(r),
            green: CGFloat(g),
            blue: CGFloat(b),
            alpha: CGFloat(a)
        )
    }
    
    init(
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
    
    init(
        rgb: UInt32
    ) {
        self.native = NSColor(
            red: CGFloat((rgb >> 16) & 0xff) / 255.0,
            green: CGFloat((rgb >> 8) & 0xff) / 255.0,
            blue: CGFloat(rgb & 0xff) / 255.0,
            alpha: 1
        )
    }
    
    init(
        rgba: UInt32
    ) {
        self.native = NSColor(
            red: CGFloat((rgba >> 24) & 0xff) / 255.0,
            green: CGFloat((rgba >> 16) & 0xff) / 255.0,
            blue: CGFloat((rgba >> 8) & 0xff) / 255.0,
            alpha: CGFloat(rgba & 0xff) / 255.0
        )
    }
    
    init(_ native: NSColor) {
        self.native = native
    }
    
    init(_ cgColor: CGColor) {
        self.init(NSColor(cgColor: cgColor) ?? NSColor.black)
    }
    
}

public extension Color {
    
    @inlinable
    var pixel: Pixel {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.native.getRed(&r, green: &g, blue: &b, alpha: &a)
        return .init(r: r, g: g, b: b, a: a)
    }
    
    @inlinable
    var cgColor: CGColor {
        return self.native.cgColor
    }
    
    @inlinable
    var isOpaque: Bool {
        return self.native.kk_isOpaque
    }
    
}

public extension Color {
    
    func with(alpha: Double) -> Color {
        return .init(self.native.withAlphaComponent(CGFloat(alpha)))
    }
    
}

#endif
