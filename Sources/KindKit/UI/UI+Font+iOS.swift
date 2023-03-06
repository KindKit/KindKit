//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI.Font {
    
    init(
        weight: Weight,
        size: Double = UI.Font.systemSize
    ) {
        self.native = UIFont.systemFont(
            ofSize: CGFloat(size),
            weight: weight.uiFontWeight
        )
    }
    
    init(
        weight: Weight,
        scaled: Double = UI.Font.systemSize,
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
        size: Double = UI.Font.systemSize
    ) {
        self.native = UIFont(
            name: name,
            size: CGFloat(size)
        )!
    }
    
    init(
        name: String,
        scaled: Double = UI.Font.systemSize,
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
        _ native: UIFont
    ) {
        self.native = native
    }
    
}

public extension UI.Font {
    
    static var systemSize: Double {
        return Double(UIFont.systemFontSize)
    }
    
}

public extension UI.Font {
    
    @inlinable
    var lineHeight: Double {
        return Double(self.native.lineHeight)
    }
    
    @inlinable
    func withSize(_ size: Double) -> UI.Font {
        return UI.Font(self.native.withSize(CGFloat(size)))
    }
    
}

#endif
