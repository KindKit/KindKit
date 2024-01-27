//
//  KindKit
//

import KindGraphics
import KindStyleSheet
import KindMonadicMacro

@Monadic
public struct ImageStyleSheet : StyleSheetTrait, MergeStyleSheetTrait {
    
    @MonadicField
    public let image: Image?
    
    @MonadicField
    public let mode: ImageMode?
    
    @MonadicField
    public let tintColor: Color?
    
    @MonadicField
    public let color: Color?
    
    @MonadicField
    public let alpha: Double?
    
    public init(
        image: Image? = nil,
        mode: ImageMode? = nil,
        tintColor: Color? = nil,
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.image = image
        self.mode = mode
        self.tintColor = tintColor
        self.color = color
        self.alpha = alpha
    }
    
    public func merge(_ other: Self) -> Self {
        return .init(
            image: other.image ?? self.image,
            mode: other.mode ?? self.mode,
            tintColor: other.tintColor ?? self.tintColor,
            color: other.color ?? self.color,
            alpha: other.alpha ?? self.alpha
        )
    }

}
