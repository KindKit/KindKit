//
//  KindKit
//

import KindGraphics
import KindStyleSheet
import KindMonadicMacro

@Monadic
public struct TextStyleSheet : StyleSheetTrait, MergeStyleSheetTrait {
    
    @MonadicField
    public let style: Style?
    
    @MonadicField
    public let text: Text?
    
    @MonadicField
    public let numberOfLines: UInt?
    
    @MonadicField
    public let color: Color?
    
    @MonadicField
    public let alpha: Double?
    
    public init(
        style: Style? = nil,
        text: Text? = nil,
        numberOfLines: UInt? = nil,
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.style = style
        self.text = text
        self.numberOfLines = numberOfLines
        self.color = color
        self.alpha = alpha
    }
    
    public func merge(_ other: Self) -> Self {
        return .init(
            style: other.style ?? self.style,
            text: other.text ?? self.text,
            numberOfLines: other.numberOfLines ?? self.numberOfLines,
            color: other.color ?? self.color,
            alpha: other.alpha ?? self.alpha
        )
    }

}
