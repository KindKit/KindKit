//
//  KindKit
//

import KindGraphics
import KindStyleSheet
import KindMonadicMacro

@Monadic
public struct GradientStyleSheet : StyleSheetTrait, MergeStyleSheetTrait {
    
    @MonadicField
    public let fill: Gradient?
    
    @MonadicField
    public let color: Color?
    
    @MonadicField
    public let alpha: Double?
    
    public init(
        fill: Gradient? = nil,
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.fill = fill
        self.color = color
        self.alpha = alpha
    }
    
    public func merge(_ other: Self) -> Self {
        return .init(
            fill: other.fill ?? self.fill,
            color: other.color ?? self.color,
            alpha: other.alpha ?? self.alpha
        )
    }

}
