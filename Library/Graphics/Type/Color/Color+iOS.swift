//
//  KindKit
//

#if os(iOS)

import UIKit

public extension Color {
    
    init(
        r: Double,
        g: Double,
        b: Double,
        a: Double = 1
    ) {
        self.handle = UIColor(
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
        self.handle = UIColor(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
    init(
        rgb: UInt32
    ) {
        self.handle = UIColor(
            red: CGFloat((rgb >> 16) & 0xff) / 255.0,
            green: CGFloat((rgb >> 8) & 0xff) / 255.0,
            blue: CGFloat(rgb & 0xff) / 255.0,
            alpha: 1
        )
    }
    
    init(
        rgba: UInt32
    ) {
        self.handle = UIColor(
            red: CGFloat((rgba >> 24) & 0xff) / 255.0,
            green: CGFloat((rgba >> 16) & 0xff) / 255.0,
            blue: CGFloat((rgba >> 8) & 0xff) / 255.0,
            alpha: CGFloat(rgba & 0xff) / 255.0
        )
    }
    
    @available(iOS 11.0, *)
    init(
        name: String,
        in bundle: Bundle? = nil,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) {
        guard let handle = UIColor(named: name, in: bundle, compatibleWith: traitCollection) else {
            fatalError("Not found color with '\(name)'")
        }
        self.handle = handle
    }
    
    @available(iOS 13.0, *)
    init(
        dynamicProvider: @escaping (UITraitCollection) -> Color
    ) {
        self.handle = UIColor(dynamicProvider: { return dynamicProvider($0).handle })
    }
    
    init(_ handle: UIColor) {
        self.handle = handle
    }
    
    init(_ cgColor: CGColor) {
        self.init(UIColor(cgColor: cgColor))
    }
    
}

public extension Color {
    
    @inlinable
    var pixel: Pixel {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.handle.getRed(&r, green: &g, blue: &b, alpha: &a)
        return .init(r: r, g: g, b: b, a: a)
    }
    
    @inlinable
    var cgColor: CGColor {
        return self.handle.cgColor
    }
    
    @inlinable
    var isOpaque: Bool {
        return self.handle.kk_isOpaque
    }
    
}

public extension Color {
    
    func with(alpha: Double) -> Color {
        return .init(self.handle.withAlphaComponent(CGFloat(alpha)))
    }
    
}

#endif
