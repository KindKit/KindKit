//
//  KindKit
//

#if os(iOS)

import UIKit

public extension Font {
    
    init(
        weight: Weight,
        size: Double = Font.systemSize
    ) {
        self.native = UIFont.systemFont(
            ofSize: CGFloat(size),
            weight: weight.uiFontWeight
        )
    }
    
    init(
        weight: Weight,
        scaled: Double = Font.systemSize,
        lower: Double? = nil,
        upper: Double? = nil
    ) {
        var size = Double(UIFontMetrics.default.scaledValue(for: CGFloat(scaled)))
        if let lower = lower {
            size = max(lower, size)
        }
        if let upper = upper {
            size = min(size, upper)
        }
        self.native = UIFont.systemFont(
            ofSize: CGFloat(size),
            weight: weight.uiFontWeight
        )
    }
    
    init(
        name: String,
        size: Double = Font.systemSize
    ) {
        self.native = UIFont(
            name: name,
            size: CGFloat(size)
        )!
    }
    
    init(
        name: String,
        scaled: Double = Font.systemSize,
        lower: Double? = nil,
        upper: Double? = nil
    ) {
        var size = Double(UIFontMetrics.default.scaledValue(for: CGFloat(scaled)))
        if let lower = lower {
            size = max(lower, size)
        }
        if let upper = upper {
            size = min(size, upper)
        }
        self.native = UIFont(
            name: name,
            size: CGFloat(size)
        )!
    }
    
    init(
        descriptor: UIFontDescriptor,
        size: Double = Font.systemSize
    ) {
        self.native = UIFont(
            descriptor: descriptor,
            size: size
        )
    }
    
    init(
        descriptor: UIFontDescriptor,
        scaled: Double = Font.systemSize,
        lower: Double? = nil,
        upper: Double? = nil
    ) {
        var size = Double(UIFontMetrics.default.scaledValue(for: CGFloat(scaled)))
        if let lower = lower {
            size = max(lower, size)
        }
        if let upper = upper {
            size = min(size, upper)
        }
        self.native = UIFont(
            descriptor: descriptor,
            size: size
        )
    }
    
}

public extension Font {
    
    static var systemSize: Double {
        return Double(UIFont.systemFontSize)
    }
    
}

public extension Font {
    
    @inlinable
    var lineHeight: Double {
        return Double(self.native.lineHeight)
    }
    
    @inlinable
    func withSize(_ size: Double) -> Font {
        return Font(self.native.withSize(CGFloat(size)))
    }
    
}

#endif
