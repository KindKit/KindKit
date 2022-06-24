//
//  KindKitView
//

#if os(iOS)

import UIKit

public struct Color : Equatable {
    
    public var native: UIColor
    
    @inlinable
    public init(
        r: Float,
        g: Float,
        b: Float,
        a: Float = 1
    ) {
        self.native = UIColor(
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
        self.native = UIColor(
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
        self.native = UIColor(
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
        self.native = UIColor(
            red: CGFloat((rgba >> 24) & 0xff) / 255.0,
            green: CGFloat((rgba >> 16) & 0xff) / 255.0,
            blue: CGFloat((rgba >> 8) & 0xff) / 255.0,
            alpha: CGFloat(rgba & 0xff) / 255.0
        )
    }
    
    @inlinable
    @available(iOS 11.0, *)
    public init(
        name: String,
        in bundle: Bundle? = nil,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) {
        guard let native = UIColor(named: name, in: bundle, compatibleWith: traitCollection) else {
            fatalError("Not found color with '\(name)'")
        }
        self.native = native
    }
    
    @inlinable
    @available(iOS 13.0, *)
    public init(
        dynamicProvider: @escaping (UITraitCollection) -> Color
    ) {
        self.native = UIColor(dynamicProvider: { return dynamicProvider($0).native })
    }
    
    @inlinable
    public init(_ native: UIColor) {
        self.native = native
    }
    
    @inlinable
    public init(_ cgColor: CGColor) {
        self.init(UIColor(cgColor: cgColor))
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

public extension Color {
    
    func with(alpha: Float) -> Color {
        return Color(self.native.withAlphaComponent(CGFloat(alpha)))
    }
    
}

#endif
