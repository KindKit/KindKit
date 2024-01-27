//
//  KindKit
//

import KindGraphics
import KindStyleSheet
import KindMonadicMacro

@Monadic
public struct ShapeStyleSheet : StyleSheetTrait, MergeStyleSheetTrait {
    
    @MonadicField
    public let fill: ShapeView.Fill?
    
    @MonadicField
    public let stroke: ShapeView.Stroke?
    
    @MonadicField
    public let line: ShapeView.Line?
    
    @MonadicField
    public let color: Color?
    
    @MonadicField
    public let alpha: Double?
    
    public init(
        fill: ShapeView.Fill? = nil,
        stroke: ShapeView.Stroke? = nil,
        line: ShapeView.Line? = nil,
        color: Color? = nil,
        alpha: Double? = nil
    ) {
        self.fill = fill
        self.stroke = stroke
        self.line = line
        self.color = color
        self.alpha = alpha
    }
    
    public func merge(_ other: Self) -> Self {
        return .init(
            fill: other.fill ?? self.fill,
            stroke: other.stroke ?? self.stroke,
            line: other.line ?? self.line,
            color: other.color ?? self.color,
            alpha: other.alpha ?? self.alpha
        )
    }

}
