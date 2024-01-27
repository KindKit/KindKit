//
//  KindKit
//

import KindGraphics
import KindStyleSheet
import KindMonadicMacro

@Monadic
public struct RectStyleSheet : StyleSheetTrait, MergeStyleSheetTrait {
    
    @MonadicField
    public let border: Border?
    
    @MonadicField
    public let cornerRadius: CornerRadius?
    
    @MonadicField
    public let fill: Color?
    
    @MonadicField
    public let color: Color?
    
    @MonadicField
    public let alpha: Double?
    
    public init(
        border: Border? = nil,
        cornerRadius: CornerRadius? = nil,
        fill: Color? = nil,
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.border = border
        self.cornerRadius = cornerRadius
        self.fill = fill
        self.color = color
        self.alpha = alpha
    }
    
    public func merge(_ other: Self) -> Self {
        return .init(
            border: other.border ?? self.border,
            cornerRadius: other.cornerRadius ?? self.cornerRadius,
            fill: other.fill ?? self.fill,
            color: other.color ?? self.color,
            alpha: other.alpha ?? self.alpha
        )
    }

}
