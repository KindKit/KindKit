//
//  KindKit
//

import KindGraphics
import KindStyleSheet
import KindMonadicMacro

@Monadic
public struct MaskStyleSheet : StyleSheetTrait, MergeStyleSheetTrait {
    
    @MonadicField
    public let border: Border?
    
    @MonadicField
    public let cornerRadius: CornerRadius?
    
    @MonadicField
    public let shadow: Shadow?
    
    @MonadicField
    public let color: Color?
    
    @MonadicField
    public let alpha: Double?
    
    public init(
        border: Border? = nil,
        cornerRadius: CornerRadius? = nil,
        shadow: Shadow? = nil,
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.color = color
        self.alpha = alpha
    }
    
    public func merge(_ other: Self) -> Self {
        return .init(
            border: other.border ?? self.border,
            cornerRadius: other.cornerRadius ?? self.cornerRadius,
            shadow: other.shadow ?? self.shadow,
            color: other.color ?? self.color,
            alpha: other.alpha ?? self.alpha
        )
    }

}
