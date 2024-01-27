//
//  KindKit
//

import KindGraphics
import KindStyleSheet
import KindMonadicMacro

@Monadic
public struct ColorStyleSheet : StyleSheetTrait, MergeStyleSheetTrait {
    
    @MonadicField
    public let color: Color?
    
    @MonadicField
    public let alpha: Double?
    
    public init(
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.color = color
        self.alpha = alpha
    }
    
    public func merge(_ other: Self) -> Self {
        return .init(
            color: other.color ?? self.color,
            alpha: other.alpha ?? self.alpha
        )
    }

}
