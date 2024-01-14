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
        self.native = UIColor(
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
        self.native = UIColor(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
    init(
        rgb: UInt32
    ) {
        self.native = UIColor(
            red: CGFloat((rgb >> 16) & 0xff) / 255.0,
            green: CGFloat((rgb >> 8) & 0xff) / 255.0,
            blue: CGFloat(rgb & 0xff) / 255.0,
            alpha: 1
        )
    }
    
    init(
        rgba: UInt32
    ) {
        self.native = UIColor(
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
        guard let native = UIColor(named: name, in: bundle, compatibleWith: traitCollection) else {
            fatalError("Not found color with '\(name)'")
        }
        self.native = native
    }
    
    @available(iOS 13.0, *)
    init(
        dynamicProvider: @escaping (UITraitCollection) -> Color
    ) {
        self.native = UIColor(dynamicProvider: { return dynamicProvider($0).native })
    }
    
    init(_ native: UIColor) {
        self.native = native
    }
    
    init(_ cgColor: CGColor) {
        self.init(UIColor(cgColor: cgColor))
    }
    
}

public extension Color {
    
    @inlinable
    var rgba: Rgba {
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
