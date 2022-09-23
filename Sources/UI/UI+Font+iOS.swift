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
        self.native = UIFont.systemFont(ofSize: CGFloat(size), weight: weight.uiFontWeight)
        
    }
    
    init(
        name: String,
        size: Float = Float(UIFont.systemFontSize)
    ) {
        self.native = UIFont(name: name, size: CGFloat(size))!
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
