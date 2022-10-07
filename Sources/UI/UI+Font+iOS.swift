//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI.Font {
    
    init(
        weight: Weight,
        size: Float = UI.Font.systemSize
    ) {
        self.native = UIFont.systemFont(
            ofSize: CGFloat(size),
            weight: weight.uiFontWeight
        )
    }
    
    init(
        weight: Weight,
        scaled: Float = UI.Font.systemSize,
        lower: Float? = nil,
        upper: Float? = nil
    ) {
        var size = Float(UIFontMetrics.default.scaledValue(for: CGFloat(scaled)))
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
        size: Float = UI.Font.systemSize
    ) {
        self.native = UIFont(
            name: name,
            size: CGFloat(size)
        )!
    }
    
    init(
        name: String,
        scaled: Float = UI.Font.systemSize,
        lower: Float? = nil,
        upper: Float? = nil
    ) {
        var size = Float(UIFontMetrics.default.scaledValue(for: CGFloat(scaled)))
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
        _ native: UIFont
    ) {
        self.native = native
    }
    
}

public extension UI.Font {
    
    static var systemSize: Float {
        return Float(UIFont.systemFontSize)
    }
    
}

public extension UI.Font {
    
    @inlinable
    var lineHeight: Float {
        return Float(self.native.lineHeight)
    }
    
    @inlinable
    func withSize(_ size: Float) -> UI.Font {
        return UI.Font(self.native.withSize(CGFloat(size)))
    }
    
}

#endif
